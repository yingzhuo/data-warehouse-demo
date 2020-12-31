#!/usr/bin/env bash

# ---
# 环境变量
# ---
export JAVA_HOME=/var/lib/java8
export SQOOP_HOME=/opt/sqoop
export HADOOP_HOME=/opt/hadoop
export HIVE_HOME=/opt/hive

# ---
# 变量
# ---
if [ "x$1" != "x" ]; then
    dt=$1
else
    dt=`dt -d '-1 day' +%F`
fi

# ---
# 开始
# ---

sql="
set mapreduce.job.queuename=hive;
use data_warehouse_demo;
load data inpath '/data-warehouse-demo/log/login/$dt' overwrite into table ods_login_log partition(`dt`='$dt');
"

$HADOOP_HOME/bin/hadoop \
  jar \
  $HADOOP_HOME/share/hadoop/common/hadoop-lzo-0.4.20.jar \
  com.hadoop.compression.lzo.DistributedLzoIndexer \
  /hive/data-warehouse-demo/ods/ods_login_log/dt=$dt

$HIVE_HOME/bin/hive -e "$sql"
