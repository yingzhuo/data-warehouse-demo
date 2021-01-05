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
-- 加载
---
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table dwd_dim_date_db
select *
from dwd_dim_date_tmp;

drop table if exists dwd_dim_date_tmp;