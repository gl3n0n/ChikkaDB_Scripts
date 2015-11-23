#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server

var_date=`date +%Y-%m-%d -d '1 day ago'`
proc_date=`date +%Y-%m-%d -d '1 day ago'`
#var_date=`date +%Y_%m_%d`
#proc_date=`date +%Y-%m-%d` 
var_cur=`date +%Y%m%d`
# %k     hour ( 0..23)
var_dir="/home/mysql/vars"
var_log="/home/mysql/log"
var_dmp="/mnt/paywall_dmp/dmp/nds"
var_loc_list="/mnt/paywall_dmp/nds/local_file_log"
var_remote_list="/mnt/paywall_dmp/nds/remote_file_log"
var_dmp_in="/mnt/paywall_dmp/dmp/nds/in"
var_dmp_out="/mnt/paywall_dmp/dmp/nds/out"
export var_date var_cur var_dir var_log var_dmp proc_date

var_usr=`head -1 $var_dir/nds.lst`
var_pn=`head -1  $var_dir/nds.pn.list`
var_chk=`tail -1  $var_dir/pn.list`
var_chk2=`tail -2  $var_dir/pn.list | head -1 `
db_prt=3307
db_host="127.0.0.1"
db_conn="mysql -ustats -p$var_chk2 archive_powerapp_flu -h$db_host -P$db_prt"
db_opt="-N -e"

logger(){
  echo "`date` : $*" >> $var_log/$var_cur.nds_check.sftp.log
}

load_dmp_prev() {
  #`$db_conn $db_opt "TRUNCATE TABLE powerapp_nds_check_log"`
  cd $var_dmp/nds_check/
  for i in `ls *.bz2`
  do
    logger "Decompressing file $i"
    bzip2 -d $i
  done

  
}

load_exp_prev() {
   cd $var_dmp_in
   COUNTER=$1
   echo $COUNTER
#   logger "PULL data process from sandvine started"
  # /home/mysql/scripts/expect/exp.nds_check_logs_getter.exp.20141111.exp  $var_usr $var_pn $var_date

   until [ $COUNTER -eq 0 ] ; do
       while read line 
       do 
          # cd $var_dmp/nds_check
          /home/mysql/scripts/expect/exp.nds_check_logs_getter.exp  $var_usr $var_pn $line 
          let COUNTER-=1
          logger "Successfully Transferred NDS File: $line" 
       done < $var_remote_list/b_"$var_date"_nds_check.remote_list
   done
    

}

reproc_dmp() {
  cd $var_dmp/nds_check/
  for x in `ls $1`
  do
    bzip2 -d $x
  done
}


  logger "NDS Stats Process Started"
  /home/mysql/scripts/expect/exp.nds_log_remote_list $var_usr $var_pn $var_date > $var_remote_list/"$var_date"_nds_check.remote_list
  logger "NDS Data Transfer Started"
