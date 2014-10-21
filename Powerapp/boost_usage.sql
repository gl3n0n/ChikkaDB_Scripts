OP PROCEDURE sp_generate_boost_usage;
delimiter //
CREATE PROCEDURE sp_generate_boost_usage(p_trandate date)
BEGIN

   truncate table boost_users;
   insert into  boost_users  select a.*, 0, 0, date_add(a.datein, interval 10 minute) 
   from powerapp_log a 
   where datein between p_trandate  and date_add(p_trandate, interval 1 day)
   and plan = 'UNLI';

   BEGIN
      DECLARE done, done_s int default 0;
      DECLARE vId bigint(20);
      DECLARE vPhone varchar(12);
      DECLARE vDatein, vDateend varchar(20);
      DECLARE c cursor FOR SELECT id, phone, datein, date_add(datein, interval 10 minute) dateend FROM boost_users WHERE b_usage = 0;
   
      SET net_write_timeout=12000;
      SET global connect_timeout=12000;
      SET net_read_timeout=12000;
      BEGIN
         declare continue handler for sqlstate '02000' set done = 1;
         OPEN c;
         REPEAT
            SET vId=null;
            SET vPhone=null;
            SET vDatein=null;
            SET vDateend=null;
            FETCH c INTO vId, vPhone, vDatein, vDateend;
            if not done then
               begin
                  declare continue handler for sqlstate '02000' set done_s = 1;
   
                  SELECT ifnull(sum(used_byte),'-1'), count(1)
                  INTO   @b_usage, @c_usage
                  FROM   boost_usage
                  WHERE  phone = vPhone
                  and    datein between vDatein and vDateend;
   
                  UPDATE  boost_users
                  SET     b_usage = @b_usage,
                          c_usage = @c_usage
                  WHERE   id=vId;
               end;
            end if;
         UNTIL done
         END REPEAT;
         close c;
      END;
   END;
   -- generate stats
   select count(1) into @total_subs from boost_users where b_usage > 0;
   select p_trandate, grp_b, count(1) uniq, round((count(1)/@total_subs)*100,2) pct from (
   select phone, case 
                    when b_usage/1000000 > 50 then '50plus'
                    when b_usage/1000000 > 45 then '50mb'
                    when b_usage/1000000 > 40 then '45mb'
                    when b_usage/1000000 > 35 then '40mb'
                    when b_usage/1000000 > 30 then '35mb'
                    when b_usage/1000000 > 25 then '30mb'
                    when b_usage/1000000 > 20 then '25mb'
                    when b_usage/1000000 > 15 then '20mb'
                    when b_usage/1000000 > 10 then '15mb'
                    when b_usage/1000000 > 5  then '10mb'
                    when b_usage/1000000 > 0  then ' 5mb' 
                    end as grp_b
   from boost_users where b_usage > 0) as t1
   group by 1,2 order by 1,2;

END;
//
delimiter ;


drop procedure sp_generate_boost_every10;
delimiter //
create procedure sp_generate_boost_every10 (p_trandate date)
begin
   set @vCtr = 0;
   WHILE (@vCtr <= 23) DO
      set @tran_dt = date_add(p_trandate, interval (@vCtr*15) minute);
      truncate table boost_users;
      insert into  boost_users  select a.*, 0, 0, date_add(a.datein, interval 15 minute) 
      from powerapp_log a 
      where datein >= @tran_dt and datein < date_add(@tran_dt, interval 15 minute) 
      and plan = 'UNLI';

      call sp_generate_boost_usage();
      select count(1) into @total_subs from boost_users where b_usage > 0;
      insert into boost_stats (datein, grp, uniq, pct)
      select @tran_dt, grp_b, count(1) uniq, round((count(1)/@total_subs)*100,2) pct from (
      select phone, case 
                       when b_usage/1000000 > 50 then '50plus'
                       when b_usage/1000000 > 45 then '50mb'
                       when b_usage/1000000 > 40 then '45mb'
                       when b_usage/1000000 > 35 then '40mb'
                       when b_usage/1000000 > 30 then '35mb'
                       when b_usage/1000000 > 25 then '30mb'
                       when b_usage/1000000 > 20 then '25mb'
                       when b_usage/1000000 > 15 then '20mb'
                       when b_usage/1000000 > 10 then '15mb'
                       when b_usage/1000000 > 5  then '10mb'
                       when b_usage/1000000 > 0  then ' 5mb' 
                       end as grp_b
      from boost_users where b_usage > 0) as t1
      group by 1,2 order by 1,2;

      SET @vCtr = @vCtr + 1;
   END WHILE;
end;
//
delimiter ;

call sp_generate_boost_every15 ();

      truncate table boost_users;
      insert into  boost_users  select a.*, 0, 0, date_add(a.datein, interval 10 minute) 
      from powerapp_log a 
      where datein between '2014-05-18 00:00:00'  and '2014-05-18 16:00:00'
      and plan = 'UNLI';


10minute                  15minute                   20minute                  25minute                  30minute
+-------+------+-------+  +-------+------+-------+   +-------+------+-------+  +-------+------+-------+  +-------+------+-------+
| grp_b | uniq | pct   |  | grp_b | uniq | pct   |   | grp_b | uniq | pct   |  | grp_b | uniq | pct   |  | grp_b | uniq | pct   |
+-------+------+-------+  +-------+------+-------+   +-------+------+-------+  +-------+------+-------+  +-------+------+-------+
|  5mb  |  995 | 77.98 |  |  5mb  |  910 | 70.11 |   |  5mb  |  805 | 61.26 |  |  5mb  |  741 | 56.14 |  |  5mb  |  684 | 51.74 |
| 10mb  |  204 | 15.99 |  | 10mb  |  234 | 18.03 |   | 10mb  |  293 | 22.30 |  | 10mb  |  295 | 22.35 |  | 10mb  |  291 | 22.01 |
| 15mb  |   64 |  5.02 |  | 15mb  |  114 |  8.78 |   | 15mb  |  125 |  9.51 |  | 15mb  |  144 | 10.91 |  | 15mb  |  168 | 12.71 |
| 20mb  |   12 |  0.94 |  | 20mb  |   32 |  2.47 |   | 20mb  |   48 |  3.65 |  | 20mb  |   65 |  4.92 |  | 20mb  |   77 |  5.82 |
| 25mb  |    1 |  0.08 |  | 25mb  |    6 |  0.46 |   | 25mb  |   29 |  2.21 |  | 25mb  |   51 |  3.86 |  | 25mb  |   48 |  3.63 |
+-------+------+-------+  | 30mb  |    2 |  0.15 |   | 30mb  |   12 |  0.91 |  | 30mb  |   16 |  1.21 |  | 30mb  |   29 |  2.19 |
5 rows in set (0.01 sec)  +-------+------+-------+   | 35mb  |    2 |  0.15 |  | 35mb  |    7 |  0.53 |  | 35mb  |   14 |  1.06 |
                          6 rows in set (0.02 sec)   +-------+------+-------+  | 40mb  |    1 |  0.08 |  | 40mb  |    9 |  0.68 |
                                                     7 rows in set (0.01 sec)  +-------+------+-------+  | 45mb  |    2 |  0.15 |
                                                                               8 rows in set (0.01 sec)  +-------+------+-------+
                                                                                                         9 rows in set (0.01 sec)
                                                           
                                                           

update boost_users set b_usage=0,c_usage=0;
call sp_generate_boost_usage();

select count(1) into @total_subs from boost_users where b_usage > 0;
select grp_b, count(1) uniq, round((count(1)/@total_subs)*100,2) pct from (
select phone, case 
                 when b_usage/1000000 > 50 then '50plus'
                 when b_usage/1000000 > 45 then '50mb'
                 when b_usage/1000000 > 40 then '45mb'
                 when b_usage/1000000 > 35 then '40mb'
                 when b_usage/1000000 > 30 then '35mb'
                 when b_usage/1000000 > 25 then '30mb'
                 when b_usage/1000000 > 20 then '25mb'
                 when b_usage/1000000 > 15 then '20mb'
                 when b_usage/1000000 > 10 then '15mb'
                 when b_usage/1000000 > 5  then '10mb'
                 when b_usage/1000000 > 0  then ' 5mb' 
                 end as grp_b
                 
from boost_users where b_usage > 0) as t1
group by 1 order by 1;

10Minutes                  15Minutes                  20Minutes                   25Minutes                  30Minutes                  
+-------+------+-------+   +-------+------+-------+   +-------+------+-------+    +-------+------+-------+   +-------+------+-------+   
| grp_b | uniq | pct   |   | grp_b | uniq | pct   |   | grp_b | uniq | pct   |    | grp_b | uniq | pct   |   | grp_b | uniq | pct   |   
+-------+------+-------+   +-------+------+-------+   +-------+------+-------+    +-------+------+-------+   +-------+------+-------+   
| 5mb   | 2079 | 77.09 |   | 5mb   | 1875 | 68.41 |   | 5mb   | 1674 | 60.43 |    | 5mb   | 1544 | 55.44 |   | 5mb   | 1416 | 50.73 |   
| 10mb  |  457 | 16.94 |   | 10mb  |  558 | 20.36 |   | 10mb  |  636 | 22.96 |    | 10mb  |  629 | 22.59 |   | 10mb  |  620 | 22.21 |   
| 15mb  |  124 |  4.60 |   | 15mb  |  205 |  7.48 |   | 15mb  |  261 |  9.42 |    | 15mb  |  315 | 11.31 |   | 15mb  |  357 | 12.79 |   
| 20mb  |   30 |  1.11 |   | 20mb  |   75 |  2.74 |   | 20mb  |  117 |  4.22 |    | 20mb  |  149 |  5.35 |   | 20mb  |  178 |  6.38 |   
| 25mb  |    6 |  0.22 |   | 25mb  |   21 |  0.77 |   | 25mb  |   49 |  1.77 |    | 25mb  |   84 |  3.02 |   | 25mb  |  105 |  3.76 |   
| 30mb  |    1 |  0.04 |   | 30mb  |    6 |  0.22 |   | 30mb  |   25 |  0.90 |    | 30mb  |   42 |  1.51 |   | 30mb  |   58 |  2.08 |   
+-------+------+-------+   | 35mb  |    1 |  0.04 |   | 35mb  |    7 |  0.25 |    | 35mb  |   16 |  0.57 |   | 35mb  |   31 |  1.11 |   
6 rows in set (0.02 sec)   +-------+------+-------+   | 40mb  |    1 |  0.04 |    | 40mb  |    5 |  0.18 |   | 40mb  |   19 |  0.68 |   
                           7 rows in set (0.02 sec)   +-------+------+-------+    | 45mb  |    1 |  0.04 |   | 45mb  |    6 |  0.21 |   
                                                      8 rows in set (0.02 sec)    +-------+------+-------+   | 50mb  |    1 |  0.04 |  
                                                                                  9 rows in set (0.02 sec)   +-------+------+-------+  
                                                                                                             10 rows in set (0.02 sec)  


select avg(b_usage), count(1) uniq from boost_users where b_usage between 10000000 and 15000000;
+---------------+------+
| avg(b_usage)  | uniq |
+---------------+------+
| 12184356.1805 |  205 |
+---------------+------+
1 row in set (0.02 sec)


CREATE TABLE `boost_users` (
  `id` int(11) NOT NULL DEFAULT '0',
  `datein` datetime NOT NULL,
  `phone` varchar(12) NOT NULL,
  `brand` varchar(16) DEFAULT NULL,
  `action` varchar(16) DEFAULT NULL,
  `plan` varchar(16) DEFAULT NULL,
  `validity` int(11) DEFAULT '0',
  `free` enum('true','false') DEFAULT 'true',
  `start_tm` datetime DEFAULT NULL,
  `end_tm` datetime DEFAULT NULL,
  `source` varchar(30) DEFAULT NULL,
  `b_usage` bigint(12) DEFAULT '0',
  `c_usage` bigint(12) DEFAULT '0',
  `dateend` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `boost_usage` (
  `datein` datetime NOT NULL,
  `tz` varchar(10) DEFAULT NULL,
  `phone` varchar(12) NOT NULL,
  `used_byte` int(11) DEFAULT '0',
  `ipaddr` varchar(20) DEFAULT NULL,
  KEY `phone_idx` (`phone`)
);


CREATE TABLE `boost_stats` (
  `datein`   datetime NOT NULL,
  `grp`      varchar(10) DEFAULT NULL,
  `uniq`     int(11) NOT NULL,
  `pct`      decimal(5,2),
  `used_mb`  bigint(14),
  KEY `datein_grp_idx` (`datein`,`grp`)
);

load data local infile '/tmp/filtered.txt' into table boost_usage fields terminated by ','; 
load data local infile '/tmp/filtered2.txt' into table boost_usage fields terminated by ','; 

create table boost_tmp as 
SELECT a.id, a.phone, sum(b.used_byte)/1000000 b_usage  
FROM boost_users a  left outer join boost_usage b  on (a.phone=b.phone and b.datein between a.datein and a.dateend)
group by 1,2;

update boost_users set b_usage=0,c_usage=0;
call sp_generate_boost_usage();


select grp_b, count(1) from (
select phone, case 
                 when b_usage/1000000 > 50 then '50plus'
                 when b_usage/1000000 > 45 then '50mb'
                 when b_usage/1000000 > 40 then '45mb'
                 when b_usage/1000000 > 35 then '40mb'
                 when b_usage/1000000 > 30 then '35mb'
                 when b_usage/1000000 > 25 then '30mb'
                 when b_usage/1000000 > 20 then '25mb'
                 when b_usage/1000000 > 15 then '20mb'
                 when b_usage/1000000 > 10 then '15mb'
                 when b_usage/1000000 > 5  then '10mb'
                 when b_usage/1000000 > 0  then '5mb' 
                 end as grp_b
from boost_users) as t1 
group by 1;


                 

DROP PROCEDURE sp_generate_boost_usage;
delimiter //
CREATE PROCEDURE sp_generate_boost_usage(p_sta datetime, p_end datetime)
BEGIN

   DECLARE done, done_s int default 0;
   DECLARE vId bigint(20);
   DECLARE vPhone varchar(12);
   DECLARE vDateIn, vDateEnd varchar(20);
   DECLARE c cursor FOR 
      SELECT max(id) id, phone, max(datein), max(date_add(datein, interval 10 minute)) dateend
      FROM   boost_users 
      WHERE  b_usage = 0
      AND    datein <= p_sta
      group  by phone;

   SET net_write_timeout=12000;
   SET global connect_timeout=12000;
   SET net_read_timeout=12000;
   BEGIN
      declare continue handler for sqlstate '02000' set done = 1;
      OPEN c;
      REPEAT
         SET vId=null;
         SET vPhone=null;
         FETCH c INTO vId, vPhone, vDateIn, vDateEnd;
         if not done then
            begin
               declare continue handler for sqlstate '02000' set done_s = 1;

               SELECT ifnull(sum(used_byte),'-1'), count(1)
               INTO   @b_usage, @c_usage
               FROM   boost_usage
               WHERE  phone = vPhone
               and    datein between p_sta and p_end;

               UPDATE  boost_users
               SET     b_usage = @b_usage,
                       c_usage = @c_usage
               WHERE   id=vId;
            end;
         end if;
      UNTIL done
      END REPEAT;
      close c;
   END;

END;
//
delimiter ;

      truncate table boost_users;
      insert into  boost_users  select a.*, 0, 0, date_add(a.datein, interval 10 minute) 
      from powerapp_log a 
      where datein between '2014-05-18 00:00:00'  and '2014-05-19 00:00:00'
      and plan = 'UNLI';


drop procedure sp_generate_boost_every10 ;
delimiter //
create procedure sp_generate_boost_every10 ()
begin
   set @vCtr = 0;
   WHILE (@vCtr <= 1440) DO
      set @tran_dt1 = date_add('2014-05-18 00:00:00', interval @vCtr minute);
      set @tran_dt2 = date_add(@tran_dt1, interval 10 minute);
      update boost_users set b_usage=0;
      call sp_generate_boost_usage(@tran_dt1, @tran_dt2);
      select count(1) into @total_subs from boost_users where b_usage > 0;
      insert into boost_stats (datein, grp, uniq, pct, used_mb)
      select @tran_dt1, grp_b, count(1) uniq, round((count(1)/@total_subs)*100,2) pct, sum(used_mb) from (
      select phone, case 
                       when b_usage/1000000 > 50 then '50plus'
                       when b_usage/1000000 > 45 then '50mb'
                       when b_usage/1000000 > 40 then '45mb'
                       when b_usage/1000000 > 35 then '40mb'
                       when b_usage/1000000 > 30 then '35mb'
                       when b_usage/1000000 > 25 then '30mb'
                       when b_usage/1000000 > 20 then '25mb'
                       when b_usage/1000000 > 15 then '20mb'
                       when b_usage/1000000 > 10 then '15mb'
                       when b_usage/1000000 > 5  then '10mb'
                       when b_usage/1000000 > 0  then ' 5mb' 
                       end as grp_b, b_usage/1000000 as used_mb
      from boost_users where b_usage > 0) as t1
      group by 1,2 order by 1,2;

      SET @vCtr = @vCtr + 1;
   END WHILE;
end;
//
delimiter ;


      truncate table boost_users;
      insert into  boost_users  select a.*, 0, 0, date_add(a.datein, interval 15 minute) 
      from  powerapp_log a 
      where datein  >= '2014-05-12'
      and   plan = 'UNLI'
      and   exists (select 1 from boost_usage b where b.datein >= '2014-05-21' and a.phone=b.phone)

delete from boost_stats;
call sp_generate_boost_every10 ();
select * from boost_stats where grp = ' 5mb' order by uniq desc limit 10;
select * from boost_stats where grp = ' 5mb' order by used_mb desc limit 10;
select datein, sum(used_mb) used_mb, sum(uniq) uniq from boost_stats group by 1 order by 2 desc limit 10;
select datein, sum(used_mb) used_mb, sum(uniq) uniq from boost_stats group by 1 order by 1;

select datein, sum(used_mb) used_mb, sum(uniq) uniq, group_concat(grp,'=',uniq) uniq_detail, group_concat(grp,'=',used_mb) mb_detail from boost_stats group by 1 order by 3 desc limit 10;


DROP PROCEDURE sp_generate_boost_usage;
delimiter //
CREATE PROCEDURE sp_generate_boost_usage(p_trandate date, p_interval int(4))
BEGIN
   
   -- truncate table boost_users;
   -- insert into  boost_users (id, datein, phone, brand, action, plan, validity, free, start_tm, end_tm, source, b_usage, c_usage, dateend)
   -- select phone, min(datein), phone, 'TEST', 'NEW', 'UNLI', '86400', 'free', min(datein), date_add(min(datein), interval p_interval minute), 'test', 0, 0, date_add(a.datein, interval 10 minute) 
   -- from boost_usage a 
   -- where datein between p_trandate and date_add(p_trandate, interval 1 day) 
   -- group by phone;

   BEGIN
      DECLARE done, done_s int default 0;
      DECLARE vId bigint(20);
      DECLARE vPhone varchar(12);
      DECLARE vDatein, vDateend varchar(20);
      DECLARE c cursor FOR SELECT id, phone, datein, date_add(datein, interval p_interval minute) dateend FROM boost_users WHERE b_usage = 0;
   
      SET net_write_timeout=12000;
      SET global connect_timeout=12000;
      SET net_read_timeout=12000;
      BEGIN
         declare continue handler for sqlstate '02000' set done = 1;
         OPEN c;
         REPEAT
            SET vId=null;
            SET vPhone=null;
            SET vDatein=null;
            SET vDateend=null;
            FETCH c INTO vId, vPhone, vDatein, vDateend;
            if not done then
               begin
                  declare continue handler for sqlstate '02000' set done_s = 1;
   
                  SELECT ifnull(sum(used_byte),'-1'), count(1)
                  INTO   @b_usage, @c_usage
                  FROM   boost_usage
                  WHERE  phone = vPhone
                  and    datein between vDatein and vDateend;
   
                  UPDATE  boost_users
                  SET     b_usage = @b_usage,
                          c_usage = @c_usage
                  WHERE   id=vId;
               end;
            end if;
         UNTIL done
         END REPEAT;
         close c;
      END;
   END;
   -- generate stats
   select count(1) into @total_subs from boost_users where b_usage > 0;
   select p_trandate, grp_b, count(1) uniq, round((count(1)/@total_subs)*100,2) pct from (
   select phone, case 
                    when b_usage/1000000 > 50 then '50plus'
                    when b_usage/1000000 > 45 then '50mb'
                    when b_usage/1000000 > 40 then '45mb'
                    when b_usage/1000000 > 35 then '40mb'
                    when b_usage/1000000 > 30 then '35mb'
                    when b_usage/1000000 > 25 then '30mb'
                    when b_usage/1000000 > 20 then '25mb'
                    when b_usage/1000000 > 15 then '20mb'
                    when b_usage/1000000 > 10 then '15mb'
                    when b_usage/1000000 > 5  then '10mb'
                    when b_usage/1000000 > 0  then ' 5mb' 
                    end as grp_b
   from boost_users where b_usage > 0) as t1
   group by 1,2 order by 1,2;

   select datein, phone, start_tm, end_tm, (b_usage/1000000) mb_used, c_usage from boost_users order by b_usage desc;
END;
//
delimiter ;

call sp_generate_boost_usage('2014-06-12', 10);
call sp_generate_boost_usage('2014-06-13', 10);
call sp_generate_boost_usage('2014-06-14', 10);
call sp_generate_boost_usage('2014-06-21', 10);
call sp_generate_boost_usage('2014-06-22', 10);
select datein, phone, start_tm, end_tm, b_usage, c_usage from boost_users order by b_usage desc;
select phone, sum(used_byte)/1000000 mb_usage from boost_usage where datein >= '2014-05-22' group by phone order by 2 desc;


truncate table boost_users;

insert into  boost_users (id, datein, phone, brand, action, plan, validity, free, start_tm, end_tm, source, b_usage, c_usage, dateend)
select Unix_Timestamp(a.datein), min(datein), phone, 'TEST', 'NEW', 'PISONET', '86400', 'free', min(datein), date_add(min(datein), interval 10 minute), 'test', 0, 0, date_add(a.datein, interval 10 minute) 
from boost_usage a where not exists (select 1 from boost_users b where a.phone = b.phone)
group by phone;

insert ignore into boost_users (id, datein, phone, brand, action, plan, validity, free, start_tm, end_tm, source, b_usage, c_usage, dateend)
select Unix_Timestamp(a.datein), min(a.datein), a.phone, 'TEST', 'NEW', 'PISONET', '86400', 'free', min(a.datein), date_add(min(a.datein), interval 10 minute), 'test', 0, 0, date_add(a.datein, interval 10 minute)
from boost_usage a, boost_users b
where a.phone = b.phone
and   a.datein > b.end_tm
group by a.phone;

insert into boost_users (id, datein, phone, brand, action, plan, validity, free, start_tm, end_tm, source, b_usage, c_usage, dateend)
select Unix_Timestamp(a.datein) id, min(a.datein) datein, a.phone, 'TEST' brand, 'NEW' action, 'PISONET' plan, '600' validity, 'free' free, min(a.datein) start_tm, date_add(min(a.datein), interval 10 minute) end_tm, 'test' source, 0 b_usage, 0 c_usage, date_add(a.datein, interval 10 minute) dateend
from boost_usage a, (select phone, max(end_tm) end_tm from boost_users group by phone) b
where a.phone = b.phone
and   a.datein > b.end_tm
group by a.phone;


######
insert into boost_users (id, datein, phone, brand, action, plan, validity, free, start_tm, end_tm, source, b_usage, c_usage, dateend)
	select id, datein, phone, brand, action, plan, validity, free, datein, date_add(datein, interval validity second) dateend, source, 0, 0, date_add(a.datein, interval validity second) 
	from  powerapp_log a 
	where datein between '2014-06-30 00:00:00' and '2014-07-02 23:59:59'
	and   plan = 'PISONET';

insert ignore into boost_users (id, datein, phone, brand, action, plan, validity, free, start_tm, end_tm, source, b_usage, c_usage, dateend)
select Unix_Timestamp(a.datein) id, min(a.datein) datein, a.phone, 'TEST' brand, 'NEW' action, 'PISONET' plan, '600' validity, 'free' free, min(a.datein) start_tm, date_add(min(a.datein), interval 15 minute) end_tm, 'test' source, 0 b_usage, 0 c_usage, date_add(a.datein, interval 15 minute) dateend
from boost_usage a, (select phone, max(end_tm) end_tm from boost_users group by phone) b
where a.phone = b.phone
and   a.datein > b.end_tm
group by a.phone;


truncate table tmp_pisonet_usage;
load data local infile '/tmp/pisousage_0630_0702.txt' into table tmp_pisonet_usage fields terminated by ',' (tx_date,start_tm,end_tm,phone,ip_addr,source,service,b_usage);
insert into boost_usage select start_tm, phone,ip_addr,b_usage from tmp_pisonet_usage;
select left(datein,10) date, count(1) from boost_usage group by 1;


call sp_generate_boost_usage('2014-06-20', 15);
call sp_generate_boost_usage('2014-06-21', 15);
call sp_generate_boost_usage('2014-06-22', 15);
call sp_generate_boost_usage('2014-06-23', 15);
call sp_generate_boost_usage('2014-06-24', 15);
call sp_generate_boost_usage('2014-06-25', 15);

call sp_generate_boost_usage('2014-06-26', 15);
call sp_generate_boost_usage('2014-06-27', 15);
call sp_generate_boost_usage('2014-06-28', 15);
call sp_generate_boost_usage('2014-06-29', 15);

call sp_generate_boost_usage('2014-06-30', 15);
call sp_generate_boost_usage('2014-07-01', 15);
call sp_generate_boost_usage('2014-07-02', 15);

select id, phone, brand, start_tm, dateend, b_usage, c_usage, source, if(b_usage>1000000, b_usage, 0) '>1M', if(b_usage>1000000, 1, 0) '>1M Tx' from boost_users where brand<>'TEST' order by phone, start_tm;
select sum(1mb_usage) 1mb_usage, sum(1mb_user) 1mb_user, round(sum(1mb_usage)/sum(1mb_user),0) AverageUsage from (
select id, phone, brand, start_tm, dateend, b_usage, c_usage, source, if(b_usage>1000000, b_usage, 0) 1mb_usage, if(b_usage>1000000, 1, 0) 1mb_user from boost_users where brand<>'TEST' order by phone, start_tm) t;


