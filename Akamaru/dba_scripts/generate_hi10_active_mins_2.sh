#!/bin/bash

# Set Variables
date_display=$1
date_file=$2
#email_to="dlchan@smart.com.ph,victor@chikka.com,jomai@chikka.com,tatezz@yahoo.com,dikster424@gmail.com,dungomichelle@yahoo.com"
#email_to="dikster424@gmail.com,dungomichelle@yahoo.com"
email_to="glenon@chikka.com"
email_cc="dbadmins@chikka.com"
fname1='/tmp/Powerapp_Active_Prepaid_list_'$date_file'.csv'
fname2='/tmp/Powerapp_Active_TNT_list_'$date_file'.csv'
fname3='/tmp/Powerapp_Active_Postpaid_list_'$date_file'.csv'
p='stats'
rm -f $fname1
rm -f $fname2
rm -f $fname3

# Generate Inactive List
echo "select phone from powerapp_log where brand='BUDDY' and datein >= date_sub('$1', interval 2 day) and datein < date_add('$1', interval 1 day) group by phone" | mysql -ustats -p$p powerapp_flu -h10.11.4.164 -P3307 | grep -v phone > $fname1
#gzip -9v $fname1

echo "select phone from powerapp_log where brand='TNT' and datein >= date_sub('$1', interval 2 day) and datein < date_add('$1', interval 1 day) group by phone" | mysql -ustats -p$p powerapp_flu -h10.11.4.164 -P3307 | grep -v phone > $fname2
#gzip -9v $fname2

echo "select phone from powerapp_log where brand='POSTPD' and datein >= date_sub('$1', interval 2 day) and datein < date_add('$1', interval 1 day) group by phone" | mysql -ustats -p$p powerapp_flu -h10.11.4.164 -P3307 | grep -v phone > $fname3
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


