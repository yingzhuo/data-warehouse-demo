package com.github.yingzhuo.datawarehouse.businesssubsys.domain

import java.util.Date

import javax.persistence._
import org.springframework.data.annotation.{CreatedDate, LastModifiedDate}
import org.springframework.data.jpa.domain.support.AuditingEntityListener

import scala.beans.BeanProperty

@Entity
@Table(name = "t_evaluation")
@EntityListeners(Array(classOf[AuditingEntityListener]))
class Evaluation extends AnyRef with Serializable {

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
   * 订单ID
   */
  @Column(name = "order_id", length = 36)
  @BeanProperty
  var orderId: String = _

  /**
   * 评价等级
   */
  @Column(name = "level", length = 10)
  @Enumerated(EnumType.STRING)
  @BeanProperty
  var level: EvaluationLevel = _

  /**
   * 评价文本
   */
  @Column(name = "text", length = 200)
  @BeanProperty
  var text: String = _

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
