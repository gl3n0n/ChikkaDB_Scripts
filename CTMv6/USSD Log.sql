select id, phone, access_code, left(replace(msg, '\n', ''), 16) msg, status, datein, timein, 'mobile' src from smsgw_in a where datein='2014-03-31' and exists (select 1 from smsgw_in b where b.datein='2014-03-31' and a.phone=b.phone and b.access_code like '*555*9%') 
union
select id, phone, access_code, left(replace(msg, '\n', ''), 16) msg, status, datein, timein from smsgw_in a where datein='2014-03-31' and exists (select 1 from smsgw_in b where b.datein='2014-03-31' and a.phone=right(b.access_code,12) and b.access_code like '*555*9%') 


DROP TABLE `ussd_log`;
CREATE TABLE `ussd_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tran_id` bigint(20) NOT NULL DEFAULT '0',
  `a_no` varchar(12) DEFAULT NULL,
  `b_no` varchar(12) DEFAULT '',
  `access_code` varchar(30) DEFAULT '',
  `msg` varchar(16) DEFAULT NULL,
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `datein` date NOT NULL DEFAULT '0000-00-00',
  `timein` time NOT NULL DEFAULT '00:00:00',
  `src` varchar(16) DEFAULT NULL,
  `charged` int(1) DEFAULT 0,
   primary key (id),
   unique (access_code,tran_id)
) ;

alter table ussd_log add key a_no_idx (a_no);
alter table ussd_log add key b_no_idx (b_no);

DROP TABLE `ussd_users`;
CREATE TABLE `ussd_users` (
  `a_no` varchar(12) DEFAULT NULL,
  `b_no` varchar(12) DEFAULT '',
  `datein` date NOT NULL DEFAULT '0000-00-00',
  `timein` time NOT NULL DEFAULT '00:00:00',
   primary key (a_no, b_no)
) ;

DROP TABLE `ussd_stats`;
CREATE TABLE `ussd_stats` (
  `datein` date NOT NULL DEFAULT '0000-00-00',
  `ussd_hits` int NOT NULL default 0,
  `ussd_cerr`  int NOT NULL default 0,
   primary key (datein)
) ;

insert into ussd_log select id, phone a_no, right(access_code, 12) b_no, access_code, left(replace(msg, '\n', ''), 16) msg, status, datein, timein, 'mobile' src from mui_ph_smart_1.smsgw_in where datein='2014-03-31' and access_code like '*555*9%';
insert into ussd_log select a.id, a.phone a_no, right(a.access_code, 12) b_no, a.access_code, left(replace(a.msg, '\n', ''), 16) msg, a.status, a.datein, a.timein from mui_ph_smart_1.smsgw_in a, ussd_log b where a.datein='2014-03-31' and a.phone=b.b_no and right(a.access_code, 12)=b.a_no;

select *, length(access_code) len from ussd_log a order by id limit 20;

select csg_session_id into @vSessionID from csgv3_v6.sms_out where msg_id = 'ph_smart_2814_ph_smart_6C286C3C0BB9C2C9B9';
status='Charged' and datesent='2014-03-01' limit 1\G
select * from csgv3_v6.sms_out where  datesent='2014-03-01' and csg_session_id=@vSessionID\G

select a_no, b_no into @vAno, @vBno from ussd_users order by rand() limit 1;
select * from ussd_log where a_no=@vAno and b_no = @vBno  union 
select * from ussd_log where a_no=@vBno and b_no = @vAno order by id;
select msg_id, gateway_id, gsm_num, access_code, suffix, left(replace(msg, '\n',' '), 16) msg, status, result, message_type, tariff, csg_tariff, datesent, timesent 
from csgv3_v6.sms_out where datesent='2014-03-01' and  gsm_num=@vBno;

select id, phone a_no, right(access_code, 12) b_no, access_code, left(replace(msg, '\n', ''), 16) msg, status, datein, timein, 'smsgw_in' src from mui_ph_smart_1.smsgw_in where datein='2014-03-31' and phone= '639202881701' and access_code like concat('%','639308318913') union
select id, phone a_no, right(access_code, 12) b_no, access_code, left(replace(msg, '\n', ''), 16) msg, status, datein, timein, 'smsgw_in' src from mui_ph_smart_1.smsgw_in where datein='2014-03-31' and phone= '639308318913' and access_code like concat('%','639202881701') union
select id, sender, recipient, origin, msg, status, datein, timein, 'bridge_in' from  mui_ph_smart_1.bridge_in where datein='2014-03-31' and origin <> 'ussd' and sender='639202881701' and recipient='639308318913' union
select id, sender, recipient, origin, msg, status, datein, timein, 'bridge_in' from  mui_ph_smart_1.bridge_in where datein='2014-03-31' and origin <> 'ussd' and sender='639308318913' and recipient='639202881701' order by datein, timein;

delete from ussd_stats;
drop procedure sp_generate_ussd_log;
delimiter //
create procedure sp_generate_ussd_log (p_trandate date) 
begin
   -- insert ussd transactions...
   delete from ussd_users;
   delete from ussd_log;
   insert into ussd_users
   select phone a_no, right(access_code, 12) b_no, min(datein), min(timein)
   from   mui_ph_smart_1.smsgw_in 
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
            select null, id, phone a_no, right(access_code, 12) b_no, access_code, left(replace(msg, '\n', ''), 16) msg, status, datein, timein, 'smsgw_in' src, 0 from mui_ph_smart_1.smsgw_in where datein=p_trandate and phone=vA_No and status=2 and access_code like concat('%',vB_No) union
            select null, id, phone a_no, right(access_code, 12) b_no, access_code, left(replace(msg, '\n', ''), 16) msg, status, datein, timein, 'smsgw_in' src, 0 from mui_ph_smart_1.smsgw_in where datein=p_trandate and phone=vB_No and status=2 and access_code like concat('%',vA_No) union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_smart', 0 from  mui_ph_smart_1.bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vA_No and status=2 and recipient=vB_No union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_smart', 0 from  mui_ph_smart_1.bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vB_No and status=2 and recipient=vA_No union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_globe', 0 from  mui_ph_globe_1.bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vA_No and status=2 and recipient=vB_No union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_globe', 0 from  mui_ph_globe_1.bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vB_No and status=2 and recipient=vA_No union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_sun', 0 from  mui_ph_sun_1.bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vA_No and status=2 and recipient=vB_No union
            select null, id, sender, recipient, origin, msg, status, datein, timein, 'mui_sun', 0 from  mui_ph_sun_1.bridge_in where datein=p_trandate and origin <> 'ussd' and sender=vB_No and status=2 and recipient=vA_No order by datein, timein;
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
                        -- if exists (select 1 from csgv3_v6.sms_out where datesent=cDatein and gsm_num=vB_No and suffix=vA_No and timesent between right(date_sub(concat(cDatein, ' ', cTimein), interval 100 second),8) and cTimein and csg_tariff = 'FREE' and status='Delivered' limit 1) then
                            UPDATE ussd_log SET charged=1 WHERE id = cID;
                            if exists (select 1 from csgv3_v6.sms_out where datesent=cDatein and gsm_num=vB_No and gateway_id like '%CAPI' and timesent between right(date_sub(concat(cDatein, ' ', cTimein), interval 120 second),8) and cTimein and status in ('Delivered','Charged') and csg_tariff <> 'FREE' limit 1) then
                              UPDATE ussd_log SET charged=2 WHERE id = cID;
                            end if;
                        -- end if;
                     else
                        -- set @USSDFlag
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

   insert into ussd_log_hist
   select * from ussd_log a
   where exists (select 1 from ussd_log b where a.datein = b.datein and a.a_no=b.a_no and a.b_no=b.b_no and b.charged > 0 );

   insert ignore into ussd_stats (datein, ussd_hits, ussd_cerr)
   select datein, sum(IF(charged=2, 1, 0)), sum(IF(charged=1, 1, 0))
   from ussd_log 
   group by datein;

end;
//
delimiter ;

echo "
call  sp_generate_ussd_log('2014-02-01');
call  sp_generate_ussd_log('2014-02-02');
call  sp_generate_ussd_log('2014-02-03');
call  sp_generate_ussd_log('2014-02-04');
call  sp_generate_ussd_log('2014-02-05');
call  sp_generate_ussd_log('2014-02-06');
call  sp_generate_ussd_log('2014-02-07');
call  sp_generate_ussd_log('2014-02-08');
call  sp_generate_ussd_log('2014-02-09');
call  sp_generate_ussd_log('2014-02-10');
call  sp_generate_ussd_log('2014-02-11');
call  sp_generate_ussd_log('2014-02-12');
call  sp_generate_ussd_log('2014-02-13');
call  sp_generate_ussd_log('2014-02-14');
call  sp_generate_ussd_log('2014-02-15');
call  sp_generate_ussd_log('2014-02-16');
call  sp_generate_ussd_log('2014-02-17');
call  sp_generate_ussd_log('2014-02-18');
call  sp_generate_ussd_log('2014-02-19');
call  sp_generate_ussd_log('2014-02-20');
call  sp_generate_ussd_log('2014-02-21');
call  sp_generate_ussd_log('2014-02-22');
call  sp_generate_ussd_log('2014-02-23');
call  sp_generate_ussd_log('2014-02-24');
call  sp_generate_ussd_log('2014-02-25');
call  sp_generate_ussd_log('2014-02-26');
call  sp_generate_ussd_log('2014-02-27');
call  sp_generate_ussd_log('2014-02-28');
call  sp_generate_ussd_log('2014-03-01');
call  sp_generate_ussd_log('2014-03-02');
call  sp_generate_ussd_log('2014-03-03');
call  sp_generate_ussd_log('2014-03-04');
call  sp_generate_ussd_log('2014-03-05');
call  sp_generate_ussd_log('2014-03-06');
call  sp_generate_ussd_log('2014-03-07');
call  sp_generate_ussd_log('2014-03-08');
call  sp_generate_ussd_log('2014-03-09');
call  sp_generate_ussd_log('2014-03-10');
call  sp_generate_ussd_log('2014-03-11');
call  sp_generate_ussd_log('2014-03-12');
call  sp_generate_ussd_log('2014-03-13');
call  sp_generate_ussd_log('2014-03-14');
call  sp_generate_ussd_log('2014-03-15');
call  sp_generate_ussd_log('2014-03-16');
call  sp_generate_ussd_log('2014-03-17');
call  sp_generate_ussd_log('2014-03-18');
call  sp_generate_ussd_log('2014-03-19');
call  sp_generate_ussd_log('2014-03-20');
call  sp_generate_ussd_log('2014-03-21');
call  sp_generate_ussd_log('2014-03-22');
call  sp_generate_ussd_log('2014-03-23');
call  sp_generate_ussd_log('2014-03-24');
call  sp_generate_ussd_log('2014-03-25');
call  sp_generate_ussd_log('2014-03-26');
call  sp_generate_ussd_log('2014-03-27');
call  sp_generate_ussd_log('2014-03-28');
call  sp_generate_ussd_log('2014-03-29');
call  sp_generate_ussd_log('2014-03-30');
call  sp_generate_ussd_log('2014-03-31');
exit" | mysql -uroot -p  -h127.0.0.1 -P3302 test 

select * from ussd_stats;
select * from ussd_log where charged=2;
select * from ussd_log where charged=1;


select '639999581332', '639999087362' into @vA_No, @vB_No;
select * from ussd_log where a_no=@vA_No and b_no = @vB_No  union
select * from ussd_log where a_no=@vB_No and b_no = @vA_No order by id;
select msg_id, gateway_id, gsm_num, access_code, suffix, left(msg, 16) msg, status, csg_tariff, datesent, timesent from csgv3_v6.sms_out where datesent='2014-03-01' and  gsm_num=@vB_No union
select msg_id, gateway_id, gsm_num, access_code, suffix, left(msg, 16) msg, status, csg_tariff, datesent, timesent from csgv3_v6.sms_out where datesent='2014-03-01' and  gsm_num=@vA_No order by datesent, timesent;
+--------+----------+--------------+--------------+--------------------+------------------+--------+------------+----------+-----------+---------+
| id     | tran_id  | a_no         | b_no         | access_code        | msg              | status | datein     | timein   | src       | charged |
+--------+----------+--------------+--------------+--------------------+------------------+--------+------------+----------+-----------+---------+
| 316317 |  2551292 | 639474750667 | 639176344783 | *555*9639176344783 | Cavite nga       |      2 | 2014-03-01 | 12:00:14 | smsgw_in  |       0 |
| 316318 |  8364101 | 639474750667 | 639176344783 | mobile             | Cavite nga       |      2 | 2014-03-01 | 12:00:15 | mui_globe |       0 |
| 316319 | 12908063 | 639176344783 | 639474750667 | mobile             | so their office  |      2 | 2014-03-01 | 12:06:55 | mui_smart |       0 |

+-----------+----------------------+--------------+-------------+--------------+------------------+----------------+--------+------------+------------+----------+
| msg_id    | gateway_id           | gsm_num      | access_code | suffix       | msg              | status         | result | csg_tariff | datesent   | timesent |
+-----------+----------------------+--------------+-------------+--------------+------------------+----------------+--------+------------+------------+----------+
| ph_globe_ | PH_GLOBE_2814_0006   | 639176344783 | 2814        | 639474750667 | Cavite nga       | Delivered      | 02     | FREE       | 2014-03-01 | 12:00:15 |
| ph_globe_ | PH_GLOBE_2814_2_CAPI | 639176344783 | 2814        |              |                  | Charged        | 20     | CHG250     | 2014-03-01 | 12:06:46 |
| ph_smart_ | PH_SMART_2814_0002   | 639474750667 | 2814        | 639176344783 | so their office  | Delivered      | 02     | FREE       | 2014-03-01 | 12:06:56 |




                     -- if (@WEBFlag = 1) and (cSrc like '2814%' or cSrc = 'mobile') and (cA_No=vB_No) then
                     --    if exists (select 1 from csgv3_v6.sms_out where datesent=cDatein and gsm_num=vB_No and suffix=vA_No and timesent between cTimein and right(date_add(concat(cDatein, ' ', cTimein), interval 30 second),8) and csg_tariff = 'FREE' limit 1) then
                     --       if exists (select 1 from csgv3_v6.sms_out where datesent=cDatein and gsm_num=vB_No and suffix is null and timesent between cTimein and right(date_add(concat(cDatein, ' ', cTimein), interval 80 second),8) and status in ('Delivered','Charged') and csg_tariff <> 'FREE' limit 1) then
                     --          UPDATE ussd_log SET charged=2 WHERE id = cID;
                     --       end if;
                     --    end if;
                     -- else
                     --    -- set @WEBFlag
                     --    if (cSrc not like '*555*%') and (cSrc not like '2814%' or cSrc = 'mobile') then
                     --       SET @WEBFlag = 1; 
                     --    else
                     --       SET @WEBFlag = 0;
                     --    end if;
                     -- end if;
