   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;
   SET net_write_timeout=12000;
   SET global connect_timeout=12000;
   SET net_read_timeout=12000;

ssh chikka@172.17.110.32

[chikka@chikka-sde2A sp_target]$ pwd
/var/sandvine/logging/target/d2/logging/sp_target/SP.audit.20141116T*

scp chikka@172.17.110.32:/var/sandvine/logging/target/d2/logging/sp_target/SP.audit.20141116T* /mnt/paywall_dmp/radius/
cd /mnt/paywall_dmp/radius/
find . -name 'SP.audit.20141116T*.cdr.tgz' -exec tar -xzvf '{}' \;
find . -name 'SP.audit.20141116T*.cdr' -print0 | xargs -0  cat |  egrep "(MAP|UNMAP|UPDATE)" | grep "COMPLETE" > /mnt/paywall_dmp/radius/SP_audit.20141116.csv
rm *.cdr
rm *.cdr.tgz
echo "load data local infile '/mnt/paywall_dmp/radius/SP_audit.20141116.csv' into table tmp_radius_log fields terminated by ',' lines terminated by '\n' (r_timestamp, r_id, r_action, @col4, @col5, @col6, @col7, @col8, phone, ip_address, @col11, @col12, @col13, @col14, @col15, map_tz) set map_tz=left(date_add('1970-01-01', interval (r_timestamp/1000) second),10);
" | mysql -uroot -p -S/mnt/dbrep3307/mysql.sock archive_powerapp_flu
gzip /mnt/paywall_dmp/radius/SP_audit.20141116.csv

select map_tz, count(1) from tmp_radius_log group by map_tz;
select left(r_tz,10) r_date, min(r_tz) min_tz, max(r_tz) max_tz, max(tot_cnt) max_cnt from (
select date_add('1970-01-01', interval (r_timestamp/1000) second) r_tz, sum(IF(r_action='MAP',1,0)) map_cnt, sum(IF(r_action='UNMAP',1,0)) umap_cnt, count(1) tot_cnt 
from tmp_radius_log group by 1
) t group by 1 order by 1;

select left(r_tz,10) r_date, r_tz, map_cnt, umap_cnt, tot_cnt from (
select date_add('1970-01-01', interval (r_timestamp/1000) second) r_tz, 
       sum(IF(r_action='MAP',1,0)) map_cnt, 
       sum(IF(r_action='UNMAP',1,0)) umap_cnt, 
       count(1) tot_cnt 
from tmp_radius_log 
where map_tz = '2014-11-11'
group by 1
) t order by r_date, tot_cnt desc limit 5;

echo "insert into tmp_radius_stats
select date_add('1970-01-01', interval (r_timestamp/1000) second) datein, sum(IF(r_action='MAP',1,0)) map_cnt, sum(IF(r_action='UNMAP',1,0)) unmap_cnt, count(1) total_cnt 
from tmp_radius_log group by 1;
" | mysql -uroot -p -S/mnt/dbrep3307/mysql.sock archive_powerapp_flu

update tmp_radius_log set map_tz=left(date_add('1970-01-01', interval (r_timestamp/1000) second),10);

CREATE TEMPORARY TABLE tmp_radius_stats (
  txdate date NOT NULL,
  datein datetime NOT NULL,
  map_cnt int(11) NOT NULL,
  umap_cnt int(11) NOT NULL,
  tot_cnt int(11) NOT NULL,
  KEY datein_idx (datein)
);

delete from tmp_radius_stats;
insert into tmp_radius_stats
select left(date_add('1970-01-01', interval (r_timestamp/1000) second),10) tx_date, date_add('1970-01-01', interval (r_timestamp/1000) second) datein, sum(IF(r_action='MAP',1,0)) map_cnt, sum(IF(r_action='UNMAP',1,0)) unmap_cnt, count(1) total_cnt 
from tmp_radius_log group by 1,2;

select '2014-11-23%' into @trandt;
select max(tot_cnt) into @TotCnt from tmp_radius_stats where datein like @trandt;
select * from tmp_radius_stats where datein like @trandt and tot_cnt = @TotCnt;
select min(datein) min_tm, max(datein) max_tm, max(tot_cnt) max_cnt from tmp_radius_stats where datein like @trandt;

select * from tmp_radius_stats where txdate='2014-11-09' order by tot_cnt desc limit 5;
select * from tmp_radius_stats where txdate='2014-11-10' order by tot_cnt desc limit 5;
select * from tmp_radius_stats where txdate='2014-11-11' order by tot_cnt desc limit 5;
select * from tmp_radius_stats where txdate='2014-11-12' order by tot_cnt desc limit 5;
select * from tmp_radius_stats where txdate='2014-11-13' order by tot_cnt desc limit 5;
select * from tmp_radius_stats where txdate='2014-11-14' order by tot_cnt desc limit 5;
select * from tmp_radius_stats where txdate='2014-11-15' order by tot_cnt desc limit 5;
select * from tmp_radius_stats where txdate='2014-11-16' order by tot_cnt desc limit 5;



+------------+---------------------+---------+----------+---------+
| txdate     | datein              | map_cnt | umap_cnt | tot_cnt |
+------------+---------------------+---------+----------+---------+
| 2014-11-09 | 2014-11-09 16:53:30 |      80 |     8456 |    8536 |
| 2014-11-09 | 2014-11-09 17:16:22 |      16 |     7894 |    7910 |
| 2014-11-09 | 2014-11-09 16:53:47 |     139 |     7214 |    7353 |
| 2014-11-09 | 2014-11-09 17:16:20 |       9 |     7292 |    7301 |
| 2014-11-09 | 2014-11-09 17:16:21 |     100 |     6545 |    6645 |
| 2014-11-10 | 2014-11-10 16:58:06 |      32 |     7116 |    7148 |
| 2014-11-10 | 2014-11-10 16:58:08 |      73 |     6795 |    6868 |
| 2014-11-10 | 2014-11-10 16:58:03 |      20 |     6280 |    6300 |
| 2014-11-10 | 2014-11-10 17:52:43 |     145 |     6069 |    6214 |
| 2014-11-10 | 2014-11-10 16:58:04 |     134 |     5866 |    6000 |
| 2014-11-11 | 2014-11-11 10:05:00 |    1167 |     1105 |    2272 |
| 2014-11-11 | 2014-11-11 09:05:02 |     855 |      836 |    1691 |
| 2014-11-11 | 2014-11-11 07:04:55 |     738 |      794 |    1532 |
| 2014-11-11 | 2014-11-11 10:34:57 |     748 |      774 |    1522 |
| 2014-11-11 | 2014-11-11 02:04:55 |     742 |      751 |    1493 |
| 2014-11-12 | 2014-11-12 18:59:34 |    2151 |     2127 |    4278 |
| 2014-11-12 | 2014-11-12 18:59:33 |    1619 |     1692 |    3311 |
| 2014-11-12 | 2014-11-12 22:25:42 |    1226 |     1572 |    2798 |
| 2014-11-12 | 2014-11-12 18:59:31 |    1329 |     1401 |    2730 |
| 2014-11-12 | 2014-11-12 22:25:38 |     986 |     1659 |    2645 |
| 2014-11-13 | 2014-11-13 17:08:53 |       0 |     7535 |    7535 |
| 2014-11-13 | 2014-11-13 17:08:56 |       0 |     6921 |    6921 |
| 2014-11-13 | 2014-11-13 17:09:28 |       0 |     5982 |    5982 |
| 2014-11-13 | 2014-11-13 17:09:14 |       0 |     5890 |    5890 |
| 2014-11-13 | 2014-11-13 17:08:58 |       0 |     5776 |    5776 |
| 2014-11-14 | 2014-11-14 12:08:25 |    1406 |     1384 |    2790 |
| 2014-11-14 | 2014-11-14 12:19:52 |    1290 |     1339 |    2629 |
| 2014-11-14 | 2014-11-14 04:09:28 |    1239 |     1204 |    2443 |
| 2014-11-14 | 2014-11-14 22:41:27 |    1118 |     1010 |    2128 |
| 2014-11-14 | 2014-11-14 06:12:16 |    1051 |     1042 |    2093 |
| 2014-11-15 | 2014-11-15 12:09:36 |    1547 |     1597 |    3144 |
| 2014-11-15 | 2014-11-15 12:21:55 |    1279 |     1266 |    2545 |
| 2014-11-15 | 2014-11-15 12:11:08 |    1071 |     1036 |    2107 |
| 2014-11-15 | 2014-11-15 22:41:40 |    1021 |      947 |    1968 |
| 2014-11-15 | 2014-11-15 12:14:57 |     955 |      938 |    1893 |
| 2014-11-16 | 2014-11-16 01:11:26 |    1574 |     1568 |    3142 |
| 2014-11-16 | 2014-11-16 10:09:57 |    1119 |     1169 |    2288 |
| 2014-11-16 | 2014-11-16 11:09:55 |    1090 |     1166 |    2256 |
| 2014-11-16 | 2014-11-16 01:51:25 |    1129 |     1117 |    2246 |
| 2014-11-16 | 2014-11-16 12:19:37 |    1023 |     1020 |    2043 |
+------------+---------------------+---------+----------+---------+
5 rows in set (0.07 sec)


+------------+---------------------+---------+----------+---------+
| txdate     | datein              | map_cnt | umap_cnt | tot_cnt |
+------------+---------------------+---------+----------+---------+
| 2014-11-10 | 2014-11-10 16:58:06 |      32 |     7116 |    7148 |
| 2014-11-11 | 2014-11-11 10:05:00 |    1167 |     1105 |    2272 |
| 2014-11-12 | 2014-11-12 18:59:34 |    2151 |     2127 |    4278 |
| 2014-11-13 | 2014-11-13 17:08:53 |       0 |     7535 |    7535 |
| 2014-11-14 | 2014-11-14 12:08:25 |    1406 |     1384 |    2790 |
| 2014-11-15 | 2014-11-15 12:09:36 |    1547 |     1597 |    3144 |
| 2014-11-16 | 2014-11-16 01:11:26 |    1574 |     1568 |    3142 |
+------------+---------------------+---------+----------+---------+


select left(date_add('1970-01-01', interval (r_timestamp/1000) second),10) datein, min(date_add('1970-01-01', interval (r_timestamp/1000) second)) min_tm, 
       max(date_add('1970-01-01', interval (r_timestamp/1000) second)) max_tm, count(1) total from tmp_radius_log group by 1;

create table tmp_radius_log (
 r_timestamp bigint not null,
 r_id int not null,
 r_action varchar(16) not null,
 phone varchar(12) not null,
 ip_address varchar(20),
 key r_action_idx(r_action)
 );
 

CREATE TABLE tmp_radius_mapping (
  r_timestamp bigint(20) NOT NULL,
  r_id int(11) NOT NULL,
  r_action varchar(16) NOT NULL,
  phone varchar(12) NOT NULL,
  ip_address varchar(20),
  map_tz datetime,
  umap_r_timestamp bigint(20),
  umap_tz datetime,
  umap_r_ip_address varchar(20),
  KEY phone_idx (phone,r_timestamp)
);

CREATE TABLE tmp_radius_umapping (
  r_timestamp bigint(20) NOT NULL,
  r_id int(11) NOT NULL,
  r_action varchar(16) NOT NULL,
  phone varchar(12) NOT NULL,
  ip_address varchar(20),
  KEY phone_idx (phone,r_timestamp)
);


insert into tmp_radius_mapping select * from tmp_radius_log where r_action='MAP';
insert into tmp_radius_umapping select * from tmp_radius_log where r_action='UNMAP';

select convert_tz(left(date_add('1970-01-01', interval (r_timestamp/1000) second),10),'+00:00','+08:00') datein, r_timestamp, r_id, r_action, phone,ip_address from tmp_radius_log limit 10;



select left(date_add('1970-01-01', interval (r_timestamp/1000) second),10) datein, count(1) total from tmp_radius_log group by 1;



DROP PROCEDURE sp_map_duration_stat_builder;
delimiter //
CREATE PROCEDURE sp_map_duration_stat_builder()
BEGIN
   DECLARE done,done_s int default 0;
   DECLARE nR_Timestamp bigint(20);
   DECLARE vPhone varchar(12);
   DECLARE vIpAdd varchar(20);
   DECLARE c cursor FOR SELECT r_timestamp, phone FROM tmp_radius_mapping order by phone, r_timestamp;

   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;
   SET net_write_timeout=12000;
   SET global connect_timeout=12000;
   SET net_read_timeout=12000;

   BEGIN
      declare continue handler for sqlstate '02000' set done = 1;
      OPEN c;
      REPEAT
         FETCH c INTO nR_Timestamp, vPhone;
         if not done then
            begin
               declare continue handler for sqlstate '02000' set done_s = 1;

               set @umap_datein = null;
               set @umap_ts     = null;
               set @umap_ipadd  = null;

               SELECT CONVERT_TZ(date_add('1970-01-01', interval (r_timestamp/1000) second),'+00:00','+08:00'), r_timestamp, ip_address
               INTO @umap_datein, @umap_r_timestamp, @umap_ip_address
               FROM tmp_radius_umapping
               WHERE phone = vPhone
               and   r_action = 'UNMAP'
               and   r_timestamp >= nR_Timestamp
               order by r_timestamp limit 1;

               if @umap_r_timestamp is not null then
                  UPDATE  tmp_radius_mapping
                  SET     umap_r_timestamp=@unmap_datein,
                          umap_tz=@unmap_ts,
                          umap_r_ip_address=@unmap_ipadd,
                          map_tz=CONVERT_TZ(date_add('1970-01-01', interval (nR_Timestamp/1000) second),'+00:00','+08:00')
                  WHERE   phone = vPhone
                  AND     r_timestamp=nR_Timestamp;
               end if;
            end;
         end if;
      UNTIL done
      END REPEAT;
      CLOSE c;
   END;

END;
//
delimiter ;



select phone, 
      count(1) no_sessions, 
      min(round((umap_r_timestamp - r_timestamp)/1000,0)) min_duration,
      avg(round((umap_r_timestamp - r_timestamp)/1000,0)) avg_duration,
      max(round((umap_r_timestamp - r_timestamp)/1000,0)) max_duration,
      round(sum(umap_r_timestamp - r_timestamp)/1000 ,0) actual_usage, 
      if(round(sum(umap_r_timestamp - r_timestamp)/1000 ,0)>86400, 86400, round(sum(umap_r_timestamp - r_timestamp)/1000 ,0)) tot_usage, 
      sum(IF(umap_r_timestamp is null, 1, 0)) no_null_unmap, 
      max(IF(umap_tz>(date_add(datein, interval 1 day), unmap_datein, datein))) unmap_forever,
from tmp_radius_log
group by phone


select phone, 
      count(1) no_sessions, 
      min(round((unmap_ts-map_ts)/1000,0)) min_duration,
      avg(round((unmap_ts-map_ts)/1000,0)) avg_duration,
      max(round((unmap_ts-map_ts)/1000,0)) max_duration,
      round(sum(unmap_ts-map_ts)/1000 ,0) actual_usage, 
      if(round(sum(unmap_ts-map_ts)/1000 ,0)>86400, 86400, round(sum(unmap_ts-map_ts)/1000 ,0)) tot_usage, 
      sum(IF(unmap_ts is null, 1, 0)) no_null_unmap, 
      max(IF(unmap_datein>(date_add(datein, interval 1 day), unmap_datein, datein))) unmap_forever,

create table powerapp_usage_per_day (
  tran_dt date not null,
  m2400 int default 0 not null,
  m1200 int default 0 not null,
  m1000 int default 0 not null,
  m0900 int default 0 not null,
  m0800 int default 0 not null,
  m0700 int default 0 not null,
  m0600 int default 0 not null,
  m0500 int default 0 not null,
  m0400 int default 0 not null,
  m0300 int default 0 not null,
  m0200 int default 0 not null,
  m0100 int default 0 not null,
  m0030 int default 0 not null,
  m0015 int default 0 not null,
  m0005 int default 0 not null,
  m0004 int default 0 not null,
  m0003 int default 0 not null,
  m0002 int default 0 not null,
  m0001 int default 0 not null,
  m0000 int default 0 not null,
  m00_0 int default 0 not null,
  primary key (tran_dt)
);

drop table powerapp_usage_per_day;
create table powerapp_usage_per_day (
  tran_dt date not null,
  usage_group varchar(8) not null,
  no_mins int default 0 not null,
  primary key (tran_dt, usage_group)
);

delete from powerapp_usage_per_day;
insert into powerapp_usage_per_day 
select datein, usage_group, count(phone) count_mins from (
select datein, phone, sum(round((unmap_ts-map_ts)/1000 ,0)) max_usage, count(1) no_sessions,
       case
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (24*60*60) then '2400' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (12*60*60) then '1200'
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (10*60*60) then '1000' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (9*60*60)  then '0900' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (8*60*60)  then '0800' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (7*60*60)  then '0700' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (6*60*60)  then '0600' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (5*60*60)  then '0500' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (4*60*60)  then '0400' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (3*60*60)  then '0300' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (2*60*60)  then '0200' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (1*60*60)  then '0100' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (30*60)    then '0030' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (15*60)    then '0015' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (10*60)    then '0010' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (9*60)     then '0009' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (8*60)     then '0008' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (7*60)     then '0007' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (6*60)     then '0006' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (5*60)     then '0005' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (4*60)     then '0004' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (3*60)     then '0003' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (2*60)     then '0002' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (1*60)     then '0001' 
           when  round(sum(IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) > (0*60)     then '0000' 
           else '00-0'
      end as usage_group
from powerapp_mapping_usage 
group by datein, phone ) as t
group  by  datein, usage_group;


-- report
select concat(tran_dt, ',', usage) mapping_usage from (
select tran_dt, group_concat(no_mins order by usage_group separator ',') usage_group
from powerapp_usage_per_day group by tran_dt order by tran_dt) as x;


select datein, usage_group, count(phone) count_mins from (
select datein, phone, round((IFNULL(unmap_ts,map_ts+86400)-map_ts)/1000,0) max_usage,
       case
           when  round((unmap_ts-map_ts)/1000,0) > (24*60*60) then '2400' 
           when  round((unmap_ts-map_ts)/1000,0) > (12*60*60) then '1200' 
           when  round((unmap_ts-map_ts)/1000,0) > (8*60*60)  then '0800' 
           when  round((unmap_ts-map_ts)/1000,0) > (4*60*60)  then '0400' 
           when  round((unmap_ts-map_ts)/1000,0) > (2*60*60)  then '0200' 
           when  round((unmap_ts-map_ts)/1000,0) > (1*60*60)  then '0100' 
           when  round((unmap_ts-map_ts)/1000,0) > (30*60)    then '0030' 
           when  round((unmap_ts-map_ts)/1000,0) > (15*60)    then '0015' 
           when  round((unmap_ts-map_ts)/1000,0) > (5*60)     then '0005' 
           else '0000' 
      end as usage_group
from powerapp_mapping_usage 
where datein = '2014-03-31') as t
group  by  datein, usage_group;


select * 
from   powerapp_mapping_usage
where datein='2014-03-10'
and   phone = '639071063659';

and   unmap_ts is null;


DROP PROCEDURE sp_map_duration_stat_builder;
delimiter //
CREATE DEFINER=root@localhost PROCEDURE sp_map_duration_stat_builder()
BEGIN

   DECLARE done,done_s int default 0;
   DECLARE vMinTxId bigint(20);
   DECLARE vPhone varchar(12);
   DECLARE vIpAdd varchar(20);
   DECLARE c cursor FOR SELECT tx_id, phone, map_ipadd FROM powerapp_mapping_usage WHERE unmap_tx_id is null;

   SET net_write_timeout=12000;
   SET global connect_timeout=12000;
   SET net_read_timeout=12000;

   INSERT IGNORE INTO powerapp_mapping_usage (tx_id, phone, datein, map_ipadd, map_datein, map_ts)

   SELECT tx_id, phone, CONVERT_TZ(left(date_add('1970-01-01', interval (ts/1000) second),10),'+00:00','+08:00') datein, ipadd,
                        CONVERT_TZ(date_add('1970-01-01', interval (ts/1000) second),'+00:00','+08:00') map_datein, ts
                        FROM   powerapp_mapping_hist where map_type ='MAP' ;

   BEGIN
      declare continue handler for sqlstate '02000' set done = 1;
      OPEN c;
      REPEAT
         FETCH c INTO vMinTxId, vPhone, vIpAdd;
         if not done then
            begin
               declare continue handler for sqlstate '02000' set done_s = 1;

               set @unmap_datein = null;
               set @unmap_ts     = null;
               set @unmap_ipadd  = null;
               set @unmap_tx_id  = null;
               set @vSimType     = null;

               SELECT CONVERT_TZ(date_add('1970-01-01', interval (ts/1000) second),'+00:00','+08:00'), ts, ipadd, tx_id
               INTO @unmap_datein, @unmap_ts, @unmap_ipadd, @unmap_tx_id
               FROM powerapp_mapping_hist
               WHERE tx_id = (select min(tx_id)
                              from powerapp_mapping_hist
                              where map_type = 'UNMAP'
                              and  phone = vPhone
                              and  ipadd = vIpAdd
                              and  tx_id > vMinTxId );

               if (vPhone REGEXP '^(63|0)908[1-7,9][0-9]{6,6}$|^(63|0)918[2,4-6][0-9]{6,6}$|^(63|0)9183[0-2][0-9]{5,5}$|^(63|0)91833[0-6][0-9]{4,4}$|^(63|0)918338[0-9]{4}$|^(63|0)918339[0-9]{4,4}$' OR
                   vPhone REGEXP '^(63|0)9183[4-7][0-9]{5,5}$|^(63|0)91838[0-9]{5,5}$|^(63|0)91839[0-9]{5,5}$|^(63|0)919[3,4,6,8][0-9]{6,6}$|^(63|0)9192[0-1][0-9]{5,5}$|^(63|0)91922[1-9][0-9]{4,4}$' OR
                   vPhone REGEXP '^(63|0)9192[3-7,9][0-9]{5,5}$|^(63|0)91928[0-8][0-9]{4,4}$|^(63|0)9195[0-3,5-9][0-9]{5,5}$|^(63|0)9199[0,2-8][0-9]{5,5}$|^(63|0)920[1,4,6][0-9]{6,6}$' OR
                   vPhone REGEXP '^(63|0)9202[0-6][0-9]{5,5}$|^(63|0)9205[0-8][0-9]{5,5}$|^(63|0)92059[0-7][0-9]{4,4}$|^(63|0)920599[0-9]{4,4}$|^(63|0)9208[0-7,9][0-9]{5,5}$|^(63|0)920880[0-9]{4,4}$' OR
                   vPhone REGEXP '^(63|0)9202(7(0(0[5-9][0-9]{2}|[1-9][0-9]{3})|[1-9][0-9]{4})|[89][0-9]{5})$|^(63|0)921[2,4-7][0-9]{6,6}$|^(63|0)9213[0-2,4-9][0-9]{5,5}$|^(63|0)92133[0-8][0-9]{4,4}$' OR
                   vPhone REGEXP '^(63|0)921339[0-8][0-9]{3,3}$|^(63|0)9219[5-9][0-9]{5,5}$|^(63|0)928[2-4,7][0-9]{6,6}$|^(63|0)92859[0-9]{5,5}$|^(63|0)9286[0-3,5-9][0-9]{5,5}$|^(63|0)9289[0,3-9][0-9]{5,5}$' OR
                   vPhone REGEXP '^(63|0)929[1-8][0-9]{6,6}$|^(63|0)9299[5-7][0-9]{5,5}$|^(63|0)9391[0-9]{6,6}$|^(63|0)939([2-5][0-9]{6}|6[0-5][0-9]{5})$|^(63|0)939(7[6-9][0-9]{5}|80[0-9]{5})$' OR
                   vPhone REGEXP '^(63|0)9399[4-6][0-9]{5}$|^(63|0)947([2-5][0-9]{6}|6[0-4][0-9]{5})$|^(63|0)947(69[0-9]{5}|7[0-9]{6}|8[0-8][0-9]{5})$|^(63|0)9479[2-8][0-9]{5}$|^(63|0)9491[1-9][0-9]{5,5}$' OR
                   vPhone REGEXP '^(63|0)9493[0-7,9][0-9]{5,5}$|^(63|0)94950[0-9]{5,5}$|^(63|0)949[4,6,7][0-9]{6,6}$|^(63|0)9499[0-8][0-9]{5,5}$|^(63|0)94939[0-9]{5}$|^(63|0)999[3-5,7][0-9]{6,6}$|^(63|0)9996[5-9][0-9]{5,5}$' OR
                   vPhone REGEXP '^(63|0)9998[0-7,9][0-9]{5,5}$|^(63|0)9999[0-8][0-9]{5,5}$|^(63|0)9991[5-9][0-9]{5,5}$|^(63|0)9985[0-2][0-9]{5}$|^(63|0)998[2-4][0-9]{6}$|^(63|0)9981[5-9][0-9]{5}$' OR
                   vPhone REGEXP '^(63|0)9989[0-4][0-9]{5}$|^(63|0)947(1[4-9][0-9]{5}|[2-5][0-9]{6}|6[0-4][0-9]{5})$|^(63|0)9281[0-9]{6,6}$|^(63|0)9476[5-8][0-9]{5}$|^(63|0)90800[0-9]{5}$')
               then
                  set @vSimType = 'BUDDY';
               elseif (vPhone REGEXP '^(63|0)907[1-9][0-9]{6,6}$|^(63|0)909[1-9][0-9]{6,6}$|^(63|0)910[1-6,8-9][0-9]{6,6}$|^(63|0)9107[0-8][0-9]{5,5}$|^(63|0)91079([0-8][0-9]{4}|9[0-8][0-9]{3})$|^(63|0)912[1-9][0-9]{6,6}$' OR
                      vPhone REGEXP '^(63|0)9187[0-8][0-9]{5,5}$|^(63|0)91879([0-8][0-9]{4}|9[0-8][0-9]{3})$|^(63|0)9197[0-9]{6,6}$|^(63|0)920(3|7)[0-9]{6,6}$|^(63|0)92088[1-9][0-9]{4,4}$|^(63|0)9285[3,4,6-8][0-9]{5,5}$' OR
                      vPhone REGEXP '^(63|0)930[1-9][0-9]{6,6}$|^(63|0)946(1[1-9][0-9]{5}|[2-6][0-9]{6}|7[0-5][0-9]{5})$|^(63|0)946[89][0-9]{6}$|^(63|0)9481[2-5][0-9]{5}$|^(63|0)9482[0-9]{6}$' OR
                      vPhone REGEXP '^(63|0)9483[0-9][1-9][5-9][0-9]{3}$|^(63|0)948[4-8][0-9]{6}$|^(63|0)9489[0-4][0-9]{5}$|^(63|0)9489[6-9][0-9]{5}$')
               then
                  set @vSimType = 'TNT';
               elseif (vPhone REGEXP '^(63|0)90885[0-9]{5,5}$|^(63|0)90880[0-2][0-1][0-1][0-9]{2,2}$|^(63|0)9188[0-9]{6,6}$|^(63|0)92888[0-9]{5,5}$|^(63|0)93999[0-9]{5,5}$|^(63|0)94988[0-9]{5,5}$|^(63|0)94999[0-9]{5,5}$' OR
                      vPhone REGEXP '^(63|0)908880[0-1][0-9]{3,3}$|^(63|0)90888020[0-9]{2,2}$|^(63|0)908880210[0-9]{1,1}$|^(63|0)908880211[0-9]{1,1}$|^(63|0)91893[0,3-9][0-9]{4,4}$|^(63|0)91894[0-8][0-9]{4,4}$' OR
                      vPhone REGEXP '^(63|0)9189[5-6][0-9]{5,5}$|^(63|0)9189(0(0[1-9][0-9]{3}|[1-9][0-9]{4})|[12][0-9]{5})$|^6391897([0-3][0-9]{4}|4[0-8][0-9]{3})$|^(63|0)91897[5-9][0-9]{4,4}$|^(63|0)9189[8-9][0-9]{5,5}$' OR
                      vPhone REGEXP '^(63|0)9209[0,1,5-7,9][0-9]{5,5}$|^(63|0)920932[6-9][0-9]{3,3}$|^(63|0)920938[0-9]{4,4}$|^(63|0)92094[5-9][0-9]{4,4}$|^(63|0)92855[0-9]{5,5}$|^(63|0)9399[0-378][0-9]{5,5}$' OR
                      vPhone REGEXP '^(63|0)999(88|99)[0-9]{5,5}$|^(63|0)91999[0-9]{5,5}$|^(63|0)9088[1-4,6,9][0-9]{5,5}$|^(63|0)90887[2-9][0-9]{4,4}$|^(63|0)90888021[2-9][0-9]{1,1}$|^(63|0)9088802[2-9][0-9]{2,2}$' OR
                      vPhone REGEXP '^(63|0)908880[3-9][0-9]{3,3}$|^(63|0)90888[1-9][0-9]{4,4}$|^(63|0)947(89|99)[0-9]{5,5}$|^(63|0)9479171[0-9]{3}$|^(63|0)947917[2-6][0-9]{3}$|^(63|0)92092[0-8][0-9]{4,4}$' OR
                      vPhone REGEXP '^(63|0)920929[0-8][0-9]{3,3}$|^(63|0)92094[0-4][0-9]{4,4}$|^(63|0)94790[0-9]{5}$|^(63|0)92098[0-9]{5,5}$|^(63|0)9285[0-2][0-9]{5,5}$|^(63|0)94938[0-9]{5}$|^(63|0)94791[0-6][0-9]{4}$')
               then
                  set @vSimType = 'POSTPD';
               end if;

               if @unmap_datein is not null then
                  UPDATE  powerapp_mapping_usage
                  SET     unmap_datein=@unmap_datein,
                          unmap_ts=@unmap_ts,
                          unmap_ipadd=@unmap_ipadd,
                          brand=ifnull(@vSimType, 'BUDDY'),
                          unmap_tx_id=@unmap_tx_id
                  WHERE   tx_id=vMinTxId;
               end if;
            end;
         end if;
      UNTIL done
      END REPEAT;
      CLOSE c;
   END;

END;
//
delimiter ;
