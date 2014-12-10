set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;

639474296630
639399369648
639188039134
639188882728
639188088585
639189087704


CREATE TABLE tmp_liberation_mins (phone varchar(12) not null, brand varchar(20), primary key (phone));
CREATE TABLE tmp_bcast_liberation_mins (phone varchar(12) not null, brand varchar(20) not null, user_type varchar(20) not null, primary key (phone));
CREATE TABLE tmp_weekly_usage (phone varchar(12), datein date, brand varchar(20), hits int(11), primary key (phone, datein));

-- 
-- Every Monday
-- 
-- truncate table tmp_liberation_mins;
truncate table tmp_weekly_usage;
truncate table tmp_bcast_liberation_mins;

select max(datein) from tmp_liberation_mins;
insert ignore into tmp_liberation_mins select phone, max(brand) brand, min(datein) from powerapp_flu.powerapp_log where datein >= '2014-11-14' and plan = 'MYVOLUME' group by phone;
insert into tmp_weekly_usage
select phone, left(datein,10) date, max(brand), count(1) hits from powerapp_log where datein >= '2014-11-10' and datein < '2014-11-17' and plan <> 'MYVOLUME' group by 1,2;

insert into tmp_bcast_liberation_mins select phone, max(brand), '5_7', 0 from tmp_weekly_usage a where exists (select 1 from tmp_liberation_mins b where a.phone=b.phone) group by phone having count(1) >= 5;
insert into tmp_bcast_liberation_mins select phone, max(brand), '3_4', 0 from tmp_weekly_usage a where exists (select 1 from tmp_liberation_mins b where a.phone=b.phone) group by phone having count(1) between 3 and 4;
insert into tmp_bcast_liberation_mins select phone, max(brand), '1_2', 0 from tmp_weekly_usage a where exists (select 1 from tmp_liberation_mins b where a.phone=b.phone) group by phone having count(1) < 3;


-- 
-- Every Monday Broadcast
-- 
select phone into outfile '/tmp/BUDDY_ACTIVE_1_20141117.csv' fields terminated by ',' lines terminated by '\n' from tmp_bcast_liberation_mins where brand = 'BUDDY' and user_type= '3_4';
select phone into outfile '/tmp/BUDDY_ACTIVE_2_20141117.csv' fields terminated by ',' lines terminated by '\n' from tmp_bcast_liberation_mins where brand = 'BUDDY' and user_type= '5_7';
select phone into outfile '/tmp/BUDDY_INACTIVE_20141117.csv' fields terminated by ',' lines terminated by '\n' from tmp_bcast_liberation_mins where brand = 'BUDDY' and user_type= '1_2';
select phone into outfile '/tmp/TNT_ACTIVE_1_20141117.csv' fields terminated by ',' lines terminated by '\n' from tmp_bcast_liberation_mins where brand = 'TNT' and user_type= '3_4';
select phone into outfile '/tmp/TNT_ACTIVE_2_20141117.csv' fields terminated by ',' lines terminated by '\n' from tmp_bcast_liberation_mins where brand = 'TNT' and user_type= '5_7';
select phone into outfile '/tmp/TNT_INACTIVE_20141117.csv' fields terminated by ',' lines terminated by '\n' from tmp_bcast_liberation_mins where brand = 'TNT' and user_type= '1_2';



-- 
-- Every Saturday / Monday / Wednesday Broadcast
-- 
set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;
insert ignore into tmp_liberation_mins select phone, max(brand), min(datein) from powerapp_log where datein >= '2014-11-10' and plan = 'MYVOLUME' group by phone;
truncate table tmp_weekly_usage;
insert into tmp_weekly_usage
select phone, max(left(datein,10)) date, max(brand), count(1) hits from powerapp_flu.powerapp_log where datein >= '2014-11-10' and plan <> 'MYVOLUME' group by 1;
-- current
select brand, count(1) from tmp_liberation_mins a where datein > '2014-11-01' and datein < '2014-11-07' group by brand;
-- lapsed
select brand, count(1) from tmp_liberation_mins a where datein < '2014-11-01' and not exists (select 1 from tmp_weekly_usage b where a.phone=b.phone) group by brand;

-- Monday Broadcast
select phone into outfile '/tmp/BUDDY_CUR_20141117.csv' fields terminated by ',' lines terminated by '\n' from tmp_liberation_mins a where datein > '2014-11-03' and datein < '2014-11-09' and brand='BUDDY' and not exists (select 1 from tmp_bcast_liberation_mins c where a.phone = c.phone);
select phone into outfile '/tmp/TNT_CUR_20141117.csv' fields terminated by ',' lines terminated by '\n' from tmp_liberation_mins a where datein > '2014-11-03' and datein < '2014-11-09' and brand='TNT' and not exists (select 1 from tmp_bcast_liberation_mins c where a.phone = c.phone);
select phone into outfile '/tmp/BUDDY_LAP_20141117.csv' fields terminated by ',' lines terminated by '\n' from tmp_liberation_mins a where datein >= '2014-10-27' and datein < '2014-11-03' and brand='BUDDY' and not exists (select 1 from tmp_weekly_usage b where a.phone=b.phone) and not exists (select 1 from tmp_bcast_liberation_mins c where a.phone = c.phone);
select phone into outfile '/tmp/TNT_LAP_20141117.csv' fields terminated by ',' lines terminated by '\n' from tmp_liberation_mins a where datein >= '2014-10-27' and datein < '2014-11-03' and brand='TNT' and not exists (select 1 from tmp_weekly_usage b where a.phone=b.phone) and not exists (select 1 from tmp_bcast_liberation_mins c where a.phone = c.phone);

-- Wednesday & Saturday Broadcast
select phone into outfile '/tmp/BUDDY_CUR_20141117.csv' fields terminated by ',' lines terminated by '\n' from tmp_liberation_mins a where datein > '2014-11-10' and datein < '2014-11-16' and brand='BUDDY';
select phone into outfile '/tmp/TNT_CUR_20141117.csv' fields terminated by ',' lines terminated by '\n' from tmp_liberation_mins a where datein > '2014-11-10' and datein < '2014-11-16' and brand='TNT';
select phone into outfile '/tmp/BUDDY_LAP_20141117.csv' fields terminated by ',' lines terminated by '\n' from tmp_liberation_mins a where datein >= '2014-11-03' and datein < '2014-11-10' and brand='BUDDY' and not exists (select 1 from tmp_weekly_usage b where a.phone=b.phone);
select phone into outfile '/tmp/TNT_LAP_20141117.csv' fields terminated by ',' lines terminated by '\n' from tmp_liberation_mins a where datein >= '2014-11-03' and datein < '2014-11-10' and brand='TNT' and not exists (select 1 from tmp_weekly_usage b where a.phone=b.phone);

truncate table tmp_plan_users;
load data local infile '/tmp/BUDDY_CUR_20141117.csv' into table tmp_plan_users (phone, brand, plan, bcast_dt, source) set brand='BUDDY', plan='LIBERATION',bcast_dt='2014-11-15',source='LIBERATION';
load data local infile '/tmp/TNT_CUR_20141117.csv' into table tmp_plan_users (phone, brand, plan, bcast_dt, source) set brand='TNT', plan='LIBERATION',bcast_dt='2014-11-15',source='LIBERATION';
load data local infile '/tmp/BUDDY_LAP_20141117.csv' into table tmp_plan_users (phone, brand, plan, bcast_dt, source) set brand='BUDDY', plan='LIBERATION',bcast_dt='2014-11-15',source='LIBERATION';
load data local infile '/tmp/TNT_LAP_20141117.csv' into table tmp_plan_users (phone, brand, plan, bcast_dt, source) set brand='TNT', plan='LIBERATION',bcast_dt='2014-11-15',source='LIBERATION';

echo "call sp_generate_bcast_mins('2014-11-14', '2014-11-15', 'N', 350000, 0, 'ALLDAY', 1000000, 'YOUTUBE', 1000000)" | mysql -uroot -p -S/mnt/dbrep3307/mysql.sock archive_powerapp_flu
