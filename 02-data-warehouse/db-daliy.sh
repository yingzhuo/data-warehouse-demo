#!/usr/bin/env bash
#------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#------------------------------------------------------------------------------------------------------------

export NOT_PARTITION_TABLE="not-partition-table"

if [[ "x$1" != "x" ]]
then
  export CUR_DATE=$1
else
  export CUR_DATE=$(date -d '-1 day' +%F)
fi

pwd=$(dirname "$0")
source "$pwd"/common/include.sh

function import_t_user_to_ods() {
  import_db_table_to_ods \
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
          DATE_FORMAT(created_date, '%Y-%m-%d') = '$CUR_DATE'
      OR
          DATE_FORMAT(last_updated_date, '%Y-%m-%d') = '$CUR_DATE'
      " \
      "ods_user_db"
}

function import_t_favor_info_to_ods() {
  import_db_table_to_ods \
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

function import_t_commodity_to_ods() {
  import_db_table_to_ods \
    "t_commodity" \
    "
    SELECT
      id,
      name,
      price,
      discount,
      description,
      trade_marker_id,
      category_3_id,
      created_date,
      last_updated_date
    FROM
      t_commodity
    WHERE
      1 = 1
    " \
    "ods_commodity_db"
}

function import_t_trade_marker_to_ods() {
    import_db_table_to_ods \
    "t_trade_marker" \
    "
    SELECT
      id,
      name,
      home_page,
      description,
      created_date,
      last_updated_date
    FROM
      t_trade_marker
    WHERE
      1 = 1
    " \
    "ods_trade_marker_db"
}

function import_t_category_1_to_ods() {
    import_db_table_to_ods \
    "t_category_1" \
    "
    SELECT
      id,
      name,
      created_date,
      last_updated_date
    FROM
      t_category_1
    WHERE
      1 = 1
    " \
    "ods_category_1_db"
}

function import_t_category_2_to_ods() {
  import_db_table_to_ods \
    "t_category_2" \
    "
    SELECT
      id,
      name,
      parent_id,
      created_date,
      last_updated_date
    FROM
      t_category_2
    WHERE
      1 = 1
    " \
    "ods_category_2_db"
}

function import_t_category_3_to_ods() {
  import_db_table_to_ods \
    "t_category_3" \
    "
    SELECT
      id,
      name,
      parent_id,
      created_date,
      last_updated_date
    FROM
      t_category_3
    WHERE
      1 = 1
    " \
    "ods_category_3_db"
}

function import_t_payment_info_to_ods() {
  import_db_table_to_ods \
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
        DATE_FORMAT(created_date, '%Y-%m-%d') = '$CUR_DATE'
    " \
    "ods_payment_info_db"
}

function import_t_order_status_transition_to_ods() {
  import_db_table_to_ods \
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
      DATE_FORMAT(created_date, '%Y-%m-%d') = '$CUR_DATE'
    " \
    "ods_order_status_transition_db"
}

function import_t_evaluation_to_ods() {
  import_db_table_to_ods \
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
      DATE_FORMAT(created_date, '%Y-%m-%d') = '$CUR_DATE'
    " \
    "ods_evaluation_db"
}

function import_t_cart_to_ods() {
  import_db_table_to_ods \
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

function import_t_cart_item_to_ods() {
  import_db_table_to_ods \
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

function import_t_order_to_ods() {
  import_db_table_to_ods \
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
        DATE_FORMAT(created_date, '%Y-%m-%d') = '$CUR_DATE'
    OR
        DATE_FORMAT(last_updated_date, '%Y-%m-%d') = '$CUR_DATE'
    " \
    "ods_order_db"
}

function import_t_order_item_ods() {
  import_db_table_to_ods \
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
      DATE_FORMAT(created_date, '%Y-%m-%d') = '$CUR_DATE'
    OR
      DATE_FORMAT(last_updated_date, '%Y-%m-%d') = '$CUR_DATE'
    " \
    "ods_order_item_db"
}

import_t_province_to_ods
import_t_user_to_ods
import_t_commodity_to_ods
import_t_trade_marker_to_ods
import_t_category_1_to_ods
import_t_category_2_to_ods
import_t_category_3_to_ods
import_t_favor_info_to_ods
import_t_payment_info_to_ods
import_t_order_status_transition_to_ods
import_t_evaluation_to_ods
import_t_cart_to_ods
import_t_cart_item_to_ods
import_t_order_to_ods
import_t_order_item_ods

# =======================================================================================================================
# ODS -> DWD
# =======================================================================================================================

hiveQl="
  use data_warehouse_demo;
  set mapreduce.job.queuename=hive;
  set hive.input.format=org.apache.hadoop.hive.ql.io.HiveInputFormat;

  insert overwrite table dwd_dim_commodity_db partition (dt = '$CUR_DATE')
  select c.id,
         c.name,
         c.price,
         c.discount,
         c.description,
         tm.id,
         tm.name,
         c1.id,
         c1.name,
         c2.id,
         c2.name,
         c3.id,
         c3.name,
         c.created_date,
         c.last_updated_date
  from ods_commodity_db c
           join
           (select id, name from ods_trade_marker_db where dt = '$CUR_DATE') as tm
           on
               c.trade_marker_id = tm.id
          join
          (select id, name, parent_id from ods_category_3_db where dt = '$CUR_DATE') as c3
          on
              c.category_3_id = c3.id
          join
          (select id, name, parent_id from ods_category_2_db where dt = '$CUR_DATE') as c2
          on
              c2.id = c3.parent_id
          join
          (select id, name from ods_category_1_db where dt = '$CUR_DATE') as c1
          on
              c1.id = c2.parent_id
  where
      c.dt = '$CUR_DATE';
"

hive -e "$hiveQl"
