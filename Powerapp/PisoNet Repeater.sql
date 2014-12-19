drop table if exists tmp_pisonet_users;
create table tmp_pisonet_users (tx_date date not null, phone varchar(12) not null, hits int(11) default 0, primary key (tx_date, phone));
insert into tmp_pisonet_users 
select left(datein,10) tx_date, phone, count(1) hits 
from   powerapp_log 
where  datein >= '2014-08-25' 
and    plan='PISONET' 
and    free='false'
group  by tx_date, phone;

drop table if exists tmp_pisonet_repeater;
create table tmp_pisonet_repeater (tx_date date not null, no_times int(11) default 0, uniq int(11) default 0, primary key (tx_date, no_times));
insert into tmp_pisonet_repeater 
select tx_date, hits no_times, count(distinct phone) uniq from tmp_pisonet_users group by 1,2;

select a.tx_date, 
       ifnull(b01.uniq,0) 1x, 
       ifnull(b02.uniq,0) 2x, 
       ifnull(b03.uniq,0) 3x, 
       ifnull(b04.uniq,0) 4x, 
       ifnull(b05.uniq,0) 5x,
       ifnull(b06.uniq,0) 6x, 
       ifnull(b07.uniq,0) 7x, 
       ifnull(b08.uniq,0) 8x, 
       ifnull(b09.uniq,0) 9x, 
       ifnull(b10.uniq,0) 10x, 
       ifnull(b11.uniq,0) 11x, 
       ifnull(b12.uniq,0) 12x, 
       ifnull(b13.uniq,0) 13x, 
       ifnull(b14.uniq,0) 14x, 
       ifnull(sum(b15.uniq),0) 15x
from tmp_month_days a 
     left outer join tmp_pisonet_repeater b01 on (a.tx_date=b01.tx_date and b01.no_times=1 )
     left outer join tmp_pisonet_repeater b02 on (a.tx_date=b02.tx_date and b02.no_times=2 )
     left outer join tmp_pisonet_repeater b03 on (a.tx_date=b03.tx_date and b03.no_times=3 )
     left outer join tmp_pisonet_repeater b04 on (a.tx_date=b04.tx_date and b04.no_times=4 )
     left outer join tmp_pisonet_repeater b05 on (a.tx_date=b05.tx_date and b05.no_times=5 )
     left outer join tmp_pisonet_repeater b06 on (a.tx_date=b06.tx_date and b06.no_times=6 )
     left outer join tmp_pisonet_repeater b07 on (a.tx_date=b07.tx_date and b07.no_times=7 )
     left outer join tmp_pisonet_repeater b08 on (a.tx_date=b08.tx_date and b08.no_times=8 )
     left outer join tmp_pisonet_repeater b09 on (a.tx_date=b09.tx_date and b09.no_times=9 )
     left outer join tmp_pisonet_repeater b10 on (a.tx_date=b10.tx_date and b10.no_times=10)
     left outer join tmp_pisonet_repeater b11 on (a.tx_date=b11.tx_date and b11.no_times=11)
     left outer join tmp_pisonet_repeater b12 on (a.tx_date=b12.tx_date and b12.no_times=12)
     left outer join tmp_pisonet_repeater b13 on (a.tx_date=b13.tx_date and b13.no_times=13)
     left outer join tmp_pisonet_repeater b14 on (a.tx_date=b14.tx_date and b14.no_times=14)
     left outer join tmp_pisonet_repeater b15 on (a.tx_date=b15.tx_date and b15.no_times>=15)
where a.tx_date > '2014-08-24'
group by  a.tx_date;


select * from tmp_pisonet_repeater where tx_date = '2014-09-04';
select count(1) hits, count(distinct phone) uniq from powerapp_log where datein  >= '2014-09-04' and datein < '2014-09-05' and plan='PISONET';


drop table if exists tmp_pisonet_users;
drop table if exists tmp_pisonet_repeater;


+------------+------+-----+-----+----+-----+
| tx_date   	1x  	2x 	3x 	4x	5x  |
+------------+------+-----+-----+----+-----+
| 2014-08-01	   8	  3	  1	 1	  1 |
| 2014-08-02	  12	  3	  0	 1	  1 |
| 2014-08-03	  13	  7	  1	 0	  1 |
| 2014-08-04	  13	  6	  2	 2	  1 |
| 2014-08-05	  18	  4	  3	 2	  1 |
| 2014-08-06	  15	  2	  2	 3	  4 |
| 2014-08-07	  18	  2	  3	 0	  5 |
| 2014-08-08	  21	  3	  2	 1	  2 |
| 2014-08-09	  21	  2	  1	 2	  1 |
| 2014-08-10	  20	  4	  3	 0	  3 |
| 2014-08-11	  12	  6	  4	 3	  1 |
| 2014-08-12	  12	  5	  1	 2	  2 |
| 2014-08-13	  16	  5	  2	 0	  2 |
| 2014-08-14	  14	  7	  0	 1	  2 |
| 2014-08-15	  14	  5	  1	 0	  0 |
| 2014-08-16	  16	  3	  2	 0	  3 |
| 2014-08-17	  18	  4	  3	 2	  0 |
| 2014-08-18	  10	  1	  1	 3	  3 |
| 2014-08-19	  13	  4	  0	 1	  3 |
| 2014-08-20	  17	  6	  3	 1	  1 |
| 2014-08-21	  18	  4	  0	 2	  0 |
| 2014-08-22	  14	  4	  1	 2	  2 |
| 2014-08-23	  12	  5	  4	 1	  2 |
| 2014-08-24	   8	  3	  2	 3	  3 |
| 2014-08-25	  18	  3	  2	 1	  2 |
| 2014-08-26	  18	  3	  8	 0	  2 |
| 2014-08-27	 463	 62	 20	 8	 11 |
| 2014-08-28	3047	567	187	88	119 |
| 2014-08-29	 509	128	 39	25	 21 |
+------------+------+-----+-----+----+-----+
29 rows in set (0.00 sec)


+------------+------+-----+-----+----+----+----+----+----+----+-----+-----+-----+-----+-----+-----+
| tx_date   	1x  	2x 	3x 	4x	5x	6x	7x	8x	9x	10x	11x	12x	13x	14x	15x |
+------------+------+-----+-----+----+----+----+----+----+----+-----+-----+-----+-----+-----+-----+
| 2014-08-25	  18	  3	  2	 1	 0	 0	 2	 0	 0	  0	  0	  0	  0	  0	  0 |
| 2014-08-26	  18	  3	  8	 0	 0	 0	 1	 0	 1	  0	  0	  0	  0	  0	  0 |
| 2014-08-27	 463	 62	 20	 8	 5	 1	 2	 0	 0	  3	  0	  0	  0	  0	  0 |
| 2014-08-28	3047	567	187	88	40	23	15	13	 8	  6	  2	  2	  1	  2	  7 |
| 2014-08-29	 993	272	 96	44	39	14	12	12	 3	  5	  0	  1	  5	  1	  7 |
| 2014-08-30	1990	400	133	72	41	24	13	 6	 5	  2	  6	  3	  3	  2	 10 |
| 2014-08-31	 848	248	 97	73	23	16	10	 7	 7	  4	  7	  2	  0	  0	  9 |
| 2014-09-01	1935	445	130	95	39	29	20	 9	 6	  7	  3	  2	  2	  4	  4 |
| 2014-09-02	 951	263	117	62	36	20	10	 9	 9	  1	  5	  3	  5	  1	  9 |
| 2014-09-03	 690	222	 94	56	34	23	 9	 5	 7	  9	  5	  1	  2	  2	  6 |
| 2014-09-04	 630	192	 81	50	29	19	15	12	 6	  6	  4	  3	  2	  3	  6 |
| 2014-09-05	  62	 15	  5	 1	 2	 1	 0	 1	 0	  0	  0	  0	  0	  0	  0 |
+------------+------+-----+-----+----+----+----+----+----+----+-----+-----+-----+-----+-----+-----+
12 rows in set (0.01 sec)


+------------+----------+------+
| tx_date   	no_times	uniq |
+------------+----------+------+
| 2014-09-04	       1	 630 |
| 2014-09-04	       2	 192 |
| 2014-09-04	       3	  81 |
| 2014-09-04	       4	  50 |
| 2014-09-04	       5	  29 |
| 2014-09-04	       6	  19 |
| 2014-09-04	       7	  15 |
| 2014-09-04	       8	  12 |
| 2014-09-04	       9	   6 |
| 2014-09-04	      10	   6 |
| 2014-09-04	      11	   4 |
| 2014-09-04	      12	   3 |
| 2014-09-04	      13	   2 |
| 2014-09-04	      14	   3 |
| 2014-09-04	      18	   1 |
| 2014-09-04	      19	   2 |
| 2014-09-04	      20	   1 |
| 2014-09-04	      21	   1 |
| 2014-09-04	      22	   1 |
+------------+----------+------+





create table tmp_nds_log (
 tx_date date not null,
 phone varchar(12) not null,
 service varchar(30),
 transmit bigint default 0,
 received bigint default 0,
 total_usage bigint default 0,
 primary key (tx_date, phone)
); 

create table tmp_nds_log (
 tx_date date not null,
 phone varchar(12) not null,
 total_usage bigint default 0,
 primary key (tx_date, phone)
); 

create temporary table tmp_pisonet_buys (
 tx_date date not null,
 phone varchar(12) not null,
 hits  bigint default 0,
 primary key (tx_date, phone)
); 

insert into tmp_nds_log select tx_date, phone, service, sum(transmit), sum(received), sum(transmit+received) tot_usage from powerapp_nds_log where service='PisonetService' group by 1,2,3;
insert into tmp_pisonet_buys select left(datein,10) tx_date, phone, count(1) hits from powerapp_log where datein >= '2014-11-26' and datein < '2014-12-01' and plan ='PISONET' group by 1,2;


select b.tx_date, sum(IF(b.total_usage=0, 1, 0)) Zero_Usage, 
                  sum(IF(b.total_usage > 0, IF(b.total_usage<1000000, 1, 0), 0)) Zero_1mb_Usage, 
                  sum(IF(b.total_usage >= 1000000, IF(b.total_usage<=20000000, 1, 0), 0)) 1mb_2mb_Usage, 
                  sum(IF(b.total_usage > 20000000, 1, 0)) Above_2mb_Usage, 
                  count(b.phone) Hits,
                  sum(b.total_usage) total_usage,
                  sum(if(b.total_usage>=1000000,1,0)) total_usage,
                  sum(if(b.total_usage>=1000000,b.total_usage,0)) total_usage_1mb,
                  sum(if(b.total_usage>=1000000,b.total_usage,0))/sum(if(b.total_usage>=1000000,1,0)) avg_usage_1mb 
from tmp_nds_log b, tmp_pisonet_buys a 
where a.tx_date = b.tx_date
and   a.phone = b.phone 
group by 1;
+------------+------------+----------------+---------------+-----------------+------+-------------+-------------+-----------------+---------------+
| tx_date   	Zero_Usage	Zero_1mb_Usage	1mb_2mb_Usage	Above_2mb_Usage	Hits	total_usage	total_usage	total_usage_1mb	avg_usage_1mb |
+------------+------------+----------------+---------------+-----------------+------+-------------+-------------+-----------------+---------------+
2014-11-26	       132	          1390	         2067	            131	3720	16154317565	       2198	    15702390450	 7143944.6997
2014-11-27	       137	          1734	         2928	            154	4953	20068493011	       3082	    19433218743	 6305392.1944
2014-11-28	       139	          1303	         2179	            132	3753	16878073047	       2311	    16430947990	 7109886.6248
2014-11-29	       267	          1436	         2063	            137	3903	16151601314	       2200	    15700904204	 7136774.6382
2014-11-30	       173	          2021	         2998	            174	5366	21607175834	       3172	    20913182290	 6593058.7295
+------------+------------+----------------+---------------+-----------------+------+-------------+-------------+-----------------+---------------+
5 rows in set (0.43 sec)


select b.tx_date, sum(IF(b.total_usage=0, 1, 0)) Zero_Usage, 
                  sum(IF(b.total_usage > 0, IF(b.total_usage<1000000, 1, 0), 0)) Zero_1mb_Usage, 
                  sum(IF(b.total_usage >= 1000000, IF(b.total_usage<=20000000, 1, 0), 0)) 1mb_2mb_Usage, 
                  sum(IF(b.total_usage > 20000000, 1, 0)) Above_2mb_Usage, 
                  count(b.phone) Hits,
                  sum(b.total_usage) total_usage,
                  sum(if(b.total_usage>=1000000,1,0)) total_usage,
                  sum(if(b.total_usage>=1000000,b.total_usage,0)) total_usage_1mb,
                  sum(if(b.total_usage>=1000000,b.total_usage,0))/sum(if(b.total_usage>=1000000,1,0)) avg_usage_1mb 
from tmp_nds_log b
group by 1;

+------------+------------+----------------+---------------+-----------------+---------+-------------+-------------+-----------------+---------------+
| tx_date   	Zero_Usage	Zero_1mb_Usage	1mb_2mb_Usage	Above_2mb_Usage	Hits   	total_usage	total_usage	total_usage_1mb	avg_usage_1mb |
+------------+------------+----------------+---------------+-----------------+---------+-------------+-------------+-----------------+---------------+
2014-11-26	   1025291	          1399	         2075	            131	1028896	16179855819	       2206	    15725784303	 7128642.0231
2014-11-27	   1026624	          1746	         2939	            154	1031463	20096041342	       3093	    19458260458	 6291063.8403
2014-11-28	   1036955	          1320	         2187	            132	1040594	16908351362	       2319	    16457615255	 7096858.6697
2014-11-29	   1041837	          1447	         2079	            137	1045500	16211068758	       2216	    15757842595	 7110939.7992
2014-11-30	   1033691	          2038	         3010	            174	1038913	21656354815	       3184	    20958395616	 6582410.6834
2014-12-02	   1064115	          1448	         2186	            131	1067880	16545396863	       2317	    16075072459	 6937881.9417
2014-12-03	   1069946	          1365	         2219	            140	1073670	17549895815	       2359	    17103738875	 7250419.1925
+------------+------------+----------------+---------------+-----------------+---------+-------------+-------------+-----------------+---------------+
7 rows in set (14.84 sec)

select tx_date, round(sum(transmit+received)/1000000,2) usage_mb from powerapp_nds_log where tx_date>='2014-11-10' and tx_date < '2014-12-11' and service = 'Pisonetservice' group by 1;
