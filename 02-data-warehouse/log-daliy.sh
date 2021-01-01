#!/usr/bin/env bash
#------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#------------------------------------------------------------------------------------------------------------

# ---
# 环境变量
# ---
export JAVA_HOME=/var/lib/java8
export SQOOP_HOME=/opt/sqoop
export HADOOP_HOME=/opt/hadoop
export HADOOP_MAPRED_HOME=/opt/hadoop
export HIVE_HOME=/opt/hive

# ---
# 变量
# ---
if [ "x$1" != "x" ]; then
    dt=$1
else
    dt=`date -d '-1 day' +%F`
fi

#------------------------------------------------------------------------------------------------------------
# HDFS临时目录 -> ODS
#------------------------------------------------------------------------------------------------------------

hiveSql="
set mapreduce.job.queuename=hive;
use data_warehouse_demo;
load data inpath '/data-warehouse-demo/log/login/$dt' overwrite into table ods_login_log partition(dt='$dt');
"

$HIVE_HOME/bin/hive -e "$hiveSql"

# 创建索引
$HADOOP_HOME/bin/hadoop \
  jar \
  $HADOOP_HOME/share/hadoop/common/hadoop-lzo-0.4.20.jar \
  com.hadoop.compression.lzo.DistributedLzoIndexer \
  /hive/data-warehouse-demo/ods/ods_login_log/dt=$dt

#------------------------------------------------------------------------------------------------------------
# OSD -> DWD
#------------------------------------------------------------------------------------------------------------

hiveSql="
insert overwrite table dwd_login_log partition (dt='$dt')
select user_id, result from ods_login_log where result = 'OK' and dt = '$dt';
"

$HIVE_HOME/bin/hive -e "$hiveSql"
