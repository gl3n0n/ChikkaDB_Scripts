#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

a=$1
logger(){
  echo "`date` : $*" >> $var_log/$var_cur.pisonet.log
}

load_dmp_() {
  logger "processing file $a"
  cat $a | grep -i "pisonetservice" | awk -F',' '{printf $4"+"$5"+"$7"+"$8"+"$13"+"$14"+"$17 "\n"}' | awk -F'+' '{printf substr($1,0,10)","substr($1,0,19)","substr($3,0,19)","$5","$6","$7","$8","$9"\n"}' | grep -v NoEnforce > $a.txt
  rm -f $a
  logger "loading file $a"
  `$db_conn $db_opt "LOAD DATA LOCAL INFILE '$a.txt'  IGNORE  INTO TABLE archive_powerapp_flu.tmp_pisonet_usage FIELDS TERMINATED by ',' IGNORE 1 LINES (tx_date,start_tm,end_tm,phone,ip_addr,source,service,b_usage)"`
  rm -f $a.txt
}

logger "Started pisonet_loader.sh => $var_date $var_cur $var_dir $var_log $var_dmp"
load_dmp_
logger "Done pisonet_loader.sh"

