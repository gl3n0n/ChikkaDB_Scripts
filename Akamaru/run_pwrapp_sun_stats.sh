#!/bin/bash

date_yesterday=$(date --date=yesterday +%Y-%m-%d)
current_month=$(date --date=yesterday +%Y-%m)
txt_month=$(date --date=yesterday +%B)

#date_yesterday="2013-07-31"
#current_month="2014-07"
#txt_month="July"

/home/dba_scripts/oist_stat/email_sun_pwrapp_stats.pl $current_month $date_yesterday $txt_month
