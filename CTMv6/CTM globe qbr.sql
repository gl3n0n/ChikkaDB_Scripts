create table ctm_qbr (carrier varchar(20), brand varchar(30), pattern varchar(80), no_users int, key qbr_idx (carrier, brand));


delimiter //
DROP procedure IF EXISTS sp_generate_ctm_globe_qbr//

create procedure sp_generate_ctm_globe_qbr ()
begin
   declare vCarrier, vBrand, vPattern Varchar(80);
   declare done int default 0;

   set session tmp_table_size = 268435456;
   set session max_heap_table_size = 268435456;
   set session sort_buffer_size = 104857600;
   set session read_buffer_size = 8388608;

   BEGIN
      DECLARE done_p int default 0;
      DECLARE c_pat CURSOR FOR SELECT operator, sim_type, pattern
                               FROM   mobile_pattern
                               WHERE  operator = 'GLOBE';
      DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done_p = 1;

      OPEN c_pat;
      REPEAT
         FETCH c_pat into vCarrier, vBrand, vPattern;
         IF not done_p THEN
            SET @vSql = concat('insert into ctm_qbr (carrier, brand, pattern, no_users) select ''', vCarrier, ''', ''', vBrand, ''', ''', vPattern, ''', count(username) from users where username like ''63%'' and username REGEXP ''^', vPattern, '$''');
            PREPARE stmt FROM @vSql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
            END IF;
      UNTIL done_p
      END REPEAT;
   END; 
end;
//

delimiter ;



1. create table globe_tmlk_qbr (phone varchar(12) not null, optin_date date not null, primary key (phone));
2. load data - mysql load users_log
3. insert ignore into globe_tmlk_qbr select recipient, datein union select donor, datein from user_log
4. truncate talbe user_log
5. repeat 2 to 4



