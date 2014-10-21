#!/bin/bash

. /etc/profile
. /home/mysql/.bash_profile

dateyest1=`date '+%b %e,%Y' --date=$1' day ago'`
dateyest2=`date '+%Y-%m-%d' --date=$1' day ago'`
# ALLAN 20130410
cd /home/mysql/dba_mon_central/db_monitor/
v_credit_adm="-u`sed -n 1,1p vars/v_dbu.txt` -p`sed -n 1,1p vars/v_dbp.txt` -h127.0.0.1 -P3302 test"
#echo $v_credit_adm    

# generate ctm stats for Hits, MT (shrike)
# mysql $v_creditadm  -N -e"call sp_generate_ctm_stats_csg()";

>/tmp/ctmv5.stats.tmp
# generate ctm stats for MO, Unique MO and Unique MT (db7)
#echo "select tran_dt, tran_tm, carrier, type, post, pre from ctm_stats_dtl where tran_dt='$dateyest2'" | mysql -uctmv5 -pctmv5 test -h 112.199.83.115 -P3382 | grep -v "^tran_dt" > /tmp/ctmv5.tmp
#mysql $v_credit_adm  -N -e"load data local infile '/tmp/ctmv5.tmp' into table ctm_stats_dtl fields terminated by '\t'";

>/tmp/ctmv5.stats.tmp
# generate ctm stats for Registrations and Logins (vega)
#echo "call sp_generate_ctm_stats_reg('$dateyest2')" | mysql -uctmv5 -pctmv5 test_allan -h 112.199.82.69 -P3386;
#echo "select tran_dt, '00:00' tran_tm, carrier, type, post, pre from ctm_stats_dtl where tran_dt='$dateyest2'" | mysql -uctmv5 -pctmv5 test_allan -h 112.199.82.69 -P3386 | grep -v "^tran_dt" > /tmp/ctmv5.tmp
#mysql $v_credit_adm  -N -e"load data local infile '/tmp/ctmv5.tmp' into table ctm_stats_dtl fields terminated by '\t'";

>/tmp/ctmv5.stats.tmp
# generate daily ctm stats (shrike)
echo "select stats from ctm_stats_daily where tran_dt = '$dateyest2' order by seq_no, stats" | mysql -uctmv5 -pctmv5 test -h127.0.0.1 -P3302 -r | grep -v stats > /tmp/ctmv5.stats.tmp
mail -s "CTMv5 Stats: $dateyest1" glenon@chikka.com afaylona@chikka.com jomai@chikka.com ps.java@chikka.com ra@chikka.com mikey@chikka.com < /tmp/ctmv5.stats.tmp
#mail -s "CTMv5 Stats: $dateyest1" glenon@chikka.com afaylona@chikka.com jojo@chikka.com < /tmp/ctmv5.stats.tmp

