delimiter //
DROP procedure IF EXISTS sp_generate_ctm_stats_mt//

create procedure sp_generate_ctm_stats_mt (p_database varchar(20), p_tablename varchar(30))
begin
   declare vSchemaOwner, vTableName, vPattern, vDatein Varchar(80);
   declare vUkMt, vTotalUkMt int default 0;
   declare done int default 0;
   declare c_tab cursor for select table_schema, concat(table_schema, '.', table_name) table_name
                            from  information_schema.tables
                            where table_name like 'bridge_in_%'
                            and   table_name like p_tablename
                            and   table_schema like p_database
                            order by table_schema, table_name;

   declare continue handler for sqlstate '23000' set done = 0;
   declare continue handler for sqlstate '02000' set done = 1;
   
   open c_tab;
   repeat
   fetch c_tab into vSchemaOwner, vTableName;
      if not done then

         SET vUkMT = 0;
         SET vTotalUkMt = 0;
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
                     SET @vSql = concat('select count(distinct tx_from) INTO @UkMt from ', vTableName, ' where status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$''');
                     PREPARE stmt FROM @vSql;
                     EXECUTE stmt;
                     DEALLOCATE PREPARE stmt;

                     SET vUkMt = vUkMt + @UkMt;
                  end if;
               UNTIL done_p
               END REPEAT;
            END; 

            -- GET TOTAL MO
            SET @vSql = concat('select min(datein), count(distinct tx_to) INTO @Datein, @TotalUkMt from ', vTableName, ' where status = 2 and tx_type = ''chat'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vDatein = @Datein;
            SET vTotalUkMt = @TotalUkMt;

            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''globe'',''ukmt'',', vUkMt, ',', vTotalUkMt - vUkMt, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

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
                     SET @vSql = concat('select count(distinct tx_from) INTO @UkMt from ', vTableName, ' where status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$''');
                     PREPARE stmt FROM @vSql;
                     EXECUTE stmt;
                     DEALLOCATE PREPARE stmt;

                     SET vUkMt = vUkMt + @UkMt;
                  end if;
               UNTIL done_p
               END REPEAT;
            END; 

            -- GET TOTAL MO
            SET @vSql = concat('select min(datein), count(distinct tx_to) INTO @Datein, @TotalUkMt from ', vTableName, ' where status = 2 and tx_type = ''chat'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vDatein = @Datein;
            SET vTotalUkMt = @TotalUkMt;

            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''smart'',''ukmt'',', vUkMt, ',', vTotalUkMt - vUkMt, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

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
                     SET @vSql = concat('select count(distinct tx_from) INTO @UkMt from ', vTableName, ' where status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$''');
                     PREPARE stmt FROM @vSql;
                     EXECUTE stmt;
                     DEALLOCATE PREPARE stmt;

                     SET vUkMt = vUkMt + @UkMt;
                  end if;
               UNTIL done_p
               END REPEAT;
            END; 

            -- GET TOTAL MO
            SET @vSql = concat('select min(datein), count(distinct tx_to) INTO @Datein, @TotalUkMt from ', vTableName, ' where status = 2 and tx_type = ''chat'' ');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vDatein = @Datein;
            SET vTotalUkMt = @TotalUkMt;

            SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''sun'',''ukmt'',', vUkMt, ',', vTotalUkMt - vUkMt, ')');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
         end if;
      end if;
   until done
   end repeat;
end;
//

delimiter ;

