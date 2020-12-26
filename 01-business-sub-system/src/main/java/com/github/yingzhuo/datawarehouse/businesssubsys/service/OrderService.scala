package com.github.yingzhuo.datawarehouse.businesssubsys.service

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.Order

trait OrderService {

  def createOrderFromCart(userId: String): Order

}
