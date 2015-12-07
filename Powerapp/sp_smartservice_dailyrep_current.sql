CREATE PROCEDURE sp_smartservice_dailyrep()
BEGIN
    DECLARE vRepHourlyHitFile varchar(70);
    DECLARE vRepHourlyUniqHitFile varchar(80);
    DECLARE vRepHourly_NoBuysFile varchar(80);
    DECLARE vRepHourly_NoUniqBuysFile varchar(80);
    DECLARE vRepDailyBuysPerplan varchar(80);
    DECLARE vRepDailyOtherRep varchar(80);
    DECLARE vErr int DEFAULT 0;
    DECLARE vMsg text;
    DECLARE CONTINUE HANDLER FOR 1086 SET vErr='1086', vMsg="File '%s' already exists";
    SET SESSION  tmp_table_size = 268435456;
    SET SESSION  max_heap_table_size = 268435456;
    SET SESSION  sort_buffer_size = 104857600;
    SET SESSION  read_buffer_size = 8388608;

    BEGIN
        SET @rep_date = date_sub(curdate(), interval 1 day);
        SET vRepHourlyHitFile = CONCAT('/mnt/logs/app_log/hourly_hits_rep.',@rep_date,'.txt');
        SET @vRepHourlyHitSQL = CONCAT("SELECT 'tx_date','plan','0000H','0100H','0200H','0300H','0400H','0500H','0600H','0700H','0800H','0900H','1000H',
                                               '1100H','1200H','1300H','1400H','1500H','1600H','1700H','1800H','1900H','2000H','2100H','2200H','2300H'
                                               UNION ALL
                                        SELECT tx_date,plan,
                                               MAX(IF(hour(tx_time)=0,hits,0))  as '0000H', MAX(IF(hour(tx_time)=1,hits,0))  as '0100H',
                                               MAX(IF(hour(tx_time)=2,hits,0))  as '0200H', MAX(IF(hour(tx_time)=3,hits,0))  as '0300H',
                                               MAX(IF(hour(tx_time)=4,hits,0))  as '0400H', MAX(IF(hour(tx_time)=5,hits,0))  as '0500H',
                                               MAX(IF(hour(tx_time)=6,hits,0))  as '0600H', MAX(IF(hour(tx_time)=7,hits,0))  as '0700H',
                                               MAX(IF(hour(tx_time)=8,hits,0))  as '0800H', MAX(IF(hour(tx_time)=9,hits,0))  as '0900H',
                                               MAX(IF(hour(tx_time)=10,hits,0)) as '1000H', MAX(IF(hour(tx_time)=11,hits,0)) as '1100H',
                                               MAX(IF(hour(tx_time)=12,hits,0)) as '1200H', MAX(IF(hour(tx_time)=13,hits,0)) as '1300H',
                                               MAX(IF(hour(tx_time)=14,hits,0)) as '1400H', MAX(IF(hour(tx_time)=15,hits,0)) as '1500H',
                                               MAX(IF(hour(tx_time)=16,hits,0)) as '1600H', MAX(IF(hour(tx_time)=17,hits,0)) as '1700H',
                                               MAX(IF(hour(tx_time)=18,hits,0)) as '1800H', MAX(IF(hour(tx_time)=19,hits,0)) as '1900H',
                                               MAX(IF(hour(tx_time)=20,hits,0)) as '2000H', MAX(IF(hour(tx_time)=21,hits,0)) as '2100H',
                                               MAX(IF(hour(tx_time)=22,hits,0)) as '2200H', MAX(IF(hour(tx_time)=23,hits,0)) as '2300H'
                                        FROM stats_smartservice_hourly
                                        WHERE tx_date ='",@rep_date,"'
                                        GROUP BY plan
                                        INTO OUTFILE '",vRepHourlyHitFile,"'"
                                      );
        PREPARE stmt FROM @vRepHourlyHitSQL;
        EXECUTE stmt;
        SELECT @vRepHourlyHitSQL;
        DEALLOCATE PREPARE stmt;
        
        SET vRepHourlyUniqHitFile = CONCAT('/mnt/logs/app_log/hourly_uniqhits_rep.',@rep_date,'.txt');
        SET @vRepHourlyUniqHitSQL = CONCAT("SELECT 'tx_date','plan','0000H','0100H','0200H','0300H','0400H','0500H','0600H','0700H','0800H','0900H','1000H',
                                                   '1100H','1200H','1300H','1400H','1500H','1600H','1700H','1800H','1900H','2000H','2100H','2200H','2300H'
                                            UNION ALL
                                            SELECT tx_date,plan,
                                                   MAX(IF(hour(tx_time)=0,uniq,0))  as '0000H', MAX(IF(hour(tx_time)=1,uniq,0))  as '0100H',
                                                   MAX(IF(hour(tx_time)=2,uniq,0))  as '0200H', MAX(IF(hour(tx_time)=3,uniq,0))  as '0300H',
                                                   MAX(IF(hour(tx_time)=4,uniq,0))  as '0400H', MAX(IF(hour(tx_time)=5,uniq,0))  as '0500H',
                                                   MAX(IF(hour(tx_time)=6,uniq,0))  as '0600H', MAX(IF(hour(tx_time)=7,uniq,0))  as '0700H',
                                                   MAX(IF(hour(tx_time)=8,uniq,0))  as '0800H', MAX(IF(hour(tx_time)=9,uniq,0))  as '0900H',
                                                   MAX(IF(hour(tx_time)=10,uniq,0)) as '1000H', MAX(IF(hour(tx_time)=11,uniq,0)) as '1100H',
                                                   MAX(IF(hour(tx_time)=12,uniq,0)) as '1200H', MAX(IF(hour(tx_time)=13,uniq,0)) as '1300H',
                                                   MAX(IF(hour(tx_time)=14,uniq,0)) as '1400H', MAX(IF(hour(tx_time)=15,uniq,0)) as '1500H',
                                                   MAX(IF(hour(tx_time)=16,uniq,0)) as '1600H', MAX(IF(hour(tx_time)=17,uniq,0)) as '1700H',
                                                   MAX(IF(hour(tx_time)=18,uniq,0)) as '1800H', MAX(IF(hour(tx_time)=19,uniq,0)) as '1900H',
                                                   MAX(IF(hour(tx_time)=20,uniq,0)) as '2000H', MAX(IF(hour(tx_time)=21,uniq,0)) as '2100H',
                                                   MAX(IF(hour(tx_time)=22,uniq,0)) as '2200H', MAX(IF(hour(tx_time)=23,uniq,0)) as '2300H'
                                            FROM stats_smartservice_hourly
                                            WHERE tx_date = '",@rep_date,"'
                                            GROUP BY plan
                                            INTO OUTFILE '",vRepHourlyUniqHitFile,"'"
                                          );
        PREPARE stmt FROM @vRepHourlyUniqHitSQL;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SET vRepHourly_NoBuysFile = CONCAT('/mnt/logs/app_log/hourly_nobuys_rep.',@rep_date,'.txt');
        SET @vRepHourlyNoBuysSQL = CONCAT("SELECT 'tx_date','plan','0000H','0100H','0200H','0300H','0400H','0500H','0600H','0700H','0800H','0900H','1000H',
                                                   '1100H','1200H','1300H','1400H','1500H','1600H','1700H','1800H','1900H','2000H','2100H','2200H','2300H'
                                           UNION ALL
                                           SELECT tx_date,plan,
                                                  MAX(IF(hour(tx_time)=0,no_buys,0))  as '0000H', MAX(IF(hour(tx_time)=1,no_buys,0))  as '0100H',
                                                  MAX(IF(hour(tx_time)=2,no_buys,0))  as '0200H', MAX(IF(hour(tx_time)=3,no_buys,0))  as '0300H',
                                                  MAX(IF(hour(tx_time)=4,no_buys,0))  as '0400H', MAX(IF(hour(tx_time)=5,no_buys,0))  as '0500H',
                                                  MAX(IF(hour(tx_time)=6,no_buys,0))  as '0600H', MAX(IF(hour(tx_time)=7,no_buys,0))  as '0700H',
                                                  MAX(IF(hour(tx_time)=8,no_buys,0))  as '0800H', MAX(IF(hour(tx_time)=9,no_buys,0))  as '0900H',
                                                  MAX(IF(hour(tx_time)=10,no_buys,0)) as '1000H', MAX(IF(hour(tx_time)=11,no_buys,0)) as '1100H',
                                                  MAX(IF(hour(tx_time)=12,no_buys,0)) as '1200H', MAX(IF(hour(tx_time)=13,no_buys,0)) as '1300H',
                                                  MAX(IF(hour(tx_time)=14,no_buys,0)) as '1400H', MAX(IF(hour(tx_time)=15,no_buys,0)) as '1500H',
                                                  MAX(IF(hour(tx_time)=16,no_buys,0)) as '1600H', MAX(IF(hour(tx_time)=17,no_buys,0)) as '1700H',
                                                  MAX(IF(hour(tx_time)=18,no_buys,0)) as '1800H', MAX(IF(hour(tx_time)=19,no_buys,0)) as '1900H',
                                                  MAX(IF(hour(tx_time)=20,no_buys,0)) as '2000H', MAX(IF(hour(tx_time)=21,no_buys,0)) as '2100H',
                                                  MAX(IF(hour(tx_time)=22,no_buys,0)) as '2200H', MAX(IF(hour(tx_time)=23,no_buys,0)) as '2300H'  
                                           FROM stats_smartservice_hourly
                                           WHERE tx_date = '",@rep_date,"'
                                           GROUP BY plan 
                                           INTO OUTFILE '",vRepHourly_NoBuysFile,"'"
                                         );
        PREPARE stmt FROM @vRepHourlyNoBuysSQL;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        
        SET vRepHourly_NoUniqBuysFile = CONCAT('/mnt/logs/app_log/hourly_nouniqbuys_rep.',@rep_date,'.txt');
        SET @vRepHourlyNoUniqBuysSQL = CONCAT("SELECT 'tx_date','plan','0000H','0100H','0200H','0300H','0400H','0500H','0600H','0700H','0800H','0900H','1000H',
                                                   '1100H','1200H','1300H','1400H','1500H','1600H','1700H','1800H','1900H','2000H','2100H','2200H','2300H'
                                               UNION ALL
                                               SELECT tx_date,plan,
                                                      MAX(IF(hour(tx_time)=0,no_uniq_buys,0))  as '0000H', MAX(IF(hour(tx_time)=1,no_uniq_buys,0))  as '0100H',
                                                      MAX(IF(hour(tx_time)=2,no_uniq_buys,0))  as '0200H', MAX(IF(hour(tx_time)=3,no_uniq_buys,0))  as '0300H',
                                                      MAX(IF(hour(tx_time)=4,no_uniq_buys,0))  as '0400H', MAX(IF(hour(tx_time)=5,no_uniq_buys,0))  as '0500H',
                                                      MAX(IF(hour(tx_time)=6,no_uniq_buys,0))  as '0600H', MAX(IF(hour(tx_time)=7,no_uniq_buys,0))  as '0700H',
                                                      MAX(IF(hour(tx_time)=8,no_uniq_buys,0))  as '0800H', MAX(IF(hour(tx_time)=9,no_uniq_buys,0))  as '0900H',
                                                      MAX(IF(hour(tx_time)=10,no_uniq_buys,0)) as '1000H', MAX(IF(hour(tx_time)=11,no_uniq_buys,0)) as '1100H',
                                                      MAX(IF(hour(tx_time)=12,no_uniq_buys,0)) as '1200H', MAX(IF(hour(tx_time)=13,no_uniq_buys,0)) as '1300H',
                                                      MAX(IF(hour(tx_time)=14,no_uniq_buys,0)) as '1400H', MAX(IF(hour(tx_time)=15,no_uniq_buys,0)) as '1500H',
                                                      MAX(IF(hour(tx_time)=16,no_uniq_buys,0)) as '1600H', MAX(IF(hour(tx_time)=17,no_uniq_buys,0)) as '1700H',
                                                      MAX(IF(hour(tx_time)=18,no_uniq_buys,0)) as '1800H', MAX(IF(hour(tx_time)=19,no_uniq_buys,0)) as '1900H',
                                                      MAX(IF(hour(tx_time)=20,no_uniq_buys,0)) as '2000H', MAX(IF(hour(tx_time)=21,no_uniq_buys,0)) as '2100H',
                                                      MAX(IF(hour(tx_time)=22,no_uniq_buys,0)) as '2200H', MAX(IF(hour(tx_time)=23,no_uniq_buys,0)) as '2300H'
                                               FROM stats_smartservice_hourly
                                               WHERE tx_date = '",@rep_date,"'
                                               GROUP BY plan
                                               INTO OUTFILE '",vRepHourly_NoUniqBuysFile,"'"
                                             );
        PREPARE stmt FROM @vRepHourlyNoUniqBuysSQL;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SET vRepDailyBuysPerplan = CONCAT('/mnt/logs/app_log/daily_hits_rep.',@rep_date,'.txt');
        SET @vRepDailyBuyPerPlanSQL = CONCAT(" SELECT 'tx_date','plan','number_of_hits','number_of_uniq_hist','numb_of_buys','numb_of_uniq_buys'
                                               UNION ALL
                                               SELECT tx_date,plan,
                                                     MAX(IF(hits>=0,hits,0)) as number_of_hits,MAX(IF(uniq>=0,uniq,0)) as  number_of_uniq_hist,
                                                     MAX(IF(no_buys>=0,no_buys,0)) as numb_of_buys,MAX(IF(no_uniq_buys>=0,no_uniq_buys,0)) as numb_of_uniq_buys
                                               FROM stats_smartservice_daily_per_plan
                                               WHERE tx_date = '",@rep_date,"'
                                               GROUP BY tx_date,plan
                                               INTO OUTFILE '",vRepDailyBuysPerplan,"'"
                                            );
        PREPARE stmt FROM @vRepDailyBuyPerPlanSQL;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SET vRepDailyOtherRep = CONCAT('/mnt/logs/app_log/daily_other_rep.',@rep_date,'.txt');
        SET @vRepDailyOtherSQL = CONCAT("SELECT 'tx_date','number_of_hits','number_of_uniq_hist','numb_of_buys','numb_of_uniq_buys','buys_via_app','buys_via_web',
                                                'buys_via_sms','number_of_active_mins','monthly_uniq_buys','monthly_uniq_active','number_insufficient_bal','number_insufficient_bal_uniq',
                                                'subs_not_allowed','subs_not_allowed_uniq','invalid_phones','invalid_phones_uniq'
                                         UNION ALL
                                         SELECT tx_date,
                                                MAX(IF(hits>=0,hits,0)) as number_of_hits,
                                                MAX(IF(uniq>=0,uniq,0)) as  number_of_uniq_hist,
                                                MAX(IF(no_buys>=0,no_buys,0)) as numb_of_buys,
                                                MAX(IF(no_uniq_buys>=0,no_uniq_buys,0)) as numb_of_uniq_buys,
                                                MAX(IF(no_buys_via_app>=0,no_buys_via_app,0)) as buys_via_app,
                                                MAX(IF(no_buys_via_web>=0,no_buys_via_web,0)) as  buys_via_web,
                                                MAX(IF(no_buys_via_sms>=0,no_buys_via_sms,0)) as buys_via_sms,
                                                MAX(IF(no_actv_mins>=0,no_actv_mins,0)) as number_of_active_mins,
                                                MAX(IF(mo_uniq_actv>=0,mo_uniq_actv,0)) as monthly_uniq_buys,
                                                MAX(IF(mo_uniq_actv>=0,mo_uniq_actv,0)) as  monthly_uniq_active,
                                                MAX(IF(insuff_bal_cnt>=0,insuff_bal_cnt,0)) as number_insufficient_bal,
                                                MAX(IF(insuff_bal_uniq>=0,insuff_bal_uniq,0)) as number_insufficient_bal_uniq,
                                                MAX(IF(subs_not_allowed_cnt>=0,subs_not_allowed_cnt,0)) as subs_not_allowed,
                                                MAX(IF(subs_not_allowed_uniq>=0,subs_not_allowed_uniq,0)) as  subs_not_allowed_uniq,
                                                MAX(IF(invalid_phone_cnt>=0,invalid_phone_cnt,0)) as invalid_phones,
                                                MAX(IF(invalid_phone_uniq>=0,invalid_phone_uniq,0)) as invalid_phones_uniq                                         
                                         FROM stats_smartservice_daily
                                         WHERE tx_date = '",@rep_date,"'                                                 
                                         GROUP BY tx_date
                                         INTO OUTFILE '",vRepDailyOtherRep,"'
                                         FIELDS TERMINATED BY '\t'
                                         LINES TERMINATED BY '\n'"
                                         );
        PREPARE stmt FROM @vRepDailyOtherSQL;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        IF vErr > 0 THEN
          DELETE FROM err_str_log WHERE datein = date_sub(curdate(),INTERVAL 30 DAY);
          INSERT IGNORE INTO err_str_log(datein,timein,err_cod,err_msg) VALUES(curdate(),curtime(),vErr,vMsg);
        END IF;


    END ;
END;
//
