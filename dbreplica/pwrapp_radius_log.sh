#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

var_date=`date +%Y-%m-%d -d '1 day ago'`
var_dir=/home/mysql/vars/
var_log=/home/mysql/log
var_dmp=/mnt/paywall_dmp/radius
var_usr=`head -1 $var_dir/usr2.list`
var_pn=`head -1  $var_dir/pn2.list`
var_chk2=`tail -2  $var_dir/pn2.list | head -1 `
db_prt=3307
db_host="127.0.0.1"
db_conn="mysql -ustats -p$var_chk2 archive_powerapp_flu -h$db_host -P$db_prt"
db_opt="-N -e"

logger(){
  echo "`date` : $*" >> $var_log/sftp.log
}

load_radius() {
  cd $var_dmp
  find . -name 'SP.audit.$var_date*.cdr.tgz' -exec tar -xzvf '{}' \;
  find . -name 'SP.audit.$var_date*.cdr' -print0 | xargs -0  cat |  egrep "(MAP|UNMAP|UPDATE)" | grep "COMPLETE" > $var_dmp/SP_audit.$var_date.csv
  `$db_conn $db_opt "LOAD DATA LOCAL INFILE '$var_dmp/SP_audit.$var_date.csv' INTO TABLE tmp_radius_log fields terminated by ',' lines terminated by '\n' (r_timestamp, r_id, r_action, @col4, @col5, @col6, @col7, @col8, phone, ip_address, @col11, @col12, @col13, @col14, @col15)"`
  rm $var_dmp/*.cdr
  rm $var_dmp/*.cdr.tgz
  gzip $var_dmp/SP_audit.$var_date.csv
  logger "PULL data process from radius ended"
}

load_exp_radius() {
   cd $var_dmp/udr
   logger "PULL data process from radius started"
   /home/mysql/scripts/expect/exp.radius_log_getter.exp  $var_usr $var_pn $var_date
   load_radius
}

cd $var_dmp/udr
load_exp_radius

