package com.github.yingzhuo.datawarehouse.businesssubsys.util

import java.util.UUID

object ID {
  def apply(): String = UUID.randomUUID().toString.replaceAll("-", "")
}
