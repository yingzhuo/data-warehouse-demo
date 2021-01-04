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
package com.github.yingzhuo.datawarehouse.businesssubsys.robot

import com.github.yingzhuo.datawarehouse.businesssubsys.domain._
import javax.persistence.EntityManager

import scala.util.Random

private[robot] abstract class AbstractRobot(private val em: EntityManager) {

  /**
   * 随机挑选一个省份
   */
  protected def pickupProvince(): Province = {
    val count: Long = em.createQuery("select count(id) from Province", classOf[java.lang.Long])
      .getSingleResult

    val num = Random.nextInt(count.asInstanceOf[Int])

    em.createQuery(
      "from Province",
      classOf[Province])
      .setFirstResult(num)
      .setMaxResults(1)
      .getSingleResult
  }

  /**
   * 随机挑选一个用户
   */
  protected def pickupUser(): User = {
    val count: Long = em.createQuery("select count(id) from User", classOf[java.lang.Long])
      .getSingleResult

    val num = Random.nextInt(count.asInstanceOf[Int])

    em.createQuery(
      "from User",
      classOf[User])
      .setFirstResult(num)
      .setMaxResults(1)
      .getSingleResult
  }

  /**
   * 随机挑选一个商品
   */
  protected def pickupCommodity(): Commodity = {
    val count: Long = em.createQuery("select count(id) from Commodity", classOf[java.lang.Long])
      .getSingleResult

    val num = Random.nextInt(count.asInstanceOf[Int])

    em.createQuery(
      "from Commodity",
      classOf[Commodity])
      .setFirstResult(num)
      .setMaxResults(1)
      .getSingleResult
  }

  /**
   * 随机挑选一个订单 (排除已评价状态)
   */
  protected def pickupOrder(): Order = {
    val count: Long = em.createQuery("select count(id) from Order as o where o.status <> '已评价' ", classOf[java.lang.Long])
      .getSingleResult

    if (count == 0) return null

    val num = Random.nextInt(count.asInstanceOf[Int])

    em.createQuery(
      "from Order as o where o.status <> '已评价'",
      classOf[Order])
      .setFirstResult(num)
      .setMaxResults(1)
      .getSingleResult
  }

  /**
   * 随机评价级别
   */
  protected def pickupEvaluationLevel(): (EvaluationLevel, String) = {
    val n = Random.between(1, 101)

    n match {
      case _ if n <= 85 => (EvaluationLevel.好评, "机器人默认评价 (好评)")
      case _ if (n > 85 && n <= 95) => (EvaluationLevel.中评, "机器人默认评价 (中评)")
      case _ => (EvaluationLevel.差评, "机器人默认评价 (差评)")
    }
  }

}
