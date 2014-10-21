create table ctm_login_dtl (chikkaid varchar(12), resource varchar(12), carrier varchar(12), country varchar(12), datein date, timein time, key login_idx (chikkaid, timein));
insert into ctm_login_dtl select chikka_id, resource, carrier, country, datein, timein from ctm_stats.logins_pht partition (p_20131030) order by chikka_id, timein;

create table ctm_login_free_msgs (carrier varchar(12), chikkaid varchar(12), buddyid varchar(12), datein date, timein time, key login_idx (chikkaid, timein));
create table ctm_login_paid_msgs (carrier varchar(12), chikkaid varchar(12), buddyid varchar(12), datein date, timein time, key login_idx (chikkaid, timein));
insert into ctm_login_free_msgs (carrier, chikkaid, buddyid, datein, timein) select 'globe' carrier, tx_from chikkaid, tx_to buddyid, datein, timein from mui_ph_globe_1.bridge_in partition (p_20131030) where tx_type = 'chat' and status=2;
insert into ctm_login_free_msgs (carrier, chikkaid, buddyid, datein, timein) select 'smart' carrier, tx_from chikkaid, tx_to buddyid, datein, timein from mui_ph_smart_1.bridge_in partition (p_20131030) where tx_type = 'chat' and status=2;
insert into ctm_login_free_msgs (carrier, chikkaid, buddyid, datein, timein) select 'sun' carrier, tx_from chikkaid, tx_to buddyid, datein, timein from mui_ph_sun_1.bridge_in partition (p_20131030) where tx_type = 'chat' and status=2;

insert into ctm_login_paid_msgs (carrier, chikkaid, buddyid, datein, timein) select 'globe' carrier, tx_to chikkaid, tx_from buddyid, datein, timein from mui_ph_globe_1.bridge_out partition (p_20131030) where tx_type = 'messaging' and status=2;
insert into ctm_login_paid_msgs (carrier, chikkaid, buddyid, datein, timein) select 'smart' carrier, tx_to chikkaid, tx_from buddyid, datein, timein from mui_ph_smart_1.bridge_out partition (p_20131030) where tx_type = 'messaging' and status=2;
insert into ctm_login_paid_msgs (carrier, chikkaid, buddyid, datein, timein) select 'sun' carrier, tx_to chikkaid, tx_from buddyid, datein, timein from mui_ph_sun_1.bridge_out partition (p_20131030) where tx_type = 'messaging' and status=2;

delimiter //

DROP PROCEDURE sp_generate_ctm_msgs_country_r//

CREATE PROCEDURE sp_generate_ctm_msgs_country_r(p_partition varchar(12))
begin
   DECLARE vChikkaID, vResource, vCarrier, vCountry, vDatein, vTimein, vTimeout Varchar(60);
   DECLARE done int default 0;
   BEGIN
      declare done_p int default 0;
      declare c_pat cursor for select chikkaid, resource, carrier, country, datein, timein
                               from   ctm_login_dtl
                               order by chikkaid, timein;
      declare continue handler for sqlstate '02000' set done_p = 1;

      set session tmp_table_size = 268435456;
      set session max_heap_table_size = 268435456;
      set session sort_buffer_size = 104857600;
      set session read_buffer_size = 8388608;

      truncate table ctm_login_dtl;
      truncate table ctm_login_free_msgs;
      truncate table ctm_login_paid_msgs;
      
      SET @vSql = concat('insert into ctm_login_dtl select chikka_id, resource, carrier, country, datein, timein from ctm_stats.logins_pht partition (', p_partition ,') order by chikka_id, timein');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      SET @vSql = concat('insert into ctm_login_free_msgs (carrier, chikkaid, buddyid, datein, timein) select ''globe'' carrier, tx_from chikkaid, tx_to buddyid, datein, timein from mui_ph_globe_1.bridge_in partition (', p_partition, ') where tx_type = ''chat'' and status=2');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      SET @vSql = concat('insert into ctm_login_free_msgs (carrier, chikkaid, buddyid, datein, timein) select ''smart'' carrier, tx_from chikkaid, tx_to buddyid, datein, timein from mui_ph_smart_1.bridge_in partition (', p_partition, ') where tx_type = ''chat'' and status=2');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      SET @vSql = concat('insert into ctm_login_free_msgs (carrier, chikkaid, buddyid, datein, timein) select ''sun'' carrier, tx_from chikkaid, tx_to buddyid, datein, timein from mui_ph_sun_1.bridge_in partition (', p_partition, ') where tx_type = ''chat'' and status=2');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      SET @vSql = concat('insert into ctm_login_paid_msgs (carrier, chikkaid, buddyid, datein, timein) select ''globe'' carrier, tx_to chikkaid, tx_from buddyid, datein, timein from mui_ph_globe_1.bridge_out partition (', p_partition, ') where tx_type = ''messaging'' and status=2');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      SET @vSql = concat('insert into ctm_login_paid_msgs (carrier, chikkaid, buddyid, datein, timein) select ''smart'' carrier, tx_to chikkaid, tx_from buddyid, datein, timein from mui_ph_smart_1.bridge_out partition (', p_partition, ') where tx_type = ''messaging'' and status=2');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      SET @vSql = concat('insert into ctm_login_paid_msgs (carrier, chikkaid, buddyid, datein, timein) select ''sun'' carrier, tx_to chikkaid, tx_from buddyid, datein, timein from mui_ph_sun_1.bridge_out partition (', p_partition, ') where tx_type = ''messaging'' and status=2');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;

      OPEN c_pat;
      REPEAT
         FETCH c_pat into vChikkaID, vResource, vCarrier, vCountry, vDatein, vTimein;
         if not done_p then

           select IFNULL(min(timein), '23:59:59') into vTimeout
           from   ctm_login_dtl
           where  chikkaid = vChikkaID
           and    timein > vTimein;


           if vChikkaID is not null and vTimein is not null and vTimeout is not null then
              SET @vSql = concat('select count(1) into @nFree from ctm_login_free_msgs where chikkaid = ''', vChikkaID, ''' and timein >= ''', vTimeIn, ''' and timein < ''', vTimeout, '''');
              PREPARE stmt FROM @vSql;
              EXECUTE stmt;
              DEALLOCATE PREPARE stmt;
              SET @vSql = concat('select count(1) into @nPaid from ctm_login_paid_msgs where chikkaid = ''', vChikkaID, ''' and timein >= ''', vTimeIn, ''' and timein < ''', vTimeout, '''');
              PREPARE stmt FROM @vSql;
              EXECUTE stmt;
              DEALLOCATE PREPARE stmt;

              if ( @nFree + @nPaid) > 0 then
                 SET @vSql = concat('insert into ctm_msgs_country (datein, chikkaid, resource, country, free_msg, paid_msg) values (''', vDatein, ''', ''', vChikkaID, ''', ''', IFNULL(vResource, 'XXX'), ''', ''', IFNULL(vCountry, 'XXX'), ''', ', @nFree, ', ', @nPaid, ')' );
                 PREPARE stmt FROM @vSql;
                 EXECUTE stmt;
                 DEALLOCATE PREPARE stmt;
              end if;
           end if;

         end if;
      UNTIL done_p
      END REPEAT;
   END;
end;
//
delimiter ;
