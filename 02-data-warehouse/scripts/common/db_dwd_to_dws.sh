#!/usr/bin/env bash
#------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#------------------------------------------------------------------------------------------------------------

function dwd_to_dws_user_daycount_db() {

  hiveQl="
use data_warehouse_demo;
set mapreduce.job.queuename=hive;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

with temp_login as (
    select user_id,
           count(*) as c
    from dwd_fact_device_startup_log
    where dt = '$CUR_DATE'
      and user_id is not null
      and user_id > 0
    group by user_id
),
     temp_cart as (
         select user_id,
                count(*) as c
         from dwd_fact_cart_item_db
         where dt = '$CUR_DATE'
           and date_format(created_date, 'yyyy-MM-dd') = '$CUR_DATE'
         group by user_id
     ),
     temp_order as (
         select user_id,
                count(*) as c
         from dwd_fact_order_db
         where dt = '$CUR_DATE'
           and date_format(created_date, 'yyyy-MM-dd') = '$CUR_DATE'
         group by user_id
     ),
     temp_payment as (
         select user_id,
                count(*)          as c,
                sum(total_amount) as a
         from dwd_fact_payment_info_db
         where dt = '$CUR_DATE'
           and date_format(created_date, 'yyyy-MM-dd') = '$CUR_DATE'
         group by user_id
     ),
     temp_evaluation_1 as (
         select user_id,
                count(*) as c
         from dwd_fact_evaluation_db
         where dt = '$CUR_DATE'
           and level = '好评'
         group by user_id
     ),
     temp_evaluation_2 as (
         select user_id,
                count(*) as c
         from dwd_fact_evaluation_db
         where dt = '$CUR_DATE'
           and level = '中评'
         group by user_id
     ),
     temp_evaluation_3 as (
         select user_id,
                count(*) as c
         from dwd_fact_evaluation_db
         where dt = '$CUR_DATE'
           and level = '差评'
         group by user_id
     ),
     temp_fav as (
         select user_id,
                count(*) as c
         from dwd_fact_favor_info_db
         where dt = '$CUR_DATE'
           and date_format(created_date, 'yyyy-MM-dd') = '$CUR_DATE'
         group by user_id
     )
insert overwrite table dws_user_action_daycount partition(dt = '$CUR_DATE')
select coalesce(temp_login.user_id,
                temp_cart.user_id,
                temp_order.user_id,
                temp_payment.user_id,
                temp_evaluation_1.user_id,
                temp_evaluation_2.user_id,
                temp_evaluation_3.user_id,
                temp_fav.user_id
           ),
       nvl(temp_login.c, 0),
       nvl(temp_cart.c, 0),
       nvl(temp_order.c, 0),
       nvl(temp_payment.c, 0),
       nvl(temp_payment.a, 0),
       nvl(temp_evaluation_1.c, 0),
       nvl(temp_evaluation_2.c, 0),
       nvl(temp_evaluation_3.c, 0),
       nvl(temp_fav.c, 0)
from temp_login
         full outer join temp_cart on temp_login.user_id = temp_cart.user_id
         full outer join temp_order on temp_login.user_id = temp_order.user_id
         full outer join temp_payment on temp_login.user_id = temp_payment.user_id
         full outer join temp_evaluation_1 on temp_login.user_id = temp_evaluation_1.user_id
         full outer join temp_evaluation_2 on temp_login.user_id = temp_evaluation_2.user_id
         full outer join temp_evaluation_3 on temp_login.user_id = temp_evaluation_3.user_id
         full outer join temp_fav on temp_login.user_id = temp_fav.user_id;
  "

  "$HIVE_HOME"/bin/hive -e "$hiveQl"
}
