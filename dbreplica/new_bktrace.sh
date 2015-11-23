#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server
#
#var_date=`date +%Y_%m_%d -d '20 day ago'`
#proc_date=`date +%Y-%m-%d -d '20 day ago'`
#p_trandate=`date +%Y-%m-%d -d '21 day ago'`
#db_partition_dt=`date +%Y%m%d -d '22 day ago'`

var_date=$1
end_date=$2
var_log="/home/mysql/log"
proc_date=$(echo $var_date | sed 's/_/-/g')
date_format_1="[0-9]{4}_[0-1][0-9]_[0-3][0-9]"
date_format_2="[0-9]{4}-[0-1][0-9]-[0-3][0-9]"

# RUN BACkATE FACEBOOK UDR
#              date_of_table_file to process/starttime    End Date/LAST FILE TO PROCESS
# ./bktrace.sh 2015_05_09                                 2015-05-17
if [[ $# -eq 2 ]] ; then
   if [[ $1 =~ ^$date_format_1$ ]] && [[ $2 =~ ^$date_format_2$ ]] ; then
      ctr=0
      proc_date_h=$(echo "$proc_date" | sed 's/-//g')
      end_date_h=$(echo "$end_date" | sed 's/-//g')
      datedif=$(echo "$end_date_h - $proc_date_h" | bc)
      while [ $ctr -le $datedif ]
      do

        filedate=`date -d "$proc_date $ctr day" +%Y_%m_%d`  
        tab_date=`date -d "$proc_date $ctr day" +%Y-%m-%d`
        cleanup_date=`date -d "$tab_date 1 day ago" +%Y-%m-%d`
        echo $filedate $tab_date $tab_date
        #var_date proc_date p_trandate of bkdate_new_powerapp_udr_log.sh   
#        /home/mysql/scripts/bk_nofb_new_powerapp_udr_log.sh $filedate $tab_date $tab_date > $var_log/$proc_date".reproc_nofb.udr.log" 2>&1 &
         /home/mysql/scripts/bk_permins_new_powerapp_udr_log.sh  $filedate $tab_date $tab_date > $var_log/$proc_date".reproc_permins.udr.log" 2>&1 &
        sleep 110m
        ctr=$(( $ctr + 1 ))

      done
   else
      echo "Wrong Data Format"
   fi 
elif [[ $# -ge 3 ]] ; then
   echo "Error: Input Parameter should not be greater than 3"
else
   echo "Error: Input Parameter should not be less than 3"
fi 
