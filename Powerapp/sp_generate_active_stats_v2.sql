CREATE TABLE powerapp_active_stats (
  tran_dt date NOT NULL,
  tran_tm time NOT NULL,
  plan varchar(16) DEFAULT NULL,
  pre_active int(11) DEFAULT '0',
  tnt_active int(11) DEFAULT '0',
  ppd_active int(11) DEFAULT '0',
  no_active  int(11) NOT NULL DEFAULT '0',
  pre_inactive int(11) DEFAULT '0',
  tnt_inactive int(11) DEFAULT '0',
  ppd_inactive int(11) DEFAULT '0',
  no_inactive  int(11) NOT NULL DEFAULT '0',
  total_subs   int(11) NOT NULL DEFAULT '0',
  pct_active float NOT NULL DEFAULT '0',
  pct_inactive float NOT NULL DEFAULT '0',
  primary key (tran_dt, tran_tm, plan)
);


DROP PROCEDURE sp_generate_active_stats;
delimiter //
CREATE PROCEDURE sp_generate_active_stats(p_trandate date)
begin
   DECLARE vTranDt,vDateTo, vDateFr, vDateSt varchar(20);
   SET vDateTo = left(p_trandate,10);
   SET vTranDt = date_sub(vDateTo, interval 1 day);
   SET vDateFr = date_sub(vDateTo, interval 2 day);
   SET vDateSt = date_sub(vDateFr, interval 7 day);
   select vDateSt, vDateFr, vDateTo;


   delete from powerapp_active_stats where tran_dt = vTranDt and tran_tm='00:00:00' and plan = 'ALL';
   truncate table powerapp_active_users;
   SET @vPlan = 'ALL';
   insert ignore into powerapp_active_users select phone, min(brand) brand, max(datein) datein from powerapp_log where datein >= vDateFr and datein < vDateTo group by phone;
   insert ignore into powerapp_active_users select phone, min(brand) brand, max(datein) datein from powerapp_flu.powerapp_log where datein >= vDateFr and datein < vDateTo group by phone;
   insert ignore into powerapp_users select phone, min(brand) brand, min(datein) datein from (
                                     select phone, min(brand) brand, min(datein) datein from powerapp_log a where datein > vDateSt and datein <= vDateFr group by phone
                                     union select phone, min(brand) brand, min(datein) datein from powerapp_flu.powerapp_log a where datein > vDateSt and datein <= vDateFr group by phone
                                     ) as t group by phone;

   select count(1) into @pre_active from powerapp_active_users where brand='BUDDY';
   select count(1) into @tnt_active from powerapp_active_users where brand='TNT';
   select count(1) into @ppd_active from powerapp_active_users where brand='POSTPD';
   select count(1) into @no_active  from powerapp_active_users;

   select count(1)-@pre_active into @pre_inactive from powerapp_flu.new_subscribers a where brand='BUDDY';
   select count(1)-@tnt_active into @tnt_inactive from powerapp_flu.new_subscribers a where brand='TNT';
   select count(1)-@ppd_active into @ppd_inactive from powerapp_flu.new_subscribers a where brand='POSTPD';
   select count(1)-@no_active  into @no_inactive  from powerapp_flu.new_subscribers;

   insert into powerapp_active_stats
          (tran_dt, tran_tm, plan, pre_active, tnt_active, ppd_active, no_active, pre_inactive, tnt_inactive, ppd_inactive, no_inactive, total_subs, pct_active, pct_inactive)
   select vTranDt, '00:00:00', @vPlan, @pre_active, @tnt_active, @ppd_active, @no_active, @pre_inactive, @tnt_inactive, @ppd_inactive, @no_inactive,
          (@no_active+@no_inactive) TotalUser,
          (@no_active / (@no_active+@no_inactive)) * 100 Pct_Active,
          (@no_inactive / (@no_active+@no_inactive)) * 100 Pct_Inactive;

end;
//
delimiter ;

+------------+----------+------+------------+------------+------------+-----------+--------------+--------------+--------------+-------------+------------+------------+--------------+
| tran_dt    | tran_tm  | plan | pre_active | tnt_active | ppd_active | no_active | pre_inactive | tnt_inactive | ppd_inactive | no_inactive | total_subs | pct_active | pct_inactive |
+------------+----------+------+------------+------------+------------+-----------+--------------+--------------+--------------+-------------+------------+------------+--------------+
| 2014-05-29 | 00:00:00 | ALL  |      63356 |      82017 |        787 |    146160 |       709130 |      1115804 |        11892 |     1836828 |    1982988 |     7.3707 |      92.6293 |
| 2014-05-29 | 00:00:00 | ALL  |      63356 |      82017 |        787 |    146160 |       710449 |      1119438 |        11895 |     1841786 |    1987946 |    7.35231 |      92.6477 |
+------------+----------+------+------------+------------+------------+-----------+--------------+--------------+--------------+-------------+------------+------------+--------------+
1 row in set (0.00 sec)

+------------+----------+------+------------+------------+------------+-----------+--------------+--------------+--------------+-------------+------------+------------+--------------+
| tran_dt    | tran_tm  | plan | pre_active | tnt_active | ppd_active | no_active | pre_inactive | tnt_inactive | ppd_inactive | no_inactive | total_subs | pct_active | pct_inactive |
+------------+----------+------+------------+------------+------------+-----------+--------------+--------------+--------------+-------------+------------+------------+--------------+
+------------+----------+------+------------+------------+------------+-----------+--------------+--------------+--------------+-------------+------------+------------+--------------+
1 row in set (0.00 sec)
