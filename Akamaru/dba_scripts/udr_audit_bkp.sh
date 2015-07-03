#!/bin/bash
. /etc/profile
#. /home/noc/.bash_profile
vFdate=`date '+%Y_%m_%d' -d' 1 days ago'`
vPrevDate=`date '+%y%m%d' -d' 1 days ago'`
vCurrDate=`date '+%y%m%d'`
vFileDate=`date '+%Y%m%d' -d' 1 days ago'`
vDLDate=`date '+%Y-%m-%d'`
vFtpuser=`more /home/noc/scripts/u.txt`
vDump_File_Raw="/tmp/bigbro"
vMailPdevto="afaylona@chikka.com"
vMailDir="/mnt/backup_bin_logs/bigbro_mail_log/"
vMailto="dbadmins@chikka.com"
vMailcc=""


echo $vFdate
# mysql -ustats -pstats archive_powerapp_flu -h172.17.150.54 -P3307 -t -e"SELECT * FROM udr_bk_logs_aud" > /home/dba_scripts/udr_bkp_audit_logs/"$vPrevDate"_udr_audit.log

mysql -ustats -pstats test -h172.17.150.54 -P3307  -e"SELECT count(1) as 'SDE1A UDR File Count' FROM udr_file_mon WHERE udr_file like '%$vFdate%.bz2'" > /home/dba_scripts/udr_bkp_audit_logs/"$vPrevDate"_udr_audit.log


#echo "" | mutt "$vMailto" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"UDR Backup Audit Report - $vFileDate" < /home/dba_scripts/udr_bkp_audit_logs/"$vPrevDate"_udr_audit.log
echo "" | mutt "$vMailto" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"SDE1A UDR File Audit Check - $vFileDate" < /home/dba_scripts/udr_bkp_audit_logs/"$vPrevDate"_udr_audit.log
