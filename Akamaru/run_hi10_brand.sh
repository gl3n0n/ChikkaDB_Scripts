#!/bin/bash

date_yesterday=$(date --date=yesterday +%Y-%m-%d)
current_month=$(date --date=yesterday +%Y-%m)
txt_month=$(date --date=yesterday +%B)

#date_yesterday="2014-01-31"
#current_month="2014-01"
#txt_month="January"

/home/dba_scripts/oist_stat/email_hi10_brand.pl $current_month $date_yesterday $txt_month
