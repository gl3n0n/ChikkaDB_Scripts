+------------+------+----------+----------+--------+----------+--------+
|            |      |          |        48h        |         24h       |
+------------+------+----------+----------+--------+----------+--------+
| Date       | Type | Inactive |  NumSubs | Pct(%) |  NumSubs | Pct(%) |
+------------+------+----------+----------+--------+----------+--------+
| 2014-03-19 | pre  |   196141 |    12209 |   6.22 |    7760  |   3.96 |
| 2014-03-19 | tnt  |   409730 |    12241 |   2.99 |    8015  |   1.96 |
| 2014-03-25 | pre  |   238686 |    14410 |   6.04 |    8647  |   3.62 |
| 2014-03-25 | tnt  |   478443 |    12718 |   2.66 |    7208  |   1.51 |
| 2014-03-30 | pre  |   265793 |    16864 |   6.34 |   10056  |   3.78 |
| 2014-03-30 | tnt  |   514902 |    12001 |   2.33 |    6903  |   1.34 |
+------------+------+----------+----------+--------+----------+--------+
6 rows in set (1.41 sec)
            
            
select round(( 7760 /196141)*100,2);
select round(( 8015 /409730)*100,2);
select round(( 8647 /238686)*100,2);
select round(( 7208 /478443)*100,2);
select round((10056 /265793)*100,2);
select round(( 6903 /514902)*100,2);
            

drop table tmp_users;
create table tmp_users as select phone, count(1) from powerapp_log where datein >= '2014-03-27' and datein < '2014-03-28' group by phone;
alter table tmp_users add key phone_idx(phone);
select count(1) pre from date_num a where dt='2014-03-19' and type='pre' and exists (select 1 from tmp_users b where b.phone = a.phone);
select count(1) tnt from date_num a where dt='2014-03-19' and type='tnt' and exists (select 1 from tmp_users b where b.phone = a.phone);

drop table tmp_users;
create table tmp_users as select phone, count(1) from powerapp_log where datein >= '2014-03-28' and datein < '2014-03-29' group by phone;
alter table tmp_users add key phone_idx(phone);
select count(1) pre from date_num a where dt='2014-03-25' and type='pre' and exists (select 1 from tmp_users b where b.phone = a.phone);
select count(1) tnt from date_num a where dt='2014-03-25' and type='tnt' and exists (select 1 from tmp_users b where b.phone = a.phone);

drop table tmp_users;
create table tmp_users as select phone, count(1) from powerapp_log where datein >= '2014-04-02' and datein < '2014-04-03' group by phone;
alter table tmp_users add key phone_idx(phone);
select count(1) pre from date_num a where dt='2014-03-30' and type='pre' and exists (select 1 from tmp_users b where b.phone = a.phone);
select count(1) tnt from date_num a where dt='2014-03-30' and type='tnt' and exists (select 1 from tmp_users b where b.phone = a.phone);

