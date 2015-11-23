#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server
var_date=`date +%Y_%m_%d -d '2 day ago'`
#var_date=`date +%Y%m%d -d '2 day ago'`
var_exp=`date +%Y%m%d -d '15 day ago'`
a=$1
# %k     hour ( 0..23)
var_dir=/home/mysql/vars/
var_log=/home/mysql/log
var_dmp=/home/mysql/dmp
var_usr=`head -1 $var_dir/usr.list`
var_pn=`head -1  $var_dir/pn.list`
var_chk=`tail -1  $var_dir/pn.list`
var_chk2=`tail -2  $var_dir/pn.list | head -1 `
#db_log_dir=/mnt/logs/mysql_binary_logs
#dmp_log_dir=/mnt/backup_bin_logs/
#log_file=/d2/chikka/logs/sessions_currently_mapped_$var_date.txt
db_prt=3307
db_host="127.0.0.1"
db_conn="mysql -ustats -p$var_chk2 archive_powerapp_flu -h$db_host -P$db_prt"
db_opt="-N -e"

logger(){
  echo "`date` : $*" >> $var_log/sftp.log
}

load_dmp_prev() {
  cat $a | awk -F',' '{printf $4"+"$5"+"$7"+"$8"+"$13"+"$14"+"$17 "\n"}' | awk -F'+' '{printf substr($1,0,10)","substr($1,0,19)","substr($3,0,19)","$5","$6","$7","$8","$9"\n"}' | grep -v NoEnforce > 2$1
#  `$db_conn $db_opt "LOAD DATA LOCAL INFILE '$var_dmp/udr/SANDVINE_ALL_$var_date'  IGNORE  INTO TABLE archive_powerapp_flu.powerapp_udr_log  FIELDS TERMINATED by ',' IGNORE 1 LINES (tx_date,start_tm,end_tm,phone,ip_addr,source,service,b_usage)"`
#  logger "PULL data process from sandvine ended"
#  rm -f $var_dmp/udr/SANDVINE_ALL_$var_date
#  `cat $1` > /home/mysql/scripts/t
echo $a
}









#echo $1
load_dmp_prev
#load_exp_prev
#`$db_conn $db_opt  "call sp_generate_udr_usage('$var_date')"`

