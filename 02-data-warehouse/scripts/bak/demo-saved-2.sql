insert overwrite table dwt_user_topic
select nvl(new.user_id, old.user_id),
       if(old.login_date_first is null and new.login_count > 0, '2021-01-01', old.login_date_first), -- ???
       if(new.login_count > 0, '2021-01-01', old.login_date_last),
       nvl(old.login_count, 0) + nvl(new.login_count, 0),
       nvl(new.login_last_7d_count, 0),
       nvl(new.login_last_30d_count, 0),
       if(old.order_date_first is null and new.order_count > 0, '2021-01-01', old.order_date_first),
       if(new.order_count > 0, '2021-01-01', old.order_date_last),
       nvl(old.order_count, 0) + nvl(new.order_count, 0),
       nvl(new.order_last_7d_count, 0),
       nvl(new.order_last_30d_count, 0),
       if(old.payment_date_first is null and new.payment_count > 0, '2021-01-01', old.payment_date_first),
       if(new.payment_count > 0, '2021-01-01', old.payment_date_last),
       nvl(old.payment_count, 0) + nvl(new.payment_count, 0),
       nvl(old.payment_amount, 0) + nvl(new.payment_amount, 0),
       nvl(new.payment_last_7d_count, 0),
       nvl(new.payment_last_30d_count, 0),
       nvl(new.payment_last_7d_amount, 0),
       nvl(new.payment_last_30d_amount, 0)
from dwt_user_topic as old
    full outer join
     (
         select user_id,
                sum(if(dt = '2021-01-01', login_count, 0))                   login_count,
                sum(if(dt >= date_add('2021-01-01', -6), 1, 0))              login_last_7d_count,
                sum(if(login_count > 0, 1, 0))                               login_last_30d_count,
                sum(if(dt = '2021-01-01', order_count, 0))                   order_count,
                sum(if(dt >= date_add('2021-01-01', -6), order_count, 0))    order_last_7d_count,
                sum(order_count)                                             order_last_30d_count,
                sum(if(dt = '2021-01-01', payment_count, 0))                 payment_count,
                sum(if(dt >= date_add('2021-01-01', -6), payment_count, 0))  payment_last_7d_count,
                sum(payment_count)                                           payment_last_30d_count,
                sum(if(dt = '2021-01-01', payment_amount, 0))                payment_amount,
                sum(if(dt >= date_add('2021-01-01', -6), payment_amount, 0)) payment_last_7d_amount,
                sum(payment_amount)                                          payment_last_30d_amount
         from dws_user_action_daycount
         where dt >= date_add('2021-01-01', -29)
         group by user_id
     ) as new
on new.user_id = old.user_id;