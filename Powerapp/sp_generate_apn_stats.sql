DROP PROCEDURE IF EXISTS `sp_generate_apn_stats`(p_trandate date);

delimiter //
CREATE PROCEDURE `sp_generate_apn_stats`(p_trandate date)
begin
   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   insert ignore into powerapp_users_apn (phone) select phone from tmp_chikka_apn;

   create temporary table tmp_chikka_apn_nobrand like powerapp_users_apn;
   insert into tmp_chikka_apn_nobrand (phone) select phone from powerapp_users_apn where brand is null;
   call sp_set_brand('tmp_chikka_apn_nobrand');
   update tmp_chikka_apn_nobrand set brand=(select brand from powerapp_flu.new_subscribers a where a.phone=tmp_chikka_apn_nobrand.phone);
   update powerapp_users_apn set brand=(select brand from tmp_chikka_apn_nobrand a where a.phone=powerapp_users_apn.phone) where brand is null;

   select count(1) into @nTotal from powerapp_users_apn a, tmp_chikka_apn b where a.phone = b.phone;
   select count(1) into @nBuddy from powerapp_users_apn a, tmp_chikka_apn b where a.phone = b.phone and a.brand = 'BUDDY';
   select count(1) into @nPostpd from powerapp_users_apn a, tmp_chikka_apn b where a.phone = b.phone and a.brand = 'POSTPD';
   select count(1) into @nTnt from powerapp_users_apn a, tmp_chikka_apn b where a.phone = b.phone and a.brand = 'TNT';

   delete from powerapp_apn_stats where tran_dt=p_trandate;
   insert into powerapp_apn_stats (tran_dt, buddy, postpd, tnt, others, total)
   values (p_trandate, @nBuddy, @nPostpd, @nTnt, @nTotal-(@nBuddy+@nPostpd+@nTnt), @nTotal);
end;
//
delimiter ;

delimiter ;
GRANT EXECUTE ON PROCEDURE  sp_generate_apn_stats  TO 'stats'@'localhost';
flush privileges;



create temporary table tmp_apn_users as select b.phone, a.brand from powerapp_users_apn a, tmp_chikka_apn b where a.phone = b.phone;
alter table tmp_apn_users add primary key (phone);
create temporary table tmp_buyers as select a.phone, a.brand, group_concat(distinct(plan) separator ':') plan from powerapp_log a where datein >= '2015-03-08' and datein < '2015-03-09' and plan <> 'MYVOLUME' group by a.phone, a.brand;
create temporary table tmp_myvolume as select a.phone, a.brand, group_concat(distinct(plan) separator ':') plan from powerapp_log a where datein >= '2015-03-08' and datein < '2015-03-09' and plan = 'MYVOLUME' group by a.phone, a.brand;
alter table tmp_buyers add primary key (phone);
alter table tmp_myvolume add primary key (phone);


select brand, count(1) from tmp_apn_users a where exists (select 1 from tmp_buyers b where a.phone = b.phone) group by 1;
select brand, count(1) from tmp_apn_users a where exists (select 1 from tmp_myvolume b where a.phone = b.phone) group by 1;



set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;
select brand, count(distinct phone) wk_uniq into outfile '/tmp/wk_fi_uniq.csv' fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2015-03-02' and datein < '2015-03-09' and plan =  'MYVOLUME' group by brand;
select brand, count(distinct phone) se_uniq into outfile '/tmp/se_fi_uniq.csv' fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2015-02-22' and datein < '2015-03-09' and plan =  'MYVOLUME' group by brand;
select brand, count(distinct phone) mo_uniq into outfile '/tmp/mo_fi_uniq.csv' fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2015-02-09' and datein < '2015-03-09' and plan =  'MYVOLUME' group by brand;
select brand, count(distinct phone) wk_uniq into outfile '/tmp/wk_bu_uniq.csv' fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2015-03-02' and datein < '2015-03-09' and plan <> 'MYVOLUME' group by brand;
select brand, count(distinct phone) se_uniq into outfile '/tmp/se_bu_uniq.csv' fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2015-02-22' and datein < '2015-03-09' and plan <> 'MYVOLUME' group by brand;
select brand, count(distinct phone) mo_uniq into outfile '/tmp/mo_bu_uniq.csv' fields terminated by ',' lines terminated by '\n' from powerapp_log where datein >= '2015-02-09' and datein < '2015-03-09' and plan <> 'MYVOLUME' group by brand;

select concat('0',substring(a.phone,3)) into outfile '/tmp/chikka_apn_prepaid_mins_09.csv' fields terminated by ',' lines terminated by '\n' 
from powerapp_users_apn a, tmp_chikka_apn b 
where a.phone = b.phone 
and a.brand = 'BUDDY';

select a.phone into outfile '/tmp/chikka_apn_prepaid_mins_63.csv' fields terminated by ',' lines terminated by '\n' 
from powerapp_users_apn a, tmp_chikka_apn b 
where a.phone = b.phone 
and a.brand = 'BUDDY';
