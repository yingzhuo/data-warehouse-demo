package com.github.yingzhuo.datawarehouse.businesssubsys.dao

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.Order
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
trait OrderDao extends JpaRepository[Order, String] {
}
