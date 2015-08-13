CREATE TABLE smartservice_users (
  phone varchar(70) not null,
  datein datetime,
  primary key (phone)
);

CREATE TABLE stats_smartservice_daily (
   tx_date date not null,
   hits int(11) default 0 not null, 
   uniq int(11) default 0 not null, 
   no_buys int(11) default 0 not null, 
   no_buys_via_app int(11) default 0 not null, 
   no_buys_via_web int(11) default 0 not null, 
   no_buys_via_sms int(11) default 0 not null, 
   no_uniq_buys int(11) default 0 not null, 
   no_actv_mins int(11) default 0 not null, 
   mo_uniq_actv int(11) default 0 not null, 
   mo_uniq_buys int(11) default 0 not null, 
   insuff_bal_cnt int(11) default 0 not null, 
   insuff_bal_uniq int(11) default 0 not null, 
   subs_not_allowed_cnt int(11) default 0 not null, 
   subs_not_allowed_uniq int(11) default 0 not null, 
   invalid_phone_cnt int(11) default 0 not null, 
   invalid_phone_uniq int(11) default 0 not null, 
   primary key (tx_date)
 );
 
CREATE TABLE stats_smartservice_hourly (
   tx_date date not null,
   tx_time time not null,
   plan    varchar(100) not null,
   hits    int(11) default 0 not null, 
   uniq    int(11) default 0 not null, 
   no_buys int(11) default 0 not null, 
   no_uniq_buys int(11) default 0 not null, 
   primary key (tx_date, tx_time, plan)
 );

CREATE TABLE stats_smartservice_daily_per_plan (
   tx_date date not null,
   plan    varchar(100) not null,
   hits    int(11) default 0 not null, 
   uniq    int(11) default 0 not null, 
   no_buys int(11) default 0 not null, 
   no_uniq_buys int(11) default 0 not null, 
   primary key (tx_date, plan)
 );

DROP PROCEDURE if exists sp_generate_stats_smartservervice;
delimiter //
CREATE PROCEDURE sp_generate_stats_smartservervice(p_trandate date)
begin
    set session tmp_table_size = 268435456;
    set session max_heap_table_size = 268435456;
    set session sort_buffer_size = 104857600;
    set session read_buffer_size = 8388608;

    SET @tran_dt = p_trandate;
    SET @tran_nw = date_add(p_trandate, interval 1 day);
    SET @tran_2d = date_sub(p_trandate, interval 2 day);
    delete from stats_smartservice_daily where tx_date = @tran_dt;
    delete from stats_smartservice_hourly where tx_date = @tran_dt;

    insert into stats_smartservice_hourly (tx_date, tx_time, plan, hits, uniq, no_buys, no_uniq_buys)
    select left(datein,10) datein, concat(substring(datein,12,2),':00'), if(plan is null or plan='', 'NOPLAN', plan), count(1) hits, count(distinct phone) uniq, 
           sum(if(free='false',1,0)) no_buys, count(distinct(if(free='false',phone,''))) uniq_buys 
    from   spa_put_log
    where  datein >= @tran_dt and datein < @tran_nw 
    group by 1,2,3;

    insert into stats_smartservice_daily_per_plan (tx_date, plan, hits, uniq, no_buys, no_uniq_buys)
    select left(datein,10) datein, if(plan is null or plan='', 'NOPLAN', plan), count(1) hits, count(distinct phone) uniq, 
           sum(if(free='false',1,0)) no_buys, count(distinct(if(free='false',phone,''))) uniq_buys 
    from   spa_put_log
    where  datein >= @tran_dt and datein < @tran_nw 
    group by 1,2;

    insert into stats_smartservice_daily (tx_date, hits, uniq, no_buys, no_uniq_buys)
    select left(datein,10) datein, count(1) hits, count(distinct phone) uniq, 
           sum(if(free='false',1,0)) no_buys, count(distinct(if(free='false',phone,''))) uniq_buys 
    from   spa_put_log
    where  datein >= @tran_dt and datein < @tran_nw 
    group by 1;

    -- Monthly unique MINS
    if @tran_dt = last_day(@tran_dt) then
       select count(distinct phone)
       into  @mo_uniq_actv
       from  spa_put_log
       where left(datein,7) = left(@tran_dt, 7);

       select count(distinct phone)
       into  @mo_uniq_buys
       from  spa_put_log
       where left(datein,7) = left(@tran_dt, 7)
       and   free='false';
    else
       select count(distinct phone)
       into  @mo_uniq_actv
       from  spa_put_log
       where datein >= date_sub(@tran_dt, interval 30 day)
       and   datein < @tran_nw;

       select count(distinct phone)
       into  @mo_uniq_buys
       from  spa_put_log
       where datein >= date_sub(@tran_dt, interval 30 day)
       and   datein < @tran_nw
       and   free='false';
    end if;

    -- Active MINS are users with buy/s within 48hours
    select count(distinct phone) into @no_actv_mins from spa_put_log where datein >= @tran_2d and datein < @tran_nw and free='false';

    -- Buys per source
    select count(1) into @no_buys_via_app from spa_put_log where datein >= @tran_dt and datein < @tran_nw and free='false' and source='app';
    select count(1) into @no_buys_via_web from spa_put_log where datein >= @tran_dt and datein < @tran_nw and free='false' and source='web';
    select count(1) into @no_buys_via_sms from spa_put_log where datein >= @tran_dt and datein < @tran_nw and free='false' and source='sms';

    -- Errors
    select count(1), count(distinct phone) into @insuff_bal_cnt, @insuff_bal_uniq from spa_put_log where datein >= @tran_dt and datein < @tran_nw and http_response='402';
    select count(1), count(distinct phone) into @subs_not_allowed_cnt, @subs_not_allowed_uniq from spa_put_log where datein >= @tran_dt and datein < @tran_nw and http_response = '400' and err_code = 'subscription_not_allowed';
    select count(1), count(distinct phone) into @invalid_phone_cnt, @invalid_phone_uniq from spa_put_log where datein >= @tran_dt and datein < @tran_nw and http_response = '400' and err_code = 'subscription_not_allowed';

    update stats_smartservice_daily
    set    no_buys_via_app = @no_buys_via_app,
           no_buys_via_web = @no_buys_via_web,
           no_buys_via_sms = @no_buys_via_sms,
           no_actv_mins = @no_actv_mins,
           mo_uniq_actv = @mo_uniq_actv,
           mo_uniq_buys = @mo_uniq_buys,
           insuff_bal_cnt = @insuff_bal_cnt,
           insuff_bal_uniq = @insuff_bal_uniq,
           subs_not_allowed_cnt = @subs_not_allowed_cnt,
           subs_not_allowed_uniq = @subs_not_allowed_uniq,
           invalid_phone_cnt = @invalid_phone_cnt,
           invalid_phone_uniq = @invalid_phone_uniq
    where  tx_date = @tran_dt;

END;
//
delimiter ;


