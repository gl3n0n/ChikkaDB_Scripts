#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server

var_date=`date +%Y_%m_%d -d '1 day ago'`
proc_date=`date +%Y-%m-%d -d '1 day ago'`
#var_date=`date +%Y_%m_%d`
#proc_date=`date +%Y-%m-%d` 
var_cur=`date +%Y%m%d`
# %k     hour ( 0..23)
var_dir="/home/mysql/vars"
var_log="/home/mysql/log"
var_dmp="/mnt/paywall_dmp/dmp"
var_loc_list="/mnt/paywall_dmp/udr/local_file_log"
var_remote_list="/mnt/paywall_dmp/udr/remote_file_log"
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
   COUNTER=$1
   echo $COUNTER

   until [ $COUNTER -eq 0 ] ; do
       while read line 
       do 
           cd $var_dmp/udr
#          /home/mysql/scripts/expect/exp.udr_logs_getter.exp  $var_usr $var_pn $line q
          /home/mysql/scripts/expect/top_udr_logs_getter.exp  $var_usr $var_pn $line 
          let COUNTER-=1
          logger "Successfully Transferred UDR File: $line" 
       done < $var_remote_list/b_"$var_date"_udr.remote_list
   done
    

}

reproc_dmp() {
  cd $var_dmp/udr/
  for x in `ls $1`
  do
    bzip2 -d $x
  done
}

# CHECKS
   logger "UDR Stats Process Started"
   /home/mysql/scripts/expect/top_udr_log_remote_list $var_usr $var_pn $var_date > $var_remote_list/"$var_date"_udr.remote_list
   RemoteFileCnt=`cat $var_remote_list/"$var_date"_udr.remote_list | grep udr.bz2 | wc -l | awk '{print $1}'`
   #RemoteFileCnt=6
   echo $RemoteFileCnt
   logger "Total number of UDR files to Transfer: $RemoteFileCnt"
   cat $var_remote_list/"$var_date"_udr.remote_list | grep udr.bz2 |  awk '{print $9}' > $var_remote_list/b_"$var_date"_udr.remote_list
   logger "UDR Data Transfer Started"
   load_exp_prev $RemoteFileCnt
   cd /mnt/paywall_dmp/dmp/udr/ 
#   logger "UDR Data Transfer Completed"
   LocalFileCnt=`ls -ltr *.bz2 |  awk '{print $9}' | sed '/^\s*$/d' | wc -l`
   #echo $LocalFileCnt
   logger "Total number of Transferred UDR files: $LocalFileCnt"
   logger "Total number of Remote UDR files: $LocalFileCnt"
#   sort $var_remote_list/b_"$var_date"_udr.remote_list  --output=$var_remote_list/sorted_"$var_date"_udr.remote_list    
#   sort $var_loc_list/"$var_date"_udr_local_list --output=$var_loc_list/sorted_"$var_date"_udr_local_list
#   diff -q --ignore-all-space --ignore-blank-lines $var_remote_list/sorted_"$var_date"_udr.remote_list $var_loc_list/sorted_"$var_date"_udr_local_list > /tmp/remot_local_chk.txt

   if [ $RemoteFileCnt -ne $LocalFileCnt ] ; then
     
      echo "FILE not match"

   else 
      echo "Donwload Complete!"  
      find $var_dmp/udr -name  'SANDVINE*.udr*.bz2' -exec  sh /home/mysql/scripts/toptalker_loader.sh {} \;
   fi     

