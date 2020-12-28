package com.github.yingzhuo.datawarehouse.businesssubsys.controller

import com.github.yingzhuo.carnival.json.Json
import com.github.yingzhuo.datawarehouse.businesssubsys.service.FavoriteInfoService
import org.springframework.web.bind.annotation._

@RestController
@RequestMapping(Array("/favor"))
protected class FavoriteController(favorService: FavoriteInfoService) {

  @PostMapping
  def addToList(@RequestParam("userId") userId: String,
                @RequestParam("commodityId") commodityId: String): Json = {

    val favoriteInfo = favorService.addToFavoriteList(userId, commodityId)
    Json.newInstance()
      .payload("favoriteInfo", favoriteInfo)
  }

  @DeleteMapping
  def removeFromList(@RequestParam("userId") userId: String,
                     @RequestParam("commodityId") commodityId: String): Json = {

    favorService.removeFromFavoriteList(userId, commodityId)
    Json.newInstance()
  }

}
