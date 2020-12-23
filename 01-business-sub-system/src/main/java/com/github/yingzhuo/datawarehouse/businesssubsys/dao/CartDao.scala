package com.github.yingzhuo.datawarehouse.businesssubsys.dao

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.Cart
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
trait CartDao extends JpaRepository[Cart, String] {
}
