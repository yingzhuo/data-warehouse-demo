package com.github.yingzhuo.datawarehouse.businesssubsys.domain

import java.util.Date

import javax.persistence._
import org.springframework.data.annotation.{CreatedDate, LastModifiedDate}
import org.springframework.data.jpa.domain.support.AuditingEntityListener

import scala.beans.BeanProperty

/**
 * 商品
 */
@Entity
@Table(name = "t_commodity")
@EntityListeners(Array(classOf[AuditingEntityListener]))
class Commodity extends AnyRef with Serializable {

  /**
   * ID
   */
  @Id
  @Column(name = "id", length = 36)
  @BeanProperty
  var id: String = _

  /**
   * 名称
   */
  @Column(name = "name", length = 100)
  @BeanProperty
  var name: String = _

  /**
   * 详细说明
   */
  @Column(name = "description", length = 2000)
  @BeanProperty
  var description: String = _

  /**
   * 价格 (分)
   */
  @Column(name = "price")
  @BeanProperty
  var price: Int = _

  /**
   * 折扣
   */
  @Column(name = "discount")
  @BeanProperty
  var discount: Int = 100

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
