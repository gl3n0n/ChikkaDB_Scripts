drop procedure if exists sp_generate_inactive_users;
delimiter //
create procedure sp_generate_inactive_users (p_trandate date)
begin
   DECLARE vTranDt,vDateTo, vDateFr, vDateSt varchar(20);
   SET vDateTo = left(p_trandate,10);
   SET vTranDt = date_sub(vDateTo, interval 1 day);
   SET vDateFr = date_sub(vDateTo, interval 2 day);
   SET vDateSt = date_sub(vDateFr, interval 7 day);
   select vDateSt, vDateFr, vDateTo;

   -- for update of powerapp_users
   truncate table powerapp_active_users;
   insert ignore into powerapp_active_users select phone, min(brand) brand, max(datein) datein from powerapp_log where datein >= vDateFr and datein < vDateTo group by phone;
   insert ignore into powerapp_active_users select phone, min(brand) brand, max(datein) datein from powerapp_flu.powerapp_log where datein >= vDateFr and datein < vDateTo group by phone;
   insert ignore into powerapp_users select phone, min(brand) brand, min(datein) datein from (
                                     select phone, min(brand) brand, min(datein) datein from powerapp_log a where datein > vDateSt and datein <= vDateFr group by phone
                                     union select phone, min(brand) brand, min(datein) datein from powerapp_flu.powerapp_log a where datein > vDateSt and datein <= vDateFr group by phone
                                     ) as t group by phone;
end;
//

delimiter ;

DROP PROCEDURE IF EXISTS sp_generate_inactive_list;
delimiter //
CREATE PROCEDURE sp_generate_inactive_list()
begin
   truncate table powerapp_inactive_list;
   truncate table powerapp_active_users;
   insert ignore into powerapp_active_users select phone, max(brand), max(datein) datein from powerapp_flu.powerapp_log where datein >  date_sub(now(), interval 2 day) group by phone;

   insert ignore into powerapp_inactive_list
   select phone, brand from powerapp_users a where not exists (select 1 from powerapp_active_users b where a.phone = b.phone);
end;
//
delimiter ;


call sp_generate_inactive_users('2013-12-01');
call sp_generate_inactive_users('2013-12-02');
call sp_generate_inactive_users('2013-12-03');
call sp_generate_inactive_users('2013-12-04');
call sp_generate_inactive_users('2013-12-05');
call sp_generate_inactive_users('2013-12-06');
call sp_generate_inactive_users('2013-12-07');
call sp_generate_inactive_users('2013-12-08');
call sp_generate_inactive_users('2013-12-09');
call sp_generate_inactive_users('2013-12-10');
call sp_generate_inactive_users('2013-12-11');
call sp_generate_inactive_users('2013-12-12');
call sp_generate_inactive_users('2013-12-13');
call sp_generate_inactive_users('2013-12-14');
call sp_generate_inactive_users('2013-12-15');
call sp_generate_inactive_users('2013-12-16');
call sp_generate_inactive_users('2013-12-17');
call sp_generate_inactive_users('2013-12-18');
call sp_generate_inactive_users('2013-12-19');
call sp_generate_inactive_users('2013-12-20');
call sp_generate_inactive_users('2013-12-21');
call sp_generate_inactive_users('2013-12-22');
call sp_generate_inactive_users('2013-12-23');
call sp_generate_inactive_users('2013-12-24');
call sp_generate_inactive_users('2013-12-25');
call sp_generate_inactive_users('2013-12-26');
call sp_generate_inactive_users('2013-12-27');
call sp_generate_inactive_users('2013-12-28');
call sp_generate_inactive_users('2013-12-29');
call sp_generate_inactive_users('2013-12-30');
call sp_generate_inactive_users('2013-12-31');

call sp_generate_inactive_users('2014-01-01');
call sp_generate_inactive_users('2014-01-02');
call sp_generate_inactive_users('2014-01-03');
call sp_generate_inactive_users('2014-01-04');
call sp_generate_inactive_users('2014-01-05');
call sp_generate_inactive_users('2014-01-06');
call sp_generate_inactive_users('2014-01-07');
call sp_generate_inactive_users('2014-01-08');
call sp_generate_inactive_users('2014-01-09');
call sp_generate_inactive_users('2014-01-10');
call sp_generate_inactive_users('2014-01-11');
call sp_generate_inactive_users('2014-01-12');
call sp_generate_inactive_users('2014-01-13');
call sp_generate_inactive_users('2014-01-14');
call sp_generate_inactive_users('2014-01-15');
call sp_generate_inactive_users('2014-01-16');
call sp_generate_inactive_users('2014-01-17');
call sp_generate_inactive_users('2014-01-18');
call sp_generate_inactive_users('2014-01-19');
call sp_generate_inactive_users('2014-01-20');
call sp_generate_inactive_users('2014-01-21');
call sp_generate_inactive_users('2014-01-22');
call sp_generate_inactive_users('2014-01-23');
call sp_generate_inactive_users('2014-01-24');
call sp_generate_inactive_users('2014-01-25');
call sp_generate_inactive_users('2014-01-26');
call sp_generate_inactive_users('2014-01-27');
call sp_generate_inactive_users('2014-01-28');
call sp_generate_inactive_users('2014-01-29');
call sp_generate_inactive_users('2014-01-30');
call sp_generate_inactive_users('2014-01-31');

call sp_generate_inactive_users('2014-02-01');
call sp_generate_inactive_users('2014-02-02');
call sp_generate_inactive_users('2014-02-03');
call sp_generate_inactive_users('2014-02-04');
call sp_generate_inactive_users('2014-02-05');
call sp_generate_inactive_users('2014-02-06');
call sp_generate_inactive_users('2014-02-07');
call sp_generate_inactive_users('2014-02-08');
call sp_generate_inactive_users('2014-02-09');
call sp_generate_inactive_users('2014-02-10');
call sp_generate_inactive_users('2014-02-11');
call sp_generate_inactive_users('2014-02-12');
call sp_generate_inactive_users('2014-02-13');
call sp_generate_inactive_users('2014-02-14');
call sp_generate_inactive_users('2014-02-15');
call sp_generate_inactive_users('2014-02-16');
call sp_generate_inactive_users('2014-02-17');
call sp_generate_inactive_users('2014-02-18');
call sp_generate_inactive_users('2014-02-19');
call sp_generate_inactive_users('2014-02-20');
call sp_generate_inactive_users('2014-02-21');
call sp_generate_inactive_users('2014-02-22');
call sp_generate_inactive_users('2014-02-23');
call sp_generate_inactive_users('2014-02-24');
call sp_generate_inactive_users('2014-02-25');
call sp_generate_inactive_users('2014-02-26');
call sp_generate_inactive_users('2014-02-27');
call sp_generate_inactive_users('2014-02-28');

set session tmp_table_size = 268435456;
set session max_heap_table_size = 268435456;
set session sort_buffer_size = 104857600;
set session read_buffer_size = 8388608;


call sp_generate_inactive_users('2014-03-01');
call sp_generate_inactive_users('2014-03-02');
call sp_generate_inactive_users('2014-03-03');
call sp_generate_inactive_users('2014-03-04');
call sp_generate_inactive_users('2014-03-05');
call sp_generate_inactive_users('2014-03-06');
call sp_generate_inactive_users('2014-03-07');
call sp_generate_inactive_users('2014-03-08');
call sp_generate_inactive_users('2014-03-09');
call sp_generate_inactive_users('2014-03-10');

 