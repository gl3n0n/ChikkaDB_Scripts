#!/bin/bash

# Set Variables
date_display=`date '+%Y-%m-%d' --date='yesterday'`
date_file=`date '+%Y_%m_%d' --date='yesterday'`
#email_to="victor@chikka.com,ps.java@chikka.com"
email_to="nbrinas@chikka.com,victor@chikka.com"
email_cc="dbadmins@chikka.com"
fname1='/tmp/Powerapp_Duration_Report_'$date_file'.txt'
fname2='/tmp/Powerapp_Mapping_TNT_list_'$date_file'.csv'
fname3='/tmp/Powerapp_Mapping_Postpaid_list_'$date_file'.csv'
p='stats'
rm -f $fname1.gz
rm -f $fname2.gz
rm -f $fname3.gz

# Generate  Mapping Usage

mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 -e"call sp_generate_hi10_percentile(90,'$date_display');" > fname1

# Send mail PREPAID
echo "PowerApp Duration Report as of $date_display.

Please refer to the attachment.



Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"PowerApp Duration Report - $date_display" -a  /tmp/test1.txt
