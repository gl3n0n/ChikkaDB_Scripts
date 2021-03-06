#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server

#var_date=`date +%Y_%m_%d -d '6 day ago'`
var_date=`date +%Y_%m_%d -d '5 day ago'`
proc_date=`date +%Y-%m-%d -d '5 day ago'`
var_cur=`date +%Y%m%d`
# %k     hour ( 0..23)
var_dir=/home/mysql/vars/
var_log=/home/mysql/log
var_dmp=/mnt/paywall_dmp/dmp

export var_date var_cur var_dir var_log var_dmp proc_date

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

load_dmp_prev() {
  #`$db_conn $db_opt "TRUNCATE TABLE powerapp_udr_log"`
  cd $var_dmp/udr/
  for i in `ls *.bz2`
  do
    logger "Decompressing file $i"
    bzip2 -d $i
  done

  
}

load_exp_prev() {
   cd $var_dmp/udr
   logger "PULL data process from sandvine started"
   /home/mysql/scripts/expect/exp.udr_logs_getter.exp  $var_usr $var_pn $var_date
   load_dmp_prev

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
load_dmp_prev
find $var_dmp/udr -name  'SANDVINE*.udr' -exec sh /home/mysql/scripts/udr_loader.sh {} \;

sleep 2
cd $var_dmp/udr


for abc in `ls *.bz2`
do

  if [ -s "$abc" ] ; then
   logger "WARNING: Error on UDR bz2 file"  >> $var_log/$var_cur.sftp.log
   ls $abc >> $var_log/sftp.log
   logger "Reprocessing $abc now" >> $var_log/$var_cur.sftp.log
   /home/mysql/scripts/expect/exp.udr_logs_reprocess.exp $var_usr $var_pn $abc
   reproc_dmp $abc
  else
   logger "Done with Loading UDR" >> $var_log/$var_cur.sftp.log
   
  fi

done
find $var_dmp/udr -name 'SANDVINE*.udr' -exec /home/mysql/scripts/udr_reprocess.sh {} \;

# finally run stored proc
#logger "Running storeproc now" 
#`$db_conn $db_opt  "call sp_generate_udr_usage('$var_date')"`
#logger "Done with storeproc"q
`$db_conn $db_opt  "call sp_generate_udr_usage('$proc_date')"`
