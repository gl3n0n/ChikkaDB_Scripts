#!/bin/bash

date_file=`date '+%Y-%m-%d' --date='yesterday'`
p='stats'
echo "call sp_generate_hi10_stats(); " | mysql -ustats -p$p powerapp_flu -h10.11.4.164 -P3307 
echo "call sp_generate_pwrapp_sun_stats(null); " | mysql -ustats -p$p powerapp_sun -h10.11.4.164 -P3307 
echo "PowerApp Stats Generation for $date_file." | mutt dbadmins@chikka.com -e"my_hdr From:powerapp_stats@chikka.com" -s"PowerApp Stats Generation - $date_file"
