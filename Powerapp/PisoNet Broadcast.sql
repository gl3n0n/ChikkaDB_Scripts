insert ignore into powerapp_optout_users select phone, max(datein), max(brand) from powerapp_optout_log group by phone;
Rica - 639399369648
Bong - 639474296630
Victor-639188039134
show tables like '%piso%';
truncate table tmp_pisonet_active_app_users;
truncate table tmp_pisonet_active_users;
truncate table tmp_pisonet_inactive_sms_users;

SERVER: PROD-DB (powerapp_flu)

# Active Users
create table tmp_pisonet_active_app_users (phone varchar(12) not null, datein datetime, hits int(11), flag smallint(1), primary key (phone));
truncate table tmp_pisonet_active_app_users;
insert into tmp_pisonet_active_app_users (phone, datein, hits, flag)
select phone, datein, hits, 0 
from ( select phone, max(datein) datein, count(1) hits 
       from   powerapp_log a
       where  datein > date_sub(curdate(), interval 7 day) 
       and    source in ('smartphone', 'sms_app')
       and    not exists (select 1 from powerapp_optout_users b where a.phone = b.phone)
       group  by phone order by hits desc) t 
limit 5000;

update tmp_pisonet_active_app_users set flag=1 
where phone in (select phone from (select phone from tmp_pisonet_active_app_users order by hits desc, datein desc limit 998) t );

select phone from tmp_pisonet_active_app_users order by hits desc, datein desc limit 998;
select phone from tmp_pisonet_active_app_users where flag=1 order by 1 desc;


# Inactive Users
create table tmp_pisonet_active_users (phone varchar(12) not null, datein datetime, hits int(11), primary key (phone));
insert into tmp_pisonet_active_users 
select phone, datein, hits 
from ( select phone, max(datein) datein, count(1) hits 
       from   powerapp_log a
       where  datein > date_sub(curdate(), interval 14 day) 
       and    not exists (select 1 from powerapp_optout_users b where a.phone = b.phone)
       group  by phone order by hits desc) t;

create table tmp_pisonet_inactive_sms_users (phone varchar(12) not null, datein datetime, hits int(11), primary key (phone));
insert into tmp_pisonet_inactive_sms_users (phone, datein, hits, brand)
select phone, datein, hits, brand 
from ( select phone, max(datein) datein, count(1) hits, min(brand) brand 
       from   powerapp_log a
       where  datein < date_sub(curdate(), interval 14 day) 
       and    source = 'sms_user'
       and    brand <> 'TNT'
       and    not exists (select 1 from powerapp_optout_users b where a.phone = b.phone)
       and    not exists (select 1 from tmp_pisonet_active_users c where a.phone = c.phone)
       and    not exists (select 1 from tmp_pisonet_inactive_sms_users_bk d where a.phone = d.phone)
       group  by phone order by datein desc) t
limit 2000;

update tmp_pisonet_inactive_sms_users set flag=1 
where flag=0 and phone in (select phone from (select phone from tmp_pisonet_inactive_sms_users where flag = 0 order by datein desc, hits desc limit 1000) t );
select phone from tmp_pisonet_inactive_sms_users where flag = 1 order by datein desc limit 1000;


## For Facebook broadcast (archive db)

   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;


sp_generate_inactive_list()

select * from powerapp_log where phone in (
'639214591092','639214595770','639214596134','639214597698','639214597750'
);

+---------------------+--------------+-------+-------------+----------+---------------------+---------------------+----------+
| datein              | phone        | brand | plan        | validity | start_tm            | end_tm              | source   |
+---------------------+--------------+-------+-------------+----------+---------------------+---------------------+----------+
| 2014-06-06 15:27:40 | 639214597750 | BUDDY | FREE_SOCIAL |    86400 | 2014-06-06 15:27:39 | 2014-06-07 15:27:39 | web      |
| 2014-06-08 16:06:22 | 639214597698 | BUDDY | FREE_SOCIAL |    86400 | 2014-06-08 16:06:22 | 2014-06-09 16:06:22 | sms_user |
| 2014-06-09 16:16:18 | 639214596134 | BUDDY | FREE_SOCIAL |    86400 | 2014-06-09 16:16:17 | 2014-06-10 16:16:17 | sms_user |
+---------------------+--------------+-------+-------------+----------+---------------------+---------------------+----------+
3 rows in set (1.13 sec)

 