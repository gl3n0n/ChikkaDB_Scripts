+------------+----------+
| source     | count(1) |
+------------+----------+
| smartphone |    18813 |
| sms_app    |      563 |
| sms_user   |    67142 |
| web        |    11784 |
+------------+----------+
4 rows in set (0.70 sec)


drop table tmp_april_active;
create table tmp_april_active as select phone from powerapp_flu.powerapp_log  where datein >= '2014-04-01' and datein < '2014-04-07' and brand='BUDDY' group by phone;
alter table tmp_april_active add key phone_idx(phone);

drop table tmp_march_inactive ;
create table tmp_march_inactive as select phone from powerapp_users a where a.datein >= '2014-03-01' and a.datein < '2014-04-01' and a.brand='BUDDY' and not exists (select 1 from tmp_april_active b where a.phone=b.phone);
alter table tmp_march_inactive add key phone_idx(phone);

drop table tmp_march_active ;
create table tmp_march_active as select phone from powerapp_users a where a.datein >= '2014-03-01' and a.datein < '2014-04-01' and a.brand='BUDDY' and exists (select 1 from tmp_april_active b where a.phone=b.phone);
alter table tmp_march_active add key phone_idx(phone);

create table tmp_april_active_app as select phone from
                              ( select phone from powerapp_flu.powerapp_log  where datein >= '2014-04-01' and datein < '2014-04-07' and brand='BUDDY' and source ='sms_app' group by phone union
                                select phone from powerapp_flu.powerapp_log  where datein >= '2014-04-01' and datein < '2014-04-07' and brand='BUDDY' and source ='smartphone' group by phone) as t group by phone;

create table tmp_april_active_sms as select phone from
                              ( select phone from powerapp_flu.powerapp_log  where datein >= '2014-04-01' and datein < '2014-04-07' and brand='BUDDY' and source ='sms_user' group by phone) as t group by phone;

create table tmp_april_active_web as select phone from
                              ( select phone from powerapp_flu.powerapp_log  where datein >= '2014-04-01' and datein < '2014-04-07' and brand='BUDDY' and source ='web' group by phone) as t group by phone;

alter table tmp_april_active_app add key phone_idx(phone);
alter table tmp_april_active_sms add key phone_idx(phone);

drop table tmp_april_active_users;
create table tmp_april_active_users as 
select a.phone, CASE when b.phone is not null and c.phone is not null then 'BOTH'
                     when b.phone is not null and c.phone is null then 'APP'
                     when b.phone is null and c.phone is not null then 'SMS'
                     else null
                 END user_type, b.phone app_phone, c.phone sms_phone
from tmp_march_active a left outer join 
     tmp_april_active_app b on (a.phone=b.phone) left outer join 
     tmp_april_active_sms c on (a.phone=c.phone);

drop table tmp_april_active;
drop table tmp_april_active_app;
drop table tmp_april_active_sms;
drop table tmp_april_active_users;
drop table tmp_mapping_usage;
drop table tmp_mapping_usage_0;
drop table tmp_march_active;
drop table tmp_numbers;


-- April 8 broadcast for April 7 generation...
drop table tmp_april_active;
create table tmp_april_active as select phone, plan, count(1) hits from powerapp_flu.powerapp_log where datein >= '2014-04-08' group by phone, plan;
alter table tmp_april_active add key (phone);
select count(1) hits, round((count(1)/100000)*100,2) pct from tmp_march_inactive a where exists (select 1 from tmp_april_active b where b.phone=a.phone);
select plan, count(distinct phone) uniq, sum(hits) hits from tmp_april_active a where exists (select 1 from tmp_march_inactive b where b.phone=a.phone) group by plan;



--- TNT Inactive
drop table tmp_april_tnt_active;
create table tmp_april_tnt_active as select phone from powerapp_flu.powerapp_log  where datein >= '2014-04-01' and datein < '2014-04-07' and brand='TNT' group by phone;
alter table tmp_april_tnt_active add key phone_idx(phone);

drop table tmp_march_tnt_inactive ;
create table tmp_march_tnt_inactive as select phone from powerapp_users a where a.datein >= '2014-03-01' and a.datein < '2014-04-01' and a.brand='TNT' and not exists (select 1 from tmp_april_tnt_active b where a.phone=b.phone);
alter table tmp_march_tnt_inactive add key phone_idx(phone);


--- All subs
drop table tmp_april_all_active;
create table tmp_april_all_active as select phone from powerapp_flu.powerapp_log  where datein >= '2014-04-01' group by phone;
alter table tmp_april_all_active add key phone_idx(phone);
create table tmp_april_fgd_broadcast as
select phone, brand from powerapp_users a where not exists (select 1 from tmp_april_all_active b where b.phone=a.phone)
                                          and not exists (select 1 from tmp_march_inactive c where c.phone=a.phone) 
                                          and brand <> 'POSTPD'
order by brand, datein desc limit 400000;
alter table tmp_april_fgd_broadcast add key phone_idx(phone);

select brand, count(1) from powerapp_users a where not exists (select 1 from tmp_april_all_active b where b.phone=a.phone)
                                        and not exists (select 1 from tmp_march_inactive c where c.phone=a.phone) group by brand;







-- April 7 generation, April 8 broadcast...
drop table tmp_april_active;
create table tmp_april_active as select phone, plan, count(1) hits from powerapp_flu.powerapp_log where datein >= '2014-04-08' group by phone, plan;
alter table tmp_april_active add key (phone);
select count(1) uniq, round((count(1)/100000)*100,2) pct from tmp_april_fgd_broadcast a where dt_created = '2014-04-07' and exists (select 1 from tmp_april_active b where b.phone=a.phone);
select plan, count(distinct phone) uniq, sum(hits) hits from tmp_april_active a where exists (select 1 from tmp_april_fgd_broadcast b where b.dt_created = '2014-04-07' and b.phone=a.phone) group by plan;


-- April 8 generation, April 8 broadcast...
drop table tmp_april_active;
create table tmp_april_active as select phone, plan, count(1) hits from powerapp_flu.powerapp_log where datein >= '2014-04-08 12:15:00' group by phone, plan;
alter table tmp_april_active add key (phone);
select count(1) uniq, round((count(1)/100000)*100,2) pct from tmp_april_fgd_broadcast a where dt_created = '2014-04-08' and exists (select 1 from tmp_april_active b where b.phone=a.phone);
select plan, count(distinct phone) uniq, sum(hits) hits from tmp_april_active a where exists (select 1 from tmp_april_fgd_broadcast b where b.dt_created = '2014-04-08' and b.phone=a.phone) group by plan;

-- Consolidated
drop table tmp_april_active;
create table tmp_april_active as select phone, plan, count(1) hits from powerapp_flu.powerapp_log where datein >= '2014-04-08 00:00:00' group by phone, plan;
alter table tmp_april_active add key (phone);
select count(1) uniq, round((count(1)/100000)*100,2) pct from tmp_april_fgd_broadcast a where exists (select 1 from tmp_april_active b where b.phone=a.phone);
select plan, count(distinct phone) uniq, sum(hits) hits from tmp_april_active a where exists (select 1 from tmp_april_fgd_broadcast b where b.phone=a.phone) group by plan;


select '2014-04-07 00:00:00', '2014-04-08' into @vStart, @vEnd;
drop table tmp_april_active;
create table tmp_april_active as select phone from powerapp_log where datein >= @vStart and datein < @vEnd group by phone;
alter table tmp_april_active add key (phone);
drop table tmp_april_new;
create table tmp_april_new as select phone from tmp_april_active a where not exists (select 1 from powerapp_users b where a.phone = b.phone and b.datein < @vStart);
alter table tmp_april_new add key (phone);
select left(datein, 10) dt, substring(datein, 12,2) tm, count(1) New_Hits from powerapp_log a where datein >= @vStart and datein < @vEnd and exists (select 1 from tmp_april_new b where a.phone = b.phone ) group by 1,2 order by 1,2;
select left(datein, 10) dt, substring(datein, 12,2) tm, count(1) Old_hits from powerapp_log a where datein >= @vStart and datein < @vEnd and not exists (select 1 from tmp_april_new b where a.phone = b.phone ) group by 1,2 order by 1,2;



################################################################################# Pacquiao
select '2014-04-07 00:00:00', '2014-04-08' into @vStart, @vEnd;
drop table tmp_april_week_active;
create table tmp_april_week_active as select phone, brand from powerapp_flu.powerapp_log where datein >= @vStart group by phone, brand;
alter table tmp_april_week_active add key (phone);

select '2014-02-01 00:00:00', '2014-04-07' into @vStart, @vEnd;
drop table tmp_april_feb_mins; 
create table tmp_april_feb_mins as 
select phone, brand, min(datein) datein from powerapp_log where datein >= @vStart and datein < @vEnd group by phone, brand;
select '2014-04-01 00:00:00', '2014-04-07' into @vStart, @vEnd;
insert ignore into tmp_april_feb_mins
select phone, brand, min(datein) datein from powerapp_flu.powerapp_log where datein >= @vStart and datein < @vEnd  group by phone, brand;
alter table tmp_april_feb_mins add key (phone);

drop table tmp_april_pacquiao_bcast;
create table tmp_april_pacquiao_bcast as
select phone, brand from tmp_april_feb_mins a where not exists (select 1 from tmp_april_week_active b where b.phone=a.phone);
alter table tmp_april_pacquiao_bcast add key phone_idx(phone);


select count(1) from powerapp_users_apn a where not exists (select 1 from tmp_april_pacquiao_bcast b where a.phone=b.phone);
update tmp_april_pacquiao_bcast a set apn_flag = 'Y' where exists (select 1 from powerapp_users_apn b where a.phone=b.phone);

###############################################
drop table tmp_april_act_mins; 
select '2014-04-15 14:50:00', '2014-04-16' into @vStart, @vEnd;
create table tmp_april_act_mins as 
select phone, brand, source, min(datein) datein, count(1) hits from powerapp_flu.powerapp_log where datein >= @vStart and datein < @vEnd group by phone, brand, source;
alter table tmp_april_act_mins add key phone_idx(phone);
----
delete from tmp_april_act_mins;
insert into tmp_april_act_mins
select phone, brand, source, min(datein) datein, count(1) hits from powerapp_flu.powerapp_log where datein >= '2014-04-15 14:50:00' group by phone, brand, source;

select sum(Total) Base, sum(No_Subs) MINs, ROUND((sum(No_Subs)/sum(Total))*100,2) Pct from (
select count(1) Total, 0 No_Subs from tmp_april_pacquiao_bcast a where dt_bcast = '2014-04-14' union
select 0 Total, count(1) No_Subs from tmp_april_pacquiao_bcast a where dt_bcast = '2014-04-14' and exists (select 1 from tmp_april_act_mins b where a.phone = b.phone)) t;

select b.source Source, sum(hits) MINs from tmp_april_pacquiao_bcast a, tmp_april_act_mins b 
where a.dt_bcast = '2014-04-14'
and   a.phone = b.phone
group by b.source;


select left(datein, 10) date, substring(datein, 12,2) time, count(1) from powerapp_log where free='false' and datein >= '2014-04-14' group by 1,2;

+------------+------+----------+
| date       | time | count(1) |
+------------+------+----------+
| 2014-04-14 | 00   |     2731 |
| 2014-04-14 | 01   |     1471 |
| 2014-04-14 | 02   |      812 |
| 2014-04-14 | 03   |      796 |
| 2014-04-14 | 04   |     1159 |
| 2014-04-14 | 05   |     2211 |
| 2014-04-14 | 06   |     3863 |
| 2014-04-14 | 07   |     4893 |
| 2014-04-14 | 08   |    32813 |
| 2014-04-14 | 09   |    28581 |
| 2014-04-14 | 10   |    12902 |
| 2014-04-14 | 11   |    10598 |
| 2014-04-14 | 12   |    10323 |
| 2014-04-14 | 13   |    10752 |
| 2014-04-14 | 14   |     9585 |
| 2014-04-14 | 15   |     4074 |
| 2014-04-14 | 16   |     4415 |
| 2014-04-14 | 17   |     4872 |
| 2014-04-14 | 18   |     3607 |
| 2014-04-14 | 19   |     2453 |
| 2014-04-14 | 20   |     7314 |
| 2014-04-14 | 21   |     6220 |
| 2014-04-14 | 22   |     8377 |
| 2014-04-14 | 23   |     6245 |
| 2014-04-15 | 00   |     3056 |
| 2014-04-15 | 01   |     1827 |
| 2014-04-15 | 02   |     1317 |
| 2014-04-15 | 03   |     1248 |
| 2014-04-15 | 04   |     2012 |
| 2014-04-15 | 05   |     4169 |
| 2014-04-15 | 06   |     6671 |
| 2014-04-15 | 07   |     7256 |
| 2014-04-15 | 08   |     7849 |
| 2014-04-15 | 09   |     9686 |
| 2014-04-15 | 10   |     8636 |
| 2014-04-15 | 11   |     8514 |
| 2014-04-15 | 12   |     8023 |
| 2014-04-15 | 13   |     8493 |
| 2014-04-15 | 14   |    10697 |
| 2014-04-15 | 15   |     9168 |
| 2014-04-15 | 16   |     3357 |
+------------+------+----------+
41 rows in set (0.50 sec)





