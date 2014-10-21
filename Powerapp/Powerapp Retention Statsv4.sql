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
   -- powerapp_optout_users
   insert ignore  into powerapp_optout_users (phone, brand, datein ) select phone, min(datein), min(brand) from powerapp_flu.powerapp_optout_log where datein >=  p_trandate and datein < date_add(p_trandate, interval 2 day) group by phone;
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
   declare vNoDay, vHits int default 0;
   declare done_p int default 0;
   declare c_pat cursor for 
      select no_day, count(distinct phone) hits from (
      select phone, count(1) no_day from (
      select left(datein,10) datein, phone, count(1) hits from powerapp_log 
      where datein < date_add(p_trandate, interval 1 day) and  datein >= date_sub(p_trandate, interval 6 day) 
      group by left(datein,10), phone
      union
      select left(datein,10) datein, phone, count(1) hits from powerapp_flu.powerapp_log 
      where datein < date_add(p_trandate, interval 1 day) and  datein >= date_sub(p_trandate, interval 6 day) 
      group by left(datein,10), phone
      ) t1 group by phone
      ) t2
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

   -- count new users 
   -- truncate table powerapp_last_week_users;
   create temporary table if not exists powerapp_last_week_users ( phone varchar(12) not null, primary key (phone) );
   create temporary table if not exists powerapp_this_week_users ( phone varchar(12) not null, primary key (phone) );
   create temporary table if not exists powerapp_week_new_users  ( phone varchar(12) not null, primary key (phone) );
   truncate table powerapp_last_week_users;
   truncate table powerapp_this_week_users;
   truncate table powerapp_week_new_users;

   insert into powerapp_last_week_users 
   select phone from (
   select phone from powerapp_flu.powerapp_log
   where  datein >= date_sub(p_trandate, interval 7 day) 
   and    datein <  date_sub(p_trandate, interval 1 day) group by phone 
   ) t group by phone;

   insert into powerapp_this_week_users 
   select phone from (
   select phone from powerapp_flu.powerapp_log
   where  datein >= date_sub(p_trandate, interval 6 day) 
   and    datein <  p_trandate group by phone 
   ) t group by phone;

   insert into powerapp_week_new_users 
   select phone 
   from   powerapp_flu.new_subscribers
   where  datein >= date_sub(p_trandate, interval 6 day) 
   and    datein <  p_trandate;

   -- Repeater MINs
   select count(1) 
   into   @NewOldUsers
   from   powerapp_this_week_users a 
   where  exists (select 1 from powerapp_last_week_users b 
                  where a.phone = b.phone)
   and    not exists (select 1 from powerapp_week_new_users c 
                  where a.phone = c.phone);
   -- New MINs
   select count(1) 
   into   @NewUsers 
   from   powerapp_week_new_users;
   
   drop temporary table if exists powerapp_last_week_users;
   drop temporary table if exists powerapp_this_week_users;
   drop temporary table if exists powerapp_week_new_users;

   delete from powerapp_retention_stats where tran_dt = p_trandate;
   insert into powerapp_retention_stats ( tran_dt, w7_days, w6_days, w5_days, w4_days, w3_days, w2_days, w1_days, old_users, new_users, wk_start )
   values (p_trandate, @Day_7, @Day_6, @Day_5, @Day_4, @Day_3, @Day_2, @Day_1, @NewOldUsers, @NewUsers, date_sub(p_trandate, interval 6 day) );

end;
//
delimiter ;


select * from powerapp_retention_stats order by tran_dt desc;


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
   declare vNoDay, vHits int default 0;
   declare done_p int default 0;
   declare c_pat cursor for 
      select no_day, count(distinct phone) hits from (
      select phone, count(1) no_day from (
      select left(datein,10) datein, phone, count(1) hits from powerapp_log 
      where datein < date_add(p_trandate, interval 1 day) and  datein >= date_sub(p_trandate, interval 6 day) 
      and   plan = p_plan
      group by left(datein,10), phone
      union
      select left(datein,10) datein, phone, count(1) hits from powerapp_flu.powerapp_log 
      where datein < date_add(p_trandate, interval 1 day) and  datein >= date_sub(p_trandate, interval 6 day) 
      and   plan = p_plan
      group by left(datein,10), phone
      ) t1 group by phone
      ) t2
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

   SET @TotalUsers = @Day_1+@Day_2+@Day_3+@Day_4+@Day_4+@Day_5+@Day_6+@Day_7;

   -- count new users 
   -- truncate table powerapp_last_week_users;
   create temporary table if not exists powerapp_last_week_users ( phone varchar(12) not null, primary key (phone) );
   create temporary table if not exists powerapp_this_week_users ( phone varchar(12) not null, primary key (phone) );
   create temporary table if not exists powerapp_plan_users ( phone varchar(12) not null, datein date, primary key (phone), key datein_idx(datein) );
   truncate table powerapp_last_week_users;
   truncate table powerapp_this_week_users;
   truncate table powerapp_plan_users;

   insert into powerapp_last_week_users 
   select phone from (
   select phone from powerapp_flu.powerapp_log
   where  datein >= date_sub(p_trandate, interval 7 day) 
   and    datein <  date_sub(p_trandate, interval 1 day) 
   and    plan = p_plan
   group by phone 
   ) t group by phone;

   insert into powerapp_this_week_users 
   select phone from (
   select phone from powerapp_flu.powerapp_log
   where  datein >= date_sub(p_trandate, interval 6 day) 
   and    datein <  p_trandate
   and    plan = p_plan
   group by phone 
   ) t group by phone;

   insert into powerapp_plan_users 
   select phone, min(datein) datein from (
   select phone, min(datein) datein from powerapp_log
   where  datein <  date_add(p_trandate, interval 1 day) 
   and    plan = p_plan
   group by phone 
   ) t group by phone;

   -- Repeater MINs
   select count(1) 
   into   @NewOldUsers
   from   powerapp_this_week_users a 
   where  exists (select 1 from powerapp_last_week_users b 
                  where a.phone = b.phone);
   -- New MINs
   select count(1) 
   into   @NewUsers 
   from   powerapp_plan_users
   where  datein = p_trandate;

   drop temporary table if exists powerapp_last_week_users;
   drop temporary table if exists powerapp_this_week_users;
   drop temporary table if exists powerapp_plan_users;

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
   declare vNoDay, vHits int default 0;
   declare done_p int default 0;
   declare c_pat cursor for
      select no_day, count(distinct phone) hits from (
      select phone, count(1) no_day from (
      select left(datein,10) datein, phone, count(1) hits from powerapp_log
      where datein < date_add(p_trandate, interval 1 day) and  datein >= date_sub(p_trandate, interval 14 day)
      group by left(datein,10), phone
      union
      select left(datein,10) datein, phone, count(1) hits from powerapp_flu.powerapp_log
      where datein < date_add(p_trandate, interval 1 day) and  datein >= date_sub(p_trandate, interval 14 day)
      group by left(datein,10), phone
      ) t1 group by phone
      ) t2
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

   create temporary table if not exists powerapp_last_week_users ( phone varchar(12) not null, primary key (phone) );
   create temporary table if not exists powerapp_this_week_users ( phone varchar(12) not null, primary key (phone) );
   create temporary table if not exists powerapp_week_new_users  ( phone varchar(12) not null, primary key (phone) );
   truncate table powerapp_last_week_users;
   truncate table powerapp_this_week_users;
   truncate table powerapp_week_new_users;

   insert into powerapp_last_week_users
   select phone from (
   select phone from powerapp_flu.powerapp_log
   where  datein >= date_sub(p_trandate, interval 15 day)
   and    datein <  p_trandate
   group by phone
   ) t group by phone;

   insert into powerapp_this_week_users
   select phone from (
   select phone from powerapp_flu.powerapp_log
   where  datein >= date_sub(p_trandate, interval 14 day)
   and    datein <  date_add(p_trandate, interval 1 day)
   group by phone
   ) t group by phone;

   insert into powerapp_week_new_users 
   select phone 
   from   powerapp_flu.new_subscribers
   where  datein >= date_sub(p_trandate, interval 14 day)
   and    datein <  date_add(p_trandate, interval 1 day);

   select count(1)
   into   @NewOldUsers
   from   powerapp_this_week_users a
   where  exists (select 1 from powerapp_last_week_users b 
                  where a.phone = b.phone)
   and    not exists (select 1 from powerapp_week_new_users c 
                  where a.phone = c.phone);

   -- New MINs
   select count(1) 
   into   @NewUsers 
   from   powerapp_week_new_users;

   drop temporary table if exists powerapp_last_week_users;
   drop temporary table if exists powerapp_this_week_users;
   drop temporary table if exists powerapp_week_new_users;

   delete from powerapp_15day_retention_stats where tran_dt = p_trandate;
   insert into powerapp_15day_retention_stats ( tran_dt, w01_days, w02_days, w03_days, w04_days, w05_days, w06_days, w07_days, w08_days,
                                                w09_days, w10_days, w11_days, w12_days, w13_days, w14_days, w15_days, new_old, wk_start,
                                                w_total, new_users )
   values (p_trandate, @Day_01, @Day_02, @Day_03, @Day_04, @Day_05, @Day_06, @Day_07, @Day_08, @Day_09, @Day_10, @Day_11, @Day_12,
                       @Day_13, @Day_14, @Day_15, @NewOldUsers, date_sub(p_trandate, interval 14 day),
                       (@Day_01+@Day_02+@Day_03+@Day_04+@Day_05+@Day_06+@Day_07+@Day_08+@Day_09+@Day_10+@Day_11+@Day_12+@Day_13+@Day_14+@Day_15),
                       @NewUsers );

end;
//
delimiter ;



call sp_generate_15day_retention_stats('2014-04-01');
call sp_generate_15day_retention_stats('2014-04-02');
call sp_generate_15day_retention_stats('2014-04-03');
call sp_generate_15day_retention_stats('2014-04-04');
call sp_generate_15day_retention_stats('2014-04-05');
call sp_generate_15day_retention_stats('2014-04-06');
call sp_generate_15day_retention_stats('2014-04-07');
call sp_generate_15day_retention_stats('2014-04-08');
call sp_generate_15day_retention_stats('2014-04-09');
call sp_generate_15day_retention_stats('2014-04-10');
call sp_generate_15day_retention_stats('2014-04-11');
call sp_generate_15day_retention_stats('2014-04-12');
call sp_generate_15day_retention_stats('2014-04-13');
call sp_generate_15day_retention_stats('2014-04-14');
call sp_generate_15day_retention_stats('2014-04-15');





DROP PROCEDURE sp_generate_retention_stats_monthly;
delimiter //

CREATE PROCEDURE sp_generate_retention_stats_monthly(p_trandate varchar(10))
begin
   declare vNoDay, vHits int default 0;
   declare done_p int default 0;
   declare c_pat cursor for
      select no_day, count(distinct phone) hits from (
      select phone, count(1) no_day from (
      select left(datein,10) datein, phone, count(1) hits from powerapp_log
      where datein < date_add(p_trandate, interval 1 day) and  datein >= date_sub(p_trandate, interval 31 day)
      group by left(datein,10), phone
      union
      select left(datein,10) datein, phone, count(1) hits from powerapp_flu.powerapp_log
      where datein < date_add(p_trandate, interval 1 day) and  datein >= date_sub(p_trandate, interval 31 day)
      group by left(datein,10), phone
      ) t1 group by phone
      ) t2
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

   create temporary table if not exists powerapp_last_week_users ( phone varchar(12) not null, primary key (phone) );
   create temporary table if not exists powerapp_this_week_users ( phone varchar(12) not null, primary key (phone) );
   create temporary table if not exists powerapp_week_new_users  ( phone varchar(12) not null, primary key (phone) );
   truncate table powerapp_last_week_users;
   truncate table powerapp_this_week_users;
   truncate table powerapp_week_new_users;

   insert into powerapp_last_week_users
   select phone from (
   select phone from powerapp_flu.powerapp_log
   where  datein >= date_sub(p_trandate, interval 32 day)
   and    datein <  p_trandate
   group by phone
   ) t group by phone;

   insert into powerapp_this_week_users
   select phone from (
   select phone from powerapp_flu.powerapp_log
   where  datein >= date_sub(p_trandate, interval 31 day)
   and    datein <  date_add(p_trandate, interval 1 day)
   group by phone
   ) t group by phone;

   insert into powerapp_week_new_users 
   select phone 
   from   powerapp_flu.new_subscribers
   where  datein >= date_sub(p_trandate, interval 31 day)
   and    datein <  date_add(p_trandate, interval 1 day);

   select count(1)
   into   @NewOldUsers
   from   powerapp_this_week_users a
   where  exists (select 1 from powerapp_last_week_users b 
                  where a.phone = b.phone)
   and    not exists (select 1 from powerapp_week_new_users c 
                  where a.phone = c.phone);

   -- New MINs
   select count(1) 
   into   @NewUsers 
   from   powerapp_week_new_users;

   drop temporary table if exists powerapp_last_week_users;
   drop temporary table if exists powerapp_this_week_users;
   drop temporary table if exists powerapp_week_new_users;

   delete from powerapp_retention_stats_monthly where tran_dt = p_trandate;
   insert into powerapp_retention_stats_monthly 
          (tran_dt, w31_days, w30_days, 
           w29_days, w28_days, w27_days, w26_days, w25_days, w24_days, w23_days, w22_days, w21_days, w20_days, 
           w19_days, w18_days, w17_days, w16_days, w15_days, w14_days, w13_days, w12_days, w11_days, w10_days, 
           w9_days, w8_days, w7_days, w6_days, w5_days, w4_days, w3_days, w2_days, w1_days, 
           new_users, wk_start, new_old)
   values (p_trandate, @Day_31, @Day_30,
    @Day_29, @Day_28, @Day_27, @Day_26, @Day_25, @Day_24, @Day_13, @Day_22, @Day_21, @Day_20,
    @Day_19, @Day_18, @Day_17, @Day_16, @Day_15, @Day_14, @Day_13, @Day_12, @Day_11, @Day_10,
    @Day_9, @Day_8, @Day_7, @Day_6, @Day_5, @Day_4, @Day_3, @Day_2, @Day_1,
    @NewUsers, date_sub(p_trandate, interval 31 day), @NewOldUsers );

end;
//
delimiter ;
