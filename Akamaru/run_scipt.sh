#!/bin/bash

date_yesterday=$(date --date=yesterday +%Y-%m-%d)
current_month=$(date --date=yesterday +%Y-%m)
txt_month=$(date --date=yesterday +%B)
txt_year=$(date --date=yesterday +%Y)

echo "Running Filename : /home/dba_scripts/oist_stat/scp.pl $date_yesterday"
/home/dba_scripts/oist_stat/scp.pl $date_yesterday

echo "Running Filename : /home/dba_scripts/oist_stat/sms_in_smart.pl $date_yesterday"
/home/dba_scripts/oist_stat/sms_in_smart.pl $date_yesterday

echo "Running Filename : /home/dba_scripts/oist_stat/sms_in_globe.pl $date_yesterday"
/home/dba_scripts/oist_stat/sms_in_globe.pl $date_yesterday

echo "Running Filename : /home/dba_scripts/oist_stat/sms_in_sun.pl $date_yesterday"
/home/dba_scripts/oist_stat/sms_in_sun.pl $date_yesterday

echo "Running Filename : /home/dba_scripts/oist_stat/parser.pl $date_yesterday"
/home/dba_scripts/oist_stat/parser.pl registration $date_yesterday

echo "Running Filename : /home/dba_scripts/oist_stat/parser_oist_success.pl $date_yesterday"
/home/dba_scripts/oist_stat/parser_oist_success.pl $date_yesterday

echo  "Running Filename : /home/dba_scripts/oist_stat/email_excel.pl $current_month $date_yesterday"
/home/dba_scripts/oist_stat/email_excel.pl $current_month $date_yesterday $txt_month

/home/dba_scripts/oist_stat/email_excel_year.pl $current_month $date_yesterday $txt_year
