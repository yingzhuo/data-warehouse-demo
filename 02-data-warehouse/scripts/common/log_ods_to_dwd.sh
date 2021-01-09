#!/usr/bin/env bash
#------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#------------------------------------------------------------------------------------------------------------

function ods_to_dwd_device_startup_db() {
  hiveQl="
use data_warehouse_demo;
set mapreduce.job.queuename=hive;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table dwd_fact_device_startup_log partition (dt = '$CUR_DATE')
select ts,
       device_id,
       user_id,
       os_type,
       brand,
       model
from ods_device_startup_log
where dt = '$CUR_DATE';
  "

  "$HIVE_HOME"/bin/hive -e "$hiveQl"
}
