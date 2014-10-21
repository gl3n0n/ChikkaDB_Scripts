#!/bin/bash

/usr/sbin/ntpdate pool.ntp.org


date_yesterday=$(date --date=yesterday +%Y-%m-%d)
current_month=$(date +"%Y-%m")
txt_month=$(date --date= +%B)


echo "Running Filename : /home/dba_scripts/oist_stat/scp.pl $date_yesterday"
/home/dba_scripts/oist_stat/scp.pl $date_yesterday
