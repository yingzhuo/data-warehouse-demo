package com.github.yingzhuo.datawarehouse.businesssubsys.dao;

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.OrderStatusTransition;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderStatusTransitionDao extends JpaRepository<OrderStatusTransition, String> {
}
