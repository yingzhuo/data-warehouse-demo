#!/usr/bin/env bash
#-----------------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#-----------------------------------------------------------------------------------------------------------------------

# 共通
export JAVA_HOME=/var/lib/java8
export SQOOP_HOME=/opt/sqoop
export HADOOP_HOME=/opt/hadoop
export HADOOP_MAPRED_HOME=/opt/hadoop
export HIVE_HOME=/opt/hive

# 关系型数据库
export DB_URL="jdbc:mysql://192.168.99.114:3306/data-warehouse-demo-report?useSSL=false"
export DB_USERNAME="root"
export DB_PASSWORD="root"

########################################################################################################################
# 将数据导入到MySQL数据库
#
# 参数:
#    $1: 关系型数据库表名
#    $2: MySQL数据库主键，多个时用逗号隔开
# 返回值:
#    无
########################################################################################################################
function export_data() {
  "$SQOOP_HOME"/bin/sqoop export \
  --connect "$DB_URL" \
  --username "$DB_USERNAME" \
  --password "$DB_PASSWORD" \
  --table "$1" \
  --num-mappers 1 \
  --export-dir /warehouse/$hive_db_name/ads/$1 \
  --input-fields-terminated-by '\t' \
  --update-mode allowinsert \
  --update-key "$2" \
  --input-null-string '\\N'    \
  --input-null-non-string '\\N'
}
