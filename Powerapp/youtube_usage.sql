create table tmp_youtube_usage like tmp_coc_usage;

   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

cd /mnt/paywall_dmp/dmp/nds/out/
sftp dbsftpuser@172.17.250.162
tr4n$p0Rt3R!
cd /incoming/
mget 2015-01-20.csv
load data local infile '/mnt/paywall_dmp/dmp/nds/out/2015-01-12.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-12';


insert into tmp_youtube_usage ( tx_date, start_tm, end_tm, phone, ip_addr, source, service, b_usage ) 
select tx_date, start_tm, end_tm, phone, ip_addr, source, service, b_usage 
from powerapp_udr_log where tx_date >= '2014-07-25' and service ='YoutubeService';

select phone, start_tm, ip_addr, source, service, b_usage from tmp_youtube_usage where tx_date >= '2014-07-25'  order by 1,2;



select txDate, sum(hits_30m) hits_30m, sum(hits_2h) hits_2h, sum(hits_5h) hits_5h, sum(hits_15h) hits_15h, sum(hits_fy5) hits_fy5 from (
select left(datein,10) txDate, count(1) hits_30m, 0 hits_2h, 0 hits_5h, 0 hits_15h, 0 hits_fy5 from powerapp_log where datein >= '2014-10-24' and free='false' and plan='YOUTUBE' and source <> 'facebook_bundled_youtube' and validity=1800 group by 1 union
select left(datein,10) txDate, 0 hits_30m, count(1) hits_2h, 0 hits_5h, 0 hits_15h, 0 hits_fy5 from powerapp_log where datein >= '2014-10-24' and free='false' and plan='YOUTUBE' and source <> 'facebook_bundled_youtube' and validity=7200 group by 1 union
select left(datein,10) txDate, 0 hits_30m, 0 hits_2h, count(1) hits_5h, 0 hits_15h, 0 hits_fy5 from powerapp_log where datein >= '2014-10-24' and free='false' and plan='YOUTUBE' and source <> 'facebook_bundled_youtube' and validity=18000 group by 1 union
select left(datein,10) txDate, 0 hits_30m, 0 hits_2h, 0 hits_5h, count(1) hits_15h, 0 hits_fy5 from powerapp_log where datein >= '2014-10-24' and free='false' and plan='YOUTUBE' and source <> 'facebook_bundled_youtube' and validity=54000 group by 1 union
select left(datein,10) txDate, 0 hits_30m, 0 hits_2h, 0 hits_5h, 0 hits_15h, count(1) hits_fy5 from powerapp_log where datein >= '2014-10-24' and plan='YOUTUBE' and source = 'facebook_bundled_youtube' group by 1 
) t group by txDate;

select txDate, sum(uniq_30m) uniq_30m, sum(uniq_2h) uniq_2h, sum(uniq_5h) uniq_5h, sum(uniq_15h) uniq_15h, sum(uniq_fy5) uniq_fy5 from (
select left(datein,10) txDate, count(distinct phone) uniq_30m, 0 uniq_2h, 0 uniq_5h, 0 uniq_15h, 0 uniq_fy5 from powerapp_log where datein >= '2014-10-24' and free='false' and plan='YOUTUBE' and source <> 'facebook_bundled_youtube' and validity=1800 group by 1 union
select left(datein,10) txDate, 0 uniq_30m, count(distinct phone) uniq_2h, 0 uniq_5h, 0 uniq_15h, 0 uniq_fy5 from powerapp_log where datein >= '2014-10-24' and free='false' and plan='YOUTUBE' and source <> 'facebook_bundled_youtube' and validity=7200 group by 1 union
select left(datein,10) txDate, 0 uniq_30m, 0 uniq_2h, count(distinct phone) uniq_5h, 0 uniq_15h, 0 uniq_fy5 from powerapp_log where datein >= '2014-10-24' and free='false' and plan='YOUTUBE' and source <> 'facebook_bundled_youtube' and validity=18000 group by 1 union
select left(datein,10) txDate, 0 uniq_30m, 0 uniq_2h, 0 uniq_5h, count(distinct phone) uniq_15h, 0 uniq_fy5 from powerapp_log where datein >= '2014-10-24' and free='false' and plan='YOUTUBE' and source <> 'facebook_bundled_youtube' and validity=54000 group by 1 union 
select left(datein,10) txDate, 0 uniq_30m, 0 uniq_2h, 0 uniq_5h, 0 uniq_15h, count(distinct phone) uniq_fy5 from powerapp_log where datein >= '2014-10-24' and plan='YOUTUBE' and source = 'facebook_bundled_youtube' group by 1 
) t group by txDate;



select left(datein,10) Date, count(1) Hits, count(distinct phone) Uniq from powerapp_log a, usage_per_plan b where datein >= '2014-11-15' and plan = 'YOUTUB                                         E' and source <> 'facebook_bundled_youtube' group by 1;


create temporary table tmp_nds_log as select * from  powerapp_nds_log limit 0;
alter table tmp_nds_log add primary key (tx_date, phone);
truncate table tmp_nds_log;
load data local infile '/tmp/YOUTUBE_2014-11-15.csv' into table tmp_nds_log fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-15';
load data local infile '/tmp/YOUTUBE_2014-11-16.csv' into table tmp_nds_log fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-16';
load data local infile '/tmp/YOUTUBE_2014-11-17.csv' into table tmp_nds_log fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-17';
load data local infile '/tmp/YOUTUBE_2014-11-18.csv' into table tmp_nds_log fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-18';
load data local infile '/tmp/YOUTUBE_2014-11-19.csv' into table tmp_nds_log fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-19';

create temporary table tmp_youtube_usage (tx_date date not null, phone varchar(12) not null, hits int default 0, primary key (tx_date, phone));
insert into tmp_youtube_usage select left(datein,10), phone, count(1) from powerapp_log where datein >= '2014-11-15' and plan = 'YOUTUBE' group by 1,2;

select tx_date, phone, count(1) from (
select a.tx_date, a.phone, a.hits, b.transmit, b.received, b.transmit+b.received total_usage from tmp_youtube_usage a, tmp_nds_log b where a.phone=b.phone and a.tx_date=b.tx_date
) t group by 1,2 having count(1) > 1;

create temporary table tmp_nds_log (
 phone varchar(12) not null,
 start_tm datetime not null,
 end_tm datetime not null,
 transmit bigint default 0,
 received bigint default 0,
 total_usage bigint default 0,
 primary key (phone, start_tm)
); 

load data local infile '/tmp/YoutubeService.2014.11.15-2014.11.20_.csv' into table tmp_nds_log fields terminated by ',' lines terminated by '\n' (phone, @col1, start_tm, end_tm, transmit,received, total_usage);

select a.phone, a.hits, b.transmit+b.received total_usage, (b.transmit+b.received)/a.hits avg_usage 
from tmp_youtube_usage a, tmp_nds_log b 
where a.phone=b.phone and a.tx_date=b.tx_date
and   a.tx_date = '2014-11-15';

select a.tx_date, sum(IF(b.transmit+b.received=0, 1, 0)) Zero_Usage, 
                  sum(IF(b.transmit+b.received > 0, IF(b.transmit+b.received<25000000, 1, 0), 0)) Zero_25mb_Usage, 
                  sum(IF(b.transmit+b.received > 25000000, IF(b.transmit+b.received<50000000, 1, 0), 0)) 25mb_50mb_Usage, 
                  sum(IF(b.transmit+b.received > 50000000, IF(b.transmit+b.received<100000000, 1, 0), 0)) 50mb_100mb_Usage, 
                  sum(IF(b.transmit+b.received > 100000000, 1, 0)) Above_100mb_Usage, 
                  count(a.phone) Hits,
                  sum(b.total_usage) total_usage,
                  sum(if(b.total_usage>=1000000,1,0)) total_usage,
                  sum(if(b.total_usage>=1000000,b.total_usage,0)) total_usage_1mb,
                  sum(if(b.total_usage>=1000000,b.total_usage,0))/sum(if(b.total_usage>=1000000,1,0)) avg_usage_1mb 
from tmp_youtube_usage a, tmp_nds_log b 
where a.phone=b.phone and a.tx_date=b.tx_date
group by 1;






YOUTUBE NDS
YOUTUBE NDS

load data local infile '/tmp/youtube_1222.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-22';
load data local infile '/tmp/youtube_1223.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-23';
load data local infile '/tmp/youtube_1224.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-24';
load data local infile '/tmp/youtube_1225.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-25';
delete from tmp_youtube_nds where (transmit+received) = 0;
load data local infile '/tmp/youtube_1226.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-26';
delete from tmp_youtube_nds where (transmit+received) = 0;
load data local infile '/tmp/youtube_1227.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-27';
delete from tmp_youtube_nds where (transmit+received) = 0;
load data local infile '/tmp/youtube_1228.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-28';
delete from tmp_youtube_nds where (transmit+received) = 0;
load data local infile '/tmp/youtube_1229.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-29';
delete from tmp_youtube_nds where (transmit+received) = 0;
load data local infile '/tmp/youtube_1230.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-30';
delete from tmp_youtube_nds where (transmit+received) = 0;
load data local infile '/tmp/youtube_1231.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-31';
delete from tmp_youtube_nds where (transmit+received) = 0;
load data local infile '/tmp/youtube_1219.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-19';
load data local infile '/tmp/youtube_1220.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-20';
load data local infile '/tmp/youtube_1221.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-21';
load data local infile '/tmp/youtube_0101.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-01';
load data local infile '/tmp/youtube_0102.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-02';
load data local infile '/tmp/youtube_0103.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-03';
load data local infile '/tmp/youtube_0104.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-04';
load data local infile '/tmp/youtube_0105.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-05';
load data local infile '/tmp/youtube_0106.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-06';
load data local infile '/tmp/youtube_0107.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-07';
load data local infile '/tmp/youtube_0108.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-08';
load data local infile '/tmp/youtube_0109.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-09';
load data local infile '/tmp/youtube_0110.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-10';
load data local infile '/tmp/youtube_0111.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-11';

load data local infile '/tmp/youtube_0112.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-12';
load data local infile '/tmp/youtube_0113.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-13';
load data local infile '/tmp/youtube_0114.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-14';
load data local infile '/tmp/youtube_0115.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-15';
load data local infile '/tmp/youtube_0116.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-16';
load data local infile '/tmp/youtube_0117.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-17';
load data local infile '/tmp/youtube_0118.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-18';
load data local infile '/tmp/youtube_0119.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-19';
load data local infile '/tmp/youtube_0120.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-20';

zcat 2015-01-05.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0105.csv
zcat 2015-01-06.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0106.csv
zcat 2015-01-07.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0107.csv
zcat 2015-01-08.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0108.csv
zcat 2015-01-09.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0109.csv
zcat 2015-01-10.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0110.csv
zcat 2015-01-11.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0111.csv
zcat 2015-01-12.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0112.csv
zcat 2015-01-13.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0113.csv
zcat 2015-01-14.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0114.csv
zcat 2015-01-15.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0115.csv
zcat 2015-01-16.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0116.csv
zcat 2015-01-17.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0117.csv
zcat 2015-01-18.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0118.csv
zcat 2015-01-19.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0119.csv
zcat 2015-01-20.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0120.csv

zcat 2015-02-02.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0202.csv
zcat 2015-02-03.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0203.csv
zcat 2015-02-04.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0204.csv
zcat 2015-02-05.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0205.csv
zcat 2015-02-06.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0206.csv
zcat 2015-02-07.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0207.csv
zcat 2015-02-08.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0208.csv
zcat 2015-02-09.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0209.csv
zcat 2015-02-10.csv.gz | grep YoutubeService | grep -v '0,0' > /tmp/youtube_0210.csv

load data local infile '/tmp/youtube_0202.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-02-02';
load data local infile '/tmp/youtube_0203.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-02-03';
load data local infile '/tmp/youtube_0204.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-02-04';
load data local infile '/tmp/youtube_0205.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-02-05';
load data local infile '/tmp/youtube_0206.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-02-06';
load data local infile '/tmp/youtube_0207.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-02-07';
load data local infile '/tmp/youtube_0208.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-02-08';
load data local infile '/tmp/youtube_0209.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-02-09';
load data local infile '/tmp/youtube_0210.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-02-10';

select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan 
from powerapp_log a 
where datein >= '2015-01-20' and datein < '2015-01-21' 
and exists (

set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;

drop temporary table tmp_youtube_buys;
create temporary table tmp_youtube_buys select left(datein,10) tx_date, phone, group_concat(distinct(plan) separator ',') plan, count(1) hits from powerapp_log where datein >= '2015-02-02' and datein < '2015-02-11' and plan = 'YOUTUBE' group by 1,2;
alter table tmp_youtube_buys add primary key (tx_date, phone);
select a.tx_date, a.phone, (a.transmit+a.received) tx_usage, ifnull(b.hits,0) buys from tmp_youtube_nds a left outer join tmp_youtube_buys b on (a.tx_date = b.tx_date and a.phone=b.phone) ;
e

create temporary table tmp_youtube_buys select left(datein,10) tx_date, phone, group_concat(distinct(plan) separator ',') plan, count(1) hits from powerapp_log a where datein >= '2015-02-02' and datein < '2015-02-11' and exists (select 1 from tmp_youtube_nds b where a.phone=b.phone ) group by 1,2;
alter table tmp_youtube_buys add primary key (tx_date, phone);
select a.tx_date, a.phone, (a.transmit+a.received) tx_usage, ifnull(b.plan,'None') buys from tmp_youtube_nds a left outer join tmp_youtube_buys b on (a.tx_date = b.tx_date and a.phone=b.phone) order by 1,2;



select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2014-12-19' and datein < '2014-12-20' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-12-19') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2014-12-20' and datein < '2014-12-21' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-12-20') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2014-12-21' and datein < '2014-12-22' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-12-21') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2014-12-22' and datein < '2014-12-23' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-12-22') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2014-12-23' and datein < '2014-12-24' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-12-23') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2014-12-24' and datein < '2014-12-25' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-12-24') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2014-12-25' and datein < '2014-12-26' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-12-25') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2014-12-26' and datein < '2014-12-27' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-12-26') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2014-12-27' and datein < '2014-12-28' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-12-27') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2014-12-28' and datein < '2014-12-29' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-12-28') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2014-12-29' and datein < '2014-12-30' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-12-29') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2014-12-30' and datein < '2014-12-31' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-12-30') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2014-12-31' and datein < '2015-01-01' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-12-31') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-01' and datein < '2015-01-02' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-01') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-02' and datein < '2015-01-03' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-02') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-03' and datein < '2015-01-04' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-03') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-04' and datein < '2015-01-05' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-04') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-05' and datein < '2015-01-05' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-05') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-06' and datein < '2015-01-05' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-06') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-07' and datein < '2015-01-05' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-07') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-08' and datein < '2015-01-05' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-08') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-09' and datein < '2015-01-05' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-09') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-10' and datein < '2015-01-05' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-10') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-11' and datein < '2015-01-05' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-11') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-12' and datein < '2015-01-05' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-12') group by 1,2;


select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-12' and datein < '2015-01-13' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-12') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-13' and datein < '2015-01-14' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-13') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-14' and datein < '2015-01-15' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-14') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-15' and datein < '2015-01-16' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-15') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-16' and datein < '2015-01-17' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-16') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-17' and datein < '2015-01-18' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-17') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-18' and datein < '2015-01-19' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-18') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-19' and datein < '2015-01-20' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-19') group by 1,2;
select left(datein,10) tx_date, phone, group_concat(plan separator ',') plan from powerapp_log a where datein >= '2015-01-20' and datein < '2015-01-21' and exists (select phone from tmp_youtube_nds b where a.phone=b.phone and b.tx_date = '2014-01-20') group by 1,2;

+------------+--------------+--------------------------+
| tx_date    | phone        | plan                     |
+------------+--------------+--------------------------+
| 2014-12-19 | 639206176420 | FACEBOOK,MYVOLUME,VIDEO5 |
| 2014-12-19 | 639474859764 | UNLI                     |
| 2014-12-20 | 639206176420 | FACEBOOK,MYVOLUME |
| 2014-12-21 | 639186231806 | FACEBOOK,MYVOLUME,VIDEO5 |
| 2014-12-21 | 639206176420 | FACEBOOK,MYVOLUME,VIDEO5 |
| 2014-12-23 | 639184611217 | FACEBOOK,MYVOLUME,VIDEO5 |
| 2014-12-23 | 639186253303 | VIDEO5                   |
| 2014-12-23 | 639195148906 | MYVOLUME,FACEBOOK,VIDEO5 |
| 2014-12-23 | 639206176420 | FACEBOOK,MYVOLUME,VIDEO5 |
| 2014-12-23 | 639474859764 | UNLI                     |
| 2014-12-24 | 639184611217 | FACEBOOK,MYVOLUME |
| 2014-12-24 | 639195148906 | FACEBOOK,MYVOLUME |
| 2014-12-25 | 639184611217 | VIDEO5,FACEBOOK,MYVOLUME |
| 2014-12-25 | 639298488022 | FACEBOOK,MYVOLUME,VIDEO5 |
| 2014-12-26 | 639186231806 | FACEBOOK,MYVOLUME,SPEEDBOOST,VIDEO5,SPEEDBOOST,SPEEDBOOST,SPEEDBOOST |
| 2014-12-26 | 639474859764 | UNLI                                                                 |
| 2014-12-27 | 639195148906 | VIDEO5 |
| 2014-12-28 | 639195148906 | VIDEO5,MYVOLUME,FACEBOOK |
| 2014-12-28 | 639198488303 | SPEEDBOOST               |
| 2014-12-28 | 639206176420 | VIDEO5,MYVOLUME,FACEBOOK |
| 2014-12-28 | 639298488022 | MYVOLUME,FACEBOOK,VIDEO5 |
| 2014-12-29 | 639206176420 | FACEBOOK,MYVOLUME        |
| 2014-12-29 | 639284950306 | VIDEO5,FACEBOOK,MYVOLUME |
| 2014-12-30 | 639206176420 | VIDEO5            |
| 2014-12-30 | 639284950306 | FACEBOOK,MYVOLUME |
| 2014-12-31 | 639206176420 | VIDEO5,FACEBOOK,MYVOLUME |
| 2014-12-31 | 639284950306 | FACEBOOK,MYVOLUME        |
+------------+--------------+--------------------------+



PISONET NDS

set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;


zcat 2014-12-01.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141201.csv
zcat 2014-12-02.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141202.csv
zcat 2014-12-03.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141203.csv
zcat 2014-12-04.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141204.csv
zcat 2014-12-05.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141205.csv
zcat 2014-12-06.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141206.csv
zcat 2014-12-07.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141207.csv
zcat 2014-12-08.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141208.csv
zcat 2014-12-09.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141209.csv
zcat 2014-12-10.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141210.csv
zcat 2014-12-11.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141211.csv
zcat 2014-12-12.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141212.csv
zcat 2014-12-13.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141213.csv
zcat 2014-12-14.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141214.csv
zcat 2014-12-15.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141215.csv
zcat 2014-12-16.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141216.csv
zcat 2014-12-17.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141217.csv
zcat 2014-12-18.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141218.csv
zcat 2014-12-19.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141219.csv
zcat 2014-12-20.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141220.csv
zcat 2014-12-21.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141221.csv
zcat 2014-12-22.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141222.csv
zcat 2014-12-23.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141223.csv
zcat 2014-12-24.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141224.csv
zcat 2014-12-25.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141225.csv
zcat 2014-12-26.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141226.csv
zcat 2014-12-27.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141227.csv
zcat 2014-12-28.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141228.csv
zcat 2014-12-29.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141229.csv
zcat 2014-12-30.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141230.csv
zcat 2014-12-31.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20141231.csv
zcat 2015-01-01.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150101.csv
zcat 2015-01-02.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150102.csv
zcat 2015-01-03.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150103.csv
zcat 2015-01-04.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150104.csv
zcat 2015-01-05.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150105.csv
zcat 2015-01-06.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150106.csv


truncate table tmp_youtube_nds;
load data local infile '/tmp/pisonet_20141201.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-01';
load data local infile '/tmp/pisonet_20141202.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-02';
load data local infile '/tmp/pisonet_20141203.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-03';
load data local infile '/tmp/pisonet_20141204.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-04';
load data local infile '/tmp/pisonet_20141205.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-05';
load data local infile '/tmp/pisonet_20141206.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-06';
load data local infile '/tmp/pisonet_20141207.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-07';
load data local infile '/tmp/pisonet_20141208.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-08';
load data local infile '/tmp/pisonet_20141209.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-09';
load data local infile '/tmp/pisonet_20141210.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-10';
load data local infile '/tmp/pisonet_20141211.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-11';
load data local infile '/tmp/pisonet_20141212.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-12';
load data local infile '/tmp/pisonet_20141213.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-13';
load data local infile '/tmp/pisonet_20141214.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-14';
load data local infile '/tmp/pisonet_20141215.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-15';
load data local infile '/tmp/pisonet_20141216.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-16';
load data local infile '/tmp/pisonet_20141217.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-17';
load data local infile '/tmp/pisonet_20141218.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-18';
load data local infile '/tmp/pisonet_20141219.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-19';
load data local infile '/tmp/pisonet_20141220.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-20';
load data local infile '/tmp/pisonet_20141221.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-21';
load data local infile '/tmp/pisonet_20141222.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-22';
load data local infile '/tmp/pisonet_20141223.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-23';
load data local infile '/tmp/pisonet_20141224.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-24';
load data local infile '/tmp/pisonet_20141225.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-25';
load data local infile '/tmp/pisonet_20141226.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-26';
load data local infile '/tmp/pisonet_20141227.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-27';
load data local infile '/tmp/pisonet_20141228.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-28';
load data local infile '/tmp/pisonet_20141229.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-29';
load data local infile '/tmp/pisonet_20141230.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-30';
load data local infile '/tmp/pisonet_20141231.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-31';
load data local infile '/tmp/pisonet_20150101.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-01';
load data local infile '/tmp/pisonet_20150102.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-02';
load data local infile '/tmp/pisonet_20150103.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-03';
load data local infile '/tmp/pisonet_20150104.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-04';
load data local infile '/tmp/pisonet_20150105.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-05';
load data local infile '/tmp/pisonet_20150106.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-06';

select tx_date, phone, sum(transmit+received) _usage from tmp_youtube_nds group by 1,2 order by 1,2;

+------------+--------------+------------+
| tx_date    | phone        | _usage     |
+------------+--------------+------------+
| 2015-01-12 | 639085581736 |   77148604 |
| 2015-01-12 | 639195148906 |   91249472 |
| 2015-01-12 | 639478001241 | 1410363696 |
| 2015-01-13 | 639077372626 |          0 |
| 2015-01-13 | 639084016420 |          0 |
| 2015-01-13 | 639206176420 |   35919555 |
| 2015-01-13 | 639207542999 |          0 |
| 2015-01-13 | 639395367658 |          0 |
| 2015-01-13 | 639464500808 |          0 |
| 2015-01-13 | 639478001241 | 1694258767 |
| 2015-01-13 | 639479827271 |          0 |
| 2015-01-13 | 639997789158 |          0 |
| 2015-01-14 | 639085581736 |  181575483 |
| 2015-01-14 | 639195148906 |   63279083 |
| 2015-01-14 | 639206176420 |   25249686 |
| 2015-01-14 | 639478001241 | 1456595029 |
| 2015-01-15 | 639085581736 |  125123265 |
| 2015-01-15 | 639195148906 |   72346523 |
| 2015-01-15 | 639282295244 |  161699818 |
| 2015-01-15 | 639478001241 | 1482656894 |
| 2015-01-16 | 639085581736 |   69311594 |
| 2015-01-16 | 639192708388 |     592007 |
| 2015-01-16 | 639195148906 |   27274935 |
| 2015-01-16 | 639206176420 |   23498201 |
| 2015-01-16 | 639478001241 |  683246418 |
| 2015-01-17 | 639085581736 |  486767505 |
| 2015-01-17 | 639186562167 |      16032 |
| 2015-01-17 | 639206176420 |     630870 |
| 2015-01-17 | 639213302341 |  488948650 |
| 2015-01-17 | 639478001241 | 1099060241 |
| 2015-01-18 | 639086046585 |   49812215 |
| 2015-01-18 | 639186562167 |       8228 |
| 2015-01-18 | 639213302341 |  673591919 |
| 2015-01-18 | 639478001241 |  429008180 |
| 2015-01-19 | 639086046585 |  138808148 |
| 2015-01-19 | 639478001241 |  945097673 |
+------------+--------------+------------+
36 rows in set (0.03 sec)


select a.tx_date, b.brand, sum(a.transmit+a.received) tot_usage,  avg(a.transmit+a.received) avg_usage from tmp_youtube_nds a left outer join powerapp_flu.new_subscribers b on a.phone = b.phone group by 1,2 order by 2,1;

+------------+--------+-------------+--------------+
| tx_date    | brand  | tot_usage   | avg_usage    |
+------------+--------+-------------+--------------+
| 2014-11-01 | BUDDY  |   798092017 | 7458803.8972 |
| 2014-11-02 | BUDDY  |  1043448811 | 7672417.7279 |
| 2014-11-03 | BUDDY  |   955031653 | 7074308.5407 |
| 2014-11-04 | BUDDY  |   917197013 | 6413965.1259 |
| 2014-11-05 | BUDDY  |   948995736 | 6778540.9714 |
| 2014-11-06 | BUDDY  |   999547739 | 6708374.0872 |
| 2014-11-07 | BUDDY  |   666259567 | 5330076.5360 |
| 2014-11-08 | BUDDY  |   728117428 | 6331455.8957 |
| 2014-11-09 | BUDDY  |   870748278 | 7988516.3119 |
| 2014-11-10 | BUDDY  |   647254182 | 5779055.1964 |
| 2014-11-11 | BUDDY  |   825881706 | 2238161.8049 |
| 2014-11-12 | BUDDY  |   794406221 | 6511526.4016 |
| 2014-11-13 | BUDDY  |   574769614 | 5422354.8491 |
| 2014-11-14 | BUDDY  |   732018287 | 7320182.8700 |
| 2014-11-15 | BUDDY  |   537523972 | 5375239.7200 |
| 2014-11-16 | BUDDY  |   719979951 | 6666481.0278 |
| 2014-11-17 | BUDDY  |   492450351 | 4396878.1339 |
| 2014-11-18 | BUDDY  |   519599242 | 4996146.5577 |
| 2014-11-19 | BUDDY  |   498480551 | 4658696.7383 |
| 2014-11-20 | BUDDY  |   568037120 | 4855018.1197 |
| 2014-11-21 | BUDDY  |   819954740 | 6776485.4545 |
| 2014-11-22 | BUDDY  |   898746367 | 7489553.0583 |
| 2014-11-23 | BUDDY  |   932208089 | 6956776.7836 |
| 2014-11-24 | BUDDY  |   816248902 | 6802074.1833 |
| 2014-11-25 | BUDDY  |   614972674 | 5082418.7934 |
| 2014-11-26 | BUDDY  |   587767070 | 5295198.8288 |
| 2014-11-27 | BUDDY  |   890490288 | 6746138.5455 |
| 2014-11-28 | BUDDY  |   937659957 | 8083275.4914 |
| 2014-11-29 | BUDDY  |  1067344932 | 8085946.4545 |
| 2014-11-30 | BUDDY  |   891833131 | 7494396.0588 |
| 2014-12-01 | BUDDY  |   891709699 | 7133677.5920 |
| 2014-12-02 | BUDDY  |   841245908 | 7252119.8966 |
| 2014-12-03 | BUDDY  |   843549219 | 7029576.8250 |
| 2014-12-04 | BUDDY  |   775810044 | 6061015.9688 |
| 2014-12-05 | BUDDY  |   589886896 | 4915724.1333 |
| 2014-12-06 | BUDDY  |   815184052 | 7027448.7241 |
| 2014-12-07 | BUDDY  |   848932106 | 8322863.7843 |
| 2014-12-08 | BUDDY  |   835335325 | 7525543.4685 |
| 2014-12-09 | BUDDY  |   765110622 | 6271398.5410 |
| 2014-12-10 | BUDDY  |   747048527 | 5616906.2180 |
| 2014-12-11 | BUDDY  |  1019743691 | 7283883.5071 |
| 2014-12-12 | BUDDY  |  1010532742 | 9270942.5872 |
| 2014-12-13 | BUDDY  |   795935363 | 8039751.1414 |
| 2014-12-14 | BUDDY  |   677760126 | 6161455.6909 |
| 2014-12-15 | BUDDY  |   688951012 | 6320651.4862 |
| 2014-12-16 | BUDDY  |   526231506 | 5539279.0105 |
| 2014-12-17 | BUDDY  |   498273846 | 6228423.0750 |
| 2014-12-18 | BUDDY  |   975536260 | 8267256.4407 |
| 2014-12-19 | BUDDY  |   724635895 | 6587599.0455 |
| 2014-12-20 | BUDDY  |   732582769 | 8231267.0674 |
| 2014-12-21 | BUDDY  |   594240021 | 6321702.3511 |
| 2014-12-22 | BUDDY  |   761829732 | 8191717.5484 |
| 2014-12-23 | BUDDY  |   615159981 | 6475368.2211 |
| 2014-12-24 | BUDDY  |   512350989 | 5692788.7667 |
| 2014-12-25 | BUDDY  |   524422866 | 6097940.3023 |
| 2014-12-26 | BUDDY  |   500201594 | 5816297.6047 |
| 2014-12-27 | BUDDY  |   504849994 | 6390506.2532 |
| 2014-12-28 | BUDDY  |   496317816 | 5979732.7229 |
| 2014-12-29 | BUDDY  |   729410844 | 8895254.1951 |
| 2014-12-30 | BUDDY  |   829914529 | 9650168.9419 |
| 2014-12-31 | BUDDY  |   674328066 | 8991040.8800 |
| 2015-01-01 | BUDDY  |   613155070 | 7569815.6790 |
| 2015-01-02 | BUDDY  |   614125827 | 7581800.3333 |
| 2015-01-03 | BUDDY  |   641877334 | 8445754.3947 |
| 2015-01-04 | BUDDY  |   578704000 | 7144493.8272 |
| 2015-01-05 | BUDDY  |   685255038 | 7876494.6897 |
| 2015-01-06 | BUDDY  |   870927246 | 8623042.0396 |
| 2014-11-01 | TNT    | 15843002948 | 3915719.9575 |
| 2014-11-02 | TNT    | 21218787697 | 3904100.7722 |
| 2014-11-03 | TNT    | 16706490859 | 4017915.0695 |
| 2014-11-04 | TNT    | 15085795686 | 3941937.7282 |
| 2014-11-05 | TNT    | 15661902980 | 3884400.5407 |
| 2014-11-06 | TNT    | 20419202225 | 4899040.8409 |
| 2014-11-07 | TNT    | 20446465898 | 5223930.9908 |
| 2014-11-08 | TNT    | 18824592181 | 4948630.9624 |
| 2014-11-09 | TNT    | 19728058658 | 4939423.8002 |
| 2014-11-10 | TNT    | 20183153482 | 5228796.2389 |
| 2014-11-11 | TNT    | 18091114484 | 4406019.1145 |
| 2014-11-12 | TNT    | 18833650733 | 4795938.5620 |
| 2014-11-13 | TNT    | 11855996445 | 3841865.3419 |
| 2014-11-14 | TNT    | 10622390868 | 3673025.8880 |
| 2014-11-15 | TNT    |  9758021198 | 3395275.2951 |
| 2014-11-16 | TNT    |  9970678721 | 3400640.7643 |
| 2014-11-17 | TNT    |  9270905201 | 3388488.7431 |
| 2014-11-18 | TNT    |  9056282333 | 3367899.7148 |
| 2014-11-19 | TNT    |  8273000144 | 3175815.7942 |
| 2014-11-20 | TNT    |  8196969536 | 3242472.1266 |
| 2014-11-21 | TNT    | 14635437004 | 4596556.8480 |
| 2014-11-22 | TNT    | 17402440794 | 5025250.0127 |
| 2014-11-23 | TNT    | 16622719030 | 4723705.3225 |
| 2014-11-24 | TNT    | 15359002877 | 4648608.6189 |
| 2014-11-25 | TNT    | 15105911732 | 4554088.5535 |
| 2014-11-26 | TNT    | 15592088749 | 4462532.5555 |
| 2014-11-27 | TNT    | 19205550714 | 4081077.4998 |
| 2014-11-28 | TNT    | 15970691405 | 4533264.6622 |
| 2014-11-29 | TNT    | 15143721726 | 4290006.1547 |
| 2014-11-30 | TNT    | 20764521004 | 4069878.6758 |
| 2014-12-01 | TNT    | 17394309774 | 3907077.6671 |
| 2014-12-02 | TNT    | 15704150955 | 4303686.2031 |
| 2014-12-03 | TNT    | 16706344256 | 4636787.1929 |
| 2014-12-04 | TNT    | 17001385088 | 4650269.4442 |
| 2014-12-05 | TNT    | 16671976433 | 4548970.3774 |
| 2014-12-06 | TNT    | 18795475213 | 4787436.3762 |
| 2014-12-07 | TNT    | 19317678703 | 4886840.0463 |
| 2014-12-08 | TNT    | 18361466509 | 4576636.7171 |
| 2014-12-09 | TNT    | 17574541248 | 4421268.2385 |
| 2014-12-10 | TNT    | 17245752284 | 4643444.3414 |
| 2014-12-11 | TNT    | 17325435188 | 4751902.1360 |
| 2014-12-12 | TNT    | 14120511897 | 4343436.4494 |
| 2014-12-13 | TNT    |  9487885502 | 3686047.2036 |
| 2014-12-14 | TNT    |  9542826878 | 3482783.5321 |
| 2014-12-15 | TNT    |  9606964278 | 3672386.9564 |
| 2014-12-16 | TNT    |  8387643625 | 3502147.6514 |
| 2014-12-17 | TNT    |  8804663259 | 3446052.1562 |
| 2014-12-18 | TNT    | 23354298389 | 4114569.8360 |
| 2014-12-19 | TNT    | 17685661935 | 5045837.9272 |
| 2014-12-20 | TNT    | 15468645716 | 4548263.9565 |
| 2014-12-21 | TNT    | 15575128479 | 4744175.5952 |
| 2014-12-22 | TNT    | 16905361453 | 4744698.6958 |
| 2014-12-23 | TNT    | 16155602462 | 4556007.4625 |
| 2014-12-24 | TNT    | 14776984325 | 4311930.0627 |
| 2014-12-25 | TNT    | 14709798490 | 4409412.0174 |
| 2014-12-26 | TNT    | 15286776926 | 4450298.9595 |
| 2014-12-27 | TNT    | 18066796530 | 4880279.9919 |
| 2014-12-28 | TNT    | 17354154913 | 4797941.6403 |
| 2014-12-29 | TNT    | 16902263679 | 4506068.6961 |
| 2014-12-30 | TNT    | 15731107370 | 4652797.2109 |
| 2014-12-31 | TNT    | 14547563088 | 4701862.6658 |
| 2015-01-01 | TNT    | 14466197822 | 4680102.8217 |
| 2015-01-02 | TNT    | 16926740399 | 4949339.2980 |
| 2015-01-03 | TNT    | 18794425762 | 5271928.6850 |
| 2015-01-04 | TNT    | 17729782113 | 5084537.4571 |
| 2015-01-05 | TNT    | 17121973073 | 4798759.2693 |
| 2015-01-06 | TNT    | 17588802451 | 4895297.0918 |
+------------+--------+-------------+--------------+


select left(datein,10) tx_date, brand, count(1), count(distinct phone) uniq from powerapp_log where datein >= '2014-12-22' and plan = 'PISONET' group by 1,2 order by 2,1;


+------------+-------+----------+------+
| tx_date    | brand | count(1) | uniq |
+------------+-------+----------+------+
| 2014-12-22 | BUDDY |      184 |   76 |
| 2014-12-23 | BUDDY |      225 |   99 |
| 2014-12-24 | BUDDY |      234 |   93 |
| 2014-12-25 | BUDDY |      206 |   88 |
| 2014-12-26 | BUDDY |      202 |   88 |
| 2014-12-27 | BUDDY |      123 |   54 |
| 2014-12-28 | BUDDY |      238 |   83 |
| 2014-12-29 | BUDDY |      246 |   81 |
| 2014-12-30 | BUDDY |      123 |   52 |
| 2014-12-31 | BUDDY |      242 |   78 |
| 2015-01-01 | BUDDY |      238 |   82 |
| 2015-01-02 | BUDDY |      120 |   48 |
| 2015-01-03 | BUDDY |      217 |   78 |
| 2015-01-04 | BUDDY |      106 |   50 |
| 2015-01-05 | BUDDY |      250 |   88 |
| 2015-01-06 | BUDDY |      346 |  103 |
| 2015-01-07 | BUDDY |        7 |    5 |
| 2014-12-22 | TNT   |     5272 | 2925 |
| 2014-12-23 | TNT   |     6797 | 3694 |
| 2014-12-24 | TNT   |     6749 | 3634 |
| 2014-12-25 | TNT   |     6506 | 3503 |
| 2014-12-26 | TNT   |     6846 | 3623 |
| 2014-12-27 | TNT   |     3852 | 2251 |
| 2014-12-28 | TNT   |     7157 | 3784 |
| 2014-12-29 | TNT   |     7020 | 3882 |
| 2014-12-30 | TNT   |     3233 | 1925 |
| 2014-12-31 | TNT   |     6169 | 3283 |
| 2015-01-01 | TNT   |     6461 | 3263 |
| 2015-01-02 | TNT   |     3613 | 2095 |
| 2015-01-03 | TNT   |     7448 | 3719 |
| 2015-01-04 | TNT   |     3527 | 1985 |
| 2015-01-05 | TNT   |     7043 | 3710 |
| 2015-01-06 | TNT   |     6989 | 3734 |
| 2015-01-07 | TNT   |      854 |  539 |
+------------+-------+----------+------+
34 rows in set (9 min 8.00 sec)




zcat 2015-01-01.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150101.csv
zcat 2015-01-02.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150102.csv
zcat 2015-01-03.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150103.csv
zcat 2015-01-04.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150104.csv
zcat 2015-01-05.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150105.csv
zcat 2015-01-06.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150106.csv
zcat 2015-01-07.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150107.csv
zcat 2015-01-08.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150108.csv
zcat 2015-01-09.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150109.csv
zcat 2015-01-10.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150110.csv
zcat 2015-01-11.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150111.csv
zcat 2015-01-12.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150112.csv
zcat 2015-01-13.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150113.csv
zcat 2015-01-14.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150114.csv
zcat 2015-01-15.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150115.csv
zcat 2015-01-16.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150116.csv
zcat 2015-01-17.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150117.csv
zcat 2015-01-18.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150118.csv
zcat 2015-01-19.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150119.csv
zcat 2015-01-20.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150120.csv
zcat 2015-01-21.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150121.csv
zcat 2015-01-22.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150122.csv
zcat 2015-01-23.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150123.csv
zcat 2015-01-24.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150124.csv
zcat 2015-01-25.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150125.csv
zcat 2015-01-26.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150126.csv
zcat 2015-01-27.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150127.csv
zcat 2015-01-28.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150128.csv
zcat 2015-01-29.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150129.csv
zcat 2015-01-30.csv.gz | grep PisonetService | grep -v '0,0' > /tmp/pisonet_20150130.csv
load data local infile '/tmp/pisonet_20141101.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-01';
load data local infile '/tmp/pisonet_20141102.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-02';
load data local infile '/tmp/pisonet_20141103.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-03';
load data local infile '/tmp/pisonet_20141104.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-04';
load data local infile '/tmp/pisonet_20141105.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-05';
load data local infile '/tmp/pisonet_20141106.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-06';
load data local infile '/tmp/pisonet_20141107.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-07';
load data local infile '/tmp/pisonet_20141108.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-08';
load data local infile '/tmp/pisonet_20141109.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-09';
load data local infile '/tmp/pisonet_20141110.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-10';
load data local infile '/tmp/pisonet_20141111.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-11';
load data local infile '/tmp/pisonet_20141112.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-12';
load data local infile '/tmp/pisonet_20141113.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-13';
load data local infile '/tmp/pisonet_20141114.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-14';
load data local infile '/tmp/pisonet_20141115.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-15';
load data local infile '/tmp/pisonet_20141116.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-16';
load data local infile '/tmp/pisonet_20141117.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-17';
load data local infile '/tmp/pisonet_20141118.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-18';
load data local infile '/tmp/pisonet_20141119.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-19';
load data local infile '/tmp/pisonet_20141120.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-20';
load data local infile '/tmp/pisonet_20141121.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-21';
load data local infile '/tmp/pisonet_20141122.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-22';
load data local infile '/tmp/pisonet_20141123.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-23';
load data local infile '/tmp/pisonet_20141124.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-24';
load data local infile '/tmp/pisonet_20141125.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-25';
load data local infile '/tmp/pisonet_20141126.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-26';
load data local infile '/tmp/pisonet_20141127.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-27';
load data local infile '/tmp/pisonet_20141128.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-28';
load data local infile '/tmp/pisonet_20141129.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-29';
load data local infile '/tmp/pisonet_20141130.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-11-30';




+------------+--------+-------------+--------------+
| tx_date    | brand  | tot_usage   | avg_usage    |
+------------+--------+-------------+--------------+
| 2014-11-01 | BUDDY  |   798092017 | 7458803.8972 |
| 2014-11-02 | BUDDY  |  1043448811 | 7672417.7279 |
| 2014-11-03 | BUDDY  |   955031653 | 7074308.5407 |
| 2014-11-04 | BUDDY  |   917197013 | 6413965.1259 |
| 2014-11-05 | BUDDY  |   948995736 | 6778540.9714 |
| 2014-11-06 | BUDDY  |   999547739 | 6708374.0872 |
| 2014-11-07 | BUDDY  |   666259567 | 5330076.5360 |
| 2014-11-08 | BUDDY  |   728117428 | 6331455.8957 |
| 2014-11-09 | BUDDY  |   870748278 | 7988516.3119 |
| 2014-11-10 | BUDDY  |   647254182 | 5779055.1964 |
| 2014-11-11 | BUDDY  |   825881706 | 2238161.8049 |
| 2014-11-12 | BUDDY  |   794406221 | 6511526.4016 |
| 2014-11-13 | BUDDY  |   574769614 | 5422354.8491 |
| 2014-11-14 | BUDDY  |   732018287 | 7320182.8700 |
| 2014-11-15 | BUDDY  |   537523972 | 5375239.7200 |
| 2014-11-16 | BUDDY  |   719979951 | 6666481.0278 |
| 2014-11-17 | BUDDY  |   492450351 | 4396878.1339 |
| 2014-11-18 | BUDDY  |   519599242 | 4996146.5577 |
| 2014-11-19 | BUDDY  |   498480551 | 4658696.7383 |
| 2014-11-20 | BUDDY  |   568037120 | 4855018.1197 |
| 2014-11-21 | BUDDY  |   819954740 | 6776485.4545 |
| 2014-11-22 | BUDDY  |   898746367 | 7489553.0583 |
| 2014-11-23 | BUDDY  |   932208089 | 6956776.7836 |
| 2014-11-24 | BUDDY  |   816248902 | 6802074.1833 |
| 2014-11-25 | BUDDY  |   614972674 | 5082418.7934 |
| 2014-11-26 | BUDDY  |   587767070 | 5295198.8288 |
| 2014-11-27 | BUDDY  |   890490288 | 6746138.5455 |
| 2014-11-28 | BUDDY  |   937659957 | 8083275.4914 |
| 2014-11-29 | BUDDY  |  1067344932 | 8085946.4545 |
| 2014-11-30 | BUDDY  |   891833131 | 7494396.0588 |
| 2014-11-01 | TNT    | 15843002948 | 3915719.9575 |
| 2014-11-02 | TNT    | 21218787697 | 3904100.7722 |
| 2014-11-03 | TNT    | 16706490859 | 4017915.0695 |
| 2014-11-04 | TNT    | 15085795686 | 3941937.7282 |
| 2014-11-05 | TNT    | 15661902980 | 3884400.5407 |
| 2014-11-06 | TNT    | 20419202225 | 4899040.8409 |
| 2014-11-07 | TNT    | 20446465898 | 5223930.9908 |
| 2014-11-08 | TNT    | 18824592181 | 4948630.9624 |
| 2014-11-09 | TNT    | 19728058658 | 4939423.8002 |
| 2014-11-10 | TNT    | 20183153482 | 5228796.2389 |
| 2014-11-11 | TNT    | 18091114484 | 4406019.1145 |
| 2014-11-12 | TNT    | 18833650733 | 4795938.5620 |
| 2014-11-13 | TNT    | 11855996445 | 3841865.3419 |
| 2014-11-14 | TNT    | 10622390868 | 3673025.8880 |
| 2014-11-15 | TNT    |  9758021198 | 3395275.2951 |
| 2014-11-16 | TNT    |  9970678721 | 3400640.7643 |
| 2014-11-17 | TNT    |  9270905201 | 3388488.7431 |
| 2014-11-18 | TNT    |  9056282333 | 3367899.7148 |
| 2014-11-19 | TNT    |  8273000144 | 3175815.7942 |
| 2014-11-20 | TNT    |  8196969536 | 3242472.1266 |
| 2014-11-21 | TNT    | 14635437004 | 4596556.8480 |
| 2014-11-22 | TNT    | 17402440794 | 5025250.0127 |
| 2014-11-23 | TNT    | 16622719030 | 4723705.3225 |
| 2014-11-24 | TNT    | 15359002877 | 4648608.6189 |
| 2014-11-25 | TNT    | 15105911732 | 4554088.5535 |
| 2014-11-26 | TNT    | 15592088749 | 4462532.5555 |
| 2014-11-27 | TNT    | 19205550714 | 4081077.4998 |
| 2014-11-28 | TNT    | 15970691405 | 4533264.6622 |
| 2014-11-29 | TNT    | 15143721726 | 4290006.1547 |
| 2014-11-30 | TNT    | 20764521004 | 4069878.6758 |
+------------+--------+-------------+--------------+



zcat 2015-01-01.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150101.csv
zcat 2015-01-02.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150102.csv
zcat 2015-01-03.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150103.csv
zcat 2015-01-04.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150104.csv
zcat 2015-01-05.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150105.csv
zcat 2015-01-06.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150106.csv
zcat 2015-01-07.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150107.csv
zcat 2015-01-08.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150108.csv
zcat 2015-01-09.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150109.csv
zcat 2015-01-10.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150110.csv
zcat 2015-01-11.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150111.csv
zcat 2015-01-12.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150112.csv
zcat 2015-01-13.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150113.csv
zcat 2015-01-14.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150114.csv
zcat 2015-01-15.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150115.csv
zcat 2015-01-16.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150116.csv
zcat 2015-01-17.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150117.csv
zcat 2015-01-18.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150118.csv
zcat 2015-01-19.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150119.csv
zcat 2015-01-20.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20150120.csv
zcat 2014-12-21.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20141221.csv
zcat 2014-12-22.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20141222.csv
zcat 2014-12-23.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20141223.csv
zcat 2014-12-24.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20141224.csv
zcat 2014-12-25.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20141225.csv
zcat 2014-12-26.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20141226.csv
zcat 2014-12-27.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20141227.csv
zcat 2014-12-28.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20141228.csv
zcat 2014-12-29.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20141229.csv
zcat 2014-12-30.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20141230.csv
zcat 2014-12-31.csv.gz | grep ClashofclansService | grep -v '0,0' > /tmp/coc_20141231.csv


load data local infile '/tmp/coc_20150101.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-01';
load data local infile '/tmp/coc_20150102.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-02';
load data local infile '/tmp/coc_20150103.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-03';
load data local infile '/tmp/coc_20150104.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-04';
load data local infile '/tmp/coc_20150105.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-05';
load data local infile '/tmp/coc_20150106.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-06';
load data local infile '/tmp/coc_20150107.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-07';
load data local infile '/tmp/coc_20150108.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-08';
load data local infile '/tmp/coc_20150109.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-09';
load data local infile '/tmp/coc_20150110.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-10';
load data local infile '/tmp/coc_20150111.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-11';
load data local infile '/tmp/coc_20150112.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-12';
load data local infile '/tmp/coc_20150113.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-13';
load data local infile '/tmp/coc_20150114.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-14';
load data local infile '/tmp/coc_20150115.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-15';
load data local infile '/tmp/coc_20150116.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-16';
load data local infile '/tmp/coc_20150117.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-17';
load data local infile '/tmp/coc_20150118.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-18';
load data local infile '/tmp/coc_20150119.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-19';
load data local infile '/tmp/coc_20150120.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2015-01-20';
load data local infile '/tmp/coc_20141221.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-21';
load data local infile '/tmp/coc_20141222.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-22';
load data local infile '/tmp/coc_20141223.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-23';
load data local infile '/tmp/coc_20141224.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-24';
load data local infile '/tmp/coc_20141225.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-25';
load data local infile '/tmp/coc_20141226.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-26';
load data local infile '/tmp/coc_20141227.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-27';
load data local infile '/tmp/coc_20141228.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-28';
load data local infile '/tmp/coc_20141229.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-29';
load data local infile '/tmp/coc_20141230.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-30';
load data local infile '/tmp/coc_20141231.csv' into table tmp_youtube_nds fields terminated by ',' lines terminated by '\n' (phone,service,transmit,received,tx_date) set tx_date='2014-12-31';

select tx_date, sum(transmit+received) total_usage, avg(transmit+received) avg_usage from tmp_youtube_nds group by 1;
+------------+-------------+--------------+
| tx_date    | total_usage | avg_usage    |
+------------+-------------+--------------+
| 2014-11-01 | 74713294012 | 9132538.0775 |
| 2014-11-02 | 75763013455 | 9449116.1705 |
| 2014-11-03 | 73314515457 | 9059003.5162 |
| 2014-11-04 | 66360805021 | 9068161.3858 |
| 2014-11-05 | 30594458902 | 6688775.4486 |
| 2014-11-06 |  7528863339 | 5185167.5888 |
| 2014-11-07 |  3951640718 | 6051517.1792 |
| 2014-11-08 |  2991295490 | 6218909.5426 |
| 2014-11-09 |  2872792778 | 7075844.2808 |
| 2014-11-10 |  2292232114 | 6064106.1217 |
| 2014-11-11 |  1739346510 | 1630127.9381 |
| 2014-11-12 |  1898231543 | 6456569.8741 |
| 2014-11-13 |  1536404987 | 5627857.0952 |
| 2014-11-14 |  1540519122 | 6262272.8537 |
| 2014-11-15 |  1440202745 | 6344505.4846 |
| 2014-11-16 |  1370483593 | 6374342.2930 |
| 2014-11-17 |  1130227838 | 5091116.3874 |
| 2014-11-18 |  1056073216 | 5770891.8907 |
| 2014-11-19 |   933605804 | 4739115.7563 |
| 2014-11-20 |   765740564 | 4375660.3657 |
| 2014-11-21 |   866293348 | 4759853.5604 |
| 2014-11-22 |   799293062 | 5258506.9868 |
| 2014-11-23 |   759875621 | 4934257.2792 |
| 2014-11-24 |   776714498 | 4515781.9651 |
| 2014-11-25 |   650155195 | 4305663.5430 |
| 2014-11-26 |   717475391 | 5124824.2214 |
| 2014-11-27 |   646743073 | 5013512.1938 |
| 2014-11-28 |   689940100 | 5797815.9664 |
| 2014-11-29 |   605205794 | 5709488.6226 |
| 2014-11-30 |   440710258 | 4157643.9434 |
| 2014-12-01 |   450936464 | 4697254.8333 |
| 2014-12-02 |   431326283 | 4356831.1414 |
| 2014-12-03 |   377424373 | 4193604.1444 |
| 2014-12-04 |   358866510 | 4272220.3571 |
| 2014-12-05 |   390082840 | 5066010.9091 |
| 2014-12-06 |   363457749 | 4600731.0000 |
| 2014-12-07 |   381842698 | 4062156.3617 |
| 2014-12-08 |   426983527 | 4797567.7191 |
| 2014-12-09 |   360194013 | 4739394.9079 |
| 2014-12-10 |   269589986 | 4569321.7966 |
| 2014-12-11 |   157944933 | 2871726.0545 |
| 2014-12-12 |   107648796 | 2446563.5455 |
| 2014-12-13 |   151090677 | 3433879.0227 |
| 2014-12-14 |   145309102 | 3927273.0270 |
| 2014-12-15 |   118974657 | 2974366.4250 |
| 2014-12-16 |   119738792 | 2660862.0444 |
| 2014-12-17 |   116024681 | 2636924.5682 |
| 2014-12-18 |   117390133 | 2214908.1698 |
| 2014-12-19 |    99356660 | 2614648.9474 |
| 2014-12-20 |    98278595 | 2807959.8571 |
| 2014-12-21 |    93928375 | 2846314.3939 |
| 2014-12-22 |    85191563 | 2937640.1034 |
| 2014-12-23 |   125226611 | 4816408.1154 |
| 2014-12-24 |    93675151 | 1357610.8841 |
| 2014-12-25 |   111260998 | 5057318.0909 |
| 2014-12-26 |   116581881 | 2649588.2045 |
| 2014-12-27 |    70660973 | 2717729.7308 |
| 2014-12-28 |   125456905 | 5018276.2000 |
| 2014-12-29 |   141700720 | 5450027.6923 |
| 2014-12-30 |   104801453 | 4192058.1200 |
| 2014-12-31 |    85583516 | 1901855.9111 |
| 2015-01-01 |    86346135 | 3924824.3182 |
| 2015-01-02 |    83495680 | 3975984.7619 |
| 2015-01-03 |    79609472 | 3790927.2381 |
| 2015-01-04 |    77066814 | 3853340.7000 |
| 2015-01-05 |    65152916 | 1416367.7391 |
| 2015-01-06 |    43905538 | 2439196.5556 |
| 2015-01-07 |    48110774 | 3207384.9333 |
| 2015-01-08 |    47596421 |  971355.5306 |
| 2015-01-09 |    57767574 | 4443659.5385 |
| 2015-01-10 |    54347381 | 2717369.0500 |
| 2015-01-11 |    38288789 | 2734913.5000 |
| 2015-01-12 |    35375495 | 2721191.9231 |
| 2015-01-13 |    39206227 | 3267185.5833 |
| 2015-01-14 |    39084605 | 2791757.5000 |
| 2015-01-15 |    46233757 | 3556442.8462 |
| 2015-01-16 |    65515280 | 5039636.9231 |
| 2015-01-17 |    71243409 | 5480262.2308 |
| 2015-01-18 |    49088748 | 4090729.0000 |
| 2015-01-19 |    43845936 | 1019672.9302 |
| 2015-01-20 |    62166731 | 4144448.7333 |
+------------+-------------+--------------+
81 rows in set (0.05 sec)


select tx_date, round(sum(transmit+received)/1000000,2) total_usage, round(avg(transmit+received)/1000000,2) avg_usage from tmp_youtube_nds group by 1;
+------------+-------------+-----------+
| tx_date    | total_usage | avg_usage |
+------------+-------------+-----------+
| 2014-11-01 |    74713.29 |      9.13 |
| 2014-11-02 |    75763.01 |      9.45 |
| 2014-11-03 |    73314.52 |      9.06 |
| 2014-11-04 |    66360.81 |      9.07 |
| 2014-11-05 |    30594.46 |      6.69 |
| 2014-11-06 |     7528.86 |      5.19 |
| 2014-11-07 |     3951.64 |      6.05 |
| 2014-11-08 |     2991.30 |      6.22 |
| 2014-11-09 |     2872.79 |      7.08 |
| 2014-11-10 |     2292.23 |      6.06 |
| 2014-11-11 |     1739.35 |      1.63 |
| 2014-11-12 |     1898.23 |      6.46 |
| 2014-11-13 |     1536.40 |      5.63 |
| 2014-11-14 |     1540.52 |      6.26 |
| 2014-11-15 |     1440.20 |      6.34 |
| 2014-11-16 |     1370.48 |      6.37 |
| 2014-11-17 |     1130.23 |      5.09 |
| 2014-11-18 |     1056.07 |      5.77 |
| 2014-11-19 |      933.61 |      4.74 |
| 2014-11-20 |      765.74 |      4.38 |
| 2014-11-21 |      866.29 |      4.76 |
| 2014-11-22 |      799.29 |      5.26 |
| 2014-11-23 |      759.88 |      4.93 |
| 2014-11-24 |      776.71 |      4.52 |
| 2014-11-25 |      650.16 |      4.31 |
| 2014-11-26 |      717.48 |      5.12 |
| 2014-11-27 |      646.74 |      5.01 |
| 2014-11-28 |      689.94 |      5.80 |
| 2014-11-29 |      605.21 |      5.71 |
| 2014-11-30 |      440.71 |      4.16 |
+------------+-------------+-----------+
30 rows in set (0.04 sec)
