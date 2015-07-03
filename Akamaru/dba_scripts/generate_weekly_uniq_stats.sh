#!/bin/bash

# Set Variables
date_display=$(date --date=yesterday +%Y-%m-%d)
date_file=$(date --date=yesterday +%Y_%m_%d)
email_to="jomai@chikka.com"
email_cc="dbadmins@chikka.com"
fname1='/tmp/Powerapp_Uniq_Subs_Stats.txt'
p='stats'
rm -f $fname1

# Generate Stats
echo "select tran_dt Date, total_uniq Uniq from powerapp_dailyrep where tran_dt >= date_sub(curdate(), interval 31 day) and tran_dt < curdate() order by tran_dt" | mysql -ustats -p$p powerapp_flu -h10.11.4.164 -P3307 --table > $fname1
echo "select concat('From ', date_sub(tran_dt, interval 30 day), ' to ', tran_dt, ': ', num_uniq_30d) 'Total Unique Subs' from powerapp_dailyrep where tran_dt = date_sub(curdate(), interval 1 day)" | mysql -ustats -p$p powerapp_flu -h10.11.4.164 -P3307 --table >> $fname1

# Send mail PREPAID
echo "PowerApp Weekly Stats, $date_display.

Please refer to the attachment.

 

Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp Weekly Stats - $date_display" -a $fname1
