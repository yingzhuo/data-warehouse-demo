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

  $HIVE_HOME/bin/hive -e "$hiveQl"
}

function ods_to_dwd_province_db() {
  hiveQl="
use data_warehouse_demo;
set mapreduce.job.queuename=hive;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table dwd_dim_province_db
select id,
       name,
       short_name,
       region
from ods_province_db;
  "

  $HIVE_HOME/bin/hive -e "$hiveQl"
}

function ods_to_dwd_payment_info_db() {
  hiveQl="
use data_warehouse_demo;
set mapreduce.job.queuename=hive;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table dwd_fact_payment_info_db partition (dt = '$CUR_DATE')
select p.id,
       p.user_id,
       p.order_id,
       p.total_amount,
       o.province_id,
       p.created_date,
       p.last_updated_date
from ods_payment_info_db as p
         join
         (select id, province_id from ods_order_db where dt = '$CUR_DATE') as o
         on p.order_id = o.id
where p.dt = '$CUR_DATE';
  "

  $HIVE_HOME/bin/hive -e "$hiveQl"
}

function ods_to_dwd_evaluation_db() {
  hiveQl="
use data_warehouse_demo;
set mapreduce.job.queuename=hive;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table dwd_fact_evaluation_db partition (dt = '$CUR_DATE')
select ev.id,
       ev.user_id,
       ev.order_id,
       ev.level,
       ev.text,
       length(ev.text),
       o.province_id,
       ev.created_date
from ods_evaluation_db as ev
         join
         (select id, province_id from ods_order_db where dt = '$CUR_DATE') as o
         on
             ev.order_id = o.id
where
    ev.dt = '$CUR_DATE';
  "

  $HIVE_HOME/bin/hive -e "$hiveQl"
}

function ods_to_dwd_cart_item_db() {
  hiveQl="
use data_warehouse_demo;
set mapreduce.job.queuename=hive;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table dwd_fact_cart_item_db partition (dt = '$CUR_DATE')
select id,
       commodity_id,
       count,
       final_price,
       user_id,
       created_date,
       last_updated_date
from ods_cart_item_db
where dt = '$CUR_DATE';
  "

  $HIVE_HOME/bin/hive -e "$hiveQl"
}