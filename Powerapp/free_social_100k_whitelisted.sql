chikka_apn_checker:key:639206661888
create table tmp_chikka_apn (phone varchar(12) not null, primary key (phone));
create table tmp_chikka_apn_stg (phone varchar(40) not null, primary key (phone));
load data local infile '/tmp/chikka_apn_2014-07-08_235901.txt' into table tmp_chikka_apn_stg fields terminated by ',';                  
insert into tmp_chikka_apn (phone) select replace(phone, 'chikka_apn_checker:key:','') from tmp_chikka_apn_stg;


select min(datein) from powerapp_log where plan ='FREE_SOCIAL' and datein >= '2014-05-01';
1. select count(1) from tmp_whitelisted_free_social a where exists (select 1 from tmp_chikka_apn b where a.phone = b.phone);
2. select count(1) from tmp_whitelisted_free_social a where exists (select 1 from powerapp_optout_log b where b.datein >= '2014-05-15' and a.phone = b.phone);

3. create temporary table tmp_plan_active_users (phone varchar(12) not null, datein datetime, primary key (phone));
   TRUNCATE TABLE tmp_plan_active_users;
   insert into tmp_plan_active_users select phone, min(datein) datein from powerapp_log b where b.datein >= '2014-05-15 00:00:00' and b.plan ='FREE_SOCIAL' AND source like 'auto_opt_in_whitelisted' group by phone;
   select count(1) from tmp_whitelisted_free_social a where exists (select 1 from tmp_plan_active_users b where a.phone = b.phone);
   select phone, datein from tmp_plan_active_users group by phone order by phone; 

1) how many are still in the Chikka APN - 51550
2) how many opted-out - 163
3) who have been activated (given Free Social) and when - 7088
