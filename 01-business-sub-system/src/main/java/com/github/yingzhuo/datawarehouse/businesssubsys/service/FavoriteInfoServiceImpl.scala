package com.github.yingzhuo.datawarehouse.businesssubsys.service

import com.github.yingzhuo.datawarehouse.businesssubsys.dao.FavoriteInfoDao
import com.github.yingzhuo.datawarehouse.businesssubsys.domain.FavoriteInfo
import com.github.yingzhuo.datawarehouse.businesssubsys.util.ID
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.{Propagation, Transactional}

@Service
protected class FavoriteInfoServiceImpl(favorDao: FavoriteInfoDao) extends AnyRef with FavoriteInfoService {

  @Transactional(propagation = Propagation.REQUIRED)
  override def addToFavoriteList(userId: String, commodityId: String): FavoriteInfo = {
    var f = favorDao.findByUserIdAndCommodityId(userId, commodityId)
    if (f != null) {
      return f
    }

    f = new FavoriteInfo()
    f.id = ID()
    f.userId = userId
    f.commodityId = commodityId
    favorDao.saveAndFlush(f)
  }

  @Transactional(propagation = Propagation.REQUIRED)
  override def removeFromFavoriteList(userId: String, commodityId: String): Unit = {
    val f = favorDao.findByUserIdAndCommodityId(userId, commodityId)
    if (f != null) {
      favorDao.delete(f)
    }
  }

}
