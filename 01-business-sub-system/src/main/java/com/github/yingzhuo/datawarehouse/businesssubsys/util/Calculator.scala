package com.github.yingzhuo.datawarehouse.businesssubsys.util

import java.util

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.{CartItem, OrderItem}

import scala.jdk.CollectionConverters._

object Calculator {

  def computeFinalPrice(price: Int, discount: Int): Int = {
    if (discount >= 100) {
      price
    }
    else {
      price * 100 / discount
    }
  }

  def computeTotalAmountForCart(items: util.List[CartItem]): Long = {
    if (items == null || items.isEmpty) {
      return 0L
    }

    var sum = 0L
    for (item <- items.asScala) {
      sum += (item.finalPrice * item.count)
    }
    sum
  }

  def computeTotalAmountForOrder(items: util.List[OrderItem]): Long = {
    if (items == null || items.isEmpty) {
      return 0L
    }

    var sum = 0L
    for (item <- items.asScala) {
      sum += (item.finalPrice * item.count)
    }
    sum
  }

}
