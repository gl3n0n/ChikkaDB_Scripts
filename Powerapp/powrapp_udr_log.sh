-bash-4.1$ cat /home/mysql/scripts/powrapp_udr_log.sh
#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server

var_date=`date +%Y_%m_%d -d '1 day ago'`
var_cur=`date +%Y%m%d`
# %k     hour ( 0..23)
var_dir=/home/mysql/vars/
var_log=/home/mysql/log
var_dmp=/home/mysql/dmp

export var_date var_cur var_dir var_log var_dmp

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
  `$db_conn $db_opt "TRUNCATE TABLE powerapp_udr_log"`
  cd $var_dmp/udr/
  for i in `ls *.bz2`
  do
    logger "Decompressing file $i"
    bzip2 -d $i
  done


}

load_exp_prev() {
   cd $var_dmp/udr
   logger "PULL data process from sandvine started"
   /home/mysql/scripts/expect/exp.udr_logs_getter.exp  $var_usr $var_pn $var_date
   load_dmp_prev

}

reproc_dmp() {
  cd $var_dmp/udr/
  for i in `ls $1`
  do
    bzip2 -d $1
  done
}

cd $var_dmp/udr
load_exp_prev
load_dmp_prev
find $var_dmp/udr -name  'SANDVINE*.udr' -exec sh /home/mysql/scripts/udr_loader.sh {} \;

sleep 2
cd /home/mysql/dmp/udr


for abc in `ls *.bz2`
do

  if [ -s "$abc" ] ; then
   logger "WARNING: Error on UDR bz2 file"  >> $var_log/$var_cur.sftp.log
   ls $abc >> $var_log/sftp.log
   logger "Reprocessing $abc now" >> $var_log/$var_cur.sftp.log
   /home/mysql/scripts/expect/exp.udr_logs_reprocess.exp $var_usr $var_pn $abc
   reproc_dmp $abc
  else
   logger "Done with Loading UDR" >> $var_log/$var_cur.sftp.log

  fi

done
find $var_dmp/udr -name 'SANDVINE*.udr' -exec /home/mysql/scripts/udr_reprocess.sh {} \;

# finally run stored proc
logger "Running storeproc now"
`$db_conn $db_opt  "call sp_generate_udr_usage('$var_date')"`
logger "Done with storeproc"

--------------------------------
bzcat SANDVINE_01_2014_07_02_*.bz2 | bzgrep -i "pisonetservice" | awk -F',' '{printf $4"+"$5"+"$7"+"$8"+"$13"+"$14"+"$17 "\n"}' | awk -F'+' '{printf substr($1,0,10)","substr($1,0,19)","substr($3,0,19)","$5","$6","$7","$8","$9"\n"}' >> /tmp/pisousage_0702_0705.txt &
--------------------------------
-bash-4.1$ cat /home/mysql/scripts/expect/exp.udr_logs_getter.exp
#!/usr/bin/expect -f
set arg1 [lindex $argv 0]
set arg2 [lindex $argv 1]
set arg3 [lindex $argv 2]

spawn sftp $arg1@172.17.110.31
expect "Connecting to 172.17.110.31..."
expect " "
expect "*?assword:"
send "$arg2\n"
expect "sftp>" { send -- "cd /usr/local/sandvine/var/spool/logging/target/UDR/\r" }
sleep 1
expect "sftp>" { send -- "mget SANDVINE_*_$arg3*\r" }
expect "sftp>"
sleep 1
expect "sftp>"
send "bye\r"


--------------------------------
-bash-4.1$ cat /home/mysql/scripts/udr_loader.sh
#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server
a=$1
# %k     hour ( 0..23)

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

load_dmp_() {
  echo $a
  logger "Processing file $a"
  cat $a | awk -F',' '{printf $4"+"$5"+"$7"+"$8"+"$13"+"$14"+"$17 "\n"}' | awk -F'+' '{printf substr($1,0,10)","substr($1,0,19)","substr($3,0,19)","$5","$6","$7","$8","$9"\n"}' | grep -v NoEnforce > $a.txt
  rm -f $a
  logger "Loading file $a"
  `$db_conn $db_opt "LOAD DATA LOCAL INFILE '$a.txt'  IGNORE  INTO TABLE archive_powerapp_flu.powerapp_udr_log  FIELDS TERMINATED by ',' IGNORE 1 LINES (tx_date,start_tm,end_tm,phone,ip_addr,source,service,b_usage)"`
  rm -f $a.txt
}

logger "Started udr_loader.sh => $var_date $var_cur $var_dir $var_log $var_dmp"
load_dmp_
logger "Done udr_loader.sh"


--------------------------------
#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server
a=$1
# %k     hour ( 0..23)
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

load_dmp_() {
  echo $a
  logger "Reprocessing file $a"
  cat $a | awk -F',' '{printf $4"+"$5"+"$7"+"$8"+"$13"+"$14"+"$17 "\n"}' | awk -F'+' '{printf substr($1,0,10)","substr($1,0,19)","substr($3,0,19)","$5","$6","$7","$8","$9"\n"}' | grep -v NoEnforce > $a.txt
  rm -f $a
  logger "Loading file $a"
  `$db_conn $db_opt "LOAD DATA LOCAL INFILE '$a.txt'  IGNORE  INTO TABLE archive_powerapp_flu.powerapp_udr_log  FIELDS TERMINATED by ',' IGNORE 1 LINES (tx_date,start_tm,end_tm,phone,ip_addr,source,service,b_usage)"`
  rm -f $a.txt
}

logger "Started udr_reprocess.sh => $var_date $var_cur $var_dir $var_log $var_dmp"
load_dmp_
logger "Done udr_reprocess.sh"


