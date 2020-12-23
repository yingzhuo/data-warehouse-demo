package com.github.yingzhuo.datawarehouse.businesssubsys.controller

import com.github.yingzhuo.carnival.json.Json
import com.github.yingzhuo.datawarehouse.businesssubsys.service.UserService
import org.springframework.web.bind.annotation.{PostMapping, RequestParam, RestController}

@RestController
protected class SecurityController(
                                    userService: UserService
                                  ) {

  @PostMapping(Array("/login"))
  def login(
             @RequestParam("username") username: String,
             @RequestParam("password") password: String
           ): Json = {

    val success = userService.login(username, password)

    Json.newInstance()
      .payload("success", success)
  }

  @PostMapping(Array("/logout"))
  def logout(
              @RequestParam("username") username: String
            ): Json = {

    userService.logout(username)
    Json.newInstance()
  }

}
