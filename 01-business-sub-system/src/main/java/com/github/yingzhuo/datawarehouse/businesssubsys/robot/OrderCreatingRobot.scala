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

import com.github.yingzhuo.datawarehouse.businesssubsys.service.{CartService, OrderService}
import javax.persistence.EntityManager
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component

import scala.util.Random

@Component
private[robot] class OrderCreatingRobot(em: EntityManager,
                                        cartService: CartService,
                                        orderService: OrderService
                                       ) extends AbstractRobot(em) {

  // 每25分钟产生一个新订单
  @Scheduled(fixedRate = 1500000L)
  def create(): Unit = {
    val user = super.pickupUser();
    val commodity = super.pickupCommodity()
    val province = super.pickupProvince()

    cartService.emptyCartForUser(user.id)
    cartService.addCommodityForUser(user.id, commodity.id, Random.between(1, 4))
    orderService.createOrderFromCart(user.id, province.id)
  }

}
