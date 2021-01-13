#!/usr/bin/env bash
#------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#------------------------------------------------------------------------------------------------------------
export NOT_PARTITION_TABLE="not-partition-table"

pwd=$(dirname "$0")
source "$pwd"/common/include.sh
source "$pwd"/common/log_ods_to_dwd.sh
source "$pwd"/common/log_dwd_to_dws.sh
source "$pwd"/common/log_dws_to_dwt.sh
source "$pwd"/common/log_dwt_to_ads.sh

if [ "x$1" != "x" ]; then
    CUR_DATE=$1
else
    CUR_DATE=$(date -d '-1 day' +%F)
fi

#------------------------------------------------------------------------------------------------------------
# HDFS临时目录 -> ODS
#------------------------------------------------------------------------------------------------------------

function import_device_startup_log_ods() {

  hiveQl="
    use data_warehouse_demo;
    set mapreduce.job.queuename=hive;

    load data inpath '/data-warehouse-demo/log/device-startup/$CUR_DATE'
      overwrite into table ods_device_startup_log partition(dt='$CUR_DATE');
  "

  "$HIVE_HOME"/bin/hive -e "$hiveQl"

  create_lzo_index "/hive/data-warehouse-demo/ods/ods_device_startup_log/dt=$CUR_DATE"
}

#import_device_startup_log_ods
#ods_to_dwd_device_startup_log
#dwd_to_dws_uv_details_daycount
dws_to_dwt_uv_topic
