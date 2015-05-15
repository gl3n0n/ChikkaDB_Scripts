#!/bin/bash

date_yesterday=$(date --date=yesterday +%Y-%m-%d)
current_month=$(date --date=yesterday +%Y-%m)
txt_month=$(date --date=yesterday +%B)

#date_yesterday="2013-10-31"
#current_month="2013-10"
#txt_month="November"

/home/dba_scripts/oist_stat/email_hi10.pl $current_month $date_yesterday $txt_month

#date_yesterday="2013-10-31"
#current_month="2013-10"
#txt_month="November"
#/home/dba_scripts/oist_stat/email_hi10.allrec.pl $current_month $date_yesterday $txt_month
