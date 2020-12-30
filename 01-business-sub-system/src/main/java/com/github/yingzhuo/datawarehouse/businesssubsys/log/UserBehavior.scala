/*
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  ____        _         __        __             _                            ____
 * |  _ \  __ _| |_ __ _  \ \      / /_ _ _ __ ___| |__   ___  _   _ ___  ___  |  _ \  ___ _ __ ___   ___
 * | | | |/ _` | __/ _` |  \ \ /\ / / _` | '__/ _ \ '_ \ / _ \| | | / __|/ _ \ | | | |/ _ \ '_ ` _ \ / _ \
 * | |_| | (_| | || (_| |   \ V  V / (_| | | |  __/ | | | (_) | |_| \__ \  __/ | |_| |  __/ | | | | | (_) |
 * |____/ \__,_|\__\__,_|    \_/\_/ \__,_|_|  \___|_| |_|\___/ \__,_|___/\___| |____/ \___|_| |_| |_|\___/
 *
 * https://github.com/yingzhuo/data-warehouse-demo
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 */
package com.github.yingzhuo.datawarehouse.businesssubsys.log

import org.slf4j.LoggerFactory

object UserBehavior {

  private val LoggerLogin = LoggerFactory.getLogger("UB_LOGIN")

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

}
