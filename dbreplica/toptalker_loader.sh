#!/bi   n/bash

. /etc/profile
#. /home/mysql/.bash_profile

# CREATED BY ALLAN FAYLONA 2014-02-06
# PULL DATA LOGS FROM application server
a=$1
# %k     hour ( 0..23)
var_date=`date +%Y-%m-%d -d '1 day ago'`
#var_cur=`date +%Y%m%d`
# %k     hour ( 0..23)
var_dir=/home/mysql/vars/
var_log=/home/mysql/log
var_dmp=/mnt/paywall_dmp/dmp/udr

var_usr=`head -1 $var_dir/usr.list`
var_pn=`head -1  $var_dir/pn.list`
var_chk=`tail -1  $var_dir/pn.list`
var_chk2=`tail -2  $var_dir/pn.list | head -1 `
#db_prt=3307
#db_host="127.0.0.1"
db_conn="mysql -ustats -p$var_chk2 archive_powerapp_flu -S/mnt/dbrep3307/mysql.sock"
db_opt="-N -e"

logger(){
  echo "`date` : $*" >> $var_log/$var_cur.udr.log
}

load_dmp_() {

#/mnt/paywall_dmp/dmp/udr/bkp
     echo "Processing TopTalkers Started for $a" >> $var_log/$var_cur.sftp.log
     echo " SET session group_concat_max_len=500000; SELECT CONCAT(\"for a in  \`ls *.bz2\` ;  do  bzcat \$a | awk -F',' '\{printf \\\$4\"\"+\"\"\\\$5\"\"+\"\"\\\$7\"\"+\"\"\\\$8\"\"+\"\"\\\$14\"\"+\"\"\\\$15\"\"+\"\"\\\$18\"\"+\"\"\\\$11 \"\"\\\n\"\"\\}'  | awk -F'+' '\{printf substr(\\\$1,0,10)\"\",\"\"substr(\\\$1,0,19)\"\",\"\"substr(\\\$3,0,19)\"\",\"\"\\\$5\"\",\"\"\\\$6\"\",\"\"\\\$7\"\",\"\"\\\$8\"\",\"\"\\\$9\"\",\"\"\\\$10\"\"\\\n\"\"\\}'  | grep -w \"\"\" ,GROUP_CONCAT(phone separator '\\\|'),\"\"\" > $var_dmp/\$a.txt ; \`mv \$a /mnt/paywall_dmp/dmp/udr/bkp/\` ; done \") FROM powerapp_nds_toptalker WHERE tx_date='"$var_date"'  INTO OUTFILE '/home/mysql/scripts/tmp_scripts/"$var_date".talker.sh'  LINES TERMINATED BY '\n';" | mysql -ustats -p$var_chk2 archive_powerapp_flu -S/mnt/dbrep3307/mysql.sock

     cat /home/mysql/scripts/tmp_scripts/"$var_date".talker.sh |  sed 's/\\\\/\\/g' > /home/mysql/scripts/tmp_scripts/x_"$var_date".talker.sh
     chmod 700 /home/mysql/scripts/tmp_scripts/x_"$var_date".talker.sh

     cd $var_dmp
     rm -f /home/mysql/scripts/tmp_scripts/"$var_date".talker.sh
     /home/mysql/scripts/tmp_scripts/x_"$var_date".talker.sh

     echo "Processing TopTalkers Completed for $a" >> $var_log/$var_cur.sftp.log
     echo "Data Loading TopTalkers Started for $a" >> $var_log/$var_cur.sftp.log
     cd $var_dmp
     
     for abc in `ls *.txt`
     do 
     `$db_conn $db_opt "LOAD DATA LOCAL INFILE '$abc'  IGNORE  INTO TABLE archive_powerapp_flu.powerapp_udr_log  FIELDS TERMINATED by ',' IGNORE 1 LINES (tx_date,start_tm,end_tm,phone,ip_addr,source,service,b_usage,device) SET gen_date='$var_date'"` 
     rm -f $abc
     done
     
     rm -f /mnt/paywall_dmp/dmp/udr/bkp/*.bz2

}

load_dmp_

