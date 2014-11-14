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
