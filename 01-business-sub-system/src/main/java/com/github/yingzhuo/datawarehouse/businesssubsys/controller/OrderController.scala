package com.github.yingzhuo.datawarehouse.businesssubsys.controller

import com.github.yingzhuo.carnival.json.Json
import com.github.yingzhuo.datawarehouse.businesssubsys.service.OrderService
import org.springframework.web.bind.annotation.{PostMapping, RequestMapping, RequestParam, RestController}

@RestController
@RequestMapping(Array("/order"))
protected class OrderController(orderService: OrderService) {

  @PostMapping
  def createOrder(@RequestParam("userId") userId: String,
                  @RequestParam(name = "provinceId", required = false, defaultValue = "14") provinceId: String): Json = {
    val order = orderService.createOrderFromCart(userId, provinceId)
    Json.newInstance()
      .payload("order", order)
  }

  @PostMapping(Array("/pay"))
  def payOrder(
                @RequestParam("userId") userId: String,
                @RequestParam("orderId") orderId: String
              ): Json = {
    val order = orderService.payOrder(userId, orderId)
    Json.newInstance()
      .payload("order", order)
  }

  @PostMapping(Array("/cancel"))
  def cancelOrder(
                   @RequestParam("userId") userId: String,
                   @RequestParam("orderId") orderId: String
                 ): Json = {
    val order = orderService.cancelOrder(userId, orderId)
    Json.newInstance()
      .payload("order", order)
  }

  @PostMapping(Array("/deliver"))
  def deliverOrder(
                    @RequestParam("userId") userId: String,
                    @RequestParam("orderId") orderId: String
                  ): Json = {
    val order = orderService.deliverOrder(userId, orderId)
    Json.newInstance()
      .payload("order", order)
  }

  @PostMapping(Array("/take"))
  def takeOrder(
                 @RequestParam("userId") userId: String,
                 @RequestParam("orderId") orderId: String
               ): Json = {
    val order = orderService.takeOrder(userId, orderId)
    Json.newInstance()
      .payload("order", order)
  }

}
