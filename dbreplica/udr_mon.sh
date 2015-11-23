#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server
var_date=`date '+%Y_%m_%d_%H:%M:%S'`
retention_date=`date +%Y-%m-%d -d '3 day ago'`
p_trandate=`date +%Y-%m-%d`
#db_partition_dt=`date +%Y%m%d -d '5 day ago'`
#db_partition_dt=`date +%Y%m%d -d '6 day ago'`
db_partition_dt=`date +%Y%m%d -d '3 day ago'`
var_cur=`date +%Y%m%d`
# %k     hour ( 0..23)
var_dir="/home/mysql/vars"
var_log="/home/mysql/log"
var_dmp="/mnt/paywall_dmp/dmp"
script_dir="/home/mysql/scripts"
udrproc_log_dir="/mnt/paywall_dmp/udr/logs"
expect_dir="/home/mysql/scripts/expect"
exp_ftp="new.udr_logs_allgetter.exp"
exp_ls="udrdl_list.exp"
tmpload_scripts_dir="/mnt/paywall_dmp/udr/udr_load_scripts"
export var_date var_cur var_dir var_log var_dmp retention_date udrproc_log_dir
var_time=`date +%T`
var_usr=`head -1 $var_dir/usr.list`
var_pn=`head -1  $var_dir/pn.list`
var_chk=`tail -1  $var_dir/pn.list`
var_chk2=`tail -2  $var_dir/pn.list | head -1 `
db_prt=3307
db_host="127.0.0.1"
db_conn="mysql -ustats -pstats test -h$db_host -P$db_prt"
db_conn2="mysql -ustats -pstats archive_powerapp_flu  -h$db_host -P$db_prt"
db_opt="-N -e"
rem_udr_path="/mnt/sandvine.dock/sandvine/target/UDR/"


logger(){
  echo "`date` : $*" >> $var_log/$var_cur.udr.mon.log
}
udr_mon_proc(){
   cat $udrproc_log_dir/udr_mon/udr_log_mon.$p_trandate.txt  | grep "SANDVINE" | awk '{print $5,$9}' | sed 's/ /,/g' > $udrproc_log_dir/udr_mon/udr_mon_dmp.sql
   $db_conn $db_opt"LOAD DATA INFILE '$udrproc_log_dir/udr_mon/udr_mon_dmp.sql' IGNORE INTO TABLE udr_file_mon FIELDS TERMINATED by ','(udr_file_size,udr_file)SET datein='$p_trandate'; DELETE FROM udr_file_mon WHERE datein='$retention_date' " 
}
ssh -q chikka@172.17.110.31 "ls -l /var/sandvine/logging/target/UDR/" > $udrproc_log_dir/udr_mon/udr_log_mon.$p_trandate.txt

   if [ -s $udrproc_log_dir/udr_mon/udr_log_mon.$p_trandate.txt ] ; then
      rm -f $udrproc_log_dir/udr_mon/udr_log_mon.$retention_date.txt
      udr_mon_proc 
   else
       logger "No udr files to process"
   fi
