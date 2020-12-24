package com.github.yingzhuo.datawarehouse.businesssubsys.controller

import com.github.yingzhuo.carnival.json.Json
import com.github.yingzhuo.datawarehouse.businesssubsys.service.CartService
import org.springframework.web.bind.annotation._

@RestController
@RequestMapping(Array("/cart"))
protected class CartController(cartService: CartService) {

  @DeleteMapping
  def emptyCart(@RequestParam("userId") userId: String): Json = {
    val cart = cartService.emptyCartForUser(userId)

    Json.newInstance()
      .payload("cart", cart)
  }

  @PostMapping(Array("/commodity"))
  def addCommodity(
                    @RequestParam("userId") userId: String,
                    @RequestParam("commodityId") commodityId: String,
                    @RequestParam("count") count: Int
                  ): Json = {

    val cart = cartService.addCommodityForUser(userId, commodityId, count)

    Json.newInstance()
      .payload("cart", cart)
  }

}
