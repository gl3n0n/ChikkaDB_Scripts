alter table powerapp_dailyrep add  line_hits    int(11) default 0 after speed_uniq;
alter table powerapp_dailyrep add  line_uniq    int(11) default 0 after speed_uniq;
alter table powerapp_dailyrep add  snap_hits    int(11) default 0 after speed_uniq;
alter table powerapp_dailyrep add  snap_uniq    int(11) default 0 after speed_uniq;
alter table powerapp_dailyrep add  tumblr_hits  int(11) default 0 after speed_uniq;
alter table powerapp_dailyrep add  tumblr_uniq  int(11) default 0 after speed_uniq;
alter table powerapp_dailyrep add  waze_hits    int(11) default 0 after speed_uniq;
alter table powerapp_dailyrep add  waze_uniq    int(11) default 0 after speed_uniq;
alter table powerapp_dailyrep add  wechat_hits  int(11) default 0 after speed_uniq;
alter table powerapp_dailyrep add  wechat_uniq  int(11) default 0 after speed_uniq;
alter table powerapp_dailyrep add  wiki_hits    int(11) default 0 after speed_uniq;
alter table powerapp_dailyrep add  wiki_uniq    int(11) default 0 after speed_uniq;

alter table powerapp_validity_dailyrep add  wiki_uniq_24    int(11) default 0 after speed_uniq;
alter table powerapp_validity_dailyrep add  wiki_hits_24    int(11) default 0 after speed_uniq;
alter table powerapp_validity_dailyrep add  wechat_uniq_24  int(11) default 0 after speed_uniq;
alter table powerapp_validity_dailyrep add  wechat_hits_24  int(11) default 0 after speed_uniq;
alter table powerapp_validity_dailyrep add  waze_uniq_24    int(11) default 0 after speed_uniq;
alter table powerapp_validity_dailyrep add  waze_hits_24    int(11) default 0 after speed_uniq;
alter table powerapp_validity_dailyrep add  tumblr_uniq_24  int(11) default 0 after speed_uniq;
alter table powerapp_validity_dailyrep add  tumblr_hits_24  int(11) default 0 after speed_uniq;
alter table powerapp_validity_dailyrep add  snap_uniq_24    int(11) default 0 after speed_uniq;
alter table powerapp_validity_dailyrep add  snap_hits_24    int(11) default 0 after speed_uniq;
alter table powerapp_validity_dailyrep add  line_uniq_24    int(11) default 0 after speed_uniq;
alter table powerapp_validity_dailyrep add  line_hits_24    int(11) default 0 after speed_uniq;

alter table powerapp_hourlyrep add  wiki_uniq_24    int(11) default 0 after speed_uniq;
alter table powerapp_hourlyrep add  wiki_hits_24    int(11) default 0 after speed_uniq;
alter table powerapp_hourlyrep add  wechat_uniq_24  int(11) default 0 after speed_uniq;
alter table powerapp_hourlyrep add  wechat_hits_24  int(11) default 0 after speed_uniq;
alter table powerapp_hourlyrep add  waze_uniq_24    int(11) default 0 after speed_uniq;
alter table powerapp_hourlyrep add  waze_hits_24    int(11) default 0 after speed_uniq;
alter table powerapp_hourlyrep add  tumblr_uniq_24  int(11) default 0 after speed_uniq;
alter table powerapp_hourlyrep add  tumblr_hits_24  int(11) default 0 after speed_uniq;
alter table powerapp_hourlyrep add  snap_uniq_24    int(11) default 0 after speed_uniq;
alter table powerapp_hourlyrep add  snap_hits_24    int(11) default 0 after speed_uniq;
alter table powerapp_hourlyrep add  line_uniq_24    int(11) default 0 after speed_uniq;
alter table powerapp_hourlyrep add  line_hits_24    int(11) default 0 after speed_uniq;

DROP TABLE IF EXISTS powerapp_hourly_report;

CREATE TABLE powerapp_hourly_report (
  tran_dt  date NOT NULL,
  plan     varchar(30) not null,
  type     varchar(10) not null,
  validity varchar(10) not null,
  tm_00    int(11) default 0,
  tm_01    int(11) default 0,
  tm_02    int(11) default 0,
  tm_03    int(11) default 0,
  tm_04    int(11) default 0,
  tm_05    int(11) default 0,
  tm_06    int(11) default 0,
  tm_07    int(11) default 0,
  tm_08    int(11) default 0,
  tm_09    int(11) default 0,
  tm_10    int(11) default 0,
  tm_11    int(11) default 0,
  tm_12    int(11) default 0,
  tm_13    int(11) default 0,
  tm_14    int(11) default 0,
  tm_15    int(11) default 0,
  tm_16    int(11) default 0,
  tm_17    int(11) default 0,
  tm_18    int(11) default 0,
  tm_19    int(11) default 0,
  tm_20    int(11) default 0,
  tm_21    int(11) default 0,
  tm_22    int(11) default 0,
  tm_23    int(11) default 0,
  tm_tot   int(11) default 0,
  PRIMARY KEY (tran_dt, plan, type, validity)
);
 
create table powerapp_hourlyrep
( tran_dt            date not null,
  tran_tm            time not null,
  unli_hits_3        int(11) default 0,
  unli_hits_24       int(11) default 0,
  unli_uniq_3        int(11) default 0,
  unli_uniq_24       int(11) default 0, 
  email_hits_3       int(11) default 0,
  email_hits_24      int(11) default 0,
  email_uniq_3       int(11) default 0,
  email_uniq_24      int(11) default 0, 
  chat_hits_3        int(11) default 0,
  chat_hits_24       int(11) default 0,
  chat_uniq_3        int(11) default 0,
  chat_uniq_24       int(11) default 0, 
  photo_hits_3       int(11) default 0,
  photo_hits_24      int(11) default 0,
  photo_uniq_3       int(11) default 0,
  photo_uniq_24      int(11) default 0, 
  social_hits_3      int(11) default 0,
  social_hits_24     int(11) default 0,
  social_uniq_3      int(11) default 0,
  social_uniq_24     int(11) default 0, 
  speed_hits         int(11) default 0,
  speed_uniq         int(11) default 0, 
  line_hits_24       int(11) default 0,
  line_uniq_24       int(11) default 0, 
  snap_hits_24       int(11) default 0,
  snap_uniq_24       int(11) default 0, 
  tumblr_hits_24     int(11) default 0,
  tumblr_uniq_24     int(11) default 0, 
  waze_hits_24       int(11) default 0,
  waze_uniq_24       int(11) default 0, 
  wechat_hits_24     int(11) default 0,
  wechat_uniq_24     int(11) default 0, 
  wiki_hits_24       int(11) default 0,
  wiki_uniq_24       int(11) default 0,
  total_hits         int(11) default 0,
  total_uniq         int(11) default 0,
  PRIMARY KEY (tran_dt, tran_tm)
);
  
DROP PROCEDURE IF EXISTS sp_generate_hi10_stats;
delimiter //
CREATE PROCEDURE sp_generate_hi10_stats()
begin
    SET @tran_dt = date_sub(curdate(), interval 1 day);
    SET @tran_nw = curdate();
    delete from powerapp_dailyrep where tran_dt = @tran_dt;
    delete from powerapp_validity_dailyrep where tran_dt = @tran_dt;
    delete from powerapp_hourlyrep where tran_dt = @tran_dt;

    select count(1), count(distinct phone) into @unli_hits,   @unli_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI';
    select count(1), count(distinct phone) into @email_hits,  @email_uniq  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL';
    select count(1), count(distinct phone) into @chat_hits,   @chat_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CHAT';
    select count(1), count(distinct phone) into @photo_hits,  @photo_uniq  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO';
    select count(1), count(distinct phone) into @social_hits, @social_uniq from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL';
    select count(1), count(distinct phone) into @speed_hits,  @speed_uniq  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SPEEDBOOST';
    select count(1), count(distinct phone) into @line_hits,   @line_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='LINE';
    select count(1), count(distinct phone) into @snap_hits,   @snap_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SNAPCHAT';
    select count(1), count(distinct phone) into @tumblr_hits, @tumblr_uniq from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='TUMBLR';
    select count(1), count(distinct phone) into @waze_hits,   @waze_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WAZE';
    select count(1), count(distinct phone) into @wechat_hits, @wechat_uniq from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT';
    select count(1), count(distinct phone) into @wiki_hits,   @wiki_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WIKIPEDIA';
    select count(1), count(distinct phone) into @total_hits,  @total_uniq  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false';

    insert ignore into powerapp_dailyrep (
            tran_dt, total_hits, total_uniq,
            unli_hits, email_hits, social_hits, photo_hits, chat_hits, speed_hits, line_hits, snap_hits, tumblr_hits, waze_hits, wechat_hits, wiki_hits,
            unli_uniq, email_uniq, social_uniq, photo_uniq, chat_uniq, speed_uniq, line_uniq, snap_uniq, tumblr_uniq, waze_uniq, wechat_uniq, wiki_uniq )
    values (@tran_dt, @total_hits, @total_uniq,
            @unli_hits, @email_hits, @social_hits, @photo_hits, @chat_hits, @speed_hits, @line_hits, @snap_hits, @tumblr_hits, @waze_hits, @wechat_hits, @wiki_hits,
            @unli_uniq, @email_uniq, @social_uniq, @photo_uniq, @chat_uniq, @speed_uniq, @line_uniq, @snap_uniq, @tumblr_uniq, @waze_uniq, @wechat_uniq, @wiki_uniq);

    select max(timein)
    into   @vTimeIn
    from   powerapp_concurrent_log
    where  datein = @tran_dt;

    if (@vTimeIn = '23:59:00') then

       select group_concat(left(timein,5) SEPARATOR ','), num_subs
       into   @vTimeIn, @vNumSubs
       from   powerapp_concurrent_log
       where  datein = @tran_dt
       and    num_subs = (select max(num_subs)
                          from   powerapp_concurrent_log
                          where  datein = @tran_dt
                         );


       select avg(num_subs)
       into   @vAvgSubs
       from   powerapp_concurrent_log
       where  datein = @tran_dt;


       select count(1)
       into   @vNumOptout
       from   powerapp_optout_log
       where  datein >= @tran_dt
       and    datein < @tran_nw;
    else
       SET @vTimeIn  = '00:00';
       SET @vNumSubs = 0;
       SET @vAvgSubs = 0;
    end if;

    select count(distinct phone) 
    into  @NumUniq30d
    from powerapp_log 
    where datein >= date_sub(@tran_dt, interval 31 day) 
    and datein < @tran_nw;

    update powerapp_dailyrep
    set    num_optout= IFNULL(@vNumOptout,0),
           concurrent_max_tm= IFNULL(@vTimeIn,'00:00'),
           concurrent_max_subs=IFNULL(@vNumSubs,0),
           concurrent_avg_subs=IFNULL(@vAvgSubs,0),
           num_uniq_30d=IFNULL(@NumUniq30d,0)
    where  tran_dt = @tran_dt;


    select count(1), count(distinct phone) into @unli_hits_3,    @unli_uniq_3    from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and validity<86400;
    select count(1), count(distinct phone) into @unli_hits_24,   @unli_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and validity >=86400;
    select count(1), count(distinct phone) into @email_hits_3,   @email_uniq_3   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL' and validity<86400;  
    select count(1), count(distinct phone) into @email_hits_24,  @email_uniq_24  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL' and validity >=86400;
    select count(1), count(distinct phone) into @chat_hits_3,    @chat_uniq_3    from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CHAT' and validity<86400;  
    select count(1), count(distinct phone) into @chat_hits_24,   @chat_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CHAT' and validity >=86400;
    select count(1), count(distinct phone) into @photo_hits_3,   @photo_uniq_3   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity<86400;  
    select count(1), count(distinct phone) into @photo_hits_24,  @photo_uniq_24  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity >=86400;
    select count(1), count(distinct phone) into @social_hits_3,  @social_uniq_3  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity <86400;
    select count(1), count(distinct phone) into @social_hits_24, @social_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity >=86400;
    select count(1), count(distinct phone) into @speed_hits,     @speed_uniq     from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SPEEDBOOST';
    select count(1), count(distinct phone) into @line_hits_24,   @line_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='LINE';
    select count(1), count(distinct phone) into @snap_hits_24,   @snap_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SNAPCHAT';
    select count(1), count(distinct phone) into @tumblr_hits_24, @tumblr_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='TUMBLR';
    select count(1), count(distinct phone) into @waze_hits_24,   @waze_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WAZE';
    select count(1), count(distinct phone) into @wechat_hits_24, @wechat_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT';
    select count(1), count(distinct phone) into @wiki_hits_24,   @wiki_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WIKIPEDIA';

    insert ignore into powerapp_validity_dailyrep
           (tran_dt,         total_hits,      total_uniq,
            unli_hits_3,     unli_hits_24,    unli_uniq_3,    unli_uniq_24, 
            email_hits_3,    email_hits_24,   email_uniq_3,   email_uniq_24, 
            chat_hits_3,     chat_hits_24,    chat_uniq_3,    chat_uniq_24, 
            photo_hits_3,    photo_hits_24,   photo_uniq_3,   photo_uniq_24, 
            social_hits_3,   social_hits_24,  social_uniq_3,  social_uniq_24, 
            speed_hits,      speed_uniq, 
            line_hits_24,    line_uniq_24, 
            snap_hits_24,    snap_uniq_24, 
            tumblr_hits_24,  tumblr_uniq_24, 
            waze_hits_24,    waze_uniq_24, 
            wechat_hits_24,  wechat_uniq_24, 
            wiki_hits_24,    wiki_uniq_24)
    values (@tran_dt,        @total_hits,     @total_uniq,
            @unli_hits_3,    @unli_hits_24,   @unli_uniq_3,   @unli_uniq_24, 
            @email_hits_3,   @email_hits_24,  @email_uniq_3,  @email_uniq_24, 
            @chat_hits_3,    @chat_hits_24,   @chat_uniq_3,   @chat_uniq_24, 
            @photo_hits_3,   @photo_hits_24,  @photo_uniq_3,  @photo_uniq_24, 
            @social_hits_3,  @social_hits_24, @social_uniq_3, @social_uniq_24, 
            @speed_hits,     @speed_uniq, 
            @line_hits_24,   @line_uniq_24, 
            @snap_hits_24,   @snap_uniq_24, 
            @tumblr_hits_24, @tumblr_uniq_24, 
            @waze_hits_24,   @waze_uniq_24, 
            @wechat_hits_24, @wechat_uniq_24, 
            @wiki_hits_24,   @wiki_uniq_24);

   set @vCtr = 0;
   WHILE (@vCtr <= 23) DO
      -- reset all values...
      select concat(lpad(@vCtr, 2, '0'), ':00:00') into @tran_tm;
      select 0, 0 into @unli_hits_3,    @unli_uniq_3;
      select 0, 0 into @unli_hits_24,   @unli_uniq_24;
      select 0, 0 into @email_hits_3,   @email_uniq_3;
      select 0, 0 into @email_hits_24,  @email_uniq_24;
      select 0, 0 into @chat_hits_3,    @chat_uniq_3;
      select 0, 0 into @chat_hits_24,   @chat_uniq_24;
      select 0, 0 into @photo_hits_3,   @photo_uniq_3;
      select 0, 0 into @photo_hits_24,  @photo_uniq_24;
      select 0, 0 into @social_hits_3,  @social_uniq_3;
      select 0, 0 into @social_hits_24, @social_uniq_24;
      select 0, 0 into @speed_hits,     @speed_uniq;
      select 0, 0 into @line_hits_24,   @line_uniq_24;
      select 0, 0 into @snap_hits_24,   @snap_uniq_24;
      select 0, 0 into @tumblr_hits_24, @tumblr_uniq_24;
      select 0, 0 into @waze_hits_24,   @waze_uniq_24;
      select 0, 0 into @wechat_hits_24, @wechat_uniq_24;
      select 0, 0 into @wiki_hits_24,   @wiki_uniq_24;


      select count(1), count(distinct phone) into @unli_hits_3,    @unli_uniq_3    from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and validity<86400;
      select count(1), count(distinct phone) into @unli_hits_24,   @unli_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and validity >=86400;
      select count(1), count(distinct phone) into @email_hits_3,   @email_uniq_3   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity<86400;  
      select count(1), count(distinct phone) into @email_hits_24,  @email_uniq_24  from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity >=86400;
      select count(1), count(distinct phone) into @chat_hits_3,    @chat_uniq_3    from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity<86400;  
      select count(1), count(distinct phone) into @chat_hits_24,   @chat_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity >=86400;
      select count(1), count(distinct phone) into @photo_hits_3,   @photo_uniq_3   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity<86400;  
      select count(1), count(distinct phone) into @photo_hits_24,  @photo_uniq_24  from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity >=86400;
      select count(1), count(distinct phone) into @social_hits_3,  @social_uniq_3  from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity <86400;
      select count(1), count(distinct phone) into @social_hits_24, @social_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity >=86400;
      select count(1), count(distinct phone) into @speed_hits,     @speed_uniq     from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SPEEDBOOST';
      select count(1), count(distinct phone) into @line_hits_24,   @line_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='LINE';
      select count(1), count(distinct phone) into @snap_hits_24,   @snap_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SNAPCHAT';
      select count(1), count(distinct phone) into @tumblr_hits_24, @tumblr_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='TUMBLR';
      select count(1), count(distinct phone) into @waze_hits_24,   @waze_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WAZE';
      select count(1), count(distinct phone) into @wechat_hits_24, @wechat_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WECHAT';
      select count(1), count(distinct phone) into @wiki_hits_24,   @wiki_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WIKIPEDIA';
      select count(1), count(distinct phone) into @total_hits,     @total_uniq     from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false';
      SET @vCtr = @vCtr + 1; 

      insert ignore into powerapp_hourlyrep
             (tran_dt,         tran_tm,         total_hits,     total_uniq,
              unli_hits_3,     unli_hits_24,    unli_uniq_3,    unli_uniq_24, 
              email_hits_3,    email_hits_24,   email_uniq_3,   email_uniq_24, 
              chat_hits_3,     chat_hits_24,    chat_uniq_3,    chat_uniq_24, 
              photo_hits_3,    photo_hits_24,   photo_uniq_3,   photo_uniq_24, 
              social_hits_3,   social_hits_24,  social_uniq_3,  social_uniq_24, 
              speed_hits,      speed_uniq, 
              line_hits_24,    line_uniq_24, 
              snap_hits_24,    snap_uniq_24, 
              tumblr_hits_24,  tumblr_uniq_24, 
              waze_hits_24,    waze_uniq_24, 
              wechat_hits_24,  wechat_uniq_24, 
              wiki_hits_24,    wiki_uniq_24)
      values (@tran_dt,        @tran_tm,        @total_hits,    @total_uniq,
              @unli_hits_3,    @unli_hits_24,   @unli_uniq_3,   @unli_uniq_24, 
              @email_hits_3,   @email_hits_24,  @email_uniq_3,  @email_uniq_24, 
              @chat_hits_3,    @chat_hits_24,   @chat_uniq_3,   @chat_uniq_24, 
              @photo_hits_3,   @photo_hits_24,  @photo_uniq_3,  @photo_uniq_24, 
              @social_hits_3,  @social_hits_24, @social_uniq_3, @social_uniq_24, 
              @speed_hits,     @speed_uniq, 
              @line_hits_24,   @line_uniq_24, 
              @snap_hits_24,   @snap_uniq_24, 
              @tumblr_hits_24, @tumblr_uniq_24, 
              @waze_hits_24,   @waze_uniq_24, 
              @wechat_hits_24, @wechat_uniq_24, 
              @wiki_hits_24,   @wiki_uniq_24);
   END WHILE;

   BEGIN
      DECLARE vPlan varchar(30);
      DECLARE done_p int default 0;
      DECLARE plan_c cursor for SELECT plan FROM
         (select 'UNLI'       as plan union
          select 'EMAIL'      as plan union
          select 'CHAT'       as plan union
          select 'PHOTO'      as plan union
          select 'SOCIAL'     as plan union
          select 'SPEEDBOOST' as plan union
          select 'LINE'       as plan union
          select 'SNAPCHAT'   as plan union
          select 'TUMBLR'     as plan union
          select 'WAZE'       as plan union
          select 'WECHAT'     as plan union
          select 'WIKIPEDIA'  as plan) as t;
      DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done_p = 1;
      DELETE FROM powerapp_hourly_report WHERE tran_dt = @tran_dt;
      OPEN plan_c;
      REPEAT
         FETCH plan_c into vPlan;
         IF not done_p THEN
            select count(1), count(distinct phone) into @tm_h_00, @tm_u_00 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '00' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_01, @tm_u_01 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '01' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_02, @tm_u_02 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '02' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_03, @tm_u_03 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '03' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_04, @tm_u_04 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '04' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_05, @tm_u_05 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '05' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_06, @tm_u_06 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '06' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_07, @tm_u_07 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '07' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_08, @tm_u_08 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '08' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_09, @tm_u_09 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '09' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_10, @tm_u_10 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '10' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_11, @tm_u_11 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '11' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_12, @tm_u_12 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '12' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_13, @tm_u_13 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '13' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_14, @tm_u_14 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '14' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_15, @tm_u_15 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '15' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_16, @tm_u_16 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '16' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_17, @tm_u_17 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '17' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_18, @tm_u_18 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '18' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_19, @tm_u_19 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '19' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_20, @tm_u_20 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '20' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_21, @tm_u_21 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '21' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_22, @tm_u_22 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '22' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_23, @tm_u_23 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '23' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_sm, @tm_u_sm from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan=vPlan and validity < 86400;
            insert into powerapp_hourly_report
                   (tran_dt, plan, type, validity, tm_00, tm_01, tm_02, tm_03, tm_04, tm_05, tm_06, tm_07, tm_08, tm_09, tm_10, tm_11, tm_12, tm_13, tm_14, tm_15, tm_16, tm_17, tm_18, tm_19, tm_20, tm_21, tm_22, tm_23, tm_tot )
            values (@tran_dt, vPlan, 'hits', '03', @tm_h_00, @tm_h_01, @tm_h_02, @tm_h_03, @tm_h_04, @tm_h_05, @tm_h_06, @tm_h_07, @tm_h_08, @tm_h_09, @tm_h_10, @tm_h_11, @tm_h_12, @tm_h_13, @tm_h_14, @tm_h_15, @tm_h_16, @tm_h_17, @tm_h_18, @tm_h_19, @tm_h_20, @tm_h_21, @tm_h_22, @tm_h_23, @tm_h_sm );
            insert into powerapp_hourly_report
                   (tran_dt, plan, type, validity, tm_00, tm_01, tm_02, tm_03, tm_04, tm_05, tm_06, tm_07, tm_08, tm_09, tm_10, tm_11, tm_12, tm_13, tm_14, tm_15, tm_16, tm_17, tm_18, tm_19, tm_20, tm_21, tm_22, tm_23, tm_tot )
            values (@tran_dt, vPlan, 'uniq', '03', @tm_u_00, @tm_u_01, @tm_u_02, @tm_u_03, @tm_u_04, @tm_u_05, @tm_u_06, @tm_u_07, @tm_u_08, @tm_u_09, @tm_u_10, @tm_u_11, @tm_u_12, @tm_u_13, @tm_u_14, @tm_u_15, @tm_u_16, @tm_u_17, @tm_u_18, @tm_u_19, @tm_u_20, @tm_u_21, @tm_u_22, @tm_u_23, @tm_u_sm );
            select count(1), count(distinct phone) into @tm_h_00, @tm_u_00 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '00' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_01, @tm_u_01 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '01' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_02, @tm_u_02 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '02' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_03, @tm_u_03 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '03' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_04, @tm_u_04 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '04' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_05, @tm_u_05 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '05' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_06, @tm_u_06 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '06' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_07, @tm_u_07 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '07' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_08, @tm_u_08 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '08' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_09, @tm_u_09 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '09' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_10, @tm_u_10 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '10' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_11, @tm_u_11 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '11' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_12, @tm_u_12 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '12' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_13, @tm_u_13 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '13' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_14, @tm_u_14 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '14' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_15, @tm_u_15 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '15' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_16, @tm_u_16 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '16' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_17, @tm_u_17 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '17' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_18, @tm_u_18 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '18' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_19, @tm_u_19 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '19' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_20, @tm_u_20 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '20' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_21, @tm_u_21 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '21' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_22, @tm_u_22 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '22' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_23, @tm_u_23 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '23' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_sm, @tm_u_sm from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan=vPlan and validity >= 86400;
            insert into powerapp_hourly_report
                   (tran_dt, plan, type, validity, tm_00, tm_01, tm_02, tm_03, tm_04, tm_05, tm_06, tm_07, tm_08, tm_09, tm_10, tm_11, tm_12, tm_13, tm_14, tm_15, tm_16, tm_17, tm_18, tm_19, tm_20, tm_21, tm_22, tm_23, tm_tot )
            values (@tran_dt, vPlan, 'hits', '24', @tm_h_00, @tm_h_01, @tm_h_02, @tm_h_03, @tm_h_04, @tm_h_05, @tm_h_06, @tm_h_07, @tm_h_08, @tm_h_09, @tm_h_10, @tm_h_11, @tm_h_12, @tm_h_13, @tm_h_14, @tm_h_15, @tm_h_16, @tm_h_17, @tm_h_18, @tm_h_19, @tm_h_20, @tm_h_21, @tm_h_22, @tm_h_23, @tm_h_sm );
            insert into powerapp_hourly_report
                   (tran_dt, plan, type, validity, tm_00, tm_01, tm_02, tm_03, tm_04, tm_05, tm_06, tm_07, tm_08, tm_09, tm_10, tm_11, tm_12, tm_13, tm_14, tm_15, tm_16, tm_17, tm_18, tm_19, tm_20, tm_21, tm_22, tm_23, tm_tot )
            values (@tran_dt, vPlan, 'uniq', '24', @tm_u_00, @tm_u_01, @tm_u_02, @tm_u_03, @tm_u_04, @tm_u_05, @tm_u_06, @tm_u_07, @tm_u_08, @tm_u_09, @tm_u_10, @tm_u_11, @tm_u_12, @tm_u_13, @tm_u_14, @tm_u_15, @tm_u_16, @tm_u_17, @tm_u_18, @tm_u_19, @tm_u_20, @tm_u_21, @tm_u_22, @tm_u_23, @tm_u_sm );
         END IF;
      UNTIL done_p
      END REPEAT;
   END; 

   call sp_generate_hi10_brand_stats (@tran_dt);
END;
//

delimiter ;

GRANT EXECUTE ON PROCEDURE `powerapp_flu`.`sp_generate_hi10_stats` TO 'stats'@'10.11.4.164';


select count(distinct phone) from powerapp_log where datein >= date_sub(curdate(), interval 30 day) and datein < curdate()

select date_sub(curdate(), interval 1 day) tran_dt, count(distinct phone) from (
select phone from powerapp_log where datein >= date_sub(curdate(), interval 31 day) and datein < curdate() group by phone
union
select phone from powerapp_flu.powerapp_log where datein >= date_sub(curdate(), interval 31 day) and datein < curdate() group by phone
) t ;

+------------+-----------------------+
| tran_dt    | count(distinct phone) |
+------------+-----------------------+
| 2014-03-01 |                348400 |
| 2014-03-02 |                355887 |
| 2014-03-03 |                369414 |
+------------+-----------------------+

update powerapp_dailyrep set num_uniq_30d = 348400 where tran_dt = '2014-03-01';
update powerapp_dailyrep set num_uniq_30d = 355887 where tran_dt = '2014-03-02';
update powerapp_dailyrep set num_uniq_30d = 369414 where tran_dt = '2014-03-03';
update powerapp_dailyrep set num_uniq_30d = 382699 where tran_dt = '2014-03-04';



DROP PROCEDURE IF EXISTS sp_regenerate_hi10_stats;
delimiter //
CREATE PROCEDURE sp_regenerate_hi10_stats(p_trandate date)
begin
    SET @tran_dt = p_trandate; 
    SET @tran_nw = date_add(@tran_dt, interval 1 day);

    delete from powerapp_dailyrep where tran_dt = @tran_dt;
    delete from powerapp_validity_dailyrep where tran_dt = @tran_dt;
    delete from powerapp_hourlyrep where tran_dt = @tran_dt;

    select count(1), count(distinct phone) into @unli_hits,   @unli_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI';
    select count(1), count(distinct phone) into @email_hits,  @email_uniq  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL';
    select count(1), count(distinct phone) into @chat_hits,   @chat_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CHAT';
    select count(1), count(distinct phone) into @photo_hits,  @photo_uniq  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO';
    select count(1), count(distinct phone) into @social_hits, @social_uniq from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL';
    select count(1), count(distinct phone) into @speed_hits,  @speed_uniq  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SPEEDBOOST';
    select count(1), count(distinct phone) into @line_hits,   @line_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='LINE';
    select count(1), count(distinct phone) into @snap_hits,   @snap_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SNAPCHAT';
    select count(1), count(distinct phone) into @tumblr_hits, @tumblr_uniq from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='TUMBLR';
    select count(1), count(distinct phone) into @waze_hits,   @waze_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WAZE';
    select count(1), count(distinct phone) into @wechat_hits, @wechat_uniq from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT';
    select count(1), count(distinct phone) into @wiki_hits,   @wiki_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WIKIPEDIA';
    select count(1), count(distinct phone) into @total_hits,  @total_uniq  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false';

    insert ignore into powerapp_dailyrep (
            tran_dt, total_hits, total_uniq,
            unli_hits, email_hits, social_hits, photo_hits, chat_hits, speed_hits, line_hits, snap_hits, tumblr_hits, waze_hits, wechat_hits, wiki_hits,
            unli_uniq, email_uniq, social_uniq, photo_uniq, chat_uniq, speed_uniq, line_uniq, snap_uniq, tumblr_uniq, waze_uniq, wechat_uniq, wiki_uniq )
    values (@tran_dt, @total_hits, @total_uniq,
            @unli_hits, @email_hits, @social_hits, @photo_hits, @chat_hits, @speed_hits, @line_hits, @snap_hits, @tumblr_hits, @waze_hits, @wechat_hits, @wiki_hits,
            @unli_uniq, @email_uniq, @social_uniq, @photo_uniq, @chat_uniq, @speed_uniq, @line_uniq, @snap_uniq, @tumblr_uniq, @waze_uniq, @wechat_uniq, @wiki_uniq);

    select max(timein)
    into   @vTimeIn
    from   powerapp_concurrent_log
    where  datein = @tran_dt;

    if (@vTimeIn = '23:59:00') then

       select group_concat(left(timein,5) SEPARATOR ','), num_subs
       into   @vTimeIn, @vNumSubs
       from   powerapp_concurrent_log
       where  datein = @tran_dt
       and    num_subs = (select max(num_subs)
                          from   powerapp_concurrent_log
                          where  datein = @tran_dt
                         );


       select avg(num_subs)
       into   @vAvgSubs
       from   powerapp_concurrent_log
       where  datein = @tran_dt;


       select count(1)
       into   @vNumOptout
       from   powerapp_optout_log
       where  datein >= @tran_dt
       and    datein < @tran_nw;
    else
       SET @vTimeIn  = '00:00';
       SET @vNumSubs = 0;
       SET @vAvgSubs = 0;
    end if;

    select count(distinct phone) 
    into  @NumUniq30d
    from powerapp_log 
    where datein >= date_sub(@tran_dt, interval 31 day) 
    and datein < @tran_nw;

    update powerapp_dailyrep
    set    num_optout= IFNULL(@vNumOptout,0),
           concurrent_max_tm= IFNULL(@vTimeIn,'00:00'),
           concurrent_max_subs=IFNULL(@vNumSubs,0),
           concurrent_avg_subs=IFNULL(@vAvgSubs,0),
           num_uniq_30d=IFNULL(@NumUniq30d,0)
    where  tran_dt = @tran_dt;


    select count(1), count(distinct phone) into @unli_hits_3,    @unli_uniq_3    from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and validity<86400;
    select count(1), count(distinct phone) into @unli_hits_24,   @unli_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and validity >=86400;
    select count(1), count(distinct phone) into @email_hits_3,   @email_uniq_3   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL' and validity<86400;  
    select count(1), count(distinct phone) into @email_hits_24,  @email_uniq_24  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL' and validity >=86400;
    select count(1), count(distinct phone) into @chat_hits_3,    @chat_uniq_3    from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CHAT' and validity<86400;  
    select count(1), count(distinct phone) into @chat_hits_24,   @chat_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CHAT' and validity >=86400;
    select count(1), count(distinct phone) into @photo_hits_3,   @photo_uniq_3   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity<86400;  
    select count(1), count(distinct phone) into @photo_hits_24,  @photo_uniq_24  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity >=86400;
    select count(1), count(distinct phone) into @social_hits_3,  @social_uniq_3  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity <86400;
    select count(1), count(distinct phone) into @social_hits_24, @social_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity >=86400;
    select count(1), count(distinct phone) into @speed_hits,     @speed_uniq     from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SPEEDBOOST';
    select count(1), count(distinct phone) into @line_hits_24,   @line_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='LINE';
    select count(1), count(distinct phone) into @snap_hits_24,   @snap_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SNAPCHAT';
    select count(1), count(distinct phone) into @tumblr_hits_24, @tumblr_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='TUMBLR';
    select count(1), count(distinct phone) into @waze_hits_24,   @waze_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WAZE';
    select count(1), count(distinct phone) into @wechat_hits_24, @wechat_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT';
    select count(1), count(distinct phone) into @wiki_hits_24,   @wiki_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WIKIPEDIA';

    insert ignore into powerapp_validity_dailyrep
           (tran_dt,         total_hits,      total_uniq,
            unli_hits_3,     unli_hits_24,    unli_uniq_3,    unli_uniq_24, 
            email_hits_3,    email_hits_24,   email_uniq_3,   email_uniq_24, 
            chat_hits_3,     chat_hits_24,    chat_uniq_3,    chat_uniq_24, 
            photo_hits_3,    photo_hits_24,   photo_uniq_3,   photo_uniq_24, 
            social_hits_3,   social_hits_24,  social_uniq_3,  social_uniq_24, 
            speed_hits,      speed_uniq, 
            line_hits_24,    line_uniq_24, 
            snap_hits_24,    snap_uniq_24, 
            tumblr_hits_24,  tumblr_uniq_24, 
            waze_hits_24,    waze_uniq_24, 
            wechat_hits_24,  wechat_uniq_24, 
            wiki_hits_24,    wiki_uniq_24)
    values (@tran_dt,        @total_hits,     @total_uniq,
            @unli_hits_3,    @unli_hits_24,   @unli_uniq_3,   @unli_uniq_24, 
            @email_hits_3,   @email_hits_24,  @email_uniq_3,  @email_uniq_24, 
            @chat_hits_3,    @chat_hits_24,   @chat_uniq_3,   @chat_uniq_24, 
            @photo_hits_3,   @photo_hits_24,  @photo_uniq_3,  @photo_uniq_24, 
            @social_hits_3,  @social_hits_24, @social_uniq_3, @social_uniq_24, 
            @speed_hits,     @speed_uniq, 
            @line_hits_24,   @line_uniq_24, 
            @snap_hits_24,   @snap_uniq_24, 
            @tumblr_hits_24, @tumblr_uniq_24, 
            @waze_hits_24,   @waze_uniq_24, 
            @wechat_hits_24, @wechat_uniq_24, 
            @wiki_hits_24,   @wiki_uniq_24);

   set @vCtr = 0;
   WHILE (@vCtr <= 23) DO
      -- reset all values...
      select concat(lpad(@vCtr, 2, '0'), ':00:00') into @tran_tm;
      select 0, 0 into @unli_hits_3,    @unli_uniq_3;
      select 0, 0 into @unli_hits_24,   @unli_uniq_24;
      select 0, 0 into @email_hits_3,   @email_uniq_3;
      select 0, 0 into @email_hits_24,  @email_uniq_24;
      select 0, 0 into @chat_hits_3,    @chat_uniq_3;
      select 0, 0 into @chat_hits_24,   @chat_uniq_24;
      select 0, 0 into @photo_hits_3,   @photo_uniq_3;
      select 0, 0 into @photo_hits_24,  @photo_uniq_24;
      select 0, 0 into @social_hits_3,  @social_uniq_3;
      select 0, 0 into @social_hits_24, @social_uniq_24;
      select 0, 0 into @speed_hits,     @speed_uniq;
      select 0, 0 into @line_hits_24,   @line_uniq_24;
      select 0, 0 into @snap_hits_24,   @snap_uniq_24;
      select 0, 0 into @tumblr_hits_24, @tumblr_uniq_24;
      select 0, 0 into @waze_hits_24,   @waze_uniq_24;
      select 0, 0 into @wechat_hits_24, @wechat_uniq_24;
      select 0, 0 into @wiki_hits_24,   @wiki_uniq_24;


      select count(1), count(distinct phone) into @unli_hits_3,    @unli_uniq_3    from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and validity<86400;
      select count(1), count(distinct phone) into @unli_hits_24,   @unli_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and validity >=86400;
      select count(1), count(distinct phone) into @email_hits_3,   @email_uniq_3   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity<86400;  
      select count(1), count(distinct phone) into @email_hits_24,  @email_uniq_24  from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity >=86400;
      select count(1), count(distinct phone) into @chat_hits_3,    @chat_uniq_3    from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity<86400;  
      select count(1), count(distinct phone) into @chat_hits_24,   @chat_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity >=86400;
      select count(1), count(distinct phone) into @photo_hits_3,   @photo_uniq_3   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity<86400;  
      select count(1), count(distinct phone) into @photo_hits_24,  @photo_uniq_24  from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity >=86400;
      select count(1), count(distinct phone) into @social_hits_3,  @social_uniq_3  from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity <86400;
      select count(1), count(distinct phone) into @social_hits_24, @social_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity >=86400;
      select count(1), count(distinct phone) into @speed_hits,     @speed_uniq     from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SPEEDBOOST';
      select count(1), count(distinct phone) into @line_hits_24,   @line_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='LINE';
      select count(1), count(distinct phone) into @snap_hits_24,   @snap_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SNAPCHAT';
      select count(1), count(distinct phone) into @tumblr_hits_24, @tumblr_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='TUMBLR';
      select count(1), count(distinct phone) into @waze_hits_24,   @waze_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WAZE';
      select count(1), count(distinct phone) into @wechat_hits_24, @wechat_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WECHAT';
      select count(1), count(distinct phone) into @wiki_hits_24,   @wiki_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WIKIPEDIA';
      select count(1), count(distinct phone) into @total_hits,     @total_uniq     from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false';
      SET @vCtr = @vCtr + 1; 

      insert ignore into powerapp_hourlyrep
             (tran_dt,         tran_tm,         total_hits,     total_uniq,
              unli_hits_3,     unli_hits_24,    unli_uniq_3,    unli_uniq_24, 
              email_hits_3,    email_hits_24,   email_uniq_3,   email_uniq_24, 
              chat_hits_3,     chat_hits_24,    chat_uniq_3,    chat_uniq_24, 
              photo_hits_3,    photo_hits_24,   photo_uniq_3,   photo_uniq_24, 
              social_hits_3,   social_hits_24,  social_uniq_3,  social_uniq_24, 
              speed_hits,      speed_uniq, 
              line_hits_24,    line_uniq_24, 
              snap_hits_24,    snap_uniq_24, 
              tumblr_hits_24,  tumblr_uniq_24, 
              waze_hits_24,    waze_uniq_24, 
              wechat_hits_24,  wechat_uniq_24, 
              wiki_hits_24,    wiki_uniq_24)
      values (@tran_dt,        @tran_tm,        @total_hits,    @total_uniq,
              @unli_hits_3,    @unli_hits_24,   @unli_uniq_3,   @unli_uniq_24, 
              @email_hits_3,   @email_hits_24,  @email_uniq_3,  @email_uniq_24, 
              @chat_hits_3,    @chat_hits_24,   @chat_uniq_3,   @chat_uniq_24, 
              @photo_hits_3,   @photo_hits_24,  @photo_uniq_3,  @photo_uniq_24, 
              @social_hits_3,  @social_hits_24, @social_uniq_3, @social_uniq_24, 
              @speed_hits,     @speed_uniq, 
              @line_hits_24,   @line_uniq_24, 
              @snap_hits_24,   @snap_uniq_24, 
              @tumblr_hits_24, @tumblr_uniq_24, 
              @waze_hits_24,   @waze_uniq_24, 
              @wechat_hits_24, @wechat_uniq_24, 
              @wiki_hits_24,   @wiki_uniq_24);
   END WHILE;

   BEGIN
      DECLARE vPlan varchar(30);
      DECLARE done_p int default 0;
      DECLARE cursor plan_c as 
      SELECT plan FROM
         (select 'UNLI'       as plan union
          select 'EMAIL'      as plan union
          select 'CHAT'       as plan union
          select 'PHOTO'      as plan union
          select 'SOCIAL'     as plan union
          select 'SPEEDBOOST' as plan union
          select 'LINE'       as plan union
          select 'SNAPCHAT'   as plan union
          select 'TUMBLR'     as plan union
          select 'WAZE'       as plan union
          select 'WECHAT'     as plan union
          select 'WIKIPEDIA'  as plan) as t;
      DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done_p = 1;
      OPEN plan_c;
      REPEAT
         FETCH plan_c into vPlan;
         IF not done_p THEN
            select count(1), count(distinct phone) into @tm_h_01 @tm_u_01 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '01' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_02 @tm_u_02 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '02' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_03 @tm_u_03 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '03' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_04 @tm_u_04 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '04' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_05 @tm_u_05 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '05' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_06 @tm_u_06 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '06' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_07 @tm_u_07 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '07' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_08 @tm_u_08 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '08' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_09 @tm_u_09 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '09' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_10 @tm_u_10 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '10' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_11 @tm_u_11 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '11' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_12 @tm_u_12 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '12' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_13 @tm_u_13 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '13' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_14 @tm_u_14 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '14' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_15 @tm_u_15 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '15' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_16 @tm_u_16 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '16' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_17 @tm_u_17 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '17' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_18 @tm_u_18 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '18' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_19 @tm_u_19 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '19' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_20 @tm_u_20 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '20' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_21 @tm_u_21 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '21' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_22 @tm_u_22 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '22' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_23 @tm_u_23 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '23' and free='false' and plan=vPlan;
            select count(1), count(distinct phone) into @tm_h_sm @tm_u_sm from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan=vPlan;
            insert into powerapp_hourly_report
                   (tran_dt, plan, type, tm_00, tm_01, tm_02, tm_03, tm_04, tm_05, tm_06, tm_07, tm_08, tm_09, tm_10, tm_11, tm_12, tm_13, tm_14, tm_15, tm_16, tm_17, tm_18, tm_19, tm_20, tm_21, tm_22, tm_23, tm_tot )
            values (@tran_dt, vPlan, 'hits', @tm_h_00, @tm_h_01, @tm_h_02, @tm_h_03, @tm_h_04, @tm_h_05, @tm_h_06, @tm_h_07, @tm_h_08, @tm_h_09, @tm_h_10, @tm_h_11, @tm_h_12, @tm_h_13, @tm_h_14, @tm_h_15, @tm_h_16, @tm_h_17, @tm_h_18, @tm_h_19, @tm_h_20, @tm_h_21, @tm_h_22, @tm_h_23, @tm_h_sm );
            insert into powerapp_hourly_report
                   (tran_dt, plan, type, tm_00, tm_01, tm_02, tm_03, tm_04, tm_05, tm_06, tm_07, tm_08, tm_09, tm_10, tm_11, tm_12, tm_13, tm_14, tm_15, tm_16, tm_17, tm_18, tm_19, tm_20, tm_21, tm_22, tm_23, tm_tot )
            values (@tran_dt, vPlan, 'uniq', @tm_u_00, @tm_u_01, @tm_u_02, @tm_u_03, @tm_u_04, @tm_u_05, @tm_u_06, @tm_u_07, @tm_u_08, @tm_u_09, @tm_u_10, @tm_u_11, @tm_u_12, @tm_u_13, @tm_u_14, @tm_u_15, @tm_u_16, @tm_u_17, @tm_u_18, @tm_u_19, @tm_u_20, @tm_u_21, @tm_u_22, @tm_u_23, @tm_u_sm );
         END IF;
      UNTIL done_p
      END REPEAT;
   END; 

   BEGIN
      DECLARE vPlan varchar(30);
      DECLARE done_p int default 0;
      DECLARE plan_c cursor for SELECT plan FROM
         (select 'UNLI'       as plan union
          select 'EMAIL'      as plan union
          select 'CHAT'       as plan union
          select 'PHOTO'      as plan union
          select 'SOCIAL'     as plan union
          select 'SPEEDBOOST' as plan union
          select 'LINE'       as plan union
          select 'SNAPCHAT'   as plan union
          select 'TUMBLR'     as plan union
          select 'WAZE'       as plan union
          select 'WECHAT'     as plan union
          select 'WIKIPEDIA'  as plan) as t;
      DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done_p = 1;
      DELETE FROM powerapp_hourly_report WHERE tran_dt = @tran_dt;
      OPEN plan_c;
      REPEAT
         FETCH plan_c into vPlan;
         IF not done_p THEN
            select count(1), count(distinct phone) into @tm_h_00, @tm_u_00 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '00' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_01, @tm_u_01 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '01' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_02, @tm_u_02 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '02' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_03, @tm_u_03 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '03' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_04, @tm_u_04 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '04' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_05, @tm_u_05 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '05' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_06, @tm_u_06 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '06' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_07, @tm_u_07 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '07' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_08, @tm_u_08 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '08' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_09, @tm_u_09 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '09' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_10, @tm_u_10 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '10' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_11, @tm_u_11 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '11' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_12, @tm_u_12 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '12' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_13, @tm_u_13 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '13' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_14, @tm_u_14 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '14' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_15, @tm_u_15 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '15' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_16, @tm_u_16 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '16' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_17, @tm_u_17 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '17' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_18, @tm_u_18 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '18' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_19, @tm_u_19 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '19' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_20, @tm_u_20 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '20' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_21, @tm_u_21 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '21' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_22, @tm_u_22 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '22' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_23, @tm_u_23 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '23' and free='false' and plan=vPlan and validity < 86400;
            select count(1), count(distinct phone) into @tm_h_sm, @tm_u_sm from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan=vPlan and validity < 86400;
            insert into powerapp_hourly_report
                   (tran_dt, plan, type, validity, tm_00, tm_01, tm_02, tm_03, tm_04, tm_05, tm_06, tm_07, tm_08, tm_09, tm_10, tm_11, tm_12, tm_13, tm_14, tm_15, tm_16, tm_17, tm_18, tm_19, tm_20, tm_21, tm_22, tm_23, tm_tot )
            values (@tran_dt, vPlan, 'hits', '03', @tm_h_00, @tm_h_01, @tm_h_02, @tm_h_03, @tm_h_04, @tm_h_05, @tm_h_06, @tm_h_07, @tm_h_08, @tm_h_09, @tm_h_10, @tm_h_11, @tm_h_12, @tm_h_13, @tm_h_14, @tm_h_15, @tm_h_16, @tm_h_17, @tm_h_18, @tm_h_19, @tm_h_20, @tm_h_21, @tm_h_22, @tm_h_23, @tm_h_sm );
            insert into powerapp_hourly_report
                   (tran_dt, plan, type, validity, tm_00, tm_01, tm_02, tm_03, tm_04, tm_05, tm_06, tm_07, tm_08, tm_09, tm_10, tm_11, tm_12, tm_13, tm_14, tm_15, tm_16, tm_17, tm_18, tm_19, tm_20, tm_21, tm_22, tm_23, tm_tot )
            values (@tran_dt, vPlan, 'uniq', '03', @tm_u_00, @tm_u_01, @tm_u_02, @tm_u_03, @tm_u_04, @tm_u_05, @tm_u_06, @tm_u_07, @tm_u_08, @tm_u_09, @tm_u_10, @tm_u_11, @tm_u_12, @tm_u_13, @tm_u_14, @tm_u_15, @tm_u_16, @tm_u_17, @tm_u_18, @tm_u_19, @tm_u_20, @tm_u_21, @tm_u_22, @tm_u_23, @tm_u_sm );
            select count(1), count(distinct phone) into @tm_h_00, @tm_u_00 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '00' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_01, @tm_u_01 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '01' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_02, @tm_u_02 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '02' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_03, @tm_u_03 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '03' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_04, @tm_u_04 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '04' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_05, @tm_u_05 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '05' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_06, @tm_u_06 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '06' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_07, @tm_u_07 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '07' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_08, @tm_u_08 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '08' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_09, @tm_u_09 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '09' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_10, @tm_u_10 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '10' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_11, @tm_u_11 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '11' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_12, @tm_u_12 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '12' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_13, @tm_u_13 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '13' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_14, @tm_u_14 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '14' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_15, @tm_u_15 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '15' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_16, @tm_u_16 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '16' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_17, @tm_u_17 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '17' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_18, @tm_u_18 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '18' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_19, @tm_u_19 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '19' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_20, @tm_u_20 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '20' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_21, @tm_u_21 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '21' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_22, @tm_u_22 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '22' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_23, @tm_u_23 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = '23' and free='false' and plan=vPlan and validity >= 86400;
            select count(1), count(distinct phone) into @tm_h_sm, @tm_u_sm from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan=vPlan and validity >= 86400;
            insert into powerapp_hourly_report
                   (tran_dt, plan, type, validity, tm_00, tm_01, tm_02, tm_03, tm_04, tm_05, tm_06, tm_07, tm_08, tm_09, tm_10, tm_11, tm_12, tm_13, tm_14, tm_15, tm_16, tm_17, tm_18, tm_19, tm_20, tm_21, tm_22, tm_23, tm_tot )
            values (@tran_dt, vPlan, 'hits', '24', @tm_h_00, @tm_h_01, @tm_h_02, @tm_h_03, @tm_h_04, @tm_h_05, @tm_h_06, @tm_h_07, @tm_h_08, @tm_h_09, @tm_h_10, @tm_h_11, @tm_h_12, @tm_h_13, @tm_h_14, @tm_h_15, @tm_h_16, @tm_h_17, @tm_h_18, @tm_h_19, @tm_h_20, @tm_h_21, @tm_h_22, @tm_h_23, @tm_h_sm );
            insert into powerapp_hourly_report
                   (tran_dt, plan, type, validity, tm_00, tm_01, tm_02, tm_03, tm_04, tm_05, tm_06, tm_07, tm_08, tm_09, tm_10, tm_11, tm_12, tm_13, tm_14, tm_15, tm_16, tm_17, tm_18, tm_19, tm_20, tm_21, tm_22, tm_23, tm_tot )
            values (@tran_dt, vPlan, 'uniq', '24', @tm_u_00, @tm_u_01, @tm_u_02, @tm_u_03, @tm_u_04, @tm_u_05, @tm_u_06, @tm_u_07, @tm_u_08, @tm_u_09, @tm_u_10, @tm_u_11, @tm_u_12, @tm_u_13, @tm_u_14, @tm_u_15, @tm_u_16, @tm_u_17, @tm_u_18, @tm_u_19, @tm_u_20, @tm_u_21, @tm_u_22, @tm_u_23, @tm_u_sm );
         END IF;
      UNTIL done_p
      END REPEAT;
   END; 

END;
//

delimiter ;

call sp_regenerate_hi10_stats('2014-03-01');
call sp_regenerate_hi10_stats('2014-03-02');
call sp_regenerate_hi10_stats('2014-03-03');
call sp_regenerate_hi10_stats('2014-03-04');
call sp_regenerate_hi10_stats('2014-03-05');
call sp_regenerate_hi10_stats('2014-03-06');
call sp_regenerate_hi10_stats('2014-03-07');
call sp_regenerate_hi10_stats('2014-03-08');
call sp_regenerate_hi10_stats('2014-03-09');
call sp_regenerate_hi10_stats('2014-03-10');
call sp_regenerate_hi10_stats('2014-03-11');
call sp_regenerate_hi10_stats('2014-03-12');
call sp_regenerate_hi10_stats('2014-03-13');
call sp_regenerate_hi10_stats('2014-03-14');
call sp_regenerate_hi10_stats('2014-03-15');
call sp_regenerate_hi10_stats('2014-03-16');
call sp_regenerate_hi10_stats('2014-03-17');
call sp_regenerate_hi10_stats('2014-03-18');
call sp_regenerate_hi10_stats('2014-03-19');
call sp_regenerate_hi10_stats('2014-03-20');
call sp_regenerate_hi10_stats('2014-03-21');
call sp_regenerate_hi10_stats('2014-03-22');
call sp_regenerate_hi10_stats('2014-03-23');



ALTER TABLE powerapp_dailyrep CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE powerapp_dailyrep CHARACTER SET latin1 COLLATE latin1_swedish_ci;



DROP PROCEDURE IF EXISTS sp_generate_hi10_stats_now;
delimiter //
CREATE PROCEDURE sp_generate_hi10_stats_now()
begin
    SET @tran_dt = curdate(); 
    SET @tran_nw = date_add(@tran_dt, interval 1 day);
    delete from powerapp_dailyrep where tran_dt = @tran_dt;
    delete from powerapp_validity_dailyrep where tran_dt = @tran_dt;
    delete from powerapp_hourlyrep where tran_dt = @tran_dt;

    select count(1), count(distinct phone) into @unli_hits,   @unli_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI';
    select count(1), count(distinct phone) into @email_hits,  @email_uniq  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL';
    select count(1), count(distinct phone) into @chat_hits,   @chat_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CHAT';
    select count(1), count(distinct phone) into @photo_hits,  @photo_uniq  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO';
    select count(1), count(distinct phone) into @social_hits, @social_uniq from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL';
    select count(1), count(distinct phone) into @speed_hits,  @speed_uniq  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SPEEDBOOST';
    select count(1), count(distinct phone) into @line_hits,   @line_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='LINE';
    select count(1), count(distinct phone) into @snap_hits,   @snap_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SNAPCHAT';
    select count(1), count(distinct phone) into @tumblr_hits, @tumblr_uniq from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='TUMBLR';
    select count(1), count(distinct phone) into @waze_hits,   @waze_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WAZE';
    select count(1), count(distinct phone) into @wechat_hits, @wechat_uniq from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT';
    select count(1), count(distinct phone) into @wiki_hits,   @wiki_uniq   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WIKIPEDIA';
    select count(1), count(distinct phone) into @total_hits,  @total_uniq  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false';

    insert ignore into powerapp_dailyrep (
            tran_dt, total_hits, total_uniq,
            unli_hits, email_hits, social_hits, photo_hits, chat_hits, speed_hits, line_hits, snap_hits, tumblr_hits, waze_hits, wechat_hits, wiki_hits,
            unli_uniq, email_uniq, social_uniq, photo_uniq, chat_uniq, speed_uniq, line_uniq, snap_uniq, tumblr_uniq, waze_uniq, wechat_uniq, wiki_uniq )
    values (@tran_dt, @total_hits, @total_uniq,
            @unli_hits, @email_hits, @social_hits, @photo_hits, @chat_hits, @speed_hits, @line_hits, @snap_hits, @tumblr_hits, @waze_hits, @wechat_hits, @wiki_hits,
            @unli_uniq, @email_uniq, @social_uniq, @photo_uniq, @chat_uniq, @speed_uniq, @line_uniq, @snap_uniq, @tumblr_uniq, @waze_uniq, @wechat_uniq, @wiki_uniq);

    select max(timein)
    into   @vTimeIn
    from   powerapp_concurrent_log
    where  datein = @tran_dt;

    if (@vTimeIn = '23:59:00') then

       select group_concat(left(timein,5) SEPARATOR ','), num_subs
       into   @vTimeIn, @vNumSubs
       from   powerapp_concurrent_log
       where  datein = @tran_dt
       and    num_subs = (select max(num_subs)
                          from   powerapp_concurrent_log
                          where  datein = @tran_dt
                         );


       select avg(num_subs)
       into   @vAvgSubs
       from   powerapp_concurrent_log
       where  datein = @tran_dt;


       select count(1)
       into   @vNumOptout
       from   powerapp_optout_log
       where  datein >= @tran_dt
       and    datein < @tran_nw;
    else
       SET @vTimeIn  = '00:00';
       SET @vNumSubs = 0;
       SET @vAvgSubs = 0;
    end if;

    select count(distinct phone) 
    into  @NumUniq30d
    from powerapp_log 
    where datein >= date_sub(@tran_dt, interval 31 day) 
    and datein < @tran_nw;

    update powerapp_dailyrep
    set    num_optout= IFNULL(@vNumOptout,0),
           concurrent_max_tm= IFNULL(@vTimeIn,'00:00'),
           concurrent_max_subs=IFNULL(@vNumSubs,0),
           concurrent_avg_subs=IFNULL(@vAvgSubs,0),
           num_uniq_30d=IFNULL(@NumUniq30d,0)
    where  tran_dt = @tran_dt;


    select count(1), count(distinct phone) into @unli_hits_3,    @unli_uniq_3    from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and validity<86400;
    select count(1), count(distinct phone) into @unli_hits_24,   @unli_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and validity >=86400;
    select count(1), count(distinct phone) into @email_hits_3,   @email_uniq_3   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL' and validity<86400;  
    select count(1), count(distinct phone) into @email_hits_24,  @email_uniq_24  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL' and validity >=86400;
    select count(1), count(distinct phone) into @chat_hits_3,    @chat_uniq_3    from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CHAT' and validity<86400;  
    select count(1), count(distinct phone) into @chat_hits_24,   @chat_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CHAT' and validity >=86400;
    select count(1), count(distinct phone) into @photo_hits_3,   @photo_uniq_3   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity<86400;  
    select count(1), count(distinct phone) into @photo_hits_24,  @photo_uniq_24  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity >=86400;
    select count(1), count(distinct phone) into @social_hits_3,  @social_uniq_3  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity <86400;
    select count(1), count(distinct phone) into @social_hits_24, @social_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity >=86400;
    select count(1), count(distinct phone) into @speed_hits,     @speed_uniq     from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SPEEDBOOST';
    select count(1), count(distinct phone) into @line_hits_24,   @line_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='LINE';
    select count(1), count(distinct phone) into @snap_hits_24,   @snap_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SNAPCHAT';
    select count(1), count(distinct phone) into @tumblr_hits_24, @tumblr_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='TUMBLR';
    select count(1), count(distinct phone) into @waze_hits_24,   @waze_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WAZE';
    select count(1), count(distinct phone) into @wechat_hits_24, @wechat_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT';
    select count(1), count(distinct phone) into @wiki_hits_24,   @wiki_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WIKIPEDIA';

    insert ignore into powerapp_validity_dailyrep
           (tran_dt,         total_hits,      total_uniq,
            unli_hits_3,     unli_hits_24,    unli_uniq_3,    unli_uniq_24, 
            email_hits_3,    email_hits_24,   email_uniq_3,   email_uniq_24, 
            chat_hits_3,     chat_hits_24,    chat_uniq_3,    chat_uniq_24, 
            photo_hits_3,    photo_hits_24,   photo_uniq_3,   photo_uniq_24, 
            social_hits_3,   social_hits_24,  social_uniq_3,  social_uniq_24, 
            speed_hits,      speed_uniq, 
            line_hits_24,    line_uniq_24, 
            snap_hits_24,    snap_uniq_24, 
            tumblr_hits_24,  tumblr_uniq_24, 
            waze_hits_24,    waze_uniq_24, 
            wechat_hits_24,  wechat_uniq_24, 
            wiki_hits_24,    wiki_uniq_24)
    values (@tran_dt,        @total_hits,     @total_uniq,
            @unli_hits_3,    @unli_hits_24,   @unli_uniq_3,   @unli_uniq_24, 
            @email_hits_3,   @email_hits_24,  @email_uniq_3,  @email_uniq_24, 
            @chat_hits_3,    @chat_hits_24,   @chat_uniq_3,   @chat_uniq_24, 
            @photo_hits_3,   @photo_hits_24,  @photo_uniq_3,  @photo_uniq_24, 
            @social_hits_3,  @social_hits_24, @social_uniq_3, @social_uniq_24, 
            @speed_hits,     @speed_uniq, 
            @line_hits_24,   @line_uniq_24, 
            @snap_hits_24,   @snap_uniq_24, 
            @tumblr_hits_24, @tumblr_uniq_24, 
            @waze_hits_24,   @waze_uniq_24, 
            @wechat_hits_24, @wechat_uniq_24, 
            @wiki_hits_24,   @wiki_uniq_24);

   set @vCtr = 0;
   WHILE (@vCtr <= 23) DO
      -- reset all values...
      select concat(lpad(@vCtr, 2, '0'), ':00:00') into @tran_tm;
      select 0, 0 into @unli_hits_3,    @unli_uniq_3;
      select 0, 0 into @unli_hits_24,   @unli_uniq_24;
      select 0, 0 into @email_hits_3,   @email_uniq_3;
      select 0, 0 into @email_hits_24,  @email_uniq_24;
      select 0, 0 into @chat_hits_3,    @chat_uniq_3;
      select 0, 0 into @chat_hits_24,   @chat_uniq_24;
      select 0, 0 into @photo_hits_3,   @photo_uniq_3;
      select 0, 0 into @photo_hits_24,  @photo_uniq_24;
      select 0, 0 into @social_hits_3,  @social_uniq_3;
      select 0, 0 into @social_hits_24, @social_uniq_24;
      select 0, 0 into @speed_hits,     @speed_uniq;
      select 0, 0 into @line_hits_24,   @line_uniq_24;
      select 0, 0 into @snap_hits_24,   @snap_uniq_24;
      select 0, 0 into @tumblr_hits_24, @tumblr_uniq_24;
      select 0, 0 into @waze_hits_24,   @waze_uniq_24;
      select 0, 0 into @wechat_hits_24, @wechat_uniq_24;
      select 0, 0 into @wiki_hits_24,   @wiki_uniq_24;


      select count(1), count(distinct phone) into @unli_hits_3,    @unli_uniq_3    from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and validity<86400;
      select count(1), count(distinct phone) into @unli_hits_24,   @unli_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and validity >=86400;
      select count(1), count(distinct phone) into @email_hits_3,   @email_uniq_3   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity<86400;  
      select count(1), count(distinct phone) into @email_hits_24,  @email_uniq_24  from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity >=86400;
      select count(1), count(distinct phone) into @chat_hits_3,    @chat_uniq_3    from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity<86400;  
      select count(1), count(distinct phone) into @chat_hits_24,   @chat_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity >=86400;
      select count(1), count(distinct phone) into @photo_hits_3,   @photo_uniq_3   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity<86400;  
      select count(1), count(distinct phone) into @photo_hits_24,  @photo_uniq_24  from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity >=86400;
      select count(1), count(distinct phone) into @social_hits_3,  @social_uniq_3  from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity <86400;
      select count(1), count(distinct phone) into @social_hits_24, @social_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity >=86400;
      select count(1), count(distinct phone) into @speed_hits,     @speed_uniq     from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SPEEDBOOST';
      select count(1), count(distinct phone) into @line_hits_24,   @line_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='LINE';
      select count(1), count(distinct phone) into @snap_hits_24,   @snap_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SNAPCHAT';
      select count(1), count(distinct phone) into @tumblr_hits_24, @tumblr_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='TUMBLR';
      select count(1), count(distinct phone) into @waze_hits_24,   @waze_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WAZE';
      select count(1), count(distinct phone) into @wechat_hits_24, @wechat_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WECHAT';
      select count(1), count(distinct phone) into @wiki_hits_24,   @wiki_uniq_24   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WIKIPEDIA';
      select count(1), count(distinct phone) into @total_hits,     @total_uniq     from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false';
      SET @vCtr = @vCtr + 1; 

      insert ignore into powerapp_hourlyrep
             (tran_dt,         tran_tm,         total_hits,     total_uniq,
              unli_hits_3,     unli_hits_24,    unli_uniq_3,    unli_uniq_24, 
              email_hits_3,    email_hits_24,   email_uniq_3,   email_uniq_24, 
              chat_hits_3,     chat_hits_24,    chat_uniq_3,    chat_uniq_24, 
              photo_hits_3,    photo_hits_24,   photo_uniq_3,   photo_uniq_24, 
              social_hits_3,   social_hits_24,  social_uniq_3,  social_uniq_24, 
              speed_hits,      speed_uniq, 
              line_hits_24,    line_uniq_24, 
              snap_hits_24,    snap_uniq_24, 
              tumblr_hits_24,  tumblr_uniq_24, 
              waze_hits_24,    waze_uniq_24, 
              wechat_hits_24,  wechat_uniq_24, 
              wiki_hits_24,    wiki_uniq_24)
      values (@tran_dt,        @tran_tm,        @total_hits,    @total_uniq,
              @unli_hits_3,    @unli_hits_24,   @unli_uniq_3,   @unli_uniq_24, 
              @email_hits_3,   @email_hits_24,  @email_uniq_3,  @email_uniq_24, 
              @chat_hits_3,    @chat_hits_24,   @chat_uniq_3,   @chat_uniq_24, 
              @photo_hits_3,   @photo_hits_24,  @photo_uniq_3,  @photo_uniq_24, 
              @social_hits_3,  @social_hits_24, @social_uniq_3, @social_uniq_24, 
              @speed_hits,     @speed_uniq, 
              @line_hits_24,   @line_uniq_24, 
              @snap_hits_24,   @snap_uniq_24, 
              @tumblr_hits_24, @tumblr_uniq_24, 
              @waze_hits_24,   @waze_uniq_24, 
              @wechat_hits_24, @wechat_uniq_24, 
              @wiki_hits_24,   @wiki_uniq_24);
   END WHILE;

END;
//

delimiter ;
