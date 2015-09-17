drop procedure if exists sp_generate_retention_main;
delimiter //
create procedure sp_generate_retention_main()
begin
   call sp_regenerate_retention_main(date_sub(curdate(), interval 1 day));
end;
//
delimiter ;

drop procedure if exists sp_regenerate_retention_main;
delimiter //
create procedure sp_regenerate_retention_main (p_trandate date)
begin
   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   delete from powerapp_retention_stats where tran_dt = p_trandate;
   delete from powerapp_retention_stats_monthly where tran_dt = p_trandate;
   -- powerapp_optout_log
   insert ignore into powerapp_optout_log (phone, datein, source, brand)
   select phone, datein, source, brand from powerapp_flu.powerapp_optout_log where datein >= date_sub(curdate(), interval 5 day);
   -- powerapp_log
   insert ignore into powerapp_log ( id, datein, phone, brand, action,  plan, validity, free, start_tm, end_tm, source ) 
   select  id, datein, phone, brand, action,  plan, validity, free, start_tm, end_tm, source from powerapp_flu.powerapp_log where datein >=  p_trandate and datein < date_add(p_trandate, interval 2 day);
   -- powerapp_users
   insert ignore into powerapp_users (phone, brand, datein ) select phone, brand, concat(datein, ' ', timein) datein from powerapp_flu.new_subscribers where datein >=  p_trandate and datein < date_add(p_trandate, interval 2 day);
   -- powerapp_users
   insert ignore into tmp_liberation_mins (phone, brand, datein ) select phone, max(brand), min(datein) from powerapp_flu.powerapp_log where datein >=  p_trandate and datein < date_add(p_trandate, interval 2 day) and plan ='MYVOLUME' group by phone;
   -- powerapp_optout_users
   insert ignore  into powerapp_optout_users (phone, brand, datein ) select phone, min(datein), min(brand) from powerapp_flu.powerapp_optout_log where datein >=  p_trandate and datein < date_add(p_trandate, interval 2 day) group by phone;

   -- TNT liberation auto renewal stats
   insert ignore into powerapp_tnt_auto_renewal_stats (tx_date, hits)
   select left(datein,10), count(1) from powerapp_log
   where datein >= p_trandate and datein < date_add(p_trandate, interval 1 day)
   and   plan = 'MYVOLUME' and source = 'auto_opt_in_liberation'
   and   brand = 'TNT'
   group by left(datein,10);

   call sp_generate_retention_stats (p_trandate);
   call sp_generate_15day_retention_stats(p_trandate);
   call sp_generate_retention_stats_monthly (p_trandate);
   call sp_generate_active_stats(date_add(p_trandate, interval 1 day));

   set @vCtr = 6;
   set @trandate = p_trandate;
   WHILE (@vCtr > 0) DO
      call sp_generate_new_mins_retention (date_sub(@trandate, interval @vCtr day));
      SET @vCtr = @vCtr - 1;      
   END WHILE;
end;
//
delimiter ;



DROP EVENT evt_pwrapp_generate_retention;
delimiter //
CREATE EVENT evt_pwrapp_generate_retention
ON SCHEDULE 
EVERY 1 DAY STARTS '2015-02-12 04:00:00' 
DO 
  call sp_regenerate_retention_main(date_sub(curdate(), interval 1 day));
//
delimiter ;





GRANT EXECUTE ON PROCEDURE `archive_powerapp_flu`.`sp_generate_retention_main` TO 'stats'@'localhost';
GRANT EXECUTE ON PROCEDURE `archive_powerapp_flu`.`sp_generate_retention_main` TO 'stats'@'10.11.4.164';
flush privileges;

create table powerapp_retention_stats (
   tran_dt date not null,
   w7_days  int default 0 not null,
   w6_days  int default 0 not null,
   w5_days  int default 0 not null,
   w4_days  int default 0 not null,
   w3_days  int default 0 not null,
   w2_days  int default 0 not null,
   w1_days  int default 0 not null,
   new_users int default 0 not null,
   wk_start date not null,
   primary key (tran_dt)
);



drop procedure if exists sp_generate_retention_stats;
delimiter //
create procedure sp_generate_retention_stats (p_trandate varchar(10))
begin

   -- count new users 
   -- truncate table powerapp_last_week_users;
   create temporary table if not exists powerapp_last_week_users ( phone varchar(12) not null, primary key (phone) );
   create temporary table if not exists powerapp_this_week_users ( phone varchar(12) not null, no_day int default 0 not null,  primary key (phone) );
   create temporary table if not exists powerapp_week_new_users  ( phone varchar(12) not null, primary key (phone) );
   truncate table powerapp_last_week_users;
   truncate table powerapp_this_week_users;
   truncate table powerapp_week_new_users;

   insert into powerapp_last_week_users 
   select phone from (
   select phone from powerapp_log
   where  datein >= date_sub(p_trandate, interval 7 day) 
   and    datein <  p_trandate
   group  by phone 
   ) t group by phone;

   insert into powerapp_this_week_users 
   select phone, count(1) no_day from (
   select left(datein,10) datein, phone from powerapp_log 
   where datein >= date_sub(p_trandate, interval 6 day) 
   and   datein < date_add(p_trandate, interval 1 day)
   group by left(datein,10), phone
   -- union
   -- select left(datein,10) datein, phone from powerapp_flu.powerapp_log 
   -- where datein >= date_sub(p_trandate, interval 6 day) 
   -- and   datein < date_add(p_trandate, interval 1 day)
   -- group by left(datein,10), phone
   ) t1 group by phone;

   insert into powerapp_week_new_users 
   select phone 
   from   powerapp_flu.new_subscribers
   where  datein >= date_sub(p_trandate, interval 6 day) 
   and    datein <  date_add(p_trandate, interval 1 day);

   begin
      declare vNoDay, vHits int default 0;
      declare done_p int default 0;
      declare c_pat cursor for 
         select no_day, count(distinct phone) hits 
         from powerapp_this_week_users
         group by no_day 
         order by no_day;
      
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      SET @Day_1 = 0;
      SET @Day_2 = 0;
      SET @Day_3 = 0;
      SET @Day_4 = 0;
      SET @Day_5 = 0;
      SET @Day_6 = 0;
      SET @Day_7 = 0;
      SET @NewUsers = 0;
      SET @NewOldUsers = 0;
   
      OPEN c_pat;
      REPEAT
      FETCH c_pat into vNoDay, vHits;
         if not done_p then
            if vNoDay = 1    then SET @Day_1 = vHits;
            elseif vNoDay = 2 then SET @Day_2 = vHits;
            elseif vNoDay = 3 then SET @Day_3 = vHits;
            elseif vNoDay = 4 then SET @Day_4 = vHits;
            elseif vNoDay = 5 then SET @Day_5 = vHits;
            elseif vNoDay = 6 then SET @Day_6 = vHits;
            elseif vNoDay = 7 then SET @Day_7 = vHits;
            end if;
         end if;
      UNTIL done_p
      END REPEAT;
   end;

   -- Repeater MINs
   select count(1) 
   into   @NewOldUsers
   from   powerapp_this_week_users a 
   where  exists (select 1 from powerapp_last_week_users b 
                  where a.phone = b.phone)
   and    not exists (select 1 from powerapp_week_new_users c 
                      where a.phone = c.phone);

   -- New MINs
   select count(1) - @NewOldUsers
   into   @WkNewUsers
   from   powerapp_this_week_users a
   where  not exists (select 1 from powerapp_week_new_users b 
                      where a.phone = b.phone);

   -- New MINs ever
   select count(1)
   into   @NewUsers 
   from   powerapp_week_new_users;

   drop temporary table if exists powerapp_last_week_users;
   drop temporary table if exists powerapp_this_week_users;
   drop temporary table if exists powerapp_week_new_users;

   delete from powerapp_retention_stats where tran_dt = p_trandate;
   insert into powerapp_retention_stats ( tran_dt, w7_days, w6_days, w5_days, w4_days, w3_days, w2_days, w1_days, old_users, wk_new_users, new_users, wk_start )
   values (p_trandate, @Day_7, @Day_6, @Day_5, @Day_4, @Day_3, @Day_2, @Day_1, @NewOldUsers, @WkNewUsers, @NewUsers, date_sub(p_trandate, interval 6 day) );
   select * from powerapp_retention_stats where tran_dt = p_trandate;
end;
//
delimiter ;


select * from powerapp_retention_stats where tran_dt >= '2015-08-01' and tran_dt < '2015-09-01' order by tran_dt desc;
call sp_generate_retention_stats('2015-07-01');
call sp_generate_retention_stats('2015-07-02');
call sp_generate_retention_stats('2015-07-03');
call sp_generate_retention_stats('2015-07-04');
call sp_generate_retention_stats('2015-07-05');
call sp_generate_retention_stats('2015-07-06');
call sp_generate_retention_stats('2015-07-07');
call sp_generate_retention_stats('2015-07-08');
call sp_generate_retention_stats('2015-07-09');
call sp_generate_retention_stats('2015-07-10');
call sp_generate_retention_stats('2015-07-11');
call sp_generate_retention_stats('2015-07-12');
call sp_generate_retention_stats('2015-07-13');
call sp_generate_retention_stats('2015-07-14');
call sp_generate_retention_stats('2015-07-15');
call sp_generate_retention_stats('2015-07-16');
call sp_generate_retention_stats('2015-07-17');
call sp_generate_retention_stats('2015-07-18');
call sp_generate_retention_stats('2015-07-19');
call sp_generate_retention_stats('2015-07-20');
call sp_generate_retention_stats('2015-07-21');
call sp_generate_retention_stats('2015-07-22');
call sp_generate_retention_stats('2015-07-23');
call sp_generate_retention_stats('2015-07-24');
call sp_generate_retention_stats('2015-07-25');
call sp_generate_retention_stats('2015-07-26');
call sp_generate_retention_stats('2015-07-27');
call sp_generate_retention_stats('2015-07-28');
call sp_generate_retention_stats('2015-07-29');
call sp_generate_retention_stats('2015-07-30');
call sp_generate_retention_stats('2015-07-31');


create table powerapp_15day_retention_stats (
   tran_dt date not null,
   w01_days  int default 0 not null,
   w02_days  int default 0 not null,
   w03_days  int default 0 not null,
   w04_days  int default 0 not null,
   w05_days  int default 0 not null,
   w06_days  int default 0 not null,
   w07_days  int default 0 not null,
   w08_days  int default 0 not null,
   w09_days  int default 0 not null,
   w10_days  int default 0 not null,
   w11_days  int default 0 not null,
   w12_days  int default 0 not null,
   w13_days  int default 0 not null,
   w14_days  int default 0 not null,
   w15_days  int default 0 not null,
   new_old   int default 0 not null,
   wk_start date not null,
   primary key (tran_dt)
);



DROP PROCEDURE sp_generate_15day_retention_stats;
delimiter //

CREATE PROCEDURE sp_generate_15day_retention_stats(p_trandate varchar(10))
begin
   create temporary table if not exists powerapp_15day_last_week_users ( phone varchar(12) not null, primary key (phone) );
   create temporary table if not exists powerapp_15day_this_week_users ( phone varchar(12) not null, no_day int default 0 not null,  primary key (phone) );
   create temporary table if not exists powerapp_15day_week_new_users  ( phone varchar(12) not null, primary key (phone) );
   truncate table powerapp_15day_last_week_users;
   truncate table powerapp_15day_this_week_users;
   truncate table powerapp_15day_week_new_users;

   insert into powerapp_15day_last_week_users
   select phone from (
   select phone from powerapp_log
   where  datein >= date_sub(p_trandate, interval 15 day)
   and    datein <  p_trandate
   group by phone
   ) t group by phone;

   insert into powerapp_15day_this_week_users(phone, no_day)
   select phone, count(1) no_day from (
   select left(datein,10) datein, phone from powerapp_log
   where datein >= date_sub(p_trandate, interval 14 day) and datein < date_add(p_trandate, interval 1 day)
   group by left(datein,10), phone
   -- union
   -- select left(datein,10) datein, phone from powerapp_flu.powerapp_log
   -- where datein >= date_sub(p_trandate, interval 14 day) and datein < date_add(p_trandate, interval 1 day)
   -- group by left(datein,10), phone
   ) t1 group by phone;

   insert into powerapp_15day_week_new_users 
   select phone 
   from   powerapp_flu.new_subscribers
   where  datein >= date_sub(p_trandate, interval 14 day)
   and    datein <  date_add(p_trandate, interval 1 day);

   begin
      declare vNoDay, vHits int default 0;
      declare done_p int default 0;
      declare c_pat cursor for
         select no_day, count(distinct phone) hits from powerapp_15day_this_week_users
         group by no_day order by no_day;
   
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      SET @Day_01 = 0;
      SET @Day_02 = 0;
      SET @Day_03 = 0;
      SET @Day_04 = 0;
      SET @Day_05 = 0;
      SET @Day_06 = 0;
      SET @Day_07 = 0;
      SET @Day_08 = 0;
      SET @Day_09 = 0;
      SET @Day_10 = 0;
      SET @Day_11 = 0;
      SET @Day_12 = 0;
      SET @Day_13 = 0;
      SET @Day_14 = 0;
      SET @Day_15 = 0;
      SET @NewOldUsers = 0;
   
      OPEN c_pat;
      REPEAT
      FETCH c_pat into vNoDay, vHits;
         if not done_p then
            if vNoDay = 1      then SET @Day_01 = vHits;
            elseif vNoDay = 2  then SET @Day_02 = vHits;
            elseif vNoDay = 3  then SET @Day_03 = vHits;
            elseif vNoDay = 4  then SET @Day_04 = vHits;
            elseif vNoDay = 5  then SET @Day_05 = vHits;
            elseif vNoDay = 6  then SET @Day_06 = vHits;
            elseif vNoDay = 7  then SET @Day_07 = vHits;
            elseif vNoDay = 8  then SET @Day_08 = vHits;
            elseif vNoDay = 9  then SET @Day_09 = vHits;
            elseif vNoDay = 10 then SET @Day_10 = vHits;
            elseif vNoDay = 11 then SET @Day_11 = vHits;
            elseif vNoDay = 12 then SET @Day_12 = vHits;
            elseif vNoDay = 13 then SET @Day_13 = vHits;
            elseif vNoDay = 14 then SET @Day_14 = vHits;
            elseif vNoDay = 15 then SET @Day_15 = vHits;
            end if;
         end if;
      UNTIL done_p
      END REPEAT;
   end;

   -- New MINs
   select count(1)
   into   @NewOldUsers
   from   powerapp_15day_this_week_users a
   where  exists (select 1 from powerapp_15day_last_week_users b 
                  where a.phone = b.phone)
   and    not exists (select 1 from powerapp_15day_week_new_users c
                      where a.phone = c.phone);

   -- New MINs for the week
   select count(1) - @NewOldUsers
   into   @WkNewUsers
   from   powerapp_15day_this_week_users a
   where  not exists (select 1 from powerapp_15day_week_new_users c
                      where a.phone = c.phone);

   -- New MINs Ever for this period
   select count(1)
   into   @NewUsers 
   from   powerapp_15day_week_new_users;

   drop temporary table if exists powerapp_15day_last_week_users;
   drop temporary table if exists powerapp_15day_this_week_users;
   drop temporary table if exists powerapp_15day_week_new_users;

   delete from powerapp_15day_retention_stats where tran_dt = p_trandate;
   insert into powerapp_15day_retention_stats ( tran_dt, w01_days, w02_days, w03_days, w04_days, w05_days, w06_days, w07_days, w08_days,
                                                w09_days, w10_days, w11_days, w12_days, w13_days, w14_days, w15_days, new_old, wk_start,
                                                w_total, wk_new_users, new_users )
   values (p_trandate, @Day_01, @Day_02, @Day_03, @Day_04, @Day_05, @Day_06, @Day_07, @Day_08, @Day_09, @Day_10, @Day_11, @Day_12,
                       @Day_13, @Day_14, @Day_15, @NewOldUsers, date_sub(p_trandate, interval 14 day),
                       (@Day_01+@Day_02+@Day_03+@Day_04+@Day_05+@Day_06+@Day_07+@Day_08+@Day_09+@Day_10+@Day_11+@Day_12+@Day_13+@Day_14+@Day_15),
                       @WkNewUsers, @NewUsers );

   select * from powerapp_15day_retention_stats where tran_dt = p_trandate;
end;
//
delimiter ;



call sp_generate_15day_retention_stats('2015-09-01');
call sp_generate_15day_retention_stats('2015-09-02');
call sp_generate_15day_retention_stats('2015-09-03');
call sp_generate_15day_retention_stats('2015-09-04');
call sp_generate_15day_retention_stats('2015-09-05');
call sp_generate_15day_retention_stats('2015-09-06');
call sp_generate_15day_retention_stats('2015-09-07');
call sp_generate_15day_retention_stats('2015-09-08');
call sp_generate_15day_retention_stats('2015-09-09');
call sp_generate_15day_retention_stats('2015-09-10');
call sp_generate_15day_retention_stats('2015-09-11');
call sp_generate_15day_retention_stats('2015-09-12');
call sp_generate_15day_retention_stats('2015-09-13');
call sp_generate_15day_retention_stats('2015-09-14');
call sp_generate_15day_retention_stats('2015-09-15');





DROP PROCEDURE sp_generate_retention_stats_monthly;
delimiter //

CREATE PROCEDURE sp_generate_retention_stats_monthly(p_trandate varchar(10))
begin
   create temporary table if not exists powerapp_mo_last_week_users ( phone varchar(12) not null, primary key (phone) );
   create temporary table if not exists powerapp_mo_this_week_users ( phone varchar(12) not null, no_day int default 0 not null,  primary key (phone) );
   create temporary table if not exists powerapp_mo_week_new_users  ( phone varchar(12) not null, primary key (phone) );
   truncate table powerapp_mo_last_week_users;
   truncate table powerapp_mo_this_week_users;
   truncate table powerapp_mo_week_new_users;

   insert into powerapp_mo_last_week_users
   select phone from (
   select phone from powerapp_log
   where  datein >= date_sub(p_trandate, interval 29 day)
   and    datein <  p_trandate
   group by phone
   ) t group by phone;

   insert into powerapp_mo_this_week_users (phone, no_day)
   select phone, count(1) no_day from (
   select left(datein,10) datein, phone from powerapp_log
   where datein >= date_sub(p_trandate, interval 29 day) and datein < date_add(p_trandate, interval 1 day)
   group by left(datein,10), phone
   ) t1 group by phone;

   insert into powerapp_mo_week_new_users 
   select phone 
   from   powerapp_flu.new_subscribers
   where  datein >= date_sub(p_trandate, interval 29 day)
   and    datein <  date_add(p_trandate, interval 1 day);

   begin
      declare vNoDay, vHits int default 0;
      declare done_p int default 0;
      declare c_pat cursor for
         select no_day, count(distinct phone) hits from powerapp_mo_this_week_users
         group by no_day order by no_day;
   
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      SET @Day_1  = 0; 
      SET @Day_2  = 0; 
      SET @Day_3  = 0; 
      SET @Day_4  = 0; 
      SET @Day_5  = 0; 
      SET @Day_6  = 0; 
      SET @Day_7  = 0; 
      SET @Day_8  = 0; 
      SET @Day_9  = 0; 
      SET @Day_10 = 0; 
      SET @Day_11 = 0; 
      SET @Day_12 = 0; 
      SET @Day_13 = 0; 
      SET @Day_14 = 0; 
      SET @Day_15 = 0; 
      SET @Day_16 = 0; 
      SET @Day_17 = 0; 
      SET @Day_18 = 0; 
      SET @Day_19 = 0; 
      SET @Day_20 = 0; 
      SET @Day_21 = 0; 
      SET @Day_22 = 0; 
      SET @Day_23 = 0; 
      SET @Day_24 = 0; 
      SET @Day_25 = 0; 
      SET @Day_26 = 0; 
      SET @Day_27 = 0; 
      SET @Day_28 = 0; 
      SET @Day_29 = 0; 
      SET @Day_30 = 0; 
      SET @Day_31 = 0; 
      SET @NewUsers = 0;
   
      OPEN c_pat;
      REPEAT
      FETCH c_pat into vNoDay, vHits;
         if not done_p then
            if     vNoDay = 1 then  SET @Day_1  = vHits;
            elseif vNoDay = 2 then  SET @Day_2  = vHits;
            elseif vNoDay = 3 then  SET @Day_3  = vHits;
            elseif vNoDay = 4 then  SET @Day_4  = vHits;
            elseif vNoDay = 5 then  SET @Day_5  = vHits;
            elseif vNoDay = 6 then  SET @Day_6  = vHits;
            elseif vNoDay = 7 then  SET @Day_7  = vHits;
            elseif vNoDay = 8 then  SET @Day_8  = vHits;
            elseif vNoDay = 9 then  SET @Day_9  = vHits;
            elseif vNoDay = 10 then SET @Day_10 = vHits;
            elseif vNoDay = 11 then SET @Day_11 = vHits;
            elseif vNoDay = 12 then SET @Day_12 = vHits;
            elseif vNoDay = 13 then SET @Day_13 = vHits;
            elseif vNoDay = 14 then SET @Day_14 = vHits;
            elseif vNoDay = 15 then SET @Day_15 = vHits;
            elseif vNoDay = 16 then SET @Day_16 = vHits;
            elseif vNoDay = 17 then SET @Day_17 = vHits;
            elseif vNoDay = 18 then SET @Day_18 = vHits;
            elseif vNoDay = 19 then SET @Day_19 = vHits;
            elseif vNoDay = 20 then SET @Day_20 = vHits;
            elseif vNoDay = 21 then SET @Day_21 = vHits;
            elseif vNoDay = 22 then SET @Day_22 = vHits;
            elseif vNoDay = 23 then SET @Day_23 = vHits;
            elseif vNoDay = 24 then SET @Day_24 = vHits;
            elseif vNoDay = 25 then SET @Day_25 = vHits;
            elseif vNoDay = 26 then SET @Day_26 = vHits;
            elseif vNoDay = 27 then SET @Day_27 = vHits;
            elseif vNoDay = 28 then SET @Day_28 = vHits;
            elseif vNoDay = 29 then SET @Day_29 = vHits;
            elseif vNoDay = 30 then SET @Day_30 = vHits;
            elseif vNoDay = 31 then SET @Day_31 = vHits;
            end if;
         end if;
      UNTIL done_p
      END REPEAT;
   end;
   
   select count(1)
   into   @NewOldUsers
   from   powerapp_mo_this_week_users a
   where  exists (select 1 from powerapp_mo_last_week_users b 
                  where a.phone = b.phone)
   and    not exists (select 1 from powerapp_mo_week_new_users c 
                      where a.phone = c.phone);

   -- New MINs
   select count(1) - @NewOldUsers 
   into   @WkNewUsers 
   from   powerapp_mo_this_week_users a
   where  not exists (select 1 from powerapp_mo_week_new_users b 
                      where a.phone = b.phone);

   -- New MINs ever for the period
   select count(1)
   into   @NewUsers 
   from   powerapp_mo_week_new_users;

   drop temporary table if exists powerapp_mo_last_week_users;
   drop temporary table if exists powerapp_mo_this_week_users;
   drop temporary table if exists powerapp_mo_week_new_users;

   delete from powerapp_retention_stats_monthly where tran_dt = p_trandate;
   insert into powerapp_retention_stats_monthly 
          (tran_dt, w31_days, w30_days, 
           w29_days, w28_days, w27_days, w26_days, w25_days, w24_days, w23_days, w22_days, w21_days, w20_days, 
           w19_days, w18_days, w17_days, w16_days, w15_days, w14_days, w13_days, w12_days, w11_days, w10_days, 
           w9_days, w8_days, w7_days, w6_days, w5_days, w4_days, w3_days, w2_days, w1_days, 
           new_old, wk_new_users, new_users, wk_start)
   values (p_trandate, @Day_31, @Day_30,
           @Day_29, @Day_28, @Day_27, @Day_26, @Day_25, @Day_24, @Day_23, @Day_22, @Day_21, @Day_20,
           @Day_19, @Day_18, @Day_17, @Day_16, @Day_15, @Day_14, @Day_13, @Day_12, @Day_11, @Day_10,
           @Day_9, @Day_8, @Day_7, @Day_6, @Day_5, @Day_4, @Day_3, @Day_2, @Day_1,
           @NewOldUsers, @WkNewUsers, @NewUsers, date_sub(p_trandate, interval 29 day));
   select tran_dt, @Day_31 + @Day_30 +
           @Day_29 + @Day_28 + @Day_27 + @Day_26 + @Day_25 + @Day_24 + @Day_23 + @Day_22 + @Day_21 + @Day_20 +
           @Day_19 + @Day_18 + @Day_17 + @Day_16 + @Day_15 + @Day_14 + @Day_13 + @Day_12 + @Day_11 + @Day_10 +
           @Day_9 + @Day_8 + @Day_7 + @Day_6 + @Day_5 + @Day_4 + @Day_3 + @Day_2 + @Day_1 Total_Mins,
           new_old + wk_new_users + new_users Total_Mins_S, new_old, wk_new_users, new_users 
   from powerapp_retention_stats_monthly where tran_dt = p_trandate;
end;
//
delimiter ;

call sp_generate_retention_stats_monthly('2015-09-01');
call sp_generate_retention_stats_monthly('2015-09-02');
call sp_generate_retention_stats_monthly('2015-09-03');
call sp_generate_retention_stats_monthly('2015-09-04');
call sp_generate_retention_stats_monthly('2015-09-05');
call sp_generate_retention_stats_monthly('2015-09-06');
call sp_generate_retention_stats_monthly('2015-09-07');
call sp_generate_retention_stats_monthly('2015-09-08');
call sp_generate_retention_stats_monthly('2015-09-09');
call sp_generate_retention_stats_monthly('2015-09-10');
call sp_generate_retention_stats_monthly('2015-09-11');
call sp_generate_retention_stats_monthly('2015-09-12');
call sp_generate_retention_stats_monthly('2015-09-13');
call sp_generate_retention_stats_monthly('2015-09-14');
call sp_generate_retention_stats_monthly('2015-09-15');







=================================================================================================

create table powerapp_retention_stats_plan (
   tran_dt date not null,
   plan  varchar(20) not null,
   w7_days  int default 0 not null,
   w6_days  int default 0 not null,
   w5_days  int default 0 not null,
   w4_days  int default 0 not null,
   w3_days  int default 0 not null,
   w2_days  int default 0 not null,
   w1_days  int default 0 not null,
   new_users int default 0 not null,
   tot_users int default 0 not null,
   wk_start date not null,
   primary key (tran_dt,plan)
);



drop procedure if exists sp_generate_retention_stats_plan;
delimiter //
create procedure sp_generate_retention_stats_plan (p_plan varchar(20), p_trandate varchar(10))
begin
   -- count new users 
   -- truncate table powerapp_last_week_users;
   create temporary table if not exists powerapp_last_week_users ( phone varchar(12) not null, primary key (phone) );
   create temporary table if not exists powerapp_this_week_users ( phone varchar(12) not null, no_day int default 0 not null,  primary key (phone) );
   truncate table powerapp_last_week_users;
   truncate table powerapp_this_week_users;
   truncate table powerapp_plan_users;

   insert into powerapp_last_week_users 
   select phone from (
   select phone from powerapp_flu.powerapp_log
   where  datein >= date_sub(p_trandate, interval 7 day) 
   and    datein <  p_trandate
   and    plan = p_plan
   group by phone 
   ) t group by phone;

   insert into powerapp_this_week_users 
   select phone, count(1) no_day from (
   select left(datein,10) datein, phone from powerapp_log 
   where datein >= date_sub(p_trandate, interval 6 day) 
   and   datein < date_add(p_trandate, interval 1 day) 
   and   plan = p_plan
   group by left(datein,10), phone
   union
   select left(datein,10) datein, phone from powerapp_flu.powerapp_log 
   where datein >= date_sub(p_trandate, interval 6 day) 
   and   datein < date_add(p_trandate, interval 1 day) 
   and   plan = p_plan
   group by left(datein,10), phone
   ) t1 group by phone;

   begin
      declare vNoDay, vHits int default 0;
      declare done_p int default 0;
      declare c_pat cursor for 
         select no_day, count(distinct phone) hits 
         from   powerapp_this_week_users
         group by no_day order by no_day;
      
      declare continue handler for sqlstate '02000' set done_p = 1;
   
      SET @Day_1 = 0;
      SET @Day_2 = 0;
      SET @Day_3 = 0;
      SET @Day_4 = 0;
      SET @Day_5 = 0;
      SET @Day_6 = 0;
      SET @Day_7 = 0;
      SET @NewUsers = 0;
      SET @TotalUsers = 0;
      SET @NewOldUsers = 0;
   
      OPEN c_pat;
      REPEAT
      FETCH c_pat into vNoDay, vHits;
         if not done_p then
            if vNoDay = 1    then SET @Day_1 = vHits;
            elseif vNoDay = 2 then SET @Day_2 = vHits;
            elseif vNoDay = 3 then SET @Day_3 = vHits;
            elseif vNoDay = 4 then SET @Day_4 = vHits;
            elseif vNoDay = 5 then SET @Day_5 = vHits;
            elseif vNoDay = 6 then SET @Day_6 = vHits;
            elseif vNoDay = 7 then SET @Day_7 = vHits;
            end if;
         end if;
      UNTIL done_p
      END REPEAT;
   end;

   SET @TotalUsers = @Day_1+@Day_2+@Day_3+@Day_4+@Day_4+@Day_5+@Day_6+@Day_7;

   -- Repeater MINs
   select count(1) 
   into   @NewOldUsers
   from   powerapp_this_week_users a 
   where  exists (select 1 from powerapp_last_week_users b 
                  where a.phone = b.phone);
   -- New MINs
   select count(1) - @NewOldUsers
   into   @NewUsers 
   from   powerapp_this_week_users
   where  datein = p_trandate;

   drop temporary table if exists powerapp_last_week_users;
   drop temporary table if exists powerapp_this_week_users;

   delete from powerapp_retention_stats_plan where tran_dt = p_trandate and plan = p_plan;
   insert into powerapp_retention_stats_plan ( tran_dt, plan, w7_days, w6_days, w5_days, w4_days, w3_days, w2_days, w1_days, old_users, new_users, tot_users, wk_start )
   values (p_trandate, p_plan, @Day_7, @Day_6, @Day_5, @Day_4, @Day_3, @Day_2, @Day_1, @NewOldUsers, @NewUsers, @TotalUsers, date_sub(p_trandate, interval 6 day) );

end;
//
delimiter ;


drop procedure if exists sp_generate_retention_stats_plan_main;
delimiter //
create procedure sp_generate_retention_stats_plan_main (p_plan varchar(20), p_day_st int, p_days int)
begin
   set @vCtr = p_day_st;
   WHILE (@vCtr <= p_days) DO
      SET @vSql = concat('select date_sub(curdate(), interval ', @vCtr, ' day) into @vDate');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      SELECT concat('Processing ', @vDate, '...') Date;
      SET @vCtr = @vCtr + 1; 
      call sp_generate_retention_stats_plan(p_plan, @vDate);
   END WHILE;
end;
//
delimiter ;
call sp_generate_retention_stats_plan_main('FACEBOOK', 1, 15);


select concat(tran_dt, ',', w7_days, ',', w6_days, ',', w5_days, ',', w4_days, ',', w3_days, ',', w2_days, ',', w1_days, ',', old_users, ',', 
              new_users, ',', wk_start, ',', '^', ',', 
              round((w7_days/tot_users),2), ',', round((w6_days/tot_users),2), ',', round((w5_days/tot_users),2), ',', 
              round((w4_days/tot_users),2), ',', round((w3_days/tot_users),2), ',', round((w2_days/tot_users),2), ',', 
              round((w1_days/tot_users),2), ',', round((old_users/tot_users),2), ',', round((new_users/tot_users),2))  sql_result
from  powerapp_retention_stats_plan 
where plan = 'FACEBOOK'
and   tran_dt >= '2014-05-01'
order by tran_dt;

S
+------------+---------+---------+---------+---------+---------+---------+---------+-----------+-----------+------------+
| tran_dt    | w7_days | w6_days | w5_days | w4_days | w3_days | w2_days | w1_days | old_users | new_users | wk_start   |
+------------+---------+---------+---------+---------+---------+---------+---------+-----------+-----------+------------+
| 2014-04-01 |    8995 |   19403 |   16295 |   15458 |   18485 |   31455 |  133653 |    198861 |     16908 | 2014-03-26 |
| 2014-04-02 |   10020 |   20555 |   15927 |   15579 |   18703 |   32186 |  131537 |    201993 |     14629 | 2014-03-27 |
| 2014-04-03 |   10427 |   20820 |   16498 |   15806 |   19328 |   32456 |  129210 |    203900 |     13006 | 2014-03-28 |
| 2014-04-04 |   10318 |   20198 |   17027 |   16393 |   19249 |   32116 |  123899 |    205312 |     12972 | 2014-03-29 |
| 2014-04-05 |   10627 |   19730 |   17466 |   16864 |   19767 |   32172 |  123374 |    204724 |      8782 | 2014-03-30 |
| 2014-04-06 |   10579 |   20272 |   17851 |   17079 |   20069 |   33288 |  121496 |    198178 |     13657 | 2014-03-31 |
| 2014-04-07 |   10319 |   21189 |   18498 |   16719 |   20811 |   33907 |  118752 |    199138 |     13064 | 2014-04-01 |
| 2014-04-08 |   10188 |   22200 |   18511 |   17565 |   20568 |   34215 |  162233 |    200446 |     12850 | 2014-04-02 |
| 2014-04-09 |    9932 |   23762 |   18903 |   17930 |   20970 |   39289 |  170280 |    201000 |     25662 | 2014-04-03 |
| 2014-04-10 |   10088 |   25041 |   19649 |   18130 |   23958 |   41409 |  192589 |    246663 |     23239 | 2014-04-04 |
| 2014-04-11 |   11682 |   26096 |   20065 |   20476 |   25413 |   44577 |  202599 |    269518 |     23983 | 2014-04-05 |
| 2014-04-12 |   12675 |   27219 |   21598 |   21648 |   26473 |   45286 |  206647 |    300250 |     22123 | 2014-04-06 |
| 2014-04-13 |   13354 |   29072 |   22800 |   22498 |   26899 |   46355 |  214257 |    314639 |     19588 | 2014-04-07 |
| 2014-04-14 |   11470 |   30219 |   24607 |   23475 |   27432 |   48188 |  279888 |    326114 |     22762 | 2014-04-08 |
+------------+---------+---------+---------+---------+---------+---------+---------+-----------+-----------+------------+
14 rows in set (0.00 sec)

########################################################################################################################################

create table powerapp_new_mins_plan_retention (
   tx_date  date not null,
   plan     varchar(20) not null,
   new_mins int(11) not null,
   day_1    int(11) not null,
   day_2    int(11) not null,
   day_3    int(11) not null,
   day_4    int(11) not null,
   day_5    int(11) not null,
   day_6    int(11) not null,
   day_7    int(11) not null,
   pct_1    int(11) not null,
   pct_2    int(11) not null,
   pct_3    int(11) not null,
   pct_4    int(11) not null,
   pct_5    int(11) not null,
   pct_6    int(11) not null,
   pct_7    int(11) not null,
   primary key (tx_date,plan)
);


drop procedure sp_generate_new_mins_retention;
delimiter //
create procedure sp_generate_new_mins_retention (p_trandate date)
begin
   drop temporary table if exists tmp_plan_active_users;
   drop temporary table if exists tmp_user_buys;
   drop temporary table if exists tmp_user_xday;
   create temporary table tmp_plan_active_users (phone varchar(12) not null, primary key (phone));
   create temporary table tmp_user_buys (phone varchar(12) not null, datein date not null, plan varchar(20), hits int(11), primary key (phone, datein, plan));
   create temporary table tmp_user_xday (phone varchar(12) not null, n_buys int(11), hits int(11), primary key (phone));

   insert into tmp_plan_active_users select phone from powerapp_flu.new_subscribers where datein >= p_trandate and datein < date_add(p_trandate, interval 1 day) ;
   insert into tmp_user_buys select phone, left(datein,10) date, plan, count(1) hits from powerapp_log a
   where datein >= p_trandate and datein < date_add(p_trandate, interval 8 day) 
   and exists (select 1 from tmp_plan_active_users b where a.phone = b.phone)
   group by 1,2,3;

   insert into tmp_user_xday select phone, count(1) no_times, sum(hits) hits from (
   select phone, datein, sum(hits) hits from tmp_user_buys group by phone, datein 
   ) t1 group by phone;

   select count(1) into @NewMins from tmp_plan_active_users;
   select count(distinct phone) into @nDay1 from tmp_user_buys where datein = p_trandate;
   select count(distinct phone) into @nDay2 from tmp_user_buys where datein = date_add(p_trandate, interval 1 day);
   select count(distinct phone) into @nDay3 from tmp_user_buys where datein = date_add(p_trandate, interval 2 day);
   select count(distinct phone) into @nDay4 from tmp_user_buys where datein = date_add(p_trandate, interval 3 day);
   select count(distinct phone) into @nDay5 from tmp_user_buys where datein = date_add(p_trandate, interval 4 day);
   select count(distinct phone) into @nDay6 from tmp_user_buys where datein = date_add(p_trandate, interval 5 day);
   select count(distinct phone) into @nDay7 from tmp_user_buys where datein = date_add(p_trandate, interval 6 day);

   select p_trandate tx_date, @NewMins, @nDay1, @nDay2, @nDay3, @nDay4, @nDay5, @nDay6, @nDay7;
   delete from powerapp_new_mins_retention where tx_date = p_trandate;
   insert into powerapp_new_mins_retention
          (tx_date, new_mins, 
           day_2, day_3, day_4, day_5, day_6, day_7,
           pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 )
   values (p_trandate, @NewMins, 
           @nDay2, @nDay3, @nDay4, @nDay5, @nDay6, @nDay7, 
           IF(@nDay2=0, 0, round((@nDay2/@NewMins)*100,0)), IF(@nDay3=0, 0, round((@nDay3/@NewMins)*100,0)), 
           IF(@nDay4=0, 0, round((@nDay4/@NewMins)*100,0)), IF(@nDay5=0, 0, round((@nDay5/@NewMins)*100,0)), 
           IF(@nDay6=0, 0, round((@nDay6/@NewMins)*100,0)), IF(@nDay7=0, 0, round((@nDay7/@NewMins)*100,0)) 
          );
   call sp_generate_new_mins_plan_retention(p_trandate);
end;
//
delimiter ;




DROP PROCEDURE sp_generate_new_mins_plan_retention;
delimiter //

CREATE PROCEDURE sp_generate_new_mins_plan_retention(p_trandate date)
begin
   drop temporary table if exists tmp_plan_active_users;
   drop temporary table if exists tmp_user_buys;
   drop temporary table if exists tmp_user_xday;
   create temporary table tmp_plan_active_users (phone varchar(12) not null, primary key (phone));
   create temporary table tmp_user_buys (phone varchar(12) not null, datein date not null, plan varchar(20), hits int(11), primary key (phone, datein, plan));
   create temporary table tmp_user_xday (phone varchar(12) not null, n_buys int(11), hits int(11), primary key (phone));

   insert into tmp_plan_active_users select phone from powerapp_flu.new_subscribers where datein >= p_trandate and datein < date_add(p_trandate, interval 1 day) ;
   insert into tmp_user_buys select phone, left(datein,10) date, plan, count(1) hits from powerapp_log a
   where datein > p_trandate and datein < date_add(p_trandate, interval 7 day)
   and exists (select 1 from tmp_plan_active_users b where a.phone = b.phone)
   group by 1,2,3;

   insert into tmp_user_xday select phone, count(1) no_times, sum(hits) hits from (
   select phone, datein, sum(hits) hits from tmp_user_buys group by phone, datein
   ) t1 group by phone;

   delete from powerapp_new_mins_plan_retention where tx_date = p_trandate;
   select count(1) into @NewMins from tmp_plan_active_users;

   begin
      declare done_p int default 0;
      declare vPlan varchar(20);
      declare c_pat cursor for select plan from powerapp_plans group by plan;

      declare continue handler for sqlstate '02000' set done_p = 1;

      OPEN c_pat;
      REPEAT
         FETCH c_pat into vPlan;
         if not done_p then
            select count(distinct phone) into @nDay1 from tmp_user_buys where datein = p_trandate and plan = vPlan;
            select count(distinct phone) into @nDay2 from tmp_user_buys where datein = date_add(p_trandate, interval 1 day) and plan = vPlan;
            select count(distinct phone) into @nDay3 from tmp_user_buys where datein = date_add(p_trandate, interval 2 day) and plan = vPlan;
            select count(distinct phone) into @nDay4 from tmp_user_buys where datein = date_add(p_trandate, interval 3 day) and plan = vPlan;
            select count(distinct phone) into @nDay5 from tmp_user_buys where datein = date_add(p_trandate, interval 4 day) and plan = vPlan;
            select count(distinct phone) into @nDay6 from tmp_user_buys where datein = date_add(p_trandate, interval 5 day) and plan = vPlan;
            select count(distinct phone) into @nDay7 from tmp_user_buys where datein = date_add(p_trandate, interval 6 day) and plan = vPlan;

            if @nDay1 is null then
               set @nDay1=0;
            end if;
            insert into powerapp_new_mins_plan_retention
                   (tx_date, plan, new_mins,
                    day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                    pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 )
            values (p_trandate, vPlan, @NewMins,
                    @nDay1, @nDay2, @nDay3, @nDay4, @nDay5, @nDay6, @nDay7,
                    IF(@nDay1=0, 0, round((@nDay1/@NewMins)*100,0)),
                    IF(@nDay2=0, 0, round((@nDay2/@NewMins)*100,0)), IF(@nDay3=0, 0, round((@nDay3/@NewMins)*100,0)),
                    IF(@nDay4=0, 0, round((@nDay4/@NewMins)*100,0)), IF(@nDay5=0, 0, round((@nDay5/@NewMins)*100,0)),
                    IF(@nDay6=0, 0, round((@nDay6/@NewMins)*100,0)), IF(@nDay7=0, 0, round((@nDay7/@NewMins)*100,0))
                   );
         end if;
      UNTIL done_p
      END REPEAT;
   end;
   select * from powerapp_new_mins_plan_retention where tx_date = p_trandate;
end;
//
delimiter ;

