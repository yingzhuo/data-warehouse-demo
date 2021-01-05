--======================================================================================================================
-- 数据仓库ODS层
-- DB type      : hive 3.1.2
-- DB           : data_warehouse_demo
-- author       : 应卓
--======================================================================================================================
set mapreduce.job.queuename=hive;

use data_warehouse_demo;

---
-- 用户登录行为日志
---
drop table if exists dwd_login_log;
create external table dwd_login_log
(
    `user_id` string comment '用户ID',
    `result`  string comment '登录结果'
)
    comment '登录日志数据'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dwd/dwd_login_log'
    tblproperties ('parquet.compression' = 'lzo');

---
-- 商品维度表
---
drop table if exists dwd_dim_commodity_db;
create external table dwd_dim_commodity_db
(
    `id`                string comment 'ID',
    `name`              string comment '商品名称',
    `price`             int comment '价格(分)',
    `discount`          int comment '折扣',
    `description`       string comment '描述',
    `trade_marker_id`   string comment '品牌ID',
    `trade_marker_name` string comment '品牌名称',
    `category_1_id`     string comment '商品一级分类ID',
    `category_1_name`   string comment '商品一级分类名称',
    `category_2_id`     string comment '商品二级分类ID',
    `category_2_name`   string comment '商品二级分类名称',
    `category_3_id`     string comment '商品三级分类ID',
    `category_3_name`   string comment '商品三级分类名称',
    `created_date`      string comment '记录创建时间',
    `last_updated_date` string comment '记录最后更新时间'
)
    comment '商品纬度表'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dwd/dwd_dim_commodity_db'
    tblproperties ('parquet.compression' = 'lzo');
