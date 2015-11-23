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
var_chk2=`tail -3  $var_dir/pn.list | head -1 `
db_prt=3307
db_host="127.0.0.1"
db_conn="mysql -ustats -p$var_chk2 archive_powerapp_flu -h$db_host -P$db_prt"
db_opt="-N -e"

logger(){
  echo "`date` : $*" >> $var_log/$var_cur.nds.sftp.log
}

load_dmp_prev() {
  `$db_conn $db_opt "TRUNCATE TABLE powerapp_nds_log"`
  cd $var_dmp/nds/
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
  # /home/mysql/scripts/expect/exp.nds_logs_getter.exp.20141111.exp  $var_usr $var_pn $var_date

   until [ $COUNTER -eq 0 ] ; do
       while read line 
       do 
          # cd $var_dmp/nds
          /home/mysql/scripts/expect/exp.nds_logs_getter.exp  $var_usr $var_pn $line 
          let COUNTER-=1
          logger "Successfully Transferred NDS File: $line" 
       done < $var_remote_list/b_"$var_date"_nds.remote_list
   done
    

}

reproc_dmp() {
  cd $var_dmp/nds/
  for x in `ls $1`
  do
    bzip2 -d $x
  done
}

load_db_dmp_() {
  cd $var_dmp_in
   file_cnt=`wc -l $var_dmp_in/$1.csv | awk '{print $1}'`
  logger "File name and count: $a.txt : $file_cnt"
  flcnt=`echo $a.txt | sed 's/\/mnt\/paywall_dmp\/dmp\/nds\///g'`
  flcnt2=`echo $var_dmp_in/$1.csv | sed 's/\/mnt\/paywall_dmp\/dmp\/udr\///g' | cut -d '/' -f 6 | sed 's/.csv//g'`
  `$db_conn $db_opt "TRUNCATE TABLE powerapp_nds_log"`
  logger "TRUNCATE completed"
  `$db_conn $db_opt "SET BULK_INSERT_BUFFER_SIZE = 20*1024*1024; LOAD DATA LOCAL INFILE '$var_dmp_in/$1.csv'  IGNORE  INTO TABLE archive_powerapp_flu.powerapp_nds_log FIELDS TERMINATED by ',' (phone,service,transmit,received) SET tx_date='$1'"`
  logger "LOAD DATA completed"
  `$db_conn $db_opt "call sp_generate_toptalker ('$1')"`
  logger "Stored routine sp_generate_toptalker completed"
}

  logger "NDS Stats Process Started"
  /home/mysql/scripts/expect/exp.nds_log_remote_list $var_usr $var_pn $var_date > $var_remote_list/"$var_date"_nds.remote_list
  RemoteFileCnt=`cat $var_remote_list/"$var_date"_nds.remote_list | grep "$var_date".csv | grep -v sftp |wc -l | awk '{print $1"    '$var_date'"}' |  sed '/^\s*$/d' ` # > /home/mysql/scripts/remote_files_dlList.txt
  logger "Total number of NDS files to Transfer: $RemoteFileCnt"
  cat $var_remote_list/"$var_date"_nds.remote_list | grep "$var_date".csv |  awk '{print $9}' | sed '/^\s*$/d' > $var_remote_list/b_"$var_date"_nds.remote_list
  logger "NDS Data Transfer Started"
  load_exp_prev $RemoteFileCnt
  cd /mnt/paywall_dmp/dmp/nds/in
  logger "NDS Data Transfer Completed"
  ls -ltr "$var_date".csv |  awk '{print $9}' | sed '/^\s*$/d' >  $var_loc_list/"$var_date"_nds_local_list
  LocalFileCnt=`cat $var_loc_list/"$var_date"_nds_local_list | wc -l`
  logger "Total number of Transferred NDS files: $LocalFileCnt"
  sort $var_remote_list/b_"$var_date"_nds.remote_list  --output=$var_remote_list/sorted_"$var_date"_nds.remote_list    
  sort $var_loc_list/"$var_date"_nds_local_list --output=$var_loc_list/sorted_"$var_date"_nds_local_list
  diff -q --ignore-all-space --ignore-blank-lines $var_remote_list/sorted_"$var_date"_nds.remote_list $var_loc_list/sorted_"$var_date"_nds_local_list > /tmp/remot_nds_local_chk.txt

  if [  -s "/tmp/remot_nds_local_chk.txt" ] ; then
        echo "FILE not match"
        logger "Error: Downloaded Files Does not match with Source" 
#        load_db_dmp_ $var_date
#        gzip -v9 $var_dmp_in/"$var_date".csv
#        mv $var_dmp_in/"$var_date".csv.gz  $var_dmp_out

        
  else
        echo "Match"
        logger "NDS import started:  $var_dmp_in/'$var_date'.csv"
        load_db_dmp_ $var_date
        logger "NDS import Completed: $var_dmp_in/'$var_date'.csv"
        gzip -v9 $var_dmp_in/"$var_date".csv 
        mv $var_dmp_in/"$var_date".csv.gz  $var_dmp_out
     

  fi

