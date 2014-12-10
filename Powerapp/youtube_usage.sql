create table tmp_youtube_usage like tmp_coc_usage;

   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

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

