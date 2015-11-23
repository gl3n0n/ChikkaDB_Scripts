#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server

var_date=`date +%Y%m%d -d '1 day ago'`
var_backdate=`date +%Y-%m-%d -d '1 day ago'`
var_cur=`date +%Y%m%d`
# %k     hour ( 0..23)
var_dir="/home/mysql/vars"
var_log="/home/mysql/log"
var_dmp="/home/mysql/dmp"

export var_date var_cur var_dir var_log var_dmp

var_usr=`head -1 $var_dir/usr3.list`
var_pn=`head -1  $var_dir/pn.list`
var_chk=`tail -1  $var_dir/pn.list`
var_chk2=`head -5 $var_dir/pn3.list | tail -1 `
db_prt=3307
db_host="127.0.0.1"
db_conn="mysql -ustats -p$var_chk2 archive_powerapp_flu -h$db_host -P$db_prt"
db_opt="-N -e"

logger(){
  echo "`date` : $*" >> $var_log/$var_cur.sftp.log
}

load_dmp_prev() {
  #`$db_conn $db_opt "TRUNCATE TABLE powerapp_udr_log"`
  cd /mnt/paywall_dmp
  for i in `ls *.gz`
  do
    logger "Decompressing file $i"
    gzip -v9 -d $i
  done

  
}

load_exp_prev() {
   cd /mnt/paywall_dmp
   logger "PULL data process from paywall started"
   /home/mysql/scripts/expect/exp.paywall_getter.exp  $var_usr $var_chk2 $var_date
   load_dmp_prev

}

reproc_dmp() {
  cd $var_dmp/udr/
  for i in `ls $1`
  do
    bzip2 -d $1
  done
}

cd $var_dmp/paywall
load_exp_prev
#find $var_dmp/paywall -name  'SANDVINE*.udr' -exec  sh /home/mysql/scripts/udr_loader.sh_btrck {} \;

#sleep 2
#cd /home/mysql/dmp/paywall


#for abc in `ls *.bz2`
#do
#
#  if [ -s "$abc" ] ; then
#   logger "WARNING: Error on UDR bz2 file"  >> $var_log/$var_cur.sftp.log
#   ls $abc >> $var_log/sftp.log
#   logger "Reprocessing $abc now" >> $var_log/$var_cur.sftp.log
#   /home/mysql/scripts/expect/exp.udr_logs_reprocess.exp $var_usr $var_pn $abc
#   reproc_dmp $abc
#  else
#   logger "Done with Loading UDR" >> $var_log/$var_cur.sftp.log
#   
#  fi

#done
#find $var_dmp/paywall -name 'SANDVINE*.udr' -exec sh /home/mysql/scripts/udr_reprocess.sh_backtrack {} \;

# finally run stored proc
#logger "Running storeproc now" 
#`$db_conn $db_opt  "call sp_generate_udr_usage('$var_backdate')"`
#logger "Done with storeproc"
