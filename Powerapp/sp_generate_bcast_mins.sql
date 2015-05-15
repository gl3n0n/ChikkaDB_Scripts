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
         set @nChkTab = 0;
         set @nChkTabS = 0;
         select count(1) into @nChkTab from information_schema.tables where table_name = concat('tmp_plan_users_', date_format(@dPrevBcast, '%m%d')) and table_schema='archive_powerapp_flu';
         select count(1) into @nChkTabS from information_schema.tables where table_name = concat('tmp_plan_users_', date_format(@dPrevBcast, '%m%d'), '_sun') and table_schema='archive_powerapp_flu';
         if (@vWhere = '') then
            if @nChkTab >= 1 then 
               SET @vWhere = concat(' and not exists (select 1 from tmp_plan_users_', date_format(@dPrevBcast, '%m%d'), ' b where b.phone = a.phone)');
               SET @vWherePwr = concat(' and not exists (select 1 from tmp_plan_users_', date_format(@dPrevBcast, '%m%d'), ' c where c.phone = a.phone and c.source=''powerapp'')');
            end if;
            if @nChkTabS >= 1 then 
               SET @vWhereSun = concat(' where not exists (select 1 from tmp_plan_users_', date_format(@dPrevBcast, '%m%d'), '_sun b where b.phone = a.phone)');
            end if;
         else
            if @nChkTab >= 1 then 
               SET @vWhere = concat(@vWhere, ' and not exists (select 1 from tmp_plan_users_', date_format(@dPrevBcast, '%m%d'), ' b where b.phone = a.phone)');
               SET @vWherePwr = concat(@vWherePwr, ' and not exists (select 1 from tmp_plan_users_', date_format(@dPrevBcast, '%m%d'), ' c where c.phone = a.phone and c.source=''powerapp'')');
            end if;
            if @nChkTabS >= 1 then 
               SET @vWhereSun = concat(@vWhereSun, ' and not exists (select 1 from tmp_plan_users_', date_format(@dPrevBcast, '%m%d'), '_sun b where b.phone = a.phone)');
            end if;
         end if;
         set @nCtr = @nCtr + 1;
      end while;
   end if;
   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   create temporary table if not exists tmp_admins (phone varchar(12) not null, primary key (phone));
   insert ignore into tmp_admins (phone) values ('639474296639');
   insert ignore into tmp_admins (phone) values ('639474296630');
   insert ignore into tmp_admins (phone) values ('639399369648');
   insert ignore into tmp_admins (phone) values ('639188039134');
   insert ignore into tmp_admins (phone) values ('639188882728');
   insert ignore into tmp_admins (phone) values ('639188088585');
   insert ignore into tmp_admins (phone) values ('639189087704');

   -- if p_trunc = 'Y' then
      TRUNCATE TABLE tmp_plan_users;
   -- end if;

   SET @vSql = '';
   SET @vSql = concat('CREATE TABLE if not exists tmp_plan_users_', date_format(p_bcastdt, '%m%d'), ' like tmp_plan_users');
   select @vSql;
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   if p_trunc = 'Y' then
      SET @vSql = '';
      SET @vSql = concat('TRUNCATE TABLE tmp_plan_users_', date_format(p_bcastdt, '%m%d'));
      select @vSql;
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   end if;

   if p_pwr_limit > 0 then
      SET @vSql = '';
      SET @vSql = concat('insert ignore into tmp_plan_users select a.phone, a.brand, ''POWERAPP'', ''', p_bcastdt, ''', ''powerapp'' from powerapp_users_apn a, tmp_chikka_apn b, tmp_liberation_mins c ',
                         'where a.phone = b.phone and a.phone = c.phone and not exists (select 1 from tmp_plan_users d where d.phone = a.phone) ', @vWherePwr, ' limit ', p_pwr_limit);
      select @vSql;
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   end if;

   if p_tnt_limit > 0 then
      SET @vSql = '';
      SET @vSql = concat('insert ignore into tmp_plan_users select phone, brand, ''', p_plan_tnt, ''', ''', p_bcastdt, ''', source from tmp_bcast_mins a ',
                         'where brand=''TNT'' and bcasted=0 and not exists (select 1 from tmp_plan_users b where b.phone = a.phone) ', 
                         @vWhere, ' limit ', p_tnt_limit);
      select @vSql;
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   end if;

   if p_bud_limit > 0 then
      SET @vSql = '';
      SET @vSql = concat('insert ignore into tmp_plan_users select phone, brand, ''', p_plan_bud, ''', ''', p_bcastdt, ''', source from tmp_bcast_mins a ',
                         'where brand=''BUDDY'' and bcasted=0 and not exists (select 1 from tmp_plan_users b where b.phone = a.phone) ', 
                         @vWhere, ' limit ', p_bud_limit);
      select @vSql;
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   end if;

   SET @vSql = '';
   SET @vSql = concat('insert ignore into tmp_plan_users_', date_format(p_bcastdt, '%m%d'),' select * from tmp_plan_users');
   select @vSql;
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   if p_pwr_limit > 0 then
      SET @vSql = concat('select phone into outfile ''/tmp/FREE_', date_format(p_bcastdt, '%Y%m%d'), '.csv'' fields terminated by '','' lines terminated by ''\n'' 
                          from ( select phone from tmp_admins union
                                 select phone from tmp_plan_users where plan = ''POWERAPP'') t
                         ');
      select @vSql;
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   end if;

   if p_tnt_limit > 0 then
      SET @vSql = concat('select phone into outfile ''/tmp/TNT_', date_format(p_bcastdt, '%Y%m%d'), '.csv'' fields terminated by '','' lines terminated by ''\n'' 
                          from ( select phone from tmp_admins union
                                 select phone from tmp_plan_users where brand = ''TNT'' and plan = ''', p_plan_tnt, ''') t
                         ');
      select @vSql;
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   end if;

   if p_bud_limit > 0 then
      SET @vSql = concat('select phone into outfile ''/tmp/BUDDY_', date_format(p_bcastdt, '%Y%m%d'), '.csv'' fields terminated by '','' lines terminated by ''\n'' 
                          from ( select phone from tmp_admins union
                                 select phone from tmp_plan_users where brand = ''BUDDY'' and plan = ''', p_plan_bud, ''') t
                         ');
      select @vSql;
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
   end if;

   SET @vSunTableNm = concat('tmp_plan_users_', date_format(p_bcastdt, '%m%d'), '_sun');
   SET @vSql = '';
   SET @vSql = concat('create table if not exists ', @vSunTableNm, ' like tmp_plan_users_sun');
   select @vSql;
   if p_sun_limit > 0 then

      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      
      SET @vSql = concat('truncate table ', @vSunTableNm);
      select @vSql;
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      
      SET @vSql = '';
      SET @vSql = concat('insert ignore into ', @vSunTableNm, ' select phone, '''', ''POWERAPP'', ''', p_bcastdt, ''', ''SUN'' from tmp_bcast_sun_mins a ',
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



call sp_generate_bcast_mins('2015-05-13', '2015-05-23', 'Y', 0, 0, 'FACEBOOK', 2000000, '', 0);


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


