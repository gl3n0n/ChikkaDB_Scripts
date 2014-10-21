delimiter //
DROP PROCEDURE sp_ctmv6_generate_stats//
CREATE PROCEDURE sp_ctmv6_generate_stats()
begin
   insert ignore into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, others, total) 
   select reg_date, carrier, type, sum(post), sum(pre), sum(tm_tnt), sum(tat_bro), sum(others), sum(total) from (
   select reg_date, 'globe' carrier, 'reg_carrier' type, count(1) post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = date_sub(curdate(), interval 1 day) and msisdn_carrier='GLOBE' and msisdn_type = 'POSTPAID' group by 1,2,3 union
   select reg_date, 'globe', 'reg_carrier', 0 post, count(1) pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = date_sub(curdate(), interval 1 day) and msisdn_carrier='GLOBE' and msisdn_type = 'PREPAID' group by 1,2,3 union
   select reg_date, 'globe', 'reg_carrier', 0 post, 0 pre, count(1) tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = date_sub(curdate(), interval 1 day) and msisdn_carrier='GLOBE' and msisdn_type = 'TM' group by 1,2,3 union
   select reg_date, 'globe', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = date_sub(curdate(), interval 1 day) and msisdn_carrier='GLOBE' group by 1,2,3 union
   select date_sub(curdate(), interval 1 day) reg_date, 'globe', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total  union
   select reg_date, 'smart', 'reg_carrier', count(1) post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = date_sub(curdate(), interval 1 day) and msisdn_carrier='SMART' and msisdn_type = 'POSTPAID' group by 1,2,3 union
   select reg_date, 'smart', 'reg_carrier', 0 post, count(1) pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = date_sub(curdate(), interval 1 day) and msisdn_carrier='SMART' and msisdn_type = 'PREPAID' group by 1,2,3 union
   select reg_date, 'smart', 'reg_carrier', 0 post, 0 pre, count(1) tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = date_sub(curdate(), interval 1 day) and msisdn_carrier='SMART' and msisdn_type = 'TNT' group by 1,2,3 union
   select reg_date, 'smart', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = date_sub(curdate(), interval 1 day) and msisdn_carrier='SMART' group by 1,2,3 union
   select date_sub(curdate(), interval 1 day) reg_date, 'smart', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total  union
   select reg_date, 'sun', 'reg_carrier', count(1) post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = date_sub(curdate(), interval 1 day) and msisdn_carrier='SUN' and msisdn_type = 'POSTPAID' group by 1,2,3 union
   select reg_date, 'sun', 'reg_carrier', 0 post, count(1) pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = date_sub(curdate(), interval 1 day) and msisdn_carrier='SUN' and msisdn_type = 'PREPAID' group by 1,2,3 union
   select reg_date, 'sun', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = date_sub(curdate(), interval 1 day) and msisdn_carrier='SUN' group by 1,2,3 union
   select date_sub(curdate(), interval 1 day) reg_date, 'sun', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total union
   select reg_date, reg_app, 'reg_sn', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = date_sub(curdate(), interval 1 day) and reg_app is not null group by 1,2,3 union
   select date_sub(curdate(), interval 1 day), 'facebook', 'reg_sn', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total union
   select date_sub(curdate(), interval 1 day), 'googleplus', 'reg_sn', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total union
   select date_sub(curdate(), interval 1 day), 'linkedin', 'reg_sn', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total union
   select date_sub(curdate(), interval 1 day), 'twitter', 'reg_sn', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total union
   select reg_date, country, 'reg_country', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = date_sub(curdate(), interval 1 day) and country is not null group by 1,2,3 union
   select date_sub(curdate(), interval 1 day), operator, 'reg_country', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from mobile_pattern where operator <> 'SMART' and operator <> 'SUN' and operator <> 'GLOBE' group by operator;
   select reg_date, reg_src, 'reg_device', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = date_sub(curdate(), interval 1 day) and reg_src is not null group by 1,2,3 union   
   select date_sub(curdate(), interval 1 day), 'android', 'reg_device', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total union
   select date_sub(curdate(), interval 1 day), 'ios', 'reg_device', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total union
   select date_sub(curdate(), interval 1 day), 'web', 'reg_device', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total ) t1 group by 1,2,3;
end;
//
delimiter ;

alter table ctm_registration mdify country varchar(30);
update ctm_registration set country='PHILIPPINES' where msisdn is not null and msisdn like '63%';


delimiter //
DROP PROCEDURE sp_ctmv6_regenerate_stats//
CREATE PROCEDURE sp_ctmv6_regenerate_stats(p_trandate varchar(10))
begin
   insert ignore into ctmv6_stats_dtl (tran_dt, carrier, type, post, pre, tm_tnt, tat_bro, others, total) 
   select reg_date, carrier, type, sum(post), sum(pre), sum(tm_tnt), sum(tat_bro), sum(others), sum(total) from (
   select reg_date, 'globe' carrier, 'reg_carrier' type, count(1) post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='GLOBE' and msisdn_type = 'POSTPAID' group by 1,2,3 union
   select reg_date, 'globe', 'reg_carrier', 0 post, count(1) pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='GLOBE' and msisdn_type = 'PREPAID' group by 1,2,3 union
   select reg_date, 'globe', 'reg_carrier', 0 post, 0 pre, count(1) tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='GLOBE' and msisdn_type = 'TM' group by 1,2,3 union
   select reg_date, 'globe', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = p_trandate and msisdn_carrier='GLOBE' group by 1,2,3 union
   select p_trandate reg_date, 'globe', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total  union
   select reg_date, 'smart', 'reg_carrier', count(1) post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='SMART' and msisdn_type = 'POSTPAID' group by 1,2,3 union
   select reg_date, 'smart', 'reg_carrier', 0 post, count(1) pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='SMART' and msisdn_type = 'PREPAID' group by 1,2,3 union
   select reg_date, 'smart', 'reg_carrier', 0 post, 0 pre, count(1) tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='SMART' and msisdn_type = 'TNT' group by 1,2,3 union
   select reg_date, 'smart', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = p_trandate and msisdn_carrier='SMART' group by 1,2,3 union
   select p_trandate reg_date, 'smart', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total  union
   select reg_date, 'sun', 'reg_carrier', count(1) post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='SUN' and msisdn_type = 'POSTPAID' group by 1,2,3 union
   select reg_date, 'sun', 'reg_carrier', 0 post, count(1) pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from ctm_registration where reg_date = p_trandate and msisdn_carrier='SUN' and msisdn_type = 'PREPAID' group by 1,2,3 union
   select reg_date, 'sun', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = p_trandate and msisdn_carrier='SUN' group by 1,2,3 union
   select p_trandate reg_date, 'sun', 'reg_carrier', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total union
   select reg_date, reg_app, 'reg_sn', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = p_trandate and reg_app is not null group by 1,2,3 union
   select p_trandate, 'facebook', 'reg_sn', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total union
   select p_trandate, 'googleplus', 'reg_sn', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total union
   select p_trandate, 'linkedin', 'reg_sn', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total union
   select p_trandate, 'twitter', 'reg_sn', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total union
   select reg_date, country, 'reg_country', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = date_sub(curdate(), interval 1 day) and country is not null group by 1,2,3 union
   select date_sub(curdate(), interval 1 day), operator, 'reg_country', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total from mobile_pattern where operator <> 'SMART' and operator <> 'SUN' and operator <> 'GLOBE' group by operator;
   select reg_date, reg_src, 'reg_device', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, count(1) total from ctm_registration where reg_date = p_trandate and reg_src is not null group by 1,2,3 union
   select p_trandate, 'android', 'reg_device', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total union
   select p_trandate, 'ios', 'reg_device', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total union
   select p_trandate, 'web', 'reg_device', 0 post, 0 pre, 0 tm_tnt, 0 tat_bro, 0 others, 0 total ) t1 group by 1,2,3;
end;
//
delimiter ;