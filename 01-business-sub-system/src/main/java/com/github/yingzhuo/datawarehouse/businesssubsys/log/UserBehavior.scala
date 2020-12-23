package com.github.yingzhuo.datawarehouse.businesssubsys.log

import org.slf4j.LoggerFactory

object UserBehavior {

  private val LoggerLogin = LoggerFactory.getLogger("UB_LOGIN")
  private val LoggerLogout = LoggerFactory.getLogger("UB_LOGOUT")

  /**
   * 登录行为
   *
   * @param userId 用户ID
   * @param result "OK" | "NG"
   */
  def login(userId: String, result: String): Unit = {
    __checkUserId(userId)
    LoggerLogin.info("{},{}", userId, result)
  }

  /**
   * 登出行为
   *
   * @param userId 用户ID
   * @param result "OK" | "NG"
   */
  def logout(userId: String, result: String = "OK"): Unit = {
    __checkUserId(userId)
    LoggerLogout.info("{},{}", userId, result)
  }

  // ------------------------------------------------------------------------------------------------------------------

  private def __checkUserId(id: String): Unit = id match {
    case null => throw new IllegalArgumentException("用户ID非法: 不可为空")
    case x if x.isEmpty => throw new IllegalArgumentException("用户ID非法: 不可为空")
    case _ =>
  }

}
