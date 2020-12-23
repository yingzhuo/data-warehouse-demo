package com.github.yingzhuo.datawarehouse.businesssubsys.domain

import java.util.Date

import javax.persistence._
import org.springframework.data.annotation.{CreatedDate, LastModifiedDate}
import org.springframework.data.jpa.domain.support.AuditingEntityListener

import scala.beans.BeanProperty

/**
 * 购物车
 */
@Entity
@Table(name = "t_cart")
@EntityListeners(Array(classOf[AuditingEntityListener]))
class Cart extends AnyRef with Serializable {

  /**
   * 用户ID
   */
  @Id
  @Column(name = "user_id", length = 36)
  @BeanProperty
  var userId: String = _

  /**
   * 商品类型总数 (size)
   */
  @Column(name = "total_count")
  @BeanProperty
  var totalCount: Int = _

  /**
   * 商品总金额 (分)
   */
  @Column(name = "total_amount")
  @BeanProperty
  var totalAmount: Long = _

  /**
   * 记录创建时间
   */
  @CreatedDate
  @Column(name = "created_date", columnDefinition = "TIMESTAMP NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp")
  @Temporal(TemporalType.TIMESTAMP)
  @BeanProperty
  var createdDate: Date = _

  /**
   * 记录最后更新时间
   */
  @LastModifiedDate
  @Column(name = "last_update_date", columnDefinition = "TIMESTAMP NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp")
  @Temporal(TemporalType.TIMESTAMP)
  @BeanProperty
  var lastUpdateDate: Date = _

}
