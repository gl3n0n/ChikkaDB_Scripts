DELIMITER //

DROP PROCEDURE IF EXISTS sp_get_chk_accnt //

CREATE PROCEDURE sp_get_chk_accnt()
BEGIN
   SELECT COUNT(1) into @count_free from ctm_accnt_list where status=0;
   IF @count_free = 0 then
      SET @mysql_err=1329;
      SELECT @mysql_err;
   ELSE
      SELECT ctm_accnt into @fetch_res from ctm_accnt_list where status=0 limit 1;
      UPDATE ctm_accnt_list set status=1 where ctm_accnt=@fetch_res;
      SELECT @fetch_res;
   END IF;
END; 
//

SHOW WARNINGS //

DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS sp_chk_accnt_upd //

CREATE PROCEDURE sp_chk_accnt_upd(
   IN api_ret tinyint(1),
   IN chk_accnt int(9)
  )
BEGIN
  DECLARE done INT DEFAULT 0;
  SELECT status into @ctm_accnt_status from ctm_accnt_list where ctm_accnt=chk_accnt;
  IF api_ret = 1 then
     SELECT IFNULL((SELECT status from ctm_accnt_list where ctm_accnt=chk_accnt),0) into @ctm_accnt_status;
     IF @ctm_accnt_status = 0 then
        SET @mysql_err=1329;
        SELECT @mysql_err;
     ELSE
        SET @fetch_res=2;
        SELECT @fetch_res;
     END IF;
  ELSE
     SELECT IFNULL((SELECT status from ctm_accnt_list where ctm_accnt=chk_accnt),0) into @ctm_accnt_status1;
     IF @ctm_accnt_status1 = 0 then
       SET @mysql_err=1329;
       SELECT @mysql_err;
     ELSE
       UPDATE ctm_accnt_list set status=0 where ctm_accnt=chk_accnt;
       SET @fetch_res=3;
       SELECT @fetch_res;
     END IF;
  END IF;
END;
//

SHOW WARNINGS //

DELIMITER ;


DELIMITER //

DROP PROCEDURE IF EXISTS sp_carrier_sim_type //

CREATE PROCEDURE sp_carrier_sim_type(
   IN in_msisdn_id varchar(19),
   OUT user_msisdn_type varchar(10),
   OUT user_msisdn_carrier varchar(15)
  )
BEGIN
  SELECT sim_type,operator into user_msisdn_type,user_msisdn_carrier
  FROM mobile_pattern
  WHERE in_msisdn_id REGEXP pattern; 
END;
//

SHOW WARNINGS //

DELIMITER ;


DELIMITER //

DROP PROCEDURE IF EXISTS sp_reg_sns_ctm_accnts //

CREATE PROCEDURE sp_reg_sns_ctm_accnts(
   IN in_ctm_accnt int(9),
   IN in_sn_provider_id tinyint(4),
   IN in_token varchar(255),
   IN in_sn_display_name varchar(80),
   IN in_email_add varchar(80),
   IN in_reg_app varchar(15),
   IN in_ctm_token varchar(255)
  )
BEGIN
   DECLARE done INT DEFAULT 0;
   DECLARE CONTINUE HANDLER FOR sqlstate '23000' SET done = 1;
   
   INSERT INTO ctm_sns_link(ctm_accnt,sn_provider_id,token,sn_display_name,email_add) VALUES (in_ctm_accnt,in_sn_provider_id,in_token,in_sn_display_name,in_email_add);
   SELECT ROW_COUNT() into @ctm_sns_link;

   INSERT INTO ctm_accounts(ctm_accnt,ctm_token,reg_date,reg_src,reg_app) values(in_ctm_accnt,in_ctm_token,now(),in_sn_provider_id,in_reg_app);
   SELECT ROW_COUNT() into @ctm_accnts;
   
   IF @ctm_sns_link = 1 and @ctm_accnts = 1  THEN
      SET @insert_res = 2;
      SELECT @insert_res;
   ELSE
      SET @mysql_err = 1062;
      SELECT @mysql_err;
   END IF;

END;
//

SHOW WARNINGS //

DELIMITER ;


DELIMITER //

DROP TRIGGER IF EXISTS trg_reg_mob_ctm_accnts //

 --  IF REGISTRATION is made via mobile
CREATE TRIGGER trg_reg_mob_ctm_accnts  before insert on ctm_accounts
FOR EACH ROW
BEGIN

   DECLARE user_msisdn_id varchar(19);
   DECLARE done int default 0;
   IF new.msisdn is null then
      BEGIN
       DECLARE EXIT HANDLER for sqlstate '02000'  set done = 1;
      END ;
   ELSE
      IF LEFT(new.msisdn,2) = 63 then
         BEGIN
           SET  user_msisdn_id=new.msisdn;
           call sp_carrier_sim_type(user_msisdn_id,@user_msisdn_type,@user_msisdn_carrier);
           SET  new.msisdn_type=@user_msisdn_type;
           SET  new.msisdn_carrier=@user_msisdn_carrier; 
         END ;
      END IF ;
   END IF;

END;
//

SHOW WARNINGS //

DELIMITER ;


DELIMITER //

DROP TRIGGER IF EXISTS trg_upd_mob_ctm_accnts //

CREATE TRIGGER trg_upd_mob_ctm_accnts  before update on ctm_accounts
FOR EACH ROW
BEGIN
   DECLARE user_msisdn_id varchar(19);
   IF old.country = 175 or new.country is null then
      SET  user_msisdn_id=new.msisdn;
      call sp_carrier_sim_type(user_msisdn_id,@user_msisdn_type,@user_msisdn_carrier);
      SET new.msisdn_type=@user_msisdn_type;
      SET new.msisdn_carrier=@user_msisdn_carrier;  
   END IF;
END;
//

SHOW WARNINGS //

DELIMITER ;

