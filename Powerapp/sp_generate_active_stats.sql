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


drop procedure if exists sp_generate_active_stats;
delimiter //
create procedure sp_generate_active_stats (p_trandate date)
begin
   DECLARE vTranDt,vDateTo, vDateFr, vDateSt varchar(20);
   SET vDateTo = left(p_trandate,10);
   SET vTranDt = date_sub(vDateTo, interval 1 day);
   SET vDateFr = date_sub(vDateTo, interval 2 day);
   SET vDateSt = date_sub(vDateFr, interval 7 day);
   select vDateSt, vDateFr, vDateTo;

   -- for update of powerapp_users
   delete from powerapp_active_stats where tran_dt = vTranDt and tran_tm='00:00:00' and plan = 'ALL';
   truncate table powerapp_active_users;
   SET @vPlan = 'ALL';
   insert ignore into powerapp_active_users select phone, min(brand) brand, max(datein) datein from powerapp_log where datein >= vDateFr and datein < vDateTo group by phone;
   insert ignore into powerapp_active_users select phone, min(brand) brand, max(datein) datein from powerapp_flu.powerapp_log where datein >= vDateFr and datein < vDateTo group by phone;
   insert ignore into powerapp_users select phone, min(brand) brand, min(datein) datein from (
                                     select phone, min(brand) brand, min(datein) datein from powerapp_log a where datein > vDateSt and datein <= vDateFr group by phone
                                     union select phone, min(brand) brand, min(datein) datein from powerapp_flu.powerapp_log a where datein > vDateSt and datein <= vDateFr group by phone
                                     ) as t group by phone;

   insert into powerapp_active_stats
          (tran_dt, tran_tm, plan, pre_active, tnt_active, ppd_active, no_active, pre_inactive, tnt_inactive, ppd_inactive, no_inactive, total_subs, pct_active, pct_inactive)
   select vTranDt, '00:00:00', @vPlan, sum(pre_active), sum(tnt_active), sum(ppd_active), sum(no_active), sum(pre_inactive), sum(tnt_inactive), sum(ppd_inactive), sum(no_inactive),
          sum(no_active+no_inactive) TotalUser,
          (sum(no_active) / sum(no_active+no_inactive)) * 100 Pct_Active,
          (sum(no_inactive) / sum(no_active+no_inactive)) * 100 Pct_Inactive  
   from (
   select count(1) pre_active, 0 tnt_active, 0 ppd_active, 0 no_active, 0 pre_inactive, 0 tnt_inactive, 0 ppd_inactive, 0 no_inactive from powerapp_active_users where brand='BUDDY' union
   select 0 pre_active, count(1) tnt_active, 0 ppd_active, 0 no_active, 0 pre_inactive, 0 tnt_inactive, 0 ppd_inactive, 0 no_inactive from powerapp_active_users where brand='TNT' union
   select 0 pre_active, 0 tnt_active, count(1) ppd_active, 0 no_active, 0 pre_inactive, 0 tnt_inactive, 0 ppd_inactive, 0 no_inactive from powerapp_active_users where brand='POSTPD' union
   select 0 pre_active, 0 tnt_active, 0 ppd_active, count(1) no_active, 0 pre_inactive, 0 tnt_inactive, 0 ppd_inactive, 0 no_inactive from powerapp_active_users union
   select 0 pre_active, 0 tnt_active, 0 ppd_active, 0 no_active, count(1) pre_inactive, 0 tnt_inactive, 0 ppd_inactive, 0 no_inactive from powerapp_users a where not exists (select 1 from powerapp_active_users b where a.phone=b.phone) and brand='BUDDY' union
   select 0 pre_active, 0 tnt_active, 0 ppd_active, 0 no_active, 0 pre_inactive, count(1) tnt_inactive, 0 ppd_inactive, 0 no_inactive from powerapp_users a where not exists (select 1 from powerapp_active_users b where a.phone=b.phone) and brand='TNT' union
   select 0 pre_active, 0 tnt_active, 0 ppd_active, 0 no_active, 0 pre_inactive, 0 tnt_inactive, count(1) ppd_inactive, 0 no_inactive from powerapp_users a where not exists (select 1 from powerapp_active_users b where a.phone=b.phone) and brand='POSTPD' union
   select 0 pre_active, 0 tnt_active, 0 ppd_active, 0 no_active, 0 pre_inactive, 0 tnt_inactive, 0 ppd_inactive, count(1) no_inactive from powerapp_users a where not exists (select 1 from powerapp_active_users b where a.phone=b.phone)
   ) a;

   -- select * from powerapp_active_stats order by tran_dt desc, tran_tm desc limit 1;
end;
//
delimiter ;
call sp_generate_active_stats('2013-12-01');
call sp_generate_active_stats('2013-12-02');
call sp_generate_active_stats('2013-12-03');
call sp_generate_active_stats('2013-12-04');
call sp_generate_active_stats('2013-12-05');
call sp_generate_active_stats('2013-12-06');
call sp_generate_active_stats('2013-12-07');
call sp_generate_active_stats('2013-12-08');
call sp_generate_active_stats('2013-12-09');
call sp_generate_active_stats('2013-12-10');
call sp_generate_active_stats('2013-12-11');
call sp_generate_active_stats('2013-12-12');
call sp_generate_active_stats('2013-12-13');
call sp_generate_active_stats('2013-12-14');
call sp_generate_active_stats('2013-12-15');
call sp_generate_active_stats('2013-12-16');
call sp_generate_active_stats('2013-12-17');
call sp_generate_active_stats('2013-12-18');
call sp_generate_active_stats('2013-12-19');
call sp_generate_active_stats('2013-12-20');
call sp_generate_active_stats('2013-12-21');
call sp_generate_active_stats('2013-12-22');
call sp_generate_active_stats('2013-12-23');
call sp_generate_active_stats('2013-12-24');
call sp_generate_active_stats('2013-12-25');
call sp_generate_active_stats('2013-12-26');
call sp_generate_active_stats('2013-12-27');
call sp_generate_active_stats('2013-12-28');
call sp_generate_active_stats('2013-12-29');
call sp_generate_active_stats('2013-12-30');
call sp_generate_active_stats('2013-12-31');

call sp_generate_active_stats('2014-01-01');
call sp_generate_active_stats('2014-01-02');
call sp_generate_active_stats('2014-01-03');
call sp_generate_active_stats('2014-01-04');
call sp_generate_active_stats('2014-01-05');
call sp_generate_active_stats('2014-01-06');
call sp_generate_active_stats('2014-01-07');
call sp_generate_active_stats('2014-01-08');
call sp_generate_active_stats('2014-01-09');
call sp_generate_active_stats('2014-01-10');
call sp_generate_active_stats('2014-01-11');
call sp_generate_active_stats('2014-01-12');
call sp_generate_active_stats('2014-01-13');
call sp_generate_active_stats('2014-01-14');
call sp_generate_active_stats('2014-01-15');
call sp_generate_active_stats('2014-01-16');
call sp_generate_active_stats('2014-01-17');
call sp_generate_active_stats('2014-01-18');
call sp_generate_active_stats('2014-01-19');
call sp_generate_active_stats('2014-01-20');
call sp_generate_active_stats('2014-01-21');
call sp_generate_active_stats('2014-01-22');
call sp_generate_active_stats('2014-01-23');
call sp_generate_active_stats('2014-01-24');
call sp_generate_active_stats('2014-01-25');
call sp_generate_active_stats('2014-01-26');
call sp_generate_active_stats('2014-01-27');
call sp_generate_active_stats('2014-01-28');
call sp_generate_active_stats('2014-01-29');
call sp_generate_active_stats('2014-01-30');
call sp_generate_active_stats('2014-01-31');

call sp_generate_active_stats('2014-02-01');
call sp_generate_active_stats('2014-02-02');
call sp_generate_active_stats('2014-02-03');
call sp_generate_active_stats('2014-02-04');
call sp_generate_active_stats('2014-02-05');
call sp_generate_active_stats('2014-02-06');
call sp_generate_active_stats('2014-02-07');
call sp_generate_active_stats('2014-02-08');
call sp_generate_active_stats('2014-02-09');
call sp_generate_active_stats('2014-02-10');
call sp_generate_active_stats('2014-02-11');
call sp_generate_active_stats('2014-02-12');
call sp_generate_active_stats('2014-02-13');
call sp_generate_active_stats('2014-02-14');
call sp_generate_active_stats('2014-02-15');
call sp_generate_active_stats('2014-02-16');
call sp_generate_active_stats('2014-02-17');
call sp_generate_active_stats('2014-02-18');
call sp_generate_active_stats('2014-02-19');
call sp_generate_active_stats('2014-02-20');
call sp_generate_active_stats('2014-02-21');
call sp_generate_active_stats('2014-02-22');
call sp_generate_active_stats('2014-02-23');
call sp_generate_active_stats('2014-02-24');
call sp_generate_active_stats('2014-02-25');
call sp_generate_active_stats('2014-02-26');
call sp_generate_active_stats('2014-02-27');
call sp_generate_active_stats('2014-02-28');

set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;


call sp_generate_active_stats('2014-03-01');
call sp_generate_active_stats('2014-03-02');
call sp_generate_active_stats('2014-03-03');
call sp_generate_active_stats('2014-03-04');
call sp_generate_active_stats('2014-03-05');
call sp_generate_active_stats('2014-03-06');
call sp_generate_active_stats('2014-03-07');
call sp_generate_active_stats('2014-03-08');
call sp_generate_active_stats('2014-03-09');
call sp_generate_active_stats('2014-03-10');
