package com.github.yingzhuo.datawarehouse.businesssubsys.dao;

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.PaymentInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PaymentInfoDao extends JpaRepository<PaymentInfo, String> {
}
