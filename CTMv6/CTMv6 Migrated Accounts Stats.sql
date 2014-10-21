Philippines +63
Australia +61 *
Canada +1 *
China +86
Hong Kong +852
Kuwait +965 *
Malaysia +60 *
Qatar +974 *
Saudi Arabia +966 *
Singapore +65
United Arab Emirates +971 *
United Kingdom +44 *
United States +1 *
Bahrain +973
Brazil +55
France +33
Greece +30
Guam +1
India +91
Italy +39
Iraq +964
Ireland +353
Jordan +962
Kazakhstan +7
Lebanon +961
Macau +853
Mexico +52
New Zealand +64
Nigeria +234
Norway +47
Oman +968
Pakistan +92
South Korea +82
North Korea +850
Qatar +974
Spain +34
Sweden +46
Taiwan +886
Thailand +66
Venezuela +58
Vietnam +84

select left(last_update, 10) date, count(1) from ctm_accounts a where exists (select 1 from migrate_user b where a.ctm_accnt=b.v6_username) group by 1;

+------------+----------+
| Date       | Migrated |
+------------+----------+
| 2014-01-29 |    49695 |
| 2014-01-30 |    43994 |
| 2014-01-31 |    31652 |
| 2014-02-01 |    24044 |
| 2014-02-02 |    25806 |
| 2014-02-03 |    22582 |
| 2014-02-04 |    18183 |
| 2014-02-05 |    15542 |
| 2014-02-06 |    14832 |
| 2014-02-07 |     4540 |
+------------+----------+
10 rows in set (5.26 sec)




select d.sn_provider, count(1) from ctm_sns_link c, sns_id_lookup d where c.sn_provider_id=d.id and exists (select 1 from ctm_accounts a,  migrate_user b where a.ctm_accnt=b.v6_username and a.ctm_accnt=c.ctm_accnt) group by 1;

+----------------+-------------+----------+
| sn_provider_id | sn_provider | count(1) |
+----------------+-------------+----------+
|              1 | facebook    |    32402 |
|              2 | linkedin    |      346 |
|              3 | googleplus  |     4743 |
|              4 | twitter     |     1941 |
+----------------+-------------+----------+
4 rows in set (2.48 sec)      4 rows in set (0.00 sec)

select count(1) ALL_cnt from ctm_accounts a where exists (select 1 from migrate_user b where a.ctm_accnt=b.v6_username);
select count(1) PC_cnt from ctm_accounts a where msisdn is null and exists (select 1 from migrate_user b where a.ctm_accnt=b.v6_username);
+----------+
|   PC_cnt |
+----------+
|    53235 |
+----------+
1 row in set (1.74 sec)

create table tmp_migrated_msisdn (ctm_accnt varchar(12), msisdn varchar(19), reg_date date, key msisdn_idx(msisdn));
insert into tmp_migrated_msisdn select ctm_accnt, msisdn, left(last_update,10) from a where exists (select 1 from migrate_user b where a.ctm_accnt=b.v6_username)

select b.operator, b.sim_type, count(a.msisdn) Cnt 
from tmp_migrated_msisdn a left join mobile_pattern b on (a.msisdn regexp b.pattern)
group by 1,2;

+----------------+----------+--------+
| operator       | sim_type | Cnt    |
+----------------+----------+--------+
| GLOBE          | POSTPAID |   5196 |
| GLOBE          | PREPAID  |  58162 |
| GLOBE          | TM       |  15538 |
| SMART          | POSTPAID |   1357 |
| SMART          | PREPAID  |  76452 |
| SMART          | TNT      |  23205 |
| SUN            | POSTPAID |   1272 |
| SUN            | PREPAID  |  12150 |
| PC ACCOUNT     | ALL      |  53235 |
+----------------+----------+--------+

+----------------+--------+
| country        | Cnt    |
+----------------+--------+
| AUSTRALIA      |     19 |
| CHINA          |      6 |
| HONG KONG      |      8 |
| JAPAN          |    110 |
| MALAYSIA       |      2 |
| SAUDI ARABIA   |     68 |
| SINGAPORE      |     69 |
| UAE            |    108 |
| UNITED KINGDOM |     61 |
| UNITED STATES  |    598 |
+----------------+--------+

+-------------+----------+
| sn_provider | count(1) |
+-------------+----------+
| facebook    |    32402 |
| linkedin    |      346 |
| googleplus  |     4743 |
| twitter     |     1941 |
+-------------+----------+

·

update mobile_pattern set sim_type = 'BROPPD' where notes like 'Smart Bro Postpaid%';
update mobile_pattern set sim_type = 'BROPRE' where notes like 'Smart Bro Prepaid%';


delimiter //

drop procedure IF EXISTS sp_get_globe_ctmv5_for_migration//

CREATE PROCEDURE sp_get_globe_ctmv5_for_migration()
begin
   declare vPattern   Varchar(120);
   declare vPostCnt int;
   declare vPostMig int;
   declare vTMCnt   int;
   declare vTMMig   int;
   declare vPreCnt  int;
   declare vPreMig  int;

   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   -- GLOBE
   SET vPostCnt = 0;
   SET vPostMig = 0;
   SET vTMCnt   = 0;
   SET vTMMig   = 0;
   SET vPreCnt  = 0;
   SET vPreMig  = 0;

   BEGIN
      declare done_p int default 0;
      declare c_pat cursor for select pattern
                               from  mobile_pattern
                               where operator = 'GLOBE'
                               and sim_type = 'POSTPAID';
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern;
         if not done_p then
            SET @vSql = concat('select sum(IF(is_migrated=1, 1, 0)), count(1) INTO @PostMig, @PostCnt from ctmv6.migrate_user where v5_username like ''63%'' and v5_username REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET vPostMig = vPostMig + @PostMig;
            SET vPostCnt = vPostCnt + @PostCnt;
         end if;
      UNTIL done_p
      END REPEAT;
   END;
   
   BEGIN
      declare done_p int default 0;
      declare c_pat cursor for select pattern
                               from  mobile_pattern
                               where operator = 'GLOBE'
                               and sim_type = 'PREPAID';
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern;
         if not done_p then
            SET @vSql = concat('select sum(IF(is_migrated=1, 1, 0)), count(1) INTO @PreMig, @PreCnt from ctmv6.migrate_user where v5_username like ''63%'' and v5_username REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET vPreMig = vPreMig + @PreMig;
            SET vPreCnt = vPreCnt + @PreCnt;
         end if;
      UNTIL done_p
      END REPEAT;
   END;

   BEGIN
      declare done_p int default 0;
      declare c_pat cursor for select pattern
                               from  mobile_pattern
                               where operator = 'GLOBE'
                               and sim_type = 'TM';
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern;
         if not done_p then
            SET @vSql = concat('select sum(IF(is_migrated=1, 1, 0)), count(1) INTO @TMMig, @TMCnt from ctmv6.migrate_user where v5_username like ''63%'' and v5_username REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET vTMMig = vTMMig + @TMMig;
            SET vTMCnt = vTMCnt + @TMCnt;
         end if;
      UNTIL done_p
      END REPEAT;
   END;
   
   select  vPostCnt, vPreCnt, vTMCnt, vPostCnt+vPreCnt+vTMCnt Total;
   SET @vSql = concat('insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, total) values (''2014-04-21'',''globe'',''ctmv5'',', vPostCnt, ',', vPreCnt, ',', vTMCnt, ',', vPostCnt+vPreCnt+vTMCnt, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   SET @vSql = concat('insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, total) values (''2014-04-21'',''globe'',''ctmv5_mig'',', vPostMig, ',', vPreMig, ',', vTMMig, ',', vPostMig+vPreMig+vTMMig, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   


end;
//

delimiter ;
call sp_get_globe_ctmv5_for_migration();





delimiter //

DROP PROCEDURE IF EXISTS sp_get_smart_ctmv5_for_migration//

CREATE PROCEDURE sp_get_smart_ctmv5_for_migration()
begin
   declare vPattern   Varchar(120);
   declare vPostCnt int;
   declare vPostMig int;
   declare vPreCnt  int;
   declare vPreMig  int;
   declare vTMCnt   int;
   declare vTMMig   int;
   declare vBroCnt  int;
   declare vBroMig  int;

   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   -- SMART
   SET vPostCnt = 0;
   SET vPostMig = 0;
   SET vPreCnt  = 0;
   SET vPreMig  = 0;
   SET vTMCnt   = 0;
   SET vTMMig   = 0;
   SET vBroCnt  = 0;
   SET vBroMig  = 0;

   BEGIN
      declare done_p int default 0;
      declare c_pat cursor for select pattern
                               from  mobile_pattern
                               where operator = 'SMART'
                               and sim_type = 'POSTPAID';
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern;
         if not done_p then
            SET @vSql = concat('select sum(IF(is_migrated=1, 1, 0)), count(1) INTO @PostMig, @PostCnt from ctmv6.migrate_user where v5_username like ''63%'' and v5_username REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET vPostMig = vPostMig + @PostMig;
            SET vPostCnt = vPostCnt + @PostCnt;
         end if;
      UNTIL done_p
      END REPEAT;
   END;
   
   BEGIN
      declare done_p int default 0;
      declare c_pat cursor for select pattern
                               from  mobile_pattern
                               where operator = 'SMART'
                               and sim_type = 'PREPAID';
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern;
         if not done_p then
            SET @vSql = concat('select sum(IF(is_migrated=1, 1, 0)), count(1) INTO @PreMig, @PreCnt from ctmv6.migrate_user where v5_username like ''63%'' and v5_username REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET vPreMig = vPreMig + @PreMig;
            SET vPreCnt = vPreCnt + @PreCnt;
         end if;
      UNTIL done_p
      END REPEAT;
   END;

   BEGIN
      declare done_p int default 0;
      declare c_pat cursor for select pattern
                               from  mobile_pattern
                               where operator = 'SMART'
                               and sim_type = 'TNT';
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern;
         if not done_p then
            SET @vSql = concat('select sum(IF(is_migrated=1, 1, 0)), count(1) INTO @TMMig, @TMCnt from ctmv6.migrate_user where v5_username like ''63%'' and v5_username REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET vTMMig = vTMMig + @TMMig;
            SET vTMCnt = vTMCnt + @TMCnt;
         end if;
      UNTIL done_p
      END REPEAT;
   END;
   
   BEGIN
      declare done_p int default 0;
      declare c_pat cursor for select pattern
                               from  mobile_pattern
                               where operator = 'SMART'
                               and sim_type like 'BRO%';
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern;
         if not done_p then
            SET @vSql = concat('select sum(IF(is_migrated=1, 1, 0)), count(1) INTO @BroMig, @BroCnt from ctmv6.migrate_user where v5_username like ''63%'' and v5_username REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET vBroMig = vBroMig + @BroMig;
            SET vBroCnt = vBroCnt + @BroCnt;
         end if;
      UNTIL done_p
      END REPEAT;
   END;

   select  vPostCnt, vPreCnt, vTMCnt, vBroCnt, vPostCnt+vPreCnt+vTMCnt+vBroCnt Total;
   select  vPostMig, vPreMig, vTMMig, vBroMig, vPostMig+vPreMig+vTMMig+vBroMig Total;
   SET @vSql = concat('insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, total) values (''2014-04-21'',''smart'',''ctmv5'',', vPostCnt, ',', vPreCnt, ',', vTMCnt, ',', vBroCnt, ',', vPostCnt+vPreCnt+vTMCnt+vBroCnt, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   SET @vSql = concat('insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, total) values (''2014-04-21'',''smart'',''ctmv5_mig'',', vPostMig, ',', vPreMig, ',', vTMMig, ',', vBroMig, ',', vPostMig+vPreMig+vTMMig+vBroMig, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   


end;
//

delimiter ;
call sp_get_smart_ctmv5_for_migration();




delimiter //

DROP PROCEDURE IF EXISTS sp_get_sun_ctmv5_for_migration//

CREATE PROCEDURE sp_get_sun_ctmv5_for_migration()
begin
   declare vPattern   Varchar(120);
   declare vPostCnt int;
   declare vPostMig int;
   declare vPreCnt  int;
   declare vPreMig  int;

   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   -- SMART
   SET vPostCnt = 0;
   SET vPostMig = 0;
   SET vPreCnt  = 0;
   SET vPreMig  = 0;

   BEGIN
      declare done_p int default 0;
      declare c_pat cursor for select pattern
                               from  mobile_pattern
                               where operator = 'SUN'
                               and sim_type = 'POSTPAID';
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern;
         if not done_p then
            SET @vSql = concat('select sum(IF(is_migrated=1, 1, 0)), count(1) INTO @PostMig, @PostCnt from ctmv6.migrate_user where v5_username like ''63%'' and v5_username REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET vPostMig = vPostMig + @PostMig;
            SET vPostCnt = vPostCnt + @PostCnt;
         end if;
      UNTIL done_p
      END REPEAT;
   END;
   
   BEGIN
      declare done_p int default 0;
      declare c_pat cursor for select pattern
                               from  mobile_pattern
                               where operator = 'SUN'
                               and sim_type = 'PREPAID';
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern;
         if not done_p then
            SET @vSql = concat('select sum(IF(is_migrated=1, 1, 0)), count(1) INTO @PreMig, @PreCnt from ctmv6.migrate_user where v5_username like ''63%'' and v5_username REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET vPreMig = vPreMig + @PreMig;
            SET vPreCnt = vPreCnt + @PreCnt;
         end if;
      UNTIL done_p
      END REPEAT;
   END;


   select  vPostCnt, vPreCnt, vPostCnt+vPreCnt Total;
   select  vPostMig, vPreMig, vPostMig+vPreMig Total;
   SET @vSql = concat('insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, total) values (''2014-04-21'',''sun'',''ctmv5'',', vPostCnt, ',', vPreCnt, ',', 0, ',', vPostCnt+vPreCnt, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   SET @vSql = concat('insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, total) values (''2014-04-21'',''sun'',''ctmv5_mig'',', vPostMig, ',', vPreMig, ',', 0, ',', vPostMig+vPreMig, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   


end;
//

delimiter ;
call sp_get_smart_ctmv5_for_migration();
call sp_get_sun_ctmv5_for_migration();

