#!/bin/bash

# Set Variables
date_display=`date '+%Y-%m-%d' --date='yesterday'`
date_file=`date '+%Y_%m_%d' --date='yesterday'`
#email_to="dlchan@smart.com.ph,victor@chikka.com,jomai@chikka.com,tatezz@yahoo.com,dikster424@gmail.com,dungomichelle@yahoo.com"
email_to="jomai@chikka.com,victor@chikka.com"
#email_to="glenon@chikka.com"
email_cc="dbadmins@chikka.com"
fname1='/tmp/Liberation_AutoRenewal.txt'
p='stats'
rm -f $fname1

# Generate 
echo "
select concat(tx_date, ': ', hits) 'Date : Total' from powerapp_tnt_auto_renewal_stats order by tx_date;
" | mysql -ustats -p$p archive_powerapp_flu -h172.17.150.54 -P3307 > $fname1

# Send mail 
echo "PowerApp Liberation Daily Stats for TNT Auto-Renewal as of $date_display.

" > /tmp/tmp_liberation.txt

cat $fname1 >> /tmp/tmp_liberation.txt
echo "


Regards,
CHIKKA DBA TEAM
" >> /tmp/tmp_liberation.txt

cat /tmp/tmp_liberation.txt | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp Liberation Auto-Renewal Stats - $date_display"
