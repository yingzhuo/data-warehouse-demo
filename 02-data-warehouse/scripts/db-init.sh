#!/usr/bin/env bash
#------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#------------------------------------------------------------------------------------------------------------
export CUR_DATE="1970-01-01"
export NOT_PARTITION_TABLE="not-partition-table"

pwd=$(dirname "$0")
source "$pwd"/common/include.sh
source "$pwd"/common/db_ods_to_dwd.sh

function import_province_to_ods() {
  import_db_to_hdfs \
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
    "$NOT_PARTITION_TABLE"
}

function import_user_to_ods() {
  import_db_to_hdfs \
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

function import_favor_info_to_ods() {
  import_db_to_hdfs \
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

function import_commodity_to_ods() {
  import_db_to_hdfs \
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

function import_trade_marker_to_ods() {
    import_db_to_hdfs \
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

function import_category_1_to_ods() {
    import_db_to_hdfs \
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
    "ods_category_1_db" \
    "$NOT_PARTITION_TABLE"
}

function import_category_2_to_ods() {
  import_db_to_hdfs \
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
    "ods_category_2_db" \
    "$NOT_PARTITION_TABLE"
}

function import_category_3_to_ods() {
  import_db_to_hdfs \
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
    "ods_category_3_db" \
    "$NOT_PARTITION_TABLE"
}

function import_payment_info_to_ods() {
  import_db_to_hdfs \
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

function import_order_status_transition_to_ods() {
  import_db_to_hdfs \
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

function import_evaluation_to_ods() {
  import_db_to_hdfs \
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

function import_cart_item_to_ods() {
  import_db_to_hdfs \
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

function import_order_to_ods() {
  import_db_to_hdfs \
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

function import_order_item_ods() {
  import_db_to_hdfs \
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

#import_province_to_ods
#import_user_to_ods
#import_commodity_to_ods
#import_trade_marker_to_ods
#import_category_1_to_ods
#import_category_2_to_ods
#import_category_3_to_ods
#import_favor_info_to_ods
#import_payment_info_to_ods
#import_order_status_transition_to_ods
#import_evaluation_to_ods
#import_cart_item_to_ods
#import_order_to_ods
#import_order_item_ods

ods_to_dwd_dim_commodity_db