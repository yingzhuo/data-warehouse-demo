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
package com.github.yingzhuo.datawarehouse.businesssubsys.service

import com.github.yingzhuo.datawarehouse.businesssubsys.dao.{PwdChangedDao, UserDao}
import com.github.yingzhuo.datawarehouse.businesssubsys.domain.PwdChanged
import com.github.yingzhuo.datawarehouse.businesssubsys.log.UserBehavior
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.{Propagation, Transactional}

@Service
protected class UserServiceImpl(userDao: UserDao, pwdChangedDao: PwdChangedDao) extends AnyRef with UserService {

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

    if (user == null) return false

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

  @Transactional(propagation = Propagation.SUPPORTS)
  override def logout(username: String): Boolean = {
    if (username == null || username.isEmpty) {
      return false
    }

    val user = userDao.findByUsername(username)
    if (user != null) {
      true
    } else {
      false
    }
  }

  @Transactional(propagation = Propagation.SUPPORTS)
  override def changePwd(username: String, oldPassword: String, newPassword: String): Boolean = {
    if (username == null || username.isEmpty) {
      return false
    }

    val user = userDao.findByUsername(username)
    if (user == null) return false

    if (user.loginPassword != oldPassword) return false

    user.loginPassword = newPassword
    userDao.saveAndFlush(user)

    pwdChangedDao.save(PwdChanged(user.id, newPassword))
    true
  }

}
