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
package com.github.yingzhuo.datawarehouse.businesssubsys.service

import java.util.Date

import com.github.yingzhuo.datawarehouse.businesssubsys.dao.{EvaluationDao, OrderDao, OrderItemDao, OrderStatusTransitionDao}
import com.github.yingzhuo.datawarehouse.businesssubsys.domain.{Evaluation, EvaluationLevel, OrderStatus, OrderStatusTransition}
import com.github.yingzhuo.datawarehouse.businesssubsys.util.ID
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.{Propagation, Transactional}

import scala.jdk.CollectionConverters._

@Service
protected class EvaluationServiceImpl(evaluationDao: EvaluationDao,
                                      orderDao: OrderDao,
                                      orderItemDao: OrderItemDao,
                                      transitionDao: OrderStatusTransitionDao
                                     ) extends AnyRef with EvaluationService {

  @Transactional(propagation = Propagation.REQUIRED)
  override def evaluate(userId: String, orderId: String, level: EvaluationLevel, text: String): Unit = {

    val exists = evaluationDao.findByUserIdAndOrderId(userId, orderId)
    if (exists != null) {
      return
    }

    val order = orderDao.findById(orderId).orElse(null)
    if (order != null) {
      order.evaluatedDate = new Date()
      order.status = OrderStatus.已评价
      orderDao.save(order)
    }

    val t = OrderStatusTransition(orderId, OrderStatus.已评价)
    transitionDao.save(t)

    for (orderItem <- orderItemDao.findByOrderId(orderId).asScala) {
      val ev = new Evaluation
      ev.id = ID()
      ev.userId = userId
      ev.level = level
      ev.text = text
      ev.orderId = orderId
      ev.commodityId = orderItem.commodityId
      evaluationDao.saveAndFlush(ev)
    }

  }

}
