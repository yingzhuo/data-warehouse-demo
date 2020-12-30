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
package com.github.yingzhuo.datawarehouse.businesssubsys.util

import java.util

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.support.Item

import scala.jdk.CollectionConverters._

object Calculator {

  def computeFinalPrice(price: Int, discount: Int): Int = {
    if (discount >= 100) {
      price
    }
    else {
      price * 100 / discount
    }
  }

  def computeTotalAmount[T <: Item](items: util.List[T]): Long = {
    if (items == null || items.isEmpty) {
      return 0L
    }

    var sum = 0L
    for (item <- items.asScala) {
      sum += (item.finalPrice * item.count)
    }
    sum
  }

}
