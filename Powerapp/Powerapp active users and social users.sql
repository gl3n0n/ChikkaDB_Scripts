[noc@jumpserv-hi10 ~]$ ssh noc@172.17.250.40
Last login: Mon Feb 17 16:21:55 2014 from 172.17.250.39
[noc@dbreplica-hi10 ~]$ mysql  -uroot -p --socket=/mnt/dbrep3307/mysql.sock --port=3307 archive_powerapp_flu




set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;

--Powerapp Active Users
drop table if exists active_user;
drop table if exists inactive_user;
create table active_user as select phone, min(datein) datein from powerapp_flu.powerapp_log where datein >= date_sub(now(), interval 1 day) group by phone;
alter table active_user add primary key (phone);

create table inactive_user as select phone, max(datein) datein from powerapp_flu.powerapp_log a where datein < date_sub(now(), interval 1 day) group by phone;
alter table inactive_user add primary key (phone);
insert ignore into  inactive_user select phone, max(datein) datein from powerapp_log a where datein < date_sub(now(), interval 1 day) group by phone;

select sum(active_user) Active_User, sum(inactive_user) Inactive_User, 
       sum(active_user+inactive_user) TotalUser,
       (sum(active_user) / sum(active_user+inactive_user)) * 100 Pct_Active,
       (sum(inactive_user) / sum(active_user+inactive_user)) * 100 Pct_Inctive  
from (
select count(1) active_user, 0 inactive_user from active_user union
select 0 active_user, count(1) inactive_user from inactive_user a where not exists (select 1 from active_user b where a.phone=b.phone) 
) a\G


  Active_User: 31442
Inactive_User: 183777

  Active_User: 34800
Inactive_User: 371034
    TotalUser: 405834
   Pct_Active: 8.5749
  Pct_Inctive: 91.4251


create table powerapp_active_stats (
   tran_dt date not null,
   tran_tm time not null,
   no_active int default 0 not null,
   no_inactive int default 0 not null,
   total_subs int default 0 not null,
   pct_active float default 0 not null,
   pct_inactive float default 0 not null
);

use archive_powerapp_flu;
CREATE TABLE powerapp_users (
  phone varchar(12) NOT NULL,
  datein datetime,
  PRIMARY KEY (phone)
);
CREATE TABLE powerapp_active_users (
  phone varchar(12) NOT NULL,
  datein datetime,
  PRIMARY KEY (phone)
);

--create table powerapp_users as select phone, min(datein) datein from powerapp_flu.powerapp_log group by phone;
alter table powerapp_users add primary key (phone);
insert ignore into  powerapp_users select phone, min(datein) datein from powerapp_log group by phone;
insert ignore into  powerapp_users select phone, min(datein) datein from powerapp_flu.powerapp_log group by phone;

insert ignore into  powerapp_active_users select phone, min(datein) datein from powerapp_log group by phone;
insert ignore into  powerapp_active_users select phone, min(datein) datein from powerapp_flu.powerapp_log group by phone;


drop procedure if exists sp_generate_active_stats;
delimiter //
create procedure sp_generate_active_stats (p_plan varchar(16), p_trandate varchar(20))
begin
   DECLARE vDateTo, vDateFr, vDateSt varchar(20);
   SET vDateTo = p_trandate;
   SET vDateFr = date_sub(vDateTo, interval 1 day);
   SET vDateSt = date_sub(vDateFr, interval 7 day);
   select vDateSt, vDateFr, vDateTo;

   -- for update of powerapp_users
   truncate table powerapp_active_users;
   if p_plan is not null then
      SET @vPlan = p_plan;
      insert ignore into powerapp_active_users select phone, max(datein) datein from powerapp_log where plan = p_plan and datein > vDateFr and datein <= vDateTo group by phone;
      insert ignore into powerapp_active_users select phone, max(datein) datein from powerapp_flu.powerapp_log where plan = p_plan and datein > vDateFr and datein <= vDateTo group by phone;
      insert ignore into powerapp_users select phone, min(datein) from (
                                        select phone, min(datein) datein from powerapp_log a where plan = p_plan and datein >= vDateSt and datein < vDateFr group by phone
                                        union select phone, min(datein) datein from powerapp_flu.powerapp_log a where plan = p_plan and datein >= vDateSt and datein < vDateFr group by phone
                                        ) as t group by phone;

   else 
      SET @vPlan = 'ALL';
      insert ignore into powerapp_active_users select phone, max(datein) datein from powerapp_log where datein > vDateFr and datein <= vDateTo group by phone;
      insert ignore into powerapp_active_users select phone, max(datein) datein from powerapp_flu.powerapp_log where datein > vDateFr and datein <= vDateTo group by phone;
      insert ignore into powerapp_users select phone, min(datein) from (
                                        select phone, min(datein) datein from powerapp_log a where datein > vDateSt and datein <= vDateFr group by phone
                                        union select phone, min(datein) datein from powerapp_flu.powerapp_log a where datein > vDateSt and datein <= vDateFr group by phone
                                        ) as t group by phone;
   end if;

   insert into powerapp_active_stats
   select left(vDateTo, 10), right(vDateTo, 8), @vPlan, sum(active_user) Active_User, sum(inactive_user) Inactive_User, 
          sum(active_user+inactive_user) TotalUser,
          (sum(active_user) / sum(active_user+inactive_user)) * 100 Pct_Active,
          (sum(inactive_user) / sum(active_user+inactive_user)) * 100 Pct_Inactive  
   from (
   select count(1) active_user, 0 inactive_user from powerapp_active_users union
   select 0 active_user, count(1) inactive_user from powerapp_users a where not exists (select 1 from powerapp_active_users b where a.phone=b.phone) 
   ) a;

   select * from powerapp_active_stats order by tran_dt desc, tran_tm desc limit 1;
end;
//
delimiter ;
call sp_generate_active_stats(NULL, '2013-12-01 23:59:59');


--Powerapp Availed Social and availed others

drop table if exists social_user;
create table social_user as select phone, max(datein) datein from powerapp_flu.powerapp_log where plan = 'SOCIAL' group by phone;
alter table social_user add primary key (phone);
insert ignore into  social_user select phone, max(datein) datein from powerapp_log a where plan = 'SOCIAL'  group by phone;

drop table if exists plan_user;
create table plan_user as select plan, phone, max(datein) datein from powerapp_flu.powerapp_log where plan <> 'SOCIAL' group by plan, phone;
alter table plan_user add primary key (plan, phone);
insert ignore into  plan_user select plan, phone, max(datein) datein from powerapp_log a where plan <> 'SOCIAL'  group by phone;

select count(1) 'Total No. of Social user' from social_user\G
select plan, count(distinct phone) from plan_user a where exists (select 1 from social_user b where a.phone=b.phone) group by plan;
select plan_count, count(phone) from (
select phone, count(plan) plan_count from plan_user a where exists (select 1 from social_user b where a.phone=b.phone) group by phone) e group by plan_count;

  
Total No. of Social Users: 204982

Breakdown of Social Users who availed of other products:
CHAT       : 3976
EMAIL      :  941
PHOTO      :  381
SPEEDBOOST : 8032
UNLI       : 7671

Breakdown of Social Users who availed by number of products:
+------------------+-------+
| No Plans Availed | Count |
+------------------+-------+
|                1 | 15005 |
|                2 |  2353 |
|                3 |   341 |
|                4 |    48 |
|                5 |    15 |
+------------------+-------+

echo "set session group_concat_max_len = 65536;
set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;
select phone, count(1) count, group_concat(plan, ' ', datein SEPARATOR '^')  packages 
from ( 
   select phone, plan, datein from powerapp_log a where exists (select 1 from inactive_user b where a.phone=b.phone) union 
   select phone, plan, datein from powerapp_flu.powerapp_log a where exists (select 1 from inactive_user b where a.phone=b.phone) order by phone, datein 
) t group by phone;" | mysql  -uroot -p --socket=/mnt/dbrep3307/mysql.sock --port=3307 archive_powerapp_flu > inactive_packages.txt


SPEEDBOOST 900 2013-12-04 16:23:24



select a.id, a.phone, a.info_1, a.info_2, a.info_3, b.id, b.phone, b.plan, b.validity, b.datein from tmp_numbers a left outer join (select id, phone, plan, validity, datein from powerapp_flu.powerapp_log where datein > '2014-02-28' and datein < '2014-03-02' and plan = 'UNLI') b on a.phone = b.phone order by a.info_2;


	
 CREATE TABLE inactive_list (
  phone varchar(20) NOT NULL,
  PRIMARY KEY (phone)
);
load data local infile '/tmp/a.sql' into table inactive_list;
create table active_from_inactive_list as select phone from powerapp_log where datein >= '2014-02-23' and datein < '2014-03-01' group by phone;
select count(1) from active_from_inactive_list a where exists (select 1 from inactive_list  b where a.phone = b.phone);
14.44% activated any package from Feb 23 to Feb 28.
(34,172 out of 236,620)

CREATE TABLE powerapp_inactive_list (
  phone varchar(12) NOT NULL,
  PRIMARY KEY (phone)
);

drop procedure if exists sp_generate_inactive_list;
delimiter //
create procedure sp_generate_inactive_list ()
begin
   truncate table powerapp_inactive_list;
   truncate table powerapp_active_users;
   insert ignore into powerapp_active_users select phone, max(datein) datein from powerapp_log where datein >  date_sub(now(), interval 1 day) group by phone;

   insert ignore into powerapp_inactive_list 
   select phone from powerapp_users a where not exists (select 1 from powerapp_active_users b where a.phone = b.phone);
end;
//
delimiter ;

call sp_generate_inactive_list();
