package com.github.yingzhuo.datawarehouse.businesssubsys.service

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.FavoriteInfo

trait FavoriteInfoService {

  def addToFavoriteList(userId: String, commodityId: String): FavoriteInfo

  def removeFromFavoriteList(userId: String, commodityId: String): Unit

}
