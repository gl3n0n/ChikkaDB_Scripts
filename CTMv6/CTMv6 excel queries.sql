CREATE VIEW ctmv6_carrier_stats AS 
select tran_dt AS tran_dt, 
       'globe' AS carrier, 
       sum(hits_total) AS hits_total, 
       sum(hits_post) AS hits_post, 
       sum(hits_pre) AS hits_pre, 
       sum(hits_tm_tnt) AS hits_tm_tnt, 
       sum(hits_tat_bro) AS hits_tat_bro, 
       sum(uniq_total) AS uniq_total, 
       sum(uniq_post) AS uniq_post, 
       sum(uniq_pre) AS uniq_pre, 
       sum(uniq_tm_tnt) AS uniq_tm_tnt, 
       sum(uniq_tat_bro) AS uniq_tat_bro, 
       sum(free_total) AS free_total, 
       sum(free_post) AS free_post, 
       sum(free_pre) AS free_pre, 
       sum(free_tm_tnt) AS free_tm_tnt, 
       sum(free_tat_bro) AS free_tat_bro, 
       sum(reg_total) AS reg_total, 
       sum(reg_post) AS reg_post, 
       sum(reg_pre) AS reg_pre, 
       sum(reg_tm_tnt) AS reg_tm_tnt, 
       sum(reg_tat_bro) AS reg_tat_bro, 
       sum(regm_total) AS regm_total, 
       sum(regm_post) AS regm_post, 
       sum(regm_pre) AS regm_pre, 
       sum(regm_tm_tnt) AS regm_tm_tnt, 
       sum(regm_tat_bro) AS regm_tat_bro, 
       sum(uniq_nonreg) AS uniq_nonreg 
from   ctmv6_globe_log 
group by tran_dt 
union 
select tran_dt AS tran_dt, 
       'smart' AS carrier, 
       sum(hits_total) AS hits_total, 
       sum(hits_post) AS hits_post, 
       sum(hits_pre) AS hits_pre, 
       sum(hits_tm_tnt) AS hits_tm_tnt, 
       sum(hits_tat_bro) AS hits_tat_bro, 
       sum(uniq_total) AS uniq_total, 
       sum(uniq_post) AS uniq_post, 
       sum(uniq_pre) AS uniq_pre, 
       sum(uniq_tm_tnt) AS uniq_tm_tnt, 
       sum(uniq_tat_bro) AS uniq_tat_bro, 
       sum(free_total) AS free_total, 
       sum(free_post) AS free_post, 
       sum(free_pre) AS free_pre, 
       sum(free_tm_tnt) AS free_tm_tnt, 
       sum(free_tat_bro) AS free_tat_bro, 
       sum(reg_total) AS reg_total, 
       sum(reg_post) AS reg_post, 
       sum(reg_pre) AS reg_pre, 
       sum(reg_tm_tnt) AS reg_tm_tnt, 
       sum(reg_tat_bro) AS reg_tat_bro, 
       sum(regm_total) AS regm_total, 
       sum(regm_post) AS regm_post, 
       sum(regm_pre) AS regm_pre, 
       sum(regm_tm_tnt) AS regm_tm_tnt, 
       sum(regm_tat_bro) AS regm_tat_bro, 
       sum(uniq_nonreg) AS uniq_nonreg 
from   ctmv6_smart_log 
group by tran_dt 
union 
select tran_dt AS tran_dt, 
       'sun' AS carrier, 
       sum(hits_total) AS hits_total, 
       sum(hits_post) AS hits_post, 
       sum(hits_pre) AS hits_pre, 
       sum(hits_tm_tnt) AS hits_tm_tnt, 
       sum(hits_tat_bro) AS hits_tat_bro, 
       sum(uniq_total) AS uniq_total, 
       sum(uniq_post) AS uniq_post, 
       sum(uniq_pre) AS uniq_pre, 
       sum(uniq_tm_tnt) AS uniq_tm_tnt, 
       sum(uniq_tat_bro) AS uniq_tat_bro, 
       sum(free_total) AS free_total, 
       sum(free_post) AS free_post, 
       sum(free_pre) AS free_pre, 
       sum(free_tm_tnt) AS free_tm_tnt, 
       sum(free_tat_bro) AS free_tat_bro, 
       sum(reg_total) AS reg_total, 
       sum(reg_post) AS reg_post, 
       sum(reg_pre) AS reg_pre, 
       sum(reg_tm_tnt) AS reg_tm_tnt, 
       sum(reg_tat_bro) AS reg_tat_bro, 
       sum(regm_total) AS regm_total, 
       sum(regm_post) AS regm_post, 
       sum(regm_pre) AS regm_pre, 
       sum(regm_tm_tnt) AS regm_tm_tnt, 
       sum(regm_tat_bro) AS regm_tat_bro, 
       sum(uniq_nonreg) AS uniq_nonreg 
from   ctmv6_sun_log 
group by tran_dt;


CREATE VIEW ctmv6_globe_log AS 
select tran_dt AS tran_dt, total AS hits_total, post AS hits_post, pre AS hits_pre, tm_tnt AS hits_tm_tnt, tat_bro AS hits_tat_bro, 0 AS uniq_total, 0 AS uniq_post, 0 AS uniq_pre, 0 AS uniq_tm_tnt, 0 AS uniq_tat_bro, 0 AS free_total, 0 AS free_post, 0 AS free_pre, 0 AS free_tm_tnt, 0 AS free_tat_bro, 0 AS reg_total, 0 AS reg_post, 0 AS reg_pre, 0 AS reg_tm_tnt, 0 AS reg_tat_bro, 0 AS regm_total, 0 AS regm_post, 0 AS regm_pre, 0 AS regm_tm_tnt, 0 AS regm_tat_bro, 0 AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'globe') and (type = 'hits')) union 
select tran_dt AS tran_dt, 0 AS hits_total, 0 AS hits_post, 0 AS hits_pre, 0 AS hits_tm_tnt, 0 AS hits_tat_bro, total AS uniq_total, post AS uniq_post, pre AS uniq_pre, tm_tnt AS uniq_tm_tnt, tat_bro AS uniq_tat_bro, 0 AS free_total, 0 AS free_post, 0 AS free_pre, 0 AS free_tm_tnt, 0 AS free_tat_bro, 0 AS reg_total, 0 AS reg_post, 0 AS reg_pre, 0 AS reg_tm_tnt, 0 AS reg_tat_bro, 0 AS regm_total, 0 AS regm_post, 0 AS regm_pre, 0 AS regm_tm_tnt, 0 AS regm_tat_bro, 0 AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'globe') and (type = 'uniq_charged')) union 
select tran_dt AS tran_dt, 0 AS hits_total, 0 AS hits_post, 0 AS hits_pre, 0 AS hits_tm_tnt, 0 AS hits_tat_bro, 0 AS uniq_total, 0 AS uniq_post, 0 AS uniq_pre, 0 AS uniq_tm_tnt, 0 AS uniq_tat_bro, total AS free_total, post AS free_post, pre AS free_pre, tm_tnt AS free_tm_tnt, tat_bro AS free_tat_bro, 0 AS reg_total, 0 AS reg_post, 0 AS reg_pre, 0 AS reg_tm_tnt, 0 AS reg_tat_bro, 0 AS regm_total, 0 AS regm_post, 0 AS regm_pre, 0 AS regm_tm_tnt, 0 AS regm_tat_bro, 0 AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'globe') and (type = 'mt')) union 
select tran_dt AS tran_dt, 0 AS hits_total, 0 AS hits_post, 0 AS hits_pre, 0 AS hits_tm_tnt, 0 AS hits_tat_bro, 0 AS uniq_total, 0 AS uniq_post, 0 AS uniq_pre, 0 AS uniq_tm_tnt, 0 AS uniq_tat_bro, 0 AS free_total, 0 AS free_post, 0 AS free_pre, 0 AS free_tm_tnt, 0 AS free_tat_bro, total AS reg_total, post AS reg_post, pre AS reg_pre, tm_tnt AS reg_tm_tnt, tat_bro AS reg_tat_bro, 0 AS regm_total, 0 AS regm_post, 0 AS regm_pre, 0 AS regm_tm_tnt, 0 AS regm_tat_bro, 0 AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'globe') and (type = 'reg_carrier')) union 
select tran_dt AS tran_dt, 0 AS hits_total, 0 AS hits_post, 0 AS hits_pre, 0 AS hits_tm_tnt, 0 AS hits_tat_bro, 0 AS uniq_total, 0 AS uniq_post, 0 AS uniq_pre, 0 AS uniq_tm_tnt, 0 AS uniq_tat_bro, 0 AS free_total, 0 AS free_post, 0 AS free_pre, 0 AS free_tm_tnt, 0 AS free_tat_bro, 0 AS reg_total, 0 AS reg_post, 0 AS reg_pre, 0 AS reg_tm_tnt, 0 AS reg_tat_bro, total AS regm_total, post AS regm_post, pre AS regm_pre, tm_tnt AS regm_tm_tnt, tat_bro AS regm_tat_bro, 0 AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'globe') and (type = 'reg_mig')) union 
select tran_dt AS tran_dt, 0 AS hits_total, 0 AS hits_post, 0 AS hits_pre, 0 AS hits_tm_tnt, 0 AS hits_tat_bro, 0 AS uniq_total, 0 AS uniq_post, 0 AS uniq_pre, 0 AS uniq_tm_tnt, 0 AS uniq_tat_bro, 0 AS free_total, 0 AS free_post, 0 AS free_pre, 0 AS free_tm_tnt, 0 AS free_tat_bro, 0 AS reg_total, 0 AS reg_post, 0 AS reg_pre, 0 AS reg_tm_tnt, 0 AS reg_tat_bro, 0 AS regm_total, 0 AS regm_post, 0 AS regm_pre, 0 AS regm_tm_tnt, 0 AS regm_tat_bro, total AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'globe') and (type = 'uniq_nonreg'));

CREATE VIEW ctmv6_smart_log AS 
select tran_dt AS tran_dt, total AS hits_total, post AS hits_post, pre AS hits_pre, tm_tnt AS hits_tm_tnt, tat_bro AS hits_tat_bro, 0 AS uniq_total, 0 AS uniq_post, 0 AS uniq_pre, 0 AS uniq_tm_tnt, 0 AS uniq_tat_bro, 0 AS free_total, 0 AS free_post, 0 AS free_pre, 0 AS free_tm_tnt, 0 AS free_tat_bro, 0 AS reg_total, 0 AS reg_post, 0 AS reg_pre, 0 AS reg_tm_tnt, 0 AS reg_tat_bro, 0 AS regm_total, 0 AS regm_post, 0 AS regm_pre, 0 AS regm_tm_tnt, 0 AS regm_tat_bro, 0 AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'smart') and (type = 'hits')) union 
select tran_dt AS tran_dt, 0 AS hits_total, 0 AS hits_post, 0 AS hits_pre, 0 AS hits_tm_tnt, 0 AS hits_tat_bro, total AS uniq_total, post AS uniq_post, pre AS uniq_pre, tm_tnt AS uniq_tm_tnt, tat_bro AS uniq_tat_bro, 0 AS free_total, 0 AS free_post, 0 AS free_pre, 0 AS free_tm_tnt, 0 AS free_tat_bro, 0 AS reg_total, 0 AS reg_post, 0 AS reg_pre, 0 AS reg_tm_tnt, 0 AS reg_tat_bro, 0 AS regm_total, 0 AS regm_post, 0 AS regm_pre, 0 AS regm_tm_tnt, 0 AS regm_tat_bro, 0 AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'smart') and (type = 'uniq_charged')) union 
select tran_dt AS tran_dt, 0 AS hits_total, 0 AS hits_post, 0 AS hits_pre, 0 AS hits_tm_tnt, 0 AS hits_tat_bro, 0 AS uniq_total, 0 AS uniq_post, 0 AS uniq_pre, 0 AS uniq_tm_tnt, 0 AS uniq_tat_bro, total AS free_total, post AS free_post, pre AS free_pre, tm_tnt AS free_tm_tnt, tat_bro AS free_tat_bro, 0 AS reg_total, 0 AS reg_post, 0 AS reg_pre, 0 AS reg_tm_tnt, 0 AS reg_tat_bro, 0 AS regm_total, 0 AS regm_post, 0 AS regm_pre, 0 AS regm_tm_tnt, 0 AS regm_tat_bro, 0 AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'smart') and (type = 'mt')) union 
select tran_dt AS tran_dt, 0 AS hits_total, 0 AS hits_post, 0 AS hits_pre, 0 AS hits_tm_tnt, 0 AS hits_tat_bro, 0 AS uniq_total, 0 AS uniq_post, 0 AS uniq_pre, 0 AS uniq_tm_tnt, 0 AS uniq_tat_bro, 0 AS free_total, 0 AS free_post, 0 AS free_pre, 0 AS free_tm_tnt, 0 AS free_tat_bro, total AS reg_total, post AS reg_post, pre AS reg_pre, tm_tnt AS reg_tm_tnt, tat_bro AS reg_tat_bro, 0 AS regm_total, 0 AS regm_post, 0 AS regm_pre, 0 AS regm_tm_tnt, 0 AS regm_tat_bro, 0 AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'smart') and (type = 'reg_carrier')) union 
select tran_dt AS tran_dt, 0 AS hits_total, 0 AS hits_post, 0 AS hits_pre, 0 AS hits_tm_tnt, 0 AS hits_tat_bro, 0 AS uniq_total, 0 AS uniq_post, 0 AS uniq_pre, 0 AS uniq_tm_tnt, 0 AS uniq_tat_bro, 0 AS free_total, 0 AS free_post, 0 AS free_pre, 0 AS free_tm_tnt, 0 AS free_tat_bro, 0 AS reg_total, 0 AS reg_post, 0 AS reg_pre, 0 AS reg_tm_tnt, 0 AS reg_tat_bro, total AS regm_total, post AS regm_post, pre AS regm_pre, tm_tnt AS regm_tm_tnt, tat_bro AS regm_tat_bro, 0 AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'smart') and (type = 'reg_mig')) union 
select tran_dt AS tran_dt, 0 AS hits_total, 0 AS hits_post, 0 AS hits_pre, 0 AS hits_tm_tnt, 0 AS hits_tat_bro, 0 AS uniq_total, 0 AS uniq_post, 0 AS uniq_pre, 0 AS uniq_tm_tnt, 0 AS uniq_tat_bro, 0 AS free_total, 0 AS free_post, 0 AS free_pre, 0 AS free_tm_tnt, 0 AS free_tat_bro, 0 AS reg_total, 0 AS reg_post, 0 AS reg_pre, 0 AS reg_tm_tnt, 0 AS reg_tat_bro, 0 AS regm_total, 0 AS regm_post, 0 AS regm_pre, 0 AS regm_tm_tnt, 0 AS regm_tat_bro, total AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'smart') and (type = 'uniq_nonreg'));

CREATE VIEW ctmv6_sun_log AS 
select tran_dt AS tran_dt, total AS hits_total, post AS hits_post, pre AS hits_pre, tm_tnt AS hits_tm_tnt, tat_bro AS hits_tat_bro, 0 AS uniq_total, 0 AS uniq_post, 0 AS uniq_pre, 0 AS uniq_tm_tnt, 0 AS uniq_tat_bro, 0 AS free_total, 0 AS free_post, 0 AS free_pre, 0 AS free_tm_tnt, 0 AS free_tat_bro, 0 AS reg_total, 0 AS reg_post, 0 AS reg_pre, 0 AS reg_tm_tnt, 0 AS reg_tat_bro, 0 AS regm_total, 0 AS regm_post, 0 AS regm_pre, 0 AS regm_tm_tnt, 0 AS regm_tat_bro, 0 AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'sun') and (type = 'hits')) union 
select tran_dt AS tran_dt, 0 AS hits_total, 0 AS hits_post, 0 AS hits_pre, 0 AS hits_tm_tnt, 0 AS hits_tat_bro, total AS uniq_total, post AS uniq_post, pre AS uniq_pre, tm_tnt AS uniq_tm_tnt, tat_bro AS uniq_tat_bro, 0 AS free_total, 0 AS free_post, 0 AS free_pre, 0 AS free_tm_tnt, 0 AS free_tat_bro, 0 AS reg_total, 0 AS reg_post, 0 AS reg_pre, 0 AS reg_tm_tnt, 0 AS reg_tat_bro, 0 AS regm_total, 0 AS regm_post, 0 AS regm_pre, 0 AS regm_tm_tnt, 0 AS regm_tat_bro, 0 AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'sun') and (type = 'uniq_charged')) union 
select tran_dt AS tran_dt, 0 AS hits_total, 0 AS hits_post, 0 AS hits_pre, 0 AS hits_tm_tnt, 0 AS hits_tat_bro, 0 AS uniq_total, 0 AS uniq_post, 0 AS uniq_pre, 0 AS uniq_tm_tnt, 0 AS uniq_tat_bro, total AS free_total, post AS free_post, pre AS free_pre, tm_tnt AS free_tm_tnt, tat_bro AS free_tat_bro, 0 AS reg_total, 0 AS reg_post, 0 AS reg_pre, 0 AS reg_tm_tnt, 0 AS reg_tat_bro, 0 AS regm_total, 0 AS regm_post, 0 AS regm_pre, 0 AS regm_tm_tnt, 0 AS regm_tat_bro, 0 AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'sun') and (type = 'mt')) union 
select tran_dt AS tran_dt, 0 AS hits_total, 0 AS hits_post, 0 AS hits_pre, 0 AS hits_tm_tnt, 0 AS hits_tat_bro, 0 AS uniq_total, 0 AS uniq_post, 0 AS uniq_pre, 0 AS uniq_tm_tnt, 0 AS uniq_tat_bro, 0 AS free_total, 0 AS free_post, 0 AS free_pre, 0 AS free_tm_tnt, 0 AS free_tat_bro, total AS reg_total, post AS reg_post, pre AS reg_pre, tm_tnt AS reg_tm_tnt, tat_bro AS reg_tat_bro, 0 AS regm_total, 0 AS regm_post, 0 AS regm_pre, 0 AS regm_tm_tnt, 0 AS regm_tat_bro, 0 AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'sun') and (type = 'reg_carrier')) union 
select tran_dt AS tran_dt, 0 AS hits_total, 0 AS hits_post, 0 AS hits_pre, 0 AS hits_tm_tnt, 0 AS hits_tat_bro, 0 AS uniq_total, 0 AS uniq_post, 0 AS uniq_pre, 0 AS uniq_tm_tnt, 0 AS uniq_tat_bro, 0 AS free_total, 0 AS free_post, 0 AS free_pre, 0 AS free_tm_tnt, 0 AS free_tat_bro, 0 AS reg_total, 0 AS reg_post, 0 AS reg_pre, 0 AS reg_tm_tnt, 0 AS reg_tat_bro, total AS regm_total, post AS regm_post, pre AS regm_pre, tm_tnt AS regm_tm_tnt, tat_bro AS regm_tat_bro, 0 AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'sun') and (type = 'reg_mig')) union 
select tran_dt AS tran_dt, 0 AS hits_total, 0 AS hits_post, 0 AS hits_pre, 0 AS hits_tm_tnt, 0 AS hits_tat_bro, 0 AS uniq_total, 0 AS uniq_post, 0 AS uniq_pre, 0 AS uniq_tm_tnt, 0 AS uniq_tat_bro, 0 AS free_total, 0 AS free_post, 0 AS free_pre, 0 AS free_tm_tnt, 0 AS free_tat_bro, 0 AS reg_total, 0 AS reg_post, 0 AS reg_pre, 0 AS reg_tm_tnt, 0 AS reg_tat_bro, 0 AS regm_total, 0 AS regm_post, 0 AS regm_pre, 0 AS regm_tm_tnt, 0 AS regm_tat_bro, total AS uniq_nonreg from ctmv6_stats_dtl where ((carrier = 'sun') and (type = 'uniq_nonreg'));


DROP VIEW ctmv6_registration_stats;
CREATE VIEW ctmv6_registration_stats AS 
select tran_dt AS tran_dt, 
       sum(reg_globe) AS reg_globe, 
       sum(reg_smart) AS reg_smart, 
       sum(reg_sun) AS reg_sun, 
       sum(reg_fb) AS reg_fb, 
       sum(reg_tw) AS reg_tw, 
       sum(reg_go) AS reg_go, 
       sum(reg_li) AS reg_li, 
       sum(((((((reg_globe + reg_smart) + reg_sun) + reg_fb) + reg_tw) + reg_go) + reg_li)) AS reg_total, 
       sum(regm_globe) AS regm_globe, 
       sum(regm_smart) AS regm_smart, 
       sum(regm_sun) AS regm_sun, 
       sum(regm_pc) AS regm_pc, 
       sum((((regm_globe + regm_smart) + regm_sun) + regm_pc)) AS regm_total, 
       sum(sign_and) AS sign_and, 
       sum(sign_ios) AS sign_ios, 
       sum(sign_web) AS sign_web, 
       sum(((sign_and + sign_ios) + sign_web)) AS sign_total, 
       sum(ussd_mt) AS ussd_mt, 
       sum(ussd_hits) AS ussd_hits, 
       sum(ussd_118_mt) AS ussd_118_mt, 
       sum(ussd_118_hits) AS ussd_118_hits 
from ctmv6_registration_log 
group by tran_dt;

DROP VIEW ctmv6_registration_log; 
CREATE VIEW ctmv6_registration_log AS 
select tran_dt AS tran_dt, total AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, 0 AS reg_go, 0 AS reg_li, 0 AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, 0 AS sign_and, 0 AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where ((type = 'reg_carrier') and (carrier = 'globe')) union 
select tran_dt AS tran_dt, 0 AS reg_globe, total AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, 0 AS reg_go, 0 AS reg_li, 0 AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, 0 AS sign_and, 0 AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where ((type = 'reg_carrier') and (carrier = 'smart')) union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, total AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, 0 AS reg_go, 0 AS reg_li, 0 AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, 0 AS sign_and, 0 AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where ((type = 'reg_carrier') and (carrier = 'sun')) union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, total AS reg_fb, 0 AS reg_tw, 0 AS reg_go, 0 AS reg_li, 0 AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, 0 AS sign_and, 0 AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where ((type = 'reg_sn') and (carrier = 'facebook')) union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, total AS reg_tw, 0 AS reg_go, 0 AS reg_li, 0 AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, 0 AS sign_and, 0 AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where ((type = 'reg_sn') and (carrier = 'twitter')) union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, total AS reg_go, 0 AS reg_li, 0 AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, 0 AS sign_and, 0 AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where ((type = 'reg_sn') and (carrier = 'googleplus')) union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, 0 AS reg_go, total AS reg_li, 0 AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, 0 AS sign_and, 0 AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where ((type = 'reg_sn') and (carrier = 'linkedin')) union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, 0 AS reg_go, 0 AS reg_li, total AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, 0 AS sign_and, 0 AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where ((type = 'reg_mig') and (carrier = 'globe')) union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, 0 AS reg_go, 0 AS reg_li, 0 AS regm_globe, total AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, 0 AS sign_and, 0 AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where ((type = 'reg_mig') and (carrier = 'smart')) union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, 0 AS reg_go, 0 AS reg_li, 0 AS regm_globe, 0 AS regm_smart, total AS regm_sun, 0 AS regm_pc, 0 AS sign_and, 0 AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where ((type = 'reg_mig') and (carrier = 'sun')) union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, 0 AS reg_go, 0 AS reg_li, 0 AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, total AS regm_pc, 0 AS sign_and, 0 AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where ((type = 'reg_mig') and (carrier = 'pc')) union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, 0 AS reg_go, 0 AS reg_li, 0 AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, others AS sign_and, 0 AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where ((type = 'login') and (carrier = 'android')) union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, 0 AS reg_go, 0 AS reg_li, 0 AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, 0 AS sign_and, others AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where ((type = 'login') and (carrier = 'ios')) union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, 0 AS reg_go, 0 AS reg_li, 0 AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, 0 AS sign_and, 0 AS sign_ios, others AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where ((type = 'login') and (carrier = 'web')) union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, 0 AS reg_go, 0 AS reg_li, 0 AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, 0 AS sign_and, 0 AS sign_ios, 0 AS sign_web, total AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where (type = 'ussdmt') union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, 0 AS reg_go, 0 AS reg_li, 0 AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, 0 AS sign_and, 0 AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, total AS ussd_hits, 0 AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where (type = 'ussd') union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, 0 AS reg_go, 0 AS reg_li, 0 AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, 0 AS sign_and, 0 AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, total AS ussd_118_mt, 0 AS ussd_118_hits from ctmv6_stats_dtl where (type = 'ussd_118_mt') union 
select tran_dt AS tran_dt, 0 AS reg_globe, 0 AS reg_smart, 0 AS reg_sun, 0 AS reg_fb, 0 AS reg_tw, 0 AS reg_go, 0 AS reg_li, 0 AS regm_globe, 0 AS regm_smart, 0 AS regm_sun, 0 AS regm_pc, 0 AS sign_and, 0 AS sign_ios, 0 AS sign_web, 0 AS ussd_mt, 0 AS ussd_hits, 0 AS ussd_118_mt, total AS ussd_118_hits from ctmv6_stats_dtl where (type = 'ussd_118');


CREATE VIEW ctmv6_registration_per_country AS 
select tran_dt AS tran_dt,
       ifnull(max(if((carrier = 'AUSTRALIA'), total, NULL)), 0) AS AUSTRALIA,
       ifnull(max(if((carrier = 'BAHRAIN'), total, NULL)), 0) AS BAHRAIN,
       ifnull(max(if((carrier = 'BRAZIL'), total, NULL)), 0) AS BRAZIL,
       ifnull(max(if((carrier = 'CANADA'), total, NULL)), 0) AS CANADA,
       ifnull(max(if((carrier = 'CHINA'), total, NULL)), 0) AS CHINA,
       ifnull(max(if((carrier = 'FRANCE'), total, NULL)), 0) AS FRANCE,
       ifnull(max(if((carrier = 'GREECE'), total, NULL)), 0) AS GREECE,
       ifnull(max(if((carrier = 'GUAM'), total, NULL)), 0) AS GUAM,
       ifnull(max(if((carrier = 'HONG KONG'), total, NULL)), 0) AS HKONG,
       ifnull(max(if((carrier = 'INDIA'), total, NULL)), 0) AS INDIA,
       ifnull(max(if((carrier = 'IRAQ'), total, NULL)), 0) AS IRAQ,
       ifnull(max(if((carrier = 'IRELAND'), total, NULL)), 0) AS IRELAND,
       ifnull(max(if((carrier = 'ITALY'), total, NULL)), 0) AS ITALY,
       ifnull(max(if((carrier = 'JAPAN'), total, NULL)), 0) AS JAPAN,
       ifnull(max(if((carrier = 'JORDAN'), total, NULL)), 0) AS JORDAN,
       ifnull(max(if((carrier = 'KAZAKHSTAN'), total, NULL)), 0) AS KAZAKHSTAN,
       ifnull(max(if((carrier = 'KUWAIT'), total, NULL)), 0) AS KUWAIT,
       ifnull(max(if((carrier = 'LEBANON'), total, NULL)), 0) AS LEBANON,
       ifnull(max(if((carrier = 'MACAU'), total, NULL)), 0) AS MACAU,
       ifnull(max(if((carrier = 'MALAYSIA'), total, NULL)), 0) AS MALAYSIA,
       ifnull(max(if((carrier = 'MEXICO'), total, NULL)), 0) AS MEXICO,
       ifnull(max(if((carrier = 'NEW ZEALAND'), total, NULL)), 0) AS ZEALAND,
       ifnull(max(if((carrier = 'NIGERIA'), total, NULL)), 0) AS NIGERIA,
       ifnull(max(if((carrier = 'NORTH KOREA'), total, NULL)), 0) AS NKOREA,
       ifnull(max(if((carrier = 'NORWAY'), total, NULL)), 0) AS NORWAY,
       ifnull(max(if((carrier = 'OMAN'), total, NULL)), 0) AS OMAN,
       ifnull(max(if((carrier = 'PAKISTAN'), total, NULL)), 0) AS PAKISTAN,
       ifnull(max(if((carrier = 'PHILIPPINES'), total, NULL)), 0) AS PHIL,
       ifnull(max(if((carrier = 'QATAR'), total, NULL)), 0) AS QATAR,
       ifnull(max(if((carrier = 'SAUDI ARABIA'), total, NULL)), 0) AS SARABIA,
       ifnull(max(if((carrier = 'SINGAPORE'), total, NULL)), 0) AS SINGAPORE,
       ifnull(max(if((carrier = 'SOUTH KOREA'), total, NULL)), 0) AS SKOREA,
       ifnull(max(if((carrier = 'SPAIN'), total, NULL)), 0) AS SPAIN,
       ifnull(max(if((carrier = 'SWEDEN'), total, NULL)), 0) AS SWEDEN,
       ifnull(max(if((carrier = 'TAIWAN'), total, NULL)), 0) AS TAIWAN,
       ifnull(max(if((carrier = 'THAILAND'), total, NULL)), 0) AS THAILAND,
       ifnull(max(if((carrier = 'UAE'), total, NULL)), 0) AS UAE,
       ifnull(max(if((carrier = 'UNITED KINGDOM'), total, NULL)), 0) AS UKINGDOM,
       ifnull(max(if((carrier = 'UNITED STATES'), total, NULL)), 0) AS USTATES,
       ifnull(max(if((carrier = 'VENEZUELA'), total, NULL)), 0) AS VENEZUELA,
       ifnull(max(if((carrier = 'VIETNAM'), total, NULL)), 0) AS VIETNAM 
from ctmv6_stats_dtl 
where (type = 'reg_country') 
group by tran_dt;


create view ctmv6_monthly_stats as
select tx_year, tx_yrmo, tx_month,
       SUM(IF(carrier = 'smart' and type ='hits', total_t, 0)) hsmart,
       SUM(IF(carrier = 'globe' and type ='hits', total_t, 0)) hglobe,
       SUM(IF(carrier = 'sun' and type ='hits', total_t, 0)) hsun,
       SUM(IF(carrier = 'smart' and type ='hits', total_t*2.5, 0)) rsmart,
       SUM(IF(carrier = 'globe' and type ='hits', total_t*2.5, 0)) rglobe,
       SUM(IF(carrier = 'sun' and type ='hits', total_t*2, 0)) rsun,
          SUM(IF(carrier = 'smart' and type ='hits', total_t*2.5, 0)) + 
          SUM(IF(carrier = 'globe' and type ='hits', total_t*2.5, 0)) + 
          SUM(IF(carrier = 'sun' and type ='hits', total_t*2, 0)) rtotal,
       SUM(IF(carrier = 'smart' and type ='reg_carrier', total_t, 0)) regsmart,
       SUM(IF(carrier = 'globe' and type ='reg_carrier', total_t, 0)) regglobe,
       SUM(IF(carrier = 'sun' and type ='reg_carrier', total_t, 0)) regsun,
       SUM(IF(carrier = 'facebook' and type ='reg_sn', total_t, 0)) reg_fb,
       SUM(IF(carrier = 'twitter' and type ='reg_sn', total_t, 0)) reg_tw,
       SUM(IF(carrier = 'googleplus' and type ='reg_sn', total_t, 0)) reg_google,
       SUM(IF(carrier = 'linkedin' and type ='reg_sn', total_t, 0)) reg_link,
       SUM(IF(carrier = 'smart' and type ='reg_carrier', total_t, 0))+
       SUM(IF(carrier = 'globe' and type ='reg_carrier', total_t, 0))+
       SUM(IF(carrier = 'sun' and type ='reg_carrier', total_t, 0))+
       SUM(IF(carrier = 'facebook' and type ='reg_sn', total_t, 0))+
       SUM(IF(carrier = 'twitter' and type ='reg_sn', total_t, 0))+
       SUM(IF(carrier = 'googleplus' and type ='reg_sn', total_t, 0))+
       SUM(IF(carrier = 'linkedin' and type ='reg_sn', total_t, 0)) regtotal
from  (select left(tran_dt,4) tx_year, left(tran_dt,7) tx_yrmo, DATE_FORMAT(tran_dt,'%M') tx_month, carrier, type, sum(total) total_t 
       from  ctmv6_stats_dtl  
       group by 1,2,3,4,5) a 
group  by 1,2,3;

drop  view ctmv6_monthly_stats;
create view ctmv6_monthly_stats as
select left(tran_dt,4) tx_year, left(tran_dt,7) tx_yrmo, DATE_FORMAT(tran_dt,'%M') tx_month,
       SUM(IF(carrier = 'smart' and type ='hits', total, 0)) h_smart,
       SUM(IF(carrier = 'globe' and type ='hits', total, 0)) h_globe,
       SUM(IF(carrier = 'sun' and type ='hits', total, 0)) h_sun,
          SUM(IF(carrier = 'smart' and type ='hits', total, 0)) + 
          SUM(IF(carrier = 'globe' and type ='hits', total, 0)) + 
          SUM(IF(carrier = 'sun' and type ='hits', total, 0)) h_total,
       SUM(IF(carrier = 'smart' and type ='hits', total*2.5, 0)) r_smart,
       SUM(IF(carrier = 'globe' and type ='hits', total*2.5, 0)) r_globe,
       SUM(IF(carrier = 'sun' and type ='hits', total*2, 0)) r_sun,
          SUM(IF(carrier = 'smart' and type ='hits', total*2.5, 0)) + 
          SUM(IF(carrier = 'globe' and type ='hits', total*2.5, 0)) + 
          SUM(IF(carrier = 'sun' and type ='hits', total*2, 0)) r_total,
       SUM(IF(carrier = 'smart' and type ='reg_carrier', total, 0)) reg_smart,
       SUM(IF(carrier = 'globe' and type ='reg_carrier', total, 0)) reg_globe,
       SUM(IF(carrier = 'sun' and type ='reg_carrier', total, 0)) reg_sun,
       SUM(IF(carrier = 'facebook' and type ='reg_sn', total, 0)) reg_fb,
       SUM(IF(carrier = 'twitter' and type ='reg_sn', total, 0)) reg_tw,
       SUM(IF(carrier = 'googleplus' and type ='reg_sn', total, 0)) reg_google,
       SUM(IF(carrier = 'linkedin' and type ='reg_sn', total, 0)) reg_link,
       SUM(IF(carrier = 'smart' and type ='reg_carrier', total, 0))+
       SUM(IF(carrier = 'globe' and type ='reg_carrier', total, 0))+
       SUM(IF(carrier = 'sun' and type ='reg_carrier', total, 0))+
       SUM(IF(carrier = 'facebook' and type ='reg_sn', total, 0))+
       SUM(IF(carrier = 'twitter' and type ='reg_sn', total, 0))+
       SUM(IF(carrier = 'googleplus' and type ='reg_sn', total, 0))+
       SUM(IF(carrier = 'linkedin' and type ='reg_sn', total, 0)) reg_total
from  ctmv6_stats_dtl  
group  by 1,2,3;


$sth_ctm_v6 = $db
select tx_month,
                        h_smart, h_globe, h_sun, 
                        r_smart, r_globe, r_sun, r_total,
                        reg_smart, reg_globe, reg_sun, 
                        reg_fb, reg_tw, reg_google, reg_link, reg_total
                 from  ctmv6_monthly_stats
                 where tx_year = left()
