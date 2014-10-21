DROP PROCEDURE `sp_generate_pwrapp_sun_brand_stats`;
delimiter //

CREATE PROCEDURE `sp_generate_pwrapp_sun_brand_stats`(p_date date)
begin
   delete from powerapp_brand_dailyrep where tran_dt = p_date;
   delete from powerapp_brand_expiry_dailyrep where tran_dt = p_date;
   select count(1) into @brandIsNull from powerapp_optout_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand is null;
   if @brandIsNull > 0 then
      call sp_optout_add_brand(p_date);
   end if;

   insert into powerapp_brand_dailyrep
   select tran_dt, plan, sum(hits_pre), sum(hits_ppd), sum(hits_tnt), sum(hits_tot), sum(uniq_pre), sum(uniq_ppd), sum(uniq_tnt), sum(uniq_tot) from (
   select left(datein, 10) tran_dt, plan, count(1) hits_pre, 0 hits_ppd, 0 hits_tnt, 0 hits_tot, count(distinct phone) uniq_pre, 0 uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and free='false' and brand='PREPAID' group by tran_dt, plan union
   select left(datein, 10) tran_dt, plan, 0 hits_pre, count(1) hits_ppd, 0 hits_tnt, 0 hits_tot, 0 uniq_pre, count(distinct phone) uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and free='false' and brand='POSTPAID' group by tran_dt, plan union
   select left(datein, 10) tran_dt, plan, 0 hits_pre, 0 hits_ppd, 0 hits_tnt, count(1) hits_tot, 0 uniq_pre, 0 uniq_ppd, 0 uniq_tnt, count(distinct phone) uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and free='false' group by tran_dt, plan
   ) temp_table group by tran_dt, plan;


   insert into powerapp_brand_expiry_dailyrep
   select tran_dt, plan, plan_exp, sum(hits_pre), sum(hits_ppd), sum(hits_tnt), sum(hits_tot), sum(uniq_pre), sum(uniq_ppd), sum(uniq_tnt), sum(uniq_tot) from (
   select left(datein, 10) tran_dt, plan, IF(validity<86400, '3H', '24H') plan_exp, count(1) hits_pre, 0 hits_ppd, 0 hits_tnt, 0 hits_tot, count(distinct phone) uniq_pre, 0 uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and free='false' and brand='PREPAID' group by tran_dt, plan, plan_exp union
   select left(datein, 10) tran_dt, plan, IF(validity<86400, '3H', '24H') plan_exp, 0 hits_pre, count(1) hits_ppd, 0 hits_tnt, 0 hits_tot, 0 uniq_pre, count(distinct phone) uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and free='false' and brand='POSTPAID' group by tran_dt, plan, plan_exp union
   select left(datein, 10) tran_dt, plan, IF(validity<86400, '3H', '24H') plan_exp, 0 hits_pre, 0 hits_ppd, 0 hits_tnt, count(1) hits_tot, 0 uniq_pre, 0 uniq_ppd, 0 uniq_tnt, count(distinct phone) uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and free='false' group by tran_dt, plan, plan_exp
   ) temp_table group by tran_dt, plan, plan_exp;

   insert into powerapp_brand_dailyrep
   select tran_dt, 'OPTOUT', sum(hits_pre), sum(hits_ppd), sum(hits_tnt), sum(hits_tot), sum(uniq_pre), sum(uniq_ppd), sum(uniq_tnt), sum(uniq_tot) from (
   select left(datein, 10) tran_dt, count(1) hits_pre, 0 hits_ppd, 0 hits_tnt, 0 hits_tot, 0 uniq_pre, 0 uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_optout_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='PREPAID' group by tran_dt union
   select left(datein, 10) tran_dt, 0 hits_pre, count(1) hits_ppd, 0 hits_tnt, 0 hits_tot, 0 uniq_pre, 0 uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_optout_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPAID' group by tran_dt union
   select left(datein, 10) tran_dt, 0 hits_pre, 0 hits_ppd, 0 hits_tnt, count(1) hits_tot, 0 uniq_pre, 0 uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_optout_log where datein >= p_date and datein < date_add(p_date, interval 1 day) group by tran_dt
   ) temp_table group by tran_dt;

   insert ignore powerapp_brand_dailyrep
   select p_date, plan, 0, 0, 0, 0, 0, 0, 0, 0 from powerapp_brand_expiry_dailyrep group by plan;

   insert ignore powerapp_brand_expiry_dailyrep
   select p_date, plan, plan_exp, 0, 0, 0, 0, 0, 0, 0, 0 from powerapp_brand_expiry_dailyrep group by plan, plan_exp;
END;
//

delimiter ;


DROP PROCEDURE `sp_generate_pwrapp_sun_stats`;
delimiter //

CREATE PROCEDURE sp_generate_pwrapp_sun_stats(p_trandate date)
begin
    if p_trandate is null then
       SET @tran_dt = date_sub(curdate(), interval 1 day);
       SET @tran_nw = curdate();
    else
       SET @tran_dt = p_trandate;
       SET @tran_nw = date_add(p_trandate, interval 1 day);
    end if;
    delete from powerapp_dailyrep where tran_dt = @tran_dt;
    delete from powerapp_validity_dailyrep where tran_dt = @tran_dt;
    delete from powerapp_hourlyrep where tran_dt = @tran_dt;

    select count(1), count(distinct phone) into @unli_hits,        @unli_uniq        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='UNLI';
    select count(1), count(distinct phone) into @email_hits,       @email_uniq       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL';
    select count(1), count(distinct phone) into @chat_hits,        @chat_uniq        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='CHAT';
    select count(1), count(distinct phone) into @photo_hits,       @photo_uniq       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO';
    select count(1), count(distinct phone) into @free_social_hits, @free_social_uniq from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='FREE_SOCIAL';
    select count(1), count(distinct phone) into @social_hits,      @social_uniq      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL';
    select count(1), count(distinct phone) into @facebook_hits,    @facebook_uniq    from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='FACEBOOK';
    select count(1), count(distinct phone) into @speed_hits,       @speed_uniq       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='SPEEDBOOST';
    select count(1), count(distinct phone) into @line_hits,        @line_uniq        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='LINE';
    select count(1), count(distinct phone) into @snap_hits,        @snap_uniq        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='SNAPCHAT';
    select count(1), count(distinct phone) into @tumblr_hits,      @tumblr_uniq      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='TUMBLR';
    select count(1), count(distinct phone) into @waze_hits,        @waze_uniq        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='WAZE';
    select count(1), count(distinct phone) into @wechat_hits,      @wechat_uniq      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT';
    select count(1), count(distinct phone) into @wiki_hits,        @wiki_uniq        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='WIKIPEDIA';
    select count(1), count(distinct phone) into @piso_hits,        @piso_uniq        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='PISONET';
    select count(1), count(distinct phone) into @school_hits,      @school_uniq      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='BACKTOSCHOOL';
    select count(1), count(distinct phone) into @coc_hits,         @coc_uniq         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='CLASHOFCLANS';
    select count(1), count(distinct phone) into @youtube_hits,     @youtube_uniq     from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='YOUTUBE';
    select count(1), count(distinct phone) into @total_hits,       @total_uniq       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false';

    insert ignore into powerapp_dailyrep (
            tran_dt, total_hits, total_uniq, piso_hits, piso_uniq, school_hits, school_uniq, coc_hits, coc_uniq, youtube_hits, youtube_uniq,
            unli_hits, email_hits, social_hits, photo_hits, chat_hits, speed_hits, line_hits, snap_hits, tumblr_hits, waze_hits, wechat_hits, wiki_hits, free_social_hits, facebook_hits,
            unli_uniq, email_uniq, social_uniq, photo_uniq, chat_uniq, speed_uniq, line_uniq, snap_uniq, tumblr_uniq, waze_uniq, wechat_uniq, wiki_uniq, free_social_uniq, facebook_uniq )
    values (@tran_dt, @total_hits, @total_uniq, @piso_hits, @piso_uniq, @school_hits, @school_uniq, @coc_hits, @coc_uniq, @youtube_hits, @youtube_uniq,
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
       SET @vNumOptout = 0;
    end if;

    if @tran_dt = last_day(@tran_dt) then
       select count(distinct phone)
       into  @NumUniq30d
       from powerapp_log
       where left(datein,7) = left(@tran_dt, 7);
    else
       select count(distinct phone)
       into  @NumUniq30d
       from powerapp_log
       where datein >= date_sub(@tran_dt, interval 30 day)
       and datein < @tran_nw;
    end if;

    update powerapp_dailyrep
    set    num_optout= IFNULL(@vNumOptout,0),
           concurrent_max_tm= IFNULL(@vTimeIn,'00:00'),
           concurrent_max_subs=IFNULL(@vNumSubs,0),
           concurrent_avg_subs=IFNULL(@vAvgSubs,0),
           num_uniq_30d=IFNULL(@NumUniq30d,0)
    where  tran_dt = @tran_dt;

    select count(1), count(distinct phone) into @unli_hits_3,         @unli_uniq_3          from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and validity<86400;
    select count(1), count(distinct phone) into @unli_hits_24,        @unli_uniq_24         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and brand = 'POSTPAID' and validity >=86400;
    select count(1), count(distinct phone) into @unli_hits_24_pp,     @unli_uniq_24_pp      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and brand = 'PREPAID'  and validity >=86400;
    select count(1), count(distinct phone) into @email_hits_3,        @email_uniq_3         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL' and validity<86400;
    select count(1), count(distinct phone) into @email_hits_24,       @email_uniq_24        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL' and validity >=86400;
    select count(1), count(distinct phone) into @chat_hits_3,         @chat_uniq_3          from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='CHAT' and validity<86400;
    select count(1), count(distinct phone) into @chat_hits_24,        @chat_uniq_24         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='CHAT' and validity >=86400;
    select count(1), count(distinct phone) into @photo_hits_3,        @photo_uniq_3         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity<86400;
    select count(1), count(distinct phone) into @photo_hits_24,       @photo_uniq_24        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity >=86400 and brand = 'POSTPAID';
    select count(1), count(distinct phone) into @photo_hits_24_pp,    @photo_uniq_24_pp     from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity >=86400 and brand = 'PREPAID'; 
    select count(1), count(distinct phone) into @social_hits_3,       @social_uniq_3        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity <86400;
    select count(1), count(distinct phone) into @social_hits_24,      @social_uniq_24       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity >=86400 and brand = 'POSTPAID';
    select count(1), count(distinct phone) into @social_hits_24_pp,   @social_uniq_24_pp    from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity >=86400 and brand = 'PREPAID'; 
    select count(1), count(distinct phone) into @speed_hits,          @speed_uniq           from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='SPEEDBOOST';
    select count(1), count(distinct phone) into @line_hits_24,        @line_uniq_24         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='LINE' and brand = 'POSTPAID';
    select count(1), count(distinct phone) into @line_hits_24_pp,     @line_uniq_24_pp      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='LINE' and brand = 'PREPAID'; 
    select count(1), count(distinct phone) into @snap_hits_24,        @snap_uniq_24         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='SNAPCHAT';
    select count(1), count(distinct phone) into @tumblr_hits_24,      @tumblr_uniq_24       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='TUMBLR';
    select count(1), count(distinct phone) into @waze_hits_24,        @waze_uniq_24         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='WAZE';
    select count(1), count(distinct phone) into @wechat_hits_24,      @wechat_uniq_24       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT' and brand = 'POSTPAID';
    select count(1), count(distinct phone) into @wechat_hits_24_pp,   @wechat_uniq_24_pp    from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT' and brand = 'PREPAID'; 
    select count(1), count(distinct phone) into @wiki_hits_24,        @wiki_uniq_24         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='WIKIPEDIA';
    select count(1), count(distinct phone) into @facebook_hits_24,    @facebook_uniq_24     from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='FACEBOOK';
    select count(1), count(distinct phone) into @free_social_hits_24, @free_social_uniq_24  from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='FREE_SOCIAL';
    select count(1), count(distinct phone) into @piso_hits_15,        @piso_uniq_15         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='PISONET' and validity <= 900;
    select count(1), count(distinct phone) into @school_hits_24,      @school_uniq_24       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='BACKTOSCHOOL';
    select count(1), count(distinct phone) into @coc_hits_24,         @coc_uniq_24          from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='CLASHOFCLANS';
    select count(1), count(distinct phone) into @youtube_hits_30,     @youtube_uniq_30      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='YOUTUBE';

    insert ignore into powerapp_validity_dailyrep
           (tran_dt,              total_hits,      total_uniq,
            unli_hits_3,          unli_uniq_3,
            unli_hits_24,         unli_uniq_24,
            unli_hits_24_pp,      unli_uniq_24_pp,
            email_hits_3,         email_hits_24,   email_uniq_3,   email_uniq_24,
            chat_hits_3,          chat_hits_24,    chat_uniq_3,    chat_uniq_24,
            photo_hits_3,         photo_uniq_3,
            photo_hits_24,        photo_uniq_24,
            photo_hits_24_pp,     photo_uniq_24_pp,
            social_hits_3,        social_uniq_3,
            social_hits_24,       social_uniq_24,
            social_hits_24_pp,    social_uniq_24_pp,
            speed_hits,           speed_uniq,
            line_hits_24,         line_uniq_24,
            line_hits_24_pp,      line_uniq_24_pp,
            snap_hits_24,         snap_uniq_24,
            tumblr_hits_24,       tumblr_uniq_24,
            waze_hits_24,         waze_uniq_24,
            wechat_hits_24,       wechat_uniq_24,
            wechat_hits_24_pp,    wechat_uniq_24_pp,
            wiki_hits_24,         wiki_uniq_24,
            facebook_hits_24,     facebook_uniq_24,
            free_social_hits_24,  free_social_uniq_24,
            piso_hits_15,         piso_uniq_15,
            school_hits_24,       school_uniq_24,
            coc_hits_24,          coc_uniq_24,
            youtube_hits_30,      youtube_uniq_30)
    values (@tran_dt,             @total_hits,     @total_uniq,
            @unli_hits_3,         @unli_uniq_3,
            @unli_hits_24,        @unli_uniq_24,
            @unli_hits_24_pp,     @unli_uniq_24_pp,
            @email_hits_3,        @email_hits_24,  @email_uniq_3,  @email_uniq_24,
            @chat_hits_3,         @chat_hits_24,   @chat_uniq_3,   @chat_uniq_24,
            @photo_hits_3,        @photo_uniq_3,
            @photo_hits_24,       @photo_uniq_24,
            @photo_hits_24_pp,    @photo_uniq_24_pp,
            @social_hits_3,       @social_uniq_3,
            @social_hits_24,      @social_uniq_24,
            @social_hits_24_pp,   @social_uniq_24_pp,
            @speed_hits,          @speed_uniq,
            @line_hits_24,        @line_uniq_24,
            @line_hits_24_pp,     @line_uniq_24_pp,
            @snap_hits_24,        @snap_uniq_24,
            @tumblr_hits_24,      @tumblr_uniq_24,
            @waze_hits_24,        @waze_uniq_24,
            @wechat_hits_24,      @wechat_uniq_24,
            @wechat_hits_24_pp,   @wechat_uniq_24_pp,
            @wiki_hits_24,        @wiki_uniq_24,
            @facebook_hits_24,    @facebook_uniq_24,
            @free_social_hits_24, @free_social_uniq_24,
            @piso_hits_15,        @piso_uniq_15,
            @school_hits_24,      @school_uniq_24,
            @coc_hits_24,         @coc_uniq_24,
            @youtube_hits_30,     @youtube_uniq_30);

   set @vCtr = 0;
   WHILE (@vCtr <= 23) DO

      select concat(lpad(@vCtr, 2, '0'), ':00:00') into @tran_tm;
      select 0, 0 into @unli_hits_3,         @unli_uniq_3;
      select 0, 0 into @unli_hits_24,        @unli_uniq_24;
      select 0, 0 into @unli_hits_24_pp,     @unli_uniq_24_pp;
      select 0, 0 into @email_hits_3,        @email_uniq_3;
      select 0, 0 into @email_hits_24,       @email_uniq_24;
      select 0, 0 into @chat_hits_3,         @chat_uniq_3;
      select 0, 0 into @chat_hits_24,        @chat_uniq_24;
      select 0, 0 into @photo_hits_3,        @photo_uniq_3;
      select 0, 0 into @photo_hits_24,       @photo_uniq_24;
      select 0, 0 into @photo_hits_24_pp,    @photo_uniq_24_pp;
      select 0, 0 into @social_hits_3,       @social_uniq_3;
      select 0, 0 into @social_hits_24,      @social_uniq_24;
      select 0, 0 into @social_hits_24_pp,   @social_uniq_24_pp;
      select 0, 0 into @speed_hits,          @speed_uniq;
      select 0, 0 into @line_hits_24,        @line_uniq_24;
      select 0, 0 into @line_hits_24_pp,     @line_uniq_24_pp;
      select 0, 0 into @snap_hits_24,        @snap_uniq_24;
      select 0, 0 into @tumblr_hits_24,      @tumblr_uniq_24;
      select 0, 0 into @waze_hits_24,        @waze_uniq_24;
      select 0, 0 into @wechat_hits_24,      @wechat_uniq_24;
      select 0, 0 into @wechat_hits_24_pp,   @wechat_uniq_24_pp;
      select 0, 0 into @wiki_hits_24,        @wiki_uniq_24;
      select 0, 0 into @facebook_hits_24,    @facebook_uniq_24;
      select 0, 0 into @free_social_hits_24, @free_social_uniq_24;
      select 0, 0 into @piso_hits_15,        @piso_uniq_15;
      select 0, 0 into @school_hits_24,      @school_uniq_24;
      select 0, 0 into @coc_hits_24,         @coc_uniq_24;
      select 0, 0 into @youtube_hits_30,     @youtube_uniq_30;


      select count(1), count(distinct phone) into @unli_hits_3,         @unli_uniq_3         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and validity<86400;
      select count(1), count(distinct phone) into @unli_hits_24,        @unli_uniq_24        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and brand = 'POSTPAID' and validity >=86400;
      select count(1), count(distinct phone) into @unli_hits_24_pp,     @unli_uniq_24_pp     from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and brand = 'PREPAID'  and validity >=86400;
      select count(1), count(distinct phone) into @email_hits_3,        @email_uniq_3        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity<86400;
      select count(1), count(distinct phone) into @email_hits_24,       @email_uniq_24       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity >=86400;
      select count(1), count(distinct phone) into @chat_hits_3,         @chat_uniq_3         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity<86400;
      select count(1), count(distinct phone) into @chat_hits_24,        @chat_uniq_24        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity >=86400;
      select count(1), count(distinct phone) into @photo_hits_3,        @photo_uniq_3        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity < 86400;
      select count(1), count(distinct phone) into @photo_hits_24,       @photo_uniq_24       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity >=86400 and brand = 'POSTPAID';
      select count(1), count(distinct phone) into @photo_hits_24_pp,    @photo_uniq_24_pp    from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity >=86400 and brand = 'PREPAID'; 
      select count(1), count(distinct phone) into @social_hits_3,       @social_uniq_3       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity < 86400;
      select count(1), count(distinct phone) into @social_hits_24,      @social_uniq_24      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity >=86400 and brand = 'POSTPAID';
      select count(1), count(distinct phone) into @social_hits_24_pp,   @social_uniq_24_pp   from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity >=86400 and brand = 'PREPAID'; 
      select count(1), count(distinct phone) into @piso_hits_15,        @piso_uniq_15        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PISONET' and validity <= 900;
      select count(1), count(distinct phone) into @speed_hits,          @speed_uniq          from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SPEEDBOOST';
      select count(1), count(distinct phone) into @line_hits_24,        @line_uniq_24        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='LINE' and brand = 'POSTPAID';
      select count(1), count(distinct phone) into @line_hits_24_pp,     @line_uniq_24_pp     from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='LINE' and brand = 'PREPAID'; 
      select count(1), count(distinct phone) into @snap_hits_24,        @snap_uniq_24        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SNAPCHAT';
      select count(1), count(distinct phone) into @tumblr_hits_24,      @tumblr_uniq_24      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='TUMBLR';
      select count(1), count(distinct phone) into @waze_hits_24,        @waze_uniq_24        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WAZE';
      select count(1), count(distinct phone) into @wechat_hits_24,      @wechat_uniq_24      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WECHAT' and brand = 'POSTPAID';
      select count(1), count(distinct phone) into @wechat_hits_24_pp,   @wechat_uniq_24_pp   from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WECHAT' and brand = 'PREPAID'; 
      select count(1), count(distinct phone) into @wiki_hits_24,        @wiki_uniq_24        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WIKIPEDIA';
      select count(1), count(distinct phone) into @facebook_hits_24,    @facebook_uniq_24    from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='FACEBOOK';
      select count(1), count(distinct phone) into @free_social_hits_24, @free_social_uniq_24 from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='FREE_SOCIAL';
      select count(1), count(distinct phone) into @school_hits_24,      @school_uniq_24      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='BACKTOSCHOOL';
      select count(1), count(distinct phone) into @coc_hits_24,         @coc_uniq_24         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CLASHOFCLANS';
      select count(1), count(distinct phone) into @youtube_hits_30,     @youtube_uniq_30     from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='YOUTUBE';
      select count(1), count(distinct phone) into @total_hits,          @total_uniq          from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false';
      SET @vCtr = @vCtr + 1;

      insert ignore into powerapp_hourlyrep
             (tran_dt,              tran_tm,         total_hits,     total_uniq,
              unli_hits_3,          unli_uniq_3,
              unli_hits_24,         unli_uniq_24,
              unli_hits_24_pp,      unli_uniq_24_pp,
              email_hits_3,         email_hits_24,   email_uniq_3,   email_uniq_24,
              chat_hits_3,          chat_hits_24,    chat_uniq_3,    chat_uniq_24,
              photo_hits_3,         photo_uniq_3,
              photo_hits_24,        photo_uniq_24,
              photo_hits_24_pp,     photo_uniq_24_pp,
              social_hits_3,        social_uniq_3,
              social_hits_24,       social_uniq_24,
              social_hits_24_pp,    social_uniq_24_pp,
              speed_hits,           speed_uniq,
              line_hits_24,         line_uniq_24,
              line_hits_24_pp,      line_uniq_24_pp,
              snap_hits_24,         snap_uniq_24,
              tumblr_hits_24,       tumblr_uniq_24,
              waze_hits_24,         waze_uniq_24,
              wechat_hits_24,       wechat_uniq_24,
              wechat_hits_24_pp,    wechat_uniq_24_pp,
              wiki_hits_24,         wiki_uniq_24,
              facebook_hits_24,     facebook_uniq_24,
              free_social_hits_24,  free_social_uniq_24,
              piso_hits_15,         piso_uniq_15,
              school_hits_24,       school_uniq_24,
              coc_hits_24,          coc_uniq_24,
              youtube_hits_30,      youtube_uniq_30)
      values (@tran_dt,             @tran_tm,        @total_hits,    @total_uniq,
              @unli_hits_3,         @unli_uniq_3,
              @unli_hits_24,        @unli_uniq_24,
              @unli_hits_24_pp,     @unli_uniq_24_pp,
              @email_hits_3,        @email_hits_24,  @email_uniq_3,  @email_uniq_24,
              @chat_hits_3,         @chat_hits_24,   @chat_uniq_3,   @chat_uniq_24,
              @photo_hits_3,        @photo_uniq_3,
              @photo_hits_24,       @photo_uniq_24,
              @photo_hits_24_pp,    @photo_uniq_24_pp,
              @social_hits_3,       @social_uniq_3,
              @social_hits_24,      @social_uniq_24,
              @social_hits_24_pp,   @social_uniq_24_pp,
              @speed_hits,          @speed_uniq,
              @line_hits_24,        @line_uniq_24,
              @line_hits_24_pp,     @line_uniq_24_pp,
              @snap_hits_24,        @snap_uniq_24,
              @tumblr_hits_24,      @tumblr_uniq_24,
              @waze_hits_24,        @waze_uniq_24,
              @wechat_hits_24,      @wechat_uniq_24,
              @wechat_hits_24_pp,   @wechat_uniq_24_pp,
              @wiki_hits_24,        @wiki_uniq_24,
              @facebook_hits_24,    @facebook_uniq_24,
              @free_social_hits_24, @free_social_uniq_24,
              @piso_hits_15,        @piso_uniq_15,
              @school_hits_24,      @school_uniq_24,
              @coc_hits_24,         @coc_uniq_24,
              @youtube_hits_30,     @youtube_uniq_30);
   END WHILE;
   call sp_generate_pwrapp_sun_brand_stats (@tran_dt);
END;
//
delimiter ;


GRANT EXECUTE ON PROCEDURE  sp_generate_pwrapp_sun_stats  TO 'stats'@'10.11.4.164';
flush privileges;

call sp_generate_pwrapp_sun_stats('2014-08-15');
call sp_generate_pwrapp_sun_stats('2014-08-16');
call sp_generate_pwrapp_sun_stats('2014-08-17');
call sp_generate_pwrapp_sun_stats('2014-08-18');
call sp_generate_pwrapp_sun_stats('2014-08-19');
call sp_generate_pwrapp_sun_stats('2014-08-20');
call sp_generate_pwrapp_sun_stats('2014-08-21');
call sp_generate_pwrapp_sun_stats('2014-08-22');
call sp_generate_pwrapp_sun_stats('2014-08-23');
call sp_generate_pwrapp_sun_stats('2014-08-24');
call sp_generate_pwrapp_sun_stats('2014-08-25');
call sp_generate_pwrapp_sun_stats('2014-08-26');
call sp_generate_pwrapp_sun_stats('2014-08-27');
call sp_generate_pwrapp_sun_stats('2014-08-28');
call sp_generate_pwrapp_sun_stats('2014-08-29');
call sp_generate_pwrapp_sun_stats('2014-08-30');
call sp_generate_pwrapp_sun_stats('2014-08-31');

call sp_generate_pwrapp_sun_stats('2014-09-01');
call sp_generate_pwrapp_sun_stats('2014-09-02');
call sp_generate_pwrapp_sun_stats('2014-09-03');
call sp_generate_pwrapp_sun_stats('2014-09-04');
call sp_generate_pwrapp_sun_stats('2014-09-05');
call sp_generate_pwrapp_sun_stats('2014-09-06');
call sp_generate_pwrapp_sun_stats('2014-09-07');
call sp_generate_pwrapp_sun_stats('2014-09-08');
call sp_generate_pwrapp_sun_stats('2014-09-09');
call sp_generate_pwrapp_sun_stats('2014-09-10');
call sp_generate_pwrapp_sun_stats('2014-09-11');
call sp_generate_pwrapp_sun_stats('2014-09-12');
call sp_generate_pwrapp_sun_stats('2014-09-13');
call sp_generate_pwrapp_sun_stats('2014-09-14');
call sp_generate_pwrapp_sun_stats('2014-09-17');
call sp_generate_pwrapp_sun_stats('2014-09-18');
call sp_generate_pwrapp_sun_stats('2014-09-19');
call sp_generate_pwrapp_sun_stats('2014-09-20');
call sp_generate_pwrapp_sun_stats('2014-09-21');

