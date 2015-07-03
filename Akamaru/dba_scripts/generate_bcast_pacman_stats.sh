#!/bin/bash

# Set Variables
date_display=$(date --date=yesterday +%H:%M)
#email_to="victor@chikka.com,speralta@chikka.com,chito@chikka.com,jomai.devera@gmail.com"
#email_cc="dbadmins@chikka.com"
email_to="glenon@chikka.com"
email_cc="glenon@@chikka.com"
fname1='/tmp/powerapp_bcast_pacman_stats.txt'
p='stats'
rm -f $fname1

# Generate Stats
echo "delete from tmp_april_act_mins;
insert into tmp_april_act_mins
select phone, brand, source, min(datein) datein, count(1) hits from powerapp_flu.powerapp_log where datein >= '2014-04-15 14:50:00' group by phone, brand, source;
" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309

echo "select b.source Source, sum(hits) MINs from tmp_april_pacquiao_bcast a, tmp_april_act_mins b 
where a.dt_bcast = '2014-04-14'
and   a.phone = b.phone
group by b.source;
" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 --table > $fname1

echo "select sum(Total) Base, sum(No_Subs) MINs, ROUND((sum(No_Subs)/sum(Total))*100,2) Pct from (
select count(1) Total, 0 No_Subs from tmp_april_pacquiao_bcast a where dt_bcast = '2014-04-14' union
select 0 Total, count(1) No_Subs from tmp_april_pacquiao_bcast a where dt_bcast = '2014-04-14' and exists (select 1 from tmp_april_act_mins b where a.phone = b.phone)) t;
" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 --table >> $fname1

# Send mail PREPAID
echo "PowerApp Broadcast (PACMAN) Stats, as of $date_display.

Please refer to the attachment.

 

Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp Broadcast (PACMAN) Stats - as of $date_display" -a $fname1
