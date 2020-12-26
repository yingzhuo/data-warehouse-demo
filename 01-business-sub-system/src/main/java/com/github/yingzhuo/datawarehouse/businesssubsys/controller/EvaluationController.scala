package com.github.yingzhuo.datawarehouse.businesssubsys.controller

import com.github.yingzhuo.carnival.json.Json
import com.github.yingzhuo.datawarehouse.businesssubsys.domain.EvaluationLevel
import com.github.yingzhuo.datawarehouse.businesssubsys.service.EvaluationService
import org.springframework.web.bind.annotation.{RequestMapping, RequestParam, RestController}

@RestController
protected class EvaluationController(evaluationService: EvaluationService) {

  @RequestMapping(Array("/evaluation"))
  def evaluate(
                @RequestParam("userId") userId: String,
                @RequestParam("orderId") orderId: String,
                @RequestParam("level") level: EvaluationLevel,
                @RequestParam("text") text: String
              ): Json = {

    val ev = evaluationService.evaluate(userId, orderId, level, text)
    Json.newInstance()
      .payload("evaluation", ev)
  }

}
