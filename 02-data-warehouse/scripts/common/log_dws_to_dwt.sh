#!/usr/bin/env bash
#------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#------------------------------------------------------------------------------------------------------------

function dws_to_dwt_device_startup_topic_log() {
  hiveQl="
use data_warehouse_demo;
set mapreduce.job.queuename=hive;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table dwt_device_startup_topic
select nvl(new.device_id, old.device_id),
       if(old.login_date_first is null, '$CUR_DATE', old.login_date_first),
       if(new.count > 0, '$CUR_DATE', old.login_date_last),
       nvl(old.login_count, 0) + if(new.count > 0, 1, 0)
from dwt_device_startup_topic as old
         full outer join (
    select device_id,
           count(*) as count
    from dws_device_startup_daycount
    where dt = '$CUR_DATE'
    group by device_id) new
                         on
                             new.device_id = old.device_id;
  "

  "$HIVE_HOME"/bin/hive -e "$hiveQl"
}
