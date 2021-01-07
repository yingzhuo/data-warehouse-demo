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
package com.github.yingzhuo.datawarehouse.businesssubsys.robot

import com.github.yingzhuo.datawarehouse.businesssubsys.service.UserService
import javax.persistence.EntityManager
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component

import scala.collection.mutable.ListBuffer
import scala.util.Random

@Component
private[robot] class UserLoginPasswordChangingRobot(em: EntityManager, userService: UserService) extends AbstractRobot(em) {

  private val passwordPool: List[String] = {
    val pool = new ListBuffer[String]()
    pool += "000000"
    pool += "111111"
    pool += "222222"
    pool += "333333"
    pool += "444444"
    pool += "555555"
    pool += "666666"
    pool += "777777"
    pool += "888888"
    pool += "999999"
    pool.toList
  }

  // 每16小时一个随机用户修改一次密码
  @Scheduled(fixedRate = 57600000)
  def execute(): Unit = {
    val user = super.pickupUser()
    val username = user.username
    val oldPwd = user.loginPassword
    val newPwd = passwordPool(Random.between(0, passwordPool.size))
    userService.changePwd(username, oldPwd, newPwd)
  }

}
