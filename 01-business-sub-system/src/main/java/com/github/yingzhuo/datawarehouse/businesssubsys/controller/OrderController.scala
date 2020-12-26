package com.github.yingzhuo.datawarehouse.businesssubsys.controller

import com.github.yingzhuo.carnival.json.Json
import com.github.yingzhuo.datawarehouse.businesssubsys.service.OrderService
import org.springframework.web.bind.annotation.{PostMapping, RequestMapping, RequestParam, RestController}

@RestController
@RequestMapping(Array("/order"))
protected class OrderController(orderService: OrderService) {

  @PostMapping
  def createOrder(@RequestParam("userId") userId: String): Json = {
    val order = orderService.createOrderFromCart(userId)
    Json.newInstance()
      .payload("order", order)
  }

}
