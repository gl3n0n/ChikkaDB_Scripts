##### RUNS @SHRIKE
##### RUNS @SHRIKE
##### RUNS @SHRIKE

mysql -uroot -p --socket=/mnt/san02-csg-archive/mysql/mysql.sock --port=3302
source db & tables: csgv3_v6.sms_out
                    mui_ph_smart_1.smsgw_in
                    mui_ph_smart_1.bridge_in
                    mui_ph_globe_1.bridge_in
                    mui_ph_sun_1.bridge_in

DROP TABLE IF EXISTS ctmv6_stats_dtl;

CREATE TABLE ctmv6_stats_dtl (
  tran_dt date NOT NULL,
  carrier varchar(30) NOT NULL,
  type varchar(30) NOT NULL,
  post int(8) NOT NULL DEFAULT 0,
  pre int(8) NOT NULL DEFAULT 0,
  tm_tnt int(8) NOT NULL DEFAULT 0,
  tat_bro int(8) NOT NULL DEFAULT 0,
  others int(8) NOT NULL DEFAULT 0,
  total int default 0,
  PRIMARY KEY (tran_dt,carrier,type)
);


DROP TABLE IF EXISTS ctmv6_active_mins;
CREATE TABLE ctmv6_active_mins (
  tx_date date NOT NULL,
  phone   varchar(30) NOT NULL,
  carrier varchar(30) NOT NULL,
  brand   varchar(30) NOT NULL,
  hits    int default 0,
  PRIMARY KEY (tx_date,phone)
);

DROP TABLE IF EXISTS ctmv6_mt_mins;
CREATE TABLE ctmv6_mt_mins (
  tx_date date NOT NULL,
  phone   varchar(30) NOT NULL,
  carrier varchar(30) NOT NULL,
  brand   varchar(30) NOT NULL,
  hits    int default 0,
  PRIMARY KEY (tx_date,phone)
);


delimiter //

drop procedure IF EXISTS sp_generate_ctmv6_stats_csg//

CREATE PROCEDURE sp_generate_ctmv6_stats_csg(p_trandate varchar(10))
begin
   declare vTranDate varchar(30);
   if p_trandate is not null then
      SET vTranDate  = p_trandate;
   else
      SET vTranDate  = date_sub(curdate(), interval 1 day);
   end if;
   call sp_generate_ctmv6_stats_globe(vTranDate);
   call sp_generate_ctmv6_stats_smart(vTranDate);
   call sp_generate_ctmv6_stats_sun(vTranDate);
END;
//
delimiter ;

DROP PROCEDURE sp_regenerate_ctmv6_stats;

delimiter //

CREATE PROCEDURE sp_regenerate_ctmv6_stats(p_trandate varchar(10))
begin
   declare vTranDate varchar(30);
   if p_trandate is not null then
      SET vTranDate  = p_trandate;
   else
      SET vTranDate  = date_sub(curdate(), interval 1 day);
   end if;

   -- start (source: ctm_registration,migrate_user)
   call sp_ctmv6_registration_stats(vTranDate);
   -- end

   -- start (source: sms_out, ctm_registration)
   call sp_generate_ctmv6_stats_globe(vTranDate);
   call sp_generate_ctmv6_stats_smart(vTranDate);
   call sp_generate_ctmv6_stats_sun(vTranDate);
   call sp_generate_active_mins(vTranDate);
   -- end

   -- start (sms_out, smsgw_in, bridge_in)
   call sp_generate_ussd_log(vTranDate);
   call sp_generate_ussd_118_log(vTranDate);
   -- end
   
   -- start (dmp_applogs_logins)
   call sp_ctmv6_login_stats(vTranDate);
   call sp_ctmv6_voice_stats(vTranDate);
   -- end 
END;
//

delimiter ;


delimiter //

drop procedure IF EXISTS sp_generate_ctmv6_stats_globe//

CREATE PROCEDURE sp_generate_ctmv6_stats_globe(p_trandate varchar(10))
begin
   declare vPattern   Varchar(120);
   declare vPostHits  int;
   declare vPostUniq  int;
   declare vTMHits    int;
   declare vTMUniq    int;
   declare vTatHits   int;
   declare vTatUniq   int;
   declare vTotalHits int;
   declare vTotalUniq int;

   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   -- GLOBE
   SET vPostHits  = 0;
   SET vPostUniq  = 0;
   SET vTMHits    = 0;
   SET vTMUniq    = 0;
   SET vTatHits   = 0;
   SET vTatUniq   = 0;
   SET vTotalHits = 0;
   SET vTotalUniq = 0;

   delete from ctmv6_stats_dtl where carrier='globe' and tran_dt = p_trandate and type in ('hits', 'mt', 'uniq_charged', 'uniq_nonreg');
   delete from ctmv6_mt_mins where carrier='GLOBE' and tx_date = p_trandate;
   
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
            SET @vSql = concat('select count(1) INTO @PostHits from sms_out where datesent=''', p_trandate ,''' and operator = ''GLOBE'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') and gsm_num REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
   
            SET @vSql = concat('select count(distinct gsm_num) INTO @PostUniq from sms_out where datesent=''', p_trandate ,''' and operator = ''GLOBE'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') and gsm_num REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('insert ignore into ctmv6_mt_mins (phone, carrier, brand, tx_date, hits) select gsm_num, ''GLOBE'', ''POSTPAID'', datesent, count(1) from sms_out where datesent=''', p_trandate ,''' and operator = ''GLOBE'' and status = ''Delivered'' and csg_tariff=''FREE'' and gsm_num REGEXP ''', vPattern, ''' group by gsm_num, datesent');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vPostHits = vPostHits + @PostHits;
            SET vPostUniq = vPostUniq + @PostUniq;
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
            SET @vSql = concat('select count(1) INTO @TMHits from sms_out where datesent=''', p_trandate ,''' and operator = ''GLOBE'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') and gsm_num REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
   
            SET @vSql = concat('select count(distinct gsm_num) INTO @TMUniq from sms_out where datesent=''', p_trandate ,''' and operator = ''GLOBE'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') and gsm_num REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('insert ignore into ctmv6_mt_mins (phone, carrier, brand, tx_date, hits) select gsm_num, ''GLOBE'', ''TM'', datesent, count(1) from sms_out where datesent=''', p_trandate ,''' and operator = ''GLOBE'' and status = ''Delivered'' and csg_tariff=''FREE'' and gsm_num REGEXP ''', vPattern, ''' group by gsm_num, datesent');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vTMHits = vTMHits + @TMHits;
            SET vTMUniq = vTMUniq + @TMUniq;

         end if;
      UNTIL done_p
      END REPEAT;
   END;

   BEGIN
      declare done_p int default 0;
      declare c_pat cursor for select pattern
                               from  mobile_pattern
                               where operator = 'GLOBE'
                               and sim_type = 'TATTOO';
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern;
         if not done_p then
            SET @vSql = concat('select count(1) INTO @TatHits from sms_out where datesent=''', p_trandate ,''' and operator = ''GLOBE'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') and gsm_num REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
   
            SET @vSql = concat('select count(distinct gsm_num) INTO @TatUniq from sms_out where datesent=''', p_trandate ,''' and operator = ''GLOBE'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') and gsm_num REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('insert ignore into ctmv6_mt_mins (phone, carrier, brand, tx_date, hits) select gsm_num, ''GLOBE'', ''TATTOO'', datesent, count(1) from sms_out where datesent=''', p_trandate ,''' and operator = ''GLOBE'' and status = ''Delivered'' and csg_tariff=''FREE'' and gsm_num REGEXP ''', vPattern, ''' group by gsm_num, datesent');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vTatHits = vTatHits + @TatHits;
            SET vTatUniq = vTatUniq + @TatUniq;

         end if;
      UNTIL done_p
      END REPEAT;
   END;

   SET @vSql = concat('select count(1) INTO @TotalHits from sms_out where datesent=''', p_trandate ,''' and operator = ''GLOBE'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET @vSql = concat('select count(distinct gsm_num) INTO @TotalUniq from sms_out where datesent=''', p_trandate ,''' and operator = ''GLOBE'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET vTotalHits = @TotalHits;
   SET vTotalUniq = @TotalUniq;
   
   SET @vSql = concat('insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, total) values (''', p_trandate ,''',''globe'',''hits'',', vPostHits, ',', vTotalHits-(vPostHits+vTMHits+vTatHits), ',', vTMHits, ',', vTatHits, ',', vTotalHits, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET @vSql = concat('insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, total) values (''', p_trandate ,''',''globe'',''uniq_charged'',', vPostUniq, ',', vTotalUniq-(vPostUniq+vTMUniq+vTatUniq), ',', vTMuniq, ',', vTatUniq, ',', vTotalUniq, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET @vSql = concat('insert ignore into ctmv6_mt_mins (phone, carrier, brand, tx_date, hits) select gsm_num, ''GLOBE'', ''PREPAID'', datesent, count(1) from sms_out a where datesent=''', p_trandate ,''' and operator = ''GLOBE'' and status = ''Delivered'' and csg_tariff=''FREE'' and not exists (select 1 from ctmv6_mt_mins b where a.gsm_num = b.phone and a.datesent=b.tx_date) group by gsm_num, datesent');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- create temporary table for validation against ctm registrations..
   create temporary table if not exists tmp_ctm_registered (msisdn varchar(30) not null, primary key (msisdn)); 
   truncate table tmp_ctm_registered;
   insert into tmp_ctm_registered select msisdn from ctm_registration where msisdn is not null and msisdn like '63%' and reg_date < p_trandate group by msisdn;

   insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, total) 
   select tx_date, 'globe', 'uniq_nonreg', sum(IF(brand='POSTPAID',1,0)) post, sum(IF(brand='PREPAID',1,0)) pre, sum(IF(brand='TM',1,0)) tnt, sum(IF(brand='TATTOO',1,0)) bro, count(1) total
   from   ctmv6_mt_mins a
   where  tx_date = p_trandate
   and    carrier = 'GLOBE' 
   and    not exists (select 1 from tmp_ctm_registered b where a.phone = b.msisdn)
   group  by tx_date;

   insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, total) 
   select tx_date, 'globe', 'mt', sum(IF(brand='POSTPAID',hits,0)) post, sum(IF(brand='PREPAID',hits,0)) pre, sum(IF(brand='TM',hits,0)) tnt, sum(IF(brand='TATTOO',hits,0)) bro, sum(hits) total
   from   ctmv6_mt_mins a
   where  tx_date = p_trandate
   and    carrier = 'GLOBE' 
   group  by tx_date;
  
   drop temporary table if exists tmp_ctm_registered;
   SELECT 'Globe' Carrier, vTotalHits, vTotalUniq;

end;
//

delimiter ;


delimiter //

drop procedure IF EXISTS sp_generate_ctmv6_stats_smart//

CREATE PROCEDURE sp_generate_ctmv6_stats_smart(p_trandate varchar(10))
begin
   declare vPattern   Varchar(120);
   declare vPostHits  int;
   declare vPostUniq  int;
   declare vTnTHits   int;
   declare vTnTUniq   int;
   declare vBroHits   int;
   declare vBroUniq   int;
   declare vTotalHits int;
   declare vTotalUniq int;

   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   -- SMART
   SET vPostHits  = 0;
   SET vPostUniq  = 0;
   SET vTnTHits   = 0;
   SET vTnTUniq   = 0;
   SET vBroHits   = 0;
   SET vBroUniq   = 0;
   SET vTotalHits = 0;
   SET vTotalUniq = 0;

   delete from ctmv6_stats_dtl where carrier='smart' and tran_dt = p_trandate and type in ('hits', 'mt', 'uniq_charged', 'uniq_nonreg');
   delete from ctmv6_mt_mins where carrier='SMART' and tx_date = p_trandate;

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
            SET @vSql = concat('select count(1) INTO @PostHits from sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') and gsm_num REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
   
            SET @vSql = concat('select count(distinct gsm_num) INTO @PostUniq from sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') and gsm_num REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('insert ignore into ctmv6_mt_mins (phone, carrier, brand, tx_date, hits) select gsm_num, ''SMART'', ''POSTPAID'', datesent, count(1) from sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and status = ''Delivered'' and csg_tariff=''FREE'' and gsm_num REGEXP ''', vPattern, ''' group by gsm_num, datesent');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
   
            SET vPostHits = vPostHits + @PostHits;
            SET vPostUniq = vPostUniq + @PostUniq;
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
            SET @vSql = concat('select count(1) INTO @TnTHits from sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') and gsm_num REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
   
            SET @vSql = concat('select count(distinct gsm_num) INTO @TnTUniq from sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') and gsm_num REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('insert ignore into ctmv6_mt_mins (phone, carrier, brand, tx_date, hits) select gsm_num, ''SMART'', ''TNT'', datesent, count(1) from sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and status = ''Delivered'' and csg_tariff=''FREE'' and gsm_num REGEXP ''', vPattern, ''' group by gsm_num, datesent');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vTnTHits = vTnTHits + @TnTHits;
            SET vTnTUniq = vTnTUniq + @TnTUniq;

         end if;
      UNTIL done_p
      END REPEAT;
   END;

   BEGIN
      declare done_p int default 0;
      declare c_pat cursor for select pattern
                               from  mobile_pattern
                               where operator = 'SMART'
                               and sim_type = 'BRO';
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern;
         if not done_p then
            SET @vSql = concat('select count(1) INTO @BroHits from sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') and gsm_num REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
   
            SET @vSql = concat('select count(distinct gsm_num) INTO @BroUniq from sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') and gsm_num REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
   
            SET @vSql = concat('insert ignore into ctmv6_mt_mins (phone, carrier, brand, tx_date, hits) select gsm_num, ''SMART'', ''BRO'', datesent, count(1) from sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and status = ''Delivered'' and csg_tariff=''FREE'' and gsm_num REGEXP ''', vPattern, ''' group by gsm_num, datesent');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
   
            SET vBroHits = vBroHits + @BroHits;
            SET vBroUniq = vBroUniq + @BroUniq;

         end if;
      UNTIL done_p
      END REPEAT;
   END;

   SET @vSql = concat('select count(1) INTO @TotalHits from sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET @vSql = concat('select count(distinct gsm_num) INTO @TotalUniq from sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
         
   SET vTotalHits = @TotalHits;
   SET vTotalUniq = @TotalUniq;
   
   SET @vSql = concat('insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, total) values (''', p_trandate ,''',''smart'',''hits'',', vPostHits, ',', vTotalHits-(vPostHits+vTnTHits+vBroHits), ',', vTnTHits, ',', vBroHits, ',', vTotalHits, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET @vSql = concat('insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, total) values (''', p_trandate ,''',''smart'',''uniq_charged'',', vPostUniq, ',', vTotalUniq-(vPostUniq+vTnTUniq+vBroUniq), ',', vTnTUniq, ',', vBroUniq, ',', vTotalUniq, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @vSql = concat('insert ignore into ctmv6_mt_mins (phone, carrier, brand, tx_date, hits) select gsm_num, ''SMART'', ''PREPAID'', datesent, count(1) from sms_out a where datesent=''', p_trandate ,''' and operator = ''SMART'' and status = ''Delivered'' and csg_tariff=''FREE'' and not exists (select 1 from ctmv6_mt_mins b where a.gsm_num = b.phone and a.datesent=b.tx_date) group by gsm_num, datesent');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- create temporary table for validation against ctm registrations..
   create temporary table if not exists tmp_ctm_registered (msisdn varchar(30) not null, primary key (msisdn)); 
   truncate table tmp_ctm_registered;
   insert into tmp_ctm_registered select msisdn from ctm_registration where msisdn is not null and msisdn like '63%' and reg_date < p_trandate group by msisdn;

   insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, total) 
   select tx_date, 'smart', 'uniq_nonreg', sum(IF(brand='POSTPAID',1,0)) post, sum(IF(brand='PREPAID',1,0)) pre, sum(IF(brand='TNT',1,0)) tnt, sum(IF(brand='BRO',1,0)) bro, count(1) total
   from   ctmv6_mt_mins a
   where  tx_date = p_trandate
   and    carrier = 'SMART' 
   and    not exists (select 1 from tmp_ctm_registered b where a.phone = b.msisdn)
   group  by tx_date;

   insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, total) 
   select tx_date, 'smart', 'mt', sum(IF(brand='POSTPAID',hits,0)) post, sum(IF(brand='PREPAID',hits,0)) pre, sum(IF(brand='TNT',hits,0)) tnt, sum(IF(brand='BRO',hits,0)) bro, sum(hits) total
   from   ctmv6_mt_mins a
   where  tx_date = p_trandate
   and    carrier = 'SMART' 
   group  by tx_date;
   
   drop temporary table if exists tmp_ctm_registered;
   SELECT 'Smart' Carrier, vTotalHits, vTotalUniq;


end;
//

delimiter ;


delimiter //

drop procedure IF EXISTS sp_generate_ctmv6_stats_sun//

CREATE PROCEDURE sp_generate_ctmv6_stats_sun(p_trandate varchar(10))
begin
   declare vPattern   Varchar(120);
   declare vPostHits  int;
   declare vPostUniq  int;
   declare vTotalHits int;
   declare vTotalUniq int;

   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   -- SUN
   SET vPostHits  = 0;
   SET vPostUniq  = 0;
   SET vTotalHits = 0;
   SET vTotalUniq = 0;

   delete from ctmv6_stats_dtl where carrier='sun' and tran_dt = p_trandate and type in ('hits', 'mt', 'uniq_charged', 'uniq_nonreg');
   delete from ctmv6_mt_mins where carrier='SUN' and tx_date = p_trandate;

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
            SET @vSql = concat('select count(1) INTO @PostHits from sms_out where datesent=''', p_trandate ,''' and operator = ''SUN'' and status IN (''Delivered'',''Charged'') and tariff = ''123000030'' and svc_desc = ''01000001C'' and gsm_num REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
   
            SET @vSql = concat('select count(distinct gsm_num) INTO @PostUniq from sms_out where datesent=''', p_trandate ,''' and operator = ''SUN'' and status IN (''Delivered'',''Charged'') and tariff = ''123000030'' and svc_desc = ''01000001C'' and gsm_num REGEXP ''', vPattern, '''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('insert ignore into ctmv6_mt_mins (phone, carrier, brand, tx_date, hits) select gsm_num, ''SUN'', ''POSTPAID'', datesent, count(1) from sms_out where datesent=''', p_trandate ,''' and operator = ''SUN'' and status = ''Delivered'' and csg_tariff=''FREE'' and gsm_num REGEXP ''', vPattern, ''' group by gsm_num, datesent');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vPostHits = vPostHits + @PostHits;
            SET vPostUniq = vPostUniq + @PostUniq;
         end if;
      UNTIL done_p
      END REPEAT;
   END;
   
   SET @vSql = concat('select count(1) INTO @TotalHits from sms_out where datesent=''', p_trandate ,''' and operator = ''SUN'' and status IN (''Delivered'',''Charged'') and tariff = ''123000030'' and svc_desc = ''01000001C'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET @vSql = concat('select count(distinct gsm_num) INTO @TotalUniq from sms_out where datesent=''', p_trandate ,''' and operator = ''SUN'' and status IN (''Delivered'',''Charged'') and tariff = ''123000030'' and svc_desc = ''01000001C'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   
   SET vTotalHits = @TotalHits;
   SET vTotalUniq = @TotalUniq;
   
   SET @vSql = concat('insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, total) values (''', p_trandate ,''',''sun'',''hits'',', vPostHits, ',', vTotalHits-vPostHits, ',', vTotalHits, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET @vSql = concat('insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, total) values (''', p_trandate ,''',''sun'',''uniq_charged'',', vPostUniq, ',', vTotalUniq-vPostUniq, ',', vTotalUniq, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @vSql = concat('insert ignore into ctmv6_mt_mins (phone, carrier, brand, tx_date, hits) select gsm_num, ''SUN'', ''PREPAID'', datesent, count(1) from sms_out a where datesent=''', p_trandate ,''' and operator = ''SUN'' and status = ''Delivered'' and csg_tariff=''FREE'' and not exists (select 1 from ctmv6_mt_mins b where a.gsm_num = b.phone and a.datesent=b.tx_date) group by gsm_num, datesent');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- create temporary table for validation against ctm registrations..
   create temporary table if not exists tmp_ctm_registered (msisdn varchar(30) not null, primary key (msisdn)); 
   truncate table tmp_ctm_registered;
   insert into tmp_ctm_registered select msisdn from ctm_registration where msisdn is not null and msisdn like '63%' and reg_date < p_trandate group by msisdn;

   insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, total) 
   select tx_date, 'sun', 'uniq_nonreg', sum(IF(brand='POSTPAID',1,0)) post, sum(IF(brand='PREPAID',1,0)) pre, 0 tnt, 0 bro, count(1) total
   from   ctmv6_mt_mins a
   where  tx_date = p_trandate
   and    carrier = 'SUN' 
   and    not exists (select 1 from tmp_ctm_registered b where a.phone = b.msisdn)
   group  by tx_date;

   insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, total) 
   select tx_date, 'sun', 'mt', sum(IF(brand='POSTPAID',hits,0)) post, sum(IF(brand='PREPAID',hits,0)) pre, 0 tnt, 0 bro, sum(hits) total
   from   ctmv6_mt_mins a
   where  tx_date = p_trandate
   and    carrier = 'SUN' 
   group  by tx_date;
   
   drop temporary table if exists tmp_ctm_registered;
   SELECT 'Sun' Carrier, vTotalHits, vTotalUniq;


end;
//

delimiter ;





DROP PROCEDURE sp_generate_active_mins;
delimiter //

CREATE PROCEDURE sp_generate_active_mins(p_trandate date)
begin
   declare vPattern, vCarrier, vSimType Varchar(120);

   delete from ctmv6_active_mins where tx_date = p_trandate;
   insert ignore into ctmv6_active_mins (phone, carrier, brand, country, tx_date, hits) 
   select suffix, null, null, null, datesent, count(1) 
   from  sms_out a 
   where datesent=p_trandate
   and   status IN ('Delivered','Charged')
   group by suffix, datesent;

   update ctmv6_active_mins set carrier = 'PC', brand='PC' where tx_date = p_trandate and phone like '00%' and carrier is null;
   update ctmv6_active_mins set carrier = 'SOCNET', brand='SOCNET' where tx_date = p_trandate and phone like '08%' and carrier is null;

   BEGIN
      declare done_p int default 0;
      declare c_pat cursor for select pattern, operator, sim_type
                               from  mobile_pattern
                               where operator in ('SUN', 'GLOBE', 'SMART')
                               order by operator, sim_type, pattern;
      declare continue handler for sqlstate '02000' set done_p = 1;

      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern, vCarrier, vSimType;
         if not done_p then
            SET @vSql = concat('update ctmv6_active_mins set carrier=''', vCarrier ,''', brand=''', vSimType, ''', country=''PHILIPPINES'' where tx_date =''', p_trandate, ''' and phone REGEXP ''', vPattern, ''' and carrier is null');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
         end if;
      UNTIL done_p
      END REPEAT;
   END;
   
   BEGIN
      declare done_p int default 0;
      declare c_pat cursor for select pattern, operator
                               from  number_ranges
                               where operator in ('SUN', 'GLOBE', 'SMART')
                               order by operator, pattern;
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern, vCarrier;
         if not done_p then
            SET @vSql = concat('update ctmv6_active_mins set carrier=''', vCarrier ,''', brand=''PREPAID'', country=''PHILIPPINES'' where tx_date =''', p_trandate, ''' and phone REGEXP ''', vPattern, ''' and carrier is null');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
         end if;
      UNTIL done_p
      END REPEAT;
   END;

   BEGIN
      declare done_p int default 0;
      declare c_pat cursor for select pattern, operator, sim_type
                               from  mobile_pattern
                               where operator not in ('SUN', 'GLOBE', 'SMART')
                               order by operator, sim_type, pattern;
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern, vCarrier, vSimType;
         if not done_p then
            SET @vSql = concat('update ctmv6_active_mins set country=''', vCarrier ,''', brand=''ALL'' where tx_date =''', p_trandate, ''' and phone REGEXP ''', vPattern, ''' and country is null');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
         end if;
      UNTIL done_p
      END REPEAT;
   END;

   delete from ctmv6_stats_dtl where tran_dt = p_trandate and type in ('active_carrier', 'active_country');
   insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, total) 
   select tx_date, carrier, 'active_carrier', sum(IF(brand='POSTPAID',1,0)) post, sum(IF(brand='PREPAID',1,0)) pre, sum(IF(brand='TM',1,IF(brand='TNT',1,0))) tnt, sum(IF(brand='BRO',1,IF(brand='TATTOO',1,0))) bro, count(1) total
   from   ctmv6_active_mins a
   where  tx_date = p_trandate
   and    carrier in ('SUN', 'SMART', 'GLOBE', 'PC', 'SOCNET') 
   and    carrier is not null 
   group  by tx_date, carrier;

   insert into ctmv6_stats_dtl (tran_dt, carrier, type, others, total) 
   select tx_date, 'INTL', 'active_carrier', sum(total), sum(total) from (
   select tx_date, count(1) total
   from   ctmv6_active_mins a
   where  tx_date = p_trandate
   and    carrier is null
   and    country is not null
   union all
   select tx_date, count(1) total
   from   ctmv6_active_mins a
   where  tx_date = p_trandate
   and    carrier is null
   and    brand is null
   and    country is null ) t1;

   insert into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, total) 
   select tx_date, country, 'active_country', 0 post, 0 pre, 0 tnt, 0 bro, count(1) total
   from   ctmv6_active_mins a
   where  tx_date =  p_trandate
   and    country is not null 
   group  by tx_date, country;
end;
//

delimiter ;





CREATE TABLE ussd_log (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  tran_id bigint(20) NOT NULL DEFAULT '0',
  a_no varchar(12) DEFAULT NULL,
  b_no varchar(12) DEFAULT '',
  access_code varchar(30) DEFAULT '',
  msg varchar(16) DEFAULT NULL,
  status tinyint(3) unsigned NOT NULL DEFAULT '0',
  datein date NOT NULL DEFAULT '0000-00-00',
  timein time NOT NULL DEFAULT '00:00:00',
  src varchar(16) DEFAULT NULL,
  charged int(1) DEFAULT '0',
  PRIMARY KEY (id),
  UNIQUE KEY access_code (access_code,tran_id),
  KEY a_b_no_idx (datein,a_no,b_no)
);

CREATE TABLE ussd_users (
  a_no varchar(12) NOT NULL DEFAULT '',
  b_no varchar(12) NOT NULL DEFAULT '',
  datein date NOT NULL DEFAULT '0000-00-00',
  timein time NOT NULL DEFAULT '00:00:00',
  PRIMARY KEY (a_no,b_no)
);

CREATE TABLE ussd_log_hist (
  id bigint(20) NOT NULL DEFAULT '0',
  tran_id bigint(20) NOT NULL DEFAULT '0',
  a_no varchar(12) DEFAULT NULL,
  b_no varchar(12) DEFAULT '',
  access_code varchar(30) DEFAULT '',
  msg varchar(16) DEFAULT NULL,
  status tinyint(3) unsigned NOT NULL DEFAULT '0',
  datein date NOT NULL DEFAULT '0000-00-00',
  timein time NOT NULL DEFAULT '00:00:00',
  src varchar(16) DEFAULT NULL,
  charged int(1) DEFAULT '0',
  UNIQUE KEY access_code (access_code,tran_id),
  KEY a_b_no_idx (datein,a_no,b_no)
);

CREATE TABLE ussd_stats (
  datein date NOT NULL DEFAULT '0000-00-00',
  ussd_hits int(11) NOT NULL DEFAULT '0',
  ussd_cerr int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (datein)
);

DROP PROCEDURE sp_generate_ussd_log;
delimiter //

CREATE PROCEDURE sp_generate_ussd_log(p_trandate date)
begin

   delete from ussd_users;
   delete from ussd_log;
   insert into ussd_users
   select phone a_no, right(access_code, 12) b_no, min(datein), min(timein)
   from   smsgw_in
   where  datein=p_trandate
   and    access_code like '*555*9%'
   group  by a_no, b_no;

   begin
      declare done_p int default 0;
      declare vA_No, vB_No varchar(30);
      declare c_pat cursor for select a_no, b_no
                               from   ussd_users
                               where  datein = p_trandate
                               order  by a_no, b_no;
      declare continue handler for sqlstate '02000' set done_p = 1;

      set session tmp_table_size = 268435456;
      set session max_heap_table_size = 268435456;
      set session sort_buffer_size = 104857600;
      set session read_buffer_size = 8388608;

      OPEN c_pat;
      REPEAT
         FETCH c_pat into vA_No, vB_No;
         if not done_p then
            insert ignore into ussd_log
            select null, id, right(access_code, 12) b_no, phone a_no, access_code, left(replace(msg, '\n', ''), 16) msg, status, datein, timein, 'smsgw_in' src, 0 from smsgw_in where datein=p_trandate and phone=vA_No and status=2 and access_code like concat('%',vB_No) union
            select null, id, right(access_code, 12) b_no, phone a_no, access_code, left(replace(msg, '\n', ''), 16) msg, status, datein, timein, 'smsgw_in' src, 0 from smsgw_in where datein=p_trandate and phone=vB_No and status=2 and access_code like concat('%',vA_No) union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_smart', 0 from  smart_bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vA_No and status=2 and recipient=vB_No union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_smart', 0 from  smart_bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vB_No and status=2 and recipient=vA_No union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_globe', 0 from  globe_bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vA_No and status=2 and recipient=vB_No union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_globe', 0 from  globe_bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vB_No and status=2 and recipient=vA_No union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_sun', 0 from  sun_bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vA_No and status=2 and recipient=vB_No union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_sun', 0 from  sun_bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vB_No and status=2 and recipient=vA_No order by datein, timein;
         end if;
      UNTIL done_p
      END REPEAT;

   end;


   begin
      declare nCharged, nFree, done_i int default 0;
      declare vA_No, vB_No varchar(30);
      declare c_pat_i cursor for select a_no, b_no
                                 from   ussd_users
                                 where  datein = p_trandate
                                 order  by a_no, b_no;
      declare continue handler for sqlstate '02000' set done_i = 1;

      OPEN c_pat_i;
      REPEAT
         FETCH c_pat_i into vA_No, vB_No;
         if not done_i then
            SET @USSDFlag = 0;
            SET @WEBFlag  = 0;
            begin
               declare cID, done_j int default 0;
               declare cA_No, cB_No, cSrc, cDatein, cTimein  varchar(30);
               declare c_pat_j cursor for select id, a_no, b_no, access_code, datein, timein
                                          from   ussd_log
                                          where  datein = p_trandate
                                          and    a_no = vA_No and b_no = vB_No union
                                          select id, a_no, b_no, access_code, datein, timein
                                          from   ussd_log
                                          where  datein = p_trandate
                                          and    a_no = vB_No and b_no = vA_No
                                          order  by datein, timein;
               declare continue handler for sqlstate '02000' set done_j = 1;
               OPEN c_pat_j;
               REPEAT
                  FETCH c_pat_j into cID, cA_No, cB_No, cSrc, cDatein, cTimein;
                  if not done_j then
                     if (@USSDFlag = 1) and (cSrc like '2814%' or cSrc = 'mobile') and (cA_No=vB_No) then

                            UPDATE ussd_log SET charged=1 WHERE id = cID;
                            if exists (select 1 from sms_out where datesent=cDatein and gsm_num=vB_No and gateway_id like '%CAPI' and timesent between right(date_sub(concat(cDatein, ' ', cTimein), interval 120 second),8) and cTimein and status in ('Delivered','Charged') and csg_tariff <> 'FREE' limit 1) then
                              UPDATE ussd_log SET charged=2 WHERE id = cID;
                            end if;

                     else

                        if (@USSDFlag = 1) and (cSrc = 'mobile') and (cA_No=vA_No) then
                           SET @USSDFlag = 1;
                        elseif cSrc like '*555*%' then
                           SET @USSDFlag = 1;
                        else
                           SET @USSDFlag = 0;
                        end if;
                     end if;

                  end if;
               UNTIL done_j
               END REPEAT;
            end;
         end if;
      UNTIL done_i
      END REPEAT;
   end;

   insert ignore into ussd_log_hist
   select * from ussd_log a
   where exists (select 1 from ussd_log b where a.datein = b.datein and a.a_no=b.a_no and a.b_no=b.b_no and b.charged > 0 );

   insert ignore into ussd_stats (datein, ussd_hits, ussd_cerr)
   select datein, sum(IF(charged=2, 1, 0)), sum(IF(charged=1, 1, 0))
   from ussd_log
   group by datein;

   insert ignore into ussd_users_hist (a_no, b_no, datein, timein)
   select a_no, b_no, datein, timein
   from ussd_users;

   delete from ctmv6_stats_dtl where tran_dt = p_trandate and type like 'ussd%' and type not like 'ussd_118%';
   insert ignore into ctmv6_stats_dtl (tran_dt, carrier, type, total)
   select datein, 'smart', 'ussd', ussd_hits
   from   ussd_stats
   where  datein = p_trandate;

   insert ignore into ctmv6_stats_dtl (tran_dt, carrier, type, total)
   select datein, 'smart', 'ussdmt', count(*) 
   from   smsgw_in 
   where  access_code like '*555*%' 
   and    datein=p_trandate;

end;
//
delimiter ;




drop procedure sp_generate_ussd_118_log;
delimiter //
create procedure sp_generate_ussd_118_log (p_trandate date) 
begin
   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   delete from ussd_118_users;
   delete from ussd_118_log;
   insert into ussd_118_users
   select phone a_no, right(access_code, 12) b_no, min(datein), min(timein)
   from   smsgw_in
   where  datein=p_trandate
   and    access_code like '*118*%'
   group  by a_no, b_no;

   begin
      declare done_p int default 0;
      declare vA_No, vB_No varchar(30);
      declare c_pat cursor for select a_no, b_no
                               from   ussd_118_users
                               where  datein = p_trandate
                               order  by a_no, b_no;
      declare continue handler for sqlstate '02000' set done_p = 1;

      set session tmp_table_size = 268435456;
      set session max_heap_table_size = 268435456;
      set session sort_buffer_size = 104857600;
      set session read_buffer_size = 8388608;

      OPEN c_pat;
      REPEAT
         FETCH c_pat into vA_No, vB_No;
         if not done_p then
            insert ignore into ussd_118_log
            select null, id, right(access_code, 12) a_no, phone b_no, access_code, left(replace(msg, '\n', ''), 16) msg, status, datein, timein, 'smsgw_in' src, 0 from smsgw_in where datein=p_trandate and phone=vA_No and status=2 and access_code like concat('%',vB_No) union
            select null, id, right(access_code, 12) a_no, phone b_no, access_code, left(replace(msg, '\n', ''), 16) msg, status, datein, timein, 'smsgw_in' src, 0 from smsgw_in where datein=p_trandate and phone=vB_No and status=2 and access_code like concat('%',vA_No) union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_smart', 0 from  smart_bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vA_No and status=2 and recipient=vB_No union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_smart', 0 from  smart_bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vB_No and status=2 and recipient=vA_No union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_globe', 0 from  globe_bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vA_No and status=2 and recipient=vB_No union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_globe', 0 from  globe_bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vB_No and status=2 and recipient=vA_No union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_sun', 0 from  sun_bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vA_No and status=2 and recipient=vB_No union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_sun', 0 from  sun_bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vB_No and status=2 and recipient=vA_No order by datein, timein;
         end if;
      UNTIL done_p
      END REPEAT;

   end;


   begin
      declare nCharged, nFree, done_i int default 0;
      declare vA_No, vB_No varchar(30);
      declare c_pat_i cursor for select a_no, b_no
                                 from   ussd_118_users
                                 where  datein = p_trandate
                                 order  by a_no, b_no;
      declare continue handler for sqlstate '02000' set done_i = 1;

      OPEN c_pat_i;
      REPEAT
         FETCH c_pat_i into vA_No, vB_No;
         if not done_i then
            SET @USSDFlag = 0;
            SET @WEBFlag  = 0;
            begin
               declare cID, done_j int default 0;
               declare cA_No, cB_No, cSrc, cDatein, cTimein  varchar(30);
               declare c_pat_j cursor for select id, a_no, b_no, access_code, datein, timein
                                          from   ussd_118_log
                                          where  datein = p_trandate
                                          and    a_no = vA_No and b_no = vB_No union
                                          select id, a_no, b_no, access_code, datein, timein
                                          from   ussd_118_log
                                          where  datein = p_trandate
                                          and    a_no = vB_No and b_no = vA_No
                                          order  by datein, timein;
               declare continue handler for sqlstate '02000' set done_j = 1;
               OPEN c_pat_j;
               REPEAT
                  FETCH c_pat_j into cID, cA_No, cB_No, cSrc, cDatein, cTimein;
                  if not done_j then
                     if (@USSDFlag = 1) and (cSrc like '2814%' or cSrc = 'mobile') and (cA_No=vB_No) then

                            UPDATE ussd_118_log SET charged=1 WHERE id = cID;
                            -- if exists (select 1 from sms_out where datesent=cDatein and gsm_num=vB_No and gateway_id like '%CAPI' and timesent between right(date_sub(concat(cDatein, ' ', cTimein), interval 120 second),8) and cTimein and status in ('Delivered','Charged') and csg_tariff <> 'FREE' limit 1) then
                            if exists (select 1 from sms_out where datesent=cDatein and gsm_num=vB_No and timesent between right(date_sub(concat(cDatein, ' ', cTimein), interval 120 second),8) and cTimein and status in ('Delivered','Charged') limit 1) then
                              UPDATE ussd_118_log SET charged=2 WHERE id = cID;
                            end if;

                     else

                        if (@USSDFlag = 1) and (cSrc = 'mobile') and (cA_No=vA_No) then
                           SET @USSDFlag = 1;
                        elseif cSrc like '*118*%' then
                           SET @USSDFlag = 1;
                        else
                           SET @USSDFlag = 0;
                        end if;
                     end if;

                  end if;
               UNTIL done_j
               END REPEAT;
            end;
         end if;
      UNTIL done_i
      END REPEAT;
   end;

   insert ignore into ussd_118_log_hist
   select * from ussd_118_log a
   where exists (select 1 from ussd_118_log b where a.datein = b.datein and a.a_no=b.a_no and a.b_no=b.b_no and b.charged > 0 );

   insert ignore into ussd_118_stats (datein, ussd_hits, ussd_cerr)
   select datein, sum(IF(charged=2, 1, 0)), sum(IF(charged=1, 1, 0))
   from ussd_118_log
   group by datein;

   insert ignore into ussd_118_users_hist (a_no, b_no, datein, timein)
   select a_no, b_no, datein, timein
   from ussd_118_users;

   delete from ctmv6_stats_dtl where tran_dt = p_trandate and type like 'ussd_118%';
   insert ignore into ctmv6_stats_dtl (tran_dt, carrier, type, total)
   select datein, 'smart', 'ussd_118', ussd_hits
   from   ussd_118_stats
   where  datein = p_trandate;

   insert ignore into ctmv6_stats_dtl (tran_dt, carrier, type, total)
   select datein, 'smart', 'ussd_118_mt', count(*)
   from   smsgw_in
   where  access_code like '*118*%'
   and    datein=p_trandate;

end;
//

delimiter ;


















##### RUNS @CARTMAN
##### RUNS @CARTMAN
##### RUNS @CARTMAN

source db & tables: ctm_registration

CREATE TABLE ctmv6_stats_dtl (
  tran_dt date NOT NULL,
  carrier varchar(30) NOT NULL,
  type varchar(30) NOT NULL,
  post int(8) NOT NULL DEFAULT 0,
  pre int(8) NOT NULL DEFAULT 0,
  tm_tnt int(8) NOT NULL DEFAULT 0,
  tat_bro int(8) NOT NULL DEFAULT 0,
  others int(8) NOT NULL DEFAULT 0,
  total int default 0,
  PRIMARY KEY (tran_dt,carrier,type)
);

delimiter //
DROP PROCEDURE sp_ctmv6_generate_stats//
CREATE PROCEDURE sp_ctmv6_generate_stats()
begin
   call sp_ctmv6_regenerate_stats( date_sub(curdate(), interval 1 day) );
end;
//
delimiter ;

grant select on ctmv6_stats.* to ctmv6@10.100.1.4 identified by 'ctmv6';
grant select on ctmv6.ctmv6_stats_log to ctmv6@10.100.1.4;
grant execute on procedure ctmv6.sp_ctmv6_generate_stats to ctmv6@10.100.1.4;
grant execute on procedure ctmv6.sp_ctmv6_generate_stats to ctmv6@localhost identified by 'ctmv6';
flush privileges;

delimiter //
DROP PROCEDURE sp_ctmv6_registration_stats//
CREATE PROCEDURE sp_ctmv6_registration_stats(p_trandate varchar(10))
begin
   insert ignore into ctm_registration (ctm_accnt, reg_app, reg_src, reg_sn_id, email_add, country, msisdn, msisdn_type, msisdn_carrier, reg_date, reg_time, is_migrated)
   select ctm_accnt, reg_app, reg_src, reg_sn_id, email_add, country, msisdn, msisdn_type, msisdn_carrier, reg_date, reg_time, 0 
   from   ctmv6.ctm_registration a where reg_date >= p_trandate;

   update ctm_registration a 
   set    is_migrated = 1 
   where  reg_date = p_trandate
   and    exists (select 1 from ctmv6.migrate_user b where a.ctm_accnt = b.v6_username and b.is_migrated = 1);


   CREATE TEMPORARY TABLE IF NOT EXISTS ctmv6_stats_log (
     tran_dt date NOT NULL,
     carrier varchar(30) NOT NULL,
     type varchar(30) NOT NULL,
     post int(8) NOT NULL DEFAULT '0',
     pre int(8) NOT NULL DEFAULT '0',
     tm_tnt int(8) NOT NULL DEFAULT '0',
     tat_bro int(8) NOT NULL DEFAULT '0',
     others int(8) NOT NULL DEFAULT '0',
     total int(11) DEFAULT '0'
   );
   truncate table ctmv6_stats_log; 

   insert into ctmv6_stats_log select reg_date, 'globe' carrier, 'reg_carrier' type, count(1) post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='GLOBE' and msisdn_type = 'POSTPAID' group by 1,2,3;
   insert into ctmv6_stats_log select reg_date, 'globe', 'reg_carrier', 0 post, count(1) pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='GLOBE' and msisdn_type = 'PREPAID' group by 1,2,3;
   insert into ctmv6_stats_log select reg_date, 'globe', 'reg_carrier', 0 post, 0 pre, count(1) tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='GLOBE' and msisdn_type = 'TM' group by 1,2,3;
   insert into ctmv6_stats_log select reg_date, 'globe', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = p_trandate and msisdn_carrier='GLOBE' group by 1,2,3;
   insert into ctmv6_stats_log select p_trandate, 'globe', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total ;
   insert into ctmv6_stats_log select reg_date, 'smart', 'reg_carrier', count(1) post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='SMART' and msisdn_type = 'POSTPAID' group by 1,2,3;
   insert into ctmv6_stats_log select reg_date, 'smart', 'reg_carrier', 0 post, count(1) pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='SMART' and msisdn_type = 'PREPAID' group by 1,2,3;
   insert into ctmv6_stats_log select reg_date, 'smart', 'reg_carrier', 0 post, 0 pre, count(1) tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='SMART' and msisdn_type = 'TNT' group by 1,2,3;
   insert into ctmv6_stats_log select reg_date, 'smart', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = p_trandate and msisdn_carrier='SMART' group by 1,2,3;
   insert into ctmv6_stats_log select p_trandate, 'smart', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total ;
   insert into ctmv6_stats_log select reg_date, 'sun', 'reg_carrier', count(1) post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='SUN' and msisdn_type = 'POSTPAID' group by 1,2,3;
   insert into ctmv6_stats_log select reg_date, 'sun', 'reg_carrier', 0 post, count(1) pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='SUN' and msisdn_type = 'PREPAID' group by 1,2,3;
   insert into ctmv6_stats_log select reg_date, 'sun', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = p_trandate and msisdn_carrier='SUN' group by 1,2,3;
   insert into ctmv6_stats_log select p_trandate, 'sun', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total;
   insert into ctmv6_stats_log select reg_date, reg_app, 'reg_sn', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = p_trandate and reg_app is not null group by 1,2,3;
   insert into ctmv6_stats_log select p_trandate, 'facebook', 'reg_sn', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total;
   insert into ctmv6_stats_log select p_trandate, 'googleplus', 'reg_sn', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total;
   insert into ctmv6_stats_log select p_trandate, 'linkedin', 'reg_sn', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total;
   insert into ctmv6_stats_log select p_trandate, 'twitter', 'reg_sn', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total;
   insert into ctmv6_stats_log select reg_date, country, 'reg_country', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = p_trandate and country is not null group by 1,2,3;
   insert into ctmv6_stats_log select p_trandate, operator, 'reg_country', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from mobile_pattern where operator <> 'SMART' and operator <> 'SUN' and operator <> 'GLOBE' group by operator;
   insert into ctmv6_stats_log select reg_date, reg_src, 'reg_device', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = p_trandate and reg_src is not null group by 1,2,3;
   insert into ctmv6_stats_log select p_trandate, 'android', 'reg_device', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total;
   insert into ctmv6_stats_log select p_trandate, 'ios', 'reg_device', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total;
   insert into ctmv6_stats_log select p_trandate, 'web', 'reg_device', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total;

   insert into ctmv6_stats_log (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, others, total )
   select reg_date, lower(msisdn_carrier) carrier, 'reg_mig' type, sum(IF(msisdn_type='POSTPAID',1,0)) post, 
          sum(IF(msisdn_type='PREPAID',1,0)) pre, sum(IF(msisdn_type='TM',1,IF(msisdn_type='TNT',1,0))) tm_tnt, 
          sum(IF(msisdn_type='BRO',1,IF(msisdn_type='TATTOO',1,0))) tat_bro, 0 others, count(1) total 
   from   ctm_registration 
   where  reg_date = p_trandate
   and    is_migrated = 1 
   and    msisdn_carrier is not null
   group  by reg_date, 2;

   insert into ctmv6_stats_log (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, others, total )
   select reg_date, 'pc' carrier, 'reg_mig' type, 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total 
   from   ctm_registration 
   where  reg_date = p_trandate
   and    is_migrated = 1 
   and    ctm_accnt like '00%'
   group  by reg_date;

   insert into ctmv6_stats_log select p_trandate, 'globe', 'reg_mig', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total;
   insert into ctmv6_stats_log select p_trandate, 'smart', 'reg_mig', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total;
   insert into ctmv6_stats_log select p_trandate, 'sun', 'reg_mig', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total;
   insert into ctmv6_stats_log select p_trandate, 'pc', 'reg_mig', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total;

   delete from ctmv6_stats_dtl where tran_dt = p_trandate and type like 'reg%';
   insert ignore into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, others, total) 
   select tran_dt, carrier, type, sum(post), sum(pre), sum(tm_tnt), sum(tat_bro), sum(others), sum(total) from ctmv6_stats_log group by 1,2,3;

   DROP TEMPORARY TABLE IF EXISTS ctmv6_stats_log;

end;
//
delimiter ;



##### RUNS @ARSENIC
##### RUNS @ARSENIC
##### RUNS @ARSENIC

mysql -uroot -p -h127.0.0.1 -P3310
source db & tables: dmp_applogs_logins

CREATE TABLE ctmv6_stats_dtl (
  tran_dt date NOT NULL,
  carrier varchar(30) NOT NULL,
  type varchar(30) NOT NULL,
  post int(8) NOT NULL DEFAULT 0,
  pre int(8) NOT NULL DEFAULT 0,
  tm_tnt int(8) NOT NULL DEFAULT 0,
  tat_bro int(8) NOT NULL DEFAULT 0,
  others int(8) NOT NULL DEFAULT 0,
  total int default 0,
  PRIMARY KEY (tran_dt,carrier,type)
);

DROP TABLE IF EXISTS ctmv6_daily_logins;
CREATE TABLE ctmv6_daily_logins (
  tx_date date NOT NULL,
  phone   varchar(30) NOT NULL,
  src     varchar(30) NOT NULL,
  carrier varchar(30),
  brand   varchar(30),
  PRIMARY KEY (tx_date,phone,src)
);

DROP TABLE IF EXISTS ctmv6_monthly_logins;
CREATE TABLE ctmv6_monthly_logins (
  tx_month varchar(8) NOT NULL,
  phone   varchar(30) NOT NULL,
  src     varchar(30) NOT NULL,
  carrier varchar(30),
  brand   varchar(30),
  PRIMARY KEY (tx_month,phone,src)
);

DROP TABLE IF EXISTS ctmv6_login_stats_hourly;
CREATE TABLE ctmv6_login_stats_hourly (
  tx_date date NOT NULL,
  tx_time time NOT NULL,
  src     varchar(30) NOT NULL,
  hits    int(11) default 0,
  PRIMARY KEY (tx_date,tx_time,src)
);


DROP TABLE IF EXISTS ctmv6_logins_hourly;
CREATE TABLE ctmv6_logins_hourly (
  tx_date date NOT NULL,
  tx_time time NOT NULL,
  phone   varchar(30) NOT NULL,
  src     varchar(30) NOT NULL,
  carrier varchar(30),
  brand   varchar(30),
  PRIMARY KEY (tx_date,tx_time,phone,src)
);

grant select on ctmv6_logs.ctmv6_stats_dtl to ctmv6@10.100.1.4 identified by 'ctmv6';
grant execute on ctmv6_logs.* to ctmv6@10.100.1.4 identified by 'ctmv6';
flush privileges;



GRANT EXECUTE ON PROCEDURE `test`.`sp_generate_ctmv6_stats_csg` TO 'db_monitor'@'localhost'\;
flush privileges;


---------------------------------

delimiter //
DROP PROCEDURE sp_ctmv6_login_stats//
CREATE PROCEDURE sp_ctmv6_login_stats(p_trandate date)
begin
   select count(1) into @nCheckNull from dmp_applogs_logins where datein = p_trandate and  src_type is null;
   if @nCheckNull > 0 then
      update dmp_applogs_logins set src_type = 'an-' where datein = p_trandate and src like 'an-%' and src_type is null;
      update dmp_applogs_logins set src_type = 'ios' where datein = p_trandate and src like 'ios%' and src_type is null;
      update dmp_applogs_logins set src_type = 'web' where datein = p_trandate and src like 'web%' and src_type is null;
      update dmp_applogs_logins set src_type = 'oth' where datein = p_trandate and src_type is null;
   end if;

   delete from ctmv6_daily_logins where tx_date = p_trandate;
   insert ignore into ctmv6_daily_logins (phone, tx_date, src) select ctm_accnt, datein, 'android' from dmp_applogs_logins where datein = p_trandate and src_type = 'an-';
   insert ignore into ctmv6_daily_logins (phone, tx_date, src) select ctm_accnt, datein, 'ios' from dmp_applogs_logins where datein = p_trandate and src_type = 'ios';
   insert ignore into ctmv6_daily_logins (phone, tx_date, src) select ctm_accnt, datein, 'web' from dmp_applogs_logins where datein = p_trandate and src_type = 'web';
   insert ignore into ctmv6_daily_logins (phone, tx_date, src) select ctm_accnt, datein, 'others' from dmp_applogs_logins where datein = p_trandate and src_type = 'oth';

   select count(1) into @nAnd from ctmv6_daily_logins where tx_date = p_trandate and src = 'android';
   select count(1) into @nIos from ctmv6_daily_logins where tx_date = p_trandate and src = 'ios';
   select count(1) into @nWeb from ctmv6_daily_logins where tx_date = p_trandate and src = 'web';
   select count(1) into @nOth from ctmv6_daily_logins where tx_date = p_trandate and src = 'oth';

   delete from ctmv6_stats_dtl where tran_dt = p_trandate and type = 'login';
   insert ignore into ctmv6_stats_dtl (tran_dt, carrier, type, others) values (p_trandate, 'android', 'login', @nAnd);
   insert ignore into ctmv6_stats_dtl (tran_dt, carrier, type, others) values (p_trandate, 'ios', 'login', @nIos);
   insert ignore into ctmv6_stats_dtl (tran_dt, carrier, type, others) values (p_trandate, 'web', 'login', @nWeb);
   insert ignore into ctmv6_stats_dtl (tran_dt, carrier, type, others) values (p_trandate, 'others', 'login', @nOth);

   delete from ctmv6_login_stats_hourly where tx_date = p_trandate;
   insert ignore into ctmv6_login_stats_hourly (tx_date, tx_time, src, hits )
   select datein, concat(left(timein, 2), ':00:00') timein, src_type, count(distinct ctm_accnt) hits
   from   dmp_applogs_logins
   where  datein = p_trandate
   group  by 1,2,3;

   delete from dmp_applogs_logins where datein = p_trandate;
end;
//
delimiter ;


drop procedure sp_batch_ctmv6_stats;
delimiter //
create procedure sp_batch_ctmv6_stats (p_start date, p_max int(3))
begin
   SET @nCtr = 0;
   WHILE (@nCtr < p_max) DO
      select concat('Processing for transactions ', date_add(p_start, interval @nCtr day), '...') TxProc;

      call sp_generate_ctmv6_stats_globe(vTranDate);
      call sp_generate_ctmv6_stats_smart(vTranDate);
      call sp_generate_ctmv6_stats_sun(vTranDate);
      call sp_generate_active_mins(vTranDate);
      -- end
      
      set @nCtr = @nCtr + 1;
   END WHILE;
end;
//
delimiter ;

call sp_batch_ctmv6_stats ('2014-07-01', 31);

cat ${FILEDIR}/${FILENM_DATA}.tmp | mutt "jps@tuna.ph,glenon@gmail.com" -e"my_hdr From:Raymond Soriano<jps@tuna.ph>" -s"Request Slip [${FILENM_DATA:2:10}] - PO Approval"
