CREATE TABLE powerapp_plans (
  plan varchar(16) NOT NULL,
  validity int(11) NOT NULL,
  cost int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (plan,validity)
);

create table powerapp_udr_detail (
   id int(11) not null, 
   phone varchar(12) not null, 
   plan varchar(16) not null, 
   validity int(11) not null, 
   tx_date  date not null,
   tx_time  datetime not null,
   tx_usage int(11) default 0 not null, 
   tx_cost  int(11) default 0 not null,
   tm_spent int(11) default 0 not null,
   primary key (id),
   key phone_idx(tx_date, phone)
);

create table powerapp_udr_summary (
   phone varchar(12) not null, 
   plan varchar(16) not null, 
   tx_date  date not null,
   tx_usage int(11) default 0 not null, 
   tx_cost  int(11) default 0 not null,
   tm_spent int(11) default 0 not null,
   primary key (tx_date, phone, plan)
);


drop PROCEDURE sp_generate_udr_usage;
delimiter //

CREATE PROCEDURE sp_generate_udr_usage(p_trandate date)
BEGIN
   truncate table powerapp_udr_detail;
   select p_trandate, date_add(p_trandate, interval 1 day) into @vStart, @vEnd;
   insert into powerapp_udr_detail (id, phone, plan, validity, tx_date, tx_time, tx_cost, service)
   select a.id, a.phone, a.plan, a.validity, left(a.datein,10) tx_date, a.datein, IFNULL(b.cost,0), b.service
   from   powerapp_log a left outer join powerapp_plans b on (a.plan = b.plan and a.validity = b.validity)
   where  a.datein between @vStart and @vEnd
   and    a.phone like '63%'
   and    a.free='false';

   BEGIN
      DECLARE done, done_s int default 0;
      DECLARE vId, vValidity bigint(20);
      DECLARE vPhone varchar(12);
      DECLARE vTmStart, vTmEnd, vService varchar(30);
      DECLARE c cursor FOR SELECT id, phone, tx_time tx_start, validity, service FROM powerapp_udr_detail WHERE tx_date = @vStart;

      SET net_write_timeout=12000;
      SET global connect_timeout=12000;
      SET net_read_timeout=12000;
      SET @nCtr =0 ;
      BEGIN
         declare continue handler for sqlstate '02000' set done = 1;
         OPEN c;
         REPEAT
            SET vId=null;
            SET vPhone=null;
            SET vTmStart=null;
            SET vValidity=null;
            SET vService=null;
            FETCH c INTO vId, vPhone, vTmStart, vValidity, vService;
            if not done then
               begin
                  declare continue handler for sqlstate '02000' set done_s = 1;

                  SELECT date_add(vTmStart, interval vValidity second) INTO vTmEnd;

                  SELECT ifnull(sum(b_usage),0), ifnull(sum(to_seconds(end_tm)-to_seconds(start_tm)),0)
                  into   @b_usage, @t_usage
                  FROM   powerapp_udr_log
                  WHERE  phone = vPhone
                  and    tx_date >= @vStart
                  and    service = vService
                  and    start_tm between vTmStart and vTmEnd;

                  UPDATE  powerapp_udr_detail
                  SET     tx_usage = @b_usage,
                          tm_spent = @t_usage
                  WHERE   id=vId;
               end;
            end if;
         UNTIL done
         END REPEAT;
         close c;
      END;
   END;


   delete from powerapp_udr_summary where tx_date = @vStart;
   insert into powerapp_udr_summary (phone, plan, tx_date, tx_usage, tx_cost, tm_spent, tx_week, tx_weekday)
   select phone, plan, tx_date, sum(tx_usage), sum(tx_cost), sum(tm_spent), week(@vStart), dayofweek(@vStart)
   from   powerapp_udr_detail
   where  tx_date = @vStart
   group  by phone, tx_date, plan;

   delete from boost_usage where datein >= @vStart and datein < @vEnd;
   insert into boost_usage (datein, phone, ipaddr, used_byte) 
   select start_tm, phone, ip_addr, b_usage 
   from   powerapp_udr_log 
   where  service = 'PisonetService'
   and    tx_date = @vStart;
 
END;
//

delimiter ;
GRANT EXECUTE ON PROCEDURE `archive_powerapp_flu`.`sp_generate_udr_usage` TO 'stats'@'localhost';
flush privileges;


call sp_generate_udr_usage('2014-07-05');
select phone, plan, tx_date, tx_usage, tx_cost, tm_spent 
into outfile '/tmp/powerapp_udr_20140706.csv' fields terminated by ',' lines terminated by '\n' 
from (
select  0 seq, 'Phone' phone, 'Plan' plan, 'Date' tx_date, 'Usage' tx_usage, 'Cost' tx_cost, 'Time Spent' tm_spent union
select  1 seq, phone, plan, tx_date, tx_usage, tx_cost, tm_spent from powerapp_udr_summary where tx_date = '2014-07-06'
) t1
order by seq;

select * from powerapp_udr_summary where tx_usage > 0 limit 10;
   insert into powerapp_udr_summary (phone, plan, tx_date, tx_usage, tx_cost, tm_spent)
   select phone, plan, tx_date, sum(tx_usage), sum(tx_cost), sum(tm_spent) 
   from   powerapp_udr_detail
   where  tx_date = '2014-06-24'
   group  by phone, tx_date, plan;



select '2014-07-06' into @tran_dt;
select 0 into @rownum;
select 'TOP 10 Based on Usage' Category;
select concat('TOP ', @rownum:=@rownum+1) Rank, t.* from (
   select phone, plan, tx_date, sum(tx_usage) b_usage, sum(tx_cost) cost, sum(tm_spent) tm_spent
   from   powerapp_udr_summary
   where  tx_date = @tran_dt
   group  by phone, tx_date, plan
   order by 4 desc
   ) t
limit 10;


select 0 into @rownum;
select 'TOP 10 Based on Buys' Category;
select concat('TOP ', @rownum:=@rownum+1) Rank, t.* from (
   select phone, plan, tx_date, sum(tx_usage) b_usage, sum(tx_cost) cost, sum(tm_spent) tm_spent
   from   powerapp_udr_summary
   where  tx_date = @tran_dt
   group  by phone, tx_date, plan
   order by 5 desc
   ) t
limit 10;

select 0 into @rownum;
select 'TOP 10 Based on Time Spent' Category;
select concat('TOP ', @rownum:=@rownum+1) Rank, t.* from (
   select phone, plan, tx_date, sum(tx_usage) b_usage, sum(tx_cost) cost, sum(tm_spent) tm_spent 
   from   powerapp_udr_summary
   where  tx_date = @tran_dt
   group  by phone, tx_date, plan
   order by 6 desc
   ) t
limit 10;









echo "" >> $fname1
echo "TOP 10 Based on MB Spent per Day" >> $fname1
echo "select 0 into @rownum;
select concat('TOP ', @rownum:=@rownum+1) Rank, t.* from (
   select phone, round(sum(tx_usage)/1000000,0) MB_Spent, sum(tx_cost) Money_Spent, sum(tm_spent) Time_Spent
   from   powerapp_udr_summary
   where  tx_date = '$tx_date'
   group  by phone
   order by 2 desc
   ) t
limit 10" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 -t >> $fname1

echo "" >> $fname1
echo "" >> $fname1
echo "TOP 10 Based on MB Spent per Plan per Day" >> $fname1
echo "select 0 into @rownum;
select concat('TOP ', @rownum:=@rownum+1) Rank, t.* from (
   select phone, plan, round(sum(tx_usage)/1000000,0) MB_Spent, sum(tx_cost) Money_Spent, sum(tm_spent) Time_Spent
   from   powerapp_udr_summary
   where  tx_date = '$tx_date'
   group  by phone, plan
   order by 3 desc
   ) t
limit 10" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 -t >> $fname1

echo "" >> $fname1
echo "TOP 10 Based on Money Spent per Plan per Day" >> $fname1
echo "select 0 into @rownum;
select concat('TOP ', @rownum:=@rownum+1) Rank, t.* from (
   select phone, plan, round(sum(tx_usage)/1000000,0) MB_Spent, sum(tx_cost) Money_Spent, sum(tm_spent) Time_Spent
   from   powerapp_udr_summary
   where  tx_date = '$tx_date'
   group  by phone, plan
   order by 4 desc
   ) t
limit 10" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 -t >> $fname1

echo "" >> $fname1
echo "TOP 10 Based on Time Spent per Plan per Day" >> $fname1
echo "select 0 into @rownum;
select concat('TOP ', @rownum:=@rownum+1) Rank, t.* from (
   select phone, plan, round(sum(tx_usage)/1000000,0) MB_Spent, sum(tx_cost) Money_Spent, sum(tm_spent) Time_Spent
   from   powerapp_udr_summary
   where  tx_date = '$tx_date'
   group  by phone, plan
   order by 5 desc
   ) t
limit 10" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 -t >> $fname1

echo "" >> $fname1
echo "TOP 10 Based on Money Spent per Plan per Day (Zero MB Spent )" >> $fname1
echo "select 0 into @rownum;
select concat('TOP ', @rownum:=@rownum+1) Rank, t.* from (
   select phone, plan, round(sum(tx_usage)/1000000,0) MB_Spent, sum(tx_cost) Money_Spent, sum(tm_spent) Time_Spent
   from   powerapp_udr_summary
   where  tx_date = '2014-07-06'
   and    tx_usage = 0
   group  by phone, plan
   order by 4 desc
   ) t
limit 10" | mysql -ustats -p$p archive_powerapp_flu -h10.11.4.164 -P3309 -t >> $fname1


create temporary table tmp_udr_top10 (phone varchar(12), plan varchar(20), key (phone,plan));
truncate table tmp_udr_top10;
insert into tmp_udr_top10 
select phone, plan from (
   select phone, plan, round(sum(tx_usage)/1000000,0) MB_Spent, sum(tx_cost) Money_Spent, sum(tm_spent) Time_Spent
   from   powerapp_udr_summary
   where  tx_date = '2014-06-28'
   and    tx_usage = 0
   group  by phone, plan
   order by 4 desc
   ) t
limit 10;

select a.* from powerapp_log a, tmp_udr_top10 b
where a.datein >= '2014-06-28' and a.datein < '2014-06-29'
and a.phone = b.phone
and a.plan  = b.plan
order by phone,id;


+----------+---------------------+--------------+-------+--------+--------+----------+-------+---------------------+---------------------+------------+
| id       | datein              | phone        | brand | action | plan   | validity | free  | start_tm            | end_tm              | source     |
+----------+---------------------+--------------+-------+--------+--------+----------+-------+---------------------+---------------------+------------+
| 14753017 | 2014-06-28 21:48:11 | 639092496858 | TNT   | NEW    | UNLI   |    86400 | false | 2014-06-28 21:48:11 | 2014-06-29 21:48:11 | sms_user   |
| 14695715 | 2014-06-28 09:22:14 | 639096884918 | TNT   | NEW    | UNLI   |    86400 | false | 2014-06-28 09:22:14 | 2014-06-29 09:22:14 | sms_user   |
| 14722880 | 2014-06-28 15:41:58 | 639185790722 | BUDDY | NEW    | UNLI   |    86400 | false | 2014-06-28 15:41:58 | 2014-06-29 15:41:58 | sms_user   |
| 14727811 | 2014-06-28 17:03:03 | 639185790722 | BUDDY | EXTEND | UNLI   |    86400 | false | 2014-06-28 15:41:58 | 2014-06-30 15:41:58 | sms_user   |
| 14709460 | 2014-06-28 12:28:28 | 639197800906 | TNT   | NEW    | UNLI   |    86400 | false | 2014-06-28 12:28:28 | 2014-06-29 12:28:28 | sms_user   |
| 14757415 | 2014-06-28 22:45:07 | 639219943661 | BUDDY | NEW    | UNLI   |    86400 | false | 2014-06-28 22:45:07 | 2014-06-29 22:45:07 | sms_user   |
| 14751388 | 2014-06-28 21:29:13 | 639281487220 | BUDDY | EXTEND | WECHAT |    86400 | false | 2014-06-25 00:52:38 | 2014-07-04 03:30:09 | smartphone |
| 14752532 | 2014-06-28 21:42:04 | 639281487220 | BUDDY | EXTEND | WECHAT |    86400 | false | 2014-06-28 21:29:13 | 2014-07-05 03:30:09 | smartphone |
| 14754029 | 2014-06-28 22:00:19 | 639281487220 | BUDDY | EXTEND | WECHAT |    86400 | false | 2014-06-28 21:42:04 | 2014-07-06 03:30:09 | smartphone |
| 14754562 | 2014-06-28 22:07:43 | 639281487220 | BUDDY | EXTEND | WECHAT |    86400 | false | 2014-06-28 22:00:19 | 2014-07-07 03:30:09 | smartphone |
| 14759970 | 2014-06-28 23:21:18 | 639281487220 | BUDDY | EXTEND | WECHAT |    86400 | false | 2014-06-28 22:07:43 | 2014-07-08 03:30:09 | smartphone |
| 14746722 | 2014-06-28 20:42:45 | 639298229978 | BUDDY | NEW    | UNLI   |    86400 | false | 2014-06-28 20:42:45 | 2014-06-29 20:42:45 | sms_user   |
| 14747199 | 2014-06-28 20:47:07 | 639298229978 | BUDDY | EXTEND | UNLI   |    86400 | false | 2014-06-28 20:42:45 | 2014-06-30 20:42:45 | sms_user   |
| 14716713 | 2014-06-28 13:58:22 | 639473402773 | BUDDY | NEW    | UNLI   |    10800 | false | 2014-06-28 13:58:22 | 2014-06-28 16:58:22 | sms_user   |
| 14716993 | 2014-06-28 14:02:33 | 639473402773 | BUDDY | EXTEND | UNLI   |    86400 | false | 2014-06-28 13:58:22 | 2014-06-29 16:58:22 | sms_user   |
| 14711829 | 2014-06-28 12:58:13 | 639494000109 | BUDDY | NEW    | UNLI   |    10800 | false | 2014-06-28 12:58:13 | 2014-06-28 15:58:13 | web        |
| 14754512 | 2014-06-28 22:07:02 | 639494000109 | BUDDY | NEW    | UNLI   |    86400 | false | 2014-06-28 22:07:02 | 2014-06-29 22:07:02 | web        |
| 14752028 | 2014-06-28 21:36:18 | 639991935629 | BUDDY | NEW    | UNLI   |    86400 | false | 2014-06-28 21:36:18 | 2014-06-29 21:36:18 | sms_user   |
+----------+---------------------+--------------+-------+--------+--------+----------+-------+---------------------+---------------------+------------+
18 rows in set (0.80 sec)




################################  
alter table powerapp_udr_summary add key weekday_idx(tx_weekday, tx_week);
create view vw_powerapp_udr_mb_week_log as
select phone, plan, tx_week, tx_date, sum(tx_usage) tx_weekday_1, 0 tx_weekday_2, 0 tx_weekday_3, 0 tx_weekday_4, 0 tx_weekday_5, 0 tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 0 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, sum(tx_usage) tx_weekday_2, 0 tx_weekday_3, 0 tx_weekday_4, 0 tx_weekday_5, 0 tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 1 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, 0 tx_weekday_2, sum(tx_usage) tx_weekday_3, 0 tx_weekday_4, 0 tx_weekday_5, 0 tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 2 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, 0 tx_weekday_2, 0 tx_weekday_3, sum(tx_usage) tx_weekday_4, 0 tx_weekday_5, 0 tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 3 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, 0 tx_weekday_2, 0 tx_weekday_3, 0 tx_weekday_4, sum(tx_usage) tx_weekday_5, 0 tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 4 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, 0 tx_weekday_2, 0 tx_weekday_3, 0 tx_weekday_4, 0 tx_weekday_5, sum(tx_usage) tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 5 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, 0 tx_weekday_2, 0 tx_weekday_3, 0 tx_weekday_4, 0 tx_weekday_5, 0 tx_weekday_6, sum(tx_usage) tx_weekday_7 from powerapp_udr_summary where tx_weekday = 6 group by phone, plan, tx_week, tx_date;

create view vw_powerapp_udr_tm_week_log as
select phone, plan, tx_week, tx_date, sum(tm_spent) tx_weekday_1, 0 tx_weekday_2, 0 tx_weekday_3, 0 tx_weekday_4, 0 tx_weekday_5, 0 tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 0 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, sum(tm_spent) tx_weekday_2, 0 tx_weekday_3, 0 tx_weekday_4, 0 tx_weekday_5, 0 tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 1 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, 0 tx_weekday_2, sum(tm_spent) tx_weekday_3, 0 tx_weekday_4, 0 tx_weekday_5, 0 tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 2 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, 0 tx_weekday_2, 0 tx_weekday_3, sum(tm_spent) tx_weekday_4, 0 tx_weekday_5, 0 tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 3 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, 0 tx_weekday_2, 0 tx_weekday_3, 0 tx_weekday_4, sum(tm_spent) tx_weekday_5, 0 tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 4 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, 0 tx_weekday_2, 0 tx_weekday_3, 0 tx_weekday_4, 0 tx_weekday_5, sum(tm_spent) tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 5 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, 0 tx_weekday_2, 0 tx_weekday_3, 0 tx_weekday_4, 0 tx_weekday_5, 0 tx_weekday_6, sum(tm_spent) tx_weekday_7 from powerapp_udr_summary where tx_weekday = 6 group by phone, plan, tx_week, tx_date;

create view vw_powerapp_udr_co_week_log as
select phone, plan, tx_week, tx_date, sum(tx_cost) tx_weekday_1, 0 tx_weekday_2, 0 tx_weekday_3, 0 tx_weekday_4, 0 tx_weekday_5, 0 tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 0 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, sum(tx_cost) tx_weekday_2, 0 tx_weekday_3, 0 tx_weekday_4, 0 tx_weekday_5, 0 tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 1 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, 0 tx_weekday_2, sum(tx_cost) tx_weekday_3, 0 tx_weekday_4, 0 tx_weekday_5, 0 tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 2 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, 0 tx_weekday_2, 0 tx_weekday_3, sum(tx_cost) tx_weekday_4, 0 tx_weekday_5, 0 tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 3 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, 0 tx_weekday_2, 0 tx_weekday_3, 0 tx_weekday_4, sum(tx_cost) tx_weekday_5, 0 tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 4 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, 0 tx_weekday_2, 0 tx_weekday_3, 0 tx_weekday_4, 0 tx_weekday_5, sum(tx_cost) tx_weekday_6, 0 tx_weekday_7 from powerapp_udr_summary where tx_weekday = 5 group by phone, plan, tx_week, tx_date union
select phone, plan, tx_week, tx_date, 0 tx_weekday_1, 0 tx_weekday_2, 0 tx_weekday_3, 0 tx_weekday_4, 0 tx_weekday_5, 0 tx_weekday_6, sum(tx_cost) tx_weekday_7 from powerapp_udr_summary where tx_weekday = 6 group by phone, plan, tx_week, tx_date;

drop view vw_powerapp_udr_week_log;
create view vw_powerapp_udr_week_log as
select phone, plan, tx_week,
       sum(tx_weekday_1) tx_wkday_mb_1, 
       sum(tx_weekday_2) tx_wkday_mb_2, 
       sum(tx_weekday_3) tx_wkday_mb_3, 
       sum(tx_weekday_4) tx_wkday_mb_4, 
       sum(tx_weekday_5) tx_wkday_mb_5, 
       sum(tx_weekday_6) tx_wkday_mb_6, 
       sum(tx_weekday_7) tx_wkday_mb_7, 
       sum(tx_weekday_1) +
       sum(tx_weekday_2) +
       sum(tx_weekday_3) +
       sum(tx_weekday_4) +
       sum(tx_weekday_5) +
       sum(tx_weekday_6) +
       sum(tx_weekday_7) tx_wkday_mb_total,
       0 tx_wkday_tm_1,
       0 tx_wkday_tm_2,
       0 tx_wkday_tm_3,
       0 tx_wkday_tm_4,
       0 tx_wkday_tm_5,
       0 tx_wkday_tm_6,
       0 tx_wkday_tm_7,
       0 tx_wkday_tm_total,
       0 tx_wkday_co_1,
       0 tx_wkday_co_2,
       0 tx_wkday_co_3,
       0 tx_wkday_co_4,
       0 tx_wkday_co_5,
       0 tx_wkday_co_6,
       0 tx_wkday_co_7,
       0 tx_wkday_co_total
from vw_powerapp_udr_mb_week_log
group by phone, plan, tx_week
union  
select phone, plan, tx_week,
       0 tx_wkday_mb_1,
       0 tx_wkday_mb_2,
       0 tx_wkday_mb_3,
       0 tx_wkday_mb_4,
       0 tx_wkday_mb_5,
       0 tx_wkday_mb_6,
       0 tx_wkday_mb_7,
       0 tx_wkday_mb_total,
       sum(tx_weekday_1) tx_wkday_tm_1, 
       sum(tx_weekday_2) tx_wkday_tm_2, 
       sum(tx_weekday_3) tx_wkday_tm_3, 
       sum(tx_weekday_4) tx_wkday_tm_4, 
       sum(tx_weekday_5) tx_wkday_tm_5, 
       sum(tx_weekday_6) tx_wkday_tm_6, 
       sum(tx_weekday_7) tx_wkday_tm_7, 
       sum(tx_weekday_1) +
       sum(tx_weekday_2) +
       sum(tx_weekday_3) +
       sum(tx_weekday_4) +
       sum(tx_weekday_5) +
       sum(tx_weekday_6) +
       sum(tx_weekday_7) tx_wkday_tm_total,
       0 tx_wkday_co_1,
       0 tx_wkday_co_2,
       0 tx_wkday_co_3,
       0 tx_wkday_co_4,
       0 tx_wkday_co_5,
       0 tx_wkday_co_6,
       0 tx_wkday_co_7,
       0 tx_wkday_co_total 
from vw_powerapp_udr_tm_week_log
group by phone, plan, tx_week
union
select phone, plan, tx_week,
       0 tx_wkday_mb_1,
       0 tx_wkday_mb_2,
       0 tx_wkday_mb_3,
       0 tx_wkday_mb_4,
       0 tx_wkday_mb_5,
       0 tx_wkday_mb_6,
       0 tx_wkday_mb_7,
       0 tx_wkday_mb_total,
       0 tx_wkday_tm_1,
       0 tx_wkday_tm_2,
       0 tx_wkday_tm_3,
       0 tx_wkday_tm_4,
       0 tx_wkday_tm_5,
       0 tx_wkday_tm_6,
       0 tx_wkday_tm_7,
       0 tx_wkday_tm_total,
       sum(tx_weekday_1) tx_wkday_co_1, 
       sum(tx_weekday_2) tx_wkday_co_2, 
       sum(tx_weekday_3) tx_wkday_co_3, 
       sum(tx_weekday_4) tx_wkday_co_4, 
       sum(tx_weekday_5) tx_wkday_co_5, 
       sum(tx_weekday_6) tx_wkday_co_6, 
       sum(tx_weekday_7) tx_wkday_co_7, 
       sum(tx_weekday_1) +
       sum(tx_weekday_2) +
       sum(tx_weekday_3) +
       sum(tx_weekday_4) +
       sum(tx_weekday_5) +
       sum(tx_weekday_6) +
       sum(tx_weekday_7) tx_wkday_co_total 
from vw_powerapp_udr_co_week_log
group by phone, plan, tx_week
;

drop view vw_powerapp_udr_weekly;
create view vw_powerapp_udr_weekly_plan as
select phone, plan, tx_week, 
       sum(tx_wkday_mb_1) tx_wkday_mb_1,
       sum(tx_wkday_mb_2) tx_wkday_mb_2,
       sum(tx_wkday_mb_3) tx_wkday_mb_3,
       sum(tx_wkday_mb_4) tx_wkday_mb_4,
       sum(tx_wkday_mb_5) tx_wkday_mb_5,
       sum(tx_wkday_mb_6) tx_wkday_mb_6,
       sum(tx_wkday_mb_7) tx_wkday_mb_7,
       sum(tx_wkday_mb_total) tx_wkday_mb_total,
       sum(tx_wkday_tm_1) tx_wkday_tm_1,
       sum(tx_wkday_tm_2) tx_wkday_tm_2,
       sum(tx_wkday_tm_3) tx_wkday_tm_3,
       sum(tx_wkday_tm_4) tx_wkday_tm_4,
       sum(tx_wkday_tm_5) tx_wkday_tm_5,
       sum(tx_wkday_tm_6) tx_wkday_tm_6,
       sum(tx_wkday_tm_7) tx_wkday_tm_7,
       sum(tx_wkday_tm_total) tx_wkday_tm_total,
       sum(tx_wkday_co_1) tx_wkday_co_1, 
       sum(tx_wkday_co_2) tx_wkday_co_2, 
       sum(tx_wkday_co_3) tx_wkday_co_3, 
       sum(tx_wkday_co_4) tx_wkday_co_4, 
       sum(tx_wkday_co_5) tx_wkday_co_5, 
       sum(tx_wkday_co_6) tx_wkday_co_6, 
       sum(tx_wkday_co_7) tx_wkday_co_7, 
       sum(tx_wkday_co_total) tx_wkday_co_total, 
       count(1) tx_wkday_wk_count
from   vw_powerapp_udr_week_log
group  by phone, plan, tx_week;

select * from vw_powerapp_udr_weekly where tx_week = 25 order by tx_wkday_wk_count desc limit 10;

set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;


drop view vw_powerapp_udr_weekly_subs;
create view vw_powerapp_udr_weekly_subs as
select phone, tx_week, 
       sum(tx_wkday_mb_1) tx_wkday_mb_1,
       sum(tx_wkday_mb_2) tx_wkday_mb_2,
       sum(tx_wkday_mb_3) tx_wkday_mb_3,
       sum(tx_wkday_mb_4) tx_wkday_mb_4,
       sum(tx_wkday_mb_5) tx_wkday_mb_5,
       sum(tx_wkday_mb_6) tx_wkday_mb_6,
       sum(tx_wkday_mb_7) tx_wkday_mb_7,
       sum(tx_wkday_mb_total) tx_wkday_mb_total,
       sum(tx_wkday_tm_1) tx_wkday_tm_1,
       sum(tx_wkday_tm_2) tx_wkday_tm_2,
       sum(tx_wkday_tm_3) tx_wkday_tm_3,
       sum(tx_wkday_tm_4) tx_wkday_tm_4,
       sum(tx_wkday_tm_5) tx_wkday_tm_5,
       sum(tx_wkday_tm_6) tx_wkday_tm_6,
       sum(tx_wkday_tm_7) tx_wkday_tm_7,
       sum(tx_wkday_tm_total) tx_wkday_tm_total,
       sum(tx_wkday_co_1) tx_wkday_co_1, 
       sum(tx_wkday_co_2) tx_wkday_co_2, 
       sum(tx_wkday_co_3) tx_wkday_co_3, 
       sum(tx_wkday_co_4) tx_wkday_co_4, 
       sum(tx_wkday_co_5) tx_wkday_co_5, 
       sum(tx_wkday_co_6) tx_wkday_co_6, 
       sum(tx_wkday_co_7) tx_wkday_co_7, 
       sum(tx_wkday_co_total) tx_wkday_co_total, 
       count(1) tx_wkday_wk_count
from   vw_powerapp_udr_week_log
group  by phone, tx_week;


create table powerapp_udr_weekly_report (
   phone       varchar(12) not null,  
   plan        varchar(16) not null, 
   tx_week     smallint(6) not null,
   tx_day_1_mb decimal(32,0) default 0,
   tx_day_2_mb decimal(32,0) default 0,
   tx_day_3_mb decimal(32,0) default 0,
   tx_day_4_mb decimal(32,0) default 0,
   tx_day_5_mb decimal(32,0) default 0,
   tx_day_6_mb decimal(32,0) default 0,
   tx_day_7_mb decimal(32,0) default 0,
   tx_day_t_mb decimal(32,0) default 0,
   tx_day_1_co decimal(32,0) default 0,
   tx_day_2_co decimal(32,0) default 0,
   tx_day_3_co decimal(32,0) default 0,
   tx_day_4_co decimal(32,0) default 0,
   tx_day_5_co decimal(32,0) default 0,
   tx_day_6_co decimal(32,0) default 0,
   tx_day_7_co decimal(32,0) default 0,
   tx_day_t_co decimal(32,0) default 0,
   tx_day_1_tm decimal(32,0) default 0,
   tx_day_2_tm decimal(32,0) default 0,
   tx_day_3_tm decimal(32,0) default 0,
   tx_day_4_tm decimal(32,0) default 0,
   tx_day_5_tm decimal(32,0) default 0,
   tx_day_6_tm decimal(32,0) default 0,
   tx_day_7_tm decimal(32,0) default 0,
   tx_day_t_tm decimal(32,0) default 0,
   primary key (plan, phone, tx_week)
);

DROP PROCEDURE sp_generate_udr_report; 
delimiter //
CREATE PROCEDURE sp_generate_udr_report (p_weekno int) 
BEGIN
   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   delete from powerapp_udr_weekly_report where tx_week = p_weekno;
   insert into powerapp_udr_weekly_report (phone, plan, tx_week) select phone, plan, tx_week from powerapp_udr_summary where tx_week = p_weekno group by phone, plan, tx_week;
   BEGIN
      DECLARE done, done_s int default 0;
      DECLARE vPhone, vPlan varchar(30);
      DECLARE c cursor FOR SELECT phone, plan FROM powerapp_udr_summary;

      SET @nCtr =0 ;
      BEGIN
         declare continue handler for sqlstate '02000' set done = 1;
         OPEN c;
         REPEAT
            SET vPhone=null;
            SET vPlan=null;
            FETCH c INTO vPhone, vPlan;
            if not done then
               select ifnull(sum(tx_usage),0), ifnull(sum(tx_cost),0), ifnull(sum(tm_spent),0) into @nUsage_1, @nCost_1, @nTime_1 from powerapp_udr_summary where phone = vPhone and plan = vPlan and tx_week = p_weekno and tx_weekday = 0;
               select ifnull(sum(tx_usage),0), ifnull(sum(tx_cost),0), ifnull(sum(tm_spent),0) into @nUsage_2, @nCost_2, @nTime_2 from powerapp_udr_summary where phone = vPhone and plan = vPlan and tx_week = p_weekno and tx_weekday = 1;
               select ifnull(sum(tx_usage),0), ifnull(sum(tx_cost),0), ifnull(sum(tm_spent),0) into @nUsage_3, @nCost_3, @nTime_3 from powerapp_udr_summary where phone = vPhone and plan = vPlan and tx_week = p_weekno and tx_weekday = 2;
               select ifnull(sum(tx_usage),0), ifnull(sum(tx_cost),0), ifnull(sum(tm_spent),0) into @nUsage_4, @nCost_4, @nTime_4 from powerapp_udr_summary where phone = vPhone and plan = vPlan and tx_week = p_weekno and tx_weekday = 3;
               select ifnull(sum(tx_usage),0), ifnull(sum(tx_cost),0), ifnull(sum(tm_spent),0) into @nUsage_5, @nCost_5, @nTime_5 from powerapp_udr_summary where phone = vPhone and plan = vPlan and tx_week = p_weekno and tx_weekday = 4;
               select ifnull(sum(tx_usage),0), ifnull(sum(tx_cost),0), ifnull(sum(tm_spent),0) into @nUsage_6, @nCost_6, @nTime_6 from powerapp_udr_summary where phone = vPhone and plan = vPlan and tx_week = p_weekno and tx_weekday = 5;
               select ifnull(sum(tx_usage),0), ifnull(sum(tx_cost),0), ifnull(sum(tm_spent),0) into @nUsage_7, @nCost_7, @nTime_7 from powerapp_udr_summary where phone = vPhone and plan = vPlan and tx_week = p_weekno and tx_weekday = 6;
               update powerapp_udr_weekly_report
               set    tx_day_1_mb = @nUsage_1, tx_day_2_mb = @nUsage_2, tx_day_3_mb = @nUsage_3, tx_day_4_mb = @nUsage_4, tx_day_5_mb = @nUsage_5, tx_day_6_mb = @nUsage_6, tx_day_7_mb = @nUsage_7,
                      tx_day_t_mb = @nUsage_1+@nUsage_2+@nUsage_3+@nUsage_4+@nUsage_5+@nUsage_6+@nUsage_7,
                      tx_day_1_co = @nCost_1, tx_day_2_co = @nCost_2, tx_day_3_co = @nCost_3, tx_day_4_co = @nCost_4, tx_day_5_co = @nCost_5, tx_day_6_co = @nCost_6, tx_day_7_co = @nCost_7,
                      tx_day_t_co = @nCost_1+@nCost_2+@nCost_3+@nCost_4+@nCost_5+@nCost_6+@nCost_7,
                      tx_day_1_tm = @nTime_1, tx_day_2_tm = @nTime_2, tx_day_3_tm = @nTime_3, tx_day_4_tm = @nTime_4, tx_day_5_tm = @nTime_5, tx_day_6_tm = @nTime_6, tx_day_7_tm = @nTime_7,
                      tx_day_t_tm = @nTime_1+@nTime_2+@nTime_3+@nTime_4+@nTime_5+@nTime_6+@nTime_7
               where  phone = vPhone
               and    plan  = vPlan
               and    tx_week = p_weekno;
            end if;
         UNTIL done
         END REPEAT;
         close c;
      END;
   END;

END;
//
delimiter ;
call sp_generate_udr_report(27);

select * from powerapp_udr_weekly_report;









***********************************************************************
***********************************************************************
***********************************************************************


drop procedure  sp_generate_udr_usage;
delimiter //
CREATE PROCEDURE sp_generate_udr_usage(p_trandate varchar(10))
begin
   declare vID int;
   declare vPhone, dStart, dEnd, vService varchar(30);
   declare done_p int default 0;
   declare c_pat cursor for
      select a.id, a.phone, a.start_tm, a.end_tm, max(b.service) service
      from   powerapp_log a, powerapp_plans b
      where  a.plan = b.plan
      and    a.datein >= p_trandate and a.datein < date_add(p_trandate, interval 1 day)
      group  by a.id, a.phone, a.start_tm, a.end_tm;

   declare continue handler for sqlstate '02000' set done_p = 1;

   OPEN c_pat;
   REPEAT
   FETCH c_pat into vID, vPhone, dStart, dEnd, vService;
      if not done_p then
         begin
            declare continue handler for sqlstate '02000' set @nUsage = 0;
            set @nUsage = 0;
            set @vDevice = '';
            select IFNULL(sum(b_usage),0), max(device)
            into   @nUsage, @vDevice
            from   powerapp_udr_log
            where  tx_date = p_trandate
            and    phone = vPhone
            and    service = vService
            and    start_tm between dStart and dEnd;
            UPDATE powerapp_log
            SET    b_usage = @nUsage,
                   device=@vDevice
            where  id = vID;
         end;
      end if;
   UNTIL done_p
   END REPEAT;

   insert ignore into powerapp_whitelisted_log (tx_date, phone, device, b_usage, b_time)
   select tx_date, phone, max(device), sum(b_usage), sum(time_to_sec(timediff(end_tm, start_tm)))
   from   powerapp_udr_log
   where  service = 'Whitelisted'
   group  by tx_date, phone
   having sum(b_usage) > 0;

   drop temporary table if exists tmp_powerapp_mins;
   create temporary table tmp_powerapp_mins (phone varchar(12) not null, primary key (phone));
   insert ignore into tmp_powerapp_mins select phone from powerapp_log where datein >= p_trandate and datein < date_add(p_trandate, interval 1 day) group by phone;
   insert ignore into powerapp_whitelisted_log (tx_date, phone, device, b_usage, b_time, service)
   select tx_date, phone, max(device), sum(b_usage), sum(time_to_sec(timediff(end_tm, start_tm))), service
   from   powerapp_udr_log a
   where  service <> 'Whitelisted'
   and    not exists (select 1 from tmp_powerapp_mins b where a.phone = b.phone)
   group  by tx_date, phone, service
   having sum(b_usage) > 0;

end;
//
delimiter ;

GRANT EXECUTE ON PROCEDURE `archive_powerapp_flu`.`sp_generate_udr_usage` TO 'stats'@'localhost';







create table tmp_udr_report (phone varchar(12) not null, source varchar(20) not null, tx_time bigint(18) default 0, tx_usage bigint(18) default 0, primary key (phone, source));
insert into tmp_udr_report select phone, source, sum(time_to_sec(timediff(end_tm,start_tm))) tx_time, sum(b_usage) tx_usage from powerapp_udr_log where tx_date='2014-10-22' group by phone, source;

select phone, sum(tx_time)/60 tx_time_mi, sum(tx_usage)/1000000 tx_usage_mb, group_concat(concat(source,':',tx_time,':',tx_usage) separator ',') source 
from tmp_udr_report
order by 2 desc limit 20;


