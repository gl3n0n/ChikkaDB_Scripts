DROP PROCEDURE sp_regenerate_hi10_stats;

delimiter //
CREATE PROCEDURE sp_regenerate_hi10_stats(p_trandate date)
begin
    set session tmp_table_size = 268435456;
    set session max_heap_table_size = 268435456;
    set session sort_buffer_size = 104857600;
    set session read_buffer_size = 8388608;

    SET @tran_dt = p_trandate;
    SET @tran_nw = date_add(p_trandate, interval 1 day);
    delete from powerapp_dailyrep where tran_dt = @tran_dt;
    delete from powerapp_validity_dailyrep where tran_dt = @tran_dt;
    delete from powerapp_hourlyrep where tran_dt = @tran_dt;
    delete from buys_per_plan where datein = @tran_dt;

    insert into buys_per_plan (datein, service, no_buys)
    select left(a.datein,10) datein, b.service, count(1) no_buys from powerapp_log a, powerapp_plan_services_mapping b
    where a.plan=b.plan and a.datein >= @tran_dt and datein < @tran_nw group by 1,2;

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
    select count(1), count(distinct phone) into @youtube_hits,     @youtube_uniq     from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='YOUTUBE' and source <> 'facebook_bundled_youtube';
    select count(1), count(distinct phone) into @fy5_hits,         @fy5_uniq         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and plan='YOUTUBE' and source = 'facebook_bundled_youtube';
    select count(1), count(distinct phone) into @myvolume_hits,    @myvolume_uniq    from powerapp_log where datein >= @tran_dt and datein < @tran_nw and plan='MYVOLUME';

    select sum(IF(free='false',1,0)) into @total_hits from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false';
    select count(distinct phone) into @total_uniq from (
       select phone from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false'
       union
       select phone from powerapp_log where datein >= @tran_dt and datein < @tran_nw and plan='YOUTUBE' and source = 'facebook_bundled_youtube') t;

    select count(1), count(distinct phone) into @buddy_hits,       @buddy_uniq       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and brand='BUDDY';
    select count(1), count(distinct phone) into @postpd_hits,      @postpd_uniq      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and brand='POSTPD';
    select count(1), count(distinct phone) into @tnt_hits,         @tnt_uniq         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and brand='TNT';
    select count(1), count(distinct phone) into @sun_hits,         @sun_uniq         from powerapp_sun.powerapp_log where datein >= @tran_dt and datein < @tran_nw;

    -- LIBERATION AUTO-RENEWAL
    select count(distinct phone) into @tnt_auto_rn   from powerapp_log where datein >= @tran_dt and datein < @tran_nw and brand='TNT'   and plan = 'MYVOLUME' and source like 'auto%';
    select count(distinct phone) into @buddy_auto_rn from powerapp_log where datein >= @tran_dt and datein < @tran_nw and brand='BUDDY' and plan = 'MYVOLUME' and source like 'auto%';

    SET @total_hits = @total_hits + @fy5_hits + @myvolume_hits;
    insert ignore into powerapp_dailyrep (
            tran_dt, total_hits, total_uniq, piso_hits, piso_uniq, school_hits, school_uniq, coc_hits, coc_uniq, youtube_hits, youtube_uniq, fy5_hits, fy5_uniq, myvolume_hits, myvolume_uniq,
            unli_hits, email_hits, social_hits, photo_hits, chat_hits, speed_hits, line_hits, snap_hits, tumblr_hits, waze_hits, wechat_hits, wiki_hits, free_social_hits, facebook_hits,
            unli_uniq, email_uniq, social_uniq, photo_uniq, chat_uniq, speed_uniq, line_uniq, snap_uniq, tumblr_uniq, waze_uniq, wechat_uniq, wiki_uniq, free_social_uniq, facebook_uniq,
            buddy_hits, buddy_uniq, postpd_hits, postpd_uniq, tnt_hits, tnt_uniq, sun_hits, sun_uniq, tnt_auto_rn, buddy_auto_rn )
    values (@tran_dt, @total_hits, @total_uniq, @piso_hits, @piso_uniq, @school_hits, @school_uniq, @coc_hits, @coc_uniq, @youtube_hits, @youtube_uniq, @fy5_hits, @fy5_uniq, @myvolume_hits, @myvolume_uniq, 
            @unli_hits, @email_hits, @social_hits, @photo_hits, @chat_hits, @speed_hits, @line_hits, @snap_hits, @tumblr_hits, @waze_hits, @wechat_hits, @wiki_hits, @free_social_hits, @facebook_hits,
            @unli_uniq, @email_uniq, @social_uniq, @photo_uniq, @chat_uniq, @speed_uniq, @line_uniq, @snap_uniq, @tumblr_uniq, @waze_uniq, @wechat_uniq, @wiki_uniq, @free_social_uniq, @facebook_uniq,
            @buddy_hits, @buddy_uniq, @postpd_hits, @postpd_uniq, @tnt_hits, @tnt_uniq, @sun_hits, @sun_uniq, @tnt_auto_rn, @buddy_auto_rn);

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

    -- PREPAID, TNT, SUN      App Deals - 24hrs
    -- Photo 24hrs - P10      Facebook - P5    
    -- Email 24hrs - P10      SnapChat - P5    
    -- Social 24hrs - P10     Tumblr - P5      
    -- Chat 24hrs - P10       Wechat - P5      
    -- Unli 24hrs - P20       Line - P5        
    -- Back-to-school - P5    Waze - P5        
    -- Boost 15mins - P5      Wiki - Free      

    -- POSTPAID               PREPAID, TNT, SUN  
    -- Photo 24hrs  - P20     Photo 24hrs    - P10  
    -- Email 24hrs  - P10     Email 24hrs    - P10  
    -- Social 24hrs - P10     Social 24hrs   - P10 
    -- Chat 24hrs   - P10     Chat 24hrs     - P10   
    -- Unli 24hrs   - P20     Unli 24hrs     - P20   
    -- Boost 15mins - P5      Boost 15mins   - P5  
    -- Photo 3hrs   - P10       
    -- Email 3hrs   - P5        
    -- Social 3hrs  - P10      
    -- Chat 3hrs    - P5         
    -- Unli 3hrs    - P15     Back-to-school - P5

    select count(1), count(distinct phone) into @unli_hits_3,         @unli_uniq_3          from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and validity<86400;
    select count(1), count(distinct phone) into @unli_hits_24_pp,     @unli_uniq_24_pp      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and brand <> 'POSTPD' and validity >=86400;
    select count(1), count(distinct phone) into @unli_hits_24,        @unli_uniq_24         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and brand =  'POSTPD' and validity >=86400;

    select count(1), count(distinct phone) into @email_hits_3,        @email_uniq_3         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL' and validity < 86400;
    select count(1), count(distinct phone) into @email_hits_24,       @email_uniq_24        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL' and validity >=86400;
    select count(1), count(distinct phone) into @chat_hits_3,         @chat_uniq_3          from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='CHAT' and validity < 86400;
    select count(1), count(distinct phone) into @chat_hits_24,        @chat_uniq_24         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='CHAT' and validity >=86400;

    select count(1), count(distinct phone) into @photo_hits_3,        @photo_uniq_3         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity < 86400;
    select count(1), count(distinct phone) into @photo_hits_24,       @photo_uniq_24        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity >= 86400 and brand =  'POSTPD';
    select count(1), count(distinct phone) into @photo_hits_24_pp,    @photo_uniq_24_pp     from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity >= 86400 and brand <> 'POSTPD';

    select count(1), count(distinct phone) into @social_hits_3,       @social_uniq_3        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity < 86400;
    select count(1), count(distinct phone) into @social_hits_24,      @social_uniq_24       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity >= 86400 and brand =  'POSTPD';
    select count(1), count(distinct phone) into @social_hits_24_pp,   @social_uniq_24_pp    from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity >= 86400 and brand <> 'POSTPD';

    select count(1), count(distinct phone) into @speed_hits,          @speed_uniq           from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='SPEEDBOOST';
    select count(1), count(distinct phone) into @line_hits_24,        @line_uniq_24         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='LINE' and brand =  'POSTPD';
    select count(1), count(distinct phone) into @line_hits_24_pp,     @line_uniq_24_pp      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='LINE' and brand <> 'POSTPD';
    select count(1), count(distinct phone) into @snap_hits_24,        @snap_uniq_24         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='SNAPCHAT';
    select count(1), count(distinct phone) into @tumblr_hits_24,      @tumblr_uniq_24       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='TUMBLR';
    select count(1), count(distinct phone) into @waze_hits_24,        @waze_uniq_24         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='WAZE';
    select count(1), count(distinct phone) into @wechat_hits_24,      @wechat_uniq_24       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT' and brand =  'POSTPD';
    select count(1), count(distinct phone) into @wechat_hits_24_pp,   @wechat_uniq_24_pp    from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT' and brand <> 'POSTPD';
    select count(1), count(distinct phone) into @wiki_hits_24,        @wiki_uniq_24         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='WIKIPEDIA';
    select count(1), count(distinct phone) into @facebook_hits_24,    @facebook_uniq_24     from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='FACEBOOK';
    select count(1), count(distinct phone) into @free_social_hits_24, @free_social_uniq_24  from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='FREE_SOCIAL';
    select count(1), count(distinct phone) into @piso_hits_15,        @piso_uniq_15         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='PISONET' and validity <= 900;
    select count(1), count(distinct phone) into @school_hits_24,      @school_uniq_24       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='BACKTOSCHOOL';
    select count(1), count(distinct phone) into @coc_hits_24,         @coc_uniq_24          from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='CLASHOFCLANS';
    select count(1), count(distinct phone) into @youtube_hits_30,     @youtube_uniq_30      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='YOUTUBE';
    select count(1), count(distinct phone) into @youtube_hits_5,      @youtube_uniq_5       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='YOUTUBE' and validity = 1800  and source <> 'facebook_bundled_youtube';
    select count(1), count(distinct phone) into @youtube_hits_15,     @youtube_uniq_15      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='YOUTUBE' and validity = 7200  and source <> 'facebook_bundled_youtube';
    select count(1), count(distinct phone) into @youtube_hits_50,     @youtube_uniq_50      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='YOUTUBE' and validity = 18000 and source <> 'facebook_bundled_youtube';
    select count(1), count(distinct phone) into @youtube_hits_120,    @youtube_uniq_120     from powerapp_log where datein >= @tran_dt and datein < @tran_nw and free='false' and plan='YOUTUBE' and validity > 18000 and source <> 'facebook_bundled_youtube';
    select count(1), count(distinct phone) into @fy5_hits_5,          @fy5_uniq_5           from powerapp_log where datein >= @tran_dt and datein < @tran_nw and plan='YOUTUBE' and source = 'facebook_bundled_youtube';

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
            youtube_hits_30,      youtube_uniq_30,
            youtube_hits_5,       youtube_uniq_5,
            youtube_hits_15,      youtube_uniq_15,
            youtube_hits_50,      youtube_uniq_50,
            youtube_hits_120,     youtube_uniq_120,
            fy5_hits_5,           fy5_uniq_5)
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
            @youtube_hits_30,     @youtube_uniq_30,
            @youtube_hits_5,      @youtube_uniq_5,
            @youtube_hits_15,     @youtube_uniq_15,
            @youtube_hits_50,     @youtube_uniq_50,
            @youtube_hits_120,    @youtube_uniq_120,
            @fy5_hits_5,          @fy5_uniq_5);

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


      select count(1), count(distinct phone) into @unli_hits_3,         @unli_uniq_3         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and validity < 86400;
      select count(1), count(distinct phone) into @unli_hits_24,        @unli_uniq_24        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and brand =  'POSTPD' and validity >=86400;
      select count(1), count(distinct phone) into @unli_hits_24_pp,     @unli_uniq_24_pp     from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and brand <> 'POSTPD' and validity >=86400;
      select count(1), count(distinct phone) into @email_hits_3,        @email_uniq_3        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity<86400;
      select count(1), count(distinct phone) into @email_hits_24,       @email_uniq_24       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity >=86400;
      select count(1), count(distinct phone) into @chat_hits_3,         @chat_uniq_3         from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity<86400;
      select count(1), count(distinct phone) into @chat_hits_24,        @chat_uniq_24        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity >=86400;
      select count(1), count(distinct phone) into @photo_hits_3,        @photo_uniq_3        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity < 86400;
      select count(1), count(distinct phone) into @photo_hits_24,       @photo_uniq_24       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity >=86400 and brand =  'POSTPD';
      select count(1), count(distinct phone) into @photo_hits_24_pp,    @photo_uniq_24_pp    from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity >=86400 and brand <> 'POSTPD';
      select count(1), count(distinct phone) into @social_hits_3,       @social_uniq_3       from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity < 86400;
      select count(1), count(distinct phone) into @social_hits_24,      @social_uniq_24      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity >=86400 and brand =  'POSTPD';
      select count(1), count(distinct phone) into @social_hits_24_pp,   @social_uniq_24_pp   from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity >=86400 and brand <> 'POSTPD';
      select count(1), count(distinct phone) into @piso_hits_15,        @piso_uniq_15        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PISONET' and validity <= 900;
      select count(1), count(distinct phone) into @speed_hits,          @speed_uniq          from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SPEEDBOOST';
      select count(1), count(distinct phone) into @line_hits_24,        @line_uniq_24        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='LINE' and brand =  'POSTPD';
      select count(1), count(distinct phone) into @line_hits_24_pp,     @line_uniq_24_pp     from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='LINE' and brand <> 'POSTPD';
      select count(1), count(distinct phone) into @snap_hits_24,        @snap_uniq_24        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SNAPCHAT';
      select count(1), count(distinct phone) into @tumblr_hits_24,      @tumblr_uniq_24      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='TUMBLR';
      select count(1), count(distinct phone) into @waze_hits_24,        @waze_uniq_24        from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WAZE';
      select count(1), count(distinct phone) into @wechat_hits_24,      @wechat_uniq_24      from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WECHAT' and brand =  'POSTPD';
      select count(1), count(distinct phone) into @wechat_hits_24_pp,   @wechat_uniq_24_pp   from powerapp_log where datein >= @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WECHAT' and brand <> 'POSTPD';
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
END;
//

delimiter ;
GRANT EXECUTE ON PROCEDURE  sp_regenerate_hi10_stats  TO 'stats'@'10.11.4.164';
GRANT EXECUTE ON PROCEDURE  sp_generate_month_days    TO 'stats'@'10.11.4.164';
flush privileges;

drop procedure sp_generate_month_days;
delimiter //

create procedure sp_generate_month_days (p_trandate date)
begin
  declare dStart date;
  -- create table if not exists tmp_month_days (tx_date date, primary key (tx_date));
  -- delete from tmp_month_days;
  set dStart = concat(left(p_trandate,8),'01');
  set @nCtr  = 0;
  set @nDays = datediff(last_day(p_trandate), dStart)+1;
  while (@nCtr < @nDays)
  do
     if date_add(dStart, interval @nCtr day) <= curdate() then
        insert ignore into tmp_month_days values (date_add(dStart, interval @nCtr day));      
        set @nCtr = @nCtr + 1;
     else
        set @nCtr = @nDays + 1;
     end if;
  end while;
end;
//
delimiter ;



GRANT EXECUTE ON PROCEDURE  sp_generate_month_days    TO 'stats'@'10.11.4.164';
flush privileges;

call sp_generate_month_days(curdate());



create table tmp_powerapp_dailyrep          as select * from powerapp_dailyrep;
create table tmp_powerapp_validity_dailyrep as select * from powerapp_validity_dailyrep;
create table tmp_powerapp_hourlyrep         as select * from powerapp_hourlyrep;
select '0000-00-00' into @tran_dt;

select '2014-06-03' into @tran_dt;
delete from powerapp_dailyrep where tran_dt = @tran_dt;
delete from powerapp_validity_dailyrep where tran_dt = @tran_dt;
delete from powerapp_hourlyrep where tran_dt = @tran_dt;
insert into powerapp_dailyrep select * from tmp_powerapp_dailyrep where tran_dt = @tran_dt;
insert into powerapp_validity_dailyrep select * from tmp_powerapp_validity_dailyrep where tran_dt = @tran_dt;
insert into powerapp_hourlyrep select * from tmp_powerapp_hourlyrep where tran_dt = @tran_dt;

call sp_regenerate_hi10_stats('2014-06-03');

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
