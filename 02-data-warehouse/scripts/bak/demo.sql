with tmp_order as (
    select commodity_id,
           count(*)                 order_count, -- 被下单次数
           sum(count)               order_num,   -- 被下单件数
           sum(count * final_price) order_amount
    from dwd_fact_order_item_db
    where dt = '1970-01-01'
    group by commodity_id
),
     tmp_payment as (
         select commodity_id,
                count(*)                 payment_count, -- 被支付次数
                sum(count)               payment_num,   -- 被支付件数
                sum(count * final_price) payment_amount -- 被支付金额
         from dwd_fact_order_item_db
         where dt = '1970-01-01'
           and order_id in
               (
                   select order_id
                   from dwd_fact_payment_info_db
                   where dt = '1970-01-01'
               )
         group by commodity_id
     ),
     tmp_cart as (
         select commodity_id,
                count(*) cart_count -- 商品被加购次数
         from dwd_fact_cart_item_db
         where dt = '1970-01-01'
         group by commodity_id
     ),
     tmp_fav as (
         select commodity_id,
                count(*) fav_count -- 商品被收藏次数
         from dwd_fact_favor_info_db
         where dt = '1970-01-01'
         group by commodity_id
     ),
     tmp_eva as (
         select commodity_id,
                sum(if(level = '好评', 1, 0)) as evaluation_count_1,
                sum(if(level = '中评', 1, 0)) as evaluation_count_2,
                sum(if(level = '差评', 1, 0)) as evaluation_count_3
         from dwd_fact_evaluation_db
         where dt = '1970-01-01'
         group by commodity_id
     )
insert
into table dws_commodity_action_daycount partition (dt = '1970-01-01')
select coalesce(tmp_order.commodity_id,
                tmp_payment.commodity_id,
                tmp_cart.commodity_id,
                tmp_fav.commodity_id,
                tmp_eva.commodity_id),
       nvl(tmp_order.order_count, 0),
       nvl(tmp_order.order_num, 0),
       nvl(tmp_order.order_amount, 0),
       nvl(tmp_payment.payment_count, 0),
       nvl(tmp_payment.payment_num, 0),
       nvl(tmp_payment.payment_amount, 0),
       nvl(tmp_cart.cart_count, 0),
       nvl(tmp_fav.fav_count, 0),
       nvl(tmp_eva.evaluation_count_1, 0),
       nvl(tmp_eva.evaluation_count_2, 0),
       nvl(tmp_eva.evaluation_count_3, 0)
from tmp_order
         full outer join tmp_payment on tmp_order.commodity_id = tmp_payment.commodity_id
         full outer join tmp_cart on tmp_order.commodity_id = tmp_cart.commodity_id
         full outer join tmp_fav on tmp_order.commodity_id = tmp_fav.commodity_id
         full outer join tmp_eva on tmp_order.commodity_id = tmp_eva.commodity_id;