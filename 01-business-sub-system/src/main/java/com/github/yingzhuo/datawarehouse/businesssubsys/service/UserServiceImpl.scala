package com.github.yingzhuo.datawarehouse.businesssubsys.service

import com.github.yingzhuo.datawarehouse.businesssubsys.dao.UserDao
import com.github.yingzhuo.datawarehouse.businesssubsys.log.UserBehavior
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.{Propagation, Transactional}

@Service
protected class UserServiceImpl(userDao: UserDao) extends AnyRef with UserService {

  private val logger = LoggerFactory.getLogger(getClass)

  @Transactional(propagation = Propagation.SUPPORTS)
  override def login(username: String, password: String): Boolean = {

    if (username == null || username.isEmpty) {
      return false
    }

    if (password == null || password.isEmpty) {
      return false
    }

    val user = userDao.findByUsername(username)

    password match {
      case x if x == user.getLoginPassword =>
        logger.debug("登录成功: userId={}, username={}", user.id, user.username)
        UserBehavior.login(user.id, "OK")
        true
      case _ =>
        logger.debug("登录失败: userId={}, username={} | 密码错误", user.id, user.username)
        UserBehavior.login(user.id, "NG")
        false
    }
  }

}
