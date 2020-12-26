package com.github.yingzhuo.datawarehouse.businesssubsys.service

import com.github.yingzhuo.datawarehouse.businesssubsys.dao.{CartDao, CartItemDao, CommodityDao}
import com.github.yingzhuo.datawarehouse.businesssubsys.domain.{Cart, CartItem}
import com.github.yingzhuo.datawarehouse.businesssubsys.util.{Calculator, ID}
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.{Propagation, Transactional}

@Service
protected class CartServiceImpl(
                                 cartDao: CartDao,
                                 cartItemDao: CartItemDao,
                                 commodityDao: CommodityDao
                               ) extends AnyRef with CartService {

  private val log = LoggerFactory.getLogger(classOf[CartServiceImpl])

  @Transactional(propagation = Propagation.REQUIRED)
  override def addCommodityForUser(userId: String, commodityId: String, count: Int): Cart = {

    val newCount = if (count <= 0) 0 else count;

    if (newCount == 0) {
      return deleteItem(userId, commodityId)
    }

    // 商品
    val comm = commodityDao.findById(commodityId).orElse(null)
    if (comm == null) {
      throw new IllegalArgumentException(s"非法的商品ID: $commodityId")
    } else {
      log.trace("找到商品")
    }

    var cartItem = cartItemDao.findByUserIdAndCommodityId(userId, commodityId)

    // 新条目
    if (cartItem == null) {
      log.trace("购物车新条目")
      cartItem = new CartItem()
      cartItem.id = ID()
    }

    cartItem.userId = userId
    cartItem.count = count
    cartItem.commodityId = comm.id
    cartItem.commodityName = comm.name
    cartItem.commodityPrice = comm.price
    cartItem.commodityDiscount = comm.discount
    cartItem.commodityDescription = comm.description
    cartItem.finalPrice = Calculator.computeFinalPrice(comm.price, comm.discount)

    if (cartItem.count <= 0) {
      cartItemDao.deleteById(cartItem.id)
    } else {
      cartItemDao.saveAndFlush(cartItem)
    }

    val items = cartItemDao.findByUserId(userId)

    // 更新购物车总数量
    val cart = findCartByForUser(userId)
    cart.totalCount = items.size
    cart.totalAmount = Calculator.computeTotalAmount(items)
    cartDao.saveAndFlush(cart)
    findCartByForUser(userId)
  }

  @Transactional(propagation = Propagation.REQUIRED)
  override def deleteItem(userId: String, commodityId: String): Cart = {
    log.trace("删除条目")
    val cartItem = cartItemDao.findByUserIdAndCommodityId(userId, commodityId)
    if (cartItem != null) {
      cartItemDao.delete(cartItem)
    }

    // 更新购物车总数量
    val items = cartItemDao.findByUserId(userId)
    val cart = findCartByForUser(userId)
    cart.totalCount = items.size
    cart.totalAmount = Calculator.computeTotalAmount(items)
    cartDao.saveAndFlush(cart)
    findCartByForUser(userId)
  }

  @Transactional(propagation = Propagation.REQUIRED)
  override def findCartByForUser(userId: String): Cart = createCartIfNecessary(userId)

  private def createCartIfNecessary(userId: String): Cart = {

    log.trace("userId={}", userId)

    val cart = cartDao.findByUserId(userId)
    if (cart != null) {
      log.trace("已经有购物车实体了")
      return cart
    }

    log.trace("创建购物车实体")
    val newCart = new Cart()
    newCart.userId = userId
    newCart.totalCount = 0
    newCart.totalAmount = 0L
    cartDao.saveAndFlush(newCart)
    newCart
  }

  @Transactional(propagation = Propagation.REQUIRED)
  override def emptyCartForUser(userId: String): Cart = {
    val cart = findCartByForUser(userId)
    cart.setTotalCount(0)
    cart.setTotalAmount(0L)
    cartDao.save(cart)

    val items = cartItemDao.findByUserId(userId)
    if (items != null && !items.isEmpty) {
      cartItemDao.deleteAll(items)
    }
    cart
  }

}
