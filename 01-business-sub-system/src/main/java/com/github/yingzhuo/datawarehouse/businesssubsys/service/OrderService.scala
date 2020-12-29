package com.github.yingzhuo.datawarehouse.businesssubsys.service

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.Order

trait OrderService {

  def createOrderFromCart(userId: String, provinceId: String): Order

  def payOrder(userId: String, orderId: String): Order

  def cancelOrder(userId: String, orderId: String): Order

  def deliverOrder(userId: String, orderId: String): Order

  def takeOrder(userId: String, orderId: String): Order

}
