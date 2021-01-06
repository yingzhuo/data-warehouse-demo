#!/usr/bin/env bash
#------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#------------------------------------------------------------------------------------------------------------

# 共通
export JAVA_HOME=/var/lib/java8
export SQOOP_HOME=/opt/sqoop
export HADOOP_HOME=/opt/hadoop
export HADOOP_MAPRED_HOME=/opt/hadoop
export HIVE_HOME=/opt/hive

# 关系型数据库
export DB_URL="jdbc:mysql://192.168.99.114:3306/data-warehouse-demo?useSSL=false"
export DB_USERNAME="root"
export DB_PASSWORD="root"

# HDFS
export HDFS_TEMP_DIR="/data-warehouse-demo"

# HIVE
export HIVE_USING_QUEUE_NAME="hive"
export HIVE_DB_NAME="data_warehouse_demo"

# 打印调试信息
echo "JAVA_HOME=$JAVA_HOME"
echo "SQOOP_HOME=$SQOOP_HOME"
echo "HADOOP_HOME=$HADOOP_HOME"
echo "HADOOP_MAPRED_HOME=$HADOOP_MAPRED_HOME"
echo "HIVE_HOME=$HIVE_HOME"

########################################################################################################################
# 为HDFS上的文件或目录生成lzo索引
#
# 参数:
#    $1: 文件或目录的Path
# 返回值:
#    无
########################################################################################################################
function create_lzo_index() {
    hdfs=$1
    $HADOOP_HOME/bin/hadoop jar \
      $HADOOP_HOME/share/hadoop/common/hadoop-lzo-0.4.20.jar \
      com.hadoop.compression.lzo.DistributedLzoIndexer \
      "$hdfs"
}

########################################################################################################################
# 将关系型数据库中的数据导入ods层
#
# 参数:
#    $1: 关系型数据库表名
#    $2: 查询语句
#    $3: Hive表名
# 全局变量:
#    CUR_DATE: 工作时间 (FORMAT: '1970-01-01')
# 返回值:
#    无
########################################################################################################################
function import_db_to_hdfs() {

    db_table_name=$1
    db_sql=$2
    hive_table_name=$3

    # 导入数据
    $SQOOP_HOME/bin/sqoop import \
        --connect "$DB_URL" \
        --username "$DB_USERNAME" \
        --password "$DB_PASSWORD" \
        --target-dir "$HDFS_TEMP_DIR/db/$db_table_name/$CUR_DATE" \
        --delete-target-dir \
        --query "$db_sql and \$CONDITIONS" \
        --num-mappers 1 \
        --compress \
        --compression-codec lzop \
        --fields-terminated-by '\001' \
        --null-string '\\N' \
        --null-non-string '\\N'

    $HADOOP_HOME/bin/hadoop fs -rm -r "$HDFS_TEMP_DIR/db/$db_table_name/$CUR_DATE/_SUCCESS"
    create_lzo_index "$HDFS_TEMP_DIR/db/$db_table_name/$CUR_DATE"
    rm -rf ./*.java

    # 导入到hive
    if [[ "$4" == "not-partition-table" ]]
    then
      hive_ql="
        set mapreduce.job.queuename=$HIVE_USING_QUEUE_NAME;
        use $HIVE_DB_NAME;
        load data inpath '$HDFS_TEMP_DIR/db/$db_table_name/$CUR_DATE' overwrite into table $hive_table_name;
      "
    else
      hive_ql="
        set mapreduce.job.queuename=$HIVE_USING_QUEUE_NAME;
        use $HIVE_DB_NAME;
        load data inpath '$HDFS_TEMP_DIR/db/$db_table_name/$CUR_DATE' overwrite into table $hive_table_name partition(dt='$CUR_DATE');
      "
    fi

    $HIVE_HOME/bin/hive -e "$hive_ql"
}
