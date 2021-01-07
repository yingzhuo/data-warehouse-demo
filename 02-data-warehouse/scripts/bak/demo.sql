insert overwrite table dwd_dim_user_db
select id,
       name,
       username,
       phone_number,
       avatar_url,
       email_addr,
       gender,
       'x', -- 密码脱敏
       created_date,
       last_updated_date,
       '1970-01-01',
       '9999-99-99'
from ods_user_db
where dt = '1970-01-01'
union all
select his.id,
       his.name,
       his.username,
       his.phone_number,
       his.avatar_url,
       his.email_addr,
       his.gender,
       'x', -- 密码脱敏
       his.created_date,
       his.last_updated_date,
       his.zip_start,
       if(u.id is not null and his.zip_end = '9999-99-99', date_add(u.dt, -1), his.zip_end)
from dwd_dim_user_db as his
         left join
     (select id, dt
      from ods_user_db
      where dt = '1970-01-01') as u
     on u.id = his.id;

select * from dwd_dim_user_db;