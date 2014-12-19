select phone 'MIN', round(sum(b_usage/1000000),0) 'Total MB Usage', count(distinct(left(datein,10))) 'No Days with Usage', 
       round(sum(validity/60),0) 'Total Duration In Minutes' 
into outfile '/tmp/AugustReport.csv' fields terminated by ',' lines terminated by '\n' 
from powerapp_log where datein >= '2014-08-01' and datein < '2014-09-01' and b_usage > 0 group by phone;

select left(datein,10) Date, sum(b_usage) b_usage from powerapp_log
where datein >= '2014-08-01' and datein < '2014-09-01' and phone = '639071000306' and b_usage > 0 group by 1;


MIN,Total MB Usage,No Days with Usage,Total Duration In Minutes

select phone 'MIN', round(sum(b_usage/1000000),0) 'Total MB Usage', count(distinct(left(datein,10))) 'No Days with Usage', 
       round(sum(validity/60),0) 'Total Duration In Minutes' 
into outfile '/tmp/Sept_1_25_Report.csv' fields terminated by ',' lines terminated by '\n' 
from powerapp_log where datein >= '2014-09-01' and datein < '2014-09-26' and b_usage > 0 group by phone;

select phone 'MIN', round(sum(b_usage/1000000),0) 'Total MB Usage', count(distinct(left(datein,10))) 'No Days with Usage', 
       round(sum(validity/60),0) 'Total Duration In Minutes' 
into outfile '/tmp/Sept_1_25_Report.csv' fields terminated by ',' lines terminated by '\n' 
from powerapp_log where datein >= '2014-09-26' and b_usage > 0 group by phone;




MIN,Registration Date,Total MB Usage,Total Duration In Minutes
create temporary table tmp_liberation_mins (phone varchar(12) not null, datein date, primary key (phone));
insert into tmp_liberation_mins select phone, left(min(datein),10) from powerapp_log where datein >= '2014-09-26' and plan='MYVOLUME' group by 1;
select a.phone 'MIN', a.datein 'Registration Date', round(sum(b.b_usage/1000000),0) 'Total MB Usage', count(distinct(left(b.datein,10))) 'No Days with Usage', 
       round(sum(b.validity/60),0) 'Total Duration In Minutes' 
into outfile '/tmp/Liberation_Report.csv' fields terminated by ',' lines terminated by '\n' 
from tmp_liberation_mins a, powerapp_log b where a.phone=b.phone and b.datein >= '2014-09-26' and b.b_usage > 0 group by a.phone, a.datein;

select b.phone 'MIN', left(b.datein,10) 'Registration Date', round(sum(b.b_usage/1000000),0) 'Total MB Usage', 
       round(sum(b.validity/60),0) 'Total Duration In Minutes' 
into outfile '/tmp/Liberation_Report.csv' fields terminated by ',' lines terminated by '\n' 
from powerapp_log b where b.datein >= '2014-10-01' and b.datein < '2014-10-07' and plan='MYVOLUME' and b.b_usage > 0 group by 1,2;


MIN,Week,Total MB Usage,No Days with Usage,Total Duration In Minutes
select b.phone 'MIN', 'Sept. 22 - 28' as 'Week', round(sum(b.b_usage/1000000),0) 'Total MB Usage', 
       count(distinct(left(datein,10))) 'No Days with Usage',
       round(sum(b.validity/60),0) 'Total Duration In Minutes' 
into outfile '/tmp/Sept_22_28_Report.csv' fields terminated by ',' lines terminated by '\n' 
from powerapp_log b where b.datein >= '2014-09-22' and b.datein <'2014-09-29' and b.b_usage > 0 group by 1,2;

select b.phone 'MIN', 'Sept. 29 - Oct. 5' as 'Week', round(sum(b.b_usage/1000000),0) 'Total MB Usage', 
       count(distinct(left(datein,10))) 'No Days with Usage',
       round(sum(b.validity/60),0) 'Total Duration In Minutes' 
into outfile '/tmp/Sept_29_Oct_05_Report.csv' fields terminated by ',' lines terminated by '\n' 
from powerapp_log b where b.datein >= '2014-09-29' and b.datein <'2014-10-05' and b.b_usage > 0 group by 1,2;

+--------+---------+
| Brand  | Uniq    |
+--------+---------+
| BUDDY  | 1182007 |
| POSTPD |   16855 |
| TNT    | 1252393 |
+--------+---------+
3 rows in set (23.71 sec)

create table tmp_concurrent_subs_hourly (tx_date date, tx_hour time, num_subs bigint(18) default 0, primary key (tx_date, tx_hour)) ;
insert into tmp_concurrent_subs_hourly select datein, concat(left(timein,2), ':00'), max(num_subs) from powerapp_flu.powerapp_concurrent_log where datein >= '2014-09-01' group by 1,2;

create table tmp_powerapp_hourly (tx_date date, tx_hour time, t_users int default 0, t_usage bigint(18) default 0, t_time bigint(18) default 0, t_reg bigint(18) default 0, primary key (tx_date, tx_hour)) ;
insert into tmp_powerapp_hourly
select left(datein, 10) tx_date, concat(substring(datein,12,2), ':00') tx_time, count(1), sum(b_usage) t_usage, round(sum(validity/60),0) t_time, count(distinct phone) t_registrant
from  powerapp_log where datein >= '2014-09-26' and plan = 'MYVOLUME' group by 1,2;


select a.tx_date , a.tx_hour 'Time', a.t_usage 'Total Usage in MB', b.num_subs '# of Concurrent Users', round(b.num_subs/a.t_time,0) 'Average Duration (minutes)', a.t_reg 'Count of Registrants'
select tx_date 'Date', 
       tx_hour 'Time', 
       round(t_usage/1000000,2) 'Total Usage in MB', 
       t_users 'Concurrent Users', 
       round(t_time/60,0) 'Total Duration (minutes)', 
       round((t_time/60)/t_users,2) 'Average Duration (minutes)', 
       t_reg 'Count of Registrants' 
from   tmp_powerapp_hourly where t_usage > 0;



select tx_date, left(start_tm,2) tx_hh, count(distinct phone) uniq, sum(b_usage) b_usage, sum(time_to_sec(timediff(end_tm,start_tm))) t_time from powerapp_udr_log where service = 'MyvolumeService' group by 1,2;


insert ignore into tmp_liberation_mins select phone, max(brand), min(datein) from powerapp_log where datein >= '2014-12-10 23:50:00' and plan = 'MYVOLUME' group by 1;


select txDate, sum(BUDDY) BUDDY, sum(POSTPD) POSTPD, sum(TNT) TNT from (
select left(datein,10) txDate, count(distinct phone) BUDDY, 0 POSTPD, 0 TNT from powerapp_log where datein >= '2014-10-26' and datein < curdate() and plan='MYVOLUME' and brand='BUDDY' group by 1 union
select left(datein,10) txDate, 0 BUDDY, count(distinct phone) POSTPD, 0 TNT from powerapp_log where datein >= '2014-10-26' and datein < curdate() and plan='MYVOLUME' and brand='POSTPD' group by 1 union
select left(datein,10) txDate, 0 BUDDY, 0 POSTPD, count(distinct phone) TNT from powerapp_log where datein >= '2014-10-26' and datein < curdate() and plan='MYVOLUME' and brand='TNT' group by 1
) t group by 1;

select txDate, sum(BUDDY) BUDDY, sum(POSTPD) POSTPD, sum(TNT) TNT from (
select left(datein,10) txDate, count(distinct phone) BUDDY, 0 POSTPD, 0 TNT from tmp_liberation_mins where datein >= '2014-10-26' and datein < curdate() and brand='BUDDY' group by 1 union
select left(datein,10) txDate, 0 BUDDY, count(distinct phone) POSTPD, 0 TNT from tmp_liberation_mins where datein >= '2014-10-26' and datein < curdate() and brand='POSTPD' group by 1 union
select left(datein,10) txDate, 0 BUDDY, 0 POSTPD, count(distinct phone) TNT from tmp_liberation_mins where datein >= '2014-10-26' and datein < curdate() and brand='TNT' group by 1
) t group by 1;

AUTO RENEWAL
select left(datein,10) txDate, brand,count(distinct phone) uniq from powerapp_log where datein >= '2014-10-22' and plan = 'MYVOLUME' and source like 'auto%' and brand= 'TNT' group by 1, 2;

NDS
select b.brand, count(1) Total, sum(if(a.transmitted+a.received=0,1,0)) wZeroUsage, sum(if(a.transmitted+a.received>0,1,0)) wUsage, sum(a.transmitted+a.received) TotalUsage from tmp_liberation_usage a, powerapp_users_apn b where a.phone=b.phone and a.tx_date='2014-09-26' group by 1;

select tx_date, sum(BUDDY_W) BUDDY_W, sum(POSTPD_W) POSTPD_W, sum(TNT_W) TNT_W, sum(BUDDY_WO) BUDDY_WO, sum(POSTPD_WO) POSTPD_WO, sum(TNT_WO) TNT_WO from (
select a.tx_date, sum(if(a.transmitted+a.received=0,1,0))  BUDDY_WO, sum(if(a.transmitted+a.received>0,1,0)) BUDDY_W, 0 POSTPD_W, 0 POSTPD_WO, 0 TNT_W, 0 TNT_WO from tmp_liberation_usage a, powerapp_users_apn b where a.phone=b.phone and b.brand='BUDDY' group by 1 union
select a.tx_date, 0 BUDDY_WO, 0 BUDDY_W, sum(if(a.transmitted+a.received=0,1,0))  POSTPD_W, sum(if(a.transmitted+a.received>0,1,0)) POSTPD_WO, 0 TNT_W, 0 TNT_WO from tmp_liberation_usage a, powerapp_users_apn b where a.phone=b.phone and b.brand='POSTPD' group by 1 union
select a.tx_date, 0 BUDDY_WO, 0 BUDDY_W, 0 POSTPD_W, 0 POSTPD_WO, sum(if(a.transmitted+a.received=0,1,0))  TNT_W, sum(if(a.transmitted+a.received>0,1,0)) TNT_WO from tmp_liberation_usage a, powerapp_users_apn b where a.phone=b.phone and b.brand='TNT' group by 1
) t group by 1;


select week(datein) Week_No, 
       date_add(left(datein,10), INTERVAL(1-DAYOFWEEK(left(datein,10))) DAY) Start_Dt, 
       date_add(date_add(left(datein,10), INTERVAL(1-DAYOFWEEK(left(datein,10))) DAY), interval 6 day) End_Dt, 
       brand Brand, 
       count(distinct phone) 'Uniq MINs', count(1) 'Total Hits',
       round(sum(b_usage)/1000000,2) 'Total Usage (MB)' 
from powerapp_log where datein >= '2014-09-28' group by 1,2,3,4;

select week(datein) wk_no, brand, count(distinct phone) 'New MINs' from powerapp_flu.new_subscribers where datein >= '2014-09-28' group by 1,2;
+-------+------------+------------+--------+-----------+----------+---------+
| wk_no | start_dt   | end_dt     | Brand  | Uniq MINs | New MINs | Total   |
+-------+------------+------------+--------+-----------+----------+---------+
|    39 | 2014-09-28 | 2014-10-05 | BUDDY  |    910458 |   562679 | 3111019 |
|    39 | 2014-09-28 | 2014-10-05 | POSTPD |     11604 |     8466 |   30524 |
|    39 | 2014-09-28 | 2014-10-05 | TNT    |    950421 |   534598 | 3134894 |
|    40 | 2014-10-05 | 2014-10-12 | BUDDY  |   1195534 |   598343 | 4866533 |
|    40 | 2014-10-05 | 2014-10-12 | POSTPD |     21631 |    14541 |   76300 |
|    40 | 2014-10-05 | 2014-10-12 | TNT    |   1139124 |   519328 | 4757923 |
|    41 | 2014-10-12 | 2014-10-19 | BUDDY  |    596051 |   146588 | 1483627 |
|    41 | 2014-10-12 | 2014-10-19 | POSTPD |      9752 |     3408 |   23074 |
|    41 | 2014-10-12 | 2014-10-19 | TNT    |    551459 |   135230 | 1429034 |
+-------+------------+------------+--------+-----------+----------+---------+

+---------+------------+------------+--------+-----------+----------+------------+------------------+
| Week_No | Start_Dt   | End_Dt     | Brand  | Uniq MINs | New MINs | Total Hits | Total Usage (MB) |
+---------+------------+------------+--------+-----------+----------+------------+------------------+
|      39 | 2014-09-28 | 2014-10-04 | BUDDY  |    910458 |   562679 |    3111019 |        395814.94 |
|      39 | 2014-09-28 | 2014-10-04 | POSTPD |     11604 |     8466 |      30524 |         10834.78 |
|      39 | 2014-09-28 | 2014-10-04 | TNT    |    950421 |   534598 |    3134894 |        282785.85 |
|      40 | 2014-10-05 | 2014-10-11 | BUDDY  |   1195534 |   598343 |    4866533 |        534237.71 |
|      40 | 2014-10-05 | 2014-10-11 | POSTPD |     21631 |    14541 |      76300 |         11318.19 |
|      40 | 2014-10-05 | 2014-10-11 | TNT    |   1139124 |   519328 |    4757923 |        421683.99 |
|      41 | 2014-10-12 | 2014-10-18 | BUDDY  |    596051 |   146588 |    1483627 |        174005.55 |
|      41 | 2014-10-12 | 2014-10-18 | POSTPD |      9752 |     3408 |      23074 |          4354.23 |
|      41 | 2014-10-12 | 2014-10-18 | TNT    |    551459 |   135230 |    1429034 |        151893.99 |
+---------+------------+------------+--------+-----------+----------+------------+------------------+



















select source, count(1) nCount, round(sum(b_usage)/1000000,2) nUsageMB from powerapp_udr_log where b_usage > 25000000 group by 1;

select avg(tx_time) Avg_Time_sec, max(tx_time) Max_Time_sec from (
select time_to_sec(timediff(end_tm,start_tm)) tx_time, source, service from powerapp_udr_log where tx_date= '2014-10-15' and b_usage > 25000000 
) t;

+--------------+
| Avg_Time_sec |
+--------------+
|     499.0304 |
+--------------+


select avg(tx_time) Avg_Time_sec from (
select time_to_sec(timediff(end_tm,start_tm)) tx_time, source, plan from powerapp_log where datein >= '2014-10-15' and datein < '2014-10-16' and b_usage > 25000000 
) t;

+--------------+
| Avg_Time_sec |
+--------------+
|   62709.9481 |
+--------------+


select source, count(1) nCount, round(sum(b_usage)/1000000,2) nUsageMB from powerapp_udr_log where service='MyvolumeService' group by 1;
select source, count(1) nCount, round(sum(b_usage)/1000000,2) nUsageMB from powerapp_udr_log where tx_date='2014-10-15' and service='MyvolumeService' group by 1 order by 3 desc;

+----------------------+---------+----------+
| source               | nCount  | nUsageMB |
+----------------------+---------+----------+
| http                 | 1049604 | 67053.89 |
| spdy                 |  478212 |  9780.04 |
| instagram            |   19983 |  7107.98 |
| twitter              |   68329 |  3459.58 |
| yahoo_generic        |  129785 |  1964.15 |
| applemaps            |    6530 |  1770.10 |
| yahoomail            |   73544 |  1125.82 |
| tumblr               |    4163 |   695.25 |
| windowslive          |   28855 |   531.24 |
| wikimedia            |    3558 |   418.53 |
| icloud               |   17019 |   290.72 |
| baidu                |   18124 |   244.79 |
| gmail                |   24741 |   238.85 |
| picasa               |     642 |   198.35 |
| imgur                |    1916 |   171.42 |
| photobucket          |    2226 |   154.13 |
| flickr               |    3465 |   151.65 |
| pinterest            |    4617 |   129.45 |
| imaps                |   17632 |   123.01 |
| badoo                |    1038 |    67.05 |
| windowslive_skydrive |     798 |    66.99 |
| cnn                  |    1459 |    60.36 |
| linkedin             |    2066 |    58.76 |
| amazon               |    1321 |    44.50 |
| msnworld             |    4081 |    43.08 |
| ssl                  |    1375 |    36.40 |
| wallstreetjournal    |      91 |    27.19 |
| flipboard            |    2150 |    24.05 |
| ebay                 |     345 |    22.69 |
| naver                |    3846 |    20.92 |
| mobileme             |    2712 |    20.13 |
| icloud_photostream   |    1355 |    18.21 |
| googlemap            |     107 |    16.19 |
| waze                 |      72 |    14.29 |
| xboxlive             |     533 |    14.15 |
| quic                 |     160 |    13.22 |
| friendster           |      63 |    11.59 |
| playstationnetwork   |     792 |    10.51 |
| yandex               |     893 |    10.38 |
| speedtest            |     116 |     9.28 |
| path                 |      71 |     8.26 |
| salesforce           |      15 |     7.85 |
| ning                 |      70 |     6.72 |
| mocospace            |      44 |     6.50 |
| imap                 |    1005 |     5.68 |
| nopayload            |    1768 |     4.10 |
| amazonkindle         |      25 |     3.32 |
| paypal               |     337 |     2.70 |
| mailru               |      83 |     2.09 |
| taobao               |     185 |     1.84 |
| koreanshoppingmall   |       3 |     1.39 |
| sina                 |     311 |     1.15 |
| daum                 |     330 |     1.06 |
| shazam               |      38 |     0.86 |
| bbmchannels          |      69 |     0.75 |
| fc2                  |      20 |     0.56 |
| nate                 |      54 |     0.54 |
| yelp                 |       9 |     0.47 |
| googleearth          |      26 |     0.17 |
| tstore               |      26 |     0.16 |
| puffinacademy        |       8 |     0.12 |
| wap2                 |      12 |     0.08 |
| yahoo_video          |       3 |     0.05 |
| kaixin001            |       4 |     0.01 |
| amebajp              |       3 |     0.00 |
+----------------------+---------+----------+
65 rows in set (14.01 sec)


select brand, count(distinct phone) Uniq_Subs, count(1) nCount, round(sum(b_usage)/1000000,2) nUsageMB, round(avg(b_usage)/1000000,2) AvgUsageMB from powerapp_log where datein >= '2014-10-15' and datein < '2014-10-16' and b_usage > 25000000 group by 1;
+--------+-----------+--------+----------+
| Brand  | Uniq_Subs | nCount | nUsageMB |
+--------+-----------+--------+----------+
| BUDDY  |       711 |    916 | 45827.03 |
| POSTPD |        12 |     14 |   582.51 |
| TNT    |       519 |    612 | 27270.45 |
+--------+-----------+--------+----------+

select brand, count(distinct phone) Uniq_Subs, count(1) nCount, round(sum(b_usage)/1000000,2) nUsageMB from powerapp_log where datein >= '2014-10-15' and datein < '2014-10-16' and plan='FACEBOOK' group by 1;
+--------+-----------+--------+----------+
| brand  | Uniq_Subs | nCount | nUsageMB |
+--------+-----------+--------+----------+
| BUDDY  |       339 |    346 | 14916.38 |
| POSTPD |         2 |      2 |    62.41 |
| TNT    |       292 |    292 | 12162.85 |
+--------+-----------+--------+----------+





select count(distinct phone) Uniq from powerapp_log where datein < '2014-10-01';
select count(distinct phone) Uniq from powerapp_log where datein datein < '2014-10-17';

select brand Brand, count(distinct phone) from powerapp_log where plan = 'MYVOLUME' group by 1;
create table tmp_liberation_mins (phone varchar(12) not null, brand varchar(20), primary key (phone));
create table tmp_users_new (phone varchar(12), primary key (phone));

insert ignore into tmp_liberation_mins select phone, max(brand), min(datein) from powerapp_log where datein >= '2014-10-26' and plan = 'MYVOLUME' group by 1;
insert into tmp_users_new select phone from powerapp_log where datein >= '2014-09-26' and plan <> 'MYVOLUME' group by 1;

select count from tmp_liberation_mins a where exists (select 1 from tmp_users_new b where a.phone=b.phone);
select count(1) from tmp_liberation_mins a where exists (select 1 from powerapp_log b where b.datein >= '2014-09-26' and b.plan <> 'MYVOLUME' and a.phone=b.phone);




BUCKET
select left(datein,10) txDate, count(1) nTotal, sum(IF(b_usage=0,1,0)) OMB_Users, sum(IF(b_usage>25000000,1,0)) 25MB_Users, sum( IF(b_usage=0,0,IF(b_usage<25000000,1,0))) Less_25MB_Users from powerapp_log where plan = 'MYVOLUME' and datein >= '2014-09-26' group by 1;
+------------+--------+-----------+------------+-----------------+
| txDate     | nTotal | OMB_Users | 25MB_Users | Less_25MB_Users |
+------------+--------+-----------+------------+-----------------+
| 2014-09-26 | 134384 |    134384 |          0 |               0 |
| 2014-09-27 | 246754 |    244474 |         45 |            2235 |
| 2014-09-28 | 236014 |    233460 |         82 |            2472 |
| 2014-09-29 | 322925 |    319594 |        109 |            3222 |
| 2014-09-30 | 274970 |    274970 |          0 |               0 |
| 2014-10-01 | 254735 |    254735 |          0 |               0 |
| 2014-10-02 | 384915 |    378788 |        153 |            5974 |
| 2014-10-03 | 474409 |    468755 |        103 |            5551 |
| 2014-10-04 | 572797 |    565860 |        128 |            6809 |
| 2014-10-05 | 549118 |    540176 |        147 |            8795 |
| 2014-10-06 | 624227 |    617423 |        158 |            6646 |
| 2014-10-07 | 641650 |    633966 |        153 |            7531 |
| 2014-10-08 | 652786 |    645738 |         83 |            6965 |
| 2014-10-09 | 648009 |    645682 |         14 |            2313 |
| 2014-10-10 | 570470 |    565616 |         56 |            4798 |
| 2014-10-11 | 667077 |    655305 |        162 |           11610 |
| 2014-10-12 | 650287 |    639811 |        127 |           10349 |
| 2014-10-13 | 660881 |    652335 |        136 |            8410 |
| 2014-10-14 | 653235 |    642973 |        121 |           10141 |
| 2014-10-15 | 693781 |    684383 |        151 |            9247 |
+------------+--------+-----------+------------+-----------------+
22 rows in set (11 min 14.71 sec)
select left(datein,10) txDate, count(1) nTotal, sum(IF(b_usage=0,1,0)) OMB_Users, sum(IF(b_usage>25000000,1,0)) 25MB_Users, sum( IF(b_usage=0,0,IF(b_usage<25000000,1,0))) Less_25MB_Users from powerapp_log where datein >= '2014-09-26' group by 1;
+------------+---------+-----------+------------+-----------------+
| txDate     | nTotal  | OMB_Users | 25MB_Users | Less_25MB_Users |
+------------+---------+-----------+------------+-----------------+
| 2014-09-26 |  459618 |    459618 |          0 |               0 |
| 2014-09-27 |  678132 |    658011 |       1481 |           18640 |
| 2014-09-28 |  654862 |    638975 |       1265 |           14622 |
| 2014-09-29 |  832463 |    817681 |       1051 |           13731 |
| 2014-09-30 |  733865 |    733865 |          0 |               0 |
| 2014-10-01 |  696351 |    696351 |          0 |               0 |
| 2014-10-02 |  952407 |    927920 |       1519 |           22968 |
| 2014-10-03 | 1116967 |   1093625 |       1546 |           21796 |
| 2014-10-04 | 1289522 |   1264597 |       1564 |           23361 |
| 2014-10-05 | 1255450 |   1225409 |       1662 |           28379 |
| 2014-10-06 | 1400831 |   1377882 |       1538 |           21411 |
| 2014-10-07 | 1424888 |   1399661 |       1338 |           23889 |
| 2014-10-08 | 1441392 |   1418545 |       1152 |           21695 |
| 2014-10-09 | 1441790 |   1429066 |        902 |           11822 |
| 2014-10-10 | 1269808 |   1251414 |        989 |           17405 |
| 2014-10-11 | 1466597 |   1431056 |       1830 |           33711 |
| 2014-10-12 | 1426517 |   1394836 |       1740 |           29941 |
| 2014-10-13 | 1446774 |   1420810 |       1467 |           24497 |
| 2014-10-14 | 1425253 |   1393916 |       1605 |           29732 |
| 2014-10-15 | 1509504 |   1481212 |       1542 |           26750 |
+------------+---------+-----------+------------+-----------------+
22 rows in set (48.62 sec)


create temporary table tmp_lib_report_mins(phone varchar(12) not null, plan varchar(20) not null
select count(1) from (select phone, count(distinct plan) plan_ctr 
from powerapp_log where datein >= '2014-09-30' and datein < '2014-10-01' and plan <> 'MYVOLUME' and plan <> 'CLASHOFCLANS' group by phone) a where plan_ctr > 1;

select brand, count(1) from (select phone, left(datein,10) datein, max(brand) brand,count(distinct plan) plan_ctr 
from powerapp_log where datein >= '2014-09-01' and datein < '2014-10-01' and plan <> 'MYVOLUME' and plan <> 'CLASHOFCLANS' group by phone, 2 having count(1)> 1) a group by brand;

select * from (select phone, left(datein,10) datein, max(brand) brand,count(distinct plan) plan_ctr 
from powerapp_log where datein >= '2014-09-30' and datein < '2014-10-01' and plan <> 'MYVOLUME' and plan <> 'CLASHOFCLANS' group by phone, 2 having count(1) > 1 a where plan_ctr > 1 limit 10;
select * from powerapp_log where datein >= '2014-09-30' and datein < '2014-10-01' and phone = '639071029434';


create table tmp_lib_report_mins (phone varchar(12) not null, brand varchar(20) not null, datein date, hits int, primary key (phone));
select '2014-09-30' into @tranDt;
insert ignore into tmp_lib_report_mins 
select phone, max(brand), min(left(datein,10)) datein, count(distinct plan) plan_ctr 
from  powerapp_log 
where datein >= @tranDt and datein < date_add(@tranDt, interval 1 day)
and   plan <> 'MYVOLUME' and plan <> 'CLASHOFCLANS' 
group by phone 
having count(distinct plan) > 1;
select * from tmp_lib_report_mins order by datein desc limit 10;

+--------+----------+
| brand  | count(1) |
+--------+----------+
| BUDDY  |    69783 |
| POSTPD |     1229 |
| TNT    |    84446 |
+--------+----------+

select '2014-09-01' into @tranDt;
truncate table tmp_social_chat;
create temporary table tmp_social_chat (phone varchar(12) not null, datein date, plan varchar(20), primary key (phone, datein, plan));
insert ignore into tmp_social_chat
select phone, left(datein,10) datein, 'PHOTO'
from  powerapp_log 
where datein >= '2014-09-01' and datein < '2014-10-01'
and   plan = 'PHOTO'
and   brand = 'POSTPD'
group by 1,2,3;

select count(distinct phone) from (select phone, datein, count(1) from tmp_social_chat group by 1,2 having count(1) > 1) a;


### Liberation UPSELL
1. select count(distinct phone) uniq from powerapp_log where  datein < curdate();
select count(distinct phone) uniq from powerapp_log where  datein < '2014-10-01';
select count(distinct phone) uniq from powerapp_log where  datein < curdate() and plan = 'MYVOLUME';

2. select brand, count(distinct phone) uniq from powerapp_log where  datein > '2014-09-26' and datein < curdate() and plan = 'MYVOLUME' group by 1;

3.
truncate from tmp_liberation_mins;
insert ignore into tmp_liberation_mins select phone, max(brand), min(datein) from powerapp_log where datein >= '2014-12-04' and datein < curdate() and plan = 'MYVOLUME' group by 1;
select brand, count(distinct phone) from powerapp_log a where datein >= '2014-09-26' and datein < curdate() and exists (select 1 from tmp_liberation_mins b where a.phone=b.phone) group by brand;


select a.phone, a.datein, round(sum(b.download+b.upload)/1000000,2) usage_mb
from  tmp_liberation_mins a, powerapp_nds_log b
where a.phone = b.phone
and   a.datein <= '2014-11-02'
and   b.tx_date = '2014-11-01'
and   




insert ignore into tmp_liberation_mins select phone, max(brand), min(datein) from powerapp_log where datein >= '2014-10-26' and plan = 'MYVOLUME' group by 1;
select brand, count(distinct phone) from powerapp_log a where datein >= '2014-09-26' and datein < curdate() and exists (select 1 from tmp_liberation_mins b where a.phone=b.phone) group by brand;

1. With Liberation package
select count(1)  from powerapp_users_apn a, tmp_chikka_apn b where a.phone = b.phone and a.brand = 'TNT' and exists (select 1 from tmp_liberation_mins c where a.phone=c.phone);


2. Didn't avail Liberation but in the Chikka APN 
select count(1) from powerapp_users_apn a, tmp_chikka_apn b where a.phone = b.phone and a.brand = 'TNT' and not exists (select 1 from tmp_liberation_mins c where a.phone=c.phone);



select  brand, count(1) from tmp_liberation_mins a where exists (select 1 from tmp_chikka_apn b where a.phone=b.phone) group by 1;
1. MIN count of Smart prepaid subs Liberation takers but are on Chikka APN ¡V as of Dec 3
   BUDDY:    737,958
   TNT  :  4,001,504

select  brand, count(1) from powerapp_users_apn a where exists (select 1 from tmp_chikka_apn b where a.phone=b.phone) group by 1;
2. MIN list of ALL Smart Prepaid Subs in Chikka APN ¡V latest date also
   BUDDY:   1,915,880
   TNT  :   5,356,132




TNT Liberation usage per MINs

select a.phone, b.tx_date, sum(IF(b.service='FacebookService',b.transmit+b.received,0)) total_fb_usage, round(sum(b.transmit+b.received)/1000000,2) total_usage_mb 
into outfile '/tmp/Liberation_TNT_usage_20141212.csv' fields terminated by ',' lines terminated by '\n' 
from  tmp_liberation_mins a, powerapp_nds_log_bkp20141212 b
where a.phone = b.phone
and   a.datein < '2014-12-13'
and   b.tx_date = '2014-12-12'
and  a.brand = 'TNT'
group by 1,2;
   