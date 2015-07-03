#!/bin/bash

# Set Variables
date_display=$(date '+%H:%M')
date_where=$(date '+%Y-%m-%d %H:%M:%S')
#email_to="victor@chikka.com,speralta@chikka.com,chito@chikka.com"
#email_cc="dbadmins@chikka.com"
email_to="glenon@chikka.com"
email_cc="glenon@chikka.com"
fname1='/tmp/powerapp_bcast_jun24_stats.txt'
p='stats'
rm -f $fname1

# Generate Stats
echo "delete from tmp_april_act_mins;
insert into tmp_april_act_mins
select phone, brand, source, min(datein) datein, count(1) hits from powerapp_flu.powerapp_log where datein >= '2014-06-24 08:00:00' and datein <= '2014-06-24 23:59:59' group by phone, brand, source;
" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309

echo "select b.source Source, count(distinct b.phone) MINs from powerapp_inactive_list_0624 a, tmp_april_act_mins b
where a.phone = b.phone
and   a.bcast_dt = '2014-06-24'
group by b.source;
" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 --table > $fname1


echo "delete from tmp_april_act_mins;
insert into tmp_april_act_mins
select phone, brand, plan, min(datein) datein, count(1) hits from powerapp_flu.powerapp_log where datein >= '2014-06-24 08:00:00' and datein <= '2014-06-24 23:59:59' group by phone, brand, plan;
" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309

echo "select b.source Plan, count(distinct b.phone) MINs from powerapp_inactive_list_0624 a, tmp_april_act_mins b
where a.phone = b.phone
and   a.bcast_dt = '2014-06-24'
group by b.source;
" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 --table >> $fname1


echo "select sum(Total) Base, sum(No_Subs) MINs, ROUND((sum(No_Subs)/sum(Total))*100,2) Pct from (
select count(1) Total, 0 No_Subs from powerapp_inactive_list_0624 a where bcast_dt = '2014-06-24' union
select 0 Total, count(1) No_Subs from powerapp_inactive_list_0624 a where bcast_dt = '2014-06-24' and exists (select 1 from tmp_april_act_mins b where a.phone = b.phone)) t;
" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 --table >> $fname1


# Send mail PREPAID
echo "PowerApp Broadcast (Jun 24) Stats.

Please refer to the attachment.



Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp Broadcast Stats (Jun 24)" -a $fname1

