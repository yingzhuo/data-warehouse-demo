--======================================================================================================================
-- 数据仓库DWD层
-- DB type      : hive 3.1.2
-- DB           : data_warehouse_demo
-- author       : 应卓
--======================================================================================================================
set mapreduce.job.queuename=hive;
use data_warehouse_demo;

---
-- 时间维度表 (临时) 非外部表
---
drop table if exists dwd_dim_date_tmp;
create table dwd_dim_date_tmp
(
    `date`         string comment '日期',
    `year`         int comment '年 (如: 2018)',
    `month`        int comment '月 (如: 7)',
    `day`          int comment '日 (如: 15)',
    `quarter`      int comment '季度 (如: 1)',
    `week`         int comment '星期 (如: 7星期日 6星期六)',
    `weekend`      boolean comment '是否是周末',
    `week_of_year` int comment '周在一年中的顺序'
)
    comment '日期维度表(临时)' row format delimited
    fields terminated by ',';

-- 日期文件要预先放在此处
load data local inpath '/home/ccae/project/data_warehouse_demo/tmp/dim_date'
    overwrite into table dwd_dim_date_tmp;

---
-- 时间维度表
---
drop table if exists dwd_dim_date_db;
create external table dwd_dim_date_db
(
    `date`         string comment '日期',
    `year`         int comment '年 (如: 2018)',
    `month`        int comment '月 (如: 7)',
    `day`          int comment '日 (如: 15)',
    `quarter`      int comment '季度 (如: 1)',
    `week`         int comment '星期 (如: 7星期日 6星期六)',
    `weekend`      boolean comment '是否是周末',
    `week_of_year` int comment '周在一年中的顺序'
)
    comment '日期维度表'
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dwd/dwd_dim_date_db'
    tblproperties ('parquet.compression' = 'lzo');

---
-- 加载时间维度数据 / 删除时间维度临时表
---
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table dwd_dim_date_db
select *
from dwd_dim_date_tmp;

drop table if exists dwd_dim_date_tmp;

---
-- 设备启动日志
---
drop table if exists dwd_fact_device_startup_log;
create external table dwd_fact_device_startup_log
(
    `ts`        string comment '时间戳',
    `device_id` string comment '设备ID',
    `user_id`   string comment '用户ID',
    `os_type`   string comment '操作系统类型',
    `brand`     string comment '品牌',
    `model`     string comment '型号'
)
    comment '设备启动日志'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dwd/dwd_fact_device_startup_log'
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

---
-- 省份维度表
---
drop table if exists dwd_dim_province_db;
create external table dwd_dim_province_db
(
    `id`         string comment 'ID',
    `name`       string comment '名称',
    `short_name` string comment '简称',
    `region`     string comment '所属地区'
)
    comment '省份维度表'
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dwd/dwd_dim_province_db'
    tblproperties ('parquet.compression' = 'lzo');

---
-- 支付信息事实表
---
drop table if exists dwd_fact_payment_info_db;
create external table dwd_fact_payment_info_db
(
    `id`                string comment 'ID',
    `user_id`           string comment '用户ID',
    `order_id`          string comment '订单ID',
    `total_amount`      bigint comment '总计金额',
    `province_id`       string comment '省份ID',
    `created_date`      string comment '记录创建时间',
    `last_updated_date` string comment '记录最后更新时间'
)
    comment '支付信息事实表'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dwd/dwd_fact_payment_info_db'
    tblproperties ('parquet.compression' = 'lzo');

---
-- 评价信息事实表
---
drop table if exists dwd_fact_evaluation_db;
create external table dwd_fact_evaluation_db
(
    `id`           string comment 'ID',
    `user_id`      string comment '用户ID',
    `commodity_id` string comment '商品ID',
    `order_id`     string comment '订单ID',
    `level`        string comment '评价级别',
    `text`         string comment '评价信息',
    `text_len`     string comment '评价信息长度',
    `province_id`  string comment '省份ID',
    `created_date` string comment '记录创建时间'
)
    comment '评价信息事实表'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dwd/dwd_fact_evaluation_db'
    tblproperties ('parquet.compression' = 'lzo');

---
-- 加购事实表
---
drop table if exists dwd_fact_cart_item_db;
create external table dwd_fact_cart_item_db
(
    `id`                string comment 'id',
    `commodity_id`      string comment '商品ID',
    `count`             int comment '数量',
    `final_price`       int comment '折后价格',
    `user_id`           string comment '用户ID',
    `created_date`      string comment '记录创建时间',
    `last_updated_date` string comment '记录最后更新时间'
)
    comment '加购事实表'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dwd/dwd_fact_cart_item_db'
    tblproperties ('parquet.compression' = 'lzo');

---
-- 订单事实表
---
drop table if exists dwd_fact_order_db;
create external table dwd_fact_order_db
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
    comment '订单事实表'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dwd/dwd_fact_order_db'
    tblproperties ('parquet.compression' = 'lzo');

---
-- 订单详情事实表
---
drop table if exists dwd_fact_order_item_db;
create external table dwd_fact_order_item_db
(
    `id`                string comment 'id',
    `order_id`          string comment '所属订单ID',
    `user_id`           string comment '用户ID',
    `commodity_id`      string comment '商品ID',
    `count`             int comment '数量',
    `final_price`       int comment '折后价格',
    `created_date`      string comment '记录创建时间',
    `last_updated_date` string comment '记录最后更新时间'
)
    comment '订单详情事实表'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dwd/dwd_fact_order_item_db'
    tblproperties ('parquet.compression' = 'lzo');

---
-- 用户维度表 (拉链表 | 非分区)
---
drop table if exists dwd_dim_user_db;
create external table dwd_dim_user_db
(
    `id`                string comment 'ID',
    `name`              string comment '姓名',
    `username`          string comment '用户名',
    `phone_number`      string comment '电话号码',
    `avatar_url`        string comment '头像地址',
    `email_addr`        string comment '电子邮件地址',
    `gender`            string comment '性别',
    `login_password`    string comment '登录密码',
    `level`             string comment '用户级别',
    `dob`               string comment '出生日期',
    `created_date`      string comment '记录创建时间',
    `last_updated_date` string comment '记录最后更新时间',
    `zip_start`         string comment '拉链日期 - 结束',
    `zip_end`           string comment '拉链日期 - 结束'
)
    comment '用户维度表'
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dwd/dwd_dim_user_db'
    tblproperties ('parquet.compression' = 'lzo');

---
-- 收藏信息
---
drop table if exists dwd_fact_favor_info_db;
create external table dwd_fact_favor_info_db
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
    stored as parquet
    location '/hive/data-warehouse-demo/dwd/dwd_fact_favor_info_db'
    tblproperties ('parquet.compression' = 'lzo');

---
-- 密码更新日志
---
drop table if exists dwd_pwd_changed_db;
create external table dwd_pwd_changed_db
(
    `id`           string comment 'id',
    `user_id`      string comment '用户ID',
    `new_password` string comment '更新后的密码',
    `created_date` string comment '记录创建时间'
)
    comment '密码更新日志'
    partitioned by (`dt` string comment '日期分区')
    row format delimited
        fields terminated by '\001'
    stored as parquet
    location '/hive/data-warehouse-demo/dwd/dwd_pwd_changed_db'
    tblproperties ('parquet.compression' = 'lzo');
