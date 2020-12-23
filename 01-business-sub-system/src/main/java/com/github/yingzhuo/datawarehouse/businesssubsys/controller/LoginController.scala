package com.github.yingzhuo.datawarehouse.businesssubsys.controller

import com.github.yingzhuo.carnival.json.Json
import com.github.yingzhuo.datawarehouse.businesssubsys.service.UserService
import org.springframework.web.bind.annotation.{PostMapping, RequestMapping, RequestParam, RestController}

@RestController
@RequestMapping(Array("/login"))
protected class LoginController(
                                 userService: UserService
                               ) {

  @PostMapping
  def login(
             @RequestParam("username") username: String,
             @RequestParam("password") password: String
           ): Json = {

    val success = userService.login(username, password)

    Json.newInstance()
      .payload("success", success)
  }

}
