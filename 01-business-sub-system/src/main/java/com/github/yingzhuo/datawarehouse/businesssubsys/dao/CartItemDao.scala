package com.github.yingzhuo.datawarehouse.businesssubsys.dao

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.CartItem
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
trait CartItemDao extends JpaRepository[CartItem, String] {
}
