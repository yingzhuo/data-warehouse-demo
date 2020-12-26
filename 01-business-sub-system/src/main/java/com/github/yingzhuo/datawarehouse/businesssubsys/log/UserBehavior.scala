package com.github.yingzhuo.datawarehouse.businesssubsys.log

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.EvaluationLevel
import org.slf4j.LoggerFactory

object UserBehavior {

  private val LoggerLogin = LoggerFactory.getLogger("UB_LOGIN")
  private val LoggerLogout = LoggerFactory.getLogger("UB_LOGOUT")
  private val LoggerEvaluate = LoggerFactory.getLogger("UB_EVALUATE")

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

  private def __checkUserId(id: String): Unit = id match {
    case null => throw new IllegalArgumentException("用户ID非法: 不可为空")
    case x if x.isEmpty => throw new IllegalArgumentException("用户ID非法: 不可为空")
    case _ =>
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

  /**
   * 订单评价行为
   *
   * @param userId  用户ID
   * @param orderId 订单行为
   * @param level   评价登记
   * @param text    评价文字
   */
  def evaluate(userId: String, orderId: String, level: EvaluationLevel, text: String): Unit = {
    __checkUserId(userId)
    LoggerEvaluate.info("{},{},{},{},{}", userId, orderId, level, text, if (text == null) 0 else text.length)
  }

}
