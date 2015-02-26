#!/bin/bash

email_to="glenon@chikka.com"
email_cc="glenon@chikka.com"
date_yesterday=$(date --date=yesterday +%Y-%m-%d)
current_month=$(date --date=yesterday +%Y-%m)
txt_month=$(date --date=yesterday +%B)
echo "param: $1"
date_yesterday="$1"
current_month="2014-09"
txt_month="September"

/home/dba_scripts/oist_stat/email_liberation_usage.pl $current_month $date_yesterday
rm /home/dba_scripts/oist_stat/PowerApp_Liberation_Usage_$date_yesterday.xls.gz
gzip /home/dba_scripts/oist_stat/PowerApp_Liberation_Usage_$date_yesterday.xls

echo "PowerApp Liberation Usage for $date_yesterday.


Please refer to the attachment.




Regards,
CHIKKA DBA TEAM
" | mutt "$email_to" -c"$email_cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp Liberation Usage - $date_yesterday" -a /home/dba_scripts/oist_stat/PowerApp_Liberation_Usage_$date_yesterday.xls.gz

