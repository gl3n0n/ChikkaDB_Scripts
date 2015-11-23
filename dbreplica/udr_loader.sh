#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server
a=$1
# %k     hour ( 0..23)
var_dir=/home/mysql/vars
var_log=/home/mysql/log
var_dmp=/mnt/paywall_dmp/dmp/

var_usr=`head -1 $var_dir/usr.list`
var_pn=`head -1  $var_dir/pn.list`
var_chk=`tail -1  $var_dir/pn.list`
var_chk2=`tail -2  $var_dir/pn.list | head -1 `
db_prt=3307
db_host="127.0.0.1"
db_conn="mysql -ustats -p$var_chk2 archive_powerapp_flu -h$db_host -P$db_prt"
db_opt="-N -e"

logger(){
  echo "`date` : $*" >> $var_log/$var_cur.sftp.log
}

load_dmp_() {
 echo "Parsing 2nd part" >> $var_log/$var_cur.sftp.log
  echo $a
  logger "udr_loader.sh: processing file $a"
  cat $a | awk -F',' '{printf $4"+"$5"+"$7"+"$8"+"$13"+"$14"+"$17 "\n"}' | awk -F'+' '{printf substr($1,0,10)","substr($1,0,19)","substr($3,0,19)","$5","$6","$7","$8","$9"\n"}' | grep -v NoEnforce > $a.txt
  rm -f $a
  echo "DB loading  part2" >> $var_log/$var_cur.sftp.log
  logger "udr_loader.sh: loading file $a"
  `$db_conn $db_opt "LOAD DATA LOCAL INFILE '$a.txt'  IGNORE  INTO TABLE archive_powerapp_flu.powerapp_udr_log  FIELDS TERMINATED by ',' IGNORE 1 LINES (tx_date,start_tm,end_tm,phone,ip_addr,source,service,b_usage)"`
  rm -f $a.txt
}

load_dmp_

