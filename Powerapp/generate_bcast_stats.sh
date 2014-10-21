#!/bin/bash

# Set Variables
date_display=$(date '+%H:%M')
date_where=$(date '+%Y-%m-%d %H:%M:%S')
email_to="glenon@chikka.com"
email_cc="glenon@chikka.com"
tx_date=$1
tb_name=$2
fname1='/tmp/powerapp_bcast_stats.txt'
p='stats'
rm -f $fname1

# Generate Stats
echo "delete from tmp_april_act_mins;
insert into tmp_april_act_mins
select phone, brand, source, min(datein) datein, count(1) hits from powerapp_flu.powerapp_log where datein >= '$tx_date 08:00:00' and datein <= '$tx_date 23:59:59' group by phone, brand, source;
" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309

echo "select b.source Source, count(distinct b.phone) MINs from $tb_name a, tmp_april_act_mins b
where a.phone = b.phone
and   a.bcast_dt = '$tx_date'
group by b.source;
" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 --table > $fname1


echo "delete from tmp_april_act_mins;
insert into tmp_april_act_mins
select phone, brand, plan, min(datein) datein, count(1) hits from powerapp_flu.powerapp_log where datein >= '$tx_date 08:00:00' and datein <= '$tx_date 23:59:59' group by phone, brand, plan;
" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309

echo "select b.source Plan, count(distinct b.phone) MINs from $tb_name a, tmp_april_act_mins b
where a.phone = b.phone
and   a.bcast_dt = '$tx_date'
group by b.source;
" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 --table >> $fname1


echo "select sum(Total) Base, sum(No_Subs) MINs, ROUND((sum(No_Subs)/sum(Total))*100,2) Pct from (
select count(1) Total, 0 No_Subs from $tb_name a where bcast_dt = '$tx_date' union
select 0 Total, count(1) No_Subs from $tb_name a where bcast_dt = '$tx_date' and exists (select 1 from tmp_april_act_mins b where a.phone = b.phone)) t;
" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 --table >> $fname1


# Send mail PREPAID
echo "PowerApp Broadcast ($tx_date) Stats.

Please refer to the attachment.



Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:do-not-reply@chikka.com<do-not-reply@chikka.com>" -s"Powerapp Broadcast Stats ($tx_date)" -a $fname1




################################################################

Broadcast Stats:

select '2014-07-11 08:00:00', '2014-07-12 07:59:59' into @tx_date1, @tx_date2;
delete from tmp_april_act_mins;
insert into tmp_april_act_mins
select phone, brand, source, min(datein) datein, count(1) hits 
from powerapp_flu.powerapp_log 
where datein >= @tx_date1 and datein <= @tx_date2 group by phone, brand, source;

select b.source Source, count(distinct b.phone) MINs from tmp_plan_users_0709 a, tmp_april_act_mins b
where a.phone = b.phone
and   a.bcast_dt = left(@tx_date1,10)
group by b.source;


select '2014-07-13 08:00:00', '2014-07-14 07:59:59' into @tx_date1, @tx_date2;
delete from tmp_april_act_mins;
insert into tmp_april_act_mins
select phone, brand, plan, min(datein) datein, count(1) hits 
from powerapp_flu.powerapp_log 
where datein >= @tx_date1 and datein <= @tx_date2 group by phone, brand, plan;

select b.source Plan, count(distinct b.phone) MINs from tmp_plan_users_0713 a, tmp_april_act_mins b
where a.phone = b.phone
and   a.bcast_dt = left(@tx_date1,10)
group by b.source;


select sum(Total) Base, sum(No_Subs) MINs, ROUND((sum(No_Subs)/sum(Total))*100,2) Pct from (
select count(1) Total, 0 No_Subs from tmp_plan_users_0710 a where bcast_dt = left(@tx_date1,10) union
select 0 Total, count(1) No_Subs from tmp_plan_users_0710 a where bcast_dt = left(@tx_date1,10) and exists (select 1 from tmp_april_act_mins b where a.phone = b.phone)) t;



+----------+
|    Total |
+----------+
|  9859926 |
+----------+

+----------+----------+----------+----------+
| Brand    |    Total |  Bcasted |   4Bcast |
+----------+----------+----------+----------+
| POSTPAID |   260194 |   260194 |   260194 |
| PREPAID  |  5836911 |  5820438 |    16473 |
| TNT      |  3762821 |  3724772 |    38049 |
+----------+----------+----------+----------+


+------------+-------+----------+
| Date       | Plan  |    Count |
+------------+-------+----------+
| 2014-07-05 | BUDDY |  1000000 |
| 2014-07-05 | TNT   |  1000000 |
| 2014-07-06 | BUDDY |  1000000 |
| 2014-07-06 | TNT   |  1000000 |
| 2014-07-07 | BUDDY |  1000000 |
| 2014-07-07 | TNT   |   540428 |
| 2014-07-09 | BUDDY |  1200000 |
| 2014-07-10 | BUDDY |  1452187 |
| 2014-07-11 | BUDDY |   168254 |
| 2014-07-11 | TNT   |  1184344 |
+------------+-------+----------+
|            | TOTAL |  9545213 +
+------------+-------+----------+



   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;


drop temporary table if exists tmp_plan_active_users;
create temporary table tmp_plan_active_users (phone varchar(12) not null, primary key (phone));

insert ignore into tmp_plan_active_users select phone from tmp_plan_users_0705 where plan like 'CHIKKA%'; 
insert ignore into tmp_plan_active_users select phone from tmp_plan_users_0706 where plan like 'CHIKKA%'; 
insert ignore into tmp_plan_active_users select phone from tmp_plan_users_0707; 
insert ignore into tmp_plan_active_users select phone from tmp_plan_users_0709; 
insert ignore into tmp_plan_active_users select phone from tmp_plan_users_0710; 
insert ignore into tmp_plan_active_users select phone from tmp_plan_users_0711; 

select brand 'Brand', count(1) 'Count' from chikka_mins_uniq a 
where not exists (select 1 from tmp_plan_active_users b where a.phone = b.phone)
group by brand;

 
