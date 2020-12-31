--======================================================================================================================
-- 数据仓库ODS层
-- DB           : data_warehouse_demo
-- author       : 应卓
--======================================================================================================================
set mapreduce.job.queuename=hive;

use data_warehouse_demo;

-- 用户登录行为日志
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
