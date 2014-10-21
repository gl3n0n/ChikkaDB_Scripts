cgsv3 sms-out
CREATE TABLE `sms_out` (
  `msg_id` varchar(64) NOT NULL DEFAULT '',
  `gateway_id` varchar(32) NOT NULL DEFAULT '1',
  `gsm_num` varchar(12) NOT NULL,
  `access_code` varchar(20) DEFAULT NULL,
  `suffix` varchar(20) DEFAULT NULL,
  `msg` text,
  `status` enum('Delivered','Charged','Charged Not\nDelivered','Delivery Error','Charging\nError','Unsubscribed','Expired') NOT NULL DEFAULT 'Delivered',
  `result` enum('02','20','23','22','30','03') NOT NULL DEFAULT '02',
  `message_type` enum('CLI','LOGO','PICMSG','SMS','TONE','VCALENDAR','VCARD','SPEC IALBIN') NOT NULL DEFAULT 'SMS',
  `dcs` int(3) DEFAULT NULL,
  `tariff` varchar(10) DEFAULT NULL,
  `svc_desc` varchar(10) DEFAULT NULL,
  `err_code` int(4) DEFAULT NULL,
  `rrn` varchar(12) DEFAULT NULL,
  `svc_id` varchar(4) DEFAULT NULL,
  `csg_cp_id` varchar(128) DEFAULT NULL,
  `csg_session_id` varchar(128) DEFAULT NULL,
  `csg_trans_id` varchar(128) DEFAULT NULL,
  `csg_msg_type` enum('PULL','PUSH') NOT NULL DEFAULT 'PULL',
  `csg_msg_subtype` varchar(16) NOT NULL DEFAULT '',
  `csg_service` varchar(128) DEFAULT NULL,
  `csg_subservice` varchar(128) DEFAULT NULL,
  `operator` varchar(6) DEFAULT NULL,
  `err_txt` varchar(160) DEFAULT '',
  `csg_tariff` varchar(32) DEFAULT '',
  `client_status` enum('SUCCESS','FAILURE','PENDING','NO\nCALLBACK') DEFAULT NULL,
  `datesent` date NOT NULL DEFAULT '0000-00-00',
  `timesent` time NOT NULL DEFAULT '00:00:00',
  `process_times` varchar(128) DEFAULT NULL,
  `scts` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`msg_id`),
  KEY `gsm_num` (`gsm_num`),
  KEY `result` (`result`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


ON SERVER: VEGA (3386)
ON SERVER: VEGA (3386)
ON SERVER: VEGA (3386)

USE DATABASE: test_allan


drop table ctm_stats_dtl;

CREATE TABLE ctm_stats_dtl (
  tran_dt date NOT NULL,
  carrier varchar(30) NOT NULL,
  type varchar(30) NOT NULL,
  post int(8) NOT NULL DEFAULT '0',
  pre int(8) NOT NULL DEFAULT '0',
  PRIMARY KEY (tran_dt,carrier,type)
);

drop table ctm_stats_dtl_reg;

create table ctm_stats_dtl_reg (
   tran_dt date not null,
   type    varchar(30) not null,           
   carrier varchar(30) not null,
   sim_type varchar(20) not null,
   hits int(8) default 0 not null
);

dump mobile_pattern (get from shrike or from akamaru)

delimiter //

drop procedure IF EXISTS sp_generate_ctm_stats_reg//
create procedure sp_generate_ctm_stats_reg (p_regdate varchar(10), p_type varchar(10))
begin
   declare vCarrier, vSim_type, vPattern varchar(150);
   declare dStart, dEnd varchar(150);
   declare done_p int default 0;
   declare c_pat cursor for select lower(operator) operator, sim_type, pattern
                            from  mobile_pattern
                            order by sim_type;
   declare continue handler for sqlstate '02000' set done_p = 1;

   if p_regdate is null then
      SET dStart = date_sub(curdate(), interval 1 day);
      SET dEnd   = curdate();
   else
      SET dStart = p_regdate;
      SET dEnd   = date_add(p_regdate, interval 1 day);
   end if;
   
   -- REGISTRATION
   if ((p_type = 'reg') or (p_type = 'all')) then
      OPEN c_pat;
      REPEAT
         FETCH c_pat into vCarrier, vSim_type, vPattern;
         if not done_p then
            SET @vSql = concat('insert into ctm_stats_dtl_reg select left(registration_datetime,10), ''reg'',''', vCarrier, ''',''', vSim_type, ''', count(1) from ctm_stats.registrations_pht where registration_datetime >= ''', dStart, ''' and registration_datetime < ''', dEnd, ''' and chikka_id REGEXP ''^', vPattern, '$'' GROUP BY 1');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
         end if;
      UNTIL done_p
      END REPEAT;
      SET @vSql = concat('insert into ctm_stats_dtl_reg select tran_dt, type, carrier, sim_type, sum(hits) from (select left(registration_datetime,10) tran_dt, ''reg'' type,''TOTAL'' carrier,''OTHERS'' sim_type, count(1) hits from ctm_stats.registrations_pht where registration_datetime >= ''', dStart, ''' and registration_datetime < ''', dEnd, ''' GROUP BY 1 union select ''', dStart, ''', ''reg'', ''TOTAL'', ''OTHERS'', 0) a group by 1,2,3  ');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      
      insert into ctm_stats_dtl 
      select tran_dt, carrier, type, sum(post), sum(pre) from (
      select tran_dt, type, carrier, sum(hits) post, 0 pre from ctm_stats_dtl_reg where tran_dt = dStart and type = 'reg' and sim_type = 'POSTPAID' group by 1,2,3 union all
      select tran_dt, type, carrier, 0 post, sum(hits) pre from ctm_stats_dtl_reg where tran_dt = dStart and type = 'reg' and sim_type <> 'POSTPAID' and sim_type <> 'OTHERS' group by 1,2,3 union all
      select dStart, 'reg', 'globe',  0, 0 union all
      select dStart, 'reg', 'smart',  0, 0 union all
      select dStart, 'reg', 'sun',    0, 0 
      ) t group by 1,2,3;
      
      insert into ctm_stats_dtl 
      select a.tran_dt, 'others', a.type, 0, a.hits - b.hits others
      from   ctm_stats_dtl_reg a, ( 
             select tran_dt, type, sum(hits) hits from ctm_stats_dtl_reg where tran_dt = dStart and sim_type <> 'OTHERS' group by 1,2
             ) b
      where a.tran_dt = dStart and a.type = 'reg' and a.sim_type = 'OTHERS'
      and   a.tran_dt = b.tran_dt
      and   a.type = b.type;    
      select * from ctm_stats_dtl where tran_dt = dStart;
   end if;

   if ((p_type = 'login') or (p_type = 'all')) then
      -- Logins
      SET @vSql = concat('insert into ctm_stats_dtl_reg select datein, type, carrier, sim_type, sum(hits) from (select datein, ''login'' type,''web'' carrier ,''OTHERS'' sim_type, count(1) hits from ctm_stats.logins_pht where datein = ''', dStart, ''' and resource = ''aurora'' GROUP BY 1 union all select ''', dStart, ''', ''login'',''web'',''OTHERS'', 0) a group by 1,2,3,4');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      SET @vSql = concat('insert into ctm_stats_dtl_reg select datein, type, carrier, sim_type, sum(hits) from (select datein, ''login'' type,''ios'' carrier ,''OTHERS'' sim_type, count(1) hits from ctm_stats.logins_pht where datein = ''', dStart, ''' and resource = ''iChikka'' GROUP BY 1 union all select ''', dStart, ''', ''login'',''ios'',''OTHERS'', 0) a group by 1,2,3,4');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      SET @vSql = concat('insert into ctm_stats_dtl_reg select datein, type, carrier, sim_type, sum(hits) from (select datein, ''login'' type,''android'' carrier ,''OTHERS'' sim_type, count(1) hits from ctm_stats.logins_pht where datein = ''', dStart, ''' and resource = ''gero'' GROUP BY 1 union all select ''', dStart, ''', ''login'',''android'',''OTHERS'', 0) a group by 1,2,3,4');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      SET @vSql = concat('insert into ctm_stats_dtl_reg select datein, type, carrier, sim_type, sum(hits) from (select datein, ''login'' type,''chrome'' carrier ,''OTHERS'' sim_type, count(1) hits from ctm_stats.logins_pht where datein = ''', dStart, ''' and resource = ''lighter'' GROUP BY 1 union all select ''', dStart, ''', ''login'',''chrome'',''OTHERS'', 0) a group by 1,2,3,4');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      SET @vSql = concat('insert into ctm_stats_dtl_reg select datein, type, carrier, sim_type, sum(hits) from (select datein, ''login'' type,''client'' carrier ,''OTHERS'' sim_type, count(1) hits from ctm_stats.logins_pht where datein = ''', dStart, ''' and resource = ''chikka_desktop'' GROUP BY 1 union all select ''', dStart, ''', ''login'',''client'',''OTHERS'', 0) a group by 1,2,3,4');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      SET @vSql = concat('insert into ctm_stats_dtl_reg select datein, type, carrier, sim_type, sum(hits) from (select datein, ''login'' type,''ztotal'' carrier ,''OTHERS'' sim_type, count(1) hits from ctm_stats.logins_pht where datein = ''', dStart, ''' GROUP BY 1 union all select ''', dStart, ''', ''login'',''ztotal'',''OTHERS'', 0) a group by 1,2,3,4');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      
      insert into ctm_stats_dtl 
      select tran_dt, carrier, type, 0 post, hits from ctm_stats_dtl_reg where tran_dt = dStart and type = 'login' and carrier <> 'ztotal' 
      union
      select a.tran_dt, 'others', a.type, 0 post, a.hits-b.hits pre 
      from   ctm_stats_dtl_reg a, (select tran_dt, type, sum(hits) hits from ctm_stats_dtl_reg where tran_dt = dStart and type = 'login' and carrier <> 'ztotal' group by tran_dt, type) b 
      where  a.tran_dt = dStart and a.type = 'login' and a.carrier = 'ztotal' 
      and    a.tran_dt = b.tran_dt and a.type = b.type;
      select * from ctm_stats_dtl where tran_dt = dStart;
   end if;

   if ((p_type = 'p2p') or (p_type = 'all')) then
      SET @vSql = concat('insert into ctm_stats_dtl_reg select datein, type, carrier, sim_type, sum(hits) from (select date datein, ''p2p'' type,''web'' carrier ,''OTHERS'' sim_type, sum(total) hits from ctm_stats.message where date = ''', dStart, ''' and sender_domain in (''PC'',''IM'') and recipient_domain in (''PC'',''IM'') union all select ''', dStart, ''', ''p2p'',''web'',''OTHERS'', 0) a group by 1,2,3,4');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;

      insert into ctm_stats_dtl select tran_dt, carrier, type, 0 post, hits from ctm_stats_dtl_reg where tran_dt = dStart and type = 'p2p'; 
   end if;

end;
//

delimiter ;


grant all on test_allan.* to ctmv5@shrike.internal.chikka.com identified by 'ctmv5';
flush privileges;








ON SERVER: DB7 (3382)
ON SERVER: DB7 (3382)
ON SERVER: DB7 (3382)

USE DATABASE: test


CREATE TABLE ctm_stats_dtl (
  tran_dt date NOT NULL,
  tran_tm time NOT NULL,
  carrier enum('globe','smart','smart8266','smart8267','sun','yahoo','gmail') NOT NULL,
  type enum('hits','mo','mt','reg','ukmo','ukmt') NOT NULL,
  post int(8) NOT NULL DEFAULT '0',
  pre int(8) NOT NULL DEFAULT '0',
  PRIMARY KEY (tran_dt,tran_tm,carrier,type)
);

dump mobile_pattern (get from shrike or from akamaru)

delimiter //
DROP procedure IF EXISTS sp_generate_ctm_stats_mui//

create procedure sp_generate_ctm_stats_mui (p_datein varchar(10))
begin
   declare vSchemaOwner, vTableName, vPattern, vDatein Varchar(80);
   declare vMo, vTotalMo, done int default 0; 
   declare vUkMo, vTotalUkMo int default 0;
   declare vUkMt, vTotalUkMt int default 0;
   declare vUkActive, vTotalUkActiveM, vTotalUkActiveP int default 0;

   IF p_datein is null THEN
      SELECT date_sub(curdate(), interval 1 day) INTO vDatein;
   ELSE
      SET vDatein = p_datein;
   END IF;

   -- GLOBE
   SET vMo = 0;
   SET vTotalMo = 0;
   SET vUkMo = 0;
   SET vTotalUkMo = 0;
   SET vUkMt = 0;
   SET vTotalUkMt = 0;
   SET vUkActive = 0;
   SET vTotalUkActiveM = 0;
   SET vTotalUkActiveP = 0;
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
            SET @vSql = concat('select count(1), count(distinct tx_from) INTO @Mo, @UkMo from mui_ph_globe_1.bridge_out where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('select count(distinct tx_to) INTO @UkMt from mui_ph_globe_1.bridge_in where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('select count(distinct chikkaid) INTO @UkActive from (',
                               'select tx_to chikkaid from mui_ph_globe_1.bridge_in where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$'' ',
                               'union ', '
                               'select tx_from chikkaid from mui_ph_globe_1.bridge_out where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$'')');
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
   SET @vSql = concat('select count(1), count(distinct tx_from) INTO @TotalMo, @TotalUkMo from mui_ph_globe_1.bridge_out where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- GET TOTAL MT
   SET @vSql = concat('select count(distinct tx_to) INTO @TotalUkMt from mui_ph_globe_1.bridge_in where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- GET TOTAL MOBILE ACTIVE USERS
   SET @vSql = concat('select count(distinct chikkaid) INTO @TotalUkActiveM from (',
                      'select tx_to chikkaid from mui_ph_globe_1.bridge_in where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_to like ''63%'' ',
                      'union ', '
                      'select tx_from chikkaid from mui_ph_globe_1.bridge_out where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_from like ''63%'')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- GET TOTAL PC ACTIVE USERS
   SET @vSql = concat('select count(distinct chikkaid) INTO @TotalUkActiveP from (',
                      'select tx_to chikkaid from mui_ph_globe_1.bridge_in where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_to like ''00%'' ',
                      'union ', '
                      'select tx_from chikkaid from mui_ph_globe_1.bridge_out where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_from like ''00%'')');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET vTotalMo = @TotalMo;
   SET vTotalUkMo = @TotalUkMo;
   SET vTotalUkMt = @TotalUkMt;
   SET vTotalUkActiveM = @TotalUkActiveM;
   SET vTotalUkActiveP = @TotalUkActiveP;

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
      SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''globe'',''ukactive'',', vUkActive, ',', vTotalUkActiveP - vUkActive, ')');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   END;

   BEGIN
      declare continue handler for sqlstate '23000' set done = 1;
      SET @vSql = concat('insert into ctm_stats_dtl values (''', vDatein ,''',''00:00'',''pc'',''ukactive'',', 0, ',', vTotalUkActiveM, ')');
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
            SET @vSql = concat('select count(1), count(distinct tx_from) INTO @Mo, @UkMo from mui_ph_smart_1.bridge_out where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('select count(distinct tx_from) INTO @UkMt from mui_ph_smart_1.bridge_in where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vMo = vMo + @Mo;
            SET vUkMo = vUkMo + @UkMo;
            SET vUkMt = vUkMt + @UkMt;
         END IF;
      UNTIL done_p
      END REPEAT;
   END; 

   -- GET TOTAL MO
   SET @vSql = concat('select count(1), count(distinct tx_from) INTO @TotalMo, @TotalUkMo from mui_ph_smart_1.bridge_out where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- GET TOTAL MT
   SET @vSql = concat('select count(distinct tx_to) INTO @TotalUkMt from mui_ph_smart_1.bridge_in where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET vTotalMo = @TotalMo;
   SET vTotalUkMo = @TotalUkMo;
   SET vTotalUkMt = @TotalUkMt;

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

   -- SUN
   SET vMo = 0;
   SET vTotalMo = 0;
   SET vUkMo = 0;
   SET vTotalUkMo = 0;
   SET vUkMt = 0;
   SET vTotalUkMt = 0;
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
            SET @vSql = concat('select count(1), count(distinct tx_from) INTO @Mo, @UkMo from mui_ph_sun_1.bridge_out where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' and tx_from REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @vSql = concat('select count(distinct tx_from) INTO @UkMt from mui_ph_sun_1.bridge_in where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' and tx_to REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET vMo = vMo + @Mo;
            SET vUkMo = vUkMo + @UkMo;
            SET vUkMt = vUkMt + @UkMt;
         END IF;
      UNTIL done_p
      END REPEAT;
   END; 

   -- GET TOTAL MO
   SET @vSql = concat('select count(1), count(distinct tx_from) INTO @TotalMo, @TotalUkMo from mui_ph_sun_1.bridge_out where datein=''', vDatein, ''' and status = 2 and tx_type = ''messaging'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   -- GET TOTAL MT
   SET @vSql = concat('select count(distinct tx_to) INTO @TotalUkMt from mui_ph_sun_1.bridge_in where datein=''', vDatein, ''' and status = 2 and tx_type = ''chat'' ');
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET vTotalMo = @TotalMo;
   SET vTotalUkMo = @TotalUkMo;
   SET vTotalUkMt = @TotalUkMt;

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

end;
//

delimiter ;

grant all on test.* to ctmv5@shrike.internal.chikka.com identified by 'ctmv5';
flush privileges;








ON SERVER: SHRIKE (3302)
ON SERVER: SHRIKE (3302)
ON SERVER: SHRIKE (3302)

USE DATABASE: test



CREATE TABLE ctm_stats_dtl (
  tran_dt date NOT NULL,
  tran_tm time NOT NULL,
  carrier varchar(30) NOT NULL,
  type varchar(30) NOT NULL DEFAULT '',
  post int(8) NOT NULL DEFAULT '0',
  pre int(8) NOT NULL DEFAULT '0',
  PRIMARY KEY (tran_dt,tran_tm,carrier,type)
);

dump mobile_pattern (get from shrike or from akamaru)


create view ctm_stats as 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, sum(pre) hits_sun_pre, sum(post) hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'sun' and type = 'hits'
group  by tran_dt
union all 
select tran_dt, sum(pre) hits_globe_pre, sum(post) hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'globe' and type = 'hits'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, sum(pre) hits_smart_8266_pre, sum(post) hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'smart8266' and type = 'hits'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, sum(pre) hits_smart_8267_pre, sum(post) hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'smart8267' and type = 'hits'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, sum(pre) mt_globe_pre, sum(post) mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'globe' and type = 'mt'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, sum(pre) mt_smart_pre, sum(post) mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'smart' and type = 'mt'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, sum(pre)  mt_sun_pre, sum(post) mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'sun' and type = 'mt'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, sum(pre) mo_globe_pre, sum(post) mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'globe' and type = 'mo'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, sum(pre) mo_smart_pre, sum(post) mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'smart' and type = 'mo'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, sum(pre) mo_sun_pre, sum(post) mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'sun' and type = 'mo'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, sum(pre) ukmo_globe_pre, sum(post) ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'globe' and type = 'ukmo'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, sum(pre) ukmo_smart_pre, sum(post) ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'smart' and type = 'ukmo'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, sum(pre) ukmo_sun_pre, sum(post) ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'sun' and type = 'ukmo'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, sum(pre) ukmt_globe_pre, sum(post) ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'globe' and type = 'ukmt'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, sum(pre) ukmt_smart_pre, sum(post) ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'smart' and type = 'ukmt'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, sum(pre) ukmt_sun_pre, sum(post) ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'sun' and type = 'ukmt'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, sum(pre) reg_globe_pre, sum(post) reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'globe' and type = 'reg'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, sum(pre) reg_smart_pre, sum(post) reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'smart' and type = 'reg'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, sum(pre) reg_sun_pre, sum(post) reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'sun' and type = 'reg'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, sum(pre) login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'android' and type = 'login'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, sum(pre) login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'chrome' and type = 'login'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, sum(pre) login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'client' and type = 'login'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, sum(pre) login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'ios' and type = 'login'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, sum(pre) login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'web' and type = 'login'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, sum(pre) login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'others' and type = 'login'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, sum(pre) p2p_msg
from ctm_stats_dtl
where type = 'p2p'
group  by tran_dt
;

create view ctm_stats_daily as
select 0 seq_no, tran_dt, concat('CTMv5 Stats as of ', date_format(tran_dt, '%b %d,%Y')) stats from ctm_stats_report where tran_type='hits' group by tran_dt union
select 1, tran_dt, '' stats from ctm_stats_report where tran_type = 'hits' group by tran_dt union
select 2 seq_no, tran_dt, 'HITS (Charged transactions only)' stats from ctm_stats_report where tran_type='hits' group by tran_dt union
select 3, tran_dt, concat(carrier, ': ', total,'
   Pre: ', pre, '
   Post: ', post) stats from ctm_stats_report where tran_type = 'hits' union
select 5 seq_no, tran_dt, '' stats from ctm_stats_report where tran_type='hits' group by tran_dt union
select 6 seq_no, tran_dt, 'Messages Sent (MO & AO)' stats from ctm_stats_report where tran_type='mo' group by tran_dt union
select 7, tran_dt, concat(carrier, ': ', total,'
   Pre: ', pre, '
   Post: ', post) stats from ctm_stats_report where tran_type = 'mo' union
select 9 seq_no, tran_dt, '' stats from ctm_stats_report where tran_type='mo' group by tran_dt union
select 10 seq_no, tran_dt, 'Messages Received (MT & AT)' stats from ctm_stats_report where tran_type='mt' group by tran_dt union
select 11, tran_dt, concat(carrier, ': ', total,'
   Pre: ', pre, '
   Post: ', post) stats from ctm_stats_report where tran_type = 'mt' union
select 12 seq_no, tran_dt, '' stats from ctm_stats_report where tran_type='mt' group by tran_dt union
select 13 seq_no, tran_dt, 'Registration' stats from ctm_stats_report where tran_type='reg' group by tran_dt union
select 14, tran_dt, concat(carrier, ': ', total,'
   Pre: ', pre, '
   Post: ', post) stats from ctm_stats_report where tran_type = 'reg' and carrier <> 'OTHERS' union
select 15, tran_dt, concat('Others', ': ', pre) stats from ctm_stats_report where tran_type = 'reg' and carrier = 'OTHERS' union
select 16 seq_no, tran_dt, '' stats from ctm_stats_report where tran_type='login' group by tran_dt union
select 17 seq_no, tran_dt, 'Sign-in via' stats from ctm_stats_report where tran_type='login' group by tran_dt union
select 18, tran_dt, concat(' ', case when (carrier='IOS') THEN 'iOS' 
                                     when (carrier='ANDROID') THEN 'Android' 
                                     when (carrier='CHROME') THEN 'Chrome' 
                                     when (carrier='CLIENT') THEN 'Client' 
                                     when (carrier='WEB') THEN 'Web' 
                                     else lower(carrier) end, ': ', pre) stats from ctm_stats_report where tran_type = 'login' and carrier <> 'OTHERS' union
select 19, tran_dt, concat(' ', 'Others', ': ', pre) stats from ctm_stats_report where tran_type = 'login' and carrier = 'OTHERS' union
select 20 seq_no, tran_dt, '' stats from ctm_stats_report where tran_type='login' group by tran_dt union
select 21 seq_no, tran_dt, 'Unique Message Senders' stats from ctm_stats_report where tran_type='ukmo' group by tran_dt union
select 22, tran_dt, concat(carrier, ': ', total,'
   Pre: ', pre, '
   Post: ', post) stats from ctm_stats_report where tran_type = 'ukmo' union
select 23 seq_no, tran_dt, '' stats from ctm_stats_report where tran_type='ukmo' group by tran_dt union
select 24 seq_no, tran_dt, 'Unique Message Recipients' stats from ctm_stats_report where tran_type='ukmt' group by tran_dt union
select 25, tran_dt, concat(carrier, ': ', total,'
   Pre: ', pre, '
   Post: ', post) stats from ctm_stats_report where tran_type = 'ukmt' union
select 26 seq_no, tran_dt, '' stats from ctm_stats_report where tran_type='ukmt' group by tran_dt union
select 27 seq_no, tran_dt, concat ('P2P Messages:', pre) stats from ctm_stats_report where tran_type='p2p' group by tran_dt
;



create view ctm_stats_report as
select tran_dt,
       type tran_type,
       CASE when (type='hits') then
          CASE when (carrier='globe') then 'Globe (P2.50)' 
               when (carrier='smart8266') then 'Smart (G8266)' 
               when (carrier='smart8267') then 'Smart (G8267)' 
               when (carrier='sun') then 'Sun (P2.00)' 
               else upper(carrier) 
          END 
       ELSE          
          CASE when (carrier='globe') then 'Globe' 
               when (carrier='smart') then 'Smart' 
               when (carrier='sun') then 'Sun' 
               else upper(carrier) 
          END 
       END as carrier,
       post+pre as total,
       post,
       pre
from ctm_stats_dtl
;

create view ctm_stats_summary as 
select tran_dt, 
       left(tran_dt, 7) tran_mm, 
       sum(hits_globe_pre) hits_globe_pre, 
       sum(hits_globe_post) hits_globe_post, 
       sum(mt_globe_pre) mt_globe_pre, 
       sum(mt_globe_post) mt_globe_post, 
       sum(ukmt_globe_pre) ukmt_globe_pre, 
       sum(ukmt_globe_post) ukmt_globe_post, 
       sum(mo_globe_pre) mo_globe_pre, 
       sum(mo_globe_post) mo_globe_post, 
       sum(ukmo_globe_pre) ukmo_globe_pre, 
       sum(ukmo_globe_post) ukmo_globe_post, 
       sum(reg_globe_pre) reg_globe_pre, 
       sum(reg_globe_post) reg_globe_post,
       sum(hits_smart_8266_pre) hits_smart_8266_pre, 
       sum(hits_smart_8266_post) hits_smart_8266_post, 
       sum(hits_smart_8267_pre) hits_smart_8267_pre, 
       sum(hits_smart_8267_post) hits_smart_8267_post, 
       sum(mt_smart_pre) mt_smart_pre, 
       sum(mt_smart_post) mt_smart_post, 
       sum(ukmt_smart_pre) ukmt_smart_pre, 
       sum(ukmt_smart_post) ukmt_smart_post, 
       sum(mo_smart_pre) mo_smart_pre, 
       sum(mo_smart_post) mo_smart_post, 
       sum(ukmo_smart_pre) ukmo_smart_pre, 
       sum(ukmo_smart_post) ukmo_smart_post, 
       sum(reg_smart_pre) reg_smart_pre,
       sum(reg_smart_post) reg_smart_post, 
       sum(hits_sun_pre) hits_sun_pre, 
       sum(hits_sun_post) hits_sun_post, 
       sum(mt_sun_pre) mt_sun_pre, 
       sum(mt_sun_post) mt_sun_post, 
       sum(ukmt_sun_pre) ukmt_sun_pre, 
       sum(ukmt_sun_post) ukmt_sun_post,
       sum(mo_sun_pre) mo_sun_pre, 
       sum(mo_sun_post) mo_sun_post, 
       sum(ukmo_sun_pre) ukmo_sun_pre, 
       sum(ukmo_sun_post) ukmo_sun_post, 
       sum(reg_sun_pre) reg_sun_pre,   
       sum(reg_sun_post) reg_sun_post,  
       sum(login_android) login_android, 
       sum(login_chrome) login_chrome,  
       sum(login_client) login_client,  
       sum(login_ios) login_ios,     
       sum(login_web) login_web,     
       sum(login_others) login_others,     
       sum(p2p_msg) p2p_msg   
from ctm_stats
group  by tran_dt, left(tran_dt, 7)
;


delimiter //

drop procedure IF EXISTS sp_generate_ctm_stats//

CREATE PROCEDURE sp_generate_ctm_stats(p_datein varchar(10))
begin
   DECLARE vDatein Varchar(10);
   DECLARE nCtr int;
   SELECT date_format(p_datein, '%Y-%m-%d') INTO vDatein;
   IF vDatein is null THEN
      SELECT "Please enter p_datein in format 'YYYY-MM-DD'" as 'Error Message', max(tran_dt) AS 'Latest CTM STATS is as of'
      FROM ctm_stats;
   ELSE
      SELECT count(1)
      INTO nCtr
      FROM ctm_stats
      WHERE tran_dt = vDatein;

      IF nCtr > 0 THEN
         SELECT concat('CTM stats for ', vDatein, ' already exists!') as 'Error Message', max(tran_dt) AS 'Latest CTM STATS is as of'
         FROM ctm_stats;
      ELSE
         insert into ctm_stats (tran_dt, tran_tm, hits_globe_pre, hits_globe_post, hits_smart_8266_pre, hits_smart_8266_post, hits_smart_8267_pre, hits_smart_8267_post, hits_sun_pre, hits_sun_post, mo_globe_pre, mo_globe_post, mo_smart_pre, mo_smart_post, mo_sun_pre, mo_sun_post, mt_globe_pre, mt_globe_post, mt_smart_pre, mt_smart_post, mt_sun_pre, mt_sun_post, ukmo_globe_pre, ukmo_globe_post, ukmo_smart_pre, ukmo_smart_post, ukmo_sun_pre, ukmo_sun_post, ukmt_globe_pre, ukmt_globe_post, ukmt_smart_pre, ukmt_smart_post, ukmt_sun_pre, ukmt_sun_post)
         select tran_dt, '00:00' tran_tm, sum(hits_globe_pre), sum(hits_globe_post), sum(hits_smart_8266_pre), sum(hits_smart_8266_post), sum(hits_smart_8267_pre), sum(hits_smart_8267_post), sum(hits_sun_pre), sum(hits_sun_post), sum(mo_globe_pre), sum(mo_globe_post), sum(mo_smart_pre), sum(mo_smart_post), sum(mo_sun_pre), sum(mo_sun_post), sum(mt_globe_pre), sum(mt_globe_post), sum(mt_smart_pre), sum(mt_smart_post), sum(mt_sun_pre), sum(mt_sun_post), sum(ukmo_globe_pre) ukmo_globe_pre, sum(ukmo_globe_post) ukmo_globe_post, sum(ukmo_smart_pre) ukmo_smart_pre, sum(ukmo_smart_post) ukmo_smart_post, sum(ukmo_sun_pre) ukmo_sun_pre, sum(ukmo_sun_post) ukmo_sun_post, sum(ukmt_globe_pre) ukmt_globe_pre, sum(ukmt_globe_post) ukmt_globe_post, sum(ukmt_smart_pre) ukmt_smart_pre, sum(ukmt_smart_post) ukmt_smart_post, sum(ukmt_sun_pre) ukmt_sun_pre, sum(ukmt_sun_post) ukmt_sun_post
         from (
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, sum(pre) hits_sun_pre, sum(post) hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'sun' and type = 'hits'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all
         select tran_dt, tran_tm, sum(pre) hits_globe_pre, sum(post) hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'globe' and type = 'hits'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, sum(pre) hits_smart_8266_pre, sum(post) hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'smart8266' and type = 'hits'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, sum(pre) hits_smart_8267_pre, sum(post) hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'smart8267' and type = 'hits'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, sum(pre) mt_globe_pre, sum(post) mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'globe' and type = 'mt'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, sum(pre) mt_smart_pre, sum(post) mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'smart' and type = 'mt'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, sum(pre)  mt_sun_pre, sum(post) mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'sun' and type = 'mt'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, sum(pre) mo_globe_pre, sum(post) mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'globe' and type = 'mo'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, sum(pre) mo_smart_pre, sum(post) mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'smart' and type = 'mo'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, sum(pre) mo_sun_pre, sum(post) mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'sun' and type = 'mo'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, sum(pre) ukmo_globe_pre, sum(post) ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'globe' and type = 'ukmo'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, sum(pre) ukmo_smart_pre, sum(post) ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'smart' and type = 'ukmo'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, sum(pre) ukmo_sun_pre, sum(post) ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'sun' and type = 'ukmo'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, sum(pre) ukmt_globe_pre, sum(post) ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'globe' and type = 'ukmt'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, sum(pre) ukmt_smart_pre, sum(post) ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'smart' and type = 'ukmt'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, sum(pre) ukmt_sun_pre, sum(post) ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'sun' and type = 'ukmt'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         ) tab1
         group  by tran_dt;
      END IF;
   END IF;
end;
//


drop procedure IF EXISTS sp_generate_ctm_stats_csg//

CREATE PROCEDURE sp_generate_ctm_stats_csg()
begin
   declare vTableName, vDatabase, vTranDate varchar(30);
   SET vTableName = concat('sms_out_', date_format(date_sub(curdate(), interval 1 day), '%m%d%y'));
   SET vTranDate  = date_sub(curdate(), interval 1 day), '%m%d%y');
   SET vDatabase = '%';
   call sp_generate_ctm_stats_csg_dtl(vDatabase, vTableName);
END;
//

drop procedure IF EXISTS sp_generate_ctm_stats_csg_dtl//

CREATE PROCEDURE sp_generate_ctm_stats_csg_dtl(p_database varchar(30), p_tablename varchar(30))
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
                     SET @vSql = concat('select count(1) INTO @Hits from ', vTableName, ' where status=2 and (csg_tariff = ''CHG250'' or csg_tariff like ''CHG2.50'') and gsm_num REGEXP ''^', vPattern, '$''');
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

grant all on test.* to ctmv5@shrike.internal.chikka.com identified by 'ctmv5';
grant select on csgv3_v6.* to db_monitor@localhost;
grant execute on procedure test.sp_generate_ctm_stats_csg to db_monitor@localhost;
grant execute on procedure test.sp_generate_ctm_stats_csg_v3 to db_monitor@localhost;
grant execute on procedure test.sp_generate_ctm_stats_csg_dtl to db_monitor@localhost;
flush privileges;

db_monitor.dba@noc.chikka.com

csgv3_v6.sms_out



mysql> select * from ctm_stats_dtl where tran_dt  = '2013-10-15' and type in ('hits', 'mt');
+------------+----------+-----------+------+-------+--------+
| tran_dt    | tran_tm  | carrier   | type | post  | pre    |
+------------+----------+-----------+------+-------+--------+
| 2013-10-15 | 00:00:00 | smart     | mt   | 28144 | 892394 |
| 2013-10-15 | 00:00:00 | smart8266 | hits |     1 |     78 |
| 2013-10-15 | 00:00:00 | smart8267 | hits |  5786 |  96064 |
+------------+----------+-----------+------+-------+--------+
3 rows in set (0.00 sec)


