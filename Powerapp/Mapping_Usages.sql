select phone, 
      count(1) no_sessions, 
      min(round((unmap_ts-map_ts)/1000,0)) min_duration,
      avg(round((unmap_ts-map_ts)/1000,0)) avg_duration,
      max(round((unmap_ts-map_ts)/1000,0)) max_duration,
      round(sum(unmap_ts-map_ts)/1000 ,0) actual_usage, 
      if(round(sum(unmap_ts-map_ts)/1000 ,0)>86400, 86400, round(sum(unmap_ts-map_ts)/1000 ,0)) tot_usage, 
      sum(IF(unmap_ts is null, 1, 0)) no_null_unmap, 
      max(IF(unmap_datein>(date_add(datein, interval 1 day), unmap_datein, datein))) unmap_forever,

create table powerapp_usage_per_day (
  tran_dt date not null,
  m2400 int default 0 not null,
  m1200 int default 0 not null,
  m1000 int default 0 not null,
  m0900 int default 0 not null,
  m0800 int default 0 not null,
  m0700 int default 0 not null,
  m0600 int default 0 not null,
  m0500 int default 0 not null,
  m0400 int default 0 not null,
  m0300 int default 0 not null,
  m0200 int default 0 not null,
  m0100 int default 0 not null,
  m0030 int default 0 not null,
  m0015 int default 0 not null,
  m0005 int default 0 not null,
  m0004 int default 0 not null,
  m0003 int default 0 not null,
  m0002 int default 0 not null,
  m0001 int default 0 not null,
  m0000 int default 0 not null,
  m00_0 int default 0 not null,
  primary key (tran_dt)
);

drop table powerapp_usage_per_day;
create table powerapp_usage_per_day (
  tran_dt date not null,
  usage_group varchar(8) not null,
  no_mins int default 0 not null,
  primary key (tran_dt, usage_group)
);

delete from powerapp_usage_per_day;
insert into powerapp_usage_per_day 
select datein, usage_group, count(phone) count_mins from (
select datein, phone, sum(round((unmap_ts-map_ts)/1000 ,0)) max_usage, count(1) no_sessions,
       case
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (24*60*60) then '2400' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (12*60*60) then '1200'
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (10*60*60) then '1000' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (9*60*60)  then '0900' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (8*60*60)  then '0800' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (7*60*60)  then '0700' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (6*60*60)  then '0600' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (5*60*60)  then '0500' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (4*60*60)  then '0400' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (3*60*60)  then '0300' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (2*60*60)  then '0200' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (1*60*60)  then '0100' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (30*60)    then '0030' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (15*60)    then '0015' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (10*60)    then '0010' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (9*60)     then '0009' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (8*60)     then '0008' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (7*60)     then '0007' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (6*60)     then '0006' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (5*60)     then '0005' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (4*60)     then '0004' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (3*60)     then '0003' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (2*60)     then '0002' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (1*60)     then '0001' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (0*60)     then '0000' 
           else '00-0'
      end as usage_group
from powerapp_mapping_usage 
group by datein, phone ) as t
group  by  datein, usage_group;


-- report
select concat(tran_dt, ',', usage) mapping_usage from (
select tran_dt, group_concat(no_mins order by usage_group separator ',') usage_group
from powerapp_usage_per_day group by tran_dt order by tran_dt) as x;


select datein, usage_group, count(phone) count_mins from (
select datein, phone, round((IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) max_usage,
       case
           when  round((unmap_ts-map_ts)/1000,0) > (24*60*60) then '2400' 
           when  round((unmap_ts-map_ts)/1000,0) > (12*60*60) then '1200' 
           when  round((unmap_ts-map_ts)/1000,0) > (8*60*60)  then '0800' 
           when  round((unmap_ts-map_ts)/1000,0) > (4*60*60)  then '0400' 
           when  round((unmap_ts-map_ts)/1000,0) > (2*60*60)  then '0200' 
           when  round((unmap_ts-map_ts)/1000,0) > (1*60*60)  then '0100' 
           when  round((unmap_ts-map_ts)/1000,0) > (30*60)    then '0030' 
           when  round((unmap_ts-map_ts)/1000,0) > (15*60)    then '0015' 
           when  round((unmap_ts-map_ts)/1000,0) > (5*60)     then '0005' 
           else '0000' 
      end as usage_group
from powerapp_mapping_usage 
where datein = '2014-03-31') as t
group  by  datein, usage_group;


select * 
from   powerapp_mapping_usage
where datein='2014-03-10'
and   phone = '639071063659';

and   unmap_ts is null;
