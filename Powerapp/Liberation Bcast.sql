set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;


CREATE TABLE tmp_liberation_mins (phone varchar(12) not null, brand varchar(20), primary key (phone));
CREATE TABLE tmp_bcast_liberation_mins (phone varchar(12) not null, brand varchar(20) not null, user_type varchar(20) not null, primary key (phone));
CREATE TABLE tmp_weekly_usage (phone varchar(12), datein date, brand varchar(20), hits int(11), primary key (phone, datein));


truncate table tmp_liberation_mins;
truncate table tmp_bcast_liberation_mins;
truncate table tmp_weekly_usage;

insert into tmp_liberation_mins select phone, max(brand) brand from powerapp_log where datein >= '2014-09-26' and plan = 'MYVOLUME' group by phone;
insert into tmp_weekly_usage
select phone, left(datein,10) date, max(brand), count(1) hits from powerapp_log where datein >= '2014-10-13' and datein < '2014-10-19' and plan <> 'MYVOLUME' group by 1,2;

insert into tmp_bcast_liberation_mins select phone, max(brand), '5_7' from tmp_weekly_usage a where exists (select 1 from tmp_liberation_mins b where a.phone=b.phone) group by phone having count(1) >= 5;
insert into tmp_bcast_liberation_mins select phone, max(brand), '3_4' from tmp_weekly_usage a where exists (select 1 from tmp_liberation_mins b where a.phone=b.phone) group by phone having count(1) between 3 and 4;
insert into tmp_bcast_liberation_mins select phone, max(brand), '1_2' from tmp_weekly_usage a where exists (select 1 from tmp_liberation_mins b where a.phone=b.phone) group by phone having count(1) < 3;


select phone into outfile '/tmp/BUDDY_ACTIVE_1_20141020.csv' fields terminated by ',' lines terminated by '\n' from tmp_bcast_liberation_mins where brand = 'BUDDY' and user_type= '3_4';
select phone into outfile '/tmp/BUDDY_ACTIVE_2_20141020.csv' fields terminated by ',' lines terminated by '\n' from tmp_bcast_liberation_mins where brand = 'BUDDY' and user_type= '5_7';
select phone into outfile '/tmp/BUDDY_INACTIVE_20141020.csv' fields terminated by ',' lines terminated by '\n' from tmp_bcast_liberation_mins where brand = 'BUDDY' and user_type= '1_2';
select phone into outfile '/tmp/TNT_ACTIVE_1_20141020.csv' fields terminated by ',' lines terminated by '\n' from tmp_bcast_liberation_mins where brand = 'TNT' and user_type= '3_4';
select phone into outfile '/tmp/TNT_ACTIVE_2_20141020.csv' fields terminated by ',' lines terminated by '\n' from tmp_bcast_liberation_mins where brand = 'TNT' and user_type= '5_7';
select phone into outfile '/tmp/TNT_INACTIVE_20141020.csv' fields terminated by ',' lines terminated by '\n' from tmp_bcast_liberation_mins where brand = 'TNT' and user_type= '1_2';

