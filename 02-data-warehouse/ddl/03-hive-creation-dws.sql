--======================================================================================================================
-- 数据仓库DWS层
-- DB type      : hive 3.1.2
-- DB           : data_warehouse_demo
-- author       : 应卓
--======================================================================================================================
set mapreduce.job.queuename=hive;
use data_warehouse_demo;

---
-- 每日设备行为汇总
---
drop table if exists dws_device_startup_daycount;
create external table dws_device_startup_daycount
(
    device_id string comment '设备ID',
    user_id   string comment '用户ID',
    os_type   string comment '操作系统类型',
    brand     string comment '品牌',
    model     string comment '设备型号'
)
    comment '每日设备行为汇总'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dws/dws_device_startup_daycount'
    tblproperties ('parquet.compression' = 'lzo');

---
-- 每日用户行为汇总
---
drop table if exists dws_user_action_daycount;
create external table dws_user_action_daycount
(
    `user_id`            string comment '用户ID',
    `login_count`        bigint comment '登录次数',
    `cart_count`         bigint comment '加购次数',
    `order_count`        bigint comment '下单次数',
    `payment_count`      bigint comment '支付次数',
    `payment_amount`     bigint comment '支付金额 (分)',
    `evaluation_count_1` bigint comment '好评次数',
    `evaluation_count_2` bigint comment '中评次数',
    `evaluation_count_3` bigint comment '差评次数',
    `favorite_count`     bigint comment '收藏次数'
)
    comment '每日用户行为汇总'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dws/dws_user_action_daycount'
    tblproperties ('parquet.compression' = 'lzo');
