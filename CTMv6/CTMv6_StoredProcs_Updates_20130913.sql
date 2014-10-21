DROP table IF EXISTS ctm_registration;

create table ctm_registration (
   ctm_accnt      int(9) unsigned zerofill NOT NULL, 
   reg_app        varchar(15) NOT NULL, 
   reg_src        varchar(20) NOT NULL, 
   reg_sn_id      varchar(80), 
   email_add      varchar(80), 
   country        smallint(6), 
   msisdn         varchar(19), 
   msisdn_type    varchar(15), 
   msisdn_carrier varchar(12), 
   reg_date       date, 
   reg_time       time, 
   PRIMARY KEY (ctm_accnt),
   KEY reg_date (reg_date)
);

-- DROP table IF EXISTS ctm_accounts;
-- 
-- CREATE TABLE ctm_accounts (
--   ctm_accnt int(9) unsigned zerofill NOT NULL,
--   ctm_token varchar(255) DEFAULT NULL,
--   display_name varchar(255) DEFAULT NULL,
--   photo_path varchar(255) DEFAULT NULL,
--   msisdn varchar(19) DEFAULT NULL,
--   msisdn_passwd varchar(100) DEFAULT NULL,
--   msisdn_salt varchar(16) DEFAULT NULL,
--   last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--   PRIMARY KEY (ctm_accnt),
--   UNIQUE KEY msisdn (msisdn)
-- );

ALTER TABLE ctm_accounts drop cloumn msisdn_type;
ALTER TABLE ctm_accounts drop cloumn msisdn_carrier;
ALTER TABLE ctm_accounts drop cloumn reg_src;
ALTER TABLE ctm_accounts drop cloumn reg_app;
ALTER TABLE ctm_accounts drop cloumn country;
ALTER TABLE ctm_accounts drop cloumn reg_date;
ALTER TABLE ctm_accounts drop cloumn reg_time;


DROP table IF EXISTS ctm_sns_link_jrnl;

CREATE TABLE ctm_sns_link_jrnl (
  ctm_accnt_fr int(9) unsigned zerofill NOT NULL,
  ctm_accnt_to int(9) unsigned zerofill,
  sn_provider_id tinyint(4) NOT NULL,
  sn_display_name_fr varchar(255),
  sn_display_name_to varchar(255),
  sn_id varchar(80) NOT NULL,
  msisdn varchar(19) NOT NULL,
  email_add varchar(80),
  linked_date datetime,
  jrnl_action varchar(10) DEFAULT 'UPDATE' not null,
  jrnl_date date not null,
  jrnl_time time not null,
  KEY jrnl_date_idx (jrnl_date)
);

delimiter //

DROP PROCEDURE IF EXISTS sp_ctm_registration_log//

CREATE PROCEDURE sp_ctm_registration_log (
   in_ctm_accnt      int(9), 
   in_reg_app        varchar(15), 
   in_reg_src        varchar(20), 
   in_reg_sn_id      varchar(80), 
   in_email_add      varchar(80), 
   in_country        smallint(6), 
   in_msisdn         varchar(19)
 )
BEGIN
   DECLARE nRetr, done_reg INT DEFAULT 0;
   DECLARE v_msisdn_type, v_msisdn_carrier VARCHAR(16) DEFAULT NULL;
   DECLARE CONTINUE HANDLER FOR sqlstate '23000' SET done_reg = 1;

   IF (in_msisdn is not null) AND (in_msisdn like '63%') THEN
      call sp_carrier_sim_type(in_msisdn, v_msisdn_type, v_msisdn_carrier);
   END IF;

   INSERT INTO ctm_registration 
          ( ctm_accnt, 
            reg_app, 
            reg_src, 
            reg_sn_id, 
            email_add, 
            country, 
            msisdn, 
            msisdn_type, 
            msisdn_carrier, 
            reg_date, 
            reg_time )
   VALUES ( in_ctm_accnt, 
            in_reg_app, 
            in_reg_src, 
            in_reg_sn_id, 
            in_email_add, 
            in_country, 
            in_msisdn, 
            v_msisdn_type, 
            v_msisdn_carrier, 
            curdate(), 
            curtime() );

   IF done_reg = 0 THEN
      SELECT ROW_COUNT() INTO nRetr;
   ELSE
      SET nRetr = 1062;
   END IF;
   -- SELECT nRetr;
END;
//


DROP PROCEDURE IF EXISTS sp_reg_sns_ctm_accnts//

CREATE PROCEDURE sp_reg_sns_ctm_accnts(
   IN in_ctm_accnt int(9),
   IN in_sn_provider_id tinyint(4),
   IN in_token varchar(255),
   IN in_sn_display_name varchar(80),
   IN in_email_add varchar(80),
   IN in_reg_app varchar(15),
   IN in_sn_id varchar(15),
   IN in_reg_src varchar(20),
   IN in_ctm_token varchar(255)
  )
BEGIN
   DECLARE nRetr, done_link, done_accnt INT DEFAULT 0;

   BEGIN
      DECLARE CONTINUE HANDLER FOR sqlstate '23000' SET done_link = 1;
      INSERT INTO ctm_sns_link
             ( ctm_accnt, sn_provider_id, token, sn_display_name, email_add, sn_id) 
      VALUES ( in_ctm_accnt, in_sn_provider_id, in_token, in_sn_display_name, in_email_add, in_sn_id);
   END;
   
   IF done_link = 0 THEN
      BEGIN
         DECLARE CONTINUE HANDLER FOR sqlstate '23000' SET done_accnt = 1;
         INSERT INTO ctm_accounts
                ( ctm_accnt, ctm_token) 
         VALUES ( in_ctm_accnt, in_ctm_token);
      END;

      IF done_accnt = 0 THEN
        SET nRetr = 2;
        call sp_ctm_registration_log (in_ctm_accnt, in_reg_app, in_reg_src, in_sn_id, in_email_add, null, null);
      ELSE
         DELETE FROM ctm_sns_link 
         WHERE  ctm_accnt = in_ctm_accnt
         AND    sn_id = in_sn_id; 
         SET nRetr = 1062;
      END IF;
   ELSE
      SET nRetr = 1062;
   END IF;
   SELECT nRetr;
END;
//

DROP TRIGGER IF EXISTS trg_reg_mob_ctm_accnts //

CREATE TRIGGER trg_reg_mob_ctm_accnts
BEFORE INSERT ON ctm_accounts
FOR EACH ROW
BEGIN
   IF (new.msisdn is not null) AND 
      (new.msisdn like '63%') 
   THEN
      call sp_ctm_registration_log (new.ctm_accnt, 'SMS', 'SMS', null, null, null, new.msisdn);
   END IF;
END;
//

DROP TRIGGER IF EXISTS trg_reg_mob_ctm_accnts //

-- CREATE TRIGGER trg_reg_mob_ctm_accnts
-- BEFORE UPDATE ON ctm_accounts
-- BEGIN
--  DECLARE user_msisdn_id varchar(19);
--  DECLARE done int default 0;
-- 
--    IF new.msisdn is null then
--       BEGIN
--        DECLARE EXIT HANDLER for sqlstate '02000'  set done = 1;
--     SET  new.msisdn_type=@user_msisdn_type,new.msisdn_carrier=@user_msisdn_carrier;
--       END ;
--    ELSE
--       IF LEFT(new.msisdn,2) = 63 then
--          BEGIN
--            SET  user_msisdn_id=new.msisdn;
--            call sp_carrier_sim_type(user_msisdn_id,@user_msisdn_type,@user_msisdn_carrier);
--            SET  new.msisdn_type=@user_msisdn_type,new.msisdn_carrier=@user_msisdn_carrier;
--          END ;
--        ELSE
--          BEGIN
--             SET  new.msisdn_type=null,new.msisdn_carrier=null;
--          END ;
--       END IF ;
--    END IF;
-- 
-- END;
-- //


DROP PROCEDURE IF EXISTS sp_link_sns//

CREATE PROCEDURE sp_link_sns (
   IN in_ctm_accnt int(9),
   IN in_sn_provider_id tinyint(4),
   IN in_token varchar(255),
   IN in_sn_secret varchar(255),
   IN in_sn_id varchar(80)
  )
BEGIN
   DECLARE done_chk, nCtr INT DEFAULT 0;
   BEGIN
      DECLARE CONTINUE HANDLER FOR sqlstate '02000' SET done_chk = 1;
      SELECT b.ctm_accnt, b.sn_provider_id, b.sn_id
      INTO   @ctm_accnt, @sn_provider_id, @sn_id
      FROM   ctm_sns_link b
      WHERE  b.sn_id = in_sn_id;
   END;
   
   IF @ctm_accnt IS NULL THEN
      SET @ctm_accnt = 0;
   END IF;

   IF done_chk = 0 THEN
      IF in_ctm_accnt = @ctm_accnt THEN
         UPDATE ctm_sns_link
         SET    token = in_token,
                sn_provider_id = in_sn_provider_id, 
                sn_id = in_sn_id,
                sn_secret = in_sn_secret
         WHERE  sn_id = in_sn_id;
      ELSE
         UPDATE ctm_sns_link
         SET    ctm_accnt = in_ctm_accnt,
                token = in_token,
                sn_provider_id = in_sn_provider_id, 
                sn_id = in_sn_id,
                sn_secret = in_sn_secret
         WHERE  sn_id = in_sn_id;

         -- Check if Old CTM Account has mobile account
         SELECT 1 INTO nCtr
         FROM   ctm_accounts
         WHERE  ctm_accnt = @ctm_accnt
         AND    msisdn is not null;
         
         IF nCtr = 0 THEN
            -- Check if Old CTM Account has other links
            SELECT count(1) INTO nCtr
            FROM   ctm_sns_link
            WHERE  ctm_accnt = @ctm_accnt;
            IF nCtr = 0 THEN
               DELETE FROM ctm_accounts
               WHERE  ctm_accnt = @ctm_accnt;
            END IF;
         END IF; 
      END IF;
   END IF;

END;
//

delimiter ;

