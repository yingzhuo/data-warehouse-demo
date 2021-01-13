--======================================================================================================================
-- 数据仓库DWT层
-- DB type      : hive 3.1.2
-- DB           : data_warehouse_demo
-- author       : 应卓
--======================================================================================================================
set mapreduce.job.queuename=hive;
use data_warehouse_demo;

---
-- 设备主题宽表
---
drop table if exists dwt_uv_topic;
create external table dwt_uv_topic
(
    `device_id`        string comment '设备ID',
    `login_date_first` string comment '首次活跃时间',
    `login_date_last`  string comment '末次活跃时间',
    `login_count`      bigint comment '累计活跃天数'
)
    comment '设备主题宽表'
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dwt/dwt_uv_topic'
    tblproperties ('parquet.compression' = 'lzo');

---
-- 用户主题宽表
---
drop table if exists dwt_user_topic;
create external table dwt_user_topic
(
    `user_id`                 string comment '用户ID',
    `login_date_first`        string comment '首次登录日期',
    `login_date_last`         string comment '末次登录日期',
    `login_count`             bigint comment '累计登录次数',
    `login_last_7d_count`     bigint comment '最近7日内登录天数',
    `login_last_30d_count`    bigint comment '最近30天内登录天数',
    `order_date_first`        string comment '首次下单时间',
    `order_date_last`         string comment '末次下单时间',
    `order_count`             bigint comment '累计下单次数',
    `order_last_7d_count`     bigint comment '最近7日内下单次数',
    `order_last_30d_count`    bigint comment '最近30日内下单次数',
    `payment_date_first`      string comment '首次支付时间',
    `payment_date_last`       string comment '末次支付时间',
    `payment_count`           bigint comment '累计支付次数',
    `payment_amount`          decimal(16, 2) comment '累计支付金额',
    `payment_last_7d_count`   bigint comment '最近7日内支付次数',
    `payment_last_30d_count`  bigint comment '最近30日内支付次数',
    `payment_last_7d_amount`  decimal(16, 2) comment '最近7日内支付金额',
    `payment_last_30d_amount` decimal(16, 2) comment '最近30日内支付金额'
)
    comment '用户主题宽表'
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dwt/dwt_user_topic'
    tblproperties ('parquet.compression' = 'lzo');
