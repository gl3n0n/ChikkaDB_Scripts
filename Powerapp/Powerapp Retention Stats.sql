drop procedure if exists sp_generate_retention_main;
delimiter //
create procedure sp_generate_retention_main ()
begin
   delete from powerapp_retention_stats where tran_dt = date_sub(curdate(), interval 1 day);
   delete from powerapp_retention_stats_monthly where tran_dt = date_sub(curdate(), interval 1 day);
   call sp_generate_retention_stats (date_sub(curdate(), interval 1 day));
   call sp_generate_retention_stats_monthly (date_sub(curdate(), interval 1 day));
   call sp_generate_active_stats(curdate());
   call sp_generate_inactive_list();
end;
//
delimiter ;

GRANT EXECUTE ON PROCEDURE `archive_powerapp_flu`.`sp_generate_retention_main` TO 'stats'@'localhost' identified by 'stats';
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
   create table powerapp_last_week_users ( phone varchar(12) not null, primary key (phone) );

   insert into powerapp_last_week_users 
   select phone from (
   select phone from powerapp_log
   where  datein >= date_sub(p_trandate, interval 7 day) 
   and    datein < p_trandate group by phone
   union
   select phone from powerapp_flu.powerapp_log
   where  datein >= date_sub(p_trandate, interval 7 day) 
   and    datein < p_trandate group by phone 
   ) t group by phone;


   select count(distinct phone) 
   into   @NewUsers 
   from (
   select phone from powerapp_log a 
   where  a.datein < date_add(p_trandate, interval 1 day)
   and    a.datein >= p_trandate
   and    not exists (
   select 1 from powerapp_last_week_users b
   where  a.phone = b.phone)
   union
   select phone from powerapp_flu.powerapp_log a 
   where  a.datein < date_add(p_trandate, interval 1 day)
   and    a.datein >= p_trandate
   and    not exists (
   select 1 from powerapp_last_week_users b
   where  a.phone = b.phone)
   ) t;
    
   drop table powerapp_last_week_users;
   -- truncate table powerapp_last_week_users;
   -- end count of new users

   insert into powerapp_retention_stats values (p_trandate, @Day_7, @Day_6, @Day_5, @Day_4, @Day_3, @Day_2, @Day_1, @NewUsers, date_sub(p_trandate, interval 6 day) );

end;
//
delimiter ;


select * from powerapp_retention_stats order by tran_dt desc;



delete from powerapp_retention_stats where tran_dt = '2014-04-22';
delete from powerapp_retention_stats_monthly where tran_dt = '2014-04-22';
call sp_generate_retention_stats ('2014-04-22');
call sp_generate_15day_retention_stats('2014-04-22');
call sp_generate_retention_stats_monthly ('2014-04-22');
call sp_generate_active_stats('2014-04-22');


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
   wk_start date not null,
   primary key (tran_dt,plan)
);



drop procedure if exists sp_generate_retention_stats_plan;
delimiter //
create procedure sp_generate_retention_stats_plan (p_plan varchar(16), p_trandate varchar(10))
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
   create table powerapp_last_week_users ( phone varchar(12) not null, primary key (phone) );

   insert into powerapp_last_week_users 
   select phone from (
   select phone from powerapp_log
   where  datein >= date_sub(p_trandate, interval 7 day) 
   and    plan = p_plan
   and    datein < p_trandate group by phone
   union
   select phone from powerapp_flu.powerapp_log
   where  datein >= date_sub(p_trandate, interval 7 day) 
   and    plan = p_plan
   and    datein < p_trandate group by phone 
   ) t group by phone;


   select count(distinct phone) 
   into   @NewUsers 
   from (
   select phone from powerapp_log a 
   where  a.datein < date_add(p_trandate, interval 1 day)
   and    a.datein >= p_trandate
   and    plan = p_plan
   and    not exists (
   select 1 from powerapp_last_week_users b
   where  a.phone = b.phone)
   union
   select phone from powerapp_flu.powerapp_log a 
   where  a.datein < date_add(p_trandate, interval 1 day)
   and    a.datein >= p_trandate
   and    plan = p_plan
   and    not exists (
   select 1 from powerapp_last_week_users b
   where  a.phone = b.phone)
   ) t;
    
   drop table powerapp_last_week_users;
   -- truncate table powerapp_last_week_users;
   -- end count of new users

   insert into powerapp_retention_stats_plan values (p_trandate, p_plan, @Day_7, @Day_6, @Day_5, @Day_4, @Day_3, @Day_2, @Day_1, @NewUsers, date_sub(p_trandate, interval 6 day) );

end;
//
delimiter ;


drop procedure if exists sp_generate_retention_stats_plan_main;
delimiter //
create procedure sp_generate_retention_stats_plan_main ()
begin
   set @vCtr = 2;
   WHILE (@vCtr <= 84) DO
      SET @vSql = concat('select date_sub(curdate(), interval ', @vCtr, ' day) into @vDate');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      SET @vCtr = @vCtr + 1; 
      call sp_generate_retention_stats_plan('UNLI', @vDate);
      call sp_generate_retention_stats_plan('SOCIAL', @vDate);
      call sp_generate_retention_stats_plan('SPEEDBOOST', @vDate);
   END WHILE;
end;
//
delimiter ;
call sp_generate_retention_stats_plan_main();
