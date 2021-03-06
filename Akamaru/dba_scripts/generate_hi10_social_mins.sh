#!/bin/bash

# Set Variables
date_display=`date '+%Y-%m-%d' --date='yesterday'`
date_file=`date '+%Y_%m_%d' --date='yesterday'`
#email_to="dlchan@smart.com.ph,victor@chikka.com,jomai@chikka.com,tatezz@yahoo.com,dikster424@gmail.com,dungomichelle@yahoo.com"
email_to="victor@chikka.com,nbrinas@chikka.com,jomai@chikka.com"
email_cc="dbadmins@chikka.com"
fname1='/tmp/Powerapp_Social_Prepaid_list_'$date_file'.txt'
fname2='/tmp/Powerapp_Social_TNT_list_'$date_file'.txt'
p='stats'
rm -f $fname1.gz
rm -f $fname2.gz

# Generate Inactive List
echo "select phone,datein from powerapp_log where brand='BUDDY' and datein>=date_sub(curdate(), interval 1 day) and datein < curdate() order by 1,2" | mysql -ustats -p$p powerapp_flu -h10.11.4.164 -P3307 | grep -v phone > $fname1
gzip -9v $fname1

echo "select phone, datein from powerapp_log where brand='TNT' and datein>=date_sub(curdate(), interval 1 day) and datein < curdate() order by 1,2" | mysql -ustats -p$p powerapp_flu -h10.11.4.164 -P3307 | grep -v phone > $fname2
gzip -9v $fname2


# Send mail PREPAID
echo "PowerApp Social Smart Prepaid MIN's as of $date_display.

Please refer to the attachment.

 

Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp Social Smart Prepaid MINs - $date_display" -a $fname1.gz

# Send mail TNT
echo "PowerApp Social TNT MIN's as of $date_display.

Please refer to the attachment.



Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp Social TNT MINs - $date_display" -a $fname2.gz

