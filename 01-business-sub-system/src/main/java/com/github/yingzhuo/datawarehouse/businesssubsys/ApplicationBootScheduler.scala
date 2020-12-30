package com.github.yingzhuo.datawarehouse.businesssubsys

import org.springframework.context.annotation.{Bean, Configuration}
import org.springframework.scheduling.annotation.EnableScheduling
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler

@Configuration
@EnableScheduling
protected class ApplicationBootScheduler {

  @Bean
  def threadPoolTaskScheduler(): ThreadPoolTaskScheduler = {
    val bean = new ThreadPoolTaskScheduler
    bean.setPoolSize(10)
    bean.setThreadNamePrefix("data-warehouse-demo-thread-")
    bean
  }

}
