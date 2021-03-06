#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server

var_date=`date +%Y_%m_%d -d '6 day ago'`
proc_date=`date +%Y-%m-%d -d '6 day ago'`
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
db_opt="-N -e"


logger(){
  echo "`date` : $*" >> $var_log/$var_cur.udr.log
}


# 1 
split_file() {
#split_file 50 $udrproc_log_dir/b_"$var_date"c_udrfile_1 $udrproc_log_dir spl.txt
#             1   2               3                                          4 
#split_file 50 $udrproc_log_dir/ b_"$var_date"c_udrfile_1  "$var_date"_spl.txt

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
    ftp_count=`ls $2/x* | wc -l`
    export ftp_count
}
# 2 
etl_proc() {

    if [ $5 = 1 ] ; then
        logger "UDR Transfer Ongoing"       
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
            "$1"/ftp_"$COUNTER"/sftp.sh >> $2/"$COUNTER"_tx.log 2>&1 &
            ((COUNTER++))
      
        done < $2/$3"_ftp_list"

        proc_check 1 3     
        find $1 -name "SANDVINE*"$3"*" -printf "%f\n" > $2/$3"_udrfile_2"
        logger "UDR Transfer Complete"



    elif [ $5 = 2 ] ; then

         bnum=1
         cnt=0
         cnter=0
         COUNTER=1
         cnt2=1
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
         proc_check 3 1 
         logger "Renaming of UDR Complete"
         logger "Log Reconstruction In Progress" 

         while read line
         do
              cd "$1"/ftp_"$COUNTER"
             echo "cd "$1"/ftp_"$COUNTER"
              for a in \`ls *$var_date*.bz2*\`
              do
                  bzcat \$a | awk -F',' '{printf \$4\"+\"\$7\"+\"\$14\"+\"\$15\"+\"\$16\"+\"\$17\"+\"\$18 \"\\n\"}'  | awk -F'+' '{printf substr(\$1,0,10)\",\"\$3\",\"\$4\",\"\$5\",\"\$8\"\\n\"}' | sed '1d' > \$a-txt
#              done " > $1"/ftp_"$COUNTER"/"$COUNTER"_bzcatp.sh"

              chmod 700 $1"/ftp_"$COUNTER"/"$COUNTER"_bzcatp.sh"
              "$1"/ftp_"$COUNTER"/"$COUNTER"_bzcatp.sh  >> $2/$3_"$COUNTER"_bz.log 2>&1 &
 
             ((COUNTER++))
         done < $2/$3"_ftp_list"
         proc_check 2 3
         logger "Log Reconstrunction Complete"

       logger "UDR compress file removal"
         cleanup_proc $1 $2 $3 $4 3
         proc_check 4 2
         logger "UDR compress file Complte"

         logger "DB Dump in Progress"           

         until [ $cnt2 -eq 21 ] ;
         do
             find $1 -name "*$cnt2-txt" | grep "bz2-$cnt2-txt" | xargs -r -P2  ls > $4/$3_dbload_list.$cnt2
             while read line 
             do
                 echo "\`$db_conn $db_opt \" ALTER TABLE test.udr_$cnt2 disable keys; SET BULK_INSERT_BUFFER_SIZE = 20*1024*1024; LOAD DATA LOCAL INFILE '$line' IGNORE  INTO TABLE test.udr_$cnt2  FIELDS TERMINATED by ',' (tx_date,phone,source,service,b_usage)\"\`" >> $4/$cnt2-$var_date.sql 
             done < $4/$3_dbload_list.$cnt2 
 
             chmod 700  $4/$cnt2-$var_date.sql
             $4/$cnt2-$var_date.sql >> $2/"$var_date"_dbload.log 2>&1 &
             ((cnt2++))
         done

         logger "DB Dump Complete"
    fi

}

cleanup_proc() {
    if [ $5 = 1 ] ; then

       dbcnt=1
       logger "Test DB Cleanup"
       until [ $dbcnt -eq 21 ] ;
       do
          `$db_conn $db_opt "TRUNCATE test.udr_$dbcnt"`
           ((dbcnt++))
       done
             logger "Test DB Complete"

    elif [ $5 = 2 ] ; then 
       dbcnt=1
       logger "Script and Log Cleanup"
       find $2 -name "x*" -type f -exec rm -f {} \;
       find $2 -name "ftp_list" -type f -exec rm -f {} \;
       find $2 -name "spl.txt" -type f -exec rm -f {} \;
       find $3 -name "*.sql"  -type f -exec rm -f {} \;
       find $3 -name "dbload_list"  -type f -exec rm -f {} \;
       find $1 -type d -name "ftp_*" -exec rm -r {} \;
       until [ $dbcnt -eq 21 ] ;
       do
          `$db_conn $db_opt "ALTER TABLE test.udr_$dbcnt ENABLE KEYS"`
          ((dbcnt++))
       done
       logger "Script and Log Cleanup Complete"

     elif [ $5 = 3 ] ; then

       logger "Bzip Cleanup Started"
       find $1  -name "SANDVINE*bz2*" | cut -d"-" -f1,2 | xargs -r -P2 rm -f
       logger "Bzip2 Cleanup Complete"

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
#logger "UDR Stats Process Started"
#logger "Generating List for UDR to download"
#cleanup_proc $var_dmp/udr $udrproc_log_dir $tmpload_scripts_dir $var_date 1  
#cleanup_proc $var_dmp/udr $udrproc_log_dir $tmpload_scripts_dir $var_date 2 
#$expect_dir/$exp_ls $var_usr $var_pn $var_date > $udrproc_log_dir/"$var_date"_udrfile_1 
#UdrDLList=`cat $udrproc_log_dir/"$var_date"_udrfile_1| grep udr.bz2|wc -l | awk '{print $1}'` 
#logger "Total number of UDR files to Transfer: $UdrDLList"

#cat $udrproc_log_dir/"$var_date"_udrfile_1 | grep udr.bz2 |  awk '{print $9}' | sed 's/\/mnt\/sandvine.dock\/sandvine\/target\/UDR\///g' > $udrproc_log_dir/b_"$var_date"_udrfile_1
#
#cat $udrproc_log_dir/"$var_date"_udrfile_1 | grep udr.bz2 |  awk '{print $9}' > $udrproc_log_dir/b_"$var_date"c_udrfile_1

##split_file 50 $udrproc_log_dir/b_"$var_date"c_udrfile_1 $udrproc_log_dir spl.txt
#split_file 50 $udrproc_log_dir/ b_"$var_date"c_udrfile_1  "$var_date"_spl.txt
#etl_proc $var_dmp/udr $udrproc_log_dir $var_date tmpload_scripts_dir 1
#DLudr=`cat $udrproc_log_dir/"$var_date"_udrfile_2 | wc -l`

#find $var_dmp/udr -name "SANDVINE_01_"$var_date"*bz2" -printf "%f\n" > $udrproc_log_dir"/"$var_date"_udrfile_2"
#DLudr=`cat $udrproc_log_dir/"$var_date"_udrfile_2 | wc -l`
#logger "Total number of Transferred UDR files: $DLudr"

sort $udrproc_log_dir/b_"$var_date"_udrfile_1  --output=$udrproc_log_dir/sorted_"$var_date"_udrlist_1
sort $udrproc_log_dir/"$var_date"_udrfile_2 --output=$udrproc_log_dir/sorted_"$var_date"_udrlist_2
#diff -q --ignore-all-space --ignore-blank-lines $udrproc_log_dir/sorted_"$var_date"_udrlist_1 $udrproc_log_dir/sorted_"$var_date"_udrlist_2 > $udrproc_log_dir/"$var_date"_udr_chk.txt
`$db_conn $db_opt "LOAD DATA INFILE '$udrproc_log_dir/b_"$var_date"_udrfile_1' INTO TABLE test.udr_file_1 LINES TERMINATED by '\r\n';LOAD DATA INFILE '$udrproc_log_dir/sorted_"$var_date"_udrlist_2' INTO TABLE test.udr_file_2 FIELDS TERMINATED  BY '\n'"`

# SIMULA DITO
# if [  -s $udrproc_log_dir"/"$var_date"_udr_chk.txt" ] ; then
#    echo "FILE not match"
#    logger "Error: Downloaded Files Does not match with Source" 
# else
    
#    logger "Files Match With Source"
#    find $var_dmp/udr -name "sftp.sh"  -exec rm -f '{}' \;
#    etl_proc $var_dmp/udr $udrproc_log_dir $var_date $tmpload_scripts_dir 2
##    $var_dmp/udr $tmpload_scripts_dir $udrproc_log_dir $udrproc_log_dir 3 2     
##      # FOR TOP TALKERS
##       cd $var_dmp/udr
##      logger "Generating Reports for TopTalkers"
##     find $var_dmp/udr -name  'SANDVINE*.udr*.bz2' -exec sh /home/mysql/scripts/toptalker_loader.sh {} \; 
#
# fi

