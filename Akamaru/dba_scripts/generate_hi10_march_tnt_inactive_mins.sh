#!/bin/bash

# Set Variables
email_to="raelepano@chikka.com"
email_cc="rsleyco@chikka.com,victor@chikka.com,dbadmins@chikka.com"
fname1='/tmp/Powerapp_MINs_bcast_20140416_1400.csv'
p='stats'
rm -f $fname1

# Generate March MINs List
echo "select phone from tmp_april_pacquiao_bcast where dt_bcast is null and apn_flag = 'Y'" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 | grep -v phone > $fname1
gzip $fname1

# Send mail 
echo "PowerApp MIN's for broadcast.

Please refer to the attachment.

 

Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp MINs for broadcast" -a $fname1.gz
