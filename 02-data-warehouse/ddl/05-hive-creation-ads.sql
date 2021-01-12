--======================================================================================================================
-- 数据仓库ADS层
-- DB type      : hive 3.1.2
-- DB           : data_warehouse_demo
-- author       : 应卓
--======================================================================================================================
set mapreduce.job.queuename=hive;
use data_warehouse_demo;

---
-- 活跃设备数
---
drop table if exists ads_uv_count;
create external table ads_uv_count
(
    `dt`          string comment '统计日期',
    `day_count`   bigint comment '当日用户数量',
    `wk_count`    bigint comment '当周用户数量',
    `mn_count`    bigint comment '当月用户数量',
    `is_weekend`  string comment '是否为周末 Y/N',
    `is_monthend` string comment '是否为月末 Y/N'
)
    row format
        delimited fields terminated by '\t'
    location '/hive/data-warehouse-demo/ads/ads_uv_count';
