#!/usr/bin/env bash
#------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#------------------------------------------------------------------------------------------------------------

function dwt_to_ads_uv_count() {
  hiveQl="
use data_warehouse_demo;
set mapreduce.job.queuename=hive;

insert overwrite table ads_uv_count
select *
from ads_uv_count
union all
select '$CUR_DATE',
       sum(if(login_date_last = '$CUR_DATE', 1, 0)),
       sum(
               if(
                           login_date_last >= date_add(next_day('$CUR_DATE', 'MO'), -7) and
                           login_date_last <= date_add(next_day('$CUR_DATE', 'MO'), -1),
                           1,
                           0
                   )
           ),
       sum(
               if(
                           date_format('$CUR_DATE', 'yyyy-MM') = date_format(login_date_last, 'yyyy-MM'),
                           1, 0
                   )
           ),
       if('$CUR_DATE' = date_add(next_day('$CUR_DATE', 'MO'), -1), 'Y', 'N'),
       if('$CUR_DATE' = last_day('$CUR_DATE'), 'Y', 'N')
from dwt_device_startup_topic;
  "

  "$HIVE_HOME"/bin/hive -e "$hiveQl"
}
