CREATE TABLE `tmp_coc_users` (
  `id` int(11) NOT NULL DEFAULT '0',
  `phone` varchar(12) NOT NULL,
  `brand` varchar(16) DEFAULT NULL,
  `plan` varchar(16) DEFAULT NULL,
  `validity` int(11) DEFAULT '0',
  `start_tm` datetime DEFAULT NULL,
  `end_tm` datetime DEFAULT NULL,
  `source` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
);

create table tmp_coc_usage like powerapp_udr_log;
select tx_date, count(1) from powerapp_udr_log where service ='ClashofclansService' group  by tx_date;
insert into tmp_coc_usage ( tx_date, start_tm, end_tm, phone, ip_addr, source, service, b_usage ) 
select tx_date, start_tm, end_tm, phone, ip_addr, source, service, b_usage 
from powerapp_udr_log where tx_date = '2014-07-22' and service ='ClashofclansService';

select tx_date, count(1) from tmp_coc_usage group  by tx_date;

insert into tmp_coc_usage (tx_date, start_tm, end_tm, phone, ip_addr, source, service, b_usage )
select tx_date, start_tm, end_tm, phone, ip_addr, source, service, b_usage from powerapp_udr_log where tx_date = '2014-07-22' and service = '';


create temporary table tmp_plan_active_users (phone varchar(12) not null, tx_date date, hits int(11), primary key (phone, tx_date));
delete from tmp_plan_active_users;
insert into tmp_plan_active_users select phone, left(datein,10), count(1) 
from powerapp_log 
where datein between '2014-07-06 00:00:00' and '2014-07-07 23:59:59'
and   plan = 'UNLI'
group by 1,2;

select count(1) Bought_2x from (select phone, count(1) from tmp_plan_active_users group by phone having count(1) > 1) t;
select count(1) Bought_1x from (select phone, count(1) from tmp_plan_active_users group by phone having count(1) = 1) t;
Bought_2x: 790
Bought_1x: 5192

delete from tmp_plan_active_users where phone in (select phone from tmp_plan_active_users group by phone having count(1) > 1);
delete from tmp_coc_users;
insert into tmp_coc_users (id, phone, brand, plan, validity, start_tm, end_tm, source)
	select id, phone, brand, plan, validity, datein, date_add(datein, interval validity second) dateend, source 
	from  powerapp_log a 
	where datein between '2014-07-06 00:00:00' and '2014-07-07 23:59:59'
	and   plan = 'UNLI'
	and   exists (select 1 from tmp_plan_active_users b where a.phone=b.phone);

select count(distinct phone) uniq, count(distinct id) buys from tmp_coc_users;
+------+------+
| uniq | buys |
+------+------+
|  790 | 1621 |
+------+------+

select round(sum(b_usage/1000000),0) Usage_in_MB, 
       count(distinct phone) Uniq_with_Usage, 
       count(distinct id) No_of_Buys_with_Usage
from (
select a.id, a.phone, a.plan, a.start_tm datein,  
       b.start_tm, b.end_tm, b.ip_addr, b.source, b.service, b.b_usage
from tmp_coc_users a left outer join tmp_coc_usage b 
on a.phone=b.phone and b.start_tm between a.start_tm and a.end_tm 
where b.id is not null
order by a.phone, a.id, b.start_tm
) t ;


create temporary table tmp_plan_users_no_usage (phone varchar(12) not null, tx_date date, hits int(11), primary key (phone, tx_date));
insert into tmp_plan_users_no_usage
select phone, left(datein,10), count(1) from (
select a.id, a.phone, a.plan, a.start_tm datein,  
       b.start_tm, b.end_tm, b.ip_addr, b.source, b.service, b.b_usage
from tmp_coc_users a left outer join tmp_coc_usage b 
on a.phone=b.phone and b.start_tm between a.start_tm and a.end_tm 
where b.id is null
and  a.start_tm >= '2014-07-06' and a.start_tm < '2014-07-07' 
order by a.phone, a.id, b.start_tm
) t group by 1,2; 

select count(distinct phone) Uniq_with_NoUsage, count(distinct id) No_of_Buys_with_NoUsage from (
select a.id, a.phone, a.plan, a.start_tm datein,  
       b.start_tm, b.end_tm, b.ip_addr, b.source, b.service, b.b_usage
from tmp_coc_users a left outer join tmp_coc_usage b 
on a.phone=b.phone and b.start_tm between a.start_tm and a.end_tm 
where b.id is not null
and  a.start_tm >= '2014-07-07' and a.start_tm < '2014-07-08' 
order by a.phone, a.id, b.start_tm
) t
where exists (select 1 from tmp_plan_users_no_usage b where t.phone=b.phone); 


+-------------+-----------------+-------------------------+ 
| Usage_in_MB | Uniq_with_Usage | No_of_Buys_with_NoUsage | 
+-------------+-----------------+-------------------------+ 
|         544 |              66 |                     109 | 
+-------------+-----------------+-------------------------+ 

+-------------------+-------------------------+
| Uniq_with_NoUsage | No_of_Buys_with_NoUsage |
+-------------------+-------------------------+
|               747 |                    1512 |
+-------------------+-------------------------+


+----------+-------------+------+-----+---------+----------------+
| Field    | Type        | Null | Key | Default | Extra          |
+----------+-------------+------+-----+---------+----------------+
| id       | int(12)     | NO   | PRI | NULL    | auto_increment |
| tx_date  | date        | NO   | MUL | NULL    |                |
| start_tm | datetime    | NO   |     | NULL    |                |
| end_tm   | datetime    | NO   |     | NULL    |                |
| phone    | varchar(12) | NO   | MUL | NULL    |                |
| ip_addr  | varchar(20) | YES  |     | NULL    |                |
| source   | varchar(30) | YES  |     | NULL    |                |
| service  | varchar(30) | YES  |     | NULL    |                |
| b_usage  | int(12)     | YES  |     | 0       |                |
+----------+-------------+------+-----+---------+----------------+



select * from tmp_coc_usage where phone = 639105698469;

+----------+---------------------+--------------+-------+--------+------+----------+-------+---------------------+---------------------+----------+---------+---------+---------------------+----------+------------+---------------------+---------------------+--------------+----------------+-----------------------------+---------------------+---------+
| id       | datein              | phone        | brand | action | plan | validity | free  | start_tm            | end_tm              | source   | b_usage | c_usage | dateend             | id       | tx_date    | start_tm            | end_tm              | phone        | ip_addr        | source                      | service             | b_usage |
+----------+---------------------+--------------+-------+--------+------+----------+-------+---------------------+---------------------+----------+---------+---------+---------------------+----------+------------+---------------------+---------------------+--------------+----------------+-----------------------------+---------------------+---------+
| 15388671 | 2014-07-07 22:35:59 | 639071030305 | TNT   | NEW    | UNLI |    86400 | false | 2014-07-07 22:35:59 | 2014-07-08 22:35:59 | sms_user |       0 |       0 | 2014-07-08 22:35:59 | 26435587 | 2014-07-07 | 2014-07-07 23:08:02 | 2014-07-07 23:17:41 | 639071030305 | 10.246.229.148 | supercellgames_clashofclans | ClashofclansService | 2097940 |
| 15388671 | 2014-07-07 22:35:59 | 639071030305 | TNT   | NEW    | UNLI |    86400 | false | 2014-07-07 22:35:59 | 2014-07-08 22:35:59 | sms_user |       0 |       0 | 2014-07-08 22:35:59 | 26435704 | 2014-07-07 | 2014-07-07 23:18:26 | 2014-07-07 23:27:41 | 639071030305 | 10.246.229.148 | supercellgames_clashofclans | ClashofclansService |  870267 |
| 15388671 | 2014-07-07 22:35:59 | 639071030305 | TNT   | NEW    | UNLI |    86400 | false | 2014-07-07 22:35:59 | 2014-07-08 22:35:59 | sms_user |       0 |       0 | 2014-07-08 22:35:59 | 26435828 | 2014-07-07 | 2014-07-07 23:27:54 | 2014-07-07 23:37:41 | 639071030305 | 10.246.229.148 | supercellgames_clashofclans | ClashofclansService | 2354888 |
| 15388671 | 2014-07-07 22:35:59 | 639071030305 | TNT   | NEW    | UNLI |    86400 | false | 2014-07-07 22:35:59 | 2014-07-08 22:35:59 | sms_user |       0 |       0 | 2014-07-08 22:35:59 | 26435945 | 2014-07-07 | 2014-07-07 23:38:01 | 2014-07-07 23:47:41 | 639071030305 | 10.246.229.148 | supercellgames_clashofclans | ClashofclansService | 3451720 |
| 15388671 | 2014-07-07 22:35:59 | 639071030305 | TNT   | NEW    | UNLI |    86400 | false | 2014-07-07 22:35:59 | 2014-07-08 22:35:59 | sms_user |       0 |       0 | 2014-07-08 22:35:59 | 26436053 | 2014-07-07 | 2014-07-07 23:47:47 | 2014-07-07 23:57:41 | 639071030305 | 10.246.229.148 | supercellgames_clashofclans | ClashofclansService | 1674692 |
+----------+---------------------+--------------+-------+--------+------+----------+-------+---------------------+---------------------+----------+---------+---------+---------------------+----------+------------+---------------------+---------------------+--------------+----------------+-----------------------------+---------------------+---------+
5 rows in set (0.35 sec)


select left(start_tm, 13) dd_hh, sum(b_usage/1000000) mb_usage from tmp_coc_usage group by 1 order by 1;
select left(start_tm, 13) dd_hh, sum(b_usage/1000000) mb_usage from tmp_coc_usage group by 1 order by 2 desc limit 10;
+---------------+----------+
| dd_hh         | mb_usage |
+---------------+----------+
| 2014-07-06 21 |  98.7003 |
| 2014-07-06 10 |  87.3613 |
| 2014-07-06 20 |  86.3560 |
| 2014-07-06 22 |  80.4454 |
| 2014-07-06 09 |  74.4537 |
| 2014-07-06 08 |  73.2991 |
| 2014-07-06 14 |  71.7359 |
| 2014-07-06 15 |  68.7513 |
| 2014-07-06 00 |  63.4421 |
| 2014-07-06 13 |  58.2177 |
+---------------+----------+

mysql> select left(start_tm, 13) dd_hh, sum(b_usage/1000000) mb_usage from tmp_coc_usage where tx_date='2014-07-07' group by 1 order by 2 desc limit 15;
+---------------+----------+
| dd_hh         | mb_usage |
+---------------+----------+
| 2014-07-07 23 | 131.2070 |
| 2014-07-07 12 | 107.4967 |
| 2014-07-07 14 | 104.4424 |
| 2014-07-07 16 | 102.0321 |
| 2014-07-07 09 | 101.6276 |
| 2014-07-07 18 | 101.4150 |
| 2014-07-07 17 |  94.8834 |
| 2014-07-07 10 |  92.3063 |
| 2014-07-07 13 |  91.5754 |
| 2014-07-07 11 |  91.3522 |
+---------------+----------+
