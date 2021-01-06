#!/usr/bin/env bash
#------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#------------------------------------------------------------------------------------------------------------

function ods_to_dwd_dim_commodity_db() {
  hiveQl="
use data_warehouse_demo;
set mapreduce.job.queuename=hive;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table dwd_dim_commodity_db partition (dt = '$CUR_DATE')
select c.id,
       c.name,
       c.price,
       c.discount,
       c.description,
       tm.id,
       tm.name,
       c1.id,
       c1.name,
       c2.id,
       c2.name,
       c3.id,
       c3.name,
       c.created_date,
       c.last_updated_date
from ods_commodity_db c
         join
         (select id, name from ods_trade_marker_db where dt = '$CUR_DATE') as tm
         on
             c.trade_marker_id = tm.id
         join
     ods_category_3_db as c3
     on
         c.category_3_id = c3.id
         join
     ods_category_2_db as c2
     on
         c2.id = c3.parent_id
         join
     ods_category_1_db as c1
     on
         c1.id = c2.parent_id
where c.dt = '$CUR_DATE';
  "

  hive -e "$hiveQl"
}
