#!/usr/bin/env bash
#------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#------------------------------------------------------------------------------------------------------------
export CUR_DATE="1970-01-01"
export NOT_PARTITION_TABLE="not-partition-table"

pwd=$(dirname "$0")
source "$pwd"/common/include.sh

function import_t_province_to_ods() {
  import_db_table_to_ods \
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
          1 = 1
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
      created_date,
      last_updated_date
    FROM
      t_commodity
    WHERE
      1 = 1
    " \
    "ods_commodity_db"
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
      1 = 1
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
      1 = 1
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
      1 = 1
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
      1 = 1
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
      1 = 1
    " \
    "ods_order_item_db"
}

import_t_province_to_ods
import_t_user_to_ods
import_t_favor_info_to_ods
import_t_commodity_to_ods
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
