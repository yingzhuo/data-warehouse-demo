--======================================================================================================================
-- 数据仓库ODS层
-- DB           : data_warehouse_demo
-- author       : 应卓
--======================================================================================================================
set mapreduce.job.queuename=hive;

use data_warehouse_demo;

---
-- 用户登录行为日志
---
drop table if exists ods_login_log;

create external table ods_login_log
(
    `user_id` string comment '用户ID',
    `result`  string comment '登录结果'
)
    comment '登录日志原始数据'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as
        inputformat 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
        outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
    location '/hive/data-warehouse-demo/ods/ods_login_log';

---
-- 省份
---
drop table if exists ods_province_db;

create external table ods_province_db
(
    `id`             string comment 'ID',
    `name`           string comment '名称',
    `short_name`     string comment '简称',
    `region`         string comment '所属地区',
    `created_date`   string comment '记录创建时间'
)
    comment '省份信息'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as
        inputformat 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
        outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
    location '/hive/data-warehouse-demo/ods/ods_province_db';

---
-- 用户表
---
drop table if exists ods_user_db;

create external table ods_user_db
(
    `id`                string comment 'ID',
    `name`              string comment '姓名',
    `username`          string comment '用户名',
    `phone_number`      string comment '电话号码',
    `avatar_url`        string comment '头像地址',
    `email_addr`        string comment '电子邮件地址',
    `gender`            string comment '性别',
    `login_password`    string comment '登录密码',
    `created_date`      string comment '记录创建时间',
    `last_updated_date` string comment '记录最后更新时间'
)
    comment '用户信息'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as
        inputformat 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
        outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
    location '/hive/data-warehouse-demo/ods/ods_user_db';

---
-- 收藏信息
---
drop table if exists ods_favor_info_db;

create external table ods_favor_info_db
(
    `id`                string comment 'ID',
    `user_id`           string comment '用户ID',
    `commodity_id`      string comment '商品ID',
    `created_date`      string comment '记录创建时间',
    `last_updated_date` string comment '记录最后更新时间'
)
    comment '收藏信息'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as
        inputformat 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
        outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
    location '/hive/data-warehouse-demo/ods/ods_favor_info_db';

---
-- 商品信息
---
drop table if exists ods_commodity_db;

create external table ods_commodity_db
(
    `id`                string comment 'ID',
    `name`              string comment '商品名称',
    `price`             int comment '价格(分)',
    `discount`          int comment '折扣',
    `description`       string comment '描述',
    `created_date`      string comment '记录创建时间',
    `last_updated_date` string comment '记录最后更新时间'
)
    comment '商品信息'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as
        inputformat 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
        outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
    location '/hive/data-warehouse-demo/ods/ods_commodity_db';

---
-- 支付信息
---
drop table if exists ods_payment_info_db;

create external table ods_payment_info_db
(
    `id`                string comment 'ID',
    `user_id`           string comment '用户ID',
    `order_id`          string comment '订单ID',
    `total_amount`      bigint comment '总计金额',
    `created_date`      string comment '记录创建时间',
    `last_updated_date` string comment '记录最后更新时间'
)
    comment '支付信息'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as
        inputformat 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
        outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
    location '/hive/data-warehouse-demo/ods/ods_payment_info_db';

---
-- 订单状态变迁
---
drop table if exists ods_order_status_transition_db;

create external table ods_order_status_transition_db
(
    `id`           string comment 'ID',
    `order_id`     string comment '订单ID',
    `status`       string comment '变迁后的状态',
    `created_date` string comment '记录创建时间'
)
    comment '支付信息'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as
        inputformat 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
        outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
    location '/hive/data-warehouse-demo/ods/ods_order_status_transition_db';

---
-- 评价
---
drop table if exists ods_evaluation_db;

create external table ods_evaluation_db
(
    `id`           string comment 'ID',
    `user_id`      string comment '用户ID',
    `order_id`     string comment '订单ID',
    `level`        string comment '评价级别',
    `text`         string comment '评价信息',
    `created_date` string comment '记录创建时间'
)
    comment '评价信息'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as
        inputformat 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
        outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
    location '/hive/data-warehouse-demo/ods/ods_evaluation_db';

---
-- 购物车
---
drop database if exists ods_cart_db;

create external table ods_cart_db
(
    `user_id`           string comment '用户ID',
    `total_amount`      bigint comment '订单ID',
    `total_count`       int comment '数量',
    `created_date`      string comment '记录创建时间',
    `last_updated_date` string comment '记录最后更新时间'
)
    comment '购物车信息'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as
        inputformat 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
        outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
    location '/hive/data-warehouse-demo/ods/ods_cart_db';

---
-- 购物车详情
---
drop database if exists ods_cart_item_db;

create external table ods_cart_item_db
(
    `id`                    string comment 'id',
    `commodity_id`          string comment '商品ID',
    `commodity_name`        string comment '商品名称',
    `commodity_price`       int comment '商品价格',
    `commodity_discount`    int comment '商品折扣',
    `commodity_description` string comment '商品描述',
    `count`                 int comment '数量',
    `final_price`           int comment '折后价格',
    `user_id`               string comment '用户ID',
    `created_date`          string comment '记录创建时间',
    `last_updated_date`     string comment '记录最后更新时间'
)
    comment '购物车详情信息'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as
        inputformat 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
        outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
    location '/hive/data-warehouse-demo/ods/ods_cart_item_db';

---
-- 订单
---
drop database if exists ods_order_db;

create external table ods_order_db
(
    `id`                string comment 'id',
    `user_id`           string comment '用户ID',
    `status`            string comment '订单状态',
    `total_amount`      bigint comment '订单总价格',
    `province_id`       string comment '身份ID',
    `canceled_date`     string comment '订单取消时间',
    `delivered_date`    string comment '订单发货时间',
    `evaluated_date`    string comment '订单评价时间',
    `payed_date`        string comment '订单支付时间',
    `taked_date`        string comment '订单收货时间',
    `created_date`      string comment '记录创建时间',
    `last_updated_date` string comment '记录最后更新时间'
)
    comment '订单信息'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as
        inputformat 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
        outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
    location '/hive/data-warehouse-demo/ods/ods_order_db';

---
-- 订单详情
---
drop database if exists ods_order_item_db;

create external table ods_order_item_db
(
    `id`                    string comment 'id',
    `order_id`              string comment '所属订单ID',
    `user_id`               string comment '用户ID',
    `commodity_id`          string comment '商品ID',
    `commodity_name`        string comment '商品名称',
    `commodity_price`       int comment '商品价格',
    `commodity_discount`    int comment '商品折扣',
    `commodity_description` string comment '商品描述',
    `count`                 int comment '数量',
    `final_price`           int comment '折后价格',
    `created_date`          string comment '记录创建时间',
    `last_updated_date`     string comment '记录最后更新时间'
)
    comment '订单详情信息'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as
        inputformat 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
        outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
    location '/hive/data-warehouse-demo/ods/ods_order_item_db';
