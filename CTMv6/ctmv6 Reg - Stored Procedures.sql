CREATE PROCEDURE sp_carrier_sim_type(
   IN  in_msisdn_id varchar(19),
   OUT user_msisdn_type varchar(10),
   OUT user_msisdn_carrier varchar(15)
  )
BEGIN
   IF left(in_msisdn_id,2) = '63' then
      SELECT sim_type,operator 
      INTO   user_msisdn_type, user_msisdn_carrier
      FROM   mobile_pattern
      WHERE  operator <> 'PHILIPPINES' 
      AND    in_msisdn_id REGEXP pattern limit 1;
   ELSEIF in_msisdn_id is not null then
      SELECT sim_type,operator 
      INTO   user_msisdn_type,user_msisdn_carrier
      FROM   mobile_pattern
      WHERE  operator <> 'SMART'
      AND    operator <> 'SUN'
      AND    operator <> 'GLOBE' 
      AND    in_msisdn_id REGEXP pattern limit 1;
   ELSE
      SET user_msisdn_type=NULL;
      SET user_msisdn_carrier = NULL;
   END IF;
END; 
//



CREATE PROCEDURE sp_ctm_registration_log(
   in_ctm_accnt      varchar(12),
   in_reg_app        varchar(15),
   in_reg_src        varchar(20),
   in_reg_sn_id      varchar(80),
   in_email_add      varchar(80),
   in_country        smallint(6),
   in_msisdn         varchar(19)
 )
BEGIN
   DECLARE nRetr, done_reg INT DEFAULT 0;
   DECLARE v_country, v_msisdn_type, v_msisdn_carrier VARCHAR(16) DEFAULT NULL;
   DECLARE CONTINUE HANDLER FOR sqlstate '23000' SET done_reg = 1;
   
   IF (in_msisdn is not null) AND (in_msisdn like '63%') THEN
      call sp_carrier_sim_type(in_msisdn, v_msisdn_type, v_msisdn_carrier);
      SET v_country = 'PHILIPPINES';
   ELSEIF (in_msisdn is not null) THEN
      call sp_carrier_sim_type(in_msisdn, v_msisdn_type, v_country);
      SET v_msisdn_carrier = null;
      SET v_msisdn_type = null;
   ELSE
      SET v_country = null;
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
            v_country,
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

END;
//
 
 