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

import java.nio.charset.StandardCharsets

import com.github.yingzhuo.datawarehouse.businesssubsys.log.LoggerWrapper
import org.apache.commons.io.IOUtils
import org.springframework.core.io.ClassPathResource
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component

import scala.jdk.CollectionConverters._
import scala.util.Random

@Component
private[robot] class DeviceStartupLoggingRobot extends AnyRef {

  private val DeviceInfoPool = {
    val resource = new ClassPathResource("robot/device-info.txt")
    IOUtils.readLines(resource.getInputStream, StandardCharsets.UTF_8).asScala
  }

  @Scheduled(fixedRate = 2500L)
  def execute(): Unit = {
    val (deviceId, os, brand, model) = randomDeviceInfo()
    LoggerWrapper.deviceStartup(deviceId, os, brand, model)
  }

  private def randomDeviceInfo(): (String, String, String, String) = {
    val parts = DeviceInfoPool(Random.between(0, DeviceInfoPool.size)).split(",")
    (parts(0), parts(1), parts(2), parts(3))
  }

}
