
delimiter //
DROP procedure IF EXISTS sp_generate_ctm_stats_mo//

create procedure sp_generate_ctm_stats_mo (p_database varchar(30), p_tablename varchar(30))
begin
   declare vSchemaOwner, vTableName, vPattern, vDatein Varchar(80);
   declare vMo, vTotalMo int default 0; 
   declare vUkMo, vTotalUkMo int default 0;
   declare done int default 0;
   declare c_tab cursor for select table_schema, concat(table_schema, '.', table_name) table_name
                            from  information_schema.tables
                            where table_name like 'bridge_out_%'
                            and   table_name like p_tablename
                            and   table_schema like p_database
                            order by table_schema, table_name;

   declare continue handler for sqlstate '02000' set done = 1;
   
   open c_tab;
   repeat
   fetch c_tab into vSchemaOwner, vTableName;
      if not done then

         SET vMo = 0;
         SET vUkMo = 0;
         SET vTotalMo = 0;
         SET vTotalUkMo = 0;
         if vSchemaOwner = 'mui_ph_globe_1' then
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
                     SET @vSql = concat('select count(1), count(distinct tx_from) INTO @Mo, @UkMo from ', vTableName, ' where status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$''');
                     PREPARE stmt FROM @vSql;
                     EXECUTE stmt;
                     DEALLOCATE PREPARE stmt;

                     SET vMo = vMo + @Mo;
                     SET vUkMo = vUkMo + @UkMo;
                  end if;
               UNTIL done_p
               END REPEAT;
            END; 

            -- GET TOTAL MO
            SET @vSql = concat('select min(datein), count(1), count(distinct tx_from) INTO @Datein, @TotalMo, @TotalUkMo from ', vTableName, ' where status = 2 and tx_type = ''messaging'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vDatein = @Datein;
            SET vTotalMo = @TotalMo;
            SET vTotalUkMo = @TotalUkMo;

            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''globe'',''mo'',', vMo, ',', vTotalMo - vMo, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''globe'',''ukmo'',', vUkMo, ',', vTotalUkMo - vUkMo, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            -- SELECT vTotalMo, vMo, vTotalUkMo, vUkMo;

         elseif vSchemaOwner = 'mui_ph_smart_1' then
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
                     SET @vSql = concat('select count(1), count(distinct tx_from) INTO @Mo, @UkMo from ', vTableName, ' where status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$''');
                     PREPARE stmt FROM @vSql;
                     EXECUTE stmt;
                     DEALLOCATE PREPARE stmt;

                     SET vMo = vMo + @Mo;
                     SET vUkMo = vUkMo + @UkMo;
                     -- if vMo is null or vMo < 0 then
                     --   select vMo, vUkMo, concat('''^', vPattern, '$''') as Pattern;
                     -- end if;
                  end if;
               UNTIL done_p
               END REPEAT;
            END; 

            -- GET TOTAL MO
            SET @vSql = concat('select min(datein), count(1), count(distinct tx_from) INTO @Datein, @TotalMo, @TotalUkMo from ', vTableName, ' where status = 2 and tx_type = ''messaging'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vDatein = @Datein;
            SET vTotalMo = @TotalMo;
            SET vTotalUkMo = @TotalUkMo;

            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''smart'',''mo'',', vMo, ',', vTotalMo - vMo, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''smart'',''ukmo'',', vUkMo, ',', vTotalUkMo - vUkMo, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            -- SELECT vTotalMo, vMo, vTotalUkMo, vUkMo;

         elseif vSchemaOwner = 'mui_ph_sun_1' then

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
                     SET @vSql = concat('select count(1), count(distinct tx_from) INTO @Mo, @UkMo from ', vTableName, ' where status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$''');
                     PREPARE stmt FROM @vSql;
                     EXECUTE stmt;
                     DEALLOCATE PREPARE stmt;

                     SET vMo = vMo + @Mo;
                     SET vUkMo = vUkMo + @UkMo;
                  end if;
               UNTIL done_p
               END REPEAT;
            END; 

            -- GET TOTAL MO
            SET @vSql = concat('select min(datein), count(1), count(distinct tx_from) INTO @Datein, @TotalMo, @TotalUkMo from ', vTableName, ' where status = 2 and tx_type = ''messaging'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vDatein = @Datein;
            SET vTotalMo = @TotalMo;
            SET vTotalUkMo = @TotalUkMo;

            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''sun'',''mo'',', vMo, ',', vTotalMo - vMo, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''sun'',''ukmo'',', vUkMo, ',', vTotalUkMo - vUkMo, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            -- SELECT vTotalMo, vMo, vTotalUkMo, vUkMo;

         end if;
      end if;
   until done
   end repeat;
end;
//

delimiter ;
