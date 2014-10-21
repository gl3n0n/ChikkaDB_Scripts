DROP PROCEDURE sp_regenerate_hi10_stats;

delimiter //
CREATE PROCEDURE sp_regenerate_hi10_stats(p_trandate date)
begin
    SET @tran_dt = p_trandate;
    SET @tran_nw = date_add(p_trandate, interval 1 day);
    delete from powerapp_dailyrep where tran_dt = @tran_dt;
    delete from powerapp_validity_dailyrep where tran_dt = @tran_dt;
    delete from powerapp_hourlyrep where tran_dt = @tran_dt;

    select count(1), count(distinct phone) into @unli_hits,        @unli_uniq        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI';
    select count(1), count(distinct phone) into @email_hits,       @email_uniq       from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL';
    select count(1), count(distinct phone) into @chat_hits,        @chat_uniq        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CHAT';
    select count(1), count(distinct phone) into @photo_hits,       @photo_uniq       from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO';
    select count(1), count(distinct phone) into @free_social_hits, @free_social_uniq from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='FREE_SOCIAL';
    select count(1), count(distinct phone) into @social_hits,      @social_uniq      from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL';
    select count(1), count(distinct phone) into @facebook_hits,    @facebook_uniq    from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='FACEBOOK';
    select count(1), count(distinct phone) into @speed_hits,       @speed_uniq       from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SPEEDBOOST';
    select count(1), count(distinct phone) into @line_hits,        @line_uniq        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='LINE';
    select count(1), count(distinct phone) into @snap_hits,        @snap_uniq        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SNAPCHAT';
    select count(1), count(distinct phone) into @tumblr_hits,      @tumblr_uniq      from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='TUMBLR';
    select count(1), count(distinct phone) into @waze_hits,        @waze_uniq        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WAZE';
    select count(1), count(distinct phone) into @wechat_hits,      @wechat_uniq      from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT';
    select count(1), count(distinct phone) into @wiki_hits,        @wiki_uniq        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WIKIPEDIA';
    select count(1), count(distinct phone) into @total_hits,       @total_uniq       from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false';

    insert ignore into powerapp_dailyrep (
            tran_dt, total_hits, total_uniq,
            unli_hits, email_hits, social_hits, photo_hits, chat_hits, speed_hits, line_hits, snap_hits, tumblr_hits, waze_hits, wechat_hits, wiki_hits, free_social_hits, facebook_hits,
            unli_uniq, email_uniq, social_uniq, photo_uniq, chat_uniq, speed_uniq, line_uniq, snap_uniq, tumblr_uniq, waze_uniq, wechat_uniq, wiki_uniq, free_social_uniq, facebook_uniq )
    values (@tran_dt, @total_hits, @total_uniq,
            @unli_hits, @email_hits, @social_hits, @photo_hits, @chat_hits, @speed_hits, @line_hits, @snap_hits, @tumblr_hits, @waze_hits, @wechat_hits, @wiki_hits, @free_social_hits, @facebook_hits,
            @unli_uniq, @email_uniq, @social_uniq, @photo_uniq, @chat_uniq, @speed_uniq, @line_uniq, @snap_uniq, @tumblr_uniq, @waze_uniq, @wechat_uniq, @wiki_uniq, @free_social_uniq, @facebook_uniq);

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


    select count(1), count(distinct phone) into @unli_hits_3,         @unli_uniq_3          from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and validity<86400;
    select count(1), count(distinct phone) into @unli_hits_24,        @unli_uniq_24         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and validity >=86400;
    select count(1), count(distinct phone) into @email_hits_3,        @email_uniq_3         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL' and validity<86400;
    select count(1), count(distinct phone) into @email_hits_24,       @email_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL' and validity >=86400;
    select count(1), count(distinct phone) into @chat_hits_3,         @chat_uniq_3          from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CHAT' and validity<86400;
    select count(1), count(distinct phone) into @chat_hits_24,        @chat_uniq_24         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CHAT' and validity >=86400;
    select count(1), count(distinct phone) into @photo_hits_3,        @photo_uniq_3         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity<86400;
    select count(1), count(distinct phone) into @photo_hits_24,       @photo_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity >=86400;
    select count(1), count(distinct phone) into @social_hits_3,       @social_uniq_3        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity <86400;
    select count(1), count(distinct phone) into @social_hits_24,      @social_uniq_24       from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity >=86400;
    select count(1), count(distinct phone) into @speed_hits,          @speed_uniq           from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SPEEDBOOST';
    select count(1), count(distinct phone) into @line_hits_24,        @line_uniq_24         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='LINE';
    select count(1), count(distinct phone) into @snap_hits_24,        @snap_uniq_24         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SNAPCHAT';
    select count(1), count(distinct phone) into @tumblr_hits_24,      @tumblr_uniq_24       from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='TUMBLR';
    select count(1), count(distinct phone) into @waze_hits_24,        @waze_uniq_24         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WAZE';
    select count(1), count(distinct phone) into @wechat_hits_24,      @wechat_uniq_24       from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT';
    select count(1), count(distinct phone) into @wiki_hits_24,        @wiki_uniq_24         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WIKIPEDIA';
    select count(1), count(distinct phone) into @facebook_hits_24,    @facebook_uniq_24     from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='FACEBOOK';
    select count(1), count(distinct phone) into @free_social_hits_24, @free_social_uniq_24  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='FREE_SOCIAL';

    insert ignore into powerapp_validity_dailyrep
           (tran_dt,             total_hits,      total_uniq,
            unli_hits_3,         unli_hits_24,    unli_uniq_3,    unli_uniq_24,
            email_hits_3,        email_hits_24,   email_uniq_3,   email_uniq_24,
            chat_hits_3,         chat_hits_24,    chat_uniq_3,    chat_uniq_24,
            photo_hits_3,        photo_hits_24,   photo_uniq_3,   photo_uniq_24,
            social_hits_3,       social_hits_24,  social_uniq_3,  social_uniq_24,
            speed_hits,          speed_uniq,
            line_hits_24,        line_uniq_24,
            snap_hits_24,        snap_uniq_24,
            tumblr_hits_24,      tumblr_uniq_24,
            waze_hits_24,        waze_uniq_24,
            wechat_hits_24,      wechat_uniq_24,
            wiki_hits_24,        wiki_uniq_24,
            facebook_hits_24,    facebook_uniq_24,
            free_social_hits_24, free_social_uniq_24)
    values (@tran_dt,             @total_hits,     @total_uniq,
            @unli_hits_3,         @unli_hits_24,   @unli_uniq_3,   @unli_uniq_24,
            @email_hits_3,        @email_hits_24,  @email_uniq_3,  @email_uniq_24,
            @chat_hits_3,         @chat_hits_24,   @chat_uniq_3,   @chat_uniq_24,
            @photo_hits_3,        @photo_hits_24,  @photo_uniq_3,  @photo_uniq_24,
            @social_hits_3,       @social_hits_24, @social_uniq_3, @social_uniq_24,
            @speed_hits,          @speed_uniq,
            @line_hits_24,        @line_uniq_24,
            @snap_hits_24,        @snap_uniq_24,
            @tumblr_hits_24,      @tumblr_uniq_24,
            @waze_hits_24,        @waze_uniq_24,
            @wechat_hits_24,      @wechat_uniq_24,
            @wiki_hits_24,        @wiki_uniq_24,
            @facebook_hits_24,    @facebook_uniq_24,
            @free_social_hits_24, @free_social_uniq_24);

   set @vCtr = 0;
   WHILE (@vCtr <= 23) DO

      select concat(lpad(@vCtr, 2, '0'), ':00:00') into @tran_tm;
      select 0, 0 into @unli_hits_3,         @unli_uniq_3;
      select 0, 0 into @unli_hits_24,        @unli_uniq_24;
      select 0, 0 into @email_hits_3,        @email_uniq_3;
      select 0, 0 into @email_hits_24,       @email_uniq_24;
      select 0, 0 into @chat_hits_3,         @chat_uniq_3;
      select 0, 0 into @chat_hits_24,        @chat_uniq_24;
      select 0, 0 into @photo_hits_3,        @photo_uniq_3;
      select 0, 0 into @photo_hits_24,       @photo_uniq_24;
      select 0, 0 into @social_hits_3,       @social_uniq_3;
      select 0, 0 into @social_hits_24,      @social_uniq_24;
      select 0, 0 into @speed_hits,          @speed_uniq;
      select 0, 0 into @line_hits_24,        @line_uniq_24;
      select 0, 0 into @snap_hits_24,        @snap_uniq_24;
      select 0, 0 into @tumblr_hits_24,      @tumblr_uniq_24;
      select 0, 0 into @waze_hits_24,        @waze_uniq_24;
      select 0, 0 into @wechat_hits_24,      @wechat_uniq_24;
      select 0, 0 into @wiki_hits_24,        @wiki_uniq_24;
      select 0, 0 into @facebook_hits_24,    @facebook_uniq_24;
      select 0, 0 into @free_social_hits_24, @free_social_uniq_24;


      select count(1), count(distinct phone) into @unli_hits_3,         @unli_uniq_3         from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and validity<86400;
      select count(1), count(distinct phone) into @unli_hits_24,        @unli_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and validity >=86400;
      select count(1), count(distinct phone) into @email_hits_3,        @email_uniq_3        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity<86400;
      select count(1), count(distinct phone) into @email_hits_24,       @email_uniq_24       from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity >=86400;
      select count(1), count(distinct phone) into @chat_hits_3,         @chat_uniq_3         from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity<86400;
      select count(1), count(distinct phone) into @chat_hits_24,        @chat_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity >=86400;
      select count(1), count(distinct phone) into @photo_hits_3,        @photo_uniq_3        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity<86400;
      select count(1), count(distinct phone) into @photo_hits_24,       @photo_uniq_24       from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity >=86400;
      select count(1), count(distinct phone) into @social_hits_3,       @social_uniq_3       from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity <86400;
      select count(1), count(distinct phone) into @social_hits_24,      @social_uniq_24      from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity >=86400;
      select count(1), count(distinct phone) into @speed_hits,          @speed_uniq          from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SPEEDBOOST';
      select count(1), count(distinct phone) into @line_hits_24,        @line_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='LINE';
      select count(1), count(distinct phone) into @snap_hits_24,        @snap_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SNAPCHAT';
      select count(1), count(distinct phone) into @tumblr_hits_24,      @tumblr_uniq_24      from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='TUMBLR';
      select count(1), count(distinct phone) into @waze_hits_24,        @waze_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WAZE';
      select count(1), count(distinct phone) into @wechat_hits_24,      @wechat_uniq_24      from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WECHAT';
      select count(1), count(distinct phone) into @wiki_hits_24,        @wiki_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WIKIPEDIA';
      select count(1), count(distinct phone) into @facebook_hits_24,    @facebook_uniq_24    from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='FACEBOOK';
      select count(1), count(distinct phone) into @free_social_hits_24, @free_social_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='FREE_SOCIAL';
      select count(1), count(distinct phone) into @total_hits,          @total_uniq          from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false';
      SET @vCtr = @vCtr + 1;

      insert ignore into powerapp_hourlyrep
             (tran_dt,              tran_tm,         total_hits,     total_uniq,
              unli_hits_3,          unli_hits_24,    unli_uniq_3,    unli_uniq_24,
              email_hits_3,         email_hits_24,   email_uniq_3,   email_uniq_24,
              chat_hits_3,          chat_hits_24,    chat_uniq_3,    chat_uniq_24,
              photo_hits_3,         photo_hits_24,   photo_uniq_3,   photo_uniq_24,
              social_hits_3,        social_hits_24,  social_uniq_3,  social_uniq_24,
              speed_hits,           speed_uniq,
              line_hits_24,         line_uniq_24,
              snap_hits_24,         snap_uniq_24,
              tumblr_hits_24,       tumblr_uniq_24,
              waze_hits_24,         waze_uniq_24,
              wechat_hits_24,       wechat_uniq_24,
              wiki_hits_24,         wiki_uniq_24,
              facebook_hits_24,     facebook_uniq_24,
              free_social_hits_24,  free_social_uniq_24)
      values (@tran_dt,             @tran_tm,        @total_hits,    @total_uniq,
              @unli_hits_3,         @unli_hits_24,   @unli_uniq_3,   @unli_uniq_24,
              @email_hits_3,        @email_hits_24,  @email_uniq_3,  @email_uniq_24,
              @chat_hits_3,         @chat_hits_24,   @chat_uniq_3,   @chat_uniq_24,
              @photo_hits_3,        @photo_hits_24,  @photo_uniq_3,  @photo_uniq_24,
              @social_hits_3,       @social_hits_24, @social_uniq_3, @social_uniq_24,
              @speed_hits,          @speed_uniq,
              @line_hits_24,        @line_uniq_24,
              @snap_hits_24,        @snap_uniq_24,
              @tumblr_hits_24,      @tumblr_uniq_24,
              @waze_hits_24,        @waze_uniq_24,
              @wechat_hits_24,      @wechat_uniq_24,
              @wiki_hits_24,        @wiki_uniq_24,
              @facebook_hits_24,    @facebook_uniq_24,
              @free_social_hits_24, @free_social_uniq_24);
   END WHILE;

   call sp_generate_hi10_brand_stats (@tran_dt);
END;
//

delimiter ;
GRANT EXECUTE ON PROCEDURE  sp_regenerate_hi10_stats  TO 'stats'@'10.11.4.164';
flush privileges;


DROP PROCEDURE sp_generate_hi10_stats;
delimiter //
CREATE PROCEDURE sp_generate_hi10_stats()
begin
   SET @tran_dt = date_sub(curdate(), interval 1 day);
   call sp_regenerate_hi10_stats(@tran_dt);
   call sp_generate_hi10_brand_stats (@tran_dt);
END;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE  sp_generate_hi10_stats  TO 'stats'@'10.11.4.164';
flush privileges;

DROP PROCEDURE sp_generate_hi10_stats_now;
delimiter //
CREATE PROCEDURE sp_generate_hi10_stats_now()
begin
   SET @tran_dt = curdate();
   call sp_regenerate_hi10_stats(@tran_dt);
END;
//
delimiter ;
GRANT EXECUTE ON PROCEDURE  sp_generate_hi10_stats_now  TO 'stats'@'10.11.4.164';
flush privileges;



select tran_tm,
 (unli_hits_3 + unli_hits_24 + email_hits_3 + email_hits_24 + chat_hits_3 + chat_hits_24 + photo_hits_3 + photo_hits_24 + social_hits_3 + social_hits_24 + speed_hits + line_hits_24 + snap_hits_24 + tumblr_hits_24 + waze_hits_24 + wechat_hits_24 + wiki_hits_24 + facebook_hits_24 + free_social_hits_24) comp, 
 total_hits
from powerapp_hourlyrep where tran_dt = '2014-05-27';

select  (unli_hits_3 + unli_hits_24 + email_hits_3 + email_hits_24 + chat_hits_3 + chat_hits_24 + photo_hits_3 + photo_hits_24 + social_hits_3 + social_hits_24 + speed_hits + line_hits_24 + snap_hits_24 + tumblr_hits_24 + waze_hits_24 + wechat_hits_24 + wiki_hits_24 + facebook_hits_24 + free_social_hits_24) comp, 
 total_hits
from powerapp_validity_dailyrep where tran_dt = '2014-05-28';
