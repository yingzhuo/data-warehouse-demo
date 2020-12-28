package com.github.yingzhuo.datawarehouse.businesssubsys.dao;

import com.github.yingzhuo.datawarehouse.businesssubsys.domain.FavoriteInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FavoriteInfoDao extends JpaRepository<FavoriteInfo, String> {

    public FavoriteInfo findByUserIdAndCommodityId(String userId, String commodityId);

}
