package com.github.yingzhuo.datawarehouse.businesssubsys.service

import com.github.yingzhuo.datawarehouse.businesssubsys.dao.{CartDao, CartItemDao, CommodityDao}
import com.github.yingzhuo.datawarehouse.businesssubsys.domain.{Cart, CartItem}
import com.github.yingzhuo.datawarehouse.businesssubsys.util.{Calculator, ID}
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.{Propagation, Transactional}

import scala.jdk.CollectionConverters._

@Service
protected class CartServiceImpl(
                                 cartDao: CartDao,
                                 cartItemDao: CartItemDao,
                                 commodityDao: CommodityDao
                               ) extends AnyRef with CartService {

  @Transactional(propagation = Propagation.REQUIRED)
  override def findCartByForUser(userId: String): Cart = createCartIfNecessary(userId)

  @Transactional(propagation = Propagation.REQUIRED)
  override def addCommodityForUser(userId: String, commodityId: String, count: Int): Cart = {

    // 商品
    val comm = commodityDao.findById(commodityId).orElse(null)
    if (comm == null) {
      throw new IllegalArgumentException(s"非法的商品ID: $commodityId")
    }

    val cart = this.findCartByForUser(userId)

    var cartItem = cartItemDao.findByUserIdAndCommodityId(userId, commodityId)

    // 新条目
    if (cartItem == null) {
      cartItem = new CartItem()
    }

    cartItem.id = ID()
    cartItem.userId = userId
    cartItem.count = count
    cartItem.commodityId = comm.id
    cartItem.commodityName = comm.name
    cartItem.commodityPrice = comm.price
    cartItem.commodityDiscount = comm.discount
    cartItem.commodityDescription = comm.description
    cartItem.finalPrice = Calculator.computeFinalPrice(comm.price, comm.discount)
    cartItemDao.saveAndFlush(cartItem)
    val items = cartItemDao.findByUserId(userId)

    // 更新购物车总数量
    cart.totalCount = items.size
    cart.totalAmount = Calculator.computeTotalAmount(items)
    cartDao.saveAndFlush(cart)
    cart
  }

  @Transactional(propagation = Propagation.REQUIRED)
  override def emptyCartForUser(userId: String): Cart = {
    val cart = findCartByForUser(userId)
    cart.setTotalCount(0)
    cart.setTotalAmount(0L)
    cartDao.save(cart)

    val items = cartItemDao.findByUserId(userId)
    cartItemDao.deleteAll(items.asJava)
    cart
  }

  private def createCartIfNecessary(userId: String): Cart = {

    val cart = cartDao.findByUserId(userId)
    if (cart != null) {
      return cart
    }

    val newCart = new Cart()
    newCart.userId = ID()
    newCart.totalCount = 0
    newCart.totalAmount = 0L
    cartDao.saveAndFlush(cart)
    newCart
  }

}
