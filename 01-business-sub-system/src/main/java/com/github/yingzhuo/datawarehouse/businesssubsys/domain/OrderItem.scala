package com.github.yingzhuo.datawarehouse.businesssubsys.domain

import java.util.Date

import javax.persistence._
import org.springframework.data.annotation.{CreatedDate, LastModifiedDate}
import org.springframework.data.jpa.domain.support.AuditingEntityListener

import scala.beans.BeanProperty

/**
 * 订单条目
 */
@Entity
@Table(name = "t_order_item")
@EntityListeners(Array(classOf[AuditingEntityListener]))
class OrderItem extends AnyRef with Serializable {

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
   * 商品ID
   */
  @Column(name = "commodity_id", length = 36)
  @BeanProperty
  var commodityId: String = _

  /**
   * 商品名称
   */
  @Column(name = "commodity_name", length = 100)
  @BeanProperty
  var commodityName: String = _

  /**
   * 商品详细说明
   */
  @Column(name = "commodity_description", length = 2000)
  @BeanProperty
  var commodityDescription: String = _

  /**
   * 商品价格 (分)
   */
  @Column(name = "commodity_price")
  @BeanProperty
  var commodityPrice: Int = _

  /**
   * 折扣
   */
  @Column(name = "commodity_discount")
  @BeanProperty
  var commodityDiscount: Int = _

  /**
   * 最终价格
   */
  @Column(name = "final_price")
  @BeanProperty
  var finalPrice: Int = _

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
  @Column(name = "last_updated_date", columnDefinition = "TIMESTAMP NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp")
  @Temporal(TemporalType.TIMESTAMP)
  @BeanProperty
  var lastUpdateDate: Date = _

}
