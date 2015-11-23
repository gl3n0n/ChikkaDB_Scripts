#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

var_date=`date +%Y-%m-%d -d '-6 day ago'`
var_dir=/home/mysql/vars/
var_chk2=`tail -2  $var_dir/pn2.list | head -1 `
var_log=/home/mysql/log
db_prt=3307
db_host="127.0.0.1"
db_conn="mysql -ustats -p$var_chk2 archive_powerapp_flu -h$db_host -P$db_prt"
db_opt="-N -e"

logger(){
  echo "`date` : $*" >> $var_log/bcast_mins.log
}

load_bcast_mins() {
  logger "BCAST MINs generation started for $var_date..."
  `$db_conn $db_opt  "call sp_generate_bcast_mins('2014-10-18', '$var_date', 'ALLDAY', 'SPEEDBOOST', 1250000)"`
  logger "BCAST MINs generation ended for $var_date..."
}


load_bcast_mins


