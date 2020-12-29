package com.github.yingzhuo.datawarehouse.businesssubsys.domain

import java.util.Date

import javax.persistence._
import org.springframework.data.annotation.CreatedDate
import org.springframework.data.jpa.domain.support.AuditingEntityListener

import scala.beans.BeanProperty

/**
 * 省份
 */
@Entity
@Table(name = "t_province")
@EntityListeners(Array(classOf[AuditingEntityListener]))
class Province extends AnyRef with Serializable {

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
  @Column(name = "name", length = 10)
  @BeanProperty
  var name: String = _

  /**
   * 简称
   */
  @Column(name = "short_name", length = 10)
  @BeanProperty
  var shortName: String = _

  /**
   * 所属区域
   */
  @Column(name = "region", length = 10)
  @BeanProperty
  var region: String = _

  /**
   * 记录创建时间
   */
  @CreatedDate
  @Column(name = "created_date", columnDefinition = "TIMESTAMP NOT NULL DEFAULT current_timestamp")
  @Temporal(TemporalType.TIMESTAMP)
  @BeanProperty
  var createdDate: Date = _

}
