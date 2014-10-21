DROP PROCEDURE sp_regenerate_hi10_stats_hh;
delimiter //
CREATE PROCEDURE sp_regenerate_hi10_stats_hh(p_trandate date)
begin
   SET @tran_dt = p_trandate;
   SET @tran_nw = date_add(@tran_dt, interval 1 day);
   DELETE FROM powerapp_hourlyrep WHERE tran_dt = @tran_dt;

   set @vCtr = 0;
   WHILE (@vCtr <= 23) DO

      select concat(lpad(@vCtr, 2, '0'), ':00:00') into @tran_tm;
      select 0, 0 into @unli_hits_3,          @unli_uniq_3;
      select 0, 0 into @unli_hits_24,         @unli_uniq_24;
      select 0, 0 into @email_hits_3,         @email_uniq_3;
      select 0, 0 into @email_hits_24,        @email_uniq_24;
      select 0, 0 into @chat_hits_3,          @chat_uniq_3;
      select 0, 0 into @chat_hits_24,         @chat_uniq_24;
      select 0, 0 into @photo_hits_3,         @photo_uniq_3;
      select 0, 0 into @photo_hits_24,        @photo_uniq_24;
      select 0, 0 into @social_hits_3,        @social_uniq_3;
      select 0, 0 into @social_hits_24,       @social_uniq_24;
      select 0, 0 into @speed_hits,           @speed_uniq;
      select 0, 0 into @line_hits_24,         @line_uniq_24;
      select 0, 0 into @snap_hits_24,         @snap_uniq_24;
      select 0, 0 into @tumblr_hits_24,       @tumblr_uniq_24;
      select 0, 0 into @waze_hits_24,         @waze_uniq_24;
      select 0, 0 into @wechat_hits_24,       @wechat_uniq_24;
      select 0, 0 into @facebook_hits_24,     @facebook_uniq_24;
      select 0, 0 into @wiki_hits_24,         @wiki_uniq_24;
      select 0, 0 into @free_social_hits_24,  @free_social_uniq_24;


      select count(1), count(distinct phone) into @unli_hits_3,           @unli_uniq_3         from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and validity<86400;
      select count(1), count(distinct phone) into @unli_hits_24,          @unli_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and validity >=86400;
      select count(1), count(distinct phone) into @email_hits_3,          @email_uniq_3        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity<86400;
      select count(1), count(distinct phone) into @email_hits_24,         @email_uniq_24       from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity >=86400;
      select count(1), count(distinct phone) into @chat_hits_3,           @chat_uniq_3         from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity<86400;
      select count(1), count(distinct phone) into @chat_hits_24,          @chat_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity >=86400;
      select count(1), count(distinct phone) into @photo_hits_3,          @photo_uniq_3        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity<86400;
      select count(1), count(distinct phone) into @photo_hits_24,         @photo_uniq_24       from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity >=86400;
      select count(1), count(distinct phone) into @social_hits_3,         @social_uniq_3       from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity <86400;
      select count(1), count(distinct phone) into @social_hits_24,        @social_uniq_24      from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity >=86400;
      select count(1), count(distinct phone) into @speed_hits,            @speed_uniq          from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SPEEDBOOST';
      select count(1), count(distinct phone) into @line_hits_24,          @line_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='LINE';
      select count(1), count(distinct phone) into @snap_hits_24,          @snap_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SNAPCHAT';
      select count(1), count(distinct phone) into @tumblr_hits_24,        @tumblr_uniq_24      from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='TUMBLR';
      select count(1), count(distinct phone) into @waze_hits_24,          @waze_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WAZE';
      select count(1), count(distinct phone) into @wechat_hits_24,        @wechat_uniq_24      from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WECHAT';
      select count(1), count(distinct phone) into @facebook_hits_24,      @facebook_uniq_24    from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='FACEBOOK';
      select count(1), count(distinct phone) into @wiki_hits_24,          @wiki_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WIKIPEDIA';
      select count(1), count(distinct phone) into @free_social_hits_24,   @free_social_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='FREE_SOCIAL';
      select count(1), count(distinct phone) into @total_hits,            @total_uniq          from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false';
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
              facebook_hits_24,     facebook_uniq_24,
              wiki_hits_24,         wiki_uniq_24,
              free_social_hits_24, free_social_uniq_24)
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
              @facebook_hits_24,    @facebook_uniq_24,
              @wiki_hits_24,        @wiki_uniq_24,
              @free_social_hits_24, @free_social_uniq_24);
   END WHILE;

   BEGIN
      DECLARE vPlan varchar(30);
      DECLARE done_p int default 0;
      DECLARE plan_c cursor for SELECT plan FROM
         (select 'UNLI'        as plan union
          select 'EMAIL'       as plan union
          select 'CHAT'        as plan union
          select 'PHOTO'       as plan union
          select 'SOCIAL'      as plan union
          select 'SPEEDBOOST'  as plan union
          select 'LINE'        as plan union
          select 'SNAPCHAT'    as plan union
          select 'TUMBLR'      as plan union
          select 'WAZE'        as plan union
          select 'WECHAT'      as plan union
          select 'FACEBOOK'    as plan union
          select 'WIKIPEDIA'   as plan union
          select 'FREE_SOCIAL' as plan) as t;
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
