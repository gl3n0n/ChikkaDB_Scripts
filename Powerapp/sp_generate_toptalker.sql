drop procedure sp_generate_toptalker;
delimiter //
create procedure sp_generate_toptalker (p_trandate date)
begin
   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   delete from powerapp_nds_toptalker where tx_date=  p_trandate;
   insert into powerapp_nds_toptalker (tx_date, phone, transmit, received, tx_usage)
   select tx_date, phone, sum(transmit), sum(received), sum(transmit+received)
   from   powerapp_nds_log
   where  tx_date = p_trandate
   group  by tx_date, phone
   order  by 5 desc
   limit 1000;

   delete from powerapp_nds_toptalker_services where tx_date=  p_trandate;
   insert into powerapp_nds_toptalker_services (tx_date, phone, service, transmit, received, tx_usage)
   select tx_date, phone, service, sum(transmit), sum(received), sum(transmit+received) 
   from   powerapp_nds_log a
   where  tx_date = p_trandate
   and    exists (select 1 from powerapp_nds_toptalker b where a.tx_date=b.tx_date and a.phone=b.phone)
   group by tx_date, phone, service
   having sum(transmit+received) > 0;

   delete from powerapp_nds_toptalker_buys where tx_date=  p_trandate;
   insert into powerapp_nds_toptalker_buys (tx_date, phone, plan, hits)
   select left(datein,10) tx_date, phone, plan, count(1) hits 
   from    powerapp_log a 
   where  datein >= p_trandate and datein < date_add(p_trandate, interval 1 day)
   and    plan <> 'MYVOLUME' 
   and    exists (select 1 from powerapp_nds_toptalker b where b.tx_date = p_trandate and a.phone = b.phone)
   group by left(datein,10), phone, plan;

   delete from powerapp_nds_brand_usage where tx_date=  p_trandate;
   insert ignore into powerapp_nds_brand_usage (tx_date, brand, transmit, received, tx_usage, num_subs)
   select b.tx_date, a.brand, sum(b.transmit), sum(b.received), sum(b.transmit+b.received), count(distinct phone) 
   from   powerapp_users_apn a, powerapp_nds_log b 
   where  a.phone = b.phone
   and    b.tx_date = p_trandate
   group by  b.tx_date, a.brand;
   

end;
//
delimiter ;

GRANT EXECUTE ON PROCEDURE `archive_powerapp_flu`.`sp_generate_toptalker` TO 'stats'@'localhost';
flush privileges;


select count(distinct phone) from powerapp_log where datein >= '2014-09-01 00:00:00' and datein < '2014-09-01 05:00:00';
select count(distinct phone) from powerapp_log where datein >= '2014-09-02 00:00:00' and datein < '2014-09-02 05:00:00';

select count(distinct phone) from powerapp_udr_log where datein >= '2014-09-02 00:00:00' and datein < '2014-09-02 05:00:00';

select phone, sum(b_usage) tx_usage 
from powerapp_udr_log 
where phone in ('639496650700', '639198713194', '639473863820', '639298149416', '639468946160', '639293610182', '639202485761', '639461936489', '639214639480', '639993514862') 
and tx_date between '2014-08-28' and '2014-08-30'
and start_tm between '2014-08-29' and '2014-08-30'
group by phone;



Subscriber      Bandwidth
639496650700    2,138,911,978
639198713194    2,029,187,753     60,101,824
639473863820    1,929,636,696
639298149416    1,755,271,490
639468946160    1,602,553,060     17,275,290
639293610182    1,527,473,420
639202485761    1,479,879,639
639461936489    1,364,349,746   
639214639480    1,289,772,465
639993514862    1,226,783,683

+--------------+------------+---------------+
| phone        | udr_usage  | Bandwidth     |
+--------------+------------+---------------+
| 639198713194 | 35,166,421 | 2,029,187,753 |
| 639202485761 | 75,253,112 | 1,479,879,639 |
| 639214639480 | 11,581,732 | 1,289,772,465 |
| 639293610182 | 13,031,057 | 1,527,473,420 |
| 639298149416 | 17,020,795 | 1,755,271,490 |
| 639461936489 | 22,293,101 | 1,364,349,746 |
| 639468946160 |  1,129,471 | 1,602,553,060 |
| 639473863820 |  2,154,323 | 1,929,636,696 |
| 639496650700 |  1,402,301 | 2,138,911,978 |
| 639993514862 | 69,759,162 | 1,226,783,683 |
+--------------+------------+---------------+
10 rows in set (0.03 sec)


95,467,266,550


+----------+--------------+------+-----+---------+----------------+
| Field    | Type         | Null | Key | Default | Extra          |
+----------+--------------+------+-----+---------+----------------+
| id       | int(12)      | NO   | PRI | NULL    | auto_increment |
| tx_date  | date         | NO   | MUL | NULL    |                |
| start_tm | datetime     | NO   |     | NULL    |                |
| end_tm   | datetime     | NO   |     | NULL    |                |
| phone    | varchar(12)  | NO   | MUL | NULL    |                |
| ip_addr  | varchar(20)  | YES  |     | NULL    |                |
| source   | varchar(30)  | YES  |     | NULL    |                |
| service  | varchar(30)  | YES  |     | NULL    |                |
| b_usage  | int(12)      | YES  |     | 0       |                |
| device   | varchar(255) | YES  |     | NULL    |                |
+----------+--------------+------+-----+---------+----------------+
10 rows in set (0.02 sec)




insert ignore into powerapp_log ( id, datein, phone, brand, action,  plan, validity, free, start_tm, end_tm, source ) 
select  id, datein, phone, brand, action,  plan, validity, free, start_tm, end_tm, source from powerapp_flu.powerapp_log where datein >= '2014-09-02';

select count(distinct phone) uniq from powerapp_udr_log where tx_date='2014-09-02' and  start_tm >= '2014-09-02' and start_tm < '2014-09-02 05:00:00';
select left(start_tm, 13) Date_HH, count(distinct phone) uniq from powerapp_udr_log where tx_date='2014-09-02' and  start_tm >= '2014-09-02' and start_tm < '2014-09-02 05:00:00' and service <> 'Whitelisted' group by 1;

select count(distinct phone) uniq from powerapp_udr_log where tx_date='2014-09-02' and  start_tm >= '2014-09-02' and start_tm < '2014-09-02 05:00:00' and service <> 'Whitelisted';
select left(datein, 13) Date_HH, count(distinct phone) uniq from powerapp_log where datein >= '2014-09-02' and datein < '2014-09-02 05:00:00' group by 1;

Buys
+------------------+------+
| Date_HH          | uniq |
+------------------+------+
| 2014-09-02 00    | 1581 |
| 2014-09-02 01    |  963 |
| 2014-09-02 02    |  624 |
| 2014-09-02 03    |  596 |
| 2014-09-02 04    |  793 |
+------------------+------+
5 rows in set (0.05 sec)

UDR Log
+--------------------+--------+
| Date_HH            | uniq   |
+--------------------+--------+
| 2014-09-02 00      | 126822 |
| 2014-09-02 01      | 130350 |
| 2014-09-02 02      |  89057 |
| 2014-09-02 03      | 113582 |
| 2014-09-02 04      |  91328 |
+--------------------+--------+
5 rows in set (1 min 29.10 sec)

+--------+
| uniq   |
+--------+
| 133069 |
+--------+


+---------------+-------+
| Date_HH       | uniq  |
+---------------+-------+
| 2014-09-02 00 | 85273 |
| 2014-09-02 01 | 85554 |
| 2014-09-02 02 | 40019 |
| 2014-09-02 03 | 70376 |
| 2014-09-02 04 | 44206 |
+---------------+-------+

+---------------------+-------------+
| service             | b_usage     |
+---------------------+-------------+
| FacebookService     | 36285155335 |
| UnlimitedService    | 10860318375 |
| SocialService       |  2036635922 |
| SpeedBoostService   |   977039231 |
| BacktoschoolService |   950446096 |
| ChatService         |   543897483 |
| ClashofclansService |   257211992 |
| WikipediaService    |   170116927 |
| PhotoService        |    88937312 |
| PisonetService      |    48099304 |
| EmailService        |     8603743 |
| TumblrService       |     3552322 |
| YoutubeService      |     2671510 |
| WechatService       |     1149575 |
| SnapchatService     |      249161 |
| LineService         |      223130 |
| 0                   |           0 |
| NoEnforce           |           0 |
+---------------------+-------------+
+-------------+
| b_usage     |
+-------------+
| 52,234,307,418 |
+-------------+




   select tx_date, phone, max(device) device, sum(b_usage) tx_usage, sum(time_to_sec(timediff(end_tm, start_tm))) tx_time, service
   from   powerapp_udr_log a
   where  service <> 'Whitelisted'
   and    not exists (select 1 from tmp_powerapp_mins b where a.phone = b.phone)
   and phone in ('639496650700', '639198713194', '639473863820',
              '639298149416', '639468946160', '639293610182',
              '639202485761', '639461936489', '639214639480',
              '639993514862')
   group  by tx_date, phone, service
   having sum(b_usage) > 0;

select '2014-11-14' into @trandt;
select phone, sum(b_usage) b_usage from powerapp_udr_log 
where   phone in (
 '639994103540',
 '639499404160',
 '639305799914',
 '639098390805',
 '639072792970',
 '639127239042',
 '639301652468',
 '639216356183',
 '639481276497',
 '639123523674')
and tx_date = @trandt
group by phone;


TOP 10 Talker
select '2014-10-18' into @trandt;
select phone, sum(b_usage) b_usage from ( 
select phone, sum(b_usage) b_usage from powerapp_log 
where datein >= @trandt and datein < date_add(@trandt, interval 1 day)
group by phone
union all
select phone, sum(b_usage) b_usage from powerapp_whitelisted_log 
where tx_date = @trandt
group by phone) t group by phone order by 2 desc limit 10;


select '2014-11-03' into @trandt;
select phone, sum(b_usage) b_usage from ( 
select phone, sum(b_usage) b_usage from powerapp_log 
where datein >= @trandt and datein < date_add(@trandt, interval 1 day)
and   phone in (
 '639462918109',
 '639207911610',
 '639489015883',
 '639072187753',
 '639284046237',
 '639468083894',
 '639489416035',
 '639306072409',
 '639469270692',
 '639995765500')
group by phone
union all
select phone, sum(b_usage) b_usage from powerapp_whitelisted_log 
where tx_date = @trandt
and   phone in (
 '639462918109',
 '639207911610',
 '639489015883',
 '639072187753',
 '639284046237',
 '639468083894',
 '639489416035',
 '639306072409',
 '639469270692',
 '639995765500')
group by phone) t group by phone order by 2 desc limit 10;

select phone into outfile '/tmp/BUDDY_20141021.csv' fields terminated by ',' lines terminated by '\n' from tmp_plan_users where brand = 'BUDDY' and plan = 'ALLDAY';

+--------------+------------+
| phone        | b_usage    |
+--------------+------------+
| 639997435628 | 1340499485 |
| 639103140805 | 1262260834 |
| 639394302616 | 1094143580 |
| 639393615350 |  417996845 |
| 639997981044 |  149195598 |
+--------------+------------+


+--------------+------------+
| phone        | b_usage    |
+--------------+------------+
| 639997435628 | 3206193119 |
| 639103140805 | 2582888713 |
| 639997981044 | 1792308078 |
| 639393615350 |  934586700 |
+--------------+------------+
4 rows in set (7.76 sec)

select * from powerapp_log where datein >= '2014-09-14' and datein < '2014-09-15' and phone = '639293610182';
select * from powerapp_udr_log where phone = '639293610182' and service='UnlimitedService';








+--------------+------------++--------------+------------+
| phone        | usage      || phone        | b_usage    |
+--------------+------------++--------------+------------+
| 639994651567 | 4235793202 || 639994651567 | 4235793202 |
| 639398605684 | 3798403355 || 639398605684 | 3798403355 |
| 639085987362 | 3713211449 || 639482573400 | 2896191493 |
| 639482573400 | 2896191493 || 639466251332 | 2119056258 |
| 639484115558 | 2849883458 || 639999170777 | 1627593655 |
| 639424866178 | 2427552039 || 639474816354 | 1593890943 |
| 639466251332 | 2119056258 || 639497398159 | 1565104681 |
| 639085589749 | 2031196566 || 639284582088 | 1427782357 |
| 639107279433 | 1856640625 || 639225240465 |  158177854 |
| 639496177935 | 1785235081 || 639479853107 |    2131227 |
+--------------+------------++--------------+------------+



sftp dbsftpuser@172.17.250.162
tr4n$p0Rt3R!
cd /incoming/

load data local infile '/mnt/paywall_dmp/dmp/nds/out/2015-01-05.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-05';


set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;
create temporary table tmp_toptalker as
select phone, sum(transmit+received) b_usage, group_concat(distinct(service) separator ',') service from tmp_youtube_nds group by phone order by 2 desc limit 10;
alter table tmp_toptalker add key (phone);

create temporary table tmp_toptalker_buys as select phone, plan, count(1) hits from powerapp_log a where datein >= '2015-02-09' and datein < '2015-02-10'
and  exists (select 1 from tmp_toptalker_0209 b where a.phone = b.phone)
group by phone, plan;
alter table tmp_toptalker_buys add key (phone);

select a.phone, a.b_usage, a.service, group_concat(concat(b.plan, ':', hits) separator ',') buys from tmp_toptalker a left outer join tmp_toptalker_buys b
on a.phone = b.phone group by 1,2,3 order by 2 desc,1;

+--------------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------+
| phone        | b_usage    | service                                                                                                                                                                                                                                                                                       | buys                               |
+--------------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------+
| 639485082402 | 2562921348 | FacebookService,ClashofclansService,BacktoschoolService,LineService,ChatService,EmailService,MyvolumeService,SpeedBoostService,SocialService,SnapchatService,PhotoService,PisonetService,WazeService,UnlimitedService,YoutubeService,Whitelisted,TumblrService,WikipediaService,WechatService | FACEBOOK:1,PISONET:8,SPEEDBOOST:47 |
| 639298056555 | 2327945087 | SnapchatService,SpeedBoostService,MyvolumeService,PisonetService,PhotoService,SocialService,UnlimitedService,WikipediaService,Whitelisted,YoutubeService,WazeService,TumblrService,WechatService,EmailService,ClashofclansService,FacebookService,BacktoschoolService,ChatService,LineService | UNLI:1                             |
| 639289993682 | 2306141423 | LineService,FacebookService,ClashofclansService,EmailService,BacktoschoolService,ChatService,SnapchatService,SocialService,MyvolumeService,PisonetService,PhotoService,SpeedBoostService,Whitelisted,UnlimitedService,YoutubeService,WikipediaService,WechatService,TumblrService,WazeService | FACEBOOK:1                         |
| 639107017473 | 2296523636 | MyvolumeService,SocialService,PhotoService,SpeedBoostService,TumblrService,SnapchatService,PisonetService,WazeService,YoutubeService,WikipediaService,Whitelisted,WechatService,UnlimitedService,ChatService,BacktoschoolService,LineService,FacebookService,ClashofclansService,EmailService | FACEBOOK:1                         |
| 639099909009 | 2225313423 | WechatService,UnlimitedService,WikipediaService,YoutubeService,Whitelisted,WazeService,BacktoschoolService,FacebookService,LineService,EmailService,ClashofclansService,ChatService,PisonetService,MyvolumeService,SocialService,TumblrService,SpeedBoostService,PhotoService                 | FACEBOOK:1                         |
| 639074138009 | 2202820289 | BacktoschoolService,FacebookService,LineService,ClashofclansService,EmailService,ChatService,MyvolumeService,SnapchatService,PhotoService,SpeedBoostService,PisonetService,SocialService,TumblrService,WechatService,WikipediaService,WazeService,YoutubeService,UnlimitedService,Whitelisted | FACEBOOK:1                         |
| 639499836863 | 2161076198 | WazeService,Whitelisted,WechatService,YoutubeService,UnlimitedService,TumblrService,WikipediaService,FacebookService,LineService,EmailService,ChatService,BacktoschoolService,ClashofclansService,PhotoService,PisonetService,MyvolumeService,SpeedBoostService,SocialService,SnapchatService | FACEBOOK:1,SPEEDBOOST:11,UNLI:1    |
| 639093579321 | 2018174378 | TumblrService,SocialService,SnapchatService,SpeedBoostService,PhotoService,MyvolumeService,PisonetService,YoutubeService,UnlimitedService,WechatService,WikipediaService,WazeService,Whitelisted,ClashofclansService,EmailService,ChatService,FacebookService,LineService,BacktoschoolService | FACEBOOK:1                         |
| 639477810274 | 2012412619 | ChatService,LineService,EmailService,BacktoschoolService,FacebookService,ClashofclansService,PisonetService,SocialService,PhotoService,MyvolumeService,SpeedBoostService,SnapchatService,YoutubeService,TumblrService,WikipediaService,Whitelisted,WazeService,UnlimitedService,WechatService | FACEBOOK:1                         |
| 639993430168 | 1962104222 | PhotoService,SocialService,SnapchatService,SpeedBoostService,MyvolumeService,PisonetService,TumblrService,WazeService,YoutubeService,Whitelisted,WechatService,UnlimitedService,WikipediaService,EmailService,LineService,BacktoschoolService,ClashofclansService,FacebookService,ChatService | FACEBOOK:1                         |
+--------------+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------+
10 rows in set (0.00 sec)


select phone, service, sum(transmit+received) b_usage from tmp_youtube_nds a where exists (select 1 from tmp_toptalker b where a.phone=b.phone ) group by 1,2 having sum(transmit+received)>0 order by 2 desc,1;

   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;
   set group_concat_max_len = 3200000;

select '2015-02-16' into @p_trandate;
insert into powerapp_nds_toptalker_buys (tx_date, phone, plan, hits)
select left(datein,10) tx_date, phone, plan, count(1) hits 
from   powerapp_log a 
where  datein >= @p_trandate and datein < date_add(@p_trandate, interval 1 day)
and    plan <> 'MYVOLUME' 
and    exists (select 1 from powerapp_nds_toptalker b where b.tx_date = @p_trandate and a.phone = b.phone)
group by left(datein,10), phone, plan;


select phone, tx_usage, max(buys) buys, max(services) services from (
select a.phone, a.tx_usage, 
       group_concat(concat(b.plan, ':', b.hits) separator ' ^ ') buys, 
       null services
from powerapp_nds_toptalker a 
left outer join powerapp_nds_toptalker_buys b on a.tx_date=b.tx_date and a.phone = b.phone 
where a.tx_date = @p_trandate
group by 1,2 
union
select a.phone, a.tx_usage, 
       null buys, 
       group_concat(concat(c.service , ':', c.tx_usage) separator ' ^ ') services
from powerapp_nds_toptalker a 
left outer join powerapp_nds_toptalker_services c on a.tx_date=c.tx_date and a.phone = c.phone  
where a.tx_date = @p_trandate
group by 1,2 
) t1
group by phone, tx_usage
order by tx_usage desc,phone limit 10;



select phone, tx_usage, max(buys) buys, max(services) services from (
select a.phone, a.tx_usage, 
       group_concat(concat(b.plan, ':', b.hits) separator ' ^ ') buys, 
       null services
from powerapp_nds_toptalker a 
left outer join powerapp_nds_toptalker_buys b on a.tx_date=b.tx_date and a.phone = b.phone 
where a.tx_date = @p_trandate
group by 1,2 
union
select a.phone, a.tx_usage, 
       null buys, 
       group_concat(concat(c.service , ':', c.tx_usage) separator ' ^ ') services
from powerapp_nds_toptalker a 
left outer join powerapp_nds_toptalker_services c on a.tx_date=c.tx_date and a.phone = c.phone  
where a.tx_date = @p_trandate
group by 1,2 
) t1
group by phone, tx_usage
having max(buys) is null 
order by tx_usage desc,phone limit 10;


create temporary table tmp_toptalker_buys as select phone, plan, count(1) hits from powerapp_log a where datein >= '2015-02-09' and datein < '2015-02-10'
and  exists (select 1 from tmp_toptalker_0209 b where a.phone = b.phone)
group by phone, plan;
alter table tmp_toptalker_buys add key (phone);
select a.phone, a.receive, group_concat(concat(b.plan, ':', hits) separator ',') buys from tmp_toptalker_0209 a left outer join tmp_toptalker_buys b
on a.phone = b.phone group by 1,2 order by 2 desc,1;
