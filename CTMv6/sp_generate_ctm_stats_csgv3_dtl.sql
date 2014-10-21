delimiter //

drop procedure IF EXISTS sp_generate_ctm_stats_csg//

CREATE PROCEDURE sp_generate_ctm_stats_csg()
begin
   declare vTranDate varchar(30);
   SET vTranDate  = date_sub(curdate(), interval 1 day);
   call sp_generate_ctm_stats_csgv3_dtl(vTranDate);
END;
//

delimiter ;

delimiter //

drop procedure IF EXISTS sp_generate_ctm_stats_csgv3_dtl//

CREATE PROCEDURE sp_generate_ctm_stats_csgv3_dtl(p_trandate varchar(10))
begin
   declare vSchemaOwner, vTableName, vPattern, vDatein Varchar(120);
   declare vMt, vTotalMt int default 0;
   declare vHits, vTotalHits int default 0;
   declare vHits8266, vTotalHits8266 int default 0;
   declare vHits8267, vTotalHits8267 int default 0;
   declare done int default 0;

   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   -- GLOBE
   SET vMt = 0;
   SET vTotalMt = 0;
   SET vHits = 0;
   SET vTotalHits = 0;
   SET vHits8266 = 0;
   SET vTotalHits8266 = 0;
   SET vHits8267 = 0;
   SET vTotalHits8267 = 0;
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
            SET @vSql = concat('select count(1) INTO @Hits from csgv3_v6.sms_out where datesent=''', p_trandate ,''' and operator = ''GLOBE'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') and gsm_num REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
   
            SET @vSql = concat('select count(1) INTO @Mt from csgv3_v6.sms_out where datesent=''', p_trandate ,''' and operator = ''GLOBE'' and gsm_num REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
   
            SET vMt = vMt + @Mt;
            SET vHits = vHits + @Hits;
         end if;
      UNTIL done_p
      END REPEAT;
   END;
   
   
   SET @vSql = concat('select count(1) INTO @TotalHits from csgv3_v6.sms_out where datesent=''', p_trandate ,''' and operator = ''GLOBE'' and status IN (''Delivered'',''Charged'') and (csg_tariff = ''CHG250'' or csg_tariff = ''CHG2.50'') ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET @vSql = concat('select count(1) INTO @TotalMt from csgv3_v6.sms_out where datesent=''', p_trandate ,''' and operator = ''GLOBE'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET vTotalMt = @TotalMt;
   SET vTotalHits = @TotalHits;
   
   SET @vSql = concat('insert into ctm_stats_dtl values (''', p_trandate ,''',''00:00'',''globe'',''hits'',', vHits, ',', vTotalHits - vHits, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET @vSql = concat('insert into ctm_stats_dtl values (''', p_trandate ,''',''00:00'',''globe'',''mt'',', vMt, ',', vTotalMt - vMt, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SELECT 'Globe' Carrier, vTotalHits, vHits, vTotalMt, vMt;

   -- SMART
   SET vMt = 0;
   SET vTotalMt = 0;
   SET vHits = 0;
   SET vTotalHits = 0;
   SET vHits8266 = 0;
   SET vTotalHits8266 = 0;
   SET vHits8267 = 0;
   SET vTotalHits8267 = 0;
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
            SET @vSql = concat('select count(1) INTO @Hits8266 from csgv3_v6.sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and status IN (''Delivered'',''Charged'') and tariff = ''82'' and svc_desc = ''66'' and gsm_num REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
   
            SET @vSql = concat('select count(1) INTO @Hits8267 from csgv3_v6.sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and status IN (''Delivered'',''Charged'') and tariff = ''82'' and svc_desc = ''67'' and gsm_num REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
   
            SET @vSql = concat('select count(1) INTO @Mt from csgv3_v6.sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and gsm_num REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vHits8266 = vHits8266 + @Hits8266;
            SET vHits8267 = vHits8267 + @Hits8267;
            SET vMt = vMt + @Mt;
         end if;
      UNTIL done_p
      END REPEAT;
   END;
   
   SET @vSql = concat('select count(1) INTO @TotalHits8266 from csgv3_v6.sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and status IN (''Delivered'',''Charged'') and tariff = ''82'' and svc_desc = ''66'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET @vSql = concat('select count(1) INTO @TotalHits8267 from csgv3_v6.sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' and status IN (''Delivered'',''Charged'') and tariff = ''82'' and svc_desc = ''67'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET @vSql = concat('select count(1) INTO @TotalMt from csgv3_v6.sms_out where datesent=''', p_trandate ,''' and operator = ''SMART'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET vTotalMt = @TotalMt;
   SET vTotalHits8266 = @TotalHits8266;
   SET vTotalHits8267 = @TotalHits8267;
   
   SET @vSql = concat('insert into ctm_stats_dtl values (''', p_trandate ,''',''00:00'',''smart8266'',''hits'',', vHits8266, ',', vTotalHits8266 - vHits8266, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET @vSql = concat('insert into ctm_stats_dtl values (''', p_trandate ,''',''00:00'',''smart8267'',''hits'',', vHits8267, ',', vTotalHits8267 - vHits8267, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SET @vSql = concat('insert into ctm_stats_dtl values (''', p_trandate ,''',''00:00'',''smart'',''mt'',', vMt, ',', vTotalMt - vMt, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
   SELECT 'Smart' Carrier, vTotalHits8266, vHits8266, vTotalHits8267, vHits8267, vTotalMt, vMt;

   -- SUN
   SET vMt = 0;
   SET vTotalMt = 0;
   SET vHits = 0;
   SET vTotalHits = 0;
   SET vHits8266 = 0;
   SET vTotalHits8266 = 0;
   SET vHits8267 = 0;
   SET vTotalHits8267 = 0;
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
            SET @vSql = concat('select count(1) INTO @Hits from csgv3_v6.sms_out where datesent=''', p_trandate ,''' and operator = ''SUN'' and status IN (''Delivered'',''Charged'') and tariff = ''123000030'' and svc_desc = ''01000001C'' and gsm_num REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('select count(1) INTO @Mt from  csgv3_v6.sms_out where datesent=''', p_trandate ,''' and operator = ''SUN'' and gsm_num REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vMt = vMt + @Mt;
            SET vHits = vHits + @Hits;
         end if;
      UNTIL done_p
      END REPEAT;
   END;

   SET @vSql = concat('select count(1) INTO @TotalHits from csgv3_v6.sms_out where datesent=''', p_trandate ,''' and operator = ''SUN'' and status IN (''Delivered'',''Charged'') and tariff = ''123000030'' and svc_desc = ''01000001C'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @vSql = concat('select count(1) INTO @TotalMt from csgv3_v6.sms_out where datesent=''', p_trandate ,''' and operator = ''SUN''');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET vTotalMt = @TotalMt;
   SET vTotalHits = @TotalHits;

   SET @vSql = concat('insert into ctm_stats_dtl values (''', p_trandate ,''',''00:00'',''sun'',''hits'',', vHits, ',', vTotalHits - vHits, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @vSql = concat('insert into ctm_stats_dtl values (''', p_trandate ,''',''00:00'',''sun'',''mt'',', vMt, ',', vTotalMt - vMt, ')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SELECT 'Sun' Carrier, vTotalHits, vHits, vTotalMt, vMt;

end;
//

delimiter ;

