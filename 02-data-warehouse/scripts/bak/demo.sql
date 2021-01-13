select commodity_id,
       count(*)                 order_count, -- 被下单次数
       sum(count)               order_num,   -- 被下单件数
       sum(count * final_price) order_amount
from dwd_fact_order_item_db
where dt = '2020-12-31'
group by commodity_id;

select commodity_id,
       count(*)                 order_count, -- 被下单次数
       sum(count)               order_num,   -- 被下单件数
       sum(count * final_price) order_amount
from dwd_fact_order_item_db
where dt = '2020-12-31'
  and order_id in
      (
          select order_id
          from dwd_fact_payment_info_db
          where dt = '2020-12-31'
      )
group by commodity_id;

select commodity_id,
       count(*) cart_count -- 商品被加购次数
from dwd_fact_cart_item_db
where dt = '2020-12-31'
group by commodity_id;

select commodity_id,
       count(*) fav_count -- 商品被收藏次数
from dwd_fact_favor_info_db
where dt = '2020-12-31'
group by commodity_id;


select oi.commodity_id               as commodity_id,
       sum(if(e.level = '好评', 1, 0)) as evaluation_count_1,
       sum(if(e.level = '中评', 1, 0)) as evaluation_count_2,
       sum(if(e.level = '差评', 1, 0)) as evaluation_count_3
from dwd_fact_order_item_db oi
         left join dwd_fact_evaluation_db e
                   on oi.order_id = e.order_id
where oi.dt = '2020-12-31'
  and e.dt = '2020-12-31'
group by oi.commodity_id;

select oi.commodity_id               as commodity_id,
       sum(if(e.level = '好评', 1, 0)) as evaluation_count_1,
       sum(if(e.level = '中评', 1, 0)) as evaluation_count_2,
       sum(if(e.level = '差评', 1, 0)) as evaluation_count_3
from dwd_fact_order_item_db oi
         left join dwd_fact_evaluation_db e
                   on oi.order_id = e.order_id
group by oi.commodity_id