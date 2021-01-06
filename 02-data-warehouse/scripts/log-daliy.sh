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
    dt=$(date -d '-1 day' +%F)
fi

#------------------------------------------------------------------------------------------------------------
# HDFS临时目录 -> ODS
#------------------------------------------------------------------------------------------------------------

hiveSql="
use data_warehouse_demo;
set mapreduce.job.queuename=hive;
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
use data_warehouse_demo;
set mapreduce.job.queuename=hive;
set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

insert overwrite table dwd_login_log partition (dt='$dt')
select user_id, result from ods_login_log where result = 'OK' and dt = '$dt';
"

insert overwrite table dwd_login_log partition (dt='2020-01-04')
select user_id, result from ods_login_log where result = 'OK' and dt = '2021-01-04';

$HIVE_HOME/bin/hive -e "$hiveSql"
