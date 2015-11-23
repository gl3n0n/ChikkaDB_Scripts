#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server

var_date=`date +%Y_%m_%d -d '2 day ago'`
#var_date=`date +%Y%m%d -d '2 day ago'`
var_exp=`date +%Y%m%d -d '15 day ago'`

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
  cd $var_dmp/udr/
  for i in `ls *.bz2`
  do
    bzip2 -d $i
  done
  #find $var_dmp/udr -name  'SANDVINE*.bz2' -exec sh /home/mysql/scripts/b.sh {} \; 

}

load_exp_prev() {
   cd $var_dmp/udr
   logger "PULL data process from sandvine started"
   /home/mysql/scripts/expect/exp.udr_logs_getter.exp  $var_usr $var_pn $var_date
   load_dmp_prev

}

cd $var_dmp/udr
load_exp_prev
#load_dmp_prev
find $var_dmp/udr -name  'SANDVINE*.udr' -exec sh /home/mysql/scripts/b.sh {} \;
#`$db_conn $db_opt  "call sp_generate_udr_usage('$var_date')"`

