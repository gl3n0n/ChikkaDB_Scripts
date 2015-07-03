echo "call sp_generate_inactive_list(); select phone from powerapp_inactive_list;" mysql -ustats -p powerapp_flu -h10.11.4.164 -P3307 | grep -v phone > '/tmp/inactive_list.txt'
mutt jojo@chikka.com,glenon@gmail.com -s"test mail with attachement" -a inactive_list.txt.gz
