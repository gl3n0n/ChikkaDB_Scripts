delimiter //
DROP procedure IF EXISTS sp_generate_ctm_stats_mui_2//

create procedure sp_generate_ctm_stats_mui_2 (p_datein varchar(10))
begin
   declare vPartitionName, vTableName, vPattern, vDatein Varchar(80);
   declare vMo, vTotalMo, done int default 0; 
   declare vUkMo, vTotalUkMo int default 0;
   declare vUkMt, vTotalUkMt int default 0;
   declare vUkActive, vTotalUkActiveM, vTotalUkActiveP int default 0;

   IF p_datein is null THEN
      SELECT date_sub(curdate(), interval 1 day) INTO vDatein;
   ELSE
      SET vDatein = p_datein;
   END IF;
   SET vPartitionName = concat('p_', date_format(vDatein, '%Y%m%d'));

   -- GLOBE
   SET vMo = 0;
   SET vTotalMo = 0;
   SET vUkMo = 0;
   SET vTotalUkMo = 0;
   SET vUkMt = 0;
   SET vTotalUkMt = 0;
   SET vUkActive = 0;
   SET vTotalUkActiveM = 0;
   BEGIN
      DECLARE done_p int default 0;
      DECLARE c_pat CURSOR FOR SELECT pattern
                               FROM   mobile_pattern
                               WHERE  operator = 'GLOBE'
                               AND    sim_type = 'POSTPAID';
      DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done_p = 1;
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern;
         IF not done_p THEN
            SET @vSql = concat('select count(1), count(distinct tx_from) INTO @Mo, @UkMo from mui_ph_globe_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('select count(distinct tx_to) INTO @UkMt from mui_ph_globe_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('select count(distinct chikkaid) INTO @UkActive from (',
                               'select tx_to chikkaid from mui_ph_globe_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$'' ',
                               'union ', 
                               'select tx_from chikkaid from mui_ph_globe_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$'') tab1');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vMo = vMo + @Mo;
            SET vUkMo = vUkMo + @UkMo;
            SET vUkMt = vUkMt + @UkMt;
            SET vUkActive = vUkActive + @UkActive;
         END IF;
      UNTIL done_p
      END REPEAT;
   END; 

   -- GET TOTAL MO
   SET @vSql = concat('select count(1), count(distinct tx_from) INTO @TotalMo, @TotalUkMo from mui_ph_globe_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- GET TOTAL MT
   SET @vSql = concat('select count(distinct tx_to) INTO @TotalUkMt from mui_ph_globe_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- GET TOTAL MOBILE ACTIVE USERS
   SET @vSql = concat('select count(distinct chikkaid) INTO @TotalUkActiveM from (',
                      'select tx_to chikkaid from mui_ph_globe_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' ',
                      'union ', 
                      'select tx_from chikkaid from mui_ph_globe_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'') tab1');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET vTotalMo = @TotalMo;
   SET vTotalUkMo = @TotalUkMo;
   SET vTotalUkMt = @TotalUkMt;
   SET vTotalUkActiveM = @TotalUkActiveM;

   BEGIN
      declare continue handler for sqlstate '23000' set done = 1;
      SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''globe'',''mo'',', vMo, ',', vTotalMo - vMo, ')');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   END;

   BEGIN
      declare continue handler for sqlstate '23000' set done = 1;
      SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''globe'',''ukmo'',', vUkMo, ',', vTotalUkMo - vUkMo, ')');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   END;

   BEGIN
      declare continue handler for sqlstate '23000' set done = 1;
      SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''globe'',''ukmt'',', vUkMt, ',', vTotalUkMt - vUkMt, ')');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   END;

   BEGIN
      declare continue handler for sqlstate '23000' set done = 1;
      SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''globe'',''ukactive'',', vUkActive, ',', vTotalUkActiveM-vUkActive, ')');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   END;

   -- SMART
   SET vMo = 0;
   SET vTotalMo = 0;
   SET vUkMo = 0;
   SET vTotalUkMo = 0;
   SET vUkMt = 0;
   SET vTotalUkMt = 0;
   SET vUkActive = 0;
   SET vTotalUkActiveM = 0;
   BEGIN
      DECLARE done_p int default 0;
      DECLARE c_pat CURSOR FOR SELECT pattern
                               FROM   mobile_pattern
                               WHERE  operator = 'SMART'
                               AND    sim_type = 'POSTPAID';
      DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done_p = 1;
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern;
         IF not done_p THEN
            SET @vSql = concat('select count(1), count(distinct tx_from) INTO @Mo, @UkMo from mui_ph_smart_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('select count(distinct tx_to) INTO @UkMt from mui_ph_smart_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('select count(distinct chikkaid) INTO @UkActive from (',
                               'select tx_to chikkaid from mui_ph_smart_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$'' ',
                               'union ', 
                               'select tx_from chikkaid from mui_ph_smart_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$'') tab1');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vMo = vMo + @Mo;
            SET vUkMo = vUkMo + @UkMo;
            SET vUkMt = vUkMt + @UkMt;
            SET vUkActive = vUkActive + @UkActive;
         END IF;
      UNTIL done_p
      END REPEAT;
   END; 

   -- GET TOTAL MO
   SET @vSql = concat('select count(1), count(distinct tx_from) INTO @TotalMo, @TotalUkMo from mui_ph_smart_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- GET TOTAL MT
   SET @vSql = concat('select count(distinct tx_to) INTO @TotalUkMt from mui_ph_smart_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- GET TOTAL MOBILE ACTIVE USERS
   SET @vSql = concat('select count(distinct chikkaid) INTO @TotalUkActiveM from (',
                      'select tx_to chikkaid from mui_ph_smart_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' ',
                      'union ', 
                      'select tx_from chikkaid from mui_ph_smart_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'') tab1');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET vTotalMo = @TotalMo;
   SET vTotalUkMo = @TotalUkMo;
   SET vTotalUkMt = @TotalUkMt;
   SET vTotalUkActiveM = @TotalUkActiveM;

   BEGIN
      declare continue handler for sqlstate '23000' set done = 1;
      SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''smart'',''mo'',', vMo, ',', vTotalMo - vMo, ')');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   END;

   BEGIN
      declare continue handler for sqlstate '23000' set done = 1;
      SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''smart'',''ukmo'',', vUkMo, ',', vTotalUkMo - vUkMo, ')');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   END;

   BEGIN
      declare continue handler for sqlstate '23000' set done = 1;
      SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''smart'',''ukmt'',', vUkMt, ',', vTotalUkMt - vUkMt, ')');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   END;

   BEGIN
      declare continue handler for sqlstate '23000' set done = 1;
      SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''smart'',''ukactive'',', vUkActive, ',', vTotalUkActiveM-vUkActive, ')');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   END;

   -- SUN
   SET vMo = 0;
   SET vTotalMo = 0;
   SET vUkMo = 0;
   SET vTotalUkMo = 0;
   SET vUkMt = 0;
   SET vTotalUkMt = 0;
   SET vUkActive = 0;
   SET vTotalUkActiveM = 0;
   BEGIN
      DECLARE done_p int default 0;
      DECLARE c_pat CURSOR FOR SELECT pattern
                               FROM   mobile_pattern
                               WHERE  operator = 'SUN'
                               AND    sim_type = 'POSTPAID';
      DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done_p = 1;
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPattern;
         IF not done_p THEN
            SET @vSql = concat('select count(1), count(distinct tx_from) INTO @Mo, @UkMo from mui_ph_sun_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('select count(distinct tx_to) INTO @UkMt from mui_ph_sun_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('select count(distinct chikkaid) INTO @UkActive from (',
                               'select tx_to chikkaid from mui_ph_sun_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$'' ',
                               'union ', 
                               'select tx_from chikkaid from mui_ph_sun_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$'') tab1');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vMo = vMo + @Mo;
            SET vUkMo = vUkMo + @UkMo;
            SET vUkMt = vUkMt + @UkMt;
            SET vUkActive = vUkActive + @UkActive;
         END IF;
      UNTIL done_p
      END REPEAT;
   END; 

   -- GET TOTAL MO
   SET @vSql = concat('select count(1), count(distinct tx_from) INTO @TotalMo, @TotalUkMo from mui_ph_sun_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- GET TOTAL MT
   SET @vSql = concat('select count(distinct tx_to) INTO @TotalUkMt from mui_ph_sun_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- GET TOTAL MOBILE ACTIVE USERS
   SET @vSql = concat('select count(distinct chikkaid) INTO @TotalUkActiveM from (',
                      'select tx_to chikkaid from mui_ph_sun_1.bridge_in partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' ',
                      'union ', 
                      'select tx_from chikkaid from mui_ph_sun_1.bridge_out partition (', vPartitionName, ') where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'') tab1');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET vTotalMo = @TotalMo;
   SET vTotalUkMo = @TotalUkMo;
   SET vTotalUkMt = @TotalUkMt;
   SET vTotalUkActiveM = @TotalUkActiveM;

   BEGIN
      declare continue handler for sqlstate '23000' set done = 1;
      SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''sun'',''mo'',', vMo, ',', vTotalMo - vMo, ')');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   END;

   BEGIN
      declare continue handler for sqlstate '23000' set done = 1;
      SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''sun'',''ukmo'',', vUkMo, ',', vTotalUkMo - vUkMo, ')');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   END;

   BEGIN
      declare continue handler for sqlstate '23000' set done = 1;
      SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''sun'',''ukmt'',', vUkMt, ',', vTotalUkMt - vUkMt, ')');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   END;

   BEGIN
      declare continue handler for sqlstate '23000' set done = 1;
      SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''sun'',''ukactive'',', vUkActive, ',', vTotalUkActiveM-vUkActive, ')');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   END;

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
