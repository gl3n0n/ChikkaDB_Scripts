#!/bin/bash

# Set Variables
date_display=`date '+%Y-%m-%d' --date='yesterday'`
date_file=`date '+%Y_%m_%d' --date='yesterday'`
email_to="dlchan@smart.com.ph,victor@chikka.com,jomai@chikka.com,tatezz@yahoo.com,dikster424@gmail.com,dungomichelle@yahoo.com"
email_cc="dbadmins@chikka.com"
fname1='/tmp/Powerapp_Inactive_Prepaid_list_'$date_file'.csv'
fname2='/tmp/Powerapp_Inactive_TNT_list_'$date_file'.csv'
fname3='/tmp/Powerapp_Inactive_Postpaid_list_'$date_file'.csv'
p='stats'
rm -f $fname1
rm -f $fname2
rm -f $fname3

# Generate Inactive List
echo "select phone from powerapp_inactive_list a where brand='BUDDY' and not exists (select 1 from powerapp_excluded_mins b where a.phone=b.phone)" | mysql -ustats -p$p archive_powerapp_flu -h172.17.150.54 -P3307 | grep -v phone > $fname1
#gzip -9v $fname1

echo "select phone from powerapp_inactive_list a where brand='TNT' and not exists (select 1 from powerapp_excluded_mins b where a.phone=b.phone)" | mysql -ustats -p$p archive_powerapp_flu -h172.17.150.54 -P3307 | grep -v phone > $fname2
#gzip -9v $fname2

echo "select phone from powerapp_inactive_list a where brand='POSTPD' and not exists (select 1 from powerapp_excluded_mins b where a.phone=b.phone)" | mysql -ustats -p$p archive_powerapp_flu -h172.17.150.54 -P3307 | grep -v phone > $fname3
#gzip -9v $fname3


# Send mail PREPAID
echo "PowerApp Inactive Smart Prepaid MIN's as of $date_display.

Please refer to the attachment.

 

Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp Inactive Smart Prepaid MINs - $date_display" -a $fname1

# Send mail TNT
echo "PowerApp Inactive TNT MIN's as of $date_display.

Please refer to the attachment.



Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp Inactive TNT MINs - $date_display" -a $fname2

# Send mail POSTPAID
echo "PowerApp Inactive Smart Postpaid MIN's as of $date_display.

Please refer to the attachment.



Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp Inactive Smart Postpaid MINs - $date_display" -a $fname3


