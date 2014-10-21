create table ctm_stats_dtl (
   tran_dt date not null,
   tran_tm time not null,  
   carrier enum('globe','smart','smart8266','smart8267','sun','yahoo','gmail') not null,
   type  enum('hits','mo','mt','reg', 'ukmo', 'ukmt') not null,
   post int(8) default 0 not null,
   pre  int(8) default 0 not null,
   primary key (tran_dt, tran_tm, carrier, type)
);


select tran_dt, time_hh, carrier, type, sum(post), sum(pre) from (
select left(registration_datetime,10) tran_dt, '00:00' time_hh, 'globe' carrier, 'reg' type, count(1) post, 0 pre from ctm_stats.registrations_pht where registration_datetime between date_sub(curdate(), interval 1 day) and curdate() and carrier='Globe' and chikka_id REGEXP '(^(([+| ]?63)|0)9173[0-2][0-9]{5,5}$)|(^(([+| ]?63)|0)9175[0-9]{6,6}$)|(^(([+| ]?63)|0)9176(2|3|5|7|8)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7|9)[0-9]{5,5}$)|(^(([+| ]?63)|0)9178[0-9][0-9]{5,5}$)|(^(([+| ]?63)|0)90599[0-9]{5,5}$)' group by left(registration_datetime,10) union all
select left(registration_datetime,10) tran_dt, '00:00' time_hh, 'globe' carrier, 'reg' type, 0 post, count(1) pre from ctm_stats.registrations_pht where registration_datetime between date_sub(curdate(), interval 1 day) and curdate() and carrier='Globe' and chikka_id not REGEXP '(^(([+| ]?63)|0)9173[0-2][0-9]{5,5}$)|(^(([+| ]?63)|0)9175[0-9]{6,6}$)|(^(([+| ]?63)|0)9176(2|3|5|7|8)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7|9)[0-9]{5,5}$)|(^(([+| ]?63)|0)9178[0-9][0-9]{5,5}$)|(^(([+| ]?63)|0)90599[0-9]{5,5}$)' group by left(registration_datetime,10) union all
select left(registration_datetime,10) tran_dt, '00:00' time_hh, 'smart' carrier, 'reg' type, count(1) post, 0 pre from ctm_stats.registrations_pht where registration_datetime between date_sub(curdate(), interval 1 day) and curdate() and carrier='Smart' and chikka_id REGEXP '(^(([+| ]?63)|0)94789[0-9]{5}$)|(^(([+| ]?63)|0)94799[0-9]{5}$)|(^(([+| ]?63)|0)9479171[0-9]{3}$)|(^(([+| ]?63)|0)947917[2-6][0-9]{3}$)|(^(([+| ]?63)|0)9088[1-4,6,9][0-9]{5}$)|(^(([+| ]?63)|0)90887[2-9][0-9]{4}$)|(^(([+| ]?63)|0)908880212[0-9]$)|(^(([+| ]?63)|0)9088802[2-9]{2}$)|(^(([+| ]?63)|0)908880[3-9]{3}$)|(^(([+| ]?63)|0)9189(0(0[1-9]|[1-9][0-9])|[12][0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)918930[0-9]{4}$)|(^(([+| ]?63)|0)91893[3-9][0-9]{4}$)|(^(([+| ]?63)|0)91894[0-8][0-9]{4}$)|(^(([+| ]?63)|0)9189(5|6)[0-9]{5}$)|(^(([+| ]?63)|0)91897([0-3][0-9]|4[0-8])[0-9]{3}$)|(^(([+| ]?63)|0)9189(7[5-9][0-9]|(8|9)[0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)91999[0-9]{5}$)|(^(([+| ]?63)|0)9209(0|1)[0-9]{5}$)|(^(([+| ]?63)|0)920932[6-9][0-9]{3}$)|(^(([+| ]?63)|0)920938[0-9]{4}$)|(^(([+| ]?63)|0)92094[5-9][0-9]{4}$)|(^(([+| ]?63)|0)9209[5-7,9][0-9]{5}$)|(^(([+| ]?63)|0)92855[0-9]{5}$)|(^(([+| ]?63)|0)9399(0|1|2|3|7|8)[0-9]{5}$)|(^(([+| ]?63)|0)999(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)9285[0-2][0-9]{5}$)|(^(([+| ]?63)|0)92092[0-8][0-9]{4}$)|(^(([+| ]?63)|0)920929[0-8][0-9]{3}$)|(^(([+| ]?63)|0)92094[0-4][0-9]{4}$)|(^(([+| ]?63)|0)90885[0-9]{5}$)|(^(([+| ]?63)|0)908880(([0-1][0-9]{3})|(2(0[0-9]{2}|1[0-1][0-9])))$)|(^(([+| ]?63)|0)9188[0-9]{6}$)|(^(([+| ]?63)|0)92888[0-9]{5}$)|(^(([+| ]?63)|0)93999[0-9]{5}$)|(^(([+| ]?63)|0)949(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)94790[5-9][0-9]{4}$)|(^(([+| ]?63)|0)94791[3-6][0-9]{4}$)|(^(([+| ]?63)|0)94938[0-9]{5}$)|(^(([+| ]?63)|0)94951[0-9]{5}$)|(^(([+| ]?63)|0)90887[0-1][0-9]{4}$)|(^(([+| ]?63)|0)9299[8-9][0-9]{5}$)|(^(([+| ]?63)|0)9396[6-9][0-9]{5}$)|(^(([+| ]?63)|0)93970[0-9]{5}$)|(^(([+| ]?63)|0)9471[2-3][0-9]{5}$)|(^(([+| ]?63)|0)9476[7-8][0-9]{5}$)|(^(([+| ]?63)|0)9281[0-3][0-9]{5}$)|(^(([+| ]?63)|0)9495[2|4][0-9]{5}$)|(^(([+| ]?63)|0)94955[1-4][0-9]{4}$)|(^(([+| ]?63)|0)9991[1-4][0-9]{5}$)|(^(([+| ]?63)|0)9996[0|3|4][0-9]{5}$)' group by left(registration_datetime,10) union all
select left(registration_datetime,10) tran_dt, '00:00' time_hh, 'smart' carrier, 'reg' type, 0 post, count(1) pre from ctm_stats.registrations_pht where registration_datetime between date_sub(curdate(), interval 1 day) and curdate() and carrier='Smart' and chikka_id not REGEXP '(^(([+| ]?63)|0)94789[0-9]{5}$)|(^(([+| ]?63)|0)94799[0-9]{5}$)|(^(([+| ]?63)|0)9479171[0-9]{3}$)|(^(([+| ]?63)|0)947917[2-6][0-9]{3}$)|(^(([+| ]?63)|0)9088[1-4,6,9][0-9]{5}$)|(^(([+| ]?63)|0)90887[2-9][0-9]{4}$)|(^(([+| ]?63)|0)908880212[0-9]$)|(^(([+| ]?63)|0)9088802[2-9]{2}$)|(^(([+| ]?63)|0)908880[3-9]{3}$)|(^(([+| ]?63)|0)9189(0(0[1-9]|[1-9][0-9])|[12][0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)918930[0-9]{4}$)|(^(([+| ]?63)|0)91893[3-9][0-9]{4}$)|(^(([+| ]?63)|0)91894[0-8][0-9]{4}$)|(^(([+| ]?63)|0)9189(5|6)[0-9]{5}$)|(^(([+| ]?63)|0)91897([0-3][0-9]|4[0-8])[0-9]{3}$)|(^(([+| ]?63)|0)9189(7[5-9][0-9]|(8|9)[0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)91999[0-9]{5}$)|(^(([+| ]?63)|0)9209(0|1)[0-9]{5}$)|(^(([+| ]?63)|0)920932[6-9][0-9]{3}$)|(^(([+| ]?63)|0)920938[0-9]{4}$)|(^(([+| ]?63)|0)92094[5-9][0-9]{4}$)|(^(([+| ]?63)|0)9209[5-7,9][0-9]{5}$)|(^(([+| ]?63)|0)92855[0-9]{5}$)|(^(([+| ]?63)|0)9399(0|1|2|3|7|8)[0-9]{5}$)|(^(([+| ]?63)|0)999(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)9285[0-2][0-9]{5}$)|(^(([+| ]?63)|0)92092[0-8][0-9]{4}$)|(^(([+| ]?63)|0)920929[0-8][0-9]{3}$)|(^(([+| ]?63)|0)92094[0-4][0-9]{4}$)|(^(([+| ]?63)|0)90885[0-9]{5}$)|(^(([+| ]?63)|0)908880(([0-1][0-9]{3})|(2(0[0-9]{2}|1[0-1][0-9])))$)|(^(([+| ]?63)|0)9188[0-9]{6}$)|(^(([+| ]?63)|0)92888[0-9]{5}$)|(^(([+| ]?63)|0)93999[0-9]{5}$)|(^(([+| ]?63)|0)949(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)94790[5-9][0-9]{4}$)|(^(([+| ]?63)|0)94791[3-6][0-9]{4}$)|(^(([+| ]?63)|0)94938[0-9]{5}$)|(^(([+| ]?63)|0)94951[0-9]{5}$)|(^(([+| ]?63)|0)90887[0-1][0-9]{4}$)|(^(([+| ]?63)|0)9299[8-9][0-9]{5}$)|(^(([+| ]?63)|0)9396[6-9][0-9]{5}$)|(^(([+| ]?63)|0)93970[0-9]{5}$)|(^(([+| ]?63)|0)9471[2-3][0-9]{5}$)|(^(([+| ]?63)|0)9476[7-8][0-9]{5}$)|(^(([+| ]?63)|0)9281[0-3][0-9]{5}$)|(^(([+| ]?63)|0)9495[2|4][0-9]{5}$)|(^(([+| ]?63)|0)94955[1-4][0-9]{4}$)|(^(([+| ]?63)|0)9991[1-4][0-9]{5}$)|(^(([+| ]?63)|0)9996[0|3|4][0-9]{5}$)' group by left(registration_datetime,10) union all
select left(registration_datetime,10) tran_dt, '00:00' time_hh, 'sun' carrier, 'reg' type, count(1) post, 0 pre from ctm_stats.registrations_pht where registration_datetime between date_sub(curdate(), interval 1 day) and curdate() and carrier='Sun' and chikka_id REGEXP '((([+| ]?63)|0)9228[0-9]{6})|((([+| ]?63)|0)922922[0-9]{4})|((([+| ]?63)|0)9328[0-9]{6})' group by left(registration_datetime,10) union all
select left(registration_datetime,10) tran_dt, '00:00' time_hh, 'sun' carrier, 'reg' type, 0 post, count(1) pre from ctm_stats.registrations_pht where registration_datetime between date_sub(curdate(), interval 1 day) and curdate() and carrier='Sun' and chikka_id not REGEXP '((([+| ]?63)|0)9228[0-9]{6})|((([+| ]?63)|0)922922[0-9]{4})|((([+| ]?63)|0)9328[0-9]{6})' group by left(registration_datetime,10)
) t1 group by tran_dt, time_hh, carrier, type;

mysql -uchk_dba -p --socket=/mnt/DF254_3382/db254_3382.sock
set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;

select tran_dt, time_hh, carrier, type, sum(post), sum(pre) from (
select datein tran_dt, '00:00' time_hh, 'globe' carrier, 'mo' type, count(1) post, 0 pre from mui_ph_globe_1.bridge_out where status = 2 and tx_type = 'messaging' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_from REGEXP '(^(([+| ]?63)|0)9173[0-2][0-9]{5,5}$)|(^(([+| ]?63)|0)9175[0-9]{6,6}$)|(^(([+| ]?63)|0)9176(2|3|5|7|8)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7|9)[0-9]{5,5}$)|(^(([+| ]?63)|0)9178[0-9][0-9]{5,5}$)|(^(([+| ]?63)|0)90599[0-9]{5,5}$)' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'globe' carrier, 'mo' type, 0 post, count(1) pre from mui_ph_globe_1.bridge_out where status = 2 and tx_type = 'messaging' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_from not REGEXP '(^(([+| ]?63)|0)9173[0-2][0-9]{5,5}$)|(^(([+| ]?63)|0)9175[0-9]{6,6}$)|(^(([+| ]?63)|0)9176(2|3|5|7|8)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7|9)[0-9]{5,5}$)|(^(([+| ]?63)|0)9178[0-9][0-9]{5,5}$)|(^(([+| ]?63)|0)90599[0-9]{5,5}$)' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'smart' carrier, 'mo' type, count(1) post, 0 pre from mui_ph_smart_1.bridge_out where status = 2 and tx_type = 'messaging' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_from REGEXP '(^(([+| ]?63)|0)94789[0-9]{5}$)|(^(([+| ]?63)|0)94799[0-9]{5}$)|(^(([+| ]?63)|0)9479171[0-9]{3}$)|(^(([+| ]?63)|0)947917[2-6][0-9]{3}$)|(^(([+| ]?63)|0)9088[1-4,6,9][0-9]{5}$)|(^(([+| ]?63)|0)90887[2-9][0-9]{4}$)|(^(([+| ]?63)|0)908880212[0-9]$)|(^(([+| ]?63)|0)9088802[2-9]{2}$)|(^(([+| ]?63)|0)908880[3-9]{3}$)|(^(([+| ]?63)|0)9189(0(0[1-9]|[1-9][0-9])|[12][0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)918930[0-9]{4}$)|(^(([+| ]?63)|0)91893[3-9][0-9]{4}$)|(^(([+| ]?63)|0)91894[0-8][0-9]{4}$)|(^(([+| ]?63)|0)9189(5|6)[0-9]{5}$)|(^(([+| ]?63)|0)91897([0-3][0-9]|4[0-8])[0-9]{3}$)|(^(([+| ]?63)|0)9189(7[5-9][0-9]|(8|9)[0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)91999[0-9]{5}$)|(^(([+| ]?63)|0)9209(0|1)[0-9]{5}$)|(^(([+| ]?63)|0)920932[6-9][0-9]{3}$)|(^(([+| ]?63)|0)920938[0-9]{4}$)|(^(([+| ]?63)|0)92094[5-9][0-9]{4}$)|(^(([+| ]?63)|0)9209[5-7,9][0-9]{5}$)|(^(([+| ]?63)|0)92855[0-9]{5}$)|(^(([+| ]?63)|0)9399(0|1|2|3|7|8)[0-9]{5}$)|(^(([+| ]?63)|0)999(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)9285[0-2][0-9]{5}$)|(^(([+| ]?63)|0)92092[0-8][0-9]{4}$)|(^(([+| ]?63)|0)920929[0-8][0-9]{3}$)|(^(([+| ]?63)|0)92094[0-4][0-9]{4}$)|(^(([+| ]?63)|0)90885[0-9]{5}$)|(^(([+| ]?63)|0)908880(([0-1][0-9]{3})|(2(0[0-9]{2}|1[0-1][0-9])))$)|(^(([+| ]?63)|0)9188[0-9]{6}$)|(^(([+| ]?63)|0)92888[0-9]{5}$)|(^(([+| ]?63)|0)93999[0-9]{5}$)|(^(([+| ]?63)|0)949(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)94790[5-9][0-9]{4}$)|(^(([+| ]?63)|0)94791[3-6][0-9]{4}$)|(^(([+| ]?63)|0)94938[0-9]{5}$)|(^(([+| ]?63)|0)94951[0-9]{5}$)|(^(([+| ]?63)|0)90887[0-1][0-9]{4}$)|(^(([+| ]?63)|0)9299[8-9][0-9]{5}$)|(^(([+| ]?63)|0)9396[6-9][0-9]{5}$)|(^(([+| ]?63)|0)93970[0-9]{5}$)|(^(([+| ]?63)|0)9471[2-3][0-9]{5}$)|(^(([+| ]?63)|0)9476[7-8][0-9]{5}$)|(^(([+| ]?63)|0)9281[0-3][0-9]{5}$)|(^(([+| ]?63)|0)9495[2|4][0-9]{5}$)|(^(([+| ]?63)|0)94955[1-4][0-9]{4}$)|(^(([+| ]?63)|0)9991[1-4][0-9]{5}$)|(^(([+| ]?63)|0)9996[0|3|4][0-9]{5}$)' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'smart' carrier, 'mo' type, 0 post, count(1) pre from mui_ph_smart_1.bridge_out where status = 2 and tx_type = 'messaging' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_from not REGEXP '(^(([+| ]?63)|0)94789[0-9]{5}$)|(^(([+| ]?63)|0)94799[0-9]{5}$)|(^(([+| ]?63)|0)9479171[0-9]{3}$)|(^(([+| ]?63)|0)947917[2-6][0-9]{3}$)|(^(([+| ]?63)|0)9088[1-4,6,9][0-9]{5}$)|(^(([+| ]?63)|0)90887[2-9][0-9]{4}$)|(^(([+| ]?63)|0)908880212[0-9]$)|(^(([+| ]?63)|0)9088802[2-9]{2}$)|(^(([+| ]?63)|0)908880[3-9]{3}$)|(^(([+| ]?63)|0)9189(0(0[1-9]|[1-9][0-9])|[12][0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)918930[0-9]{4}$)|(^(([+| ]?63)|0)91893[3-9][0-9]{4}$)|(^(([+| ]?63)|0)91894[0-8][0-9]{4}$)|(^(([+| ]?63)|0)9189(5|6)[0-9]{5}$)|(^(([+| ]?63)|0)91897([0-3][0-9]|4[0-8])[0-9]{3}$)|(^(([+| ]?63)|0)9189(7[5-9][0-9]|(8|9)[0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)91999[0-9]{5}$)|(^(([+| ]?63)|0)9209(0|1)[0-9]{5}$)|(^(([+| ]?63)|0)920932[6-9][0-9]{3}$)|(^(([+| ]?63)|0)920938[0-9]{4}$)|(^(([+| ]?63)|0)92094[5-9][0-9]{4}$)|(^(([+| ]?63)|0)9209[5-7,9][0-9]{5}$)|(^(([+| ]?63)|0)92855[0-9]{5}$)|(^(([+| ]?63)|0)9399(0|1|2|3|7|8)[0-9]{5}$)|(^(([+| ]?63)|0)999(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)9285[0-2][0-9]{5}$)|(^(([+| ]?63)|0)92092[0-8][0-9]{4}$)|(^(([+| ]?63)|0)920929[0-8][0-9]{3}$)|(^(([+| ]?63)|0)92094[0-4][0-9]{4}$)|(^(([+| ]?63)|0)90885[0-9]{5}$)|(^(([+| ]?63)|0)908880(([0-1][0-9]{3})|(2(0[0-9]{2}|1[0-1][0-9])))$)|(^(([+| ]?63)|0)9188[0-9]{6}$)|(^(([+| ]?63)|0)92888[0-9]{5}$)|(^(([+| ]?63)|0)93999[0-9]{5}$)|(^(([+| ]?63)|0)949(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)94790[5-9][0-9]{4}$)|(^(([+| ]?63)|0)94791[3-6][0-9]{4}$)|(^(([+| ]?63)|0)94938[0-9]{5}$)|(^(([+| ]?63)|0)94951[0-9]{5}$)|(^(([+| ]?63)|0)90887[0-1][0-9]{4}$)|(^(([+| ]?63)|0)9299[8-9][0-9]{5}$)|(^(([+| ]?63)|0)9396[6-9][0-9]{5}$)|(^(([+| ]?63)|0)93970[0-9]{5}$)|(^(([+| ]?63)|0)9471[2-3][0-9]{5}$)|(^(([+| ]?63)|0)9476[7-8][0-9]{5}$)|(^(([+| ]?63)|0)9281[0-3][0-9]{5}$)|(^(([+| ]?63)|0)9495[2|4][0-9]{5}$)|(^(([+| ]?63)|0)94955[1-4][0-9]{4}$)|(^(([+| ]?63)|0)9991[1-4][0-9]{5}$)|(^(([+| ]?63)|0)9996[0|3|4][0-9]{5}$)' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'sun' carrier, 'mo' type, count(1) post, 0 pre from mui_ph_sun_1.bridge_out where status = 2 and tx_type = 'messaging' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_from REGEXP '((([+| ]?63)|0)9228[0-9]{6})|((([+| ]?63)|0)922922[0-9]{4})|((([+| ]?63)|0)9328[0-9]{6})' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'sun' carrier, 'mo' type, 0 post, count(1) pre from mui_ph_sun_1.bridge_out where status = 2 and tx_type = 'messaging' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_from not REGEXP '((([+| ]?63)|0)9228[0-9]{6})|((([+| ]?63)|0)922922[0-9]{4})|((([+| ]?63)|0)9328[0-9]{6})' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'globe' carrier, 'ukmo' type, count(distinct tx_from) post, 0 pre from mui_ph_globe_1.bridge_out where status = 2 and tx_type = 'messaging' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_from REGEXP '(^(([+| ]?63)|0)9173[0-2][0-9]{5,5}$)|(^(([+| ]?63)|0)9175[0-9]{6,6}$)|(^(([+| ]?63)|0)9176(2|3|5|7|8)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7|9)[0-9]{5,5}$)|(^(([+| ]?63)|0)9178[0-9][0-9]{5,5}$)|(^(([+| ]?63)|0)90599[0-9]{5,5}$)' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'globe' carrier, 'ukmo' type, 0 post, count(distinct tx_from) pre from mui_ph_globe_1.bridge_out where status = 2 and tx_type = 'messaging' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_from not REGEXP '(^(([+| ]?63)|0)9173[0-2][0-9]{5,5}$)|(^(([+| ]?63)|0)9175[0-9]{6,6}$)|(^(([+| ]?63)|0)9176(2|3|5|7|8)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7|9)[0-9]{5,5}$)|(^(([+| ]?63)|0)9178[0-9][0-9]{5,5}$)|(^(([+| ]?63)|0)90599[0-9]{5,5}$)' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'smart' carrier, 'ukmo' type, count(distinct tx_from) post, 0 pre from mui_ph_smart_1.bridge_out where status = 2 and tx_type = 'messaging' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_from REGEXP '(^(([+| ]?63)|0)94789[0-9]{5}$)|(^(([+| ]?63)|0)94799[0-9]{5}$)|(^(([+| ]?63)|0)9479171[0-9]{3}$)|(^(([+| ]?63)|0)947917[2-6][0-9]{3}$)|(^(([+| ]?63)|0)9088[1-4,6,9][0-9]{5}$)|(^(([+| ]?63)|0)90887[2-9][0-9]{4}$)|(^(([+| ]?63)|0)908880212[0-9]$)|(^(([+| ]?63)|0)9088802[2-9]{2}$)|(^(([+| ]?63)|0)908880[3-9]{3}$)|(^(([+| ]?63)|0)9189(0(0[1-9]|[1-9][0-9])|[12][0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)918930[0-9]{4}$)|(^(([+| ]?63)|0)91893[3-9][0-9]{4}$)|(^(([+| ]?63)|0)91894[0-8][0-9]{4}$)|(^(([+| ]?63)|0)9189(5|6)[0-9]{5}$)|(^(([+| ]?63)|0)91897([0-3][0-9]|4[0-8])[0-9]{3}$)|(^(([+| ]?63)|0)9189(7[5-9][0-9]|(8|9)[0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)91999[0-9]{5}$)|(^(([+| ]?63)|0)9209(0|1)[0-9]{5}$)|(^(([+| ]?63)|0)920932[6-9][0-9]{3}$)|(^(([+| ]?63)|0)920938[0-9]{4}$)|(^(([+| ]?63)|0)92094[5-9][0-9]{4}$)|(^(([+| ]?63)|0)9209[5-7,9][0-9]{5}$)|(^(([+| ]?63)|0)92855[0-9]{5}$)|(^(([+| ]?63)|0)9399(0|1|2|3|7|8)[0-9]{5}$)|(^(([+| ]?63)|0)999(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)9285[0-2][0-9]{5}$)|(^(([+| ]?63)|0)92092[0-8][0-9]{4}$)|(^(([+| ]?63)|0)920929[0-8][0-9]{3}$)|(^(([+| ]?63)|0)92094[0-4][0-9]{4}$)|(^(([+| ]?63)|0)90885[0-9]{5}$)|(^(([+| ]?63)|0)908880(([0-1][0-9]{3})|(2(0[0-9]{2}|1[0-1][0-9])))$)|(^(([+| ]?63)|0)9188[0-9]{6}$)|(^(([+| ]?63)|0)92888[0-9]{5}$)|(^(([+| ]?63)|0)93999[0-9]{5}$)|(^(([+| ]?63)|0)949(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)94790[5-9][0-9]{4}$)|(^(([+| ]?63)|0)94791[3-6][0-9]{4}$)|(^(([+| ]?63)|0)94938[0-9]{5}$)|(^(([+| ]?63)|0)94951[0-9]{5}$)|(^(([+| ]?63)|0)90887[0-1][0-9]{4}$)|(^(([+| ]?63)|0)9299[8-9][0-9]{5}$)|(^(([+| ]?63)|0)9396[6-9][0-9]{5}$)|(^(([+| ]?63)|0)93970[0-9]{5}$)|(^(([+| ]?63)|0)9471[2-3][0-9]{5}$)|(^(([+| ]?63)|0)9476[7-8][0-9]{5}$)|(^(([+| ]?63)|0)9281[0-3][0-9]{5}$)|(^(([+| ]?63)|0)9495[2|4][0-9]{5}$)|(^(([+| ]?63)|0)94955[1-4][0-9]{4}$)|(^(([+| ]?63)|0)9991[1-4][0-9]{5}$)|(^(([+| ]?63)|0)9996[0|3|4][0-9]{5}$)' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'smart' carrier, 'ukmo' type, 0 post, count(distinct tx_from) pre from mui_ph_smart_1.bridge_out where status = 2 and tx_type = 'messaging' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_from not REGEXP '(^(([+| ]?63)|0)94789[0-9]{5}$)|(^(([+| ]?63)|0)94799[0-9]{5}$)|(^(([+| ]?63)|0)9479171[0-9]{3}$)|(^(([+| ]?63)|0)947917[2-6][0-9]{3}$)|(^(([+| ]?63)|0)9088[1-4,6,9][0-9]{5}$)|(^(([+| ]?63)|0)90887[2-9][0-9]{4}$)|(^(([+| ]?63)|0)908880212[0-9]$)|(^(([+| ]?63)|0)9088802[2-9]{2}$)|(^(([+| ]?63)|0)908880[3-9]{3}$)|(^(([+| ]?63)|0)9189(0(0[1-9]|[1-9][0-9])|[12][0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)918930[0-9]{4}$)|(^(([+| ]?63)|0)91893[3-9][0-9]{4}$)|(^(([+| ]?63)|0)91894[0-8][0-9]{4}$)|(^(([+| ]?63)|0)9189(5|6)[0-9]{5}$)|(^(([+| ]?63)|0)91897([0-3][0-9]|4[0-8])[0-9]{3}$)|(^(([+| ]?63)|0)9189(7[5-9][0-9]|(8|9)[0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)91999[0-9]{5}$)|(^(([+| ]?63)|0)9209(0|1)[0-9]{5}$)|(^(([+| ]?63)|0)920932[6-9][0-9]{3}$)|(^(([+| ]?63)|0)920938[0-9]{4}$)|(^(([+| ]?63)|0)92094[5-9][0-9]{4}$)|(^(([+| ]?63)|0)9209[5-7,9][0-9]{5}$)|(^(([+| ]?63)|0)92855[0-9]{5}$)|(^(([+| ]?63)|0)9399(0|1|2|3|7|8)[0-9]{5}$)|(^(([+| ]?63)|0)999(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)9285[0-2][0-9]{5}$)|(^(([+| ]?63)|0)92092[0-8][0-9]{4}$)|(^(([+| ]?63)|0)920929[0-8][0-9]{3}$)|(^(([+| ]?63)|0)92094[0-4][0-9]{4}$)|(^(([+| ]?63)|0)90885[0-9]{5}$)|(^(([+| ]?63)|0)908880(([0-1][0-9]{3})|(2(0[0-9]{2}|1[0-1][0-9])))$)|(^(([+| ]?63)|0)9188[0-9]{6}$)|(^(([+| ]?63)|0)92888[0-9]{5}$)|(^(([+| ]?63)|0)93999[0-9]{5}$)|(^(([+| ]?63)|0)949(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)94790[5-9][0-9]{4}$)|(^(([+| ]?63)|0)94791[3-6][0-9]{4}$)|(^(([+| ]?63)|0)94938[0-9]{5}$)|(^(([+| ]?63)|0)94951[0-9]{5}$)|(^(([+| ]?63)|0)90887[0-1][0-9]{4}$)|(^(([+| ]?63)|0)9299[8-9][0-9]{5}$)|(^(([+| ]?63)|0)9396[6-9][0-9]{5}$)|(^(([+| ]?63)|0)93970[0-9]{5}$)|(^(([+| ]?63)|0)9471[2-3][0-9]{5}$)|(^(([+| ]?63)|0)9476[7-8][0-9]{5}$)|(^(([+| ]?63)|0)9281[0-3][0-9]{5}$)|(^(([+| ]?63)|0)9495[2|4][0-9]{5}$)|(^(([+| ]?63)|0)94955[1-4][0-9]{4}$)|(^(([+| ]?63)|0)9991[1-4][0-9]{5}$)|(^(([+| ]?63)|0)9996[0|3|4][0-9]{5}$)' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'sun' carrier, 'ukmo' type, count(distinct tx_from) post, 0 pre from mui_ph_sun_1.bridge_out where status = 2 and tx_type = 'messaging' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_from REGEXP '((([+| ]?63)|0)9228[0-9]{6})|((([+| ]?63)|0)922922[0-9]{4})|((([+| ]?63)|0)9328[0-9]{6})' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'sun' carrier, 'ukmo' type, 0 post, count(distinct tx_from) pre from mui_ph_sun_1.bridge_out where status = 2 and tx_type = 'messaging' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_from not REGEXP '((([+| ]?63)|0)9228[0-9]{6})|((([+| ]?63)|0)922922[0-9]{4})|((([+| ]?63)|0)9328[0-9]{6})' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'globe' carrier, 'ukmt' type, count(distinct tx_to) post, 0 pre from mui_ph_globe_1.bridge_out where status = 2 and tx_type = 'chat' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_to REGEXP '(^(([+| ]?63)|0)9173[0-2][0-9]{5,5}$)|(^(([+| ]?63)|0)9175[0-9]{6,6}$)|(^(([+| ]?63)|0)9176(2|3|5|7|8)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7|9)[0-9]{5,5}$)|(^(([+| ]?63)|0)9178[0-9][0-9]{5,5}$)|(^(([+| ]?63)|0)90599[0-9]{5,5}$)' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'globe' carrier, 'ukmt' type, 0 post, count(distinct tx_to) pre from mui_ph_globe_1.bridge_out where status = 2 and tx_type = 'chat' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_to not REGEXP '(^(([+| ]?63)|0)9173[0-2][0-9]{5,5}$)|(^(([+| ]?63)|0)9175[0-9]{6,6}$)|(^(([+| ]?63)|0)9176(2|3|5|7|8)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7)[0-9]{5,5}$)|(^(([+| ]?63)|0)9177(0|1|2|7|9)[0-9]{5,5}$)|(^(([+| ]?63)|0)9178[0-9][0-9]{5,5}$)|(^(([+| ]?63)|0)90599[0-9]{5,5}$)' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'smart' carrier, 'ukmt' type, count(distinct tx_to) post, 0 pre from mui_ph_smart_1.bridge_out where status = 2 and tx_type = 'chat' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_to REGEXP '(^(([+| ]?63)|0)94789[0-9]{5}$)|(^(([+| ]?63)|0)94799[0-9]{5}$)|(^(([+| ]?63)|0)9479171[0-9]{3}$)|(^(([+| ]?63)|0)947917[2-6][0-9]{3}$)|(^(([+| ]?63)|0)9088[1-4,6,9][0-9]{5}$)|(^(([+| ]?63)|0)90887[2-9][0-9]{4}$)|(^(([+| ]?63)|0)908880212[0-9]$)|(^(([+| ]?63)|0)9088802[2-9]{2}$)|(^(([+| ]?63)|0)908880[3-9]{3}$)|(^(([+| ]?63)|0)9189(0(0[1-9]|[1-9][0-9])|[12][0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)918930[0-9]{4}$)|(^(([+| ]?63)|0)91893[3-9][0-9]{4}$)|(^(([+| ]?63)|0)91894[0-8][0-9]{4}$)|(^(([+| ]?63)|0)9189(5|6)[0-9]{5}$)|(^(([+| ]?63)|0)91897([0-3][0-9]|4[0-8])[0-9]{3}$)|(^(([+| ]?63)|0)9189(7[5-9][0-9]|(8|9)[0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)91999[0-9]{5}$)|(^(([+| ]?63)|0)9209(0|1)[0-9]{5}$)|(^(([+| ]?63)|0)920932[6-9][0-9]{3}$)|(^(([+| ]?63)|0)920938[0-9]{4}$)|(^(([+| ]?63)|0)92094[5-9][0-9]{4}$)|(^(([+| ]?63)|0)9209[5-7,9][0-9]{5}$)|(^(([+| ]?63)|0)92855[0-9]{5}$)|(^(([+| ]?63)|0)9399(0|1|2|3|7|8)[0-9]{5}$)|(^(([+| ]?63)|0)999(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)9285[0-2][0-9]{5}$)|(^(([+| ]?63)|0)92092[0-8][0-9]{4}$)|(^(([+| ]?63)|0)920929[0-8][0-9]{3}$)|(^(([+| ]?63)|0)92094[0-4][0-9]{4}$)|(^(([+| ]?63)|0)90885[0-9]{5}$)|(^(([+| ]?63)|0)908880(([0-1][0-9]{3})|(2(0[0-9]{2}|1[0-1][0-9])))$)|(^(([+| ]?63)|0)9188[0-9]{6}$)|(^(([+| ]?63)|0)92888[0-9]{5}$)|(^(([+| ]?63)|0)93999[0-9]{5}$)|(^(([+| ]?63)|0)949(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)94790[5-9][0-9]{4}$)|(^(([+| ]?63)|0)94791[3-6][0-9]{4}$)|(^(([+| ]?63)|0)94938[0-9]{5}$)|(^(([+| ]?63)|0)94951[0-9]{5}$)|(^(([+| ]?63)|0)90887[0-1][0-9]{4}$)|(^(([+| ]?63)|0)9299[8-9][0-9]{5}$)|(^(([+| ]?63)|0)9396[6-9][0-9]{5}$)|(^(([+| ]?63)|0)93970[0-9]{5}$)|(^(([+| ]?63)|0)9471[2-3][0-9]{5}$)|(^(([+| ]?63)|0)9476[7-8][0-9]{5}$)|(^(([+| ]?63)|0)9281[0-3][0-9]{5}$)|(^(([+| ]?63)|0)9495[2|4][0-9]{5}$)|(^(([+| ]?63)|0)94955[1-4][0-9]{4}$)|(^(([+| ]?63)|0)9991[1-4][0-9]{5}$)|(^(([+| ]?63)|0)9996[0|3|4][0-9]{5}$)' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'smart' carrier, 'ukmt' type, 0 post, count(distinct tx_to) pre from mui_ph_smart_1.bridge_out where status = 2 and tx_type = 'chat' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_to not REGEXP '(^(([+| ]?63)|0)94789[0-9]{5}$)|(^(([+| ]?63)|0)94799[0-9]{5}$)|(^(([+| ]?63)|0)9479171[0-9]{3}$)|(^(([+| ]?63)|0)947917[2-6][0-9]{3}$)|(^(([+| ]?63)|0)9088[1-4,6,9][0-9]{5}$)|(^(([+| ]?63)|0)90887[2-9][0-9]{4}$)|(^(([+| ]?63)|0)908880212[0-9]$)|(^(([+| ]?63)|0)9088802[2-9]{2}$)|(^(([+| ]?63)|0)908880[3-9]{3}$)|(^(([+| ]?63)|0)9189(0(0[1-9]|[1-9][0-9])|[12][0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)918930[0-9]{4}$)|(^(([+| ]?63)|0)91893[3-9][0-9]{4}$)|(^(([+| ]?63)|0)91894[0-8][0-9]{4}$)|(^(([+| ]?63)|0)9189(5|6)[0-9]{5}$)|(^(([+| ]?63)|0)91897([0-3][0-9]|4[0-8])[0-9]{3}$)|(^(([+| ]?63)|0)9189(7[5-9][0-9]|(8|9)[0-9]{2})[0-9]{3}$)|(^(([+| ]?63)|0)91999[0-9]{5}$)|(^(([+| ]?63)|0)9209(0|1)[0-9]{5}$)|(^(([+| ]?63)|0)920932[6-9][0-9]{3}$)|(^(([+| ]?63)|0)920938[0-9]{4}$)|(^(([+| ]?63)|0)92094[5-9][0-9]{4}$)|(^(([+| ]?63)|0)9209[5-7,9][0-9]{5}$)|(^(([+| ]?63)|0)92855[0-9]{5}$)|(^(([+| ]?63)|0)9399(0|1|2|3|7|8)[0-9]{5}$)|(^(([+| ]?63)|0)999(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)9285[0-2][0-9]{5}$)|(^(([+| ]?63)|0)92092[0-8][0-9]{4}$)|(^(([+| ]?63)|0)920929[0-8][0-9]{3}$)|(^(([+| ]?63)|0)92094[0-4][0-9]{4}$)|(^(([+| ]?63)|0)90885[0-9]{5}$)|(^(([+| ]?63)|0)908880(([0-1][0-9]{3})|(2(0[0-9]{2}|1[0-1][0-9])))$)|(^(([+| ]?63)|0)9188[0-9]{6}$)|(^(([+| ]?63)|0)92888[0-9]{5}$)|(^(([+| ]?63)|0)93999[0-9]{5}$)|(^(([+| ]?63)|0)949(88|99)[0-9]{5}$)|(^(([+| ]?63)|0)94790[5-9][0-9]{4}$)|(^(([+| ]?63)|0)94791[3-6][0-9]{4}$)|(^(([+| ]?63)|0)94938[0-9]{5}$)|(^(([+| ]?63)|0)94951[0-9]{5}$)|(^(([+| ]?63)|0)90887[0-1][0-9]{4}$)|(^(([+| ]?63)|0)9299[8-9][0-9]{5}$)|(^(([+| ]?63)|0)9396[6-9][0-9]{5}$)|(^(([+| ]?63)|0)93970[0-9]{5}$)|(^(([+| ]?63)|0)9471[2-3][0-9]{5}$)|(^(([+| ]?63)|0)9476[7-8][0-9]{5}$)|(^(([+| ]?63)|0)9281[0-3][0-9]{5}$)|(^(([+| ]?63)|0)9495[2|4][0-9]{5}$)|(^(([+| ]?63)|0)94955[1-4][0-9]{4}$)|(^(([+| ]?63)|0)9991[1-4][0-9]{5}$)|(^(([+| ]?63)|0)9996[0|3|4][0-9]{5}$)' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'sun' carrier, 'ukmt' type, count(distinct tx_to) post, 0 pre from mui_ph_sun_1.bridge_out where status = 2 and tx_type = 'chat' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_to REGEXP '((([+| ]?63)|0)9228[0-9]{6})|((([+| ]?63)|0)922922[0-9]{4})|((([+| ]?63)|0)9328[0-9]{6})' group by datein, time_hh, carrier, type union all
select datein tran_dt, '00:00' time_hh, 'sun' carrier, 'ukmt' type, 0 post, count(distinct tx_to) pre from mui_ph_sun_1.bridge_out where status = 2 and tx_type = 'chat' and datein between date_sub(curdate(), interval 1 day) and curdate() and tx_to not REGEXP '((([+| ]?63)|0)9228[0-9]{6})|((([+| ]?63)|0)922922[0-9]{4})|((([+| ]?63)|0)9328[0-9]{6})' group by datein, time_hh, carrier, type
) t1 group by tran_dt, time_hh, carrier, type;


select 'DATE, TIME, GLOBE, GLOBE, GLOBE, GLOBE, GLOBE, GLOBE, GLOBE, GLOBE, GLOBE, GLOBE, SMART, SMART, SMART, SMART, SMART, SMART, SMART, SMART, SMART, SMART, SMART, SMART, SUN, SUN, SUN, SUN, SUN, SUN, SUN, SUN, SUN, SUN' union all 
select 'DATE, TIME, HITS, HITS, MT, MT, UKMT, UKMT, MO, MO, UKMO, UKMO, HITS, HITS, HITS, HITS, MT, MT, UKMT, UKMT, MO, MO, UKMO, UKMO, HITS, HITS, MT, MT, UKMT, UKMT, MO, MO, UKMO, UKMO' union all 
select 'DATE, TIME, PRE, POST, PRE, POST, PRE, POST, PRE, POST, PRE, POST, PRE, POST, PRE, POST, PRE, POST, PRE, POST, PRE, POST, PRE, POST, PRE, POST, PRE, POST, PRE, POST, PRE, POST, PRE, POST';

select tran_dt, hits_globe_pre, hits_globe_post, mt_globe_pre, mt_globe_post, ukmt_globe_pre, ukmt_globe_post, mo_globe_pre, mo_globe_post, ukmo_globe_pre, ukmo_globe_post, reg_globe_pre, reg_globe_post, hits_smart_8266_pre, hits_smart_8266_post, hits_smart_8267_pre, hits_smart_8267_post, mt_smart_pre, mt_smart_post, ukmt_smart_pre, ukmt_smart_post, mo_smart_pre, mo_smart_post, ukmo_smart_pre, ukmo_smart_post, reg_smart_pre, reg_smart_post, hits_sun_pre, hits_sun_post, mt_sun_pre, mt_sun_post, ukmt_sun_pre, ukmt_sun_post, mo_sun_pre, mo_sun_post, ukmo_sun_pre, ukmo_sun_post, reg_sun_pre, reg_sun_post
from ctm_stats
where tran_dt >= '2013-01-01' and tran_dt < '2013-02-01'
order by tran_dt, tran_tm
;


CTM V5 stats
-- Generate CSG stats (shrike -P3302)
call sp_generate_ctm_stats_mui()

-- GET MUI stats (DB7 -P2282)
echo "select tran_dt, tran_tm, carrier, type, post, pre from ctm_stats_dtl where tran_dt='`date '+%Y-%m-%d' -d '1 day ago'`'" | mysql -uctmv5 -pctmv5 test -h 112.199.83.115 -P3382 | grep -v "^tran_dt" > ctmv5.tmp

-- Load MUI stats (shrike -P3302) 
echo "load data local infile 'ctmv5.tmp' into table ctm_stats_dtl fields terminated by '\t'" | mysql -uctmv5 -pctmv5 test -h127.0.0.1 -P3302

-- Generate EOD stats (shrike -P3302)
echo "select stats from ctm_stats_daily where tran_dt = '`date '+%Y-%m-%d' -d '1 day ago'`' order by seq_no" | mysql -uctmv5 -pctmv5 test -h127.0.0.1 -P3302 | grep -v stats


select case when (carrier='globe') then 'Globe (P2.50)' case when (carrier='smart8266') then 'Smart (G8266)' case when (carrier='smart8267' then 'Smart (G8267' case when (carrier='sun' then 'Sun (P2.00)' else upper(carrier) END as carrier,  post+pre total, post, pre from ctm_stats_dtl where tran_dt = '2013-04-10' and type = 'hits';

create view ctm_stats_report as
select tran_dt,
       type tran_type,
       CASE when (type='hits') then
          CASE when (carrier='globe') then 'Globe (P2.50)' 
               when (carrier='smart8266') then 'Smart (G8266)' 
               when (carrier='smart8267') then 'Smart (G8267)' 
               when (carrier='sun') then 'Sun (P2.00)' 
               else upper(carrier) 
          END 
       ELSE          
          CASE when (carrier='globe') then 'Globe' 
               when (carrier='smart') then 'Smart' 
               when (carrier='sun') then 'Sun' 
               else upper(carrier) 
          END 
       END as carrier,
       post+pre as total,
       post,
       pre
from ctm_stats_dtl;
            
drop view ctm_stats_daily;
CREATE VIEW ctm_stats_daily AS 
select 0 AS seq_no, tran_dt AS tran_dt,concat('CTMv5 Stats as of ',date_format(ctm_stats_report.tran_dt,'%b %d,%Y')) AS stats from ctm_stats_report where (ctm_stats_report.tran_type = 'hits') group by ctm_stats_report.tran_dt union 
select 1 AS 1,ctm_stats_report.tran_dt AS tran_dt,'' AS stats from ctm_stats_report where (ctm_stats_report.tran_type = 'hits') group by ctm_stats_report.tran_dt union 
select 2 AS seq_no,ctm_stats_report.tran_dt AS tran_dt,'HITS' AS stats from ctm_stats_report where (ctm_stats_report.tran_type = 'hits') group by ctm_stats_report.tran_dt union 
select 3 AS 3,ctm_stats_report.tran_dt AS tran_dt,concat(ctm_stats_report.carrier,':',ctm_stats_report.total,'
   Pre:',ctm_stats_report.pre,'
   Post:',ctm_stats_report.post) AS stats from ctm_stats_report where (ctm_stats_report.tran_type = 'hits') union 
select 5 AS seq_no,ctm_stats_report.tran_dt AS tran_dt,'' AS stats from ctm_stats_report where (ctm_stats_report.tran_type = 'hits') group by ctm_stats_report.tran_dt union 
select 6 AS seq_no,ctm_stats_report.tran_dt AS tran_dt,'Total MO' AS stats from ctm_stats_report where (ctm_stats_report.tran_type = 'mo') group by ctm_stats_report.tran_dt union 
select 7 AS 7,ctm_stats_report.tran_dt AS tran_dt,concat(ctm_stats_report.carrier,':',ctm_stats_report.total,'
   Pre:',ctm_stats_report.pre,'
   Post:',ctm_stats_report.post) AS stats from ctm_stats_report where (ctm_stats_report.tran_type = 'mo') union 
select 9 AS seq_no,ctm_stats_report.tran_dt AS tran_dt,'' AS stats from ctm_stats_report where (ctm_stats_report.tran_type = 'mo') group by ctm_stats_report.tran_dt union 
select 10 AS seq_no,ctm_stats_report.tran_dt AS tran_dt,'Total MT' AS stats from ctm_stats_report where (ctm_stats_report.tran_type = 'mt') group by ctm_stats_report.tran_dt union 
select 11 AS 11,ctm_stats_report.tran_dt AS tran_dt,concat(ctm_stats_report.carrier,':',ctm_stats_report.total,'
   Pre:',ctm_stats_report.pre,'
   Post:',ctm_stats_report.post) AS stats from ctm_stats_report where (ctm_stats_report.tran_type = 'mt') union 
select 12 AS seq_no,ctm_stats_report.tran_dt AS tran_dt,'' AS stats from ctm_stats_report where (ctm_stats_report.tran_type = 'mt') group by ctm_stats_report.tran_dt


drop view ctm_stats_daily;
create view ctm_stats_daily as
select 0 seq_no, tran_dt, concat('CTMv5 Stats as of ', date_format(tran_dt, '%b %d,%Y')) stats from ctm_stats_report where tran_type='hits' group by tran_dt union
select 1, tran_dt, '' stats from ctm_stats_report where tran_type = 'hits' group by tran_dt union
select 2 seq_no, tran_dt, 'HITS (Charged transactions only)' stats from ctm_stats_report where tran_type='hits' group by tran_dt union
select 3, tran_dt, concat(carrier, ': ', total,'
   Pre: ', pre, '
   Post: ', post) stats from ctm_stats_report where tran_type = 'hits' union
select 5 seq_no, tran_dt, '' stats from ctm_stats_report where tran_type='hits' group by tran_dt union
select 6 seq_no, tran_dt, 'Messages Sent (MO & AO)' stats from ctm_stats_report where tran_type='mo' group by tran_dt union
select 7, tran_dt, concat(carrier, ': ', total,'
   Pre: ', pre, '
   Post: ', post) stats from ctm_stats_report where tran_type = 'mo' union
select 9 seq_no, tran_dt, '' stats from ctm_stats_report where tran_type='mo' group by tran_dt union
select 10 seq_no, tran_dt, 'Messages Received (MT & AT)' stats from ctm_stats_report where tran_type='mt' group by tran_dt union
select 11, tran_dt, concat(carrier, ': ', total,'
   Pre: ', pre, '
   Post: ', post) stats from ctm_stats_report where tran_type = 'mt' union
select 12 seq_no, tran_dt, '' stats from ctm_stats_report where tran_type='mt' group by tran_dt union
select 13 seq_no, tran_dt, 'Registration' stats from ctm_stats_report where tran_type='reg' group by tran_dt union
select 14, tran_dt, concat(carrier, ': ', total,'
   Pre: ', pre, '
   Post: ', post) stats from ctm_stats_report where tran_type = 'reg' and carrier <> 'OTHERS' union
select 15, tran_dt, concat('Others', ': ', pre) stats from ctm_stats_report where tran_type = 'reg' and carrier = 'OTHERS' union
select 16 seq_no, tran_dt, '' stats from ctm_stats_report where tran_type='login' group by tran_dt union
select 17 seq_no, tran_dt, 'Sign-in via' stats from ctm_stats_report where tran_type='login' group by tran_dt union
select 18, tran_dt, concat(' ', case when (carrier='IOS') THEN 'iOS' 
                                     when (carrier='ANDROID') THEN 'Android' 
                                     when (carrier='CHROME') THEN 'Chrome' 
                                     when (carrier='CLIENT') THEN 'Client' 
                                     when (carrier='WEB') THEN 'Web' 
                                     else lower(carrier) end, ': ', pre) stats from ctm_stats_report where tran_type = 'login' and carrier <> 'OTHERS' union
select 19, tran_dt, concat(' ', 'Others', ': ', pre) stats from ctm_stats_report where tran_type = 'login' and carrier = 'OTHERS' union
select 20 seq_no, tran_dt, '' stats from ctm_stats_report where tran_type='login' group by tran_dt union
select 21 seq_no, tran_dt, 'Unique Message Senders' stats from ctm_stats_report where tran_type='ukmo' group by tran_dt union
select 22, tran_dt, concat(carrier, ': ', total,'
   Pre: ', pre, '
   Post: ', post) stats from ctm_stats_report where tran_type = 'ukmo' union
select 23 seq_no, tran_dt, '' stats from ctm_stats_report where tran_type='ukmo' group by tran_dt union
select 24 seq_no, tran_dt, 'Unique Message Recipients' stats from ctm_stats_report where tran_type='ukmt' group by tran_dt union
select 25, tran_dt, concat(carrier, ': ', total,'
   Pre: ', pre, '
   Post: ', post) stats from ctm_stats_report where tran_type = 'ukmt' union
select 26 seq_no, tran_dt, '' stats from ctm_stats_report where tran_type='ukmt' group by tran_dt union
select 27 seq_no, tran_dt, concat ('P2P Messages:', pre) stats from ctm_stats_report where tran_type='p2p' group by tran_dt
;



create view ctm_stats as 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, sum(pre) hits_sun_pre, sum(post) hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'sun' and type = 'hits'
group  by tran_dt
union all 
select tran_dt, sum(pre) hits_globe_pre, sum(post) hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'globe' and type = 'hits'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, sum(pre) hits_smart_8266_pre, sum(post) hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'smart8266' and type = 'hits'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, sum(pre) hits_smart_8267_pre, sum(post) hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'smart8267' and type = 'hits'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, sum(pre) mt_globe_pre, sum(post) mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'globe' and type = 'mt'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, sum(pre) mt_smart_pre, sum(post) mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'smart' and type = 'mt'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, sum(pre)  mt_sun_pre, sum(post) mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'sun' and type = 'mt'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, sum(pre) mo_globe_pre, sum(post) mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'globe' and type = 'mo'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, sum(pre) mo_smart_pre, sum(post) mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'smart' and type = 'mo'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, sum(pre) mo_sun_pre, sum(post) mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'sun' and type = 'mo'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, sum(pre) ukmo_globe_pre, sum(post) ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'globe' and type = 'ukmo'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, sum(pre) ukmo_smart_pre, sum(post) ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'smart' and type = 'ukmo'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, sum(pre) ukmo_sun_pre, sum(post) ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'sun' and type = 'ukmo'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, sum(pre) ukmt_globe_pre, sum(post) ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'globe' and type = 'ukmt'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0 mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, sum(pre) ukmt_smart_pre, sum(post) ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'smart' and type = 'ukmt'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, sum(pre) ukmt_sun_pre, sum(post) ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'sun' and type = 'ukmt'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, sum(pre) reg_globe_pre, sum(post) reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'globe' and type = 'reg'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, sum(pre) reg_smart_pre, sum(post) reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'smart' and type = 'reg'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, sum(pre) reg_sun_pre, sum(post) reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'sun' and type = 'reg'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, sum(pre) login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'android' and type = 'login'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, sum(pre) login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'chrome' and type = 'login'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, sum(pre) login_client, 0 login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'client' and type = 'login'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, sum(pre) login_ios, 0 login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'ios' and type = 'login'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, sum(pre) login_web, 0 login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'web' and type = 'login'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, sum(pre) login_others, 0 p2p_msg
from ctm_stats_dtl
where carrier = 'others' and type = 'login'
group  by tran_dt
union all 
select tran_dt, 0 hits_globe_pre, 0 hits_globe_post, 0 hits_smart_8266_pre, 0 hits_smart_8266_post, 0 hits_smart_8267_pre, 0 hits_smart_8267_post, 0 hits_sun_pre, 0 hits_sun_post, 0 mo_globe_pre, 0 mo_globe_post, 0 mo_smart_pre, 0 mo_smart_post, 0 mo_sun_pre, 0 mo_sun_post, 0 mt_globe_pre, 0 mt_globe_post, 0 mt_smart_pre, 0 mt_smart_post, 0  mt_sun_pre, 0 mt_sun_post, 0 ukmo_globe_pre, 0 ukmo_globe_post, 0 ukmo_smart_pre, 0 ukmo_smart_post, 0 ukmo_sun_pre, 0 ukmo_sun_post, 0 ukmt_globe_pre, 0 ukmt_globe_post, 0 ukmt_smart_pre, 0 ukmt_smart_post, 0 ukmt_sun_pre, 0 ukmt_sun_post, 0 reg_globe_pre, 0 reg_globe_post, 0 reg_smart_pre, 0 reg_smart_post, 0 reg_sun_pre, 0 reg_sun_post, 0 login_android, 0 login_chrome, 0 login_client, 0 login_ios, 0 login_web, 0 login_others, sum(pre) p2p_msg
from ctm_stats_dtl
where type = 'p2p'
group  by tran_dt;

create view ctm_stats_summary as 
select tran_dt, 
       left(tran_dt, 7) tran_mm, 
       sum(hits_globe_pre) hits_globe_pre, 
       sum(hits_globe_post) hits_globe_post, 
       sum(mt_globe_pre) mt_globe_pre, 
       sum(mt_globe_post) mt_globe_post, 
       sum(ukmt_globe_pre) ukmt_globe_pre, 
       sum(ukmt_globe_post) ukmt_globe_post, 
       sum(mo_globe_pre) mo_globe_pre, 
       sum(mo_globe_post) mo_globe_post, 
       sum(ukmo_globe_pre) ukmo_globe_pre, 
       sum(ukmo_globe_post) ukmo_globe_post, 
       sum(reg_globe_pre) reg_globe_pre, 
       sum(reg_globe_post) reg_globe_post,
       sum(hits_smart_8266_pre) hits_smart_8266_pre, 
       sum(hits_smart_8266_post) hits_smart_8266_post, 
       sum(hits_smart_8267_pre) hits_smart_8267_pre, 
       sum(hits_smart_8267_post) hits_smart_8267_post, 
       sum(mt_smart_pre) mt_smart_pre, 
       sum(mt_smart_post) mt_smart_post, 
       sum(ukmt_smart_pre) ukmt_smart_pre, 
       sum(ukmt_smart_post) ukmt_smart_post, 
       sum(mo_smart_pre) mo_smart_pre, 
       sum(mo_smart_post) mo_smart_post, 
       sum(ukmo_smart_pre) ukmo_smart_pre, 
       sum(ukmo_smart_post) ukmo_smart_post, 
       sum(reg_smart_pre) reg_smart_pre,
       sum(reg_smart_post) reg_smart_post, 
       sum(hits_sun_pre) hits_sun_pre, 
       sum(hits_sun_post) hits_sun_post, 
       sum(mt_sun_pre) mt_sun_pre, 
       sum(mt_sun_post) mt_sun_post, 
       sum(ukmt_sun_pre) ukmt_sun_pre, 
       sum(ukmt_sun_post) ukmt_sun_post,
       sum(mo_sun_pre) mo_sun_pre, 
       sum(mo_sun_post) mo_sun_post, 
       sum(ukmo_sun_pre) ukmo_sun_pre, 
       sum(ukmo_sun_post) ukmo_sun_post, 
       sum(reg_sun_pre) reg_sun_pre,   
       sum(reg_sun_post) reg_sun_post,  
       sum(login_android) login_android, 
       sum(login_chrome) login_chrome,  
       sum(login_client) login_client,  
       sum(login_ios) login_ios,     
       sum(login_web) login_web,     
       sum(login_others) login_others,     
       sum(p2p_msg) p2p_msg   
from ctm_stats
group  by tran_dt, left(tran_dt, 7)
;
