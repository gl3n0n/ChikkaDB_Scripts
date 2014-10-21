#!/bin/bash

date_yesterday=$(date +%Y-%m-%d)
current_month=$(date +%Y-%m)
txt_month=$(date +%B)

/home/dba_scripts/oist_stat/email_hi10_08_20.pl $current_month $date_yesterday $txt_month
