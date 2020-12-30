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
package com.github.yingzhuo.datawarehouse.businesssubsys.domain

import java.util.Date

import javax.persistence._
import org.springframework.data.annotation.{CreatedDate, LastModifiedDate}
import org.springframework.data.jpa.domain.support.AuditingEntityListener

import scala.beans.BeanProperty

/**
 * 用户
 */
@Entity
@Table(name = "t_user")
@EntityListeners(Array(classOf[AuditingEntityListener]))
class User extends AnyRef with Serializable {

  /**
   * ID
   */
  @Id
  @Column(name = "id", length = 36)
  @BeanProperty
  var id: String = _

  /**
   * 用户名 (登录用)
   */
  @Column(name = "username", length = 30)
  @BeanProperty
  var username: String = _

  /**
   * 姓名
   */
  @Column(name = "name", length = 20)
  @BeanProperty
  var name: String = _

  /**
   * 性别
   */
  @Enumerated(EnumType.STRING)
  @Column(name = "gender", length = 8)
  @BeanProperty
  var gender: Gender = _

  /**
   * 电话号码
   */
  @Column(name = "phone_number", length = 20)
  @BeanProperty
  var phoneNumber: String = _

  /**
   * 电子邮件地址
   */
  @Column(name = "email_addr", length = 100)
  @BeanProperty
  var emailAddress: String = _

  /**
   * 头像地址
   */
  @Column(name = "avatar_url", length = 200)
  @BeanProperty
  var avatarUrl: String = _

  /**
   * 登录密码
   */
  @Column(name = "login_password", length = 32)
  @BeanProperty
  var loginPassword: String = _

  /**
   * 记录创建时间
   */
  @CreatedDate
  @Column(name = "created_date", columnDefinition = "TIMESTAMP NOT NULL DEFAULT current_timestamp")
  @Temporal(TemporalType.TIMESTAMP)
  @BeanProperty
  var createdDate: Date = _

  /**
   * 记录最后更新时间
   */
  @LastModifiedDate
  @Column(name = "last_updated_date", columnDefinition = "TIMESTAMP NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp")
  @Temporal(TemporalType.TIMESTAMP)
  @BeanProperty
  var lastUpdateDate: Date = _

}
