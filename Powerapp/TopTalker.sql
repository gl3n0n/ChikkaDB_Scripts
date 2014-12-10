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


