create temporary table tmp_bestever select phone from pull_log where datein = '2014-08-12' and keyword = 'BESTEVER_END' group by phone;
alter table tmp_bestever add primary key (phone);
select left(timein,2) tm_hh, count(distinct phone) uniq from pull_log a where datein = '2014-08-12' and keyword <> 'BESTEVER_END' and exists (select 1 from tmp_bestever b where a.phone=b.phone) group by 1;
select max(timein) max_timein, count(distinct phone) uniq from request_log a where datein = '2014-08-12' and exists (select 1 from tmp_bestever b where a.phone=b.phone);

drop temporary table tmp_bestever_6k;
create temporary table tmp_bestever_6k select phone, min(timein) min_time, max(timein) max_time from pull_log a where datein = '2014-08-12' and keyword <> 'BESTEVER_END' and exists (select 1 from tmp_bestever b where a.phone=b.phone) group by 1;
alter table tmp_bestever_6k add primary key (phone);

create temporary table tmp_bestever_6k_hh select phone, left(timein,2) tm_hh from pull_log a where datein = '2014-08-12' and keyword <> 'BESTEVER_END' and exists (select 1 from tmp_bestever b where a.phone=b.phone) group by 1,2;
alter table tmp_bestever_6k_hh add primary key (phone,tm_hh);


select left(timein,2) tm_hh, count(distinct phone) uniq, count(1) hits, min(timein), max(timein) 
from pull_log a 
where datein = '2014-08-12' and timein < '10:00:00' 
and exists (select 1 from tmp_bestever_6k b where a.phone=b.phone) group by 1;

create table tmP_bestever_latest_sms as
select gsm_num, max(msg_id) msg_id from csg_v3.sms_in z 
   where datein=curdate() 
   and  exists (select 1 from (select phone from tmp_bestever a where not exists (select 1 from tmp_plan_availers b where a.phone=b.phone)) t  where t.phone=z.gsm_num) 
   group by 1 




Reprocess ->->->->->



CREATE TABLE tmp_bestever_transid (
  transid varchar(128) NOT NULL, timein time NOT NULL DEFAULT '00:00:00',
  msg text, batch_no int(3) DEFAULT '0', gsm_num varchar(12), 
  PRIMARY KEY (transid),
  KEY (gsm_num),
);

create temporary table tmp_bestever select phone from pull_log where datein = '2014-08-12' and keyword = 'BESTEVER_END' group by phone;
alter table tmp_bestever add primary key (phone);

truncate table tmp_plan_availers;
load data infile '/tmp/tmp_plan_availers_11.csv' into table tmp_plan_availers;

drop table tmp_bestever_latest_sms;
create table tmp_bestever_latest_sms as
select gsm_num, max(msg_id) msg_id 
from csg_v3.sms_in a 
where datein=curdate() 
and  exists (select 1 from tmp_bestever b where b.phone=a.gsm_num) 
group by gsm_num;
alter table tmp_bestever_latest_sms add key (gsm_num);

insert into tmp_bestever_transid 
select z.transid, z.timein, z.msg, 6, z.gsm_num from csg_v3.sms_in z, tmp_bestever_latest_sms y 
where z.datein=curdate() and z.gsm_num = y.gsm_num and z.msg_id = y.msg_id 
and   not exists (select 1 from tmp_plan_availers b where y.gsm_num=b.phone)
and   not exists (select 1 from tmp_bestever_transid b where z.transid=b.transid)
and   z.msg  in ('FACEBOOK', 'UNLI20', 'SOCIAL', 'FREE WIKI', 'FREE SOCIAL', 'SOCIAL10', 
                 'SCHOOL', 'CHAT10', 'WIKI FREE', 'FB', 'SOCIAL FREE', 'FACEBOOK 5', 'FREEWIKI', 'UNLI 20', 
                 'UNLI15', 'SOCIAL 10', 'FREESOCIAL', 'UNLI30', 'UNLI5', 'UNLIFB', 'FB 5')
order by z.timein asc
limit 1000;

select transid into outfile '/tmp/tmp_bestever_reprocess_6.csv' fields terminated by ',' from tmp_bestever_transid where batch_no = 6; 
select count(1) from transaction_log a where exists (select 1 from tmp_bestever_transid b where b.batch_no=6  and a.transid = b.transid);
delete from transaction_log where exists (select 1 from tmp_bestever_transid b where b.batch_no=6 and transaction_log.transid = b.transid);

select count(distinct gsm_num) uniq, count(1) hits from tmp_bestever_transid;

select count(1) from tmp_bestever_latest_sms a where not exists (select 1 from tmp_plan_availers b where a.gsm_num=b.phone)
                                               and   not exists (select 1 from tmp_bestever_transid b where a.gsm_num=b.gsm_num);

select left(z.timein,2) tm_hh, count(1) from csg_v3.sms_in z, tmp_bestever_latest_sms y 
where z.datein=curdate() and z.gsm_num = y.gsm_num and z.msg_id = y.msg_id 
and   not exists (select 1 from tmp_plan_availers b where y.gsm_num=b.phone)
and   not exists (select 1 from tmp_bestever_transid b where y.gsm_num=b.gsm_num)
group by 1;



-- Availers

select phone into outfile '/tmp/tmp_bestever_26k.cs' from tmp_bestever;
create table tmp_bestever (phone varchar(12) not null, primary key (phone));
load data infile '/tmp/tmp_bestever_26k.csv' into table tmp_bestever;
select plan, count(1), count(distinct phone) uniq  from powerapp_log a where datein >= curdate() and exists (select 1 from tmp_bestever b where a.phone=b.phone) group by 1;
select count(1) no_txns, count(distinct phone) availers, 26947-count(distinct phone) non_availers  from powerapp_log a where datein >= curdate() and exists (select 1 from tmp_bestever b where a.phone=b.phone);





+-----------------------+----------+
| msg                   | count(1) |
+-----------------------+----------+
| FACEBOOK              |    10678 |
| UNLI20                |     1119 |
| BOOST5                |      281 |
| SOCIAL                |      203 |
| FREE WIKI             |      190 |
| FREE SOCIAL           |      144 |
| SOCIAL10              |      142 |
| SCHOOL                |      129 |
| CHAT10                |       94 |
| WIKI FREE             |       93 |
| FB                    |       77 |
| SOCIAL FREE           |       44 |
| FACEBOOK 5            |       44 |
| FREEWIKI              |       32 |
| UNLI 20               |       32 |
| UNLI15                |       26 |
| SOCIAL 10             |       25 |
| FREESOCIAL            |       25 |
| UNLI30                |       23 |
| UNLI5                 |       22 |
| UNLIFB                |       21 |
| FB 5                  |       19 |
| BOOSTS5               |       13 |
+-----------------------+----------+
54 rows in set (0.15 sec)
