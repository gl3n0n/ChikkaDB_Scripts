drop view powerapp_plan_ctr;
create view powerapp_plan_ctr as
select left(datein,10) datein, count(1) unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost,  0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where datein >= date_sub(curdate(), interval 15 day) and free='false' and plan= 'UNLI' group by left(datein,10) union 
select left(datein,10) datein, 0 unli, count(1) email, 0 social, 0 photo, 0 chat, 0 speedboost,  0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where datein >= date_sub(curdate(), interval 15 day) and free='false' and plan= 'EMAIL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli, 0 email, count(1) social, 0 photo, 0 chat, 0 speedboost,  0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where datein >= date_sub(curdate(), interval 15 day) and free='false' and plan= 'SOCIAL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli, 0 email, 0 social, count(1) photo, 0 chat, 0 speedboost,  0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where datein >= date_sub(curdate(), interval 15 day) and free='false' and plan= 'PHOTO' group by left(datein,10) union 
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, count(1) chat, 0 speedboost,  0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where datein >= date_sub(curdate(), interval 15 day) and free='false' and plan= 'CHAT' group by left(datein,10) union 
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, count(1) speedboost,  0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where datein >= date_sub(curdate(), interval 15 day) and free='false' and plan= 'SPEEDBOOST' group by left(datein,10) union 
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, count(distinct phone) unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 total_hits, 0 total_uniq from powerapp_log where datein >= date_sub(curdate(), interval 15 day) and free='false' and plan= 'UNLI' group by left(datein,10) union 
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, count(distinct phone) email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 total_hits, 0 total_uniq from powerapp_log where datein >= date_sub(curdate(), interval 15 day) and free='false' and plan= 'EMAIL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, count(distinct phone) social, 0 photo, 0 chat, 0 speedboost, 0 total_hits, 0 total_uniq from powerapp_log where datein >= date_sub(curdate(), interval 15 day) and free='false' and plan= 'SOCIAL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, 0 social, count(distinct phone) photo, 0 chat, 0 speedboost, 0 total_hits, 0 total_uniq from powerapp_log where datein >= date_sub(curdate(), interval 15 day) and free='false' and plan= 'PHOTO' group by left(datein,10) union 
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, 0 social, 0 photo, count(distinct phone) chat, 0 speedboost, 0 total_hits, 0 total_uniq from powerapp_log where datein >= date_sub(curdate(), interval 15 day) and free='false' and plan= 'CHAT' group by left(datein,10) union 
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, 0 social, 0 photo, 0 chat, count(distinct phone) speedboost, 0 total_hits, 0 total_uniq from powerapp_log where datein >= date_sub(curdate(), interval 15 day) and free='false' and plan= 'SPEEDBOOST' group by left(datein,10) union 
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, count(1) total_hits, 0 total_uniq from powerapp_log where datein >= date_sub(curdate(), interval 15 day) and free='false' group by left(datein,10) union 
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 total_hits, count(distinct phone) total_uniq from powerapp_log where datein >= date_sub(curdate(), interval 15 day) and free='false' group by left(datein,10);  

create view powerapp_plan_summary as
select datein tran_dt, sum(unli) UNLI, sum(email) EMAIL, sum(social) SOCIAL, sum(photo) PHOTO, sum(chat) CHAT, sum(speedboost) SPEEDBOOST,
                    sum(unli_u) UNLI_U, sum(email_u) EMAIL_U, sum(social_u) SOCIAL_U, sum(photo_u) PHOTO_U, sum(chat_u) CHAT_U, sum(speedboost_u) SPEEDBOOST_U,
                    sum(total_hits) TOTAL_HITS, suM(total_uniq) TOTAL_UNIQ
from powerapp_plan_ctr
group by  datein;

CREATE PROCEDURE sp_generate_hi10_stats()
begin
    insert ignore into powerapp_dailyrep (tran_dt, unli_hits, email_hits, social_hits, photo_hits, chat_hits, speed_hits, unli_uniq, email_uniq, social_uniq, photo_uniq, chat_uniq, speed_uniq, total_hits, total_uniq)
    select tran_dt, unli, email, social, photo, chat, speedboost, unli_u, email_u, social_u, photo_u, chat_u, speedboost_u, total_hits, total_uniq
    from   powerapp_plan_summary
    where  tran_dt = date_sub(curdate(), interval 1 day);
END;
//



insert into powerapp_dailyrep (tran_dt, unli_hits, email_hits, social_hits, photo_hits, chat_hits, speed_hits, unli_uniq, email_uniq, social_uniq, photo_uniq, chat_uniq, speed_uniq, total_hits, total_uniq)
select datein DATE, sum(unli) UNLI, sum(email) EMAIL, sum(social) SOCIAL, sum(photo) PHOTO, sum(chat) CHAT, sum(speedboost) SPEEDBOOST, 
                    sum(unli_u) UNLI_U, sum(email_u) EMAIL_U, sum(social_u) SOCIAL_U, sum(photo_u) PHOTO_U, sum(chat_u) CHAT_U, sum(speedboost_u) SPEEDBOOST_U,
                    sum(total_hits), suM(total_uniq)
from (
select left(datein,10) datein, count(1) unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'UNLI' group by left(datein,10) union
select left(datein,10) datein, 0 unli, count(1) email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'EMAIL' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, count(1) social, 0 photo, 0 chat, 0 speedboost, 0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'SOCIAL' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, count(1) photo, 0 chat, 0 speedboost, 0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'PHOTO' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, count(1) chat, 0 speedboost, 0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'CHAT' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, count(1) speedboost, 0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'SPEEDBOOST' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, count(distinct phone) unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'UNLI' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, count(distinct phone) email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'EMAIL' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, count(distinct phone) social, 0 photo, 0 chat, 0 speedboost, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'SOCIAL' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, 0 social, count(distinct phone) photo, 0 chat, 0 speedboost, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'PHOTO' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, 0 social, 0 photo, count(distinct phone) chat, 0 speedboost, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'CHAT' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, 0 social, 0 photo, 0 chat, count(distinct phone) speedboost, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'SPEEDBOOST' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, count(1) total_hits, 0 total_uniq from powerapp_log group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 total_hits, count(distinct phone) total_uniq from powerapp_log group by left(datein,10) 
) as t1
group by  datein;



DROP table powerapp_dailyrep ;
create table powerapp_dailyrep (
tran_dt date not null,
unli_hits int default 0,
unli_uniq int default 0,
email_hits int default 0,
email_uniq int default 0,
chat_hits int default 0,
chat_uniq int default 0,
photo_hits int default 0,
photo_uniq int default 0,
social_hits int default 0,
social_uniq int default 0,
speed_hits int default 0,
speed_uniq int default 0,
total_hits int default 0,
total_uniq int default 0,
primary key (tran_dt)
);

create table powerapp_concurrent_subs (
   tran_dt date not null,
   num_subs int default 0,
   primary key (tran_dt)
);
 

select tran_dt, unli_hits, email_hits, chat_hits, photo_hits, social_hits, speed_hits from powerapp_dailyrep where tran_dt >= '2013-12-01' and tran_dt < '2014-01-01';
select tran_dt, unli_uniq, email_uniq, chat_uniq, photo_uniq, social_uniq, speed_uniq from powerapp_dailyrep where tran_dt >= '2013-12-01' and tran_dt < '2014-01-01';
select tran_dt, total_hits from powerapp_dailyrep where tran_dt >= '2013-12-01' and tran_dt < '2014-01-01';
select tran_dt, total_uniq from powerapp_dailyrep where tran_dt >= '2013-12-01' and tran_dt < '2014-01-01';

select date_format(tran_dt, '%y-%b'), total_hits from powerapp_dailyrep group by 1;

select '2013-12-01' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-01' union
select '2013-12-02' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-02' union
select '2013-12-03' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-03' union
select '2013-12-04' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-04' union
select '2013-12-05' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-05' union
select '2013-12-06' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-06' union
select '2013-12-07' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-07' union
select '2013-12-08' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-08' union
select '2013-12-09' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-09' union
select '2013-12-10' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-10' union
select '2013-12-11' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-11' union
select '2013-12-12' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-12' union
select '2013-12-13' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-13' union
select '2013-12-14' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-14' union
select '2013-12-15' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-15' union
select '2013-12-16' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-16' union
select '2013-12-17' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-17' union
select '2013-12-18' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-18' union
select '2013-12-19' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-19' union
select '2013-12-20' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-20' union
select '2013-12-21' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-21' union
select '2013-12-22' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-22' union
select '2013-12-23' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-23' union
select '2013-12-24' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-24' union
select '2013-12-25' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-25' union
select '2013-12-26' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-26' union
select '2013-12-27' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-27' union
select '2013-12-28' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-28' union
select '2013-12-29' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-29' union
select '2013-12-30' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-30' union
select '2013-12-31' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-31' 


insert into powerapp_concurrent_subs values ('2013-12-01',    38);
insert into powerapp_concurrent_subs values ('2013-12-02',    35);
insert into powerapp_concurrent_subs values ('2013-12-03',    40);
insert into powerapp_concurrent_subs values ('2013-12-04',   419);
insert into powerapp_concurrent_subs values ('2013-12-05',   588);
insert into powerapp_concurrent_subs values ('2013-12-06',   654);
insert into powerapp_concurrent_subs values ('2013-12-07',   712);
insert into powerapp_concurrent_subs values ('2013-12-08',   875);
insert into powerapp_concurrent_subs values ('2013-12-09',  1061);
insert into powerapp_concurrent_subs values ('2013-12-10',  1133);
insert into powerapp_concurrent_subs values ('2013-12-11',  1119);
insert into powerapp_concurrent_subs values ('2013-12-12',  1336);
insert into powerapp_concurrent_subs values ('2013-12-13',  1607);
insert into powerapp_concurrent_subs values ('2013-12-14',  1802);
insert into powerapp_concurrent_subs values ('2013-12-15',  2050);
insert into powerapp_concurrent_subs values ('2013-12-16',  3718);
insert into powerapp_concurrent_subs values ('2013-12-17',  5154);
insert into powerapp_concurrent_subs values ('2013-12-18',  7100);
insert into powerapp_concurrent_subs values ('2013-12-19',  8569);
insert into powerapp_concurrent_subs values ('2013-12-20', 10098);
insert into powerapp_concurrent_subs values ('2013-12-21', 14004);
insert into powerapp_concurrent_subs values ('2013-12-22', 17128);
insert into powerapp_concurrent_subs values ('2013-12-23', 20360);
insert into powerapp_concurrent_subs values ('2013-12-24', 23236);
insert into powerapp_concurrent_subs values ('2013-12-25', 25682);
insert into powerapp_concurrent_subs values ('2013-12-26', 25992);
insert into powerapp_concurrent_subs values ('2013-12-27', 26790);
insert into powerapp_concurrent_subs values ('2013-12-28', 27750);
insert into powerapp_concurrent_subs values ('2013-12-29', 28439);
insert into powerapp_concurrent_subs values ('2013-12-30', 30034);
insert into powerapp_concurrent_subs values ('2013-12-31', 31274);
+------------+-------+

Total Concurrent subs
+------------+-------+
| datein     | uniq  |
+------------+-------+
| 2013-12    | 31274 |
+------------+-------+


select DATE_FORMAT(a.tran_dt,'%m/%d/%Y'), a.unli_hits, a.email_hits, a.chat_hits, a.photo_hits, a.social_hits, a.speed_hits, a.unli_uniq, a.email_uniq, a.chat_uniq, a.photo_uniq, a.social_uniq, a.speed_uniq, a.total_hits, a.total_uniq, IFNULL(b.num_subs,0) from powerapp_dailyrep a left outer join powerapp_concurrent_subs b on a.tran_dt = b.tran_dt
