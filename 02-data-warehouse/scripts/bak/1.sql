insert overwrite table dwd_fact_cart_item_db partition (dt = '1970-01-01')
select id,
       commodity_id,
       count,
       final_price,
       user_id,
       created_date,
       last_updated_date
from ods_cart_item_db
where dt = '1970-01-01';