SERVER: VEGA

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


insert into ctm_stats_dtl select tran_dt, carrier, type, 0 post, hits from ctm_stats_dtl_reg where tran_dt <= '2013-06-13' and type = 'p2p'; 

call sp_generate_ctm_stats_reg('2013-01-01');
call sp_generate_ctm_stats_reg('2013-04-30');
call sp_generate_ctm_stats_reg('2013-05-01');
call sp_generate_ctm_stats_reg(null);

select tran_dt, type, carrier, sum(post), sum(pre) from (
select tran_dt, type, carrier, sum(hits) post, 0 pre from ctm_stats_dtl_reg where sim_type = 'POSTPAID' group by 1,2,3 union
select tran_dt, type, carrier, 0 post, sum(hits) pre from ctm_stats_dtl_reg where sim_type <> 'POSTPAID' and sim_type <> 'OTHERS' group by 1,2,3 union
select tran_dt, type, carrier, 0 post, sum(hits) pre from ctm_stats_dtl_reg where sim_type = 'OTHERS' group by 1,2,3
) as t group by 1,2,3;



| 2013-04-30 | reg    | GLOBE   |       653 |     6318 |        6971 |
| 2013-04-30 | reg    | SMART   |       343 |     9869 |       10212 |
| 2013-04-30 | reg    | SUN     |       358 |     2254 |        2612 |
| 2013-04-30 | reg    | TOTAL   |         0 |        0 |       22910 |

set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;


call sp_generate_ctm_stats_reg('2013-01-01', 'login');
call sp_generate_ctm_stats_reg('2013-01-02');
call sp_generate_ctm_stats_reg('2013-01-03');
call sp_generate_ctm_stats_reg('2013-01-04');
call sp_generate_ctm_stats_reg('2013-01-05');
call sp_generate_ctm_stats_reg('2013-01-06');
call sp_generate_ctm_stats_reg('2013-01-07');
call sp_generate_ctm_stats_reg('2013-01-08');
call sp_generate_ctm_stats_reg('2013-01-09');
call sp_generate_ctm_stats_reg('2013-01-10');
call sp_generate_ctm_stats_reg('2013-01-11');
call sp_generate_ctm_stats_reg('2013-01-12');
call sp_generate_ctm_stats_reg('2013-01-13');
call sp_generate_ctm_stats_reg('2013-01-14');
call sp_generate_ctm_stats_reg('2013-01-15');
call sp_generate_ctm_stats_reg('2013-01-16');
call sp_generate_ctm_stats_reg('2013-01-17');
call sp_generate_ctm_stats_reg('2013-01-18');
call sp_generate_ctm_stats_reg('2013-01-19');
call sp_generate_ctm_stats_reg('2013-01-20');
call sp_generate_ctm_stats_reg('2013-01-21');
call sp_generate_ctm_stats_reg('2013-01-22');
call sp_generate_ctm_stats_reg('2013-01-23');
call sp_generate_ctm_stats_reg('2013-01-24');
call sp_generate_ctm_stats_reg('2013-01-25');
call sp_generate_ctm_stats_reg('2013-01-26');
call sp_generate_ctm_stats_reg('2013-01-27');
call sp_generate_ctm_stats_reg('2013-01-28');
call sp_generate_ctm_stats_reg('2013-01-29');
call sp_generate_ctm_stats_reg('2013-01-30');
call sp_generate_ctm_stats_reg('2013-01-31');
call sp_generate_ctm_stats_reg('2013-02-01', 'all');
call sp_generate_ctm_stats_reg('2013-02-02', 'all');
call sp_generate_ctm_stats_reg('2013-02-03', 'all');
call sp_generate_ctm_stats_reg('2013-02-04', 'all');
call sp_generate_ctm_stats_reg('2013-02-05', 'all');
call sp_generate_ctm_stats_reg('2013-02-06', 'all');
call sp_generate_ctm_stats_reg('2013-02-07', 'all');
call sp_generate_ctm_stats_reg('2013-02-08', 'all');
call sp_generate_ctm_stats_reg('2013-02-09', 'all');
call sp_generate_ctm_stats_reg('2013-02-10', 'all');
call sp_generate_ctm_stats_reg('2013-02-11', 'all');
call sp_generate_ctm_stats_reg('2013-02-12', 'all');
call sp_generate_ctm_stats_reg('2013-02-13', 'all');
call sp_generate_ctm_stats_reg('2013-02-14', 'all');
call sp_generate_ctm_stats_reg('2013-02-15', 'all');
call sp_generate_ctm_stats_reg('2013-02-16', 'all');
call sp_generate_ctm_stats_reg('2013-02-17', 'all');
call sp_generate_ctm_stats_reg('2013-02-18', 'all');
call sp_generate_ctm_stats_reg('2013-02-19', 'all');
call sp_generate_ctm_stats_reg('2013-02-20', 'all');
call sp_generate_ctm_stats_reg('2013-02-21', 'all');
call sp_generate_ctm_stats_reg('2013-02-22', 'all');
call sp_generate_ctm_stats_reg('2013-02-23', 'all');
call sp_generate_ctm_stats_reg('2013-02-24', 'all');
call sp_generate_ctm_stats_reg('2013-02-25', 'all');
call sp_generate_ctm_stats_reg('2013-02-26', 'all');
call sp_generate_ctm_stats_reg('2013-02-27', 'all');
call sp_generate_ctm_stats_reg('2013-02-28', 'all');
call sp_generate_ctm_stats_reg('2013-02-29', 'all');
call sp_generate_ctm_stats_reg('2013-03-01', 'all');
call sp_generate_ctm_stats_reg('2013-03-02', 'all');
call sp_generate_ctm_stats_reg('2013-03-03', 'all');
call sp_generate_ctm_stats_reg('2013-03-04', 'all');
call sp_generate_ctm_stats_reg('2013-03-05', 'all');
call sp_generate_ctm_stats_reg('2013-03-06', 'all');
call sp_generate_ctm_stats_reg('2013-03-07', 'all');
call sp_generate_ctm_stats_reg('2013-03-08', 'all');
call sp_generate_ctm_stats_reg('2013-03-09', 'all');
call sp_generate_ctm_stats_reg('2013-03-10', 'all');
call sp_generate_ctm_stats_reg('2013-03-11', 'all');
call sp_generate_ctm_stats_reg('2013-03-12', 'all');
call sp_generate_ctm_stats_reg('2013-03-13', 'all');
call sp_generate_ctm_stats_reg('2013-03-14', 'all');
call sp_generate_ctm_stats_reg('2013-03-15', 'all');
call sp_generate_ctm_stats_reg('2013-03-16', 'all');
call sp_generate_ctm_stats_reg('2013-03-17', 'all');
call sp_generate_ctm_stats_reg('2013-03-18', 'all');
call sp_generate_ctm_stats_reg('2013-03-19', 'all');
call sp_generate_ctm_stats_reg('2013-03-20', 'all');
call sp_generate_ctm_stats_reg('2013-03-21', 'all');
call sp_generate_ctm_stats_reg('2013-03-22', 'all');
call sp_generate_ctm_stats_reg('2013-03-23', 'all');
call sp_generate_ctm_stats_reg('2013-03-24', 'all');
call sp_generate_ctm_stats_reg('2013-03-25', 'all');
call sp_generate_ctm_stats_reg('2013-03-26', 'all');
call sp_generate_ctm_stats_reg('2013-03-27', 'all');
call sp_generate_ctm_stats_reg('2013-03-28', 'all');
call sp_generate_ctm_stats_reg('2013-03-29', 'all');
call sp_generate_ctm_stats_reg('2013-03-30', 'all');
call sp_generate_ctm_stats_reg('2013-03-31', 'all');
call sp_generate_ctm_stats_reg('2013-04-01', 'all');
call sp_generate_ctm_stats_reg('2013-04-02', 'all');
call sp_generate_ctm_stats_reg('2013-04-03', 'all');
call sp_generate_ctm_stats_reg('2013-04-04', 'all');
call sp_generate_ctm_stats_reg('2013-04-05', 'all');
call sp_generate_ctm_stats_reg('2013-04-06', 'all');
call sp_generate_ctm_stats_reg('2013-04-07', 'all');
call sp_generate_ctm_stats_reg('2013-04-08', 'all');
call sp_generate_ctm_stats_reg('2013-04-09', 'all');
call sp_generate_ctm_stats_reg('2013-04-10', 'all');
call sp_generate_ctm_stats_reg('2013-04-11', 'all');
call sp_generate_ctm_stats_reg('2013-04-12', 'all');
call sp_generate_ctm_stats_reg('2013-04-13', 'all');
call sp_generate_ctm_stats_reg('2013-04-14', 'all');
call sp_generate_ctm_stats_reg('2013-04-15', 'all');
call sp_generate_ctm_stats_reg('2013-04-16', 'all');
call sp_generate_ctm_stats_reg('2013-04-17', 'all');
call sp_generate_ctm_stats_reg('2013-04-18', 'all');
call sp_generate_ctm_stats_reg('2013-04-19', 'all');
call sp_generate_ctm_stats_reg('2013-04-20', 'all');
call sp_generate_ctm_stats_reg('2013-04-21', 'all');
call sp_generate_ctm_stats_reg('2013-04-22', 'all');
call sp_generate_ctm_stats_reg('2013-04-23', 'all');
call sp_generate_ctm_stats_reg('2013-04-24', 'all');
call sp_generate_ctm_stats_reg('2013-04-25', 'all');
call sp_generate_ctm_stats_reg('2013-04-26', 'all');
call sp_generate_ctm_stats_reg('2013-04-27', 'all');
call sp_generate_ctm_stats_reg('2013-04-28', 'all');
call sp_generate_ctm_stats_reg('2013-04-29', 'all');


call sp_generate_ctm_stats_reg('2013-06-01', 'p2p');
call sp_generate_ctm_stats_reg('2013-06-02', 'p2p');
call sp_generate_ctm_stats_reg('2013-06-03', 'p2p');
call sp_generate_ctm_stats_reg('2013-06-04', 'p2p');
call sp_generate_ctm_stats_reg('2013-06-05', 'p2p');
call sp_generate_ctm_stats_reg('2013-06-06', 'p2p');
call sp_generate_ctm_stats_reg('2013-06-07', 'p2p');
call sp_generate_ctm_stats_reg('2013-06-08', 'p2p');
call sp_generate_ctm_stats_reg('2013-06-09', 'p2p');
call sp_generate_ctm_stats_reg('2013-06-10', 'p2p');
call sp_generate_ctm_stats_reg('2013-06-11', 'p2p');
call sp_generate_ctm_stats_reg('2013-06-12', 'p2p');
call sp_generate_ctm_stats_reg('2013-06-13', 'p2p');
call sp_generate_ctm_stats_reg('2013-06-14', 'p2p');
call sp_generate_ctm_stats_reg('2013-04-15', 'p2p');
call sp_generate_ctm_stats_reg('2013-04-16', 'p2p');
