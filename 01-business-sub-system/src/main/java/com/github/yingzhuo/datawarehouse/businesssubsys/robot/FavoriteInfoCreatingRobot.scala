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
package com.github.yingzhuo.datawarehouse.businesssubsys.robot

import com.github.yingzhuo.datawarehouse.businesssubsys.service.FavoriteInfoService
import javax.persistence.EntityManager
import org.springframework.context.annotation.Profile
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component

@Component
@Profile(Array("!norobot"))
private[robot] class FavoriteInfoCreatingRobot(em: EntityManager,
                                               favoriteInfoService: FavoriteInfoService) extends AbstractRobot(em) {

  // 每13分钟变更一个订单的状态
  @Scheduled(fixedRate = 1800000L)
  def execute(): Unit = {
    val user = pickupUser()
    val commodity = pickupCommodity()
    favoriteInfoService.addToFavoriteList(user.id, commodity.id)
  }

}
