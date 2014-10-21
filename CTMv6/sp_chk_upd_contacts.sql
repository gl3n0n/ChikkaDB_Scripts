DROP PROCEDURE sp_chk_test_contacts;
delimiter ;;
CREATE PROCEDURE sp_chk_test_contacts(IN p_Contacts text)
BEGIN
    DECLARE vData_Row, vContacts text;
    DECLARE vNorm_Accnt, vRaw_Accnt varchar(100);
    DECLARE vName varchar(60);
    DECLARE vCurrent_Field, vSversion, vSdeleted, vSfave, vChkUpdate tinyint;
    DECLARE vCtm_Acnt, vCSV_Value varchar(20);
    SET vContacts = p_Contacts;
    WHILE INSTR(vContacts, ';') > 0 DO
       SET vData_Row=CAST(SUBSTRING(vContacts, 1, INSTR(vContacts,';' )) AS CHAR);
       SET vCurrent_Field=1;
       WHILE INSTR(vData_Row, ',') > 0 DO
           SET vCSV_Value=CAST(SUBSTRING(vData_Row, 1, INSTR(vData_Row,',' )-1) AS CHAR);
           IF vCurrent_Field = 1 THEN
              SET vCtm_Acnt=vCSV_Value;
           END IF;
           IF vCurrent_Field = 2 THEN
              SET vRaw_Accnt=vCSV_Value;
           END IF;
           IF vCurrent_Field = 3 THEN
              SET vNorm_Accnt=vCSV_Value;
           END IF;
           IF vCurrent_Field = 4 THEN
              SET vName=vCSV_Value;
           END IF;
           IF vCurrent_Field = 5 THEN
              SET vSversion=vCSV_Value;
           END IF;
           IF vCurrent_Field = 6 THEN
              SET vSdeleted=vCSV_Value;
           END IF;
           IF vCurrent_Field = 7 THEN
              SET vSfave=vCSV_Value;
           END IF;
           SET vData_Row = SUBSTRING(vData_Row, INSTR( vData_Row,',') + 1, LENGTH(vData_Row));
           SET vCurrent_Field = vCurrent_Field + 1;
       END WHILE;
       UPDATE ctmv6.contacts_1 
       SET    raw_contact_id=vRaw_Accnt,
              name=vName,
              s_version=vSversion,
              s_deleted=vSdeleted,
              s_fave=vSfave
       WHERE  ctm_accnt=vCtm_Acnt
       AND    norm_contact_id=vNorm_Accnt;
       SELECT row_count() INTO vChkUpdate;
       IF vChkUpdate = 0 THEN
          BEGIN
             DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET @catch_dup_err = 1;
             INSERT INTO ctmv6.contacts_1(ctm_accnt,raw_contact_id,norm_contact_id,name,s_version,s_deleted,s_fave)
             VALUES (vCtm_Acnt, vRaw_Accnt, vNorm_Accnt, vName, vSversion, vSdeleted, vSfave);
          END;
       END IF;
       SET vContacts = SUBSTRING(vContacts, INSTR(vContacts,';' ) + 1, LENGTH(vContacts));
    END WHILE;
END;
;;
delimiter ;

-- call sp_chk_upd_contacts('08112777247,639183611111,639183611111,kirsten,1,0,0,;');
call sp_chk_test_contacts('08100000022,639206433282,639206433282,TesK,3,0,0,;08100000024,639206433282,639206433282,TesK,3,0,0,;08100000024,639206433282,639206433282,TesK,3,0,0,;');  
UPDATE ctmv6.contacts_1 SET raw_contact_id='639206433282',name='TesK',s_version=3,s_deleted=0,s_fave=0 WHERE  ctm_accnt='08100000022' and norm_contact_id='639206433289';
select row_count();
SELECT SQL_CALC_FOUND_ROWS * FROM ctmv6.contacts_1 LIMIT 5;
SELECT FOUND_ROWS();
