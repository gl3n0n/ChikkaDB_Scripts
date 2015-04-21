drop procedure if exists sp_generate_udr_toptalker;
delimiter //
create procedure sp_generate_udr_toptalker (p_trandate date)
begin
   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   delete from powerapp_udr_toptalker where tx_date = p_trandate;
   delete from powerapp_udr_toptalker_services where tx_date = p_trandate;
   delete from powerapp_udr_toptalker_sources where tx_date = p_trandate;
   delete from powerapp_udr_toptalker_buys where tx_date = p_trandate;
   delete from powerapp_udr_services_summary where tx_date = p_trandate;
   delete from powerapp_udr_sources_summary where tx_date = p_trandate;
   delete from powerapp_udr_toptalker_log where tx_date = p_trandate;
   delete from powerapp_udr_tables_cnt where tx_date = p_trandate;

   create temporary table if not exists tmp_top_mins (phone varchar(12) not null, tx_usage bigint(18) default 0 not null, primary key (phone));
   create temporary table if not exists tmp_top_100 (phone varchar(12) not null, tx_usage bigint(18) default 0 not null, key phone_idx(phone));
   create temporary table if not exists tmp_top_services (service varchar(40) not null, phone varchar(12) not null, tx_usage bigint(18) default 0 not null, key phone_idx(phone));
   create temporary table if not exists tmp_top_sources (source varchar(40) not null, phone varchar(12) not null, tx_usage bigint(18) default 0 not null, key phone_idx(phone));
   create temporary table if not exists tmp_services_summary (tx_date date not null, service varchar(40) not null, tx_usage bigint(18) default 0 not null, key phone_idx(tx_date,service));
   create temporary table if not exists tmp_sources_summary (tx_date date not null, source varchar(40) not null, tx_usage bigint(18) default 0 not null, key phone_idx(tx_date,source));
   truncate table tmp_top_mins;
   truncate table tmp_top_100;
   truncate table tmp_top_services;
   truncate table tmp_top_sources;
   truncate table tmp_services_summary;
   truncate table tmp_sources_summary;

   -- generate TOP 2000 MINs per UDR table
   set @nTableCnt  = 50;
   set @nCtr  = 0;
   while (@nCtr <= @nTableCnt)
   do
      SET @nCtr  = @nCtr + 1; 
      if @nCtr < (@nTableCnt+1) then
         SET @vSql = '';
         SET @vSql = concat('insert ignore into tmp_top_mins select phone, sum(b_usage) from test.udr_', @nCtr, ' ',
                            'where tx_date = ''', p_trandate, ''' group by phone having sum(b_usage) > 0 ',
                            'order by 2 desc limit 2000');
         select @vSql;
         PREPARE stmt FROM @vSql;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;
      end if;
   end while;
   select 'First Pass....' Process;

   -- generate usage for all MINs on table tmp_top_mins per UDR table
   set @nCtr  = 0;
   while (@nCtr <= @nTableCnt)
   do
      SET @nCtr  = @nCtr + 1; 
      if @nCtr < (@nTableCnt+1) then
         SET @vSql = '';
         SET @vSql = concat('insert into tmp_top_100 select phone, sum(b_usage) from test.udr_', @nCtr, ' a ',
                            'where tx_date = ''', p_trandate, ''' and exists (select 1 from tmp_top_mins b where a.phone=b.phone) ',
                            'group by phone having sum(b_usage) > 0');
         PREPARE stmt FROM @vSql;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;
      end if;
   end while;
   select 'Second Pass....' Process;

   -- generate TOP 100 MINs
   insert ignore into powerapp_udr_toptalker (tx_date, phone, tx_usage) select p_trandate, phone, sum(tx_usage) from tmp_top_100 group by 1,2 order by 3 desc limit 1000;
   insert ignore into powerapp_udr_toptalker (tx_date, phone, tx_usage) select p_trandate, phone, tx_usage from powerapp_nds_toptalker a where tx_date = p_trandate                           and not exists (select 1 from powerapp_udr_toptalker b where a.phone=b.phone and b.tx_date = p_trandate) order by tx_usage desc limit 100; 
   insert ignore into powerapp_udr_toptalker (tx_date, phone, tx_usage) select p_trandate, phone, tx_usage from powerapp_nds_toptalker a where tx_date = date_sub(p_trandate, interval 1 day) and not exists (select 1 from powerapp_udr_toptalker b where a.phone=b.phone and b.tx_date = p_trandate) order by tx_usage desc limit 100; 
   insert ignore into powerapp_udr_toptalker (tx_date, phone, tx_usage) select p_trandate, phone, tx_usage from powerapp_nds_toptalker a where tx_date = date_sub(p_trandate, interval 2 day) and not exists (select 1 from powerapp_udr_toptalker b where a.phone=b.phone and b.tx_date = p_trandate) order by tx_usage desc limit 100; 
   insert ignore into powerapp_udr_toptalker (tx_date, phone, tx_usage) select p_trandate, phone, tx_usage from powerapp_nds_toptalker a where tx_date = date_sub(p_trandate, interval 3 day) and not exists (select 1 from powerapp_udr_toptalker b where a.phone=b.phone and b.tx_date = p_trandate) order by tx_usage desc limit 100; 
   
   -- select '2015-02-24' tran_date, phone, sum(tx_usage) from tmp_top_100 group by 1,2 order by 3 desc limit 1000;
   select 'Third Pass....' Process;
   set @nCtr  = 0;
   while (@nCtr <= @nTableCnt)
   do 
      SET @nCtr  = @nCtr + 1; 
      if @nCtr < (@nTableCnt+1) then
         SET @vSql = '';
         SET @vSql = concat('insert into tmp_top_services (service, phone, tx_usage) ',
                            'select service, phone, sum(b_usage) ',
                            'from   test.udr_', @nCtr, ' a ',
                            'where  tx_date = ''', p_trandate, ''' ',
         --                   'and    exists (select 1 from powerapp_udr_toptalker b where b.tx_date=''', p_trandate, ''' and a.phone=b.phone) ',
                            'group by service, phone ',
                            'having sum(b_usage) > 0');
         PREPARE stmt FROM @vSql;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;
         
         SET @vSql = '';
         SET @vSql = concat('insert into tmp_top_sources (source, phone, tx_usage) ',
                            'select source, phone, sum(b_usage) ',
                            'from   test.udr_', @nCtr, ' a ',
                            'where  tx_date = ''', p_trandate, ''' ',
         --                   'and    exists (select 1 from powerapp_udr_toptalker b where b.tx_date=''', p_trandate, ''' and a.phone=b.phone) ',
                            'group by source, phone ',
                            'having sum(b_usage) > 0');
         PREPARE stmt FROM @vSql;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;

         -- SET @vSql = '';
         -- SET @vSql = concat('insert into tmp_services_summary (tx_date, service, tx_usage) ',
         --                    'select tx_date, service, sum(b_usage) ',
         --                    'from   test.udr_', @nCtr, ' a ',
         --                    'where  tx_date = ''', p_trandate, ''' ',
         --                    'group by tx_date, service ',
         --                    'having sum(b_usage) > 0');
         -- PREPARE stmt FROM @vSql;
         -- EXECUTE stmt;
         -- DEALLOCATE PREPARE stmt;

         -- SET @vSql = '';
         -- SET @vSql = concat('insert into tmp_sources_summary (tx_date, source, phone, tx_usage) ',
         --                    'select tx_date, source, sum(b_usage) ',
         --                    'from   test.udr_', @nCtr, ' a ',
         --                    'where  tx_date = ''', p_trandate, ''' ',
         --                    'group by tx_date, source ',
         --                    'having sum(b_usage) > 0');
         -- PREPARE stmt FROM @vSql;
         -- EXECUTE stmt;
         -- DEALLOCATE PREPARE stmt;

         SET @vSql = '';
         SET @vSql = concat('insert into powerapp_udr_toptalker_log (tx_date, phone, source, service, rx, tx, b_usage, tx_time, filename) ',
                            'select tx_date, phone, source, service, rx, tx, b_usage, tx_time, filename ',
                            'from   test.udr_', @nCtr, ' a ',
                            'where  tx_date = ''', p_trandate, ''' ',
                            'and    exists (select 1 from powerapp_udr_toptalker b where a.phone=b.phone and a.tx_date=b.tx_date) ',
                            'and    b_usage > 0');
         PREPARE stmt FROM @vSql;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;

         SET @vSql = '';
         SET @vSql = concat('insert into powerapp_udr_tables_cnt (tx_date, table_name, num_rows) ',
                            'select ''', p_trandate, ''', ''udr_', @nCtr, ''', count(1) ',
                            'from   test.udr_', @nCtr);
         select @vSql; 
         PREPARE stmt FROM @vSql;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;
      end if;

   end while;

   select 'Fourth Pass....' Process;
   update powerapp_udr_toptalker a set tx_usage=(select sum(b_usage) from powerapp_udr_toptalker_log b where a.phone=.b.phone and a.tx_date=b.tx_date) where tx_date = p_trandate;   
   insert ignore into powerapp_udr_toptalker_services (tx_date, phone, service, tx_usage) select p_trandate, phone, service, sum(tx_usage) from tmp_top_services group by 1,2,3;
   insert ignore into powerapp_udr_toptalker_sources(tx_date, phone, source, tx_usage) select p_trandate, phone, source, sum(tx_usage) from tmp_top_sources group by 1,2,3;
   -- insert ignore into powerapp_udr_services_summary (tx_date, service, tx_usage) select tx_date, service, sum(tx_usage) from tmp_services_summary group by 1,2;
   -- insert ignore into powerapp_udr_sources_summary (tx_date,source, tx_usage) select tx_date, source, sum(tx_usage) from tmp_sources_summary group by 1,2;
   insert ignore into powerapp_udr_services_summary (tx_date, service, brand, tx_usage, tx_uniq) select p_trandate, b.service, IFNULL(a.brand,'OTHERS'), sum(b.tx_usage), count(distinct b.phone) from tmp_top_services b left outer join powerapp_users_apn a on a.phone = b.phone group by 1,2,3;
   insert ignore into powerapp_udr_sources_summary (tx_date, source, brand, tx_usage, tx_uniq) select p_trandate, b.source, IFNULL(a.brand,'OTHERS'), sum(b.tx_usage), count(distinct b.phone) from tmp_top_sources b left outer join powerapp_users_apn a on a.phone = b.phone group by 1,2,3;

   select 'Fifth Pass....' Process;
   insert ignore into powerapp_udr_toptalker_buys (tx_date, phone, plan, hits)
   select left(datein,10) tx_date, phone, plan, count(1) hits 
   from   powerapp_log a 
   where  datein >= p_trandate and datein < date_add(p_trandate, interval 1 day)
   and    plan <> 'MYVOLUME' 
   and    exists (select 1 from powerapp_udr_toptalker b where b.tx_date = p_trandate and a.phone = b.phone)
   group by left(datein,10), phone, plan;

   update powerapp_udr_toptalker a 
   set w_buys=1 
   where tx_date = p_trandate 
   and   exists (select 1 from powerapp_udr_toptalker_buys b 
                 where a.tx_date=b.tx_date and a.phone=b.phone);

   call sp_process_udr_wo_buys(p_trandate);
   select 'Done ....' Process;
end;
//
delimiter ;

GRANT EXECUTE ON PROCEDURE `archive_powerapp_flu`.`sp_generate_udr_toptalker` TO 'stats'@'localhost' ;


drop procedure if exists sp_process_udr_wo_buys;
delimiter //
create procedure sp_process_udr_wo_buys (in p_trandate date)
begin

   declare vPlan Varchar(100);
   declare vPhone Varchar(12);
   declare done_p, nCnt int default 0;
   declare c_wo_buys cursor for 
      select phone from powerapp_udr_toptalker 
      where  tx_date = p_trandate
      and    w_buys=0;
   declare continue handler for sqlstate '02000' set done_p = 1;


   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   OPEN c_wo_buys;
   REPEAT
   FETCH c_wo_buys into vPhone;
      set vPlan = NULL;
      set nCnt = 1;
      begin
         declare continue handler for sqlstate '02000' set nCnt = 0;
         select concat(plan, '^', start_tm, '^', end_tm) into vPlan 
         from powerapp_log 
         where datein > date_sub(p_trandate, interval 3 day)
         and   end_tm >= p_trandate
         and   start_tm <= p_trandate
         and   phone = vPhone
         limit 1; 
      end;
      if vPlan is not null then
         update powerapp_udr_toptalker
         set    w_plan=vPlan
         where  tx_date = p_trandate
         and    phone = vPhone;
      end if;
   UNTIL done_p
   END REPEAT;
end;
//
delimiter ;

call sp_generate_udr_toptalker('2015-03-15');
call sp_process_udr_wo_buys('2015-03-15');

   update powerapp_udr_toptalker a 
   set w_buys=1 
   where tx_date = '2015-03-15' 
   and   exists (select 1 from powerapp_udr_toptalker_buys b 
                 where a.tx_date=b.tx_date and a.phone=b.phone);
truncate table powerapp_udr_toptalker;
truncate table powerapp_udr_toptalker_services;
truncate table powerapp_udr_toptalker_sources;
truncate table powerapp_udr_toptalker_buys;
truncate table powerapp_udr_services_summary;
truncate table powerapp_udr_sources_summary;
call sp_generate_udr_toptalker('2015-03-08');


create temporary table tmp_phones select tx_date, phone, tx_usage from powerapp_nds_toptalker where tx_date='2015-03-12' order by tx_usage desc limit 20;
alter table tmp_phones add key (tx_date, phone);
select a.*, b.*, a.tx_usage-b.tx_usage tx_diff from tmp_phones a left outer join powerapp_udr_toptalker b on a.phone=b.phone and a.tx_date=b.tx_date order by a.tx_usage desc;

delete from tmp_phones;
insert into tmp_phones select tx_date, phone, tx_usage from powerapp_nds_toptalker where tx_date='2015-03-10' order by tx_usage desc limit 20;
select a.phone, a.tx_date, a.tx_usage nds_usage, b.tx_date, ifnull(b.tx_usage,0) udr_usage
from   tmp_phones a left outer join powerapp_udr_toptalker b 
on  a.phone=b.phone and b.tx_date='2015-03-12'
order by a.tx_usage desc;

select a.phone, a.tx_date, a.tx_usage nds_usage, b.tx_date, ifnull(b.tx_usage,0) udr_usage
from   tmp_phones a left outer join powerapp_nds_toptalker b 
on  a.phone=b.phone and b.tx_date='2015-03-12'
order by a.tx_usage desc;

+--------------+------------+------------+------------+-----------+------------+-----------+------------+-----------+
| phone        | tx_date    | nds_usage  | tx_date    | udr_usage | tx_date    | udr_usage | tx_date    | udr_usage |
+--------------+------------+------------+------------+-----------+------------+-----------+------------+-----------+
| 639466163819 | 2015-03-09 | 2740729166 | 2015-03-09 |  20891548 | 2015-03-10 |         0 | 2015-03-08 | 153440872 |
| 639123437474 | 2015-03-09 | 2551314591 | 2015-03-09 |  97153266 | 2015-03-10 |         0 | 2015-03-08 |         0 |
| 639108804128 | 2015-03-09 | 2515453614 | 2015-03-09 |     55200 | 2015-03-10 |  14063978 | 2015-03-08 |         0 |
| 639097496388 | 2015-03-09 | 2508682969 | 2015-03-09 | 158794020 | 2015-03-10 |    883600 | 2015-03-08 |         0 |
| 639102044522 | 2015-03-09 | 2471280113 | 2015-03-09 |         0 | 2015-03-10 |         0 | 2015-03-08 |         0 |
| 639187343149 | 2015-03-09 | 2464448615 | 2015-03-09 |    192450 | 2015-03-10 | 134990442 | 2015-03-08 | 116856412 |
| 639072390123 | 2015-03-09 | 2444791603 | 2015-03-09 |  77276526 | 2015-03-10 |      5520 | 2015-03-08 |  71458546 |
| 639463263905 | 2015-03-09 | 2400527699 | 2015-03-09 |   3158572 | 2015-03-10 |         0 | 2015-03-08 | 147516150 |
| 639126377783 | 2015-03-09 | 2389847591 | 2015-03-09 |  62897734 | 2015-03-10 |    183184 | 2015-03-08 | 119791490 |
| 639075462864 | 2015-03-09 | 2371437840 | 2015-03-09 | 187615584 | 2015-03-10 |         0 | 2015-03-08 |         0 |
| 639462080209 | 2015-03-09 | 2369943679 | 2015-03-09 |         0 | 2015-03-10 |         0 | 2015-03-08 |         0 |
| 639094515912 | 2015-03-09 | 2362627717 | 2015-03-09 | 132142314 | 2015-03-10 |         0 | 2015-03-08 |  65409240 |
| 639469236930 | 2015-03-09 | 2359240598 | 2015-03-09 | 255032088 | 2015-03-10 |   1098966 | 2015-03-08 |         0 |
| 639075616729 | 2015-03-09 | 2351991788 | 2015-03-09 |     25410 | 2015-03-10 |         0 | 2015-03-08 |         0 |
| 639466388763 | 2015-03-09 | 2346297387 | 2015-03-09 |    392136 | 2015-03-10 |         0 | 2015-03-08 | 105350482 |
| 639468426587 | 2015-03-09 | 2343081641 | 2015-03-09 |         0 | 2015-03-10 |         0 | 2015-03-08 | 150918558 |
| 639101689873 | 2015-03-09 | 2340775507 | 2015-03-09 |         0 | 2015-03-10 |         0 | 2015-03-08 |         0 |
| 639093694060 | 2015-03-09 | 2337523951 | 2015-03-09 |         0 | 2015-03-10 |         0 | 2015-03-08 |         0 |
| 639309085787 | 2015-03-09 | 2337119900 | 2015-03-09 |         0 | 2015-03-10 |    249078 | 2015-03-08 |         0 |
| 639488967796 | 2015-03-09 | 2336297435 | 2015-03-09 |     77868 | 2015-03-10 |    694616 | 2015-03-08 |         0 |
+--------------+------------+------------+------------+-----------+------------+-----------+------------+-----------+
20 rows in set (0.00 sec)                                                                                            

+--------------+------------+------------+------------+-----------+------------+-----------+
| phone        | tx_date    | nds_usage  | tx_date    | udr_usage | tx_date    | udr_usage |
+--------------+------------+------------+------------+-----------+------------+-----------+
| 639214972847 | 2015-03-08 | 2663517175 | 2015-03-08 |         0 | 2015-03-09 |    827890 |
| 639487909070 | 2015-03-08 | 2310609845 | 2015-03-08 |         0 | 2015-03-09 | 124196618 |
| 639185220417 | 2015-03-08 | 1917472860 | 2015-03-08 |         0 | 2015-03-09 |   1529050 |
| 639494227483 | 2015-03-08 | 1802278074 | 2015-03-08 |         0 | 2015-03-09 |         0 |
| 639499876676 | 2015-03-08 | 1753030911 | 2015-03-08 |         0 | 2015-03-09 |         0 |
| 639468964688 | 2015-03-08 | 1659595047 | 2015-03-08 | 119531200 | 2015-03-09 |  11537280 |
| 639128526911 | 2015-03-08 | 1647612347 | 2015-03-08 | 110332532 | 2015-03-09 |  21479060 |
| 639302458068 | 2015-03-08 | 1640153364 | 2015-03-08 |         0 | 2015-03-09 |         0 |
| 639995168054 | 2015-03-08 | 1518655874 | 2015-03-08 |         0 | 2015-03-09 |         0 |
| 639484071973 | 2015-03-08 | 1479429875 | 2015-03-08 | 138893414 | 2015-03-09 |         0 |
| 639091231889 | 2015-03-08 | 1474973011 | 2015-03-08 | 146831854 | 2015-03-09 | 140573566 |
| 639485991983 | 2015-03-08 | 1438997412 | 2015-03-08 |         0 | 2015-03-09 |  14442556 |
| 639392657226 | 2015-03-08 | 1361770167 | 2015-03-08 |         0 | 2015-03-09 |  57592894 |
| 639304799457 | 2015-03-08 | 1320959282 | 2015-03-08 | 115354566 | 2015-03-09 |   4636916 |
| 639124555960 | 2015-03-08 | 1314171141 | 2015-03-08 |         0 | 2015-03-09 | 117502116 |
| 639075582809 | 2015-03-08 | 1300827033 | 2015-03-08 |         0 | 2015-03-09 |         0 |
| 639475824577 | 2015-03-08 | 1268087530 | 2015-03-08 |         0 | 2015-03-09 |         0 |
| 639466156090 | 2015-03-08 | 1251364564 | 2015-03-08 | 146366146 | 2015-03-09 |    288612 |
| 639201125308 | 2015-03-08 | 1249080060 | 2015-03-08 |         0 | 2015-03-09 |  38035776 |
| 639214852766 | 2015-03-08 | 1231612645 | 2015-03-08 |         0 | 2015-03-09 | 115002444 |
+--------------+------------+------------+------------+-----------+------------+-----------+
20 rows in set (0.01 sec)

Tel No. 282-8812




select tx_date,brand,tx_usage,tx_uniq from powerapp_udr_services_summary where tx_date>='2015-04-15' and service='FreeIpPool';
select * from powerapp_flu.buys_per_plan where datein >= '2015-04-15' and service='MyvolumeService';

+------------+---------+---------+---------+---------+---------+
| Date       |   BUDDY |  OTHERS |  POSTPD |     TNT |   TOTAL |
+------------+---------+---------+---------+---------+---------+
| 2015-04-15 |   51161 |    5505 |     368 |   54581 |  111615 | 
| 2015-04-16 |   35295 |    4249 |     277 |   37357 |   77178 |
| 2015-04-17 |  188354 |   14638 |    1352 |  166016 |  370360 |
+------------+---------+---------+---------+---------+---------+
12 rows in set (0.01 sec)


+------------+--------+--------------+---------+
| tx_date    | brand  | tx_usage     | tx_uniq |
+------------+--------+--------------+---------+
| 2015-04-15 | BUDDY  | 111092424642 |   51161 |
| 2015-04-15 | OTHERS |  16486115746 |    5505 |
| 2015-04-15 | POSTPD |    798578504 |     368 |
| 2015-04-15 | TNT    | 125740109489 |   54581 |
| 2015-04-16 | BUDDY  | 183180181449 |   35295 |
| 2015-04-16 | OTHERS |  28628752694 |    4249 |
| 2015-04-16 | POSTPD |   1358650905 |     277 |
| 2015-04-16 | TNT    | 192648369275 |   37357 |
| 2015-04-17 | BUDDY  | 283030334748 |  188354 |
| 2015-04-17 | OTHERS |  34919950440 |   14638 |
| 2015-04-17 | POSTPD |   1796201404 |    1352 |
| 2015-04-17 | TNT    | 244526438608 |  166016 |
+------------+--------+--------------+---------+

+------------+-----------------+---------+
| datein     | service         | no_buys |
+------------+-----------------+---------+
| 2015-04-15 | MyvolumeService | 6399987 |
| 2015-04-16 | MyvolumeService |   49499 |
| 2015-04-17 | MyvolumeService |   78657 |
| 2015-04-18 | MyvolumeService |   85293 |
| 2015-04-19 | MyvolumeService |   72213 |
| 2015-04-20 | MyvolumeService |    7872 |
+------------+-----------------+---------+
