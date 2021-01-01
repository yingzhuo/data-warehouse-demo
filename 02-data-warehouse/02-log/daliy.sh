#!/usr/bin/env bash
#------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#------------------------------------------------------------------------------------------------------------

# ---
# 环境变量
# ---
export JAVA_HOME=/var/lib/java8
export HADOOP_HOME=/opt/hadoop
export HIVE_HOME=/opt/hive
export SQOOP_HOME=/opt/sqoop

# ---
# 变量
# ---
if [ "x$1" != "x" ]; then
    dt=$1
else
    dt=`date -d '-1 day' +%F`
fi

sql="
use data_warehouse_demo;
load data inpath '/data-warehouse-demo/log/login/$dt' overwrite into table ods_login_log partition(dt='$dt');
"

# 导入数据
$HIVE_HOME/bin/hive -e "$sql"

# 创建索引
$HADOOP_HOME/bin/hadoop \
  jar \
  $HADOOP_HOME/share/hadoop/common/hadoop-lzo-0.4.20.jar \
  com.hadoop.compression.lzo.DistributedLzoIndexer \
  /hive/data-warehouse-demo/ods/ods_login_log/dt=$dt

exit 0