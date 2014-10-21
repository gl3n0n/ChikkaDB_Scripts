delimiter //
drop procedure if exists sp_generate_ctm_stats//

create procedure sp_generate_ctm_stats (p_datein varchar(10)) 
begin
   DECLARE vDatein Varchar(10);
   DECLARE nCtr int;
   SELECT date_format(p_datein, '%Y-%m-%d') INTO vDatein;
   IF vDatein is null THEN
      SELECT "Please enter p_datein in format 'YYYY-MM-DD'" as 'Error Message', max(tran_dt) AS 'Latest CTM STATS is as of'
      FROM ctm_stats;
   ELSE
      SELECT count(1) 
      INTO nCtr 
      FROM ctm_stats 
      WHERE tran_dt = vDatein;

      IF nCtr > 0 THEN
         SELECT concat('CTM stats for ', vDatein, ' already exists!') as 'Error Message', max(tran_dt) AS 'Latest CTM STATS is as of'
         FROM ctm_stats;
      ELSE
         insert into ctm_stats (tran_dt, tran_tm, hits_globe_pre, hits_globe_post, hits_smart_8266_pre, hits_smart_8266_post, hits_smart_8267_pre, hits_smart_8267_post, hits_sun_pre, hits_sun_post, mo_globe_pre, mo_globe_post, mo_smart_pre, mo_smart_post, mo_sun_pre, mo_sun_post, mt_globe_pre, mt_globe_post, mt_smart_pre, mt_smart_post, mt_sun_pre, mt_sun_post, ukmo_globe_pre, ukmo_globe_post, ukmo_smart_pre, ukmo_smart_post, ukmo_sun_pre, ukmo_sun_post, ukmt_globe_pre, ukmt_globe_post, ukmt_smart_pre, ukmt_smart_post, ukmt_sun_pre, ukmt_sun_post)
         select tran_dt, '00:00' tran_tm, sum(hits_globe_pre), sum(hits_globe_post), sum(hits_smart_8266_pre), sum(hits_smart_8266_post), sum(hits_smart_8267_pre), sum(hits_smart_8267_post), sum(hits_sun_pre), sum(hits_sun_post), sum(mo_globe_pre), sum(mo_globe_post), sum(mo_smart_pre), sum(mo_smart_post), sum(mo_sun_pre), sum(mo_sun_post), sum(mt_globe_pre), sum(mt_globe_post), sum(mt_smart_pre), sum(mt_smart_post), sum(mt_sun_pre), sum(mt_sun_post), sum(ukmo_globe_pre) ukmo_globe_pre, sum(ukmo_globe_post) ukmo_globe_post, sum(ukmo_smart_pre) ukmo_smart_pre, sum(ukmo_smart_post) ukmo_smart_post, sum(ukmo_sun_pre) ukmo_sun_pre, sum(ukmo_sun_post) ukmo_sun_post, sum(ukmt_globe_pre) ukmt_globe_pre, sum(ukmt_globe_post) ukmt_globe_post, sum(ukmt_smart_pre) ukmt_smart_pre, sum(ukmt_smart_post) ukmt_smart_post, sum(ukmt_sun_pre) ukmt_sun_pre, sum(ukmt_sun_post) ukmt_sun_post
         from (
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, sum(pre) hits_sun_pre, sum(post) hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'sun' and type = 'hits'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all 
         select tran_dt, tran_tm, sum(pre) hits_globe_pre, sum(post) hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'globe' and type = 'hits'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all 
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, sum(pre) hits_smart_8266_pre, sum(post) hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'smart8266' and type = 'hits'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all 
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, sum(pre) hits_smart_8267_pre, sum(post) hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'smart8267' and type = 'hits'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all 
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, sum(pre) mt_globe_pre, sum(post) mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'globe' and type = 'mt'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all 
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, sum(pre) mt_smart_pre, sum(post) mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'smart' and type = 'mt'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all 
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, sum(pre)  mt_sun_pre, sum(post) mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'sun' and type = 'mt'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all 
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, sum(pre) mo_globe_pre, sum(post) mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'globe' and type = 'mo'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all 
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, sum(pre) mo_smart_pre, sum(post) mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'smart' and type = 'mo'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all 
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, sum(pre) mo_sun_pre, sum(post) mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'sun' and type = 'mo'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all 
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, sum(pre) ukmo_globe_pre, sum(post) ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'globe' and type = 'ukmo'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all 
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, sum(pre) ukmo_smart_pre, sum(post) ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'smart' and type = 'ukmo'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all 
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, sum(pre) ukmo_sun_pre, sum(post) ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'sun' and type = 'ukmo'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all 
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, sum(pre) ukmt_globe_pre, sum(post) ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'globe' and type = 'ukmt'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all 
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, sum(pre) ukmt_smart_pre, sum(post) ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'smart' and type = 'ukmt'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         union all 
         select tran_dt, tran_tm, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, sum(pre) ukmt_sun_pre, sum(post) ukmt_sun_post
         from ctm_stats_dtl
         where carrier = 'sun' and type = 'ukmt'
         and   tran_dt = p_datein
         group  by tran_dt, tran_tm
         ) tab1
         group  by tran_dt;
      END IF;
   END IF;
end;
//

delimiter ;
