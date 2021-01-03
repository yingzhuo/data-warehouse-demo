package com.github.yingzhuo.datawarehouse.businesssubsys.robot

import com.github.yingzhuo.datawarehouse.businesssubsys.log.UserBehavior
import javax.persistence.EntityManager
import org.slf4j.LoggerFactory
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component

@Component
private[robot] class LoginRobot(em: EntityManager) extends AbstractRobot(em) {

  private val log = LoggerFactory.getLogger(classOf[LoginRobot])

  // 每6分钟生成一条登录日志
  @Scheduled(fixedRate = 360000L)
  def execute(): Unit = {
    val user = pickupUser()
    log.debug("pickup user| id={}, username={}", user.id, user.username)
    UserBehavior.login(user.id, "OK")
  }

}
