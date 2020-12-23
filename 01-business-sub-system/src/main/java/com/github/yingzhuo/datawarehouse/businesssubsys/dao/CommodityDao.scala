package com.github.yingzhuo.datawarehouse.businesssubsys.dao

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.Commodity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
trait CommodityDao extends JpaRepository[Commodity, String] {
}
