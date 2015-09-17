#!/bin/bash

date_yesterday=$(date --date=yesterday +%Y-%m-%d)
current_month=$(date --date=yesterday +%Y-%m)
txt_month=$(date --date=yesterday +%B)

#date_yesterday="2015-08-31"
#current_month="2015-08"
#txt_month="August"

/home/dba_scripts/oist_stat/email_hi10_active_retention.pl $current_month $date_yesterday $txt_month
