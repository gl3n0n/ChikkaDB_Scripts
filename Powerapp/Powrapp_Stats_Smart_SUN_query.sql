select datediff(curdate(), '2014-07-31'); 

# Chikka APN (dbreplica.archive_powerapp_flu)
select tran_dt, sum(buddy+others) buddy, sum(postpd) postpd, sum(sun) sun, sum(buddy+others+postpd+sun) total from (
select tran_dt, buddy, postpd, others, 0 sun from archive_powerapp_flu.powerapp_apn_stats where tran_dt = last_day(tran_dt)
union
select tran_dt, 0 buddy, 0 postpd, 0 others, num_subs sun from powerapp_sun.powerapp_concurrent_subs where tran_dt = last_day(tran_dt)
) t group by tran_dt;


+------------+---------+--------+--------+---------+
| tran_dt    | buddy   | postpd | sun    | total   |
+------------+---------+--------+--------+---------+
| 2014-07-31 |       0 |      0 |     33 |      33 |
| 2014-08-31 |       0 |      0 |  68954 |   68954 |
| 2014-09-30 |       0 |      0 | 122993 |  122993 |
| 2014-10-31 |       0 |      0 | 138926 |  138926 |
| 2014-11-30 | 1911425 |  19462 | 144509 | 2075396 |
| 2014-12-31 | 1974869 |  20112 | 152669 | 2147650 |
| 2015-01-31 | 2009700 |  20700 | 159889 | 2190289 |
| 2015-02-28 | 2041570 |  21955 | 167892 | 2231417 |
| 2015-03-31 | 2118403 |  23944 | 178632 | 2320979 |
| 2015-04-30 | 2184388 |  24822 | 183995 | 2393205 |
| 2015-05-31 | 2262310 |  25687 | 189261 | 2477258 |
+------------+---------+--------+--------+---------+
11 rows in set (0.00 sec)





# 
# Active Users (hi10.powerapp_flu)
# 
select tran_dt, num_actv_30d_buddy buddy, num_actv_30d_tnt tnt, num_actv_30d_postpd postpd from powerapp_flu.powerapp_dailyrep where tran_dt = last_day(tran_dt);
select tran_dt, num_actv_30d sun from powerapp_sun.powerapp_dailyrep where tran_dt = last_day(tran_dt);

# 
# TOTAL AVAILMENTS & REVENUE (dbreplica.archive_powerapp_flu)
#    
   select max(tran_dt) from powerapp_brand_dailyrep;
   insert into powerapp_brand_dailyrep select * from powerapp_flu.powerapp_brand_dailyrep where tran_dt> '2015-09-30' and tran_dt < curdate();

   select max(tran_dt) from powerapp_sun_brand_dailyrep;
   insert ignore into powerapp_sun_brand_dailyrep
   select tran_dt, plan, sum(hits_pre), sum(hits_ppd), sum(hits_tnt), sum(hits_tot), sum(uniq_pre), sum(uniq_ppd), sum(uniq_tnt), sum(uniq_tot) from (
   select left(datein, 10) tran_dt, plan, count(1) hits_pre, 0 hits_ppd, 0 hits_tnt, 0 hits_tot, count(distinct phone) uniq_pre, 0 uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_sun.powerapp_log where free='false' and brand='PREPAID'  and datein > '2015-09-30' and datein < curdate() group by tran_dt, plan union
   select left(datein, 10) tran_dt, plan, 0 hits_pre, count(1) hits_ppd, 0 hits_tnt, 0 hits_tot, 0 uniq_pre, count(distinct phone) uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_sun.powerapp_log where free='false' and brand='POSTPAID' and datein > '2015-09-30' and datein < curdate() group by tran_dt, plan union
   select left(datein, 10) tran_dt, plan, 0 hits_pre, 0 hits_ppd, 0 hits_tnt, count(1) hits_tot, 0 uniq_pre, 0 uniq_ppd, 0 uniq_tnt, count(distinct phone) uniq_tot from powerapp_sun.powerapp_log where free='false' and datein > '2015-09-30' and datein < curdate() group by tran_dt, plan
   ) temp_table group by tran_dt, plan;


select date_format(tran_dt, '%Y-%b') Month, sum(total_hits) total_hits,
       sum(buddy_hits) buddy_hits, sum(tnt_hits) tnt_hits, sum(ppd_hits) ppd_hits,
       sum(buddy_amt+tnt_amt+ppd_amt) total_amt,
       sum(buddy_amt) buddy_amt, sum(tnt_amt) tnt_amt, sum(ppd_amt) ppd_amt 
from (
select s.tran_dt tran_dt,sum((s.hits_pre+s.hits_tnt+s.hits_ppd)) total_hits, 
       sum(s.hits_pre) buddy_hits, sum(s.hits_tnt) tnt_hits, sum(s.hits_ppd) ppd_hits,
       sum((s.hits_pre+s.hits_tnt+s.hits_ppd)*(m.price)) total_amt,  
       sum(s.hits_pre*(m.price)) buddy_amt, sum(s.hits_tnt*(m.price)) tnt_amt, sum(s.hits_ppd*(m.price)) ppd_amt
from powerapp_brand_dailyrep s, powerapp_plan_services_mapping m
where s.plan=m.plan
and   m.price >  0
group by s.tran_dt
) t1a group by 1 order by tran_dt;

select date_format(tran_dt, '%Y-%b') Month, sum(total_hits) total_hits, sum(total_amt) total_amt
from (
select s.tran_dt tran_dt, sum(s.hits_tot) total_hits, sum(s.hits_tot*m.price) total_amt
from powerapp_sun_brand_dailyrep s, powerapp_plan_services_mapping m
where s.plan=m.plan
group by s.tran_dt
) t1a group by 1 order by tran_dt;

+----------+------------+-----------+-----------+----------+---------+  
| Month    | total_hits | total_amt | buddy_amt | tnt_amt  | ppd_amt |  
+----------+------------+-----------+-----------+----------+---------+  
| NULL     |          0 |         0 |         0 |        0 |       0 |  
| 2013-Nov |        737 |      7245 |      5515 |      215 |    1515 |  
| 2013-Dec |      67321 |    699835 |    441575 |   240760 |   17500 |  
| 2014-Jan |     260536 |   2732545 |   1900225 |   777020 |   55300 |  
| 2014-Feb |     791298 |   1131675 |    785800 |   305825 |   40050 |  
| 2014-Mar |    2012177 |   1621035 |   1144035 |   417925 |   59075 |  
| 2014-Apr |    4517486 |   2207600 |   1535140 |   582060 |   90400 |  +----------+------------+-----------+
| 2014-May |    4815348 |   5858375 |   4903675 |   770390 |  184310 |  | Month    | total_hits | total_amt |
| 2014-Jun |    2675655 |   9793664 |   7020089 |  2554259 |  219316 |  +----------+------------+-----------+
| 2014-Jul |    2629005 |  15225790 |   8884639 |  6085392 |  255759 |  | 2014-Jul |        216 |      1505 |
| 2014-Aug |    3666112 |  22666426 |  12133974 | 10270637 |  261815 |  | 2014-Aug |     123939 |    432940 |
| 2014-Sep |    4789084 |  28163746 |  15546956 | 12323785 |  293005 |  | 2014-Sep |     430621 |   1495430 |
| 2014-Oct |    3562094 |  23728346 |  15632419 |  7797582 |  298345 |  | 2014-Oct |     343753 |   1240410 |
| 2014-Nov |    2541904 |  16503563 |  11158563 |  5107785 |  237215 |  | 2014-Nov |     252726 |    766495 |
| 2014-Dec |    2217411 |  14998338 |   9897970 |  4882128 |  218240 |  | 2014-Dec |     249071 |    888670 |
| 2015-Jan |   18058545 |  15803942 |   9898392 |  5670060 |  235490 |  | 2015-Jan |     246104 |    936110 |
| 2015-Feb |    2622473 |  15765255 |   8949032 |  6546088 |  270135 |  | 2015-Feb |     227359 |    903355 |
| 2015-Mar |    3670331 |  22340564 |  13155762 |  8751402 |  433400 |  | 2015-Mar |     293177 |   1100035 |
| 2015-Apr |    1762646 |  10676123 |   7309230 |  3096323 |  270570 |  | 2015-Apr |     203960 |    556180 |
| 2015-May |    1133120 |   8450090 |   8086956 |    83984 |  279150 |  | 2015-May |     215575 |    518195 |
+----------+------------+-----------+-----------+----------+---------+  +----------+------------+-----------+


                                      
select tx_mon, plan, sum(hits) hits from (
select left(tran_dt,7) tx_mon, plan, sum(hits_pre+hits_ppd) hits from powerapp_brand_dailyrep where tran_dt >= '2015-05-01' and plan not in ('MYVOLUME', 'OPTOUT') group by 1,2 union
select left(tran_dt,7) tx_mon, plan, sum(hits_pre+hits_ppd) hits from powerapp_brand_dailyrep where tran_dt >= '2015-05-01' and plan not in ('MYVOLUME', 'OPTOUT') group by 1,2 
) t1 group by tx_mon, plan having sum(hits) > 0
order by 1,3 desc;
+---------+--------------+--------+
| tx_mon  | plan         | hits   |
+---------+--------------+--------+
| 2015-01 | FACEBOOK     | 406731 |
| 2015-01 | UNLI         | 302986 |
| 2015-01 | SPEEDBOOST   | 259869 |
| 2015-01 | CHAT         |  40087 |
| 2015-01 | SOCIAL       |  21149 |
| 2015-01 | DEARPOPE     |  15385 |
| 2015-01 | BACKTOSCHOOL |  10949 |
| 2015-01 | WIKIPEDIA    |   9932 |
| 2015-01 | PISONET      |   7902 |
| 2015-01 | PHOTO        |   2540 |
| 2015-01 | EMAIL        |   2441 |
| 2015-01 | WECHAT       |   1645 |
| 2015-01 | FREE_SOCIAL  |   1601 |
| 2015-01 | LINE         |    855 |
| 2015-01 | WAZE         |    360 |
| 2015-01 | SNAPCHAT     |    227 |
| 2015-01 | TUMBLR       |    182 |
| 2015-02 | FACEBOOK     | 381589 |
| 2015-02 | UNLI         | 277016 |
| 2015-02 | SPEEDBOOST   | 206503 |
| 2015-02 | CHAT         |  37568 |
| 2015-02 | SOCIAL       |  21496 |
| 2015-02 | BACKTOSCHOOL |  15691 |
| 2015-02 | PISONET      |   7597 |
| 2015-02 | WIKIPEDIA    |   6994 |
| 2015-02 | PHOTO        |   2551 |
| 2015-02 | FREE_SOCIAL  |   2091 |
| 2015-02 | EMAIL        |   1999 |
| 2015-02 | WECHAT       |   1278 |
| 2015-02 | LINE         |    656 |
| 2015-02 | WAZE         |    305 |
| 2015-02 | VIDEO5       |    248 |
| 2015-02 | SNAPCHAT     |    174 |
| 2015-02 | YOUTUBE      |    164 |
| 2015-02 | TUMBLR       |    143 |
| 2015-02 | VIDEO15      |     49 |
| 2015-02 | VIDEO50      |      4 |
| 2015-03 | FACEBOOK     | 677565 |
| 2015-03 | UNLI         | 394983 |
| 2015-03 | SPEEDBOOST   | 258385 |
| 2015-03 | CHAT         |  38165 |
| 2015-03 | SOCIAL       |  36034 |
| 2015-03 | BACKTOSCHOOL |  29812 |
| 2015-03 | PISONET      |  11437 |
| 2015-03 | WIKIPEDIA    |  10081 |
| 2015-03 | PHOTO        |   4810 |
| 2015-03 | EMAIL        |   2814 |
| 2015-03 | WECHAT       |   1373 |
| 2015-03 | FREE_SOCIAL  |    985 |
| 2015-03 | VIDEO5       |    902 |
| 2015-03 | LINE         |    861 |
| 2015-03 | WAZE         |    465 |
| 2015-03 | TUMBLR       |    236 |
| 2015-03 | VIDEO15      |    198 |
| 2015-03 | SNAPCHAT     |    188 |
| 2015-03 | VIDEO50      |     54 |
| 2015-03 | VIDEO120     |      6 |
| 2015-04 | FACEBOOK     | 536569 |
| 2015-04 | UNLI         | 184771 |
| 2015-04 | SPEEDBOOST   | 118067 |
| 2015-04 | SOCIAL       |  25349 |
| 2015-04 | CHAT         |  19908 |
| 2015-04 | BACKTOSCHOOL |  16128 |
| 2015-04 | WIKIPEDIA    |  10384 |
| 2015-04 | PISONET      |   5780 |
| 2015-04 | PHOTO        |   3451 |
| 2015-04 | EMAIL        |   1663 |
| 2015-04 | VIDEO5       |   1157 |
| 2015-04 | WECHAT       |    651 |
| 2015-04 | LINE         |    365 |
| 2015-04 | WAZE         |    297 |
| 2015-04 | FREE_SOCIAL  |    241 |
| 2015-04 | TUMBLR       |    115 |
| 2015-04 | SNAPCHAT     |    104 |
| 2015-04 | VIDEO15      |     96 |
| 2015-04 | VIDEO50      |      8 |
| 2015-05 | FACEBOOK     | 641928 |
| 2015-05 | UNLI         | 183296 |
| 2015-05 | SPEEDBOOST   | 170920 |
| 2015-05 | SOCIAL       |  25868 |
| 2015-05 | BACKTOSCHOOL |  18342 |
| 2015-05 | CHAT         |  17467 |
| 2015-05 | PISONET      |   9401 |
| 2015-05 | WIKIPEDIA    |   7906 |
| 2015-05 | PHOTO        |   4323 |
| 2015-05 | VIDEO5       |   2843 |
| 2015-05 | EMAIL        |   1844 |
| 2015-05 | WECHAT       |    716 |
| 2015-05 | LINE         |    537 |
| 2015-05 | WAZE         |    328 |
| 2015-05 | FREE_SOCIAL  |    229 |
| 2015-05 | TUMBLR       |    196 |
| 2015-05 | SNAPCHAT     |    154 |
| 2015-05 | VIDEO15      |     92 |
| 2015-05 | VIDEO50      |      7 |
| 2015-06 | FACEBOOK     | 695469 |
| 2015-06 | UNLI         | 187497 |
| 2015-06 | SPEEDBOOST   | 159052 |
| 2015-06 | SOCIAL       |  20955 |
| 2015-06 | CHAT         |  15094 |
| 2015-06 | BACKTOSCHOOL |   8983 |
| 2015-06 | PISONET      |   6932 |
| 2015-06 | WIKIPEDIA    |   6326 |
| 2015-06 | PHOTO        |   3570 |
| 2015-06 | VIDEO5       |   2264 |
| 2015-06 | EMAIL        |   1681 |
| 2015-06 | WECHAT       |    744 |
| 2015-06 | LINE         |    490 |
| 2015-06 | WAZE         |    361 |
| 2015-06 | FREE_SOCIAL  |    247 |
| 2015-06 | TUMBLR       |    186 |
| 2015-06 | SNAPCHAT     |    123 |
| 2015-06 | VIDEO15      |    106 |
| 2015-06 | VIDEO50      |      7 |
+---------+--------------+--------+
114 rows in set (0.02 sec)
