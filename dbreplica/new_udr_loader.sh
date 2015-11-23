#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server
a=$1
# %k     hour ( 0..23)
#var_date=`date +%Y-%m-%d -d '14 day ago'`
#var_cur=`date +%Y%m%d`
# %k     hour ( 0..23)
var_dir=/home/mysql/vars/
var_log=/home/mysql/log
var_dmp=/mnt/paywall_dmp/dmp

var_usr=`head -1 $var_dir/usr.list`
var_pn=`head -1  $var_dir/pn.list`
var_chk=`tail -1  $var_dir/pn.list`
var_chk2=`tail -2  $var_dir/pn.list | head -1 `
db_prt=3307
db_host="127.0.0.1"
db_conn="mysql -ustats -p$var_chk2 archive_powerapp_flu -h$db_host -P$db_prt"
db_opt="-N -e"

logger(){
  echo "`date` : $*" >> $var_log/$var_cur.udr.log
# $var_log/$var_cur.udr.log 
}

load_dmp_() {
  echo $a
  cd $var_dmp/udr
  logger "Processing of UDR file inprogress: $a"
  
#bzcat $a | awk -F',' '{printf $4"+"$7"+"$14"+"$15"+"$16"+"$17"+"$18 "\n"}' | awk -F'+' '{printf substr($1,0,10)","$3","$4","$5","$8"\n"}' | sed '1d'  > $a.txt
  ls $a
  logger "Completed UDR processing: $a"
}

load_dmp_

