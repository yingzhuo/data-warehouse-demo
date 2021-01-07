insert overwrite table dwd_fact_order_item_db partition (dt = '1970-01-01')
select id,
       order_id,
       user_id,
       commodity_id,
       count,
       final_price,
       created_date,
       last_updated_date
from ods_order_item_db
where dt = '1970-01-01';