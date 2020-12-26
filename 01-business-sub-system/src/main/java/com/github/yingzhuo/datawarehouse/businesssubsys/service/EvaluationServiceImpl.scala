package com.github.yingzhuo.datawarehouse.businesssubsys.service

import com.github.yingzhuo.datawarehouse.businesssubsys.dao.EvaluationDao
import com.github.yingzhuo.datawarehouse.businesssubsys.domain.{Evaluation, EvaluationLevel}
import com.github.yingzhuo.datawarehouse.businesssubsys.log.UserBehavior
import com.github.yingzhuo.datawarehouse.businesssubsys.util.ID
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.{Propagation, Transactional}

@Service
protected class EvaluationServiceImpl(evaluationDao: EvaluationDao) extends AnyRef with EvaluationService {

  @Transactional(propagation = Propagation.REQUIRED)
  override def evaluate(userId: String, orderId: String, level: EvaluationLevel, text: String): Evaluation = {

    val exists = evaluationDao.findByUserIdAndOrderId(userId, orderId)
    if (exists != null) {
      return exists
    }

    UserBehavior.evaluate(userId, orderId, level, text)
    val ev = new Evaluation
    ev.id = ID()
    ev.userId = userId
    ev.level = level
    ev.text = text
    ev.orderId = orderId
    evaluationDao.saveAndFlush(ev)
  }

}
