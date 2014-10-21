drop procedure sp_get_churn_rate;
delimiter //
create procedure sp_get_churn_rate()
begin
   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;
   
   -- create temporary tables
   drop temporary table if exists tmp_last_buy;
   create temporary table tmp_last_buy select phone, max(brand), max(datein) datein from powerapp_log group by 1;
   alter table tmp_last_buy add primary key (phone);
   drop temporary table if exists tmp_last_optout;
   create temporary  table tmp_last_optout select phone, max(brand), max(datein) datein, count(1) no_optout from powerapp_optout_log group by 1;
   alter table tmp_last_optout add primary key (phone);
   
   -- update powerapp_optout_log
   insert ignore into powerapp_optout_log 
   select * 
   from powerapp_flu.powerapp_optout_log 
   where datein >= concat(left(curdate(),8),'01');
   
   -- update powerapp_optout_users
   insert ignore into powerapp_optout_users 
   select phone, min(datein), max(brand), null, max(datein), count(1) 
   from powerapp_flu.powerapp_optout_log 
   where datein >= concat(left(curdate(),8),'01') group by 1;
   
   update powerapp_optout_users set last_buy = (select datein from tmp_last_buy a where a.phone=powerapp_optout_users.phone);
   update powerapp_optout_users set last_optout = (select datein from tmp_last_optout a where a.phone=powerapp_optout_users.phone);
   update powerapp_optout_users set no_optout = (select no_optout from tmp_last_optout a where a.phone=powerapp_optout_users.phone);
   
   -- generate chrun rate
   select count(1) into @nTotal from powerapp_optout_users;
   select count(1) into @nTotal from powerapp_optout_users;
   select count(1) into @n1xTime from powerapp_optout_users where no_optout = 1 or no_optout is null;
   select @nTotal-@n1xTime into @n2xTime;
   select sum(total) into @nOptin from (
   select count(1) total from powerapp_optout_users where last_buy > datein and last_buy is not null and last_optout is null union
   select count(1) total from powerapp_optout_users where last_buy > last_optout and last_buy is not null and last_optout is not null) t;
   select @nTotal-@nOptin into @nOptout;
   
   select concat('Total = ', @nTotal) Optout_Stats union
   select concat('Opted-out 1x = ', @n1xTime)  union
   select concat('Opted-out multiple times = ', @n2xTime) union
   select concat('Opted-out and Opted-in = ', @nOptin) union
   select concat('Opted-out and Never Opt-in = ', @nOptout);
   
   drop temporary table tmp_last_buy;
   drop temporary table tmp_last_optout;
end;
//
delimiter ;


drop temporary table tmp_optin_log;
create temporary table tmp_optin_log like powerapp_log;
truncate table tmp_optin_log;
insert into tmp_optin_log select * from powerapp_log a where datein >= '2014-09-26' and a.plan='MYVOLUME' and exists (select 1 from powerapp_flu.powerapp_optout_log b where datein >= '2014-09-26' and a.phone=b.phone);
select * from powerapp_flu.powerapp_optout_log a where datein >= '2014-09-26' and exists (select 1 from tmp_optin_log b where a.phone=b.phone and b.datein between a.datein and date_add(a.datein, interval 1 hour));


select left(a.datein,10) Date, a.brand, count(1) FreeOptin  from powerapp_flu.powerapp_optout_log a where datein >= '2014-09-26' and exists (select 1 from tmp_optin_log b where a.phone=b.phone and b.datein between a.datein and date_add(a.datein, interval 1 hour)) group by 1,2 order by 2,1;
select left(a.datein,10) Date, a.brand, count(1) Optout from powerapp_flu.powerapp_optout_log a where datein >= '2014-09-26' group by 1,2 order by 2,1;
select left(a.datein,10) Date, a.brand, count(1) from tmp_optin_log a where datein >= '2014-09-26' group by 1,2 order by 2,1;

+------------+-------+--------+-----------+
| Date       | Brand | Optout | FreeOptin |
+------------+-------+--------+-----------+
| 2014-09-26 | BUDDY |   1897 |         1 |
| 2014-09-27 | BUDDY |   1750 |       210 |dhi@oceanic
| 2014-09-28 | BUDDY |   1654 |       207 |
| 2014-09-29 | BUDDY |   1539 |       222 |
| 2014-09-30 | BUDDY |    148 |         9 |
| 2014-09-26 | TNT   |    714 |         1 |
| 2014-09-27 | TNT   |    758 |       119 |
| 2014-09-28 | TNT   |    657 |       178 |
| 2014-09-29 | TNT   |    632 |       239 |
| 2014-09-30 | TNT   |     62 |        10 |
+------------+-------+--------+-----------+
+------------+--------+--------+
| Date       | brand  | Optout |
+------------+--------+--------+
| 2014-09-26 | BUDDY  |   1897 |
| 2014-09-27 | BUDDY  |   1750 |
| 2014-09-28 | BUDDY  |   1654 |
| 2014-09-29 | BUDDY  |   1539 |
| 2014-09-30 | BUDDY  |    148 |
| 2014-09-26 | TNT    |    714 |
| 2014-09-27 | TNT    |    758 |
| 2014-09-28 | TNT    |    657 |
| 2014-09-29 | TNT    |    632 |
| 2014-09-30 | TNT    |     62 |
+------------+--------+--------+
| 2014-09-26 | POSTPD |     19 |
| 2014-09-27 | POSTPD |     24 |
| 2014-09-28 | POSTPD |     36 |
| 2014-09-29 | POSTPD |     23 |

                                   
+------------+-------+----------+  
| Date       | brand | count(1) |
+------------+-------+----------+
| 2014-09-26 | BUDDY |     1508 |
| 2014-09-28 | BUDDY |   105472 |
| 2014-09-29 | BUDDY |   132397 |
| 2014-09-30 | BUDDY |     5618 |
| 2014-09-26 | TNT   |      210 |
| 2014-09-28 | TNT   |   130542 |
| 2014-09-29 | TNT   |   190528 |
| 2014-09-30 | TNT   |     4951 |
+------------+-------+----------+

+------------+--------+----------+
| Date       | brand  | count(1) |
+------------+--------+----------+
| 2014-09-26 | BUDDY  |     1897 |
| 2014-09-28 | BUDDY  |     1654 |
| 2014-09-29 | BUDDY  |     1539 |
| 2014-09-30 | BUDDY  |      100 |
| 2014-09-26 | TNT    |      714 |
| 2014-09-28 | TNT    |      657 |
| 2014-09-29 | TNT    |      632 |
| 2014-09-30 | TNT    |       42 |
+------------+--------+----------+
| 2014-09-26 | POSTPD |       19 |
| 2014-09-27 | POSTPD |       24 |
| 2014-09-28 | POSTPD |       36 |
| 2014-09-29 | POSTPD |       23 |
+------------+--------+----------+

create temporary table tmp_optin_log like powerapp_sun.powerapp_log;
truncate table tmp_optin_log;
insert into tmp_optin_log select * from powerapp_sun.powerapp_log a where datein >= '2014-09-26' and a.plan='MYVOLUME' and exists (select 1 from powerapp_sun.powerapp_optout_log b where datein >= '2014-09-26' and a.phone=b.phone);
select * from powerapp_sun.powerapp_optout_log a where datein >= '2014-09-26' and exists (select 1 from tmp_optin_log b where a.phone=b.phone and b.datein between a.datein and date_add(a.datein, interval 1 hour));



+------------+--------+----------+
| Date       | brand  | count(1) |
+------------+--------+----------+
| 2014-09-26 | BUDDY  |     1897 |
| 2014-09-27 | BUDDY  |     1750 |
| 2014-09-28 | BUDDY  |     1654 |
| 2014-09-29 | BUDDY  |     1539 |
| 2014-09-30 | BUDDY  |      138 |
| 2014-09-26 | POSTPD |       19 |
| 2014-09-27 | POSTPD |       24 |
| 2014-09-28 | POSTPD |       36 |
| 2014-09-29 | POSTPD |       23 |
| 2014-09-26 | TNT    |      714 |
| 2014-09-27 | TNT    |      758 |
| 2014-09-28 | TNT    |      657 |
| 2014-09-29 | TNT    |      632 |
| 2014-09-30 | TNT    |       55 |



BacktoschoolService |    45705 |
ChatService         |    83218 |
ClashofclansService |    29502 |
EmailService        |     3302 |
FacebookService     |  2394879 |
LineService         |      676 |
MyvolumeService     |  1048673 |
NoEnforce           |  2289192 |
PhotoService        |     3231 |
PisonetService      |    18093 |
SnapchatService     |        3 |
SocialService       |   121142 |
SpeedBoostService   |    46070 |
TumblrService       |       12 |
UnlimitedService    |  1363342 |
WazeService         |       15 |
WechatService       |     1093 |
Whitelisted         | 28258165 |
WikipediaService    |     1439 |
YoutubeService      |        9 |

insert into powerapp_plans values ('MYVOLUME', 86400, 0, 'MyvolumeService');

                        





+---------+---------+---------+---------+--------------+-------------+
| Month   |   BUDDY |  POSTPD |     TNT | SUN Postpaid | SUN Prepaid |
+---------+---------+---------+---------+--------------+-------------+
| 2013-11 |      35 |      11 |       7 |              |             |
| 2013-12 |   18240 |     480 |   13340 |              |             |
| 2014-01 |   59130 |     977 |   26917 |              |             |
| 2014-02 |  103658 |    3600 |  235563 |              |             |
| 2014-03 |  223806 |    2915 |  359161 |              |             |
| 2014-04 |  424457 |    6040 |  559161 |              |             |
| 2014-05 |  389387 |    5115 |  427054 |              |             |
| 2014-06 |  214483 |    4131 |  333425 |              |             |
| 2014-07 |  265715 |    4202 |  318474 |            7 |          12 |
| 2014-08 |  337889 |    5069 |  531630 |          681 |       57894 |
| 2014-09 |  818455 |    5682 |  986099 |         1324 |      110121 |
+---------+---------+---------+---------+--------------+-------------+
                                         
| 2013-11 | POSTPD |        11 |         
| 2013-12 | POSTPD |       480 |
| 2014-01 | POSTPD |       977 |
| 2014-02 | POSTPD |      3600 |
| 2014-03 | POSTPD |      2915 |
| 2014-04 | POSTPD |      6040 |
| 2014-05 | POSTPD |      5115 |
| 2014-06 | POSTPD |      4131 |
| 2014-07 | POSTPD |      4202 |
| 2014-08 | POSTPD |      5069 |
| 2014-09 | POSTPD |      5682 |
| 2014-10 | POSTPD |        72 |
| 2013-11 | TNT    |         7 |
| 2013-12 | TNT    |     13340 |
| 2014-01 | TNT    |     26917 |
| 2014-02 | TNT    |    235563 |
| 2014-03 | TNT    |    359161 |
| 2014-04 | TNT    |    559161 |
| 2014-05 | TNT    |    427054 |
| 2014-06 | TNT    |    333425 |
| 2014-07 | TNT    |    318474 |
| 2014-08 | TNT    |    531630 |
| 2014-09 | TNT    |    986099 |
| 2014-10 | TNT    |      8555 |
+---------+--------+-----------+
40 rows in set (1 min 50.21 sec)


+---------+--------------+-------------+
| Month   | SUN Postpaid | SUN Prepaid |
+---------+--------------+-------------+
| 2014-07 |            7 |          12 |
| 2014-08 |          681 |       57894 |
| 2014-09 |         1324 |      110121 |
+---------+--------------+-------------+
| 2014-07 | PREPAID  |           12 |          12 |
| 2014-08 | PREPAID  |        57894 |       57894 |
| 2014-09 | PREPAID  |       110121 |      110121 |
| 2014-10 | PREPAID  |         6234 |        6234 |
+---------+----------+--------------+-------------+
7 rows in set (1.83 sec)










