package com.github.yingzhuo.datawarehouse.businesssubsys.service

import java.util

import com.github.yingzhuo.datawarehouse.businesssubsys.dao.{CartDao, CartItemDao, OrderDao, OrderItemDao}
import com.github.yingzhuo.datawarehouse.businesssubsys.domain.{CartItem, Order, OrderItem, OrderStatus}
import com.github.yingzhuo.datawarehouse.businesssubsys.service.exception.BusinessException
import com.github.yingzhuo.datawarehouse.businesssubsys.util.{Calculator, ID}
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.{Propagation, Transactional}

import scala.jdk.CollectionConverters._

@Service
protected class OrderServiceImpl(
                                  cartDao: CartDao,
                                  cartItemDao: CartItemDao,
                                  orderDao: OrderDao,
                                  orderItemDao: OrderItemDao
                                ) extends AnyRef with OrderService {

  @Transactional(propagation = Propagation.REQUIRED)
  override def createOrderFromCart(userId: String): Order = {

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

    val savedOrder = orderDao.save(order)

    for (item <- orderItemList.asScala) {
      orderItemDao.save(item)
    }

    // TODO: 清空购物车
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
      list.add(orderItem)
    }
    list
  }

}
