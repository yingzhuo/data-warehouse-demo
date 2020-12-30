/*
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  ____        _         __        __             _                            ____
 * |  _ \  __ _| |_ __ _  \ \      / /_ _ _ __ ___| |__   ___  _   _ ___  ___  |  _ \  ___ _ __ ___   ___
 * | | | |/ _` | __/ _` |  \ \ /\ / / _` | '__/ _ \ '_ \ / _ \| | | / __|/ _ \ | | | |/ _ \ '_ ` _ \ / _ \
 * | |_| | (_| | || (_| |   \ V  V / (_| | | |  __/ | | | (_) | |_| \__ \  __/ | |_| |  __/ | | | | | (_) |
 * |____/ \__,_|\__\__,_|    \_/\_/ \__,_|_|  \___|_| |_|\___/ \__,_|___/\___| |____/ \___|_| |_| |_|\___/
 *
 * https://github.com/yingzhuo/data-warehouse-demo
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 */
package com.github.yingzhuo.datawarehouse.businesssubsys.service

import java.util
import java.util.Date

import com.github.yingzhuo.datawarehouse.businesssubsys.dao._
import com.github.yingzhuo.datawarehouse.businesssubsys.domain._
import com.github.yingzhuo.datawarehouse.businesssubsys.service.exception.BusinessException
import com.github.yingzhuo.datawarehouse.businesssubsys.util.{Calculator, ID}
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.{Propagation, Transactional}

import scala.jdk.CollectionConverters._

@Service
protected class OrderServiceImpl(cartDao: CartDao,
                                 cartItemDao: CartItemDao,
                                 orderDao: OrderDao,
                                 orderItemDao: OrderItemDao,
                                 paymentInfoDao: PaymentInfoDao,
                                 transitionDao: OrderStatusTransitionDao
                                ) extends AnyRef with OrderService {

  @Transactional(propagation = Propagation.REQUIRED)
  override def createOrderFromCart(userId: String, provinceId: String): Order = {

    val cartItemList = cartItemDao.findByUserId(userId)
    if (cartItemList == null || cartItemList.isEmpty) {
      throw BusinessException("购物车是空的")
    }

    val orderId = ID()
    val orderItemList = transform(cartItemList, orderId)

    val order = new Order
    order.id = orderId
    order.userId = userId
    order.status = OrderStatus.未支付
    order.totalAmount = Calculator.computeTotalAmount(orderItemList)
    order.provinceId = provinceId

    val savedOrder = orderDao.saveAndFlush(order)

    for (item <- orderItemList.asScala) {
      orderItemDao.save(item)
    }

    // 清空购物车
    val cart = cartDao.findByUserId(userId)
    cart.setTotalCount(0)
    cart.setTotalAmount(0L)
    cartDao.save(cart)
    cartItemDao.deleteAll(cartItemList)

    val transition = OrderStatusTransition(orderId, OrderStatus.未支付)
    transitionDao.save(transition)

    savedOrder
  }

  private def transform(cartItemList: util.List[CartItem], orderId: String): util.List[OrderItem] = {
    val list = new util.ArrayList[OrderItem](cartItemList.size())

    for (cartItem <- cartItemList.asScala) {
      val orderItem = new OrderItem
      orderItem.id = ID()
      orderItem.orderId = orderId
      orderItem.commodityId = cartItem.commodityId
      orderItem.commodityPrice = cartItem.commodityPrice
      orderItem.commodityDiscount = cartItem.commodityDiscount
      orderItem.commodityName = cartItem.commodityName
      orderItem.commodityDescription = cartItem.commodityDescription
      orderItem.count = cartItem.count
      orderItem.finalPrice = cartItem.finalPrice
      orderItem.userId = cartItem.userId
      list.add(orderItem)
    }
    list
  }

  @Transactional(propagation = Propagation.REQUIRED)
  override def payOrder(userId: String, orderId: String): Order = {
    val order = orderDao.findById(orderId).orElse(null)

    if (order == null) return null

    order.status = OrderStatus.已支付
    order.payedDate = new Date()

    val pay = new PaymentInfo()
    pay.id = ID()
    pay.userId = userId
    pay.orderId = orderId
    pay.totalAmount = order.totalAmount
    paymentInfoDao.save(pay)

    val transition = OrderStatusTransition(orderId, OrderStatus.已支付)
    transitionDao.save(transition)

    orderDao.saveAndFlush(order)
  }

  @Transactional(propagation = Propagation.REQUIRED)
  override def cancelOrder(userId: String, orderId: String): Order = {
    val order = orderDao.findById(orderId).orElse(null)

    if (order == null) return null

    val transition = OrderStatusTransition(orderId, OrderStatus.已取消)
    transitionDao.save(transition)

    order.status = OrderStatus.已取消
    order.canceledDate = new Date()
    orderDao.saveAndFlush(order)
  }

  @Transactional(propagation = Propagation.REQUIRED)
  override def deliverOrder(userId: String, orderId: String): Order = {
    val order = orderDao.findById(orderId).orElse(null)

    if (order == null) return null

    val transition = OrderStatusTransition(orderId, OrderStatus.配送中)
    transitionDao.save(transition)

    order.status = OrderStatus.配送中
    order.deliveredDate = new Date()
    orderDao.saveAndFlush(order)
  }

  @Transactional(propagation = Propagation.REQUIRED)
  override def takeOrder(userId: String, orderId: String): Order = {
    val order = orderDao.findById(orderId).orElse(null)

    if (order == null) return null

    val transition = OrderStatusTransition(orderId, OrderStatus.待评价)
    transitionDao.save(transition)

    order.status = OrderStatus.待评价
    order.takedDate = new Date()
    orderDao.saveAndFlush(order)
  }

}
