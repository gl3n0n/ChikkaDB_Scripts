delimiter //
DROP procedure IF EXISTS sp_generate_ctm_stats//

create procedure sp_generate_ctm_stats (p_database varchar(30), p_tablename varchar(30))
begin
   declare vSchemaOwner, vTableName, vPattern, vDatein Varchar(120);
   declare vMt, vTotalMt int default 0; 
   declare vHits, vTotalHits int default 0;
   declare vHits8266, vTotalHits8266 int default 0;
   declare vHits8267, vTotalHits8267 int default 0;

   declare done int default 0;
   declare c_tab cursor for select table_schema, concat(table_schema, '.', table_name) table_name
                            from  information_schema.tables
                            where table_name like 'sms_out_%'
                            and   table_schema like p_database
                            and   table_name like p_tablename
                            order by table_schema, table_name;

   declare continue handler for sqlstate '02000' set done = 1;
   
   OPEN c_tab;
   REPEAT
   FETCH c_tab into vSchemaOwner, vTableName;
      if not done then

         SET vMt = 0;
         SET vTotalMt = 0;
         SET vHits = 0;
         SET vTotalHits = 0;
         SET vHits8266 = 0;
         SET vTotalHits8266 = 0;
         SET vHits8267 = 0;
         SET vTotalHits8267 = 0;
         if vSchemaOwner = 'balde2814_globe' then
            -- GET POSTPAID MT and HITS
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
                     SET @vSql = concat('select count(1) INTO @Hits from ', vTableName, ' where status=2 and (csg_tariff = ''CHG250'' or csg_tariff like ''CHG2.50'')   ''^', vPattern, '$''');
                     PREPARE stmt FROM @vSql;
                     EXECUTE stmt;
                     DEALLOCATE PREPARE stmt;

                     SET @vSql = concat('select count(1) INTO @Mt from ', vTableName, ' where gsm_num REGEXP ''^', vPattern, '$''');
                     PREPARE stmt FROM @vSql;
                     EXECUTE stmt;
                     DEALLOCATE PREPARE stmt;

                     SET vMt = vMt + @Mt;
                     SET vHits = vHits + @Hits;
                  end if;
               UNTIL done_p
               END REPEAT;
            END; 

            -- GET TOTAL MT and HITS
            SET @vSql = concat('select count(1) INTO @TotalHits from ', vTableName, ' where status=2 and (csg_tariff = ''CHG250'' or csg_tariff like ''CHG2.50'') ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('select min(datein), count(1) INTO @Datein, @TotalMt from ', vTableName);
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vDatein = @Datein;
            SET vTotalMt = @TotalMt;
            SET vTotalHits = @TotalHits;

            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''globe'',''hits'',', vHits, ',', vTotalHits - vHits, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''globe'',''mt'',', vMt, ',', vTotalMt - vMt, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SELECT vTotalHits, vHits, vTotalMt, vMt;

         elseif vSchemaOwner = 'balde2814_smart_ngin' then

            -- GET POSTPAID MT and HITS
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
                     SET @vSql = concat('select count(1) INTO @Hits8266 from ', vTableName, ' where status=2 and tariff = ''82'' and svc_desc = ''66'' and gsm_num REGEXP ''^', vPattern, '$''');
                     PREPARE stmt FROM @vSql;
                     EXECUTE stmt;
                     DEALLOCATE PREPARE stmt;

                     SET @vSql = concat('select count(1) INTO @Hits8267 from ', vTableName, ' where status=2 and tariff = ''82'' and svc_desc = ''67'' and gsm_num REGEXP ''^', vPattern, '$''');
                     PREPARE stmt FROM @vSql;
                     EXECUTE stmt;
                     DEALLOCATE PREPARE stmt;

                     SET @vSql = concat('select count(1) INTO @Mt from ', vTableName, ' where gsm_num REGEXP ''^', vPattern, '$''');
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

            -- GET TOTAL MT and INSERT MT
            SET @vSql = concat('select min(datein), count(1) INTO @Datein, @TotalMt from ', vTableName );
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET vDatein = @Datein;
            SET vTotalMt = @TotalMt;

            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''smart'',''mt'',', vMt, ',', vTotalMt - vMt, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            -- GET TOTAL TOTAL HITS 8266 and 8267
            SET @vSql = concat('select count(1) INTO @TotalHits8266 from ', vTableName, ' where status=2 and tariff = ''82'' and svc_desc = ''66''' );
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET vTotalHits8266 = @TotalHits8266;

            SET @vSql = concat('select count(1) INTO @TotalHits8267 from ', vTableName, ' where status=2 and tariff = ''82'' and svc_desc = ''67''' );
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            SET vTotalHits8267 = @TotalHits8267;

            -- INSERT 8266 and 8267
            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''smart8266'',''hits'',', vHits8266, ',', vTotalHits8266 - vHits8266, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''smart8267'',''hits'',', vHits8267, ',', vTotalHits8267 - vHits8267, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;


            SELECT  vHits8266,  vTotalHits8266, vHits8267, vTotalHits8267, vMt, vTotalMt;

         elseif vSchemaOwner = 'balde2814_sun' then

            -- GET POSTPAID MT and HITS
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
                     SET @vSql = concat('select count(1) INTO @Hits from ', vTableName, ' where status=2 and tariff = ''123000030'' and svc_desc = ''01000001C'' and gsm_num REGEXP ''^', vPattern, '$''');
                     PREPARE stmt FROM @vSql;
                     EXECUTE stmt;
                     DEALLOCATE PREPARE stmt;

                     SET @vSql = concat('select count(1) INTO @Mt from ', vTableName, ' where gsm_num REGEXP ''^', vPattern, '$''');
                     PREPARE stmt FROM @vSql;
                     EXECUTE stmt;
                     DEALLOCATE PREPARE stmt;

                     SET vMt = vMt + @Mt;
                     SET vHits = vHits + @Hits;
                  end if;
               UNTIL done_p
               END REPEAT;
            END; 

            -- GET TOTAL MT and HITS
            SET @vSql = concat('select count(1) INTO @TotalHits from ', vTableName, ' where status=2 and tariff = ''123000030'' and svc_desc = ''01000001C'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('select min(datein), count(1) INTO @Datein, @TotalMt from ', vTableName);
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vDatein = @Datein;
            SET vTotalMt = @TotalMt;
            SET vTotalHits = @TotalHits;

            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''sun'',''hits'',', vHits, ',', vTotalHits - vHits, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''sun'',''mt'',', vMt, ',', vTotalMt - vMt, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SELECT vTotalHits, vHits, vTotalMt, vMt;

         end if;
      end if;

   until done
   end repeat;
end;
//

delimiter ;

