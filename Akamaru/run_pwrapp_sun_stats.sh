#!/bin/bash

date_yesterday=$(date --date=yesterday +%Y-%m-%d)
current_month=$(date --date=yesterday +%Y-%m)
txt_month=$(date --date=yesterday +%B)

#date_yesterday="2013-09-30"
#current_month="2014-09"
#txt_month="September"

/home/dba_scripts/oist_stat/email_sun_pwrapp_stats.pl $current_month $date_yesterday $txt_month
