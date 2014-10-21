#!/bin/bash

. /etc/profile
. /home/mysql/.bash_profile

cd /home/mysql/dba_mon_central/db_monitor/
v_credit_adm="-u`sed -n 1,1p vars/v_dbu.txt` -p`sed -n 1,1p vars/v_dbp.txt` -h127.0.0.1 -P3302 test"
    

# generate ctm stats for Hits, MT
mysql $v_credit_adm  -N -e"call sp_generate_ctmv6_stats_csg()";

>/tmp/ctmv6.stats.tmp
# generate ctmv6 stats for Registration (Cartman)
# procedure sp_ctmv6_generate_stats() runs on Cartman every 7am
echo "select tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, others, total from ctmv6_stats_dtl where tran_dt='`date '+%Y-%m-%d' -d '1 day ago'`'" | mysql -uctmv6 -pctmv6 ctmv6 -h 10.100.24.1 -P3306 | grep -v "^tran_dt" > /tmp/ctmv6.tmp
mysql $v_credit_adm  -N -e"load data local infile '/tmp/ctmv6.tmp' into table ctmv6_stats_dtl fields terminated by '\t'";

>/tmp/ctmv6.stats.tmp
# generate ctmv6 stats for Logins (arsenic)
echo "call sp_ctmv6_generate_stats()" | mysql -uctmv6 -pctmv6 ctmv6_logs -h10.100.1.29 -P3310;
echo "select tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, others, total from ctmv6_stats_dtl where tran_dt='`date '+%Y-%m-%d' -d '1 day ago'`'" | mysql -uctmv6 -pctmv6 ctmv6_logs -h10.100.1.29 -P3310 | grep -v "^tran_dt" > /tmp/ctmv6.tmp
mysql $v_credit_adm  -N -e"load data local infile '/tmp/ctmv6.tmp' into table ctmv6_stats_dtl fields terminated by '\t'";

>/tmp/ctmv6.stats.tmp
# generate ctm daily summary report (shrike)
echo "select stats from ctm_stats_daily where tran_dt = '`date '+%Y-%m-%d' -d '1 day ago'`' order by seq_no, stats" | mysql -uctmv5 -pctmv5 test -h127.0.0.1 -P3302 -r | grep -v stats > /tmp/ctmv5.stats.tmp
dateyest1=`date '+%b %e,%Y' --date='1 day ago'`
mail -s "CTMv6 Stats: $dateyest1" glenon@chikka.com < /tmp/ctmv5.stats.tmp
