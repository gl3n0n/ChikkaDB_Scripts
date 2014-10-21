set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;

-- New SMS and Smartphone Users
drop temporary table if exists tmp_current_smart_user;
drop temporary table if exists tmp_new_smart_user;
create temporary table tmp_current_smart_user (phone varchar(12) not null, week_no int(3) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone, week_no));
create temporary table tmp_new_smart_user (phone varchar(12) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone));
insert into tmp_current_smart_user select phone, week(datein), count(1), group_concat(distinct plan ) from powerapp_log a
where datein >= date_sub(curdate(), interval 30 day) and free='false' and source = 'smartphone' and brand='BUDDY'
and exists (select 1 from powerapp_flu.new_subscribers b where a.phone = b.phone and b.datein > date_sub(curdate(), interval 30 day))
group by 1,2;
insert into tmp_new_smart_user select phone, sum(hits), group_concat(distinct plan) 
from tmp_current_smart_user a 
where not exists (select 1 from tmp_repeater_mins b where a.phone=b.phone)
group by phone having count(1) = 1 limit 2000;

drop temporary table if exists tmp_current_sms_user;
drop temporary table if exists tmp_new_sms_user;
create temporary table tmp_current_sms_user (phone varchar(12) not null, week_no int(3) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone, week_no));
create temporary table tmp_new_sms_user (phone varchar(12) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone));
insert into tmp_current_sms_user select phone, week(datein), count(1), group_concat(distinct plan ) from powerapp_log a
where datein >= date_sub(curdate(), interval 30 day) and free='false' and source like 'sms%'  and brand='BUDDY'
and not exists (select 1 from tmp_current_smart_user b where a.phone = b.phone ) 
and exists (select 1 from powerapp_flu.new_subscribers b where a.phone = b.phone and b.datein > date_sub(curdate(), interval 30 day))
group by 1,2;
insert into tmp_new_sms_user select phone, sum(hits), group_concat(distinct plan) 
from tmp_current_sms_user a
where not exists (select 1 from tmp_new_smart_user b where a.phone=b.phone)
and   not exists (select 1 from tmp_repeater_mins b where a.phone=b.phone)
group by phone having count(1) = 1 limit 2000;


select phone into outfile '/tmp/new_sms_4a.csv' fields terminated by '|' from tmp_new_sms_user;
select phone into outfile '/tmp/new_smart_4a.csv' fields terminated by '|' from tmp_new_smart_user;


-- Lapsed SMS and Smartphone Users
drop temporary table if exists tmp_current_user;
drop temporary table if exists tmp_lapsed_sms_user;
drop temporary table if exists tmp_lapsed_smart_user;
create temporary table tmp_current_user (phone varchar(12) not null, week_no int(3) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone, week_no));
create temporary table tmp_lapsed_sms_user (phone varchar(12) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone));
create temporary table tmp_lapsed_smart_user (phone varchar(12) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone));

insert into tmp_current_user select phone, week(datein), count(1), group_concat(distinct plan ) 
from powerapp_log where datein >= date_sub(curdate(), interval 30 day) and free='false' and brand='BUDDY' 
group by 1,2;
insert into tmp_lapsed_smart_user select phone, count(1), group_concat(distinct plan ) 
from powerapp_log a 
where datein > date_sub(curdate(), interval 40 day) and datein < date_sub(curdate(), interval 30 day) and free='false' and source = 'smartphone' and brand='BUDDY'
and   not exists (select 1 from tmp_current_user b where a.phone = b.phone) 
and   not exists (select 1 from tmp_repeater_mins b where a.phone=b.phone)
and   not exists (select 1 from tmp_new_sms_user b where a.phone=b.phone)
and   not exists (select 1 from tmp_new_smart_user b where a.phone=b.phone)
group by 1 limit 2000;

insert into tmp_lapsed_sms_user select phone, count(1), group_concat(distinct plan ) 
from powerapp_log a 
where datein > date_sub(curdate(), interval 40 day) and datein < date_sub(curdate(), interval 30 day) and free='false' and source like 'sms%' and brand='BUDDY'
and   not exists (select 1 from tmp_current_user b where a.phone = b.phone) 
and   not exists (select 1 from tmp_repeater_mins b where a.phone=b.phone)
and   not exists (select 1 from tmp_new_sms_user b where a.phone=b.phone)
and   not exists (select 1 from tmp_new_smart_user b where a.phone=b.phone)
and not exists (select 1 from tmp_lapsed_smart_user b where a.phone = b.phone) 
group by 1 limit 2000;

select phone into outfile '/tmp/lapsed_sms_4a.csv' fields terminated by '|' from tmp_lapsed_sms_user;
select phone into outfile '/tmp/lapsed_smart_4a.csv' fields terminated by '|' from tmp_lapsed_smart_user;



-- Current SMS and Smartphone Users
drop temporary table if exists tmp_current_user;
drop temporary table if exists tmp_current_sms_user;
create temporary table tmp_current_user (phone varchar(12) not null, week_no int(3) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone, week_no));
create temporary table tmp_current_sms_user (phone varchar(12) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone));
insert into tmp_current_user select phone, week(datein), count(1), group_concat(distinct plan ) 
from powerapp_log where datein >= date_sub(curdate(), interval 90 day) and free='false' and source like 'sms%' and brand='BUDDY' group by 1,2;
insert into tmp_current_sms_user select phone, sum(hits), group_concat(distinct plan) 
from tmp_current_user a
where not exists (select 1 from tmp_repeater_mins b where a.phone=b.phone)
and   not exists(select 1 from tmp_lapsed_sms_user b where a.phone=b.phone) 
and   not exists(select 1 from tmp_lapsed_smart_user b where a.phone=b.phone) 
and   not exists (select 1 from tmp_new_sms_user b where a.phone=b.phone)
and   not exists (select 1 from tmp_new_smart_user b where a.phone=b.phone)
group by phone having count(1) = 14 limit 2000;

drop temporary table if exists tmp_current_user;
drop temporary table if exists tmp_current_smart_user;
create temporary table tmp_current_user (phone varchar(12) not null, week_no int(3) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone, week_no));
create temporary table tmp_current_smart_user (phone varchar(12) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone));
insert into tmp_current_user select phone, week(datein), count(1), group_concat(distinct plan ) 
from powerapp_log where datein >= date_sub(curdate(), interval 90 day) and free='false' and source = 'smartphone' and brand='BUDDY' group by 1,2;
insert into tmp_current_smart_user select phone, sum(hits), group_concat(distinct plan) from tmp_current_user a 
where  not exists (select 1 from tmp_repeater_mins b where a.phone=b.phone)
and   not exists(select 1 from tmp_current_sms_user b where a.phone=b.phone) 
and   not exists(select 1 from tmp_lapsed_sms_user b where a.phone=b.phone) 
and   not exists(select 1 from tmp_lapsed_smart_user b where a.phone=b.phone) 
and   not exists (select 1 from tmp_new_sms_user b where a.phone=b.phone)
and   not exists (select 1 from tmp_new_smart_user b where a.phone=b.phone)
group by phone having count(1) = 14 limit 2000;

select phone into outfile '/tmp/current_sms_4a.csv' fields terminated by '|' from tmp_current_sms_user;
select phone into outfile '/tmp/current_smart_4a.csv' fields terminated by '|' from tmp_current_smart_user;

select phone, count(1), min(seq_no), max(seq_no) from (
select '1' seq_no, phone from tmp_new_sms_user union
select '2' seq_no, phone from tmp_new_smart_user union
select '3' seq_no, phone from tmp_lapsed_sms_user union
select '4' seq_no, phone from tmp_lapsed_smart_user union
select '5' seq_no, phone from tmp_current_sms_user union
select '6' seq_no, phone from tmp_current_smart_user) t group by phone having count(1)> 1;


load data local infile '/tmp/new_sms_2.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/new_smart_2.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/lapsed_sms_2.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/lapsed_smart_2.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/current_sms_2.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/current_smart_2.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/new_sms_3.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/new_smart_3.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/lapsed_sms_3.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/lapsed_smart_3.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/current_sms_3.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/current_smart_3.csv' ignore into table tmp_repeater_mins;

load data local infile '/tmp/new_sms_4a.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/new_smart_4a.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/lapsed_sms_4a.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/lapsed_smart_4a.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/current_sms_4a.csv' ignore into table tmp_repeater_mins;
load data local infile '/tmp/current_smart_4a.csv' ignore into table tmp_repeater_mins;


--- SMS ONLY
set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;


-- New SMS and Smartphone Users
drop temporary table if exists tmp_current_user;
drop temporary table if exists tmp_new_sms_user;
create temporary table tmp_current_user (phone varchar(12) not null, week_no int(3) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone, week_no));
create temporary table tmp_new_sms_user (phone varchar(12) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone));
insert into tmp_current_user select phone, week(datein), count(1), group_concat(distinct plan ) from powerapp_log a
where datein >= date_sub(curdate(), interval 30 day) and free='false' and source like 'sms%' 
and exists (select 1 from powerapp_flu.new_subscribers b where a.phone = b.phone and b.datein > date_sub(curdate(), interval 30 day))
group by 1,2;
insert into tmp_new_sms_user select phone, sum(hits), group_concat(distinct plan) 
from tmp_current_user a
where not exists (select 1 from tmp_repeater_mins b where a.phone=b.phone)
group by phone having count(1) = 1 limit 500;

drop temporary table if exists tmp_current_user;
drop temporary table if exists tmp_new_smart_user;
create temporary table tmp_current_user (phone varchar(12) not null, week_no int(3) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone, week_no));
create temporary table tmp_new_smart_user (phone varchar(12) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone));
insert into tmp_current_user select phone, week(datein), count(1), group_concat(distinct plan ) from powerapp_log a
where datein >= date_sub(curdate(), interval 30 day) and free='false' and source = 'smartphone'
and exists (select 1 from powerapp_flu.new_subscribers b where a.phone = b.phone and b.datein > date_sub(curdate(), interval 30 day))
group by 1,2;
insert into tmp_new_smart_user select phone, sum(hits), group_concat(distinct plan) 
from tmp_current_user a 
where not exists (select 1 from tmp_new_sms_user b where a.phone=b.phone) 
group by phone having count(1) = 1 limit 500;

select phone into outfile '/tmp/new_sms_2.csv' fields terminated by '|' from tmp_new_sms_user;
select phone into outfile '/tmp/new_smart.csv' fields terminated by '|' from tmp_new_smart_user;

-- Lapsed SMS and Smartphone Users
drop temporary table if exists tmp_current_user;
drop temporary table if exists tmp_lapsed_sms_user;
drop temporary table if exists tmp_lapsed_smart_user;
create temporary table tmp_current_user (phone varchar(12) not null, week_no int(3) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone, week_no));
create temporary table tmp_lapsed_sms_user (phone varchar(12) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone));
create temporary table tmp_lapsed_smart_user (phone varchar(12) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone));

insert into tmp_current_user select phone, week(datein), count(1), group_concat(distinct plan ) from powerapp_log where datein >= date_sub(curdate(), interval 30 day) and free='false' group by 1,2;
insert into tmp_lapsed_sms_user select phone, count(1), group_concat(distinct plan ) 
from powerapp_log a 
where datein > date_sub(curdate(), interval 40 day) and datein < date_sub(curdate(), interval 30 day) and free='false' and source like 'sms%' 
and not exists (select 1 from tmp_current_user b where a.phone = b.phone) 
group by 1 limit 500;
insert into tmp_lapsed_smart_user select phone, count(1), group_concat(distinct plan ) 
from powerapp_log a 
where datein > date_sub(curdate(), interval 40 day) and datein < date_sub(curdate(), interval 30 day) and free='false' and source = 'smartphone' 
and not exists (select 1 from tmp_current_user b where a.phone = b.phone) 
and not exists (select 1 from tmp_lapsed_sms_user b where a.phone = b.phone) 
group by 1 limit 500;

select phone into outfile '/tmp/lapsed_sms_2.csv' fields terminated by '|' from tmp_lapsed_sms_user;
select phone into outfile '/tmp/lapsed_smart.csv' fields terminated by '|' from tmp_lapsed_smart_user;



-- Current SMS and Smartphone Users
drop temporary table if exists tmp_current_user;
drop temporary table if exists tmp_current_sms_user;
create temporary table tmp_current_user (phone varchar(12) not null, week_no int(3) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone, week_no));
create temporary table tmp_current_sms_user (phone varchar(12) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone));
insert into tmp_current_user select phone, week(datein), count(1), group_concat(distinct plan ) from powerapp_log where datein >= date_sub(curdate(), interval 90 day) and free='false' and source like 'sms%' group by 1,2;
insert into tmp_current_sms_user select phone, sum(hits), group_concat(distinct plan) 
from tmp_current_user a
where not exists(select 1 from tmp_lapsed_sms_user b where a.phone=b.phone) 
and   not exists(select 1 from tmp_lapsed_smart_user b where a.phone=b.phone) 
group by phone having count(1) = 14 limit 500;

drop temporary table if exists tmp_current_user;
drop temporary table if exists tmp_current_smart_user;
create temporary table tmp_current_user (phone varchar(12) not null, week_no int(3) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone, week_no));
create temporary table tmp_current_smart_user (phone varchar(12) not null, hits int(11) default 0 not null, plan varchar(120), primary key (phone));
insert into tmp_current_user select phone, week(datein), count(1), group_concat(distinct plan ) from powerapp_log where datein >= date_sub(curdate(), interval 90 day) and free='false' and source = 'smartphone' group by 1,2;
insert into tmp_current_smart_user select phone, sum(hits), group_concat(distinct plan) from tmp_current_user a 
where not exists(select 1 from tmp_current_sms_user b where a.phone=b.phone) 
and   not exists(select 1 from tmp_lapsed_sms_user b where a.phone=b.phone) 
and   not exists(select 1 from tmp_lapsed_smart_user b where a.phone=b.phone) 
group by phone having count(1) = 14 limit 500;

select phone into outfile '/tmp/current_sms_2.csv' fields terminated by '|' from tmp_current_sms_user;
select phone into outfile '/tmp/current_smart.csv' fields terminated by '|' from tmp_current_smart_user;

select phone, count(1), min(seq_no), max(seq_no) from (
select '1' seq_no, phone from tmp_new_sms_user union
select '2' seq_no, phone from tmp_new_smart_user union
select '3' seq_no, phone from tmp_lapsed_sms_user union
select '4' seq_no, phone from tmp_lapsed_smart_user union
select '5' seq_no, phone from tmp_current_sms_user union
select '6' seq_no, phone from tmp_current_smart_user) t group by phone having count(1)> 1;






+--------------+------------+---------------+  +--------------+---------------+---------------+
| phone        | udr_usage  | Bandwidth     |  | phone        | udr_usage     | Bandwidth     |                                           
+--------------+------------+---------------+  +--------------+---------------+---------------+                                           
| 639198713194 | 35,166,421 | 2,029,187,753 |  | 639198713194 |   302,078,016 | 2,029,187,753 |                                           
| 639202485761 | 75,253,112 | 1,479,879,639 |  | 639202485761 | 1,428,904,870 | 1,479,879,639 |                                           
| 639214639480 | 11,581,732 | 1,289,772,465 |  | 639214639480 |    99,722,377 | 1,289,772,465 |                                           
| 639293610182 | 13,031,057 | 1,527,473,420 |  | 639293610182 |    80,359,952 | 1,527,473,420 |                                           
| 639298149416 | 17,020,795 | 1,755,271,490 |  | 639298149416 |   163,438,977 | 1,755,271,490 |                                           
| 639461936489 | 22,293,101 | 1,364,349,746 |  | 639461936489 |   275,955,322 | 1,364,349,746 |                                           
| 639468946160 |  1,129,471 | 1,602,553,060 |  | 639468946160 |    17,414,955 | 1,602,553,060 |                                           
| 639473863820 |  2,154,323 | 1,929,636,696 |  | 639473863820 |    10,676,872 | 1,929,636,696 |                                           
| 639496650700 |  1,402,301 | 2,138,911,978 |  | 639496650700 |    13,134,803 | 2,138,911,978 |                                           
| 639993514862 | 69,759,162 | 1,226,783,683 |  | 639993514862 | 1,156,404,061 | 1,226,783,683 |                                           
+--------------+------------+---------------+  +--------------+---------------+---------------+                                           
