insert overwrite table dwt_device_startup_topic
select nvl(new.device_id, old.device_id),
       if(old.login_date_first is null, '2021-01-10', old.login_date_first),
       if(new.count > 0, '2021-01-10', old.login_date_last),
       nvl(old.login_count, 0) + if(new.count > 0, 1, 0)
from dwt_device_startup_topic as old
         full outer join (
    select device_id,
           count(*) as count
    from dws_device_startup_daycount
    where dt = '2021-01-10'
    group by device_id) new
                         on
                             new.device_id = old.device_id;