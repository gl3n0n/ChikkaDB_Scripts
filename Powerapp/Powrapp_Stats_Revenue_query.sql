truncate table tmp_active_stats;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log_2013_11 where free='false' group by 1,2;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log_2013_12 where free='false' group by 1,2;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log_2014_01 where free='false' group by 1,2;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log_2014_02 where free='false' group by 1,2;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log_2014_03 where free='false' group by 1,2;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log_2014_04 where free='false' group by 1,2;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log_2014_05 where free='false' group by 1,2;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log_2014_06 where free='false' group by 1,2;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log_2014_07 where free='false' group by 1,2;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log_2014_08 where free='false' group by 1,2;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log_2014_09 where free='false' group by 1,2;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log_2014_10 where free='false' group by 1,2;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log_2014_11 where free='false' group by 1,2;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log_2014_12 where free='false' group by 1,2;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log_2015_01 where free='false' group by 1,2;
insert into tmp_active_stats select left(datein,10), brand, count(distinct phone) uniq, count(1) hits from powerapp_log where datein >= '2015-02-01' and free='false' group by 1,2;


   insert into powerapp_sun_brand_dailyrep
   select tran_dt, plan, sum(hits_pre), sum(hits_ppd), sum(hits_tnt), sum(hits_tot), sum(uniq_pre), sum(uniq_ppd), sum(uniq_tnt), sum(uniq_tot) from (
   select left(datein, 10) tran_dt, plan, count(1) hits_pre, 0 hits_ppd, 0 hits_tnt, 0 hits_tot, count(distinct phone) uniq_pre, 0 uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_sun.powerapp_log where free='false' and brand='PREPAID' group by tran_dt, plan union
   select left(datein, 10) tran_dt, plan, 0 hits_pre, count(1) hits_ppd, 0 hits_tnt, 0 hits_tot, 0 uniq_pre, count(distinct phone) uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_sun.powerapp_log where free='false' and brand='POSTPAID' group by tran_dt, plan union
   select left(datein, 10) tran_dt, plan, 0 hits_pre, 0 hits_ppd, 0 hits_tnt, count(1) hits_tot, 0 uniq_pre, 0 uniq_ppd, 0 uniq_tnt, count(distinct phone) uniq_tot from powerapp_sun.powerapp_log where free='false' group by tran_dt, plan
   ) temp_table group by tran_dt, plan;

select date_format(tran_dt, '%Y-%b') Month, sum(total_hits) total_hits, sum(total_amt) total_amt
from (
select s.tran_dt tran_dt, sum(s.hits_tot) total_hits, sum(s.hits_tot*m.price) total_amt
from powerapp_sun_brand_dailyrep s, powerapp_plan_services_mapping m
where s.plan=m.plan
group by s.tran_dt
) t1a group by 1 order by tran_dt;

+----------+------------+-----------+
| Month    | total_hits | total_amt |
+----------+------------+-----------+
| 2014-Jul |        216 |      1505 |
| 2014-Aug |     123939 |    432940 |
| 2014-Sep |     430621 |   1495430 |
| 2014-Oct |     343753 |   1240410 |
| 2014-Nov |     252726 |    766495 |
| 2014-Dec |     249071 |    888670 |
| 2015-Jan |     246104 |    936110 |
| 2015-Feb |     227359 |    903355 |
| 2015-Mar |     293177 |   1100035 |
| 2015-Apr |     203960 |    556180 |
| 2015-May |     167651 |    402500 |
+----------+------------+-----------+


+---------+--------+
| Month   | uniq   |
+---------+--------+
| 2014-07 |     19 |
| 2014-08 |  58575 |
| 2014-09 | 111444 |
| 2014-10 |  59263 |
| 2014-11 |  33604 |
| 2014-12 |  32952 |
| 2015-01 |  31264 |
| 2015-02 |  28918 |
| 2015-03 |  33986 |
| 2015-04 |  30578 |
| 2015-05 |  21995 |
+---------+--------+

select date_format(txDate, '%Y-%b') Month, sum(buddy+tnt+postpd) Total,
        sum(buddy) Buddy, sum(tnt) TNT, sum(postpd) Postpd
from (
select concat(left(tx_date,7), '-01') txDate, sum(uniq) buddy, 0 tnt, 0 postpd from tmp_active_stats where brand = 'BUDDY' group by 1 union
select concat(left(tx_date,7), '-01') txDate, 0 buddy, sum(uniq) tnt, 0 postpd from tmp_active_stats where brand = 'TNT' group by 1 union
select concat(left(tx_date,7), '-01') txDate, 0 buddy, 0 tnt, sum(uniq) postpd from tmp_active_stats where brand = 'POSTPD' group by 1
) a group by 1
order by txDate;

select left(tran_dt,7) Month, sum(hits_pre+hits_tnt+hits_ppd) total, 
       sum(hits_pre), sum(hits_tnt), sum(hits_ppd)
from powerapp_flu.powerapp_brand_dailyrep
where plan in ('BACKTOSCHOOL','BESTEVER','CHAT','EMAIL','FACEBOOK','FREE_SOCIAL',
               'FY5','LINE','PHOTO','PISONET','SNAPCHAT','SOCIAL','SPEEDBOOST',
               'TUMBLR','UNLI','WAZE','WECHAT','WIKIPEDIA','YOUTUBE')
group by 1;


select tx_date Date, sum(buddy+tnt+postpd) Total,
        sum(buddy) Buddy, sum(tnt) TNT, sum(postpd) Postpd
from (
select tx_date, sum(uniq) buddy, 0 tnt, 0 postpd from tmp_active_stats where brand = 'BUDDY' group by 1 union
select tx_date, 0 buddy, sum(uniq) tnt, 0 postpd from tmp_active_stats where brand = 'TNT' group by 1 union
select tx_date, 0 buddy, 0 tnt, sum(uniq) postpd from tmp_active_stats where brand = 'POSTPD' group by 1
) a 
where left(tx_date,7) = '2014-07'
group by 1
order by 1;


+----------+---------+---------+---------+--------+  +----------+------------+-----------+-----------+----------+---------+
| Month    | Total   | Buddy   | TNT     | Postpd |  | Month    | total_hits | total_amt | buddy_amt | tnt_amt  | ppd_amt |
+----------+---------+---------+---------+--------+  +----------+------------+-----------+-----------+----------+---------+
| 2013-Nov |     737 |     562 |      20 |    155 |  | 2013-Nov |        737 |      7245 |      5515 |      215 |    1515 |
| 2013-Dec |   67321 |   42208 |   23698 |   1415 |  | 2013-Dec |      67321 |    699835 |    441575 |   240760 |   17500 |
| 2014-Jan |  260536 |  179489 |   75938 |   5109 |  | 2014-Jan |     260536 |   2732545 |   1900225 |   777020 |   55300 |
| 2014-Feb |  791252 |  383028 |  395078 |  13146 |  | 2014-Feb |     791298 |   1131675 |    785800 |   305825 |   40050 |
| 2014-Mar | 2007346 | 1028888 |  956612 |  21846 |  | 2014-Mar |    2012177 |   1621035 |   1144035 |   417925 |   59075 |
| 2014-Apr | 4379903 | 2661864 | 1675751 |  42288 |  | 2014-Apr |    4517486 |   2207600 |   1535140 |   582060 |   90400 |
| 2014-May | 4714571 | 2798874 | 1873548 |  42149 |  | 2014-May |    4815348 |   5858375 |   4903675 |   770390 |  184310 |
| 2014-Jun | 2630298 | 1301342 | 1304023 |  24933 |  | 2014-Jun |    2675655 |   9793664 |   7020089 |  2554259 |  219316 |
| 2014-Jul | 2589014 | 1445789 | 1111663 |  31562 |  | 2014-Jul |    2629005 |  15225790 |   8884639 |  6085392 |  255759 |
| 2014-Aug | 3723622 | 1828040 | 1859324 |  36258 |  | 2014-Aug |    3666112 |  22666426 |  12133974 | 10270637 |  261815 |
| 2014-Sep | 4730680 | 2370211 | 2321861 |  38608 |  | 2014-Sep |    4789084 |  28163746 |  15546956 | 12323785 |  293005 |
| 2014-Oct | 3438318 | 1862756 | 1539966 |  35596 |  | 2014-Oct |    3562094 |  23728346 |  15632419 |  7797582 |  298345 |
| 2014-Nov | 2351444 | 1349267 |  974186 |  27991 |  | 2014-Nov |    2541904 |  16503563 |  11158563 |  5107785 |  237215 |
| 2014-Dec | 1994430 | 1119814 |  850504 |  24112 |  | 2014-Dec |    2217411 |  14998338 |   9897970 |  4882128 |  218240 |
| 2015-Jan | 2100327 | 1056802 | 1017980 |  25545 |  | 2015-Jan |   18058545 |  15803942 |   9898392 |  5670060 |  235490 |
| 2015-Feb | 2438870 |  938301 | 1474750 |  25819 |  | 2015-Feb |    2622473 |  15765255 |   8949032 |  6546088 |  270135 |
| 2015-Mar | 3216825 | 1388671 | 1789365 |  38789 |  | 2015-Mar |    3670331 |  22340564 |  13155762 |  8751402 |  433400 |
| 2015-Apr | 1533340 |  899187 |  608243 |  25910 |  | 2015-Apr |    1762639 |  10676073 |   7309180 |  3096323 |  270570 |
+----------+---------+---------+---------+--------+  +----------+------------+-----------+-----------+----------+---------+
                                                     
select plan, tran_dt, sum(total_hits) total_hits,
select date_format(tran_dt, '%Y-%b') Month, sum(total_hits) total_hits,
       sum(buddy_amt+tnt_amt+ppd_amt) total_amt,
       sum(buddy_amt) buddy_amt, sum(tnt_amt) tnt_amt, sum(ppd_amt) ppd_amt 
from (
select s.tran_dt tran_dt,sum((s.hits_pre+s.hits_tnt+s.hits_ppd)) total_hits, 
       sum(s.hits_pre) buddy_hits, sum(s.hits_tnt) tnt_hits, sum(s.hits_ppd) ppd_hits,
       sum((s.hits_pre+s.hits_tnt+s.hits_ppd)*(m.price)) total_amt,  
       sum(s.hits_pre*(m.price)) buddy_amt, sum(s.hits_tnt*(m.price)) tnt_amt, sum(s.hits_ppd*(m.price)) ppd_amt
from powerapp_brand_dailyrep s, powerapp_plan_services_mapping m
where s.plan=m.plan
group by s.tran_dt
) t1a group by 1 order by tran_dt;
) t1a group by plan, tran_dt order by plan, tran_dt;

select tran_dt, sum(total_hits) total_hits,
       sum(buddy_hits) buddy_hits, sum(tnt_hits) tnt_hits, sum(ppd_hits) ppd_hits
from (
select s.tran_dt tran_dt, s.plan, sum((s.hits_pre+s.hits_tnt+s.hits_ppd)) total_hits, 
       sum(s.hits_pre) buddy_hits, sum(s.hits_tnt) tnt_hits, sum(s.hits_ppd) ppd_hits
from powerapp_brand_dailyrep s
group by s.tran_dt
) t1a group by tran_dt order by tran_dt;

s.plan in ('BACKTOSCHOOL','BESTEVER','CHAT','EMAIL','FACEBOOK','FREE_SOCIAL',
               'FY5','LINE','PHOTO','PISONET','SNAPCHAT','SOCIAL','SPEEDBOOST',
               'TUMBLR','UNLI','WAZE','WECHAT','WIKIPEDIA','YOUTUBE')
and 

select s.plan, m.plan, m.service
from powerapp_sun_brand_dailyrep s, powerapp_plan_services_mapping m
where  s.plan=m.plan
group by 1;
+------------+-------+---------------+---------------+---------------+
| tran_dt    | total | sum(hits_pre) | sum(hits_tnt) | sum(hits_ppd) |
+------------+-------+---------------+---------------+---------------+
| 2014-12-01 | 75247 |         42051 |         32343 |           853 |
| 2014-12-04 | 73364 |         42054 |         30462 |           848 |
| 2014-12-05 | 75102 |         43005 |         31195 |           902 |
| 2014-12-06 | 74809 |         42496 |         31398 |           915 |
| 2014-12-07 | 72593 |         40578 |         31068 |           947 |
| 2014-12-08 | 73528 |         41167 |         31548 |           813 |
| 2014-12-09 | 73877 |         41972 |         31059 |           846 |
| 2014-12-10 | 70638 |         40300 |         29527 |           811 |
| 2014-12-11 | 70859 |         40985 |         29109 |           765 |
| 2014-12-12 | 68584 |         40362 |         27386 |           836 |
| 2014-12-13 | 68023 |         39705 |         27426 |           892 |
| 2014-12-14 | 67368 |         38869 |         27630 |           869 |
| 2014-12-15 | 66163 |         38426 |         26916 |           821 |
| 2014-12-16 | 64646 |         38047 |         25804 |           795 |
| 2014-12-17 | 64213 |         37083 |         26291 |           839 |
| 2014-12-18 | 70343 |         37454 |         32065 |           824 |
| 2014-12-19 | 67826 |         38019 |         28996 |           811 |
| 2014-12-20 | 66838 |         37520 |         28466 |           852 |
| 2014-12-21 | 65536 |         36446 |         28310 |           780 |
| 2014-12-22 | 67767 |         37255 |         29669 |           843 |
| 2014-12-23 | 69293 |         37339 |         31176 |           778 |
| 2014-12-24 | 72694 |         38501 |         33314 |           879 |
| 2014-12-25 | 65371 |         34908 |         29683 |           780 |
| 2014-12-26 | 69184 |         37315 |         31029 |           840 |
| 2014-12-27 | 68586 |         36713 |         31025 |           848 |
| 2014-12-28 | 67297 |         36840 |         29638 |           819 |
| 2014-12-29 | 66205 |         36242 |         29114 |           849 |
| 2014-12-30 | 64662 |         34850 |         28976 |           836 |
| 2014-12-31 | 68148 |         36103 |         31239 |           806 |
+------------+-------+---------------+---------------+---------------+

select tx_date, sum(hits) hits from archive_powerapp_flu.tmp_active_stats where tx_date >='2014-12-01' and tx_date < '2015-01-01' group by 1;
select tran_dt, 
       (unli_hits+email_hits+chat_hits+photo_hits+social_hits+speed_hits+line_hits+
        snap_hits+tumblr_hits+waze_hits+wechat_hits+wiki_hits+piso_hits+free_social_hits+
        facebook_hits+school_hits+coc_hits+youtube_hits+fy5_hits) total 
from powerapp_flu.powerapp_dailyrep
where tran_dt >='2014-12-01' and tran_dt < '2015-01-01';
 
select concat('insert ignore into powerapp_plan_services_mapping values (''', plan, ''',''', lower(plan), 'Service'',0);') as sql_s from powerapp_flu.powerapp_brand_dailyrep group by 1;
update powerapp_plan_services_mapping set price=10 where plan in ('CHAT','EMAIL','PHOTO','SOCIAL');
update powerapp_plan_services_mapping set price=5 where plan in ('LINE','SNAPCHAT','TUMBLR','WAZE','WECHAT','SPEEDBOOST','BACKTOSCHOOL','VIDEO5','FACEBOOK');
update powerapp_plan_services_mapping set price=20 where plan='UNLI';

select DATE_FORMAT(tran_dt,'%m/%d/%Y') Date,
                      chat_hits_24*10 chat,
                      email_hits_24*10 email,
                      (photo_hits_24_pp*10)+(photo_hits_24*10) photo,
                      (unli_hits_24_pp*20)+(unli_hits_24*20) unli,
                      speed_hits*5 speed,
                      (social_hits_24_pp*10)+(social_hits_24*10) social,
                      (line_hits_24_pp*5)+(line_hits_24*5) line,
                      snap_hits_24*5 snap,
                      tumblr_hits_24*5 tumblr,
                      waze_hits_24*5 waze,
                      (wechat_hits_24_pp*5)+(wechat_hits_24*5) wechat,
                      facebook_hits_24*5 facebook,
                      wiki_hits_24*0 wiki,
                      free_social_hits_24*0 free,
                      piso_hits_15*1 piso,
                      school_hits_24*5 social,
                      youtube_hits_5*5 youtube_5,
                      youtube_hits_15*15 youtube_15,
                      youtube_hits_50*50 youtube_50,
                      youtube_hits_120*120 youtube_120,
                      fy5_hits_5*5 fy5,
                      total_hits total_hits
                from  powerapp_flu.powerapp_validity_dailyrep
                order by tran_dt;

powerapp_dailyrep
;





insert into tmp_facebook_udr_log (tx_date, phone, src, tx_time, tx_usage)
select tx_date, phone, 'udr_1' src, sum(end_time-strt_time), sum(b_usage) from udr_1 where tx_date = '2015-04-15' group by tx_date, phone, 3;
drop procedure if exists sp_generate_facebook_usage;
delimiter //
create procedure sp_generate_facebook_usage (p_trandate date)
begin
   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   delete from tmp_facebook_udr_log where tx_date = p_trandate;
   set @nTableCnt  = 50;
   set @nCtr  = 0;
   while (@nCtr <= @nTableCnt)
   do 
      SET @nCtr  = @nCtr + 1; 
      if @nCtr < (@nTableCnt+1) then
         SET @vSql = '';
         SET @vSql = concat('insert into tmp_facebook_udr_log (tx_date, phone, src, tx_time, tx_usage) ',
                            'select tx_date, phone, ''udr_',  @nCtr, ''' src, ', 
                                   'sum(time_to_sec(timediff(if(end_time<strt_time, date_add(concat(tx_date, '' '', end_time), interval 1 day), concat(tx_date, '' '', end_time)), ',
                                   'concat(tx_date, '' '',strt_time)))) tx_time, ',
                                   'sum(b_usage) tx_usage ',
                            'from udr_', @nCtr, ' ',
                            'where tx_date = ''', p_trandate, ''' ',
                            -- 'and service = ''FacebookService'' ',
                            'group by tx_date, phone, 3 ',
                            'having sum(b_usage) > 0');
         if @nCtr = 1 then
            select @vSql;
         end if;
         PREPARE stmt FROM @vSql;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;
      end if;
   end while;
end;
//
delimiter ;
call sp_generate_facebook_usage('2015-04-15');
call sp_generate_facebook_usage('2015-04-16');
call sp_generate_facebook_usage('2015-04-17');
call sp_generate_facebook_usage('2015-04-18');


select tx_date, phone,  concat(tx_date, ' ',strt_time) start_tm,
       if(end_time<strt_time, date_add(concat(tx_date, ' ', end_time), interval 1 day), concat(tx_date, ' ', end_time)) end_tm,
       time_to_sec(timediff(if(end_time<strt_time, date_add(concat(tx_date, ' ', end_time), interval 1 day), concat(tx_date, ' ', end_time)), 
       concat(tx_date, ' ',strt_time))) tx_time, 
       b_usage tx_usage, service
from  udr_15 where tx_date='2015-05-16' and phone = '639081000997';



select tx_date, count(phone) uniq, round(avg(tx_time)/60,2) avg_tm, round(sum(tx_time)/60,2) tot_tm, round(sum(tx_usage)/1000000,2) tot_usage 
from (
      insert into tmp_facebook_user_log (tx_date, phone, tx_time, tx_usage)
      select tx_date, phone, sum(tx_time) tx_time, sum(tx_usage) tx_usage 
      from tmp_facebook_udr_log 
       group by tx_date, phone
     ) t1 group by tx_date;

select a.tx_date, b.brand, sum(a.tx_time) tx_time, sum(a.tx_usage) tx_usage, avg(a.tx_time) tx_avg_tm, count(a.phone) uniq 
from tmp_facebook_user_log a left outer join archive_powerapp_flu.powerapp_users b on (a.phone=b.phone) 
group by a.tx_date, b.brand
order by b.brand, a.tx_date;

+------------+--------+--------+-------------+------------+
| tx_date    | uniq   | avg_tm | tot_tm      | tot_usage  |
+------------+--------+--------+-------------+------------+
| 2015-04-15 |  26688 |  12.17 |   324826.08 |    8721.82 |
| 2015-04-16 |  74402 | 302.35 | 22495682.60 |  411347.75 |
| 2015-04-17 | 384219 | 141.89 | 54516244.93 | 1039039.64 |
| 2015-04-18 | 204165 | 210.96 | 43071219.82 |  621981.09 |
| 2015-04-19 |  72526 |  73.56 |  5334983.85 |   87266.36 |
| 2015-04-24 | 361147 | 133.32 | 48147353.75 |  962606.77 |
| 2015-04-25 | 410887 | 166.79 | 68531312.98 | 1380376.10 |
| 2015-04-26 | 333135 | 183.37 | 61085787.92 | 1248477.22 |
| 2015-04-27 | 328735 | 184.02 | 60494875.08 | 1262327.90 |
| 2015-04-28 |  60652 |  14.02 |   850423.22 |   19068.35 |
| 2015-04-29 | 327330 | 189.78 | 62120465.67 | 1348819.81 |
| 2015-04-30 | 327827 | 189.01 | 61962422.55 | 1359574.79 |
| 2015-05-01 | 325472 | 189.18 | 61574370.60 | 1389555.53 |
| 2015-05-02 | 326636 | 191.27 | 62475115.35 | 1452330.00 |
| 2015-05-03 | 320196 | 190.67 | 61052222.98 | 1427796.46 |
| 2015-05-04 | 335250 | 188.04 | 63039486.72 | 1464793.50 |
| 2015-05-05 | 321588 | 160.13 | 51497256.43 | 1175118.25 |
| 2015-05-06 | 332999 | 178.78 | 59532071.22 | 1405259.11 |
| 2015-05-07 | 285235 | 202.51 | 57761679.42 | 1400537.47 |
| 2015-05-08 | 276337 | 208.67 | 57663534.65 | 1422594.91 |
| 2015-05-09 | 275384 | 207.36 | 57102342.78 | 1438535.19 |
| 2015-05-10 | 273962 | 193.44 | 52994304.68 | 1344264.93 |
| 2015-05-11 | 274342 | 179.76 | 49314814.73 | 1231920.66 |
| 2015-05-12 | 277595 | 180.78 | 50183031.53 | 1242918.65 |
| 2015-05-13 | 270925 | 177.51 | 48092479.15 | 1124145.19 |
| 2015-05-14 | 274261 | 174.90 | 47969551.77 | 1149743.42 |
| 2015-05-15 | 256684 | 137.26 | 35232043.98 |  862178.21 |
+------------+--------+--------+-------------+------------+
27 rows in set (27 min 43.16 sec)

insert into tmp_facebook_udr_log (tx_date, phone, src, tx_time, tx_usage) 
select tx_date, phone, 'udr_1' src, sum(time_to_sec(timediff(if(end_time<strt_time, date_add(concat(tx_date, ' ', end_time), interval 1 day), concat(tx_date, ' ', end_time)), concat(tx_date, ,strt_time)))), sum(b_usage) 
from   udr_1 
where  tx_date = '2015-04-15' 
group by tx_date, phone, 3 
having sum(b_usage) > 0;


insert into tmp_facebook_user_log (tx_date, phone, tx_time, tx_usage)
select tx_date, phone, sum(tx_time) tx_time, sum(tx_usage) tx_usage 
from tmp_facebook_udr_log 
group by tx_date, phone

insert into tmp_facebook_user_log select tx_date, phone, round(sum(tx_time/60),2) tx_tm_mi, round(sum(tx_usage/1000000),2) tx_usage_mb 
from tmp_facebook_udr_log group by 1,2;

create table tmp_facebook_user_brand_log
insert into tmp_facebook_user_brand_log 
select a.tx_date, b.brand, sum(a.tx_time) tx_time, sum(a.tx_usage) tx_usage, avg(a.tx_time) tx_avg_tm, count(a.phone) uniq
from tmp_facebook_user_log a left outer join archive_powerapp_flu.powerapp_users_apn b on (a.phone=b.phone)
group by a.tx_date, b.brand
order by b.brand, a.tx_date;

select tx_date, round(sum(buddy),2) buddy, round(sum(tnt),2) tnt, round(sum(postpd),2) postpd 
from (
select tx_date, avg(tx_avg_tm) buddy, 0 tnt, 0 postpd from tmp_facebook_user_brand_log where brand= 'BUDDY' group by tx_date union
select tx_date, 0 buddy, avg(tx_avg_tm) tnt, 0 postpd from tmp_facebook_user_brand_log where brand= 'TNT' group by tx_date union
select tx_date, 0 buddy, 0 tnt, avg(tx_avg_tm) postpd from tmp_facebook_user_brand_log where brand= 'POSTPD' group by tx_date
) t1a
group by tx_date;

select tx_date, round(sum(buddy),2) buddy, round(sum(tnt),2) tnt, round(sum(postpd),2) postpd 
from (
select tx_date, sum(tx_usage) buddy, 0 tnt, 0 postpd from tmp_facebook_user_brand_log where brand= 'BUDDY' group by tx_date union
select tx_date, 0 buddy, sum(tx_usage) tnt, 0 postpd from tmp_facebook_user_brand_log where brand= 'TNT' group by tx_date union
select tx_date, 0 buddy, 0 tnt, sum(tx_usage) postpd from tmp_facebook_user_brand_log where brand= 'POSTPD' group by tx_date
) t1a
group by tx_date;

+------------+----------+----------+----------+ +------------+------------------+-----------------+----------------+
| tx_date    | buddy    | tnt      | postpd   | | tx_date    | buddy            | tnt             | postpd         |
+------------+----------+----------+----------+ +------------+------------------+-----------------+----------------+
| 2015-04-15 |   787.61 |   730.02 |   824.18 | | 2015-04-15 |    2743200973.00 |   5945824876.00 |    32795390.00 |
| 2015-04-16 | 20248.57 | 18030.39 | 17255.59 | | 2015-04-16 |  162961231508.00 | 246889846405.00 |  1496676275.00 |
| 2015-04-17 | 10575.53 |  8192.46 |  7012.31 | | 2015-04-17 |  561299524807.00 | 473070854935.00 |  4669261924.00 |
| 2015-04-18 | 16191.50 | 12376.92 | 10242.05 | | 2015-04-18 |  328728836923.00 | 291100687671.00 |  2042771705.00 |
| 2015-04-19 |  5073.29 |  4410.33 |  3994.92 | | 2015-04-19 |   43290263864.00 |  43699058808.00 |   277041020.00 |
| 2015-04-24 |  7803.42 |  6830.58 |  6161.62 | | 2015-04-24 |  673318285864.00 | 280263801036.00 |  9024682485.00 |
| 2015-04-25 |  9739.92 |  8566.45 |  8091.51 | | 2015-04-25 |  973227529446.00 | 392723540951.00 | 14394687123.00 |
| 2015-04-26 | 10682.98 |  8315.00 |  8172.09 | | 2015-04-26 | 1041147129417.00 | 191254191651.00 | 16014404546.00 |
| 2015-04-27 | 10394.89 |  9314.79 |  7735.36 | | 2015-04-27 | 1072452671249.00 | 175389815893.00 | 14418611626.00 |
| 2015-04-28 |   809.60 |   873.24 |   771.22 | | 2015-04-28 |   16200251144.00 |   2657275099.00 |   210798079.00 |
| 2015-04-29 | 10748.90 |  9631.80 |  7671.25 | | 2015-04-29 | 1180183322694.00 | 152945864059.00 | 15678442702.00 |
| 2015-04-30 | 10673.47 |  9621.24 |  8133.25 | | 2015-04-30 | 1199812286071.00 | 144840947272.00 | 14919547977.00 |
| 2015-05-01 | 10696.32 |  9670.40 |  8213.42 | | 2015-05-01 | 1224326415264.00 | 147016720430.00 | 18185008781.00 |
| 2015-05-02 | 10814.03 |  9825.86 |  8192.85 | | 2015-05-02 | 1281409616590.00 | 152415422516.00 | 18449496076.00 |
| 2015-05-03 | 10880.24 |  9826.97 |  8175.30 | | 2015-05-03 | 1251966518062.00 | 155582043791.00 | 20230354727.00 |
| 2015-05-04 | 10573.50 |  9731.03 |  7746.75 | | 2015-05-04 | 1294359301903.00 | 153078693368.00 | 17274608002.00 |
| 2015-05-05 |  9056.35 |  8273.07 |  6968.12 | | 2015-05-05 | 1038297627350.00 | 123062051419.00 | 13753404117.00 |
| 2015-05-06 | 10050.06 |  8987.05 |  7690.88 | | 2015-05-06 | 1248747953234.00 | 140504925613.00 | 15974259957.00 |
| 2015-05-07 | 11565.67 |  4595.43 |  8357.28 | | 2015-05-07 | 1369116042813.00 |  12950782035.00 | 18461781503.00 |
| 2015-05-08 | 11467.45 |  7367.90 |  8478.41 | | 2015-05-08 | 1404067335308.00 |    997755652.00 | 17496034441.00 |
| 2015-05-09 | 11371.27 |  7356.89 |  8375.24 | | 2015-05-09 | 1417478922198.00 |    923795490.00 | 20112544425.00 |
| 2015-05-10 | 10652.52 |  7164.21 |  8371.05 | | 2015-05-10 | 1323591154491.00 |    834249298.00 | 19803547663.00 |
| 2015-05-11 |  9790.26 |  6361.95 |  7644.50 | | 2015-05-11 | 1214732097408.00 |    671839355.00 | 16480208682.00 |
| 2015-05-12 |  9920.68 |  6568.14 |  7554.20 | | 2015-05-12 | 1226052694123.00 |    648377896.00 | 16180487296.00 |
| 2015-05-13 |  9834.48 |  6551.98 |  7469.61 | | 2015-05-13 | 1108395068843.00 |    610783024.00 | 15138129429.00 |
| 2015-05-14 |  9632.75 |  6782.32 |  7483.56 | | 2015-05-14 | 1134457347054.00 |    586308276.00 | 14681455033.00 |
| 2015-05-15 |  7552.87 |  5551.20 |  5783.85 | | 2015-05-15 |  849866276195.00 |    471891953.00 | 11833013223.00 |
| 2015-05-16 | 10577.15 |  7134.80 |  8214.55 | | 2015-05-16 | 1258116766300.00 |    619673052.00 | 19852218328.00 |
+------------+----------+----------+----------+ +------------+------------------+-----------------+----------------+



insert into tmp_facebook_user_log (tx_date, phone, tx_time, tx_usage)
select tx_date, phone, 
       sum(time_to_sec(timediff(if(end_time<strt_time, date_add(concat(tx_date, ' ', end_time), interval 1 day), concat(tx_date, ' ', end_time)),
                                concat(tx_date, ' ',strt_time)))) tx_time,   
       sum(b_usage) tx_usage 
from udr_fb_trace 
group by tx_date, phone;

insert into tmp_facebook_user_brand_log 
select a.tx_date, b.brand, round(sum(a.tx_time)/60,2) tx_time, round(sum(a.tx_usage)/1000000,2) tx_usage, avg(a.tx_time) tx_avg_tm, count(a.phone) uniq
from tmp_facebook_user_log_2014 a left outer join archive_powerapp_flu.powerapp_users_apn b on (a.phone=b.phone)
group by a.tx_date, b.brand
order by b.brand, a.tx_date;

select tx_date, round(sum(buddy),2) buddy, round(sum(tnt),2) tnt, round(sum(postpd),2) postpd 
from (
select tx_date, round(avg(tx_avg_tm)/60,2) buddy, 0 tnt, 0 postpd from tmp_facebook_user_brand_log where brand= 'BUDDY' group by tx_date union
select tx_date, 0 buddy, round(avg(tx_avg_tm)/60,2) tnt, 0 postpd from tmp_facebook_user_brand_log where brand= 'TNT' group by tx_date union
select tx_date, 0 buddy, 0 tnt, round(avg(tx_avg_tm)/60,2) postpd from tmp_facebook_user_brand_log where brand= 'POSTPD' group by tx_date
) t1a
group by tx_date;
