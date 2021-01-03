package com.github.yingzhuo.datawarehouse.businesssubsys.robot

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.OrderStatus
import com.github.yingzhuo.datawarehouse.businesssubsys.service.{EvaluationService, OrderService}
import javax.persistence.EntityManager
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component

@Component
private[robot] class OrderUpdatingRobot(em: EntityManager,
                                        orderService: OrderService,
                                        evaluationService: EvaluationService) extends AbstractRobot(em) {

  // 每13分钟变更一个订单的状态
  @Scheduled(fixedRate = 780000L)
  def update(): Unit = {

    val order = super.pickupOrder()

    if (order == null) return

    order.status match {
      case OrderStatus.已取消 => // NOP
      case OrderStatus.已评价 => // NOP
      case OrderStatus.未支付 =>
        orderService.payOrder(order.userId, order.id)
      case OrderStatus.已支付 =>
        orderService.deliverOrder(order.userId, order.id)
      case OrderStatus.配送中 =>
        orderService.takeOrder(order.userId, order.id)
      case OrderStatus.待评价 =>
        val (level, text) = super.pickupEvaluationLevel()
        evaluationService.evaluate(
          order.userId,
          order.id,
          level,
          text
        )
    }
  }

}
