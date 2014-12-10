DROP PROCEDURE sp_generate_bcast_mins;
delimiter //
CREATE PROCEDURE sp_generate_bcast_mins(
   p_startdt date, p_bcastdt date, p_trunc varchar(1), 
   p_pwr_limit int, p_sun_limit int,
   p_plan_bud varchar(20), p_bud_limit int,
   p_plan_tnt varchar(20), p_tnt_limit int)
BEGIN
   set @vWhere = '';
   set @vWherePwr = '';
   set @vWhereSun = '';
   set @nCtr  = 0;
   set @nDays = datediff(p_bcastdt, p_startdt);
   select @nDays;
   if @nDays > 0 then
      while (@nCtr < @nDays)
      do 
         set @dPrevBcast = date_add(p_startdt, interval @nCtr day);
         if (@vWhere = '') then
            SET @vWhere = concat(' and not exists (select 1 from tmp_plan_users_', date_format(@dPrevBcast, '%m%d'), ' b where b.phone = a.phone)');
            SET @vWherePwr = concat(' and not exists (select 1 from tmp_plan_users_', date_format(@dPrevBcast, '%m%d'), ' c where c.phone = a.phone and c.source=''powerapp'')');
            SET @vWhereSun = concat(' where not exists (select 1 from tmp_plan_users_', date_format(@dPrevBcast, '%m%d'), '_sun b where b.phone = a.phone)');
         else
            SET @vWhere = concat(@vWhere, ' and not exists (select 1 from tmp_plan_users_', date_format(@dPrevBcast, '%m%d'), ' b where b.phone = a.phone)');
            SET @vWherePwr = concat(@vWherePwr, ' and not exists (select 1 from tmp_plan_users_', date_format(@dPrevBcast, '%m%d'), ' c where c.phone = a.phone and c.source=''powerapp'')');
            SET @vWhereSun = concat(@vWhereSun, ' and not exists (select 1 from tmp_plan_users_', date_format(@dPrevBcast, '%m%d'), '_sun b where b.phone = a.phone)');
         end if;
         set @nCtr = @nCtr + 1;
      end while;
   end if;
   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   if p_trunc = 'Y' then
      TRUNCATE TABLE tmp_plan_users;
   end if;

   SET @vSql = '';
   SET @vSql = concat('CREATE TABLE if not exists tmp_plan_users_', date_format(p_bcastdt, '%m%d'), ' like tmp_plan_users');
   select @vSql;
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @vSql = '';
   SET @vSql = concat('TRUNCATE TABLE tmp_plan_users_', date_format(p_bcastdt, '%m%d'));
   select @vSql;
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   if p_pwr_limit > 0 then
      SET @vSql = '';
      SET @vSql = concat('insert into tmp_plan_users select a.phone, a.brand, ''POWERAPP'', ''', p_bcastdt, ''', ''powerapp'' from powerapp_users_apn a, tmp_chikka_apn b ',
                         'where a.phone = b.phone and not exists (select 1 from tmp_plan_users c where c.phone = a.phone) ', @vWherePwr, ' limit ', p_pwr_limit);
      select @vSql;
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   end if;

   if p_tnt_limit > 0 then
      SET @vSql = '';
      SET @vSql = concat('insert into tmp_plan_users select phone, brand, ''', p_plan_tnt, ''', ''', p_bcastdt, ''', source from tmp_bcast_mins a ',
                         'where brand=''TNT'' and bcasted=0 and not exists (select 1 from tmp_plan_users b where b.phone = a.phone) ', 
                         @vWhere, ' limit ', p_tnt_limit);
      select @vSql;
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   end if;

   if p_bud_limit > 0 then
      SET @vSql = '';
      SET @vSql = concat('insert into tmp_plan_users select phone, brand, ''', p_plan_bud, ''', ''', p_bcastdt, ''', source from tmp_bcast_mins a ',
                         'where brand=''BUDDY'' and bcasted=0 and not exists (select 1 from tmp_plan_users b where b.phone = a.phone) ', 
                         @vWhere, ' limit ', p_bud_limit);
      select @vSql;
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   end if;

   SET @vSql = '';
   SET @vSql = concat('insert into tmp_plan_users_', date_format(p_bcastdt, '%m%d'),' select * from tmp_plan_users');
   select @vSql;
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   if p_pwr_limit > 0 then
      SET @vSql = concat('select phone into outfile ''/tmp/SHOUTOUT_', date_format(p_bcastdt, '%Y%m%d'), '.csv'' fields terminated by '','' lines terminated by ''\n'' from tmp_plan_users where plan = ''POWERAPP''');
      select @vSql;
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   end if;
   SET @vSql = concat('select phone into outfile ''/tmp/TNT_', date_format(p_bcastdt, '%Y%m%d'), '.csv'' fields terminated by '','' lines terminated by ''\n'' from tmp_plan_users where brand = ''TNT'' and plan = ''', p_plan_tnt, '''');
   select @vSql;
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   SET @vSql = concat('select phone into outfile ''/tmp/BUDDY_', date_format(p_bcastdt, '%Y%m%d'), '.csv'' fields terminated by '','' lines terminated by ''\n'' from tmp_plan_users where brand = ''BUDDY'' and plan = ''', p_plan_bud, '''');
   select @vSql;
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @vSunTableNm = concat('tmp_plan_users_', date_format(p_bcastdt, '%m%d'), '_sun');
   SET @vSql = '';
   SET @vSql = concat('create table ', @vSunTableNm, ' like tmp_plan_users_1201_sun');
   select @vSql;
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
      
   if p_sun_limit > 0 then
      SET @vSql = '';
      SET @vSql = concat('insert into ', @vSunTableNm, ' select phone, '''', ''POWERAPP'', ''', p_bcastdt, ''', ''SUN'' from tmp_bcast_sun_mins a ',
                         @vWhereSun, ' order by datein desc limit 500000');
      select @vSql;
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;

      SET @vSql = concat('select phone into outfile ''/tmp/SUN_', date_format(p_bcastdt, '%Y%m%d'), '.csv'' fields terminated by '','' lines terminated by ''\n'' from ', @vSunTableNm);
      select @vSql;
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   end if;   
END;
//
delimiter ;


delimiter ;
GRANT EXECUTE ON PROCEDURE `archive_powerapp_flu`.`sp_generate_bcast_mins` TO 'stats'@'localhost';
flush privileges;


call sp_generate_bcast_mins('2014-10-18', '2014-10-22', 'ALLDAY', 'SPEEDBOOST', 1250000);


#!/bin/bash

. /etc/profile
#. /home/mysql/.bash_profile

var_date=`date +%Y-%m-%d -d '-1 day ago'`
var_dir=/home/mysql/vars/
var_chk2=`tail -2  $var_dir/pn2.list | head -1 `
var_log=/home/mysql/log
db_prt=3307
db_host="127.0.0.1"
db_conn="mysql -ustats -p$var_chk2 archive_powerapp_flu -h$db_host -P$db_prt"
db_opt="-N -e"

logger(){
  echo "`date` : $*" >> $var_log/bcast_mins.log
}

load_bcast_mins() {
  logger "BCAST MINs generation started for $var_date..."
  `$db_conn $db_opt  "call sp_generate_bcast_mins('2014-10-18', '$var_date', 'ALLDAY', 'SPEEDBOOST', 1250000)"`
  logger "BCAST MINs generation ended for $var_date..."
}


load_bcast_mins


