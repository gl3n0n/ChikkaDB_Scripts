#!/bin/bash

date_yesterday=$(date --date=yesterday +%Y-%m-%d)
current_month=$(date +"%Y-%m")
txt_month=$(date --date= +%B)


/home/dba_scripts/oist_stat/email_excel_ctmv5.pl $current_month $date_yesterday $txt_month
