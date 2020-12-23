package com.github.yingzhuo.datawarehouse.businesssubsys.log

import org.slf4j.LoggerFactory

object UserBehavior {

  private val LoggerLogin = LoggerFactory.getLogger("user.behavior.login")

  def login(userId: String, result: String): Unit = {
    __checkUserId(userId)
    LoggerLogin.info("{},{}", userId, result)
  }

  private def __checkUserId(id: String): Unit = id match {
    case null => throw new IllegalArgumentException("用户ID非法: 不可为空")
    case x if x.isEmpty => throw new IllegalArgumentException("用户ID非法: 不可为空")
    case _ =>
  }

}
