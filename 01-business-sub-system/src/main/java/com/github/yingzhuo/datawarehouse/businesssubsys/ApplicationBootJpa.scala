package com.github.yingzhuo.datawarehouse.businesssubsys

import javax.persistence.EntityManagerFactory
import org.springframework.boot.autoconfigure.domain.EntityScan
import org.springframework.context.annotation.{Bean, Configuration}
import org.springframework.data.jpa.repository.config.{EnableJpaAuditing, EnableJpaRepositories}
import org.springframework.orm.jpa.JpaTransactionManager
import org.springframework.transaction.annotation.EnableTransactionManagement

@Configuration
@EnableJpaAuditing
@EnableJpaRepositories(basePackages = Array("com.github.yingzhuo.datawarehouse.businesssubsys"))
@EntityScan(basePackages = Array("com.github.yingzhuo.datawarehouse.businesssubsys"))
@EnableTransactionManagement
protected class ApplicationBootJpa {

  @Bean
  protected def transactionManager(entityManagerFactory: EntityManagerFactory) = new JpaTransactionManager(entityManagerFactory)

}
