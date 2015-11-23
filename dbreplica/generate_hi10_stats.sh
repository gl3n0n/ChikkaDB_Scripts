#!/bin/bash

tx_date=`date '+%Y-%m-%d' --date='1 day ago'`
p=`tail -2  /home/mysql/vars/pn.list | head -1`
echo "processing retentation stats for $tx_date..." >> /tmp/gen_hi10.log
echo "call sp_generate_retention_main();" | mysql -ustats -p$p archive_powerapp_flu -hlocalhost --socket=/mnt/dbrep3307/mysql.sock -P3307 
