#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server

var_date=`date +%Y_%m_%d -d '7 day ago'`
proc_date=`date +%Y-%m-%d -d '7 day ago'`
p_trandate=`date +%Y-%m-%d -d '8 day ago'`
#var_date=`date +%Y_%m_%d`
#proc_date=`date +%Y-%m-%d` 
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
export var_date var_cur var_dir var_log var_dmp proc_date udrproc_log_dir
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
  echo "`date` : $*" >> $var_log/$var_cur.udr.log
}


# 1 
split_file() {

  cd $2    
  split -l $1 $2/$3
  ls $2/x* |  awk '{print $1}' | sed '/^\s*$/d' > $2/$4
  bnum=1
  cnt=0
  cnter=0

  while read line
  do
     mv $line $line"."$bnum
     ((bnum ++))
  done <  $2/$4

}
# 2 
etl_proc() {

  if [ $5 = 1 ] ; then
     
       if [ $6 = 1 ] ; then
 
          logger "UDR Download Started"
           cd $2
           ls $2/x* | awk '{print $1}' | sed '/^\s*$/d' > $2/$3"_ftp_list"
           COUNTER=1
           while read line
           do
    #          cd "$1"/ftp_"$COUNTER"
               if [ ! -d "$1"/ftp_"$COUNTER" ] ; then
               mkdir "$1"/ftp_"$COUNTER"
               fi

            while read line
            do
                echo " cd "$1"/ftp_"$COUNTER"
                $expect_dir/$exp_ftp $var_usr $var_pn $line " >> "$1"/ftp_"$COUNTER"/sftp.sh
            done < $line

            chmod 700 "$1"/ftp_"$COUNTER"/sftp.sh
            $1"/ftp_"$COUNTER/sftp.sh >> $2"/"$COUNTER"_tx.log" 2>&1 &
            ((COUNTER++))

            done < $2/$3"_ftp_list"
            sleep 7m
            proc_check 1 3
            find $1 -name "SANDVINE*"$3"*" -printf "%f\n" > $2/$3"_udrfile_2"
            logger "UDR Download Complete"

       else

            logger "Downloding Missing UDR files"
            cd $1
            while read line
            do
                $expect_dir/$exp_ftp $var_usr $var_pn $line
            done < $udrproc_log_dir/"$var_date"_udr_reprocess.txt
            sleep 2m
            find $var_dmp/udr -name "SANDVINE*"$3"*" -printf "%f\n" > $2/$3"_udrfile_2" 
            logger "UDR Download is sync with the source"
            

       fi 

  elif [ $5 = 2 ] ; then

       bnum=1
       cnt=0
       cnter=0
       COUNTER=1
       cnt2=1
       find $1 -name "SANDVINE*.bz2" | xargs -r ls   >  $2"/"$3"_mvList"
       
       if [ -s "$2"/"$3"_mvList"" ]  ; then

         logger "Renaming of UDR Ongoing"
          while read line
          do
              ((cnt++))
              mv $line $line"-"$cnt
              ((cnter++))
              if ((cnt ==20)) ; then
                  cnt=0
              fi
          done < $2"/"$3"_mvList"
          sleep 1m
          proc_check 3 1
          logger "Renaming of UDR Complete"
          logger "Log Reconstruction In Progress"


      else
     
          find $1 -name "SANDVINE*.bz2" | xargs -r ls   >  $2"/"$3"_mvList"
          logger "Renaming of UDR Ongoing"
          while read line
          do
              ((cnt++))
              mv $line $line"-"$cnt
               ((cnter++))

               if ((cnt ==20)) ; then
                  cnt=0
               fi

           done < $2"/"$3"_mvList"
           sleep 1m
           proc_check 3 1
           logger "Renaming of UDR Complete"
           logger "Log Reconstruction In Progress"
       fi 
         
       while read line
       do
           cd "$1"/ftp_"$COUNTER"
           echo "cd "$1"/ftp_"$COUNTER"
           for a in \`ls *$var_date*.bz2*\`
           do
           bzcat \$a | awk -F',' '{printf \$4\"+\"\$7\"+\"\$14\"+\"\$15\"+\"\$16\"+\"\$17\"+\"\$18 \"\\n\"}'  | awk -F'+' '{printf substr(\$1,0,10)\",\"\$3\",\"\$4\",\"\$5\",\"\$8\"\\n\"}' | sed '1d' > \$a-txt
           done " > $1"/ftp_"$COUNTER"/"$COUNTER"_bzcatp.sh"
           chmod 700 $1"/ftp_"$COUNTER"/"$COUNTER"_bzcatp.sh"
          "$1"/ftp_"$COUNTER"/"$COUNTER"_bzcatp.sh > $2/$3_"$COUNTER"_bz.log 2>&1 &
           ((COUNTER++))
        done < $2/$3"_ftp_list"
        sleep 37m
        proc_check 2 3
        logger "Log Reconstrunction Complete"
         cleanup_proc $var_dmp/udr $udrproc_log_dir $tmpload_scripts_dir $var_date 3 1 # REMOVE IF MISSING FILES 2015-03-05
         until [ $cnt2 -eq 21 ] ;
         do
#             find $1 -name "*$cnt2-txt" | grep "bz2-$cnt2-txt" | xargs -r -P2  ls > $4/$3_dbload_list.$cnt2
 #find /mnt/paywall_dmp/dmp/udr -name "*bz2-1-txt" -type f | xargs -r ls  | wc -l
             find $1 -name "*$3*bz2-$cnt2-txt" | grep "bz2-$cnt2-txt" | xargs -r -P2  ls > $4/$3_dbload_list.$cnt2
             while read line 
             do
                 echo "\`$db_conn $db_opt \" INSERT INTO test.loaded_udr_files VALUES('$line'); SET BULK_INSERT_BUFFER_SIZE = 20*1024*1024; LOAD DATA LOCAL INFILE '$line' IGNORE  INTO TABLE test.udr_$cnt2  FIELDS TERMINATED by ',' (tx_date,phone,source,service,b_usage)\"\`" >> $4/$cnt2-$var_date.sql 
             done < $4/$3_dbload_list.$cnt2 
 
             chmod 700  $4/$cnt2-$var_date.sql
             $4/$cnt2-$var_date.sql >> $2/"$var_date"_dbload.log 2>&1 &
             ((cnt2++))
         done
         sleep 20m
         logger "DB Dump Complete"
    fi

}

cleanup_proc() {
    if [ $5 = 1 ] ; then

       dbcnt=1
       logger "Test DB Cleanup"
       until [ $dbcnt -eq 21 ] ;
       do
          `$db_conn $db_opt "TRUNCATE test.udr_$dbcnt; truncate table test.udr_file_1;truncate table test.udr_file_2;"`
           ((dbcnt++))
       done
             logger "Test DB Complete"

    elif [ $5 = 2 ] ; then 
       dbcnt=1
       logger "Script and Log Cleanup"
       
       find $2 -name "x*" -type f -exec rm {} \;
       find $2 -name "*ftp_list" -type f -exec rm -f {} \;
       find $2 -name "*spl.txt" -type f -exec rm -f {} \;
       find $3 -name "*.sql"  -type f -exec rm -f {} \;
       find $3 -name "*dbload_list*"  -type f -exec rm {} \;
       find $2 -name "*$var_date*" -type f  -exec rm -f {} \;
#       rm -f $var_dmp/udr/4_reprocess/*
       find $1 -type d -name "ftp_*" -exec rm -r {} \;


    elif [ $5 = 3 ] ; then

         logger "Bzip Cleanup Started"
         find $1  -name "SANDVINE*bz2*" | cut -d"-" -f1,2 | xargs -r rm -f # xargs -r -P2 ls >> /tmp/ajz.tzt
         logger "Bzip2 Cleanup Complete"
#        find $1 -name "*$cnt2-txt" | grep "bz2-$cnt2-txt" | xargs -r -P2  ls > $4/$3_dbload_list.$cnt2

    elif [ $5 = 4 ] ; then
           cnt2=0
          if [ $6 =  1 ]  ; then 
               until [ $cnt2 -eq 21 ] ;
              do
                 echo "\`$db_conn $db_opt \" ALTER TABLE test.udr_$cnt2 disable keys;)\"\`" >> $3/$cnt2-$4.enablekey.sql
                 chmod 700   $3/$cnt2-$4.enablekey.sql
                 $3/$cnt2-$4.enablekey.sql >> $2/"$var_date"_dbenable.log 2>&1 &
                 ((cnt2++))
              done
          else
              until [ $cnt2 -eq 21 ] ;
              do
                 echo "\`$db_conn $db_opt \" ALTER TABLE test.udr_$cnt2 enable keys;)\"\`" >> $3/$cnt2-$4.enablekey.sql
                 chmod 700   $3/$cnt2-$4.enablekey.sql
                 $3/$cnt2-$4.enablekey.sql >> $2/"$var_date"_dbenable.log 2>&1 &
                 ((cnt2++))
              done
           fi

    fi 

}


proc_check() {

    if [ $1 = 1 ]; then
       count_ps=`ps aux| grep "sftp dbadmin@172.17.250.62"  | grep -v ? | grep -v S+ |  wc -l`
       until [ $count_ps -eq 0 ] ;
       do
          sleep $2m
          let count_ps-=1
          count_ps=`ps aux| grep "sftp dbadmin@172.17.250.62"| grep -v ? | grep -v S+ | wc -l`
       done

    elif [ $1 = 2 ]; then
         count_ps=`ps aux| grep bzcat | grep -v ? | grep -v S+ |  wc -l`
         until [ $count_ps -eq 0 ] ;
         do
            sleep $2m
            let count_ps-=1
            count_ps=`ps aux| grep bzcat | grep -v ? | grep -v S+ |  wc -l`
            echo $count_ps
         done

    elif [ $1 = 3 ]; then
         count_ps_x=`ps aux| grep mv | grep -v "?" | grep -v S+ |  wc -l`
         until [ $count_ps_x -eq 0 ] ;
         do
            sleep $2m
            let count_ps-=1
            count_ps_x=`ps aux| grep mv | grep -v "?" | grep -v S+ |  wc -l`
            echo $count_ps
         done

    elif [ $1 = 4 ]; then
         count_ps_x=`ps aux| grep rm | grep -v "?" | grep -v S+ |  wc -l`
         until [ $count_ps_x -eq 0 ] ;
         do
            sleep $2m
            let count_ps-=1
            count_ps_x=`ps aux| grep rm | grep -v "?" | grep -v S+ |  wc -l`
            echo $count_ps
         done

  else
        Logger "Invalid Procedure"
  fi 


}
  UdrDLList=0
  DLudr=0
  logger "UDR Stats Process Started"
  logger "Generating List for UDR to download"
  cleanup_proc $var_dmp/udr $udrproc_log_dir $tmpload_scripts_dir $var_date 1  
  cleanup_proc $var_dmp/udr $udrproc_log_dir $tmpload_scripts_dir $var_date 2 
  cleanup_proc $var_dmp/udr $udrproc_log_dir $tmpload_scripts_dir $var_date 4 1
  sleep 3
  $expect_dir/$exp_ls $var_usr $var_pn $var_date > $udrproc_log_dir/"$var_date"_udrfile_1 
  logger "Total number of UDR files to Transfer: $UdrDLList"

  cat $udrproc_log_dir/"$var_date"_udrfile_1 | grep udr.bz2 |  awk '{print $9}' | sed 's/\/mnt\/sandvine.dock\/sandvine\/target\/UDR\///g' > $udrproc_log_dir/b_"$var_date"_udrfile_1
  cat $udrproc_log_dir/"$var_date"_udrfile_1 | grep udr.bz2 |  awk '{print $9}' > $udrproc_log_dir/b_"$var_date"c_udrfile_1

  split_file 50 $udrproc_log_dir/ b_"$var_date"c_udrfile_1  "$var_date"_spl.txt
  etl_proc $var_dmp/udr $udrproc_log_dir $var_date tmpload_scripts_dir 1 1 # DOWNLOAD 1st Try

  find $var_dmp/udr -name "SANDVINE_01_"$var_date"*bz2" -printf "%f\n" > $udrproc_log_dir"/"$var_date"_udrfile_2"
  #DLudr=`cat $udrproc_log_dir/"$var_date"_udrfile_2 | wc -l`
  logger "Total number of Transferred UDR files: $DLudr"

  sort $udrproc_log_dir/b_"$var_date"_udrfile_1  --output=$udrproc_log_dir/sorted_"$var_date"_udrlist_1
  sort $udrproc_log_dir/"$var_date"_udrfile_2 --output=$udrproc_log_dir/sorted_"$var_date"_udrlist_2
  UdrDLList=`more $udrproc_log_dir/sorted_"$var_date"_udrlist_1 | wc -l`
  DLudr=`more $udrproc_log_dir/sorted_"$var_date"_udrlist_2 | wc -l`
  diff -q --ignore-all-space --ignore-blank-lines $udrproc_log_dir/sorted_"$var_date"_udrlist_1 $udrproc_log_dir/sorted_"$var_date"_udrlist_2 > $udrproc_log_dir/"$var_date"_udr_chk.txt
  echo $DLudr $UdrDLList
  if [ "$DLudr" -eq "$UdrDLList" ] ; then
     echo "Pede na"
     etl_proc $var_dmp/udr $udrproc_log_dir $var_date $tmpload_scripts_dir 2 1
     sleep 5m
     cleanup_proc $var_dmp/udr $udrproc_log_dir $tmpload_scripts_dir $var_date 4 2
     sleep 20m
     `$db_conn2 $db_opt "call sp_generate_udr_toptalker('$p_trandate')"` 
  else
  #         if [ ! -s "$udrproc_log_dir/"$var_date"_udr_reprocess.txt" ] ; then
              echo "problems pa din"
              `$db_conn $db_opt "TRUNCATE test.udr_file_1;TRUNCATE  test.udr_file_2;"`

              `$db_conn $db_opt "LOAD DATA INFILE '$udrproc_log_dir/b_"$var_date"_udrfile_1' INTO TABLE test.udr_file_1 LINES TERMINATED by '\r\n';LOAD DATA INFILE '$udrproc_log_dir/sorted_"$var_date"_udrlist_2' INTO TABLE test.udr_file_2 FIELDS TERMINATED  BY '\n';  select CONCAT('$rem_udr_path', a.udr_file) FROM  udr_file_1 a LEFT JOIN udr_file_2 b on a.udr_file=b.udr_file WHERE b.udr_file is NULL INTO OUTFILE '$udrproc_log_dir/"$var_date"_udr_reprocess.txt'"`
               sleep 1
               logger "Downloading Missing UDR Files"
               etl_proc $var_dmp/udr/ftp_1 $udrproc_log_dir $var_date $tmpload_scripts_dir 1 2
               sleep 2m
               etl_proc $var_dmp/udr $udrproc_log_dir $var_date $tmpload_scripts_dir 2 1 
               sleep 5m
               cleanup_proc $var_dmp/udr $udrproc_log_dir $tmpload_scripts_dir $var_date 4 2
               sleep 20m
               rm -f  "$udrproc_log_dir/"$var_date"_udr_reprocess.txt"
               sleep 2m
               `$db_conn2 $db_opt "call sp_generate_udr_toptalker('$p_trandate')"`
               
   #        fi

  fi
