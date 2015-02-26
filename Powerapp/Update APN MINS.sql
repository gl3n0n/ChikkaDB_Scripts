scp gmlenon@172.17.250.55:/home/noc/redis_audit/logs_6317/redis6317_2015-02-17*.txt.gz /tmp/.
scp /tmp/redis6317_2015-02-17*.txt.gz gmlenon@172.17.250.40:/tmp/.
ssh gmlenon@172.17.250.40
su -
chown -R mysql.mysql /tmp/redis6317_2015-02-17*.txt.gz
mv /tmp/redis6317_2015-02-17*.txt.gz  /home/mysql/dmp/udr/.
cd ~/scripts/
./pwrapp_apn_mins.sh &



exit