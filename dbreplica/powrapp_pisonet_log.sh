#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server

var_date=`date +%Y_%m_%d -d '4 day ago'`
var_cur=`date +%Y%m%d`
# %k     hour ( 0..23)
var_dir=/home/mysql/vars/
var_log=/home/mysql/log
var_dmp=/home/mysql/dmp
var_usr=`head -1 $var_dir/usr.list`
var_pn=`head -1  $var_dir/pn.list`
var_chk=`tail -1  $var_dir/pn.list`
var_chk2=`tail -2  $var_dir/pn.list | head -1 `
db_prt=3307
db_host="127.0.0.1"
db_conn="mysql -ustats -p$var_chk2 archive_powerapp_flu -h$db_host -P$db_prt"
db_opt="-N -e"
export var_date var_cur var_dir var_log var_dmp var_usr var_pn var_chk var_chk2 db_prt db_host db_conn db_opt

logger(){
  echo "`date` : $*" >> $var_log/$var_cur.pisonet.log
}

load_dmp_prev() {
  `$db_conn $db_opt "delete from tmp_pisonet_usage"`
  cd $var_dmp/udr/
  for i in `ls *.bz2`
  do
    logger "decompress file $i"
    bzip2 -d $i
  done
}

load_exp_prev() {
   cd $var_dmp/udr
   logger "PULL data process from sandvine started"
   /home/mysql/scripts/expect/exp.udr_logs_getter.exp  $var_usr $var_pn $var_date
}

reproc_dmp() {
  cd $var_dmp/udr/
  for i in `ls $1`
  do
    bzip2 -d $1
  done
}

cd $var_dmp/udr
load_exp_prev
#load_dmp_prev
#find $var_dmp/udr -name  'SANDVINE*.udr' -exec sh /home/mysql/scripts/pisonet_loader.sh {} \;

#sleep 2
#cd /home/mysql/dmp/udr
#for abc in `ls *.bz2`
#do
#  if [ -s "$abc" ] ; then
#   logger "WARNING: Error on UDR bz2 file" 
#   logger "Reprocessing $abc now"  
#   /home/mysql/scripts/expect/exp.udr_logs_reprocess.exp $var_usr $var_pn $abc
#   reproc_dmp $abc
#  else
#   logger "Done with Loading UDR" 
#  fi
#done
#find $var_dmp/udr -name 'SANDVINE*.udr' -exec /home/mysql/scripts/pisonet_reloader.sh {} \;

# finally run stored proc
#logger "Insert into boost_usage..." 
#`$db_conn $db_opt  "insert into boost_usage (datein, phone, ipaddr, used_byte) select start_tm, phone, ip_addr, b_usage from tmp_pisonet_usage"`
#logger "Done with insert..."

