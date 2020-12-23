package com.github.yingzhuo.datawarehouse.businesssubsys.dao

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.User
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
trait UserDao extends JpaRepository[User, Long] {
}
