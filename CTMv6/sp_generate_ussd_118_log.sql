delete from ussd_118_stats;
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
            select null, id, phone a_no, right(access_code, 12) b_no, access_code, left(replace(msg, '\n', ''), 16) msg, status, datein, timein, 'smsgw_in' src, 0 from smsgw_in where datein=p_trandate and phone=vA_No and status=2 and access_code like concat('%',vB_No) union
            select null, id, phone a_no, right(access_code, 12) b_no, access_code, left(replace(msg, '\n', ''), 16) msg, status, datein, timein, 'smsgw_in' src, 0 from smsgw_in where datein=p_trandate and phone=vB_No and status=2 and access_code like concat('%',vA_No) union
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


call  sp_generate_ussd_118_log('2015-02-27');
call  sp_generate_ussd_118_log('2015-02-28');
