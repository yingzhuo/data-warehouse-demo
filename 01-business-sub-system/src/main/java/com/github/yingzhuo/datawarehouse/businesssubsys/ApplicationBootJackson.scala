package com.github.yingzhuo.datawarehouse.businesssubsys

import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.scala.DefaultScalaModule
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Configuration

@Configuration
protected class ApplicationBootJackson {

  @Autowired(required = false)
  def configObjectMapper(om: ObjectMapper): Unit = {
    Option(om).foreach(_.registerModule(DefaultScalaModule))
  }

}
