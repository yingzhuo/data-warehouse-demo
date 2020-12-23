package com.github.yingzhuo.datawarehouse.businesssubsys.domain

import java.util.Date

import javax.persistence._
import org.springframework.data.annotation.{CreatedDate, LastModifiedDate}
import org.springframework.data.jpa.domain.support.AuditingEntityListener

import scala.beans.BeanProperty

/**
 * 订单
 */
@Entity
@Table(name = "t_order")
@EntityListeners(Array(classOf[AuditingEntityListener]))
class Order extends AnyRef with Serializable {

  /**
   * ID
   */
  @Id
  @Column(name = "id", length = 36)
  @BeanProperty
  var id: String = _

  /**
   * 用户ID
   */
  @Column(name = "user_id", length = 36)
  @BeanProperty
  var userId: String = _

  /**
   * 状态
   */
  @Column(name = "status", length = 10)
  @Enumerated(EnumType.STRING)
  @BeanProperty
  var status: OrderStatus = _

  /**
   * 总计金额
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
