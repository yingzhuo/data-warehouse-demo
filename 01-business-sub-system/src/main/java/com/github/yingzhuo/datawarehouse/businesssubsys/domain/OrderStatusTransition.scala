package com.github.yingzhuo.datawarehouse.businesssubsys.domain

import java.util.Date

import com.github.yingzhuo.datawarehouse.businesssubsys.util.ID
import javax.persistence._
import org.springframework.data.annotation.CreatedDate

import scala.beans.BeanProperty

/**
 * 订单状态迁移
 */
@Entity
@Table(name = "t_order_status_transition")
class OrderStatusTransition extends AnyRef with Serializable {

  /**
   * ID
   */
  @Id
  @Column(name = "id", length = 36)
  @BeanProperty
  var id: String = _

  /**
   * 订单ID
   */
  @Column(name = "order_id", length = 36)
  @BeanProperty
  var orderId: String = _

  /**
   * 状态
   */
  @Column(name = "status", length = 10)
  @Enumerated(EnumType.STRING)
  @BeanProperty
  var status: OrderStatus = _

  /**
   * 记录创建时间
   */
  @CreatedDate
  @Column(name = "created_date", columnDefinition = "TIMESTAMP NOT NULL DEFAULT current_timestamp")
  @Temporal(TemporalType.TIMESTAMP)
  @BeanProperty
  var createdDate: Date = _

}

object OrderStatusTransition {

  def apply(orderId: String, status: OrderStatus): OrderStatusTransition = {
    val transition = new OrderStatusTransition
    transition.id = ID()
    transition.orderId = orderId
    transition.status = status
    transition
  }

}