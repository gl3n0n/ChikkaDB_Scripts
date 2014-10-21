create temporary table tmp_plan_active_users (phone varchar(12) not null, primary key (phone));
create temporary table tmp_user_buys (phone varchar(12) not null, datein date not null, plan varchar(20), hits int(11), primary key (phone, datein, plan));
create temporary table tmp_user_xday (phone varchar(12) not null, n_buys int(11), hits int(11), primary key (phone));


select '2014-07-22' into @txDate;
truncate table tmp_plan_active_users;
truncate table tmp_user_buys;
truncate table tmp_user_xday;

insert into tmp_plan_active_users select phone from powerapp_flu.new_subscribers where datein >= @txDate and datein < date_add(@txDate, interval 1 day) ;
insert into tmp_user_buys select phone, left(datein,10) date, plan, count(1) hits from powerapp_log a
where datein >= @txDate and datein < date_add(@txDate, interval 8 day) 
and exists (select 1 from tmp_plan_active_users b where a.phone = b.phone)
group by 1,2,3;
insert into tmp_user_xday select phone, count(1) no_times, sum(hits) hits from (
select phone, datein, sum(hits) hits from tmp_user_buys group by phone, datein ) t1 group by phone;

select n_buys n_days, count(1) uniq, sum(hits) hits from tmp_user_xday t1 group by 1;
select plan, sum(hits) hits from tmp_user_buys a where exists (select 1 from tmp_user_xday b where a.phone = b.phone and b.n_buys=1) group by 1 order by 2 desc limit 5;
select plan, sum(hits) hits from tmp_user_buys a where exists (select 1 from tmp_user_xday b where a.phone = b.phone and b.n_buys=2) group by 1 order by 2 desc limit 5;
select plan, sum(hits) hits from tmp_user_buys a where exists (select 1 from tmp_user_xday b where a.phone = b.phone and b.n_buys=3) group by 1 order by 2 desc limit 5;


----

create table powerapp_new_mins_retention (
   tx_date  date not null,
   new_mins int(11) not null,
   day_2    int(11) not null,
   day_3    int(11) not null,
   day_4    int(11) not null,
   day_5    int(11) not null,
   day_6    int(11) not null,
   day_7    int(11) not null,
   pct_2    int(11) not null,
   pct_3    int(11) not null,
   pct_4    int(11) not null,
   pct_5    int(11) not null,
   pct_6    int(11) not null,
   pct_7    int(11) not null,
   primary key (tx_date)
);

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


drop procedure sp_generate_new_mins_plan_retention;
delimiter //
create procedure sp_generate_new_mins_plan_retention (p_trandate date)
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

end;
//
delimiter ;


drop procedure sp_generate_batch_new_mins_retention;
delimiter //
create procedure sp_generate_batch_new_mins_retention (p_start date, p_max int(3))
begin
   SET @nCtr = 0;
   WHILE (@nCtr < p_max) DO
      select concat('Processing for transactions ', date_add(p_start, interval @nCtr day), '...') TxProc;
      call sp_generate_new_mins_retention(date_add(p_start, interval @nCtr day));
      set @nCtr = @nCtr + 1;
   END WHILE;
end;
//
delimiter ;

call sp_generate_batch_new_mins_retention ('2014-06-01', 30);
