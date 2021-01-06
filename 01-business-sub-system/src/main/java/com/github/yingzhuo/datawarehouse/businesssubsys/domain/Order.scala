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

import com.github.yingzhuo.datawarehouse.businesssubsys.datawarehouse.{DataWarehouse, Policy}
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
@DataWarehouse(policy = Policy.NEW_UPDATED)
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
   * 省份ID (买家)
   */
  @Column(name = "province_id", length = 36)
  @BeanProperty
  var provinceId: String = _

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

  /**
   * 支付时间
   */
  @Column(name = "payed_date")
  @Temporal(TemporalType.TIMESTAMP)
  @BeanProperty
  var payedDate: Date = _

  /**
   * 取消时间
   */
  @Column(name = "canceled_date")
  @Temporal(TemporalType.TIMESTAMP)
  @BeanProperty
  var canceledDate: Date = _

  /**
   * 开始配送时间
   */
  @Column(name = "delivered_date")
  @Temporal(TemporalType.TIMESTAMP)
  @BeanProperty
  var deliveredDate: Date = _

  /**
   * 收货时间
   */
  @Column(name = "taked_date")
  @Temporal(TemporalType.TIMESTAMP)
  @BeanProperty
  var takedDate: Date = _

  /**
   * 评价时间
   */
  @Column(name = "evaluated_date")
  @Temporal(TemporalType.TIMESTAMP)
  @BeanProperty
  var evaluatedDate: Date = _

}
