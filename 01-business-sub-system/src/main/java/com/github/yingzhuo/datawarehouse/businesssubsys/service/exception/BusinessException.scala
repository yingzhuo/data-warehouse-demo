package com.github.yingzhuo.datawarehouse.businesssubsys.service.exception

class BusinessException private(msg: String) extends RuntimeException(msg)

object BusinessException {
  def apply(message: String): BusinessException = new BusinessException(message)
}
