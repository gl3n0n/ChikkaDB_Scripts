#!/bin/bash

# Set Variables
date_display=`date '+%Y-%m-%d' --date='yesterday'`
date_file=`date '+%Y_%m_%d' --date='yesterday'`
email_to="dlchan@smart.com.ph,victor@chikka.com,jomai@chikka.com,tatezz@yahoo.com,dikster424@gmail.com,dungomichelle@yahoo.com"
#email_to="glenon@chikka.com"
email_cc="dbadmins@chikka.com"
fname1='/tmp/Powerapp_Active_Prepaid_list_'$date_file'.txt'
fname2='/tmp/Powerapp_Active_TNT_list_'$date_file'.txt'
fname3='/tmp/Powerapp_Active_Postpaid_list_'$date_file'.txt'
p='stats'
rm -f $fname1
rm -f $fname2
rm -f $fname3

# Generate Inactive List
echo "select phone from powerapp_active_users where brand='BUDDY'" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 | grep -v phone > $fname1
#gzip -9v $fname1

echo "select phone from powerapp_active_users where brand='TNT'" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 | grep -v phone > $fname2
#gzip -9v $fname2

echo "select phone from powerapp_active_users where brand='POSTPD'" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 | grep -v phone > $fname3
#gzip -9v $fname3


# Send mail PREPAID
echo "PowerApp Active Smart Prepaid MIN's as of $date_display.

Please refer to the attachment.

 

Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp Active Smart Prepaid MINs - $date_display" -a $fname1

# Send mail TNT
echo "PowerApp Active TNT MIN's as of $date_display.

Please refer to the attachment.



Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp Active TNT MINs - $date_display" -a $fname2

# Send mail PREPAID
echo "PowerApp Active Smart Postpaid MIN's as of $date_display.

Please refer to the attachment.



Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp Active Smart Postpaid MINs - $date_display" -a $fname3


