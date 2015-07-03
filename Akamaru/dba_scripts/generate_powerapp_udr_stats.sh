#!/bin/bash

# Set Variables
date_display=$(date '+%H:%M')
date_where=$(date '+%Y-%m-%d %H:%M:%S')
tx_date=$1
email_to="glenon@chikka.com"
email_cc="glenon@chikka.com"
fname1='/tmp/powerapp_udr_stats.txt'
p='stats'
rm -f $fname1

# Generate Stats
echo "" >> $fname1
echo "TOP 10 Based on MB Spent per Day" >> $fname1
echo "select 0 into @rownum;
select concat('TOP ', @rownum:=@rownum+1) Rank, t.* from (
   select phone, round(sum(tx_usage)/1000000,0) MB_Spent, sum(tx_cost) Money_Spent, sum(tm_spent) Time_Spent
   from   powerapp_udr_summary
   where  tx_date = '$tx_date'
   group  by phone
   order by 2 desc
   ) t
limit 10" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 -t >> $fname1

echo "" >> $fname1
echo "" >> $fname1
echo "TOP 10 Based on MB Spent per Plan per Day" >> $fname1
echo "select 0 into @rownum;
select concat('TOP ', @rownum:=@rownum+1) Rank, t.* from (
   select phone, plan, round(sum(tx_usage)/1000000,0) MB_Spent, sum(tx_cost) Money_Spent, sum(tm_spent) Time_Spent
   from   powerapp_udr_summary
   where  tx_date = '$tx_date'
   group  by phone, plan
   order by 3 desc
   ) t
limit 10" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 -t >> $fname1

echo "" >> $fname1
echo "TOP 10 Based on Money Spent per Plan per Day" >> $fname1
echo "select 0 into @rownum;
select concat('TOP ', @rownum:=@rownum+1) Rank, t.* from (
   select phone, plan, round(sum(tx_usage)/1000000,0) MB_Spent, sum(tx_cost) Money_Spent, sum(tm_spent) Time_Spent
   from   powerapp_udr_summary
   where  tx_date = '$tx_date'
   group  by phone, plan
   order by 4 desc
   ) t
limit 10" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 -t >> $fname1

echo "" >> $fname1
echo "TOP 10 Based on Time Spent per Plan per Day" >> $fname1
echo "select 0 into @rownum;
select concat('TOP ', @rownum:=@rownum+1) Rank, t.* from (
   select phone, plan, round(sum(tx_usage)/1000000,0) MB_Spent, sum(tx_cost) Money_Spent, sum(tm_spent) Time_Spent
   from   powerapp_udr_summary
   where  tx_date = '$tx_date'
   group  by phone, plan
   order by 5 desc
   ) t
limit 10" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 -t >> $fname1


echo "" >> $fname1
echo "******" >> $fname1
echo "TOP 10 Based on Money Spent per Plan per Day (w Zero MB Spent )" >> $fname1
echo "select 0 into @rownum;
select concat('TOP ', @rownum:=@rownum+1) Rank, t.* from (
   select phone, plan, round(sum(tx_usage)/1000000,0) MB_Spent, sum(tx_cost) Money_Spent, sum(tm_spent) Time_Spent
   from   powerapp_udr_summary
   where  tx_date = '$tx_date'
   and    tx_usage = 0
   group  by phone, plan
   order by 4 desc
   ) t
limit 10" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 -t >> $fname1


# Send mail PREPAID
echo "PowerApp UDR ($tx_date) Stats.

Please refer to the attachment.



Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp UDR Stats ($tx_date)" -a $fname1

