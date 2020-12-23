package com.github.yingzhuo.datawarehouse.businesssubsys.service

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.Cart

trait CartService {

  def findCartByForUser(userId: String): Cart

  def addCommodityForUser(userId: String, commodityId: String, count: Int): Cart

  def emptyCartForUser(userId: String): Cart

}
