#!/bin/bash

date_yesterday=$(date --date=yesterday +%Y-%m-%d)
current_month=$(date --date=yesterday +%Y-%m)
txt_month=$(date --date=yesterday +%B)

#date_yesterday="2014-11-30"
#current_month="2014-11"
#txt_month="November"

/home/dba_scripts/oist_stat/email_hi10_usage.pl $current_month $date_yesterday $txt_month
