#!/bin/sh
dateyest=`date '+%Y-%m-%d' --date='1 day ago'`
dateyest1=`date '+%b %e' --date='1 day ago'`
dir=/tmp
dbb=stats

>$dir/powerapp_liberation.tmp

echo "Powerapp Liberation Stats for $dateyest" >> $dir/powerapp_liberation.tmp
echo " " >> $dir/powerapp_liberation.tmp
#t_uniq=`echo "select count(distinct phone) hits from powerapp_flu.powerapp_log where datein>='$dateyest' and datein < date_add('$dateyest', interval 1 day) and brand='TNT' and plan='MYVOLUME'"| mysql -ustats -pstats powerapp_flu -h10.11.4.164 -P3309 -N`
t_tota=`echo "select count(1) hits from powerapp_flu.powerapp_log where datein>='$dateyest' and datein < date_add('$dateyest', interval 1 day) and brand='TNT' and plan='MYVOLUME'"| mysql -ustats -pstats powerapp_flu -h10.11.4.164 -P3309 -N`
#echo "Total Unique :  ${t_uniq}" >> $dir/powerapp_liberation.tmp
echo "Total Hits   :  ${t_tota}" >> $dir/powerapp_liberation.tmp
echo " ">> $dir/powerapp_liberation.tmp
echo " ">> $dir/powerapp_liberation.tmp
echo " ">> $dir/powerapp_liberation.tmp
echo "Regards, ">> $dir/powerapp_liberation.tmp
echo " ">> $dir/powerapp_liberation.tmp
echo "CHIKKA DBA Team" >> $dir/powerapp_liberation.tmp

to="jomai@chikka.com"
cc="glenon@chikka.com"
cat $dir/powerapp_liberation.tmp |  mutt "$to" -c"$cc" -e"my_hdr From:Powerapp Stats<powerapp_stats@chikka.com>" -s"Powerapp Liberation Stats, $dateyest1"


