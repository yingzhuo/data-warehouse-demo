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
application="data-warehouse-demo"
db="jdbc:mysql://192.168.99.114:3306/data-warehouse-demo?useSSL=false"
dbusername="root"
dbpassword="root"
dt='1970-01-01'

# $1: 关系型数据库表名
# $2: 关系型数据库选择SQL
# $3: Hive表名
# $4: 有值时表示非分区表, 不传值时按分区表处理
import_table() {
    # 导入数据
    $SQOOP_HOME/bin/sqoop import \
        --connect $db \
        --username $dbusername \
        --password $dbpassword \
        --target-dir /$application/db/$1/$dt \
        --delete-target-dir \
        --query "$2 and \$CONDITIONS" \
        --num-mappers 1 \
        --compress \
        --compression-codec lzop \
        --fields-terminated-by '\001' \
        --null-string '\\N' \
        --null-non-string '\\N'

    # 删除HDFS上无用的文件
    $HADOOP_HOME/bin/hadoop fs -rm /$application/db/$1/$dt/_SUCCESS

    # 生成lzo索引文件
    $HADOOP_HOME/bin/hadoop jar \
        $HADOOP_HOME/share/hadoop/common/hadoop-lzo-0.4.20.jar \
        com.hadoop.compression.lzo.DistributedLzoIndexer \
        /$application/db/$1/$dt

    # 导入到hive
    if [[ "x$4" == "x" ]]
    then
      hiveQl="
        set mapreduce.job.queuename=hive;
        use data_warehouse_demo;
        load data inpath '/$application/db/$1/$dt' overwrite into table $3 partition(dt='$dt');
      "
    else
      hiveQl="
        set mapreduce.job.queuename=hive;
        use data_warehouse_demo;
        load data inpath '/$application/db/$1/$dt' overwrite into table $3;
      "
    fi

    $HIVE_HOME/bin/hive -e "$hiveQl"

    # 删除本地垃圾文件
    rm -f ./*.java
}

import_t_province() {
  import_table \
    "t_province" \
    "
    SELECT
      id,
      name,
      short_name,
      region
    FROM
      t_province
    WHERE
      1 = 1
    " \
    "ods_province_db" \
    "not-partition-table"
}

import_t_user() {
  import_table \
      "t_user" \
      "
      SELECT
          id,
          name,
          username,
          phone_number,
          avatar_url,
          email_addr,
          gender,
          login_password,
          created_date,
          last_updated_date
      FROM
          t_user
      WHERE
          1 = 1
      " \
      "ods_user_db"
}

import_t_favor_info() {
  import_table \
    "t_favor_info" \
    "
    SELECT
      id,
      user_id,
      commodity_id,
      created_date,
      last_updated_date
    FROM
      t_favor_info
    WHERE
      1 = 1
    " \
    "ods_favor_info_db"
}

import_t_commodity() {
  import_table \
    "t_commodity" \
    "
    SELECT
      id,
      name,
      price,
      discount,
      description,
      created_date,
      last_updated_date
    FROM
      t_commodity
    WHERE
      1 = 1
    " \
    "ods_commodity_db"
}

import_t_payment_info() {
  import_table \
    "t_payment_info" \
    "
    SELECT
      id,
      user_id,
      order_id,
      total_amount,
      created_date,
      last_updated_date
    FROM
      t_payment_info
    WHERE
      1 = 1
    " \
    "ods_payment_info_db"
}

import_t_order_status_transition() {
  import_table \
    "t_order_status_transition" \
    "
    SELECT
      id,
      order_id,
      status,
      created_date
    FROM
      t_order_status_transition
    WHERE
      1 = 1
    " \
    "ods_order_status_transition_db"
}

import_t_evaluation() {
  import_table \
    "t_evaluation" \
    "
    SELECT
      id,
      user_id,
      order_id,
      level,
      text,
      created_date,
      last_updated_date
    FROM
      t_evaluation
    WHERE
      1 = 1
    " \
    "ods_evaluation_db"
}

import_t_cart() {
  import_table \
    "t_cart" \
    "
    SELECT
      user_id,
      total_amount,
      total_count,
      created_date,
      last_updated_date
    FROM
      t_cart
    WHERE
      1 = 1
    " \
    "ods_cart_db"
}

import_t_cart_item() {
  import_table \
    "t_cart_item" \
    "
    SELECT
      id,
      commodity_id,
      commodity_name,
      commodity_price,
      commodity_discount,
      commodity_description,
      count,
      final_price,
      user_id,
      created_date,
      last_updated_date
    FROM
      t_cart_item
    WHERE
      1 = 1
    " \
    "ods_cart_item_db"
}

import_t_order() {
  import_table \
    "t_order" \
    "
    SELECT
      id,
      user_id,
      status,
      total_amount,
      province_id,
      canceled_date,
      delivered_date,
      evaluated_date,
      payed_date,
      taked_date,
      created_date,
      last_updated_date
    FROM
      t_order
    WHERE
      1 = 1
    " \
    "ods_order_db"
}

import_t_order_item() {
  import_table \
    "t_order_item" \
    "
    SELECT
      id,
      order_id,
      user_id,
      commodity_id,
      commodity_name,
      commodity_price,
      commodity_discount,
      commodity_description,
      count,
      final_price,
      created_date,
      last_updated_date
    FROM
      t_order_item
    WHERE
      1 = 1
    " \
    "ods_order_item_db"
}

import_t_province
import_t_user
import_t_favor_info
import_t_commodity
import_t_payment_info
import_t_order_status_transition
import_t_evaluation
import_t_cart
import_t_cart_item
import_t_order
import_t_order_item