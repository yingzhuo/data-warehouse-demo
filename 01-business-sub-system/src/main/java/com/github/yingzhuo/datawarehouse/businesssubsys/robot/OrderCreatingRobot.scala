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

  @Scheduled(fixedRate = 30000L)
  def create(): Unit = {
    val user = super.pickupUser();
    val commodity = super.pickupCommodity()
    val province = super.pickupProvince()

    cartService.emptyCartForUser(user.id)
    cartService.addCommodityForUser(user.id, commodity.id, Random.between(1, 4))
    orderService.createOrderFromCart(user.id, province.id)
  }

}
