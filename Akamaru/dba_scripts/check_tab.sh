#!/bin/bash

date_file=`date '+%Y-%m-%d' --date='yesterday'`
p='stats'
echo "select 'ArchiveDB' DB;
   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;
select left(datein,10) PwrLog_Date, count(1) Count from powerapp_log where datein >= date_sub(curdate(), interval 7 day) group by 1;
select left(datein,10) PwrUsr_Date, count(1) Count from powerapp_users where datein >= date_sub(curdate(), interval 7 day) group by 1;
select left(datein,10) PwrOptLog_Date, count(1) Count from powerapp_optout_log where datein >= date_sub(curdate(), interval 7 day) group by 1;
select left(datein,10) PwrOptUsr_Date, count(1) Count from powerapp_optout_users where datein >= date_sub(curdate(), interval 7 day) group by 1; 
select 'SlaveDB' DB;
select left(datein,10) PwrLog_Date, count(1) Count from powerapp_flu.powerapp_log where datein >= date_sub(curdate(), interval 7 day) group by 1;
select left(datein,10) PwrUsr_Date, count(1) Count from powerapp_flu.new_subscribers where datein >= date_sub(curdate(), interval 7 day) group by 1;
select left(datein,10) PwrOptLog_Date, count(1) Count from powerapp_flu.powerapp_optout_log where datein >= date_sub(curdate(), interval 7 day) group by 1;
" | mysql -ustats -p$p archive_powerapp_flu -h172.17.150.54 -P3307 --table > /tmp/check_tab.txt 
echo "PowerApp Check Tables for $date_file." | mutt dbadmins@chikka.com -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"PowerApp Check tables - $date_file" -a /tmp/check_tab.txt
#10.11.4.164 -P3309
