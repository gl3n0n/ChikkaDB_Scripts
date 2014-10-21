#!/bin/bash

. /etc/profile
. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server

var_date=`date +%Y_%m_%d -d '1 day ago'`
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
db_host="172.17.150.54"
db_conn="mysql -ustats -p$var_chk2 -h$db_host -P$db_prt"
db_opt="-N -e"

logger(){
  echo "`date` : $*" >> $var_log/sftp.log
}

load_dmp_prev() {
  cd $var_dmp/udr
  for i in `ls SANDVINE*.bz2`
  do
     bzcat $i | awk -F',' '{printf $4"+"$5"+"$7"+"$8"+"$13"+"$14"+"$17 "\n"}' | awk -F'+' '{printf substr($1,0,10)","substr($1,0,19)","substr($3,0,19)","$5","$6","$7","$8","$9"\n"}' | grep -v NoEnforce > $var_dmp/udr/2$i.txt
     #rm -f $i

    `$db_conn $db_opt "LOAD DATA LOCAL INFILE '$var_dmp/udr/2$i.txt'  IGNORE  INTO TABLE archive_powerapp_flu.powerapp_udr_log  FIELDS TERMINATED by ',' IGNORE 1 LINES (tx_date,start_tm,end_tm,phone,ip_addr,source,service,b_usage)"`

     rm -f $var_dmp/udr/2$i.txt
     rm -f $i
  done
#
#  for a in  `ls 2SANDVINE*.txt`
#  do
#    `$db_conn $db_opt "LOAD DATA LOCAL INFILE '$a'  IGNORE  INTO TABLE archive_powerapp_flu.powerapp_udr_log  FIELDS TERMINATED by ',' IGNORE 1 LINES (tx_date,start_tm,end_tm,phone,ip_addr,source,service,b_usage)"`
#    rm -f $a
#  done
  logger "PULL data process from sandvine ended"

}

load_exp_prev() {
   cd $var_dmp/udr
   logger "PULL data process from sandvine started"
   /home/mysql/scripts/expect/exp.udr_logs_getter.exp  $var_usr $var_pn $var_date
   load_dmp_prev

}

cd $var_dmp/udr
load_exp_prev
`$db_conn $db_opt -e "call  archive_powerapp_flu.sp_generate_udr_usage('$var_date')"`

bzcat SANDVINE_01_2014_06_18_21_02_55.udr.bz2 | awk -F',' '{printf $4 "+"$7"+"$8"+"$13"+"$14"+"$17 "\n"}' | awk -F'+' '{printf substr($1,0,10)" ,"substr($1,1+length($1)-10)", "$3" , "$4" , "$5" , "$6" , "$7 "\n"}' > $var_dmp/udr/2$i


cat pisousage0625.txt | awk -F',' '{printf $4"+"$5"+"$7"+"$8"+"$13"+"$14"+"$17 "\n"}' | awk -F'+' '{printf substr($1,0,10)","substr($1,0,19)","substr($3,0,19)","$5","$6","$7","$8","$9"\n"}' | grep -v NoEnforce > 2clashofclans_0620.txt

cd /usr/local/sandvine/var/spool/logging/target/UDR
bzcat SANDVINE_01_2014_06_29_*.bz2 | bzgrep -i "pisonetservice" | awk -F',' '{printf $4"+"$5"+"$7"+"$8"+"$13"+"$14"+"$17 "\n"}' | awk -F'+' '{printf substr($1,0,10)","substr($1,0,19)","substr($3,0,19)","$5","$6","$7","$8","$9"\n"}' >> /tmp/pisousage_0625_0629.txt

cat voice.txt | grep 2014-07-01 | grep voice_upload | grep recipient | awk -F' ' '{print substr($1,26,10),substr($1,37,8),substr($2,17,7),$5,substr($8,164,12)}'