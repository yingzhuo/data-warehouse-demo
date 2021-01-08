#!/usr/bin/env bash
#------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#------------------------------------------------------------------------------------------------------------

function ods_to_dwd_commodity_db() {
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

  "$HIVE_HOME"/bin/hive -e "$hiveQl"
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

  "$HIVE_HOME"/bin/hive -e "$hiveQl"
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

  "$HIVE_HOME"/bin/hive -e "$hiveQl"
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

  "$HIVE_HOME"/bin/hive -e "$hiveQl"
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

  "$HIVE_HOME"/bin/hive -e "$hiveQl"
}

function ods_to_dwd_order_db() {
  hiveQl="
use data_warehouse_demo;
set mapreduce.job.queuename=hive;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table dwd_fact_order_db partition (dt)
select if(new.id is not null, new.id, old.id),
       if(new.user_id is not null, new.user_id, old.user_id),
       if(new.status is not null, new.status, old.status),
       if(new.total_amount is not null, new.total_amount, old.total_amount),
       if(new.province_id is not null, new.province_id, old.province_id),
       if(new.canceled_date is not null, new.canceled_date, old.canceled_date),
       if(new.delivered_date is not null, new.delivered_date, old.delivered_date),
       if(new.evaluated_date is not null, new.evaluated_date, old.evaluated_date),
       if(new.payed_date is not null, new.payed_date, old.payed_date),
       if(new.taked_date is not null, new.taked_date, old.taked_date),
       if(new.created_date is not null, new.created_date, old.created_date),
       if(new.last_updated_date is not null, new.last_updated_date, old.last_updated_date),
       date_format(if(new.created_date is not null, new.created_date, old.created_date), 'yyyy-MM-dd') as dt
from (
         select id,
                user_id,
                status,
                total_amount,
                province_id,
                canceled_date,
                delivered_date,
                evaluated_date,
                payed_date,
                taked_date,
                created_date,
                last_updated_date
         from ods_order_db
         where dt in (
             select date_format(created_date, 'yyyy-MM-dd') as d
             from ods_order_db
             where dt = '$CUR_DATE'
               and date_format(created_date, 'yyyy-MM-dd') is not null
             group by date_format(created_date, 'yyyy-MM-dd')
         )
     ) as old
         full outer join
     (
         select id,
                user_id,
                status,
                total_amount,
                province_id,
                canceled_date,
                delivered_date,
                evaluated_date,
                payed_date,
                taked_date,
                created_date,
                last_updated_date
         from ods_order_db
         where dt = '$CUR_DATE'
     ) as new
     on new.id = old.id;
  "

  "$HIVE_HOME"/bin/hive -e "$hiveQl"
}

function ods_to_dwd_order_item_db() {
    hiveQl="
use data_warehouse_demo;
set mapreduce.job.queuename=hive;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table dwd_fact_order_item_db partition (dt = '$CUR_DATE')
select id,
       order_id,
       user_id,
       commodity_id,
       count,
       final_price,
       created_date,
       last_updated_date
from ods_order_item_db
where dt = '$CUR_DATE';
    "

  "$HIVE_HOME"/bin/hive -e "$hiveQl"
}

function ods_to_dwd_user_db() {
  hiveQl="
use data_warehouse_demo;
set mapreduce.job.queuename=hive;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table dwd_dim_user_db
select id,
       name,
       username,
       phone_number,
       avatar_url,
       email_addr,
       gender,
       'x', -- 密码脱敏
       created_date,
       last_updated_date,
       '$CUR_DATE',
       '9999-99-99'
from ods_user_db
where dt = '$CUR_DATE'
union all
select his.id,
       his.name,
       his.username,
       his.phone_number,
       his.avatar_url,
       his.email_addr,
       his.gender,
       'x', -- 密码脱敏
       his.created_date,
       his.last_updated_date,
       his.zip_start,
       if(u.id is not null and his.zip_end = '9999-99-99', date_add(u.dt, -1), his.zip_end)
from dwd_dim_user_db as his
         left join
     (select id, dt
      from ods_user_db
      where dt = '$CUR_DATE') as u
     on u.id = his.id;
  "

  "$HIVE_HOME"/bin/hive -e "$hiveQl"
}

function ods_to_dwd_pwd_changed() {
  hiveQl="
use data_warehouse_demo;
set mapreduce.job.queuename=hive;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table dwd_pwd_changed_db partition (dt = '$CUR_DATE')
select id,
       user_id,
       'x',
       created_date
from ods_pwd_changed_db
where dt = '$CUR_DATE';
  "

  "$HIVE_HOME"/bin/hive -e "$hiveQl"
}
