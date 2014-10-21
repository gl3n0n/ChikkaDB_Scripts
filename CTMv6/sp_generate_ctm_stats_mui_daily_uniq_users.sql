delimiter //
DROP procedure IF EXISTS sp_generate_ctm_stats_mui_daily_uniq_users//

create procedure sp_generate_ctm_stats_mui_daily_uniq_users (p_datein varchar(10))
begin
   declare vPartitionName, vPattern, vDatein Varchar(80);
   declare vUkActive, vTotalUkActiveM, vTotalUkActiveP, done int default 0;

   IF p_datein is null THEN
      SELECT date_sub(curdate(), interval 1 day) INTO vDatein;
   ELSE
      SET vDatein = p_datein;
   END IF;
   SET vPartitionName = concat('p_', date_format(vDatein, '%Y%m%d'));

   -- -- GLOBE
   -- SET vUkActive = 0;
   -- SET vTotalUkActiveM = 0;
   -- BEGIN
   --    DECLARE done_p int default 0;
   --    DECLARE c_pat CURSOR FOR SELECT pattern
   --                             FROM   mobile_pattern
   --                             WHERE  operator = 'GLOBE'
   --                             AND    sim_type = 'POSTPAID';
   --    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done_p = 1;
   --    OPEN c_pat;
   --    REPEAT
   --       FETCH c_pat into vPattern;
   --       IF not done_p THEN
   --          SET @vSql = concat('select count(distinct chikkaid) INTO @UkActive from (',
   --                             'select tx_to chikkaid from mui_ph_globe_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$'' ',
   --                             'union ', 
   --                             'select tx_from chikkaid from mui_ph_globe_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$'') tab1');
   --          PREPARE stmt FROM @vSql;
   --          EXECUTE stmt;
   --          DEALLOCATE PREPARE stmt;
   -- 
   --          SET vUkActive = vUkActive + @UkActive;
   --       END IF;
   --    UNTIL done_p
   --    END REPEAT;
   -- END; 
   -- 
   -- -- GET TOTAL MOBILE ACTIVE USERS
   -- SET @vSql = concat('select count(distinct chikkaid) INTO @TotalUkActiveM from (',
   --                    'select tx_to chikkaid from mui_ph_globe_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' ',
   --                    'union ', 
   --                    'select tx_from chikkaid from mui_ph_globe_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'') tab1');
   -- PREPARE stmt FROM @vSql;
   -- EXECUTE stmt;
   -- DEALLOCATE PREPARE stmt;
   -- 
   -- SET vTotalUkActiveM = @TotalUkActiveM;
   -- 
   -- BEGIN
   --    declare continue handler for sqlstate '23000' set done = 1;
   --    SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''globe'',''ukactive'',', vUkActive, ',', vTotalUkActiveM-vUkActive, ')');
   --    PREPARE stmt FROM @vSql;
   --    EXECUTE stmt;
   --    DEALLOCATE PREPARE stmt;
   -- END;
   -- 
   -- -- SMART
   -- SET vUkActive = 0;
   -- SET vTotalUkActiveM = 0;
   -- BEGIN
   --    DECLARE done_p int default 0;
   --    DECLARE c_pat CURSOR FOR SELECT pattern
   --                             FROM   mobile_pattern
   --                             WHERE  operator = 'SMART'
   --                             AND    sim_type = 'POSTPAID';
   --    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done_p = 1;
   --    OPEN c_pat;
   --    REPEAT
   --       FETCH c_pat into vPattern;
   --       IF not done_p THEN
   --          SET @vSql = concat('select count(distinct chikkaid) INTO @UkActive from (',
   --                             'select tx_to chikkaid from mui_ph_smart_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$'' ',
   --                             'union ', 
   --                             'select tx_from chikkaid from mui_ph_smart_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$'') tab1');
   --          PREPARE stmt FROM @vSql;
   --          EXECUTE stmt;
   --          DEALLOCATE PREPARE stmt;
   -- 
   --          SET vUkActive = vUkActive + @UkActive;
   --       END IF;
   --    UNTIL done_p
   --    END REPEAT;
   -- END; 
   -- 
   -- -- GET TOTAL MOBILE ACTIVE USERS
   -- SET @vSql = concat('select count(distinct chikkaid) INTO @TotalUkActiveM from (',
   --                    'select tx_to chikkaid from mui_ph_smart_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' ',
   --                    'union ', 
   --                    'select tx_from chikkaid from mui_ph_smart_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'') tab1');
   -- PREPARE stmt FROM @vSql;
   -- EXECUTE stmt;
   -- DEALLOCATE PREPARE stmt;
   -- 
   -- SET vTotalUkActiveM = @TotalUkActiveM;
   -- 
   -- BEGIN
   --    declare continue handler for sqlstate '23000' set done = 1;
   --    SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''smart'',''ukactive'',', vUkActive, ',', vTotalUkActiveM-vUkActive, ')');
   --    PREPARE stmt FROM @vSql;
   --    EXECUTE stmt;
   --    DEALLOCATE PREPARE stmt;
   -- END;
   -- 
   -- -- SUN
   -- SET vUkActive = 0;
   -- SET vTotalUkActiveM = 0;
   -- BEGIN
   --    DECLARE done_p int default 0;
   --    DECLARE c_pat CURSOR FOR SELECT pattern
   --                             FROM   mobile_pattern
   --                             WHERE  operator = 'SUN'
   --                             AND    sim_type = 'POSTPAID';
   --    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done_p = 1;
   --    OPEN c_pat;
   --    REPEAT
   --       FETCH c_pat into vPattern;
   --       IF not done_p THEN
   --          SET @vSql = concat('select count(distinct chikkaid) INTO @UkActive from (',
   --                             'select tx_to chikkaid from mui_ph_sun_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$'' ',
   --                             'union ', 
   --                             'select tx_from chikkaid from mui_ph_sun_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$'') tab1');
   --          PREPARE stmt FROM @vSql;
   --          EXECUTE stmt;
   --          DEALLOCATE PREPARE stmt;
   -- 
   --          SET vUkActive = vUkActive + @UkActive;
   --       END IF;
   --    UNTIL done_p
   --    END REPEAT;
   -- END; 
   -- 
   -- -- GET TOTAL MOBILE ACTIVE USERS
   -- SET @vSql = concat('select count(distinct chikkaid) INTO @TotalUkActiveM from (',
   --                    'select tx_to chikkaid from mui_ph_sun_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' ',
   --                    'union ', 
   --                    'select tx_from chikkaid from mui_ph_sun_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'') tab1');
   -- PREPARE stmt FROM @vSql;
   -- EXECUTE stmt;
   -- DEALLOCATE PREPARE stmt;
   -- 
   -- SET vTotalUkActiveM = @TotalUkActiveM;
   -- 
   -- BEGIN
   --    declare continue handler for sqlstate '23000' set done = 1;
   --    SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''sun'',''ukactive'',', vUkActive, ',', vTotalUkActiveM-vUkActive, ')');
   --    PREPARE stmt FROM @vSql;
   --    EXECUTE stmt;
   --    DEALLOCATE PREPARE stmt;
   -- END;

   -- GET TOTAL PC ACTIVE USERS
   SET @vSql = concat('select count(distinct chikkaid) INTO @TotalUkActiveP from (',
                      'select tx_from chikkaid from mui_ph_sun_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_from like ''00%'' group by tx_from ',
                      'union ', 
                      'select tx_to chikkaid from mui_ph_sun_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_to like ''00%'' group by tx_to ',
                      'union ', 
                      'select tx_from chikkaid from mui_ph_globe_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_from like ''00%'' group by tx_from ',
                      'union ', 
                      'select tx_to chikkaid from mui_ph_globe_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_to like ''00%'' group by tx_to ',
                      'union ', 
                      'select tx_from chikkaid from mui_ph_smart_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_from like ''00%'' group by tx_from ',
                      'union ', 
                      'select tx_to chikkaid from mui_ph_smart_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_to like ''00%'' group by tx_to ',
                      ') as tab1');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET vTotalUkActiveP = @TotalUkActiveP;

   BEGIN
      declare continue handler for sqlstate '23000' set done = 1;
      SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''others'',''ukactive'',', 0, ',', vTotalUkActiveP, ')');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   END;


end;
//

delimiter ;


call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-01');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-02');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-03');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-04');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-05');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-05');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-06');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-07');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-08');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-09');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-10');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-11');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-12');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-13');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-14');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-15');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-16');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-17');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-18');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-19');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-20');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-21');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-22');
call sp_generate_ctm_stats_mui_daily_uniq_users('2013-10-23');
