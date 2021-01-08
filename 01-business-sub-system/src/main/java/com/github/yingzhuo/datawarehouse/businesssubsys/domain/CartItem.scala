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
import com.github.yingzhuo.datawarehouse.businesssubsys.domain.support.Item
import javax.persistence._
import org.springframework.data.annotation.{CreatedDate, LastModifiedDate}
import org.springframework.data.jpa.domain.support.AuditingEntityListener

import scala.beans.BeanProperty

/**
 * 购物车条目
 */
@Entity
@Table(name = "t_cart_item")
@EntityListeners(Array(classOf[AuditingEntityListener]))
@DataWarehouse(policy = Policy.ALL)
class CartItem extends AnyRef with Serializable with Item {

  /**
   * ID
   */
  @Id
  @Column(name = "id", length = 36)
  @BeanProperty
  var id: String = _

  /**
   * 所属用户ID
   */
  @Column(name = "user_id", length = 36)
  @BeanProperty
  var userId: String = _

  /**
   * 商品件数
   */
  @Column(name = "count")
  @BeanProperty
  var count: Int = _

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
   * 折后价格
   */
  @Column(name = "final_price")
  @BeanProperty
  var finalPrice: Int = _

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

object CartItem {
}
