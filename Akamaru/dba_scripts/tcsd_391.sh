#!/bin/sh
set -e
sub_dateyes=`date '+%Y%m%d' --date='1 day ago'`
dateyest=`date '+%Y-%m-%d' --date='1 day ago'`
dateyest1=`date '+%b %e' --date='1 day ago'`
DayYest=`date +%a '--date=1 day ago'`
dir=/home/dba_scripts/tcsd/
dbb=stats

>$dir/hits.per.tcsd.$dateyest

echo "AC:391v4" >> $dir/hits.per.tcsd.$dateyest
#echo " "  >> $dir/hits.per.tcsd.$dateyest
 echo "STATUS          TCSD    HITS" >> $dir/hits.per.tcsd.$dateyest
 echo "select 'SUCCESS  ', TCSD, hits from tcsd_hits where datesent='$dateyest' " | mysql -ustats -pstats netcast_stats -hford.internal.chikka.com -P3306 -N >> $dir/hits.per.tcsd.$dateyest 
echo "AC:391v4:END" >> $dir/hits.per.tcsd.$dateyest
# echo " " >> $dir/hits.per.tcsd.$dateyest
#t_uniq=`echo "select format(sum(bilang),0) from uniq_messages where datesent='${dateyest}'"| mysql -ustats -pstats netcast_stats -hford.internal.chikka.com -P3306 -N` 
# echo "Total unique recipients for 391:  ${t_uniq}" >> $dir/hits.per.tcsd.$dateyest
# echo "Total unique recipients per operator" >> $dir/hits.per.tcsd.$dateyest
# echo "select operator, format(bilang,0) from uniq_messages where datesent='${dateyest}'"| mysql -ustats -pstats netcast_stats -hford.internal.chikka.com -P3306 -N >> $dir/hits.per.tcsd.$dateyest
# echo " ">> $dir/hits.per.tcsd.$dateyest
# echo "Thanks ">> $dir/hits.per.tcsd.$dateyest
# echo " ">> $dir/hits.per.tcsd.$dateyest
# echo "DBA Team" >> $dir/hits.per.tcsd.$dateyest

#to="jojo@chikka.com"
#cc="jojo@chikka.com"    
to="zcabatuan@chikka.com,caparolma@chikka.com"
cc="dbadmins@chikka.com,ra@chikka.com,cs.watchdog@chikka.com,mzsabino@chikka.com"
cat $dir/hits.per.tcsd.$dateyest |  mutt "$to" -c"$cc" -e"my_hdr From:Netcast Stats<netcast_stats@chikka.com>" -s"$sub_dateyes SMART Hits Per TC/SD" 

