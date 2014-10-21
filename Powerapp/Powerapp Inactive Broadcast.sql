       639188882728
Rica - 639399369648
Victor-639188039134
Bong - 639474296630

SERVER: DB-REPLICA (archive_powerapp_flu)
call sp_generate_inactive_list();

CREATE TABLE powerapp_inactive_list_0628 (
  phone varchar(12) NOT NULL,
  brand varchar(16) DEFAULT NULL,
  bcast_dt date DEFAULT NULL,
  PRIMARY KEY (phone),
  KEY bcast_dt_idx (bcast_dt,phone)
);

insert into powerapp_inactive_list_0628 select phone, brand, null from powerapp_inactive_list;

update powerapp_inactive_list_0628 set  bcast_dt='2014-06-28' where brand= 'TNT' and bcast_dt is null order by rand() limit 400000;
update powerapp_inactive_list_0628 set  bcast_dt='2014-06-28' where brand<>'TNT' and bcast_dt is null order by rand() limit 400000;
update powerapp_inactive_list_0628 set  bcast_dt='2014-06-29' where brand= 'TNT' and bcast_dt is null order by rand() limit 400000;
update powerapp_inactive_list_0628 set  bcast_dt='2014-06-29' where brand<>'TNT' and bcast_dt is null order by rand() limit 400000;
select bcast_dt, count(1) from powerapp_inactive_list_0628 group by 1;

echo "select phone from powerapp_inactive_list_0628 where brand<>'TNT' and bcast_dt='2014-06-28'" |  mysql -uroot -p --socket=/mnt/dbrep3307/mysql.sock --port=3307 archive_powerapp_flu | grep -v phone > smart_06282014.csv
echo "select phone from powerapp_inactive_list_0628 where brand='TNT' and bcast_dt='2014-06-28'"  |  mysql -uroot -p --socket=/mnt/dbrep3307/mysql.sock --port=3307 archive_powerapp_flu | grep -v phone > tnt_06282014.csv
echo "select phone from powerapp_inactive_list_0628 where brand<>'TNT' and bcast_dt='2014-06-29'" |  mysql -uroot -p --socket=/mnt/dbrep3307/mysql.sock --port=3307 archive_powerapp_flu | grep -v phone > smart_06292014.csv
echo "select phone from powerapp_inactive_list_0628 where brand='TNT' and bcast_dt='2014-06-29'"  |  mysql -uroot -p --socket=/mnt/dbrep3307/mysql.sock --port=3307 archive_powerapp_flu | grep -v phone > tnt_06292014.csv


select phone into outfile '/tmp/BUDDY_20140728.csv' fields terminated by ',' lines terminated by '\n' from powerapp_inactive_list_0728 where brand = 'BUDDY';
select phone into outfile '/tmp/TNT_20140728.csv' fields terminated by ',' lines terminated by '\n' from powerapp_inactive_list_0728 where brand = 'TNT';
scp noc@172.17.250.40:/tmp/*_20140728.csv /tmp/.
scp /tmp/*_20140728.csv noc@172.17.250.158:/tmp/.
cd /var/www/html/scripts/5555-powerapp/bcast
mv /tmp/*_20140728.csv .

select count(1) from  powerapp_inactive_list a where brand = 'TNT' 
and not exists (select 1 from tmp_plan_users_0908 b where a.phone=b.phone)
and not exists (select 1 from tmp_plan_users_0909 b where a.phone=b.phone);
select phone into outfile '/tmp/TNT_INACTIVE_20140909.csv' fields terminated by ',' lines terminated by '\n' 
from powerapp_inactive_list a 
where brand = 'TNT' 
and not exists (select 1 from tmp_plan_users_0908 b where a.phone=b.phone)
and not exists (select 1 from tmp_plan_users_0909 b where a.phone=b.phone);
scp noc@172.17.250.40:/tmp/TNT_INACTIVE_20140909.csv /tmp/.
scp /tmp/TNT_INACTIVE_20140909.csv noc@172.17.250.158:/tmp/.
ssh noc@172.17.250.158
vi /tmp/TNT_INACTIVE_20140909.csv
639474296630
639399369648
639188039134
639188882728
639188088585
639189087704
wc -l /tmp/TNT_INACTIVE_20140909.csv 
sort /tmp/TNT_INACTIVE_20140909.csv | uniq | wc -l
cd /var/www/html/scripts/5555-powerapp/bcast
mv /tmp/TNT_INACTIVE_20140909.csv .



select phone into outfile '/tmp/powerapp_mins_20140908.csv' fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' group by phone;

select concat('''/tmp/',lower(plan), '_mins_20140908.csv''') plan, count(distinct phone) from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' group by 1;

select phone into outfile '/tmp/backtoschool_mins_20140908.csv' fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'BACKTOSCHOOL' group by phone;
select phone into outfile '/tmp/chat_mins_20140908.csv'         fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'CHAT' group by phone;
select phone into outfile '/tmp/clashofclans_mins_20140908.csv' fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'CLASHOFCLANS' group by phone;
select phone into outfile '/tmp/email_mins_20140908.csv'        fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'EMAIL' group by phone;
select phone into outfile '/tmp/facebook_mins_20140908.csv'     fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'FACEBOOK' group by phone;
select phone into outfile '/tmp/free_social_mins_20140908.csv'  fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'FREE_SOCIAL' group by phone;
select phone into outfile '/tmp/line_mins_20140908.csv'         fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'LINE' group by phone;
select phone into outfile '/tmp/photo_mins_20140908.csv'        fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'PHOTO' group by phone;
select phone into outfile '/tmp/pisonet_mins_20140908.csv'      fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'PISONET' group by phone;
select phone into outfile '/tmp/snapchat_mins_20140908.csv'     fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'SNAPCHAT' group by phone;
select phone into outfile '/tmp/social_mins_20140908.csv'       fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'SOCIAL' group by phone;
select phone into outfile '/tmp/speedboost_mins_20140908.csv'   fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'SPEEDBOOST' group by phone;
select phone into outfile '/tmp/tumblr_mins_20140908.csv'       fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'TUMBLR' group by phone;
select phone into outfile '/tmp/unli_mins_20140908.csv'         fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'UNLI' group by phone;
select phone into outfile '/tmp/waze_mins_20140908.csv'         fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'WAZE' group by phone;
select phone into outfile '/tmp/wechat_mins_20140908.csv'       fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'WECHAT' group by phone;
select phone into outfile '/tmp/wikipedia_mins_20140908.csv'    fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'WIKIPEDIA' group by phone;
select phone into outfile '/tmp/youtube_mins_20140908.csv'      fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2014-09-08' and datein < '2014-09-09' and plan = 'YOUTUBE' group by phone;

scp noc@172.17.250.40:/tmp/*_20140909.csv /tmp/.


+--------------+---------------------------------------+-----------------------+
| plan         | plan                                  | count(distinct phone) |
+--------------+---------------------------------------+-----------------------+
| BACKTOSCHOOL | '/tmp/backtoschool_mins_20140908.csv' |                   995 |
| CHAT         | '/tmp/chat_mins_20140908.csv'         |                  1744 |
| CLASHOFCLANS | '/tmp/clashofclans_mins_20140908.csv' |                 11270 |
| EMAIL        | '/tmp/email_mins_20140908.csv'        |                   198 |
| FACEBOOK     | '/tmp/facebook_mins_20140908.csv'     |                107448 |
| FREE_SOCIAL  | '/tmp/free_social_mins_20140908.csv'  |                  1572 |
| LINE         | '/tmp/line_mins_20140908.csv'         |                    32 |
| PHOTO        | '/tmp/photo_mins_20140908.csv'        |                   186 |
| PISONET      | '/tmp/pisonet_mins_20140908.csv'      |                  3457 |
| SNAPCHAT     | '/tmp/snapchat_mins_20140908.csv'     |                    14 |
| SOCIAL       | '/tmp/social_mins_20140908.csv'       |                  2320 |
| SPEEDBOOST   | '/tmp/speedboost_mins_20140908.csv'   |                  8221 |
| TUMBLR       | '/tmp/tumblr_mins_20140908.csv'       |                     6 |
| UNLI         | '/tmp/unli_mins_20140908.csv'         |                 11270 |
| WAZE         | '/tmp/waze_mins_20140908.csv'         |                    21 |
| WECHAT       | '/tmp/wechat_mins_20140908.csv'       |                    89 |
| WIKIPEDIA    | '/tmp/wikipedia_mins_20140908.csv'    |                  1501 |
| YOUTUBE      | '/tmp/youtube_mins_20140908.csv'      |                    21 |
+--------------+---------------------------------------+-----------------------+
