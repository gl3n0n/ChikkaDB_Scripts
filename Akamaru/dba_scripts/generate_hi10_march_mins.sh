#!/bin/bash

# Set Variables
date_display=$1
date_file=$2
email_to="jsia@chikka.com,victor@chikka.com"
email_cc="dbadmins@chikka.com"
fname1='/tmp/Powerapp_March_MINs_'$date_file'.csv'
p='stats'
rm -f $fname1.gz

# Generate March MINs List
echo "select phone from powerapp_users where datein >= '2014-03-01' and datein < '2014-04-01' group by phone" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 | grep -v phone > $fname1
gzip -9v $fname1

# Send mail PREPAID
echo "PowerApp March MIN's as of $date_display.

Please refer to the attachment.

 

Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp March MINs - $date_display" -a $fname1.gz
