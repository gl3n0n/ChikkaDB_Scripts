#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile
var_date=`date +%Y-%m-%d -d '4 day ago'`
#var_date=`date +%Y-%m-%d -d '1 day ago'`
var_dir=/home/mysql/vars
var_log=/home/mysql/log
var_dmp=/home/mysql/dmp
var_usr=`head -2 $var_dir/usr.list | tail -1`
var_pn=`head -4 $var_dir/pn.list | tail -1`
var_chk2=`tail -2 $var_dir/pn2.list | head -1 `
db_prt="-S/mnt/dbrep3307/mysql.sock"
db_host="localhost"
db_conn="mysql -ustats -p$var_chk2 archive_powerapp_flu -h$db_host $db_prt"
db_opt="-N -e "

logger(){
  echo "`date` : $*" >> $var_log/sftp_apn.log
}

load_apn_mins() {
  cd $var_dmp/udr
  gzip -d $var_dmp/udr/redis6317_$var_date*.gz
  echo "start awk..."
  echo "$var_dmp/udr/redis6317_$var_date*.txt | awk -F':' '{printf $3"\n"}' >  $var_dmp/udr/tmp_redis6317_$var_date"
  cat $var_dmp/udr/redis6317_$var_date*.txt | awk -F':' '{printf $3"\n"}' >  $var_dmp/udr/tmp_redis6317_$var_date
  var_cnt_1=`wc -l $var_dmp/udr/redis6317_$var_date*.txt`
  logger "APN MINS count: $var_cnt_1"
  logger "start truncate..."
  logger $db_conn $db_opt  "truncate table tmp_chikka_apn"
  `$db_conn $db_opt "truncate table tmp_chikka_apn"`
  logger "start load..."
  `$db_conn $db_opt "LOAD DATA LOCAL INFILE '$var_dmp/udr/tmp_redis6317_$var_date' INTO TABLE tmp_chikka_apn"`
  logger "start storedproc..."
  `$db_conn $db_opt "call sp_generate_apn_stats('$var_date')"`
  logger "end storedproc..."
  gzip $var_dmp/udr/redis6317_$var_date*.txt
  rm -f $var_dmp/udr/tmp_redis6317_$var_date1.txt.gz
  echo "PULL data process from sandvine ended"
  logger "PULL data process from sandvine ended"
}

load_exp_apn() {
   cd $var_dmp/udr
   logger "PULL data process from APN MINS started"
   echo "PULL data process from APN MINS started"
   /home/mysql/scripts/expect/exp.apn_mins_getter.exp  $var_usr $var_pn $var_date
   load_apn_mins
}

cd $var_dmp/udr
load_exp_apn

