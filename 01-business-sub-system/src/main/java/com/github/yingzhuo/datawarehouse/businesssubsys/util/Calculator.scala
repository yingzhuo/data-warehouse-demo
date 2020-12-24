package com.github.yingzhuo.datawarehouse.businesssubsys.util

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.CartItem

object Calculator {

  def computeFinalPrice(price: Int, discount: Int): Int = {
    if (discount >= 100) {
      price
    }
    else {
      price * 100 / discount
    }
  }

  def computeTotalAmount(cartItems: java.util.List[CartItem]): Long = {

    import scala.jdk.CollectionConverters._

    if (cartItems == null || cartItems.isEmpty) {
      return 0L
    }

    var sum = 0L
    for (item <- cartItems.asScala) {
      sum += (item.finalPrice * item.count)
    }
    sum
  }

}
