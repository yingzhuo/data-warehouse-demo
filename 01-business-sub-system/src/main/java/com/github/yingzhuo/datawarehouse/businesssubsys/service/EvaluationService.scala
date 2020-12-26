package com.github.yingzhuo.datawarehouse.businesssubsys.service

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.{Evaluation, EvaluationLevel}

trait EvaluationService {

  def evaluate(userId: String, orderId: String, level: EvaluationLevel, text: String): Evaluation

}
