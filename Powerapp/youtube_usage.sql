create table tmp_youtube_usage like tmp_coc_usage;

   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

insert into tmp_youtube_usage ( tx_date, start_tm, end_tm, phone, ip_addr, source, service, b_usage ) 
select tx_date, start_tm, end_tm, phone, ip_addr, source, service, b_usage 
from powerapp_udr_log where tx_date >= '2014-07-25' and service ='YoutubeService';

select phone, start_tm, ip_addr, source, service, b_usage from tmp_youtube_usage where tx_date >= '2014-07-25'  order by 1,2;
