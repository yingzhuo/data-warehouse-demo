package com.github.yingzhuo.datawarehouse.businesssubsys.robot

import com.github.yingzhuo.datawarehouse.businesssubsys.dao.UserDao
import com.github.yingzhuo.datawarehouse.businesssubsys.log.UserBehavior
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component

import scala.util.Random

@Component
protected class LoginRobot(userDao: UserDao) {

  @Scheduled(fixedRate = 1000L)
  def execute(): Unit = {

    val ids = userDao.findAllIds()

    val id = ids.get(Random.nextInt(10000) % ids.size())
    UserBehavior.login(id, "OK")
  }

}
