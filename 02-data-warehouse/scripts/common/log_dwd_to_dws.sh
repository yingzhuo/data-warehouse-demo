#!/usr/bin/env bash
#-----------------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#-----------------------------------------------------------------------------------------------------------------------

function dwd_to_dws_uv_details_daycount() {
  hiveQl="
use data_warehouse_demo;
set mapreduce.job.queuename=hive;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table dws_uv_details_daycount partition (dt = '$CUR_DATE')
select device_id,
       concat_ws(' @@ ', collect_set(user_id)),
       concat_ws(' @@ ', collect_set(os_type)),
       concat_ws(' @@ ', collect_set(brand)),
       concat_ws(' @@ ', collect_set(model))
from dwd_fact_device_startup_log
where dt = '$CUR_DATE'
group by device_id;
  "

  "$HIVE_HOME"/bin/hive -e "$hiveQl"
}