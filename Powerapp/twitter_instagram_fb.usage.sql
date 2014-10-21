Twitter Instagram & Facebook Usage


   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;



CREATE TABLE tmp_twitter_fb_usage (
  id int(12) NOT NULL AUTO_INCREMENT,
  tx_date date NOT NULL,
  start_tm time DEFAULT NULL,
  end_tm time DEFAULT NULL,
  phone varchar(12) NOT NULL,
  ip_addr varchar(20) DEFAULT NULL,
  source varchar(30) DEFAULT NULL,
  service varchar(30) DEFAULT NULL,
  b_usage int(12) DEFAULT '0',
  PRIMARY KEY (id),
  KEY datein_phone_idx (phone)
);

create table tmp_twitter_fb_users (
  tx_date date NOT NULL,
  phone varchar(12) NOT NULL,
  service varchar(30) DEFAULT NULL,
  b_usage int(12) DEFAULT '0',
  PRIMARY KEY (tx_date,phone,service));

insert into tmp_twitter_fb_users
select tx_date, phone, service, sum(b_usage) from tmp_twitter_fb_usage group by tx_date, phone, service;
select tx_date Date, round(sum(b_usage/1000000),0) Total_MB, round(avg(b_usage/1000000),0) Avg_MB from tmp_twitter_fb_users where service in ('FacebookService','PhotoService','SocialService') and b_usage > 1000000 group by 1;
select tx_date Date, round(sum(b_usage/1000000),0) Total_MB, round(avg(b_usage/1000000),0) Avg_MB from tmp_twitter_fb_users where service in ('FacebookService','PhotoService','SocialService') and b_usage > 0 group by 1;
select tx_date Date, round(sum(b_usage/1000000),0) Total_MB, round(avg(b_usage/1000000),0) Avg_MB from tmp_twitter_fb_users where service in ('FacebookService','PhotoService','SocialService') group by 1;

select tx_date Date, service, round(sum(b_usage/1000000),0) Total_MB, round(avg(b_usage/1000000),0) Avg_MB from tmp_twitter_fb_users where service in ('FacebookService','PhotoService','SocialService') and b_usage > 1000000 group by 1,2 order by 2,1;
select tx_date Date, service, round(sum(b_usage/1000000),0) Total_MB, round(avg(b_usage/1000000),0) Avg_MB from tmp_twitter_fb_users where service in ('FacebookService','PhotoService','SocialService') and b_usage > 0 group by 1,2 order by 2,1;
select tx_date Date, service, round(sum(b_usage/1000000),0) Total_MB, round(avg(b_usage/1000000),0) Avg_MB from tmp_twitter_fb_users where service in ('FacebookService','PhotoService','SocialService') group by 1,2 order by 2,1;

FacebookService
PhotoService
SocialService


+------------+----------+-----------+
| Date       | Total_MB | Avg_Usage |
+------------+----------+-----------+
| 2014-06-15 |  2408513 |  24328908 |
| 2014-06-16 |  2229630 |  22717247 |
| 2014-06-17 |  1889558 |  20646164 |
| 2014-06-18 |  1665436 |  23149375 |
+------------+----------+-----------+

+------------+----------+-----------+
| Date       | Total_MB | Avg_Usage |
+------------+----------+-----------+
| 2014-06-15 |  2414169 |  19721830 |
| 2014-06-16 |  2235202 |  18683040 |
| 2014-06-17 |  1896076 |  16438591 |
| 2014-06-18 |  1669075 |  19134844 |
+------------+----------+-----------+

+------------+----------+-----------+
| Date       | Total_MB | Avg_Usage |
+------------+----------+-----------+
| 2014-06-15 |  2414169 |  19711525 |
| 2014-06-16 |  2235202 |  18668528 |
| 2014-06-17 |  1896076 |  16422929 |
| 2014-06-18 |  1669075 |  19115778 |
+------------+----------+-----------+



select tx_date Date, round(sum(b_usage/1000000),0) Total_MB, round(avg(b_usage),0) Avg_Usage, count(1) No_Trans from tmp_twitter_fb_usage where b_usage > 1000000 group by 1;

+------------+----------+------------+----------+
| Date       | Total_MB | Avg_Usage  | No_Trans |
+------------+----------+------------+----------+
| 2014-06-14 |    95617 | 2318277.33 |    41245 |
| 2014-06-15 |  1749198 | 2253243.91 |   776302 |
| 2014-06-16 |  1613930 | 2275392.92 |   709297 |
| 2014-06-17 |  1373829 | 2280292.93 |   602479 |
| 2014-06-18 |  1191487 | 2239628.04 |   532002 |
| 2014-06-19 |   193240 | 2310299.11 |    83643 |
+------------+----------+------------+----------+


select tx_date Date, round(sum(b_usage/1000000),0) Total_MB, round(avg(b_usage),0) Avg_Usage from (
select tx_date, phone, sum(b_usage) b_usage from tmp_twitter_fb_usage group by 1,2
) t where b_usage > 1000000 
group by 1;

drop table tmp_facebook_log;
create temporary table tmp_facebook_log (tx_date date, phone varchar(12), mb_usage int(11), primary key (tx_date,phone));
truncate table tmp_facebook_log;
insert into tmp_facebook_log select tx_date, phone, round(b_usage/1000000,0) from tmp_twitter_fb_users where service = 'FacebookService';

select '2014-06-15' into @tx_date;
select floor(count(1)/2)-5 median_low, ceil(count(1)/2)+5 median_high, round(count(1)/2,0) into @median_lo, @median_hi, @median from tmp_facebook_log where tx_date = @tx_date;
select 0 into @rownum;
select mb_usage into @median_mb from 
(
   select  phone, mb_usage, @rownum:=@rownum+1 rank from
   (
      select phone, mb_usage from tmp_facebook_log where tx_date = @tx_date order by mb_usage 
   ) t 
) u 
where rank =@median;

select @median, @median_lo, @median_hi;
select 0 into @rownum;
select * from 
(
   select  phone, mb_usage, @rownum:=@rownum+1 rank from
   (
      select phone, mb_usage from tmp_facebook_log where tx_date = @tx_date order by mb_usage 
   ) t 
) u 
where rank between @median_lo and @median_hi;
select mb_usage, count(1) uniq from tmp_facebook_log where tx_date = @tx_date and mb_usage = @median_mb group by mb_usage;
select count(1) total_uniq from tmp_facebook_log where tx_date = @tx_date;


select '2014-06-18' into @tx_date;
\. a.sql
