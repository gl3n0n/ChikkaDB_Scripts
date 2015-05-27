CREATE PROCEDURE `prc_netcast_migrate_company_details_new`(IN companyid INT)
BEGIN
     DECLARE newcompany_id INT;
     DECLARE old_compan_id INT;

     TRUNCATE  netcast_db_migrate.contacts;
     TRUNCATE  netcast_db_migrate.exclusion_list;
     TRUNCATE  netcast_db_migrate.groups;
     TRUNCATE  netcast_db_migrate.groups_contacts;
     TRUNCATE  netcast_db_migrate.users;
     TRUNCATE  netcast_db_migrate.sftp_details;
     TRUNCATE  netcast_db_migrate.v3_user_id_references;
     TRUNCATE  netcast_db_migrate.ws_tokens;
     TRUNCATE  netcast_simulator.stg_prod_users;
     TRUNCATE  netcast_simulator.v4_pivot_report;
     TRUNCATE  netcast_simulator.tmp_msisdn_v3;
     TRUNCATE  netcast_simulator.v3_pivot_report;
     TRUNCATE  netcast3_db.contacts_tb2;
     INSERT into netcast3_db.contacts_tb2(id,company_id,name,alias,msisdn_id,user_id,age,gender,address,birthday,email,
                                          status_flag,date_created,date_updated)
     select * from netcast3_db.contacts_tb;

     SELECT new_company_id INTO newcompany_id FROM company_list WHERE id=companyid;
     SELECT id INTO old_compan_id FROM company_list WHERE id=companyid;
     SELECT newcompany_id;
     SELECT old_compan_id;

     BEGIN
          DECLARE done int default 0;
          DECLARE CONTINUE HANDLER for sqlstate '23000' set done = 1;
          DECLARE CONTINUE HANDLER FOR 1086 set done = 1;

          -- SET 63 format, and brand for mobile numbers (msisdn_tb)
          INSERT INTO netcast_simulator.tmp_msisdn_v3(id,msisdn)
          SELECT id,msisdn
          FROM netcast3_db.msisdn_tb ;

          UPDATE netcast_simulator.tmp_msisdn_v3
          SET msisdn = CASE WHEN LENGTH(msisdn)=9 THEN CONCAT('639',`msisdn`) ELSE `msisdn` END,
          brand=netcast_simulator.fnc_mobile_pattern_operator(msisdn);

          -- migrate table users_tb to netcast_central_prod.users
          INSERT IGNORE netcast_central_prod.users
                (company_id,username,name,
                 role,
                 email,
                 msisdn,
                 status,
                 email_verified, mobile_verified, date_created, date_updated)
          SELECT newcompany_id, email,name, 
                 CASE WHEN role=1 THEN 'COMPANY ADMIN' ELSE 'CONTENT PROVIDER' END, 
                 email, 
                 CONCAT('639',mobile_number),
                 CASE WHEN status_flag=1 THEN 'ACTIVE' ELSE 'DISABLED' END, 
                 1, 0, date_created, date_updated 
          FROM netcast3_db.users_tb;

          INSERT INTO netcast_simulator.stg_prod_users
                (user_id,company_id,username,password,name,role,
                 email,msisdn,msisdn_carrier,msisdn_brand,status,email_verified,
                 mobile_verified,date_created,date_updated)
          SELECT user_id,company_id,username,password,name,role,
                 email,msisdn,msisdn_carrier,msisdn_brand,status,email_verified,
                 mobile_verified,date_created,date_updated
          FROM netcast_central_prod.users;

          INSERT INTO users 
                (company_id,username,name,
                 role,
                 email, msisdn,
                 status,
                 email_verified, mobile_verified, date_created, date_updated,
                 old_user_id, v3_company_id)
          SELECT newcompany_id, email,name,
                 CASE WHEN role=1 THEN 'COMPANY ADMIN' ELSE 'CONTENT PROVIDER' END,
                 email, CONCAT('639',mobile_number),
                 CASE WHEN status_flag=1 THEN 'ACTIVE' ELSE 'DISABLED' END,
                 1, 0, date_created, date_updated,
                 id, old_compan_id
          FROM netcast3_db.users_tb;


          UPDATE netcast_db_migrate.users 
          SET    msisdn_carrier = netcast_simulator.fnc_mobile_pattern_operator(msisdn);

          -- UPDATE netcast_db_migrate.users a
          -- INNER JOIN netcast_simulator.stg_prod_users b ON (a.company_id=b.company_id AND a.email=b.email)
          -- SET a.user_id=b.user_id
          -- WHERE b.username not like 'chk_q%'
          -- AND b.company_id=200;

          UPDATE netcast_db_migrate.users a
          SET a.user_id = IFNULL((select b.user_id from netcast_simulator.stg_prod_users b where a.email=b.email and b.username not like 'chk_q%' AND b.company_id=newcompany_id order by date_updated limit 1),a.user_id);


          call netcast_simulator.sp_premigration_req();

          SET @sql_insert_groups = CONCAT("INSERT INTO netcast_db_migrate.groups (old_group_id,user_id,company_id,group_name,date_created,new_user_id)
                                           SELECT a.id as old_group_id,b.old_user_id as user_id,",newcompany_id,",a.name as group_name,b.date_created,b.user_id
                                           FROM netcast3_db.group_tb a
                                           INNER JOIN netcast_db_migrate.users b ON(a.user_id=b.old_user_id)
                                           WHERE a.company_id=",companyid,"
                                           AND a.status_flag=1
                                           AND b.status=1
                                           GROUP BY a.user_id,group_name");
          PREPARE stmt FROM @sql_insert_groups;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @sql_insert_groups;

          DROP TABLE IF EXISTS netcast_db_migrate.stg_contacts_active;
          CREATE TEMPORARY TABLE IF NOT EXISTS netcast_db_migrate.stg_contacts_active like netcast_db_migrate.contacts;
          DROP INDEX `user_id` ON netcast_db_migrate.stg_contacts_active;
          SET @sql_insert_contacts_active = CONCAT("INSERT IGNORE INTO netcast_db_migrate.stg_contacts_active(old_contact_id,user_id,company_id,msisdn,email,first_name,
                                                                                                              info1,info2,info3,info4,date_created,network,new_user_id)
                                                    SELECT a.id  AS old_contact_id,a.user_id AS user_id,",newcompany_id,",b.msisdn  AS msisdn,a.email AS email,a.name AS first_name,
                                                           a.age AS info_1,a.gender AS info_2,a.address AS info_3,a.birthday AS info_4,a.date_created  AS date_created,b.brand,c.user_id
                                                    FROM netcast3_db.contacts_tb a
                                                    INNER JOIN netcast_simulator.tmp_msisdn_v3 b ON (a.msisdn_id=b.id)
                                                    INNER JOIN netcast_db_migrate.users c ON(a.user_id=c.old_user_id)
                                                    WHERE a.company_id=",companyid,"
                                                    AND a.status_flag=1
                                                    AND b.brand is not null
                                                    AND b.brand !=''
                                                    AND c.status='ACTIVE'
                                                    GROUP BY a.id,b.id");
          PREPARE stmt FROM @sql_insert_contacts_active;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @sql_insert_contacts_active;

          DROP TABLE IF EXISTS netcast_db_migrate.stg_groups_2;
          CREATE TEMPORARY TABLE IF NOT EXISTS netcast_db_migrate.stg_groups_2 like netcast_db_migrate.groups;
          DROP INDEX `groupname_id` ON  netcast_db_migrate.stg_groups_2;
          SET @sql_insert_stg_groups_2 = CONCAT("INSERT IGNORE INTO netcast_db_migrate.stg_groups_2(old_group_id,user_id,company_id,group_name,date_created,new_user_id)
                                                 SELECT a.group_id,b.user_id,b.company_id,CONCAT(c.name,'_',b.user_id) as group_nane,a.date_created,d.user_id
                                                 FROM netcast3_db.contacts_group_tb a
                                                 INNER JOIN netcast3_db.contacts_tb b ON (a.cONtact_id=b.id )
                                                 INNER JOIN netcast3_db.group_tb c ON (a.group_id=c.id)
                                                 INNER JOIN netcast_simulator.vw_stg_users d ON (b.user_id=d.id)
                                                 WHERE c.status_flag<>0
                                                 AND b.user_id<>c.user_id
                                                 AND d.user_id !=0
                                                 GROUP BY 6,4,3,2,1
                                                 ORDER BY 1");
          PREPARE stmt FROM @sql_insert_stg_groups_2;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @sql_insert_stg_groups_2;

          DROP TABLE IF EXISTS netcast_db_migrate.stg_groups_3;
          CREATE TEMPORARY TABLE IF NOT EXISTS netcast_db_migrate.stg_groups_3 like netcast_db_migrate.groups;
          DROP INDEX `groupname_id` ON  netcast_db_migrate.stg_groups_3;
          SET @sql_insert_stg_groups_3 = CONCAT("INSERT IGNORE INTO netcast_db_migrate.stg_groups_3(old_group_id,user_id,company_id,group_name,date_created,new_user_id)
                                                 SELECT a.group_id,b.user_id,b.company_id,CONCAT(c.name,'_',b.user_id) as group_nane,a.date_created,e.user_id
                                                 FROM netcast3_db.contacts_group_tb a
                                                 INNER JOIN netcast3_db.contacts_tb b ON (a.cONtact_id=b.id )
                                                 INNER JOIN netcast3_db.group_tb c ON (a.group_id=c.id)
                                                 INNER JOIN netcast_simulator.vw_stg_users d ON (b.user_id=d.id)
                                                 CROSS JOIN netcast_simulator.vw_stg_users e
                                                 WHERE c.status_flag<>0
                                                 AND b.user_id<>c.user_id
                                                 AND d.user_id =0
                                                 AND e.role=1
                                                 AND e.status_flag=1
                                                 -- AND e.status_flag=1
                                                 GROUP BY 6,4,3,2,1
                                                 ORDER BY 1");

          PREPARE stmt FROM @sql_insert_stg_groups_3;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @sql_insert_stg_groups_3;

          INSERT INTO netcast_simulator.v4_pivot_report(v4_company_id,v3_userid,v3_grpid,num_count,type,v4_grpid,v4_userid,v3_company_id)
          SELECT a.company_id,b.id,a.old_group_id,count(1),'split_groups',a.group_id,a.new_user_id,old_compan_id
          FROM netcast_db_migrate.stg_groups_2 a
          INNER JOIN netcast_simulator.vw_stg_users b ON (a.user_id=b.id)
          GROUP BY a.new_user_id;

          INSERT INTO netcast_simulator.v4_pivot_report(v4_company_id,v3_userid,v3_grpid,num_count,type,v4_grpid,v4_userid,v3_company_id)
          SELECT a.company_id,b.id,a.old_group_id,count(1),'split_groups',a.group_id,a.new_user_id,old_compan_id
          FROM netcast_db_migrate.stg_groups_3 a
          INNER JOIN netcast_simulator.vw_stg_users b ON (a.user_id=b.id)
          GROUP BY a.new_user_id;


          INSERT INTO netcast_db_migrate.groups(old_group_id,user_id,company_id,group_name,date_created,new_user_id)
          SELECT old_group_id,user_id,company_id,group_name,date_created,new_user_id
          FROM netcast_db_migrate.stg_groups_2;

          INSERT INTO netcast_db_migrate.groups(old_group_id,user_id,company_id,group_name,date_created,new_user_id)
          SELECT old_group_id,user_id,company_id,group_name,date_created,new_user_id
          FROM netcast_db_migrate.stg_groups_3;

          DROP TABLE IF EXISTS netcast_db_migrate.stg_groups_del;
          CREATE TEMPORARY TABLE IF NOT EXISTS netcast_db_migrate.stg_groups_del like netcast_db_migrate.groups;
          DROP INDEX `groupname_id` ON  netcast_db_migrate.stg_groups_del;
          SET @sql_insert_stg_groups_del = CONCAT("INSERT  IGNORE INTO  netcast_db_migrate.stg_groups_del (old_group_id,user_id,company_id,group_name,date_created,new_user_id)
                                                   SELECT a.id as old_group_id,a.user_id, ",newcompany_id,",CONCAT(a.name,'_',a.user_id),a.date_created,d.user_id
                                                   FROM netcast3_db.group_tb a
                                                   LEFT JOIN netcast3_db.users_tb b ON(a.user_id=b.id AND a.company_id=b.company_id)
                                                   INNER JOIN netcast_simulator.vw_stg_users d
                                                   WHERE b.id is null
                                                   AND d.role=1
                                                   AND a.status_flag=1
                                                   GROUP BY 1,2");
          PREPARE stmt FROM @sql_insert_stg_groups_del;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @sql_insert_stg_groups_del;

          INSERT INTO netcast_simulator.v4_pivot_report(v4_company_id,v3_userid,v3_grpid,num_count,type,v4_grpid,v4_userid,v3_company_id)
          SELECT newcompany_id,user_id,old_group_id,count(1),'group_xfer_to_admin',group_id,new_user_id,old_compan_id
          FROM netcast_db_migrate.stg_groups_del
          GROUP BY 2;

          INSERT INTO  netcast_db_migrate.groups (old_group_id,user_id,company_id,group_name,date_created,new_user_id)
          SELECT old_group_id,user_id,company_id,group_name,date_created,new_user_id
          FROM netcast_db_migrate.stg_groups_del;


          DROP TABLE IF EXISTS netcast_db_migrate.stg_groups_deact;
          CREATE TEMPORARY TABLE IF NOT EXISTS netcast_db_migrate.stg_groups_deact like netcast_db_migrate.groups;
          DROP INDEX `groupname_id` ON  netcast_db_migrate.stg_groups_deact;

          SET @sql_insert_stg_groups_deact = CONCAT("INSERT IGNORE INTO  netcast_db_migrate.stg_groups_deact (old_group_id,user_id,company_id,group_name,date_created,new_user_id)
                                                     SELECT a.id as old_group_id,a.user_id,",newcompany_id,",a.name,a.date_created,b.user_id
                                                     FROM netcast3_db.group_tb a
                                                     LEFT JOIN netcast_simulator.vw_stg_users b ON(a.user_id=b.id)
                                                     WHERE a.status_flag=1
                                                     AND b.status_flag=0
                                                     GROUP BY 1,2");
          PREPARE stmt FROM @sql_insert_stg_groups_deact;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @sql_insert_stg_groups_deact;

          INSERT IGNORE INTO netcast_db_migrate.groups (old_group_id,user_id,company_id,group_name,date_created,new_user_id)
          SELECT old_group_id,user_id,company_id,group_name,date_created,new_user_id
          FROM netcast_db_migrate.stg_groups_deact;

          INSERT INTO netcast_simulator.v4_pivot_report(v4_company_id,v3_userid,v3_grpid,num_count,type,v4_grpid,v4_userid,v3_company_id)
          SELECT a.company_id,b.id,a.old_group_id,count(1),'migrated_groups',a.group_id,a.new_user_id,old_compan_id
          FROM netcast_db_migrate.groups a
          INNER JOIN netcast_simulator.vw_tot_users b ON (a.new_user_id=b.user_id)
          GROUP BY a.new_user_id;

          INSERT INTO netcast_simulator.v3_pivot_report(company_id,user_id,num_count,type)
          SELECT company_id,user_id,sum(mycount) AS num_count,'duplicate_msisdn_userid'
          FROM (SELECT old_compan_id as company_id,a.user_id,(COUNT(1) -1 ) AS mycount,'duplicate_msisdn_userid'
                FROM netcast_db_migrate.stg_contacts_active a
                INNER JOIN netcast_simulator.tmp_msisdn_v3 b  ON(a.msisdn=b.msisdn)
                WHERE  b.brand is not null
                AND b.brand !=''
                GROUP BY a.user_id,a.msisdn
                HAVING COUNT(1) > 1) t
          GROUP BY user_id;

          SET @sql_insert_contacts_active = CONCAT("INSERT IGNORE INTO netcast_db_migrate.contacts (old_contact_id,user_id,company_id,msisdn,email,first_name,
                                                                                                    info1,info2,info3,info4,date_created,network,new_user_id)
                                                    SELECT a.id  AS old_contact_id,a.user_id AS user_id,",newcompany_id,",b.msisdn  AS msisdn,a.email AS email,
                                                           a.name AS first_name,a.age AS info_1,a.gender AS info_2,a.address AS info_3,a.birthday AS info_4,
                                                           a.date_created  AS date_created,b.brand ,c.user_id
                                                    FROM netcast3_db.contacts_tb a
                                                    INNER JOIN netcast_simulator.tmp_msisdn_v3 b ON (a.msisdn_id=b.id)
                                                    INNER JOIN netcast_db_migrate.users c ON(a.user_id=c.old_user_id)
                                                    WHERE a.company_id=",companyid,"
                                                    AND a.status_flag=1
                                                    AND b.brand is not null
                                                    AND b.brand !=''
                                                    AND c.status='ACTIVE'
                                                    GROUP BY a.id,b.id");
          PREPARE stmt FROM @sql_insert_contacts_active;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @sql_insert_contacts_active;
          SELECT 'MIGRATED CONTACTS WITTH ACTIVE USERS, WITH MSISDN, ACTIVE CONTACTS, SUPPORTED BRANDS';

          DROP TABLE IF EXISTS netcast_db_migrate.stg_contacts_disable;
          CREATE TEMPORARY TABLE IF NOT EXISTS netcast_db_migrate.stg_contacts_disable like netcast_db_migrate.contacts;
          DROP INDEX `user_id` ON netcast_db_migrate.stg_contacts_disable;
          SET @sql_insert_stg_contacts_disab = CONCAT("INSERT IGNORE INTO netcast_db_migrate.stg_contacts_disable (old_contact_id,user_id,company_id,msisdn,email,first_name,
                                                                                                                   info1,info2,info3,info4,date_created,network,new_user_id)
                                                       SELECT a.id  AS old_contact_id,a.user_id AS user_id,",newcompany_id,",b.msisdn  AS msisdn,a.email AS email,
                                                              a.name AS first_name,a.age AS info_1,a.gender AS info_2,a.address AS info_3,a.birthday AS info_4,
                                                              a.date_created  AS date_created,b.brand ,c.user_id
                                                       FROM netcast3_db.contacts_tb a
                                                       INNER JOIN netcast_simulator.tmp_msisdn_v3 b ON (a.msisdn_id=b.id)
                                                       INNER JOIN netcast_simulator.vw_stg_users c ON(a.user_id=c.id)
                                                       WHERE a.company_id=",companyid,"
                                                       AND a.status_flag=1
                                                       AND c.status_flag=0
                                                       AND b.brand is not null
                                                       AND b.brand !=''
                                                       GROUP BY a.id,b.id");
          PREPARE stmt FROM @sql_insert_stg_contacts_disab;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @sql_insert_stg_contacts_disab;

          INSERT INTO netcast_simulator.v3_pivot_report(company_id,user_id,num_count,type)
          SELECT company_id,user_id,sum(mycount) AS num_count,'duplicate_msisdn_userid'
          FROM ( SELECT old_compan_id as company_id,a.user_id,COUNT(1) AS mycount,'duplicate_msisdn_userid'
                 FROM netcast_db_migrate.stg_contacts_disable a
                 LEFT JOIN netcast_db_migrate.contacts b  on(a.msisdn=b.msisdn AND a.new_user_id=b.new_user_id)
                 WHERE b.msisdn is not null
                 GROUP BY a.new_user_id
                 having count(1) > 1) t
          GROUP BY user_id;

          INSERT IGNORE INTO netcast_db_migrate.contacts (old_contact_id,user_id,company_id,msisdn,email,first_name,
                                                          info1,info2,info3,info4,date_created,network,new_user_id)
          SELECT old_contact_id,user_id,company_id,msisdn,email,first_name,info1,info2,info3,info4,
                 date_created,network_brand,new_user_id
          FROM netcast_db_migrate.stg_contacts_disable;

          DROP TABLE IF EXISTS netcast_db_migrate.stg_contacts_deact;
          CREATE TEMPORARY TABLE IF NOT EXISTS netcast_db_migrate.stg_contacts_deact like netcast_db_migrate.contacts;
          DROP INDEX `user_id` ON netcast_db_migrate.stg_contacts_deact;

          SET @sql_insert_stg_contacts_deleted =  CONCAT("INSERT IGNORE INTO netcast_db_migrate.stg_contacts_deact (old_contact_id,user_id,company_id,msisdn,email,first_name,
                                                                                                                  info1,info2,info3,info4,date_created,network,new_user_id)
                                                        SELECT a.id  AS old_contact_id,a.user_id AS user_id,",newcompany_id,",b.msisdn  AS msisdn,a.email AS email,a.name AS first_name,
                                                               a.age AS info_1,a.gender AS info_2,a.address AS info_3,a.birthday AS info_4,a.date_created  AS date_created,b.brand ,d.v4_id
                                                        FROM netcast3_db.contacts_tb a
                                                        INNER JOIN netcast_simulator.tmp_msisdn_v3 b ON (a.msisdn_id=b.id)
                                                        INNER JOIN netcast_simulator.vw_complete_user_contacts c ON(a.user_id=c.v3_id)
                                                        CROSS join netcast_simulator.vw_complete_user_contacts d
                                                        WHERE a.company_id=",companyid,"
                                                        AND a.status_flag=1
                                                        AND b.brand is not null AND b.brand !=''
                                                        AND c.status is null
                                                        AND d.role='COMPANY ADMIN'
                                                        AND d.status='ACTIVE'
                                                        GROUP BY a.id,b.id");
          PREPARE stmt FROM @sql_insert_stg_contacts_deleted;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @sql_insert_stg_contacts_deleted;

          INSERT INTO netcast_simulator.v4_pivot_report(num_count,v4_company_id,v3_userid,type,v4_userid,v3_company_id)
          SELECT count(distinct a.msisdn),newcompany_id,a.user_id,
                 'transferred_to_admin',a.new_user_id,old_compan_id
          FROM netcast_db_migrate.stg_contacts_deact a
          LEFT JOIN netcast_db_migrate.contacts b on(a.msisdn=b.msisdn AND a.new_user_id=b.new_user_id)
          WHERE b.msisdn is null
          GROUP BY a.new_user_id,b.msisdn;

          INSERT IGNORE INTO netcast_db_migrate.contacts (old_contact_id,user_id,company_id,msisdn,email,first_name,
                                                          info1,info2,info3,info4,date_created,network,new_user_id)
          SELECT old_contact_id,user_id,company_id,msisdn,email,first_name,
                 info1,info2,info3,info4,date_created,network,new_user_id
          FROM netcast_db_migrate.stg_contacts_deact;

          INSERT INTO netcast_simulator.v3_pivot_report(company_id,user_id,num_count,type)
          SELECT company_id,user_id,sum(mycount) AS num_count,'duplicate_msisdn_userid'
          FROM ( SELECT old_compan_id as company_id,a.user_id,(COUNT(1)-1) AS mycount,'duplicate_msisdn_userid'
          FROM netcast_db_migrate.stg_contacts_deact a
          LEFT JOIN netcast_db_migrate.contacts b on(a.new_user_id=b.new_user_id AND a.msisdn=b.msisdn)
          WHERE b.msisdn is not null
          GROUP BY a.new_user_id,a.msisdn
          having count(1) > 1) t GROUP BY user_id;

          INSERT INTO netcast_simulator.v4_pivot_report(v4_company_id,v3_userid,num_count,type,v4_userid,v3_company_id)
          SELECT a.company_id,b.id,count(distinct a.msisdn),'v4_migrated_contacts',a.new_user_id,old_compan_id
          FROM netcast_db_migrate.contacts a
          INNER JOIN netcast_simulator.vw_stg_users b ON (a.new_user_id=b.user_id)
          WHERE network is not  null
          AND network !=''
          GROUP BY 1,5;

          --RECENTLY EDITED/ADDED BY JOJO
          truncate table netcast_db_migrate.groups_contact_stg;
          
          insert into netcast_db_migrate.groups_contact_stg
          select a1.*, b1.contact_id
          from (
          select b.id gcid,
          b.contact_id gccontact_id,
          b.group_id gcgroup_id,
          b.status_flag gcstatus_flag,
          b.date_created gcdate_created,
          e.group_name,
          e.group_id,
          e.new_user_id user_id,
          concat('639',d.msisdn) as msisdn
          FROM netcast3_db.group_tb c, netcast3_db.contacts_group_tb b, netcast3_db.contacts_tb2 a, netcast3_db.msisdn_tb d, netcast_db_migrate.groups e
                       WHERE a.id = b.contact_id AND c.id = b.group_id AND  a.msisdn_id = d.id AND
                           c.status_flag = 1 AND
                           a.status_flag = 1 and
                           e.group_name =(if (a.user_id <> c.user_id, concat(c.name,'_',a.user_id),  concat(c.name))) and
          
                           b.status_flag = 1
                        group by d.id, c.id  order by 1, c.name, d.msisdn) a1
          left  join
          netcast_db_migrate.contacts b1 on a1.gccontact_id=b1.old_contact_id;
          
          update
          netcast_db_migrate.groups_contact_stg a
          left join  netcast_db_migrate.contacts b on a.msisdn=b.msisdn
          set a.contact_id=b.contact_id where a.contact_id is null ;


          SET @insert_group_contacts = CONCAT("INSERT IGNORE INTO netcast_db_migrate.groups_contacts (company_id,user_id,contact_id,group_id,date_created,new_user_id)
                                             SELECT  ",newcompany_id,",
                                                     b.user_id as user_id,
                                                     a.contact_id as contact_id,
                                                     a.group_id as group_id,
                                                     a.gcdate_created AS date_created,
                                                     a.user_id
                                                     from groups_contact_stg a
                                                     left join netcast_db_migrate.users b on a.user_id=b.user_id ");

          PREPARE stmt FROM @insert_group_contacts;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @insert_group_contacts;

          SET @insert_exclutions = CONCAT("INSERT IGNORE INTO netcast_db_migrate.exclusion_list (company_id,msisdn,date_created)
                                           SELECT ",newcompany_id," ,b.msisdn as msisdn,a.date_created as date_created
                                           FROM netcast3_db.exclusions_tb a
                                           INNER JOIN netcast_simulator.tmp_msisdn_v3 b ON (a.msisdn_id=b.id)
                                           WHERE company_id=",companyid);
          PREPARE stmt FROM @insert_exclutions;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @insert_exclutions;

          SET @insert_web_services = CONCAT("INSERT IGNORE INTO netcast_db_migrate.ws_tokens (ip,token,old_cpmyid,company_id,active_flag,date_created,date_updated)
                                             SELECT  ip,token,company_id,",newcompany_id,",active_flag,date_created,date_updated
                                             FROM netcast3_db.webservices_tb
                                             WHERE company_id=",old_compan_id);
          PREPARE stmt FROM @insert_web_services;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @insert_web_services;

          SET @insert_ftpservices = CONCAT("INSERT IGNORE INTO netcast_db_migrate.sftp_details (ip,folder,old_cpmy_id,company_id,active_flag,date_created,date_updated,email)
                                            SELECT  ip,folder,company_id,",newcompany_id,",active_flag,date_created,date_updated,email
                                            FROM netcast3_db.ftpservices_tb" );
          PREPARE stmt FROM @insert_ftpservices;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @insert_ftpservices;

          SET @insert_company_settings = CONCAT("INSERT INTO company_settings (company_id, setting, data, date_created)
                                                 VALUES (",newcompany_id,", 'secondary_info', '{""info1"":{""value"":"""",""enabled"":0},""info2"":{""value"":"""",""enabled"":0},
                                                         ""info3"":{""value"":"""",""enabled"":0},""info4"":{""value"":"""",""enabled"":0}}', now())");
          PREPARE stmt FROM  @insert_company_settings;
          SELECT @insert_company_settings;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET @insert2_company_settings = CONCAT("INSERT INTO company_settings (company_id, setting, data, date_created)
                                                  VALUES (",newcompany_id,", 'bulk_upload_template', '{""filename"":""1-sample-bulk-upload.csv""}', now())");
          PREPARE stmt FROM  @insert2_company_settings;
          SELECT @insert_company_settings;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET @sql_csv_contacts_no_msisdn = CONCAT("SELECT a.name,a.alias,CONCAT('639',b.msisdn) as msisdn,a.user_id,a.age,a.gender,a.address,a.birthday,a.email,a.date_created
                                                           INTO OUTFILE '/mnt/logs/netcast4_bulk/missing_msisdn_",newcompany_id,".txt'
                                                           FIELDS TERMINATED BY ','
                                                           LINES TERMINATED BY '\n'
                                                    FROM netcast3_db.contacts_tb a
                                                    LEFT JOIN netcast3_db.msisdn_tb b on (a.msisdn_id=b.id)
                                                    WHERE b.id is null
                                                    AND company_id=",old_compan_id);
          PREPARE stmt FROM @sql_csv_contacts_no_msisdn;
          SELECT @sql_csv_contacts_no_msisdn;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET @sql_csv_contacts_unsupported_msisdn = CONCAT("SELECT b.name,b.alias,CONCAT('639',a.msisdn) as msisdn,b.user_id,b.age,b.gender,b.address,b.birthday,b.email,b.date_created
                                                                    INTO OUTFILE '/mnt/logs/netcast4_bulk/unsupprtd_msisdn_",newcompany_id,".txt'
                                                                    FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
                                                             FROM netcast_simulator.tmp_msisdn_v3 a LEFT JOIN netcast3_db.contacts_tb b on (a.id=b.msisdn_id)
                                                             WHERE a.brand IS NULL
                                                             AND company_id=",old_compan_id);
          PREPARE stmt FROM @sql_csv_contacts_unsupported_msisdn;
          SELECT @sql_csv_contacts_unsupported_msisdn;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET @sql_load_contacts = CONCAT("SELECT contact_id,new_user_id,company_id,msisdn,network,network_brand,
                                                  email,first_name,middle_name,last_name,info1,info2,info3,
                                                  info4,upload_type,date_created,date_updated
                                           INTO OUTFILE '/mnt/logs/dmp_files_migrate/contacts_",newcompany_id,".txt'
                                           FIELDS TERMINATED BY '||'
                                           FROM contacts WHERE company_id=",newcompany_id, "
                                           GROUP BY new_user_id,msisdn");
          PREPARE stmt FROM @sql_load_contacts;
          SELECT @sql_load_contacts;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET @sql_load_groups = CONCAT("SELECT group_id,new_user_id,company_id,group_name,group_description,parent_group_id,num_members,date_created,date_updated
                                         INTO OUTFILE '/mnt/logs/dmp_files_migrate/groups_",newcompany_id,".txt'
                                         FIELDS TERMINATED BY '||'
                                         FROM groups");
          PREPARE stmt FROM @sql_load_groups;
          SELECT @sql_load_groups ;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET @sql_load_groups_contacts = CONCAT("SELECT company_id,new_user_id,contact_id,group_id,date_created
                                                   INTO OUTFILE '/mnt/logs/dmp_files_migrate/groups_contacts_",newcompany_id,".txt'
                                                   FIELDS TERMINATED BY '||'
                                                   FROM groups_contacts");
          PREPARE stmt FROM @sql_load_groups_contacts;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @sql_load_groups_contacts;

          SET @sql_load_exclusions_list = CONCAT("SELECT ex_id,company_id,msisdn,remarks,date_created,date_updated
                                                  INTO OUTFILE '/mnt/logs/dmp_files_migrate/exclusion_list_",newcompany_id,".txt'
                                                  FIELDS TERMINATED BY '||'
                                                  FROM exclusion_list");
          PREPARE stmt FROM @sql_load_exclusions_list;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @sql_load_exclusions_list;

          SET @sql_load_company_settings = CONCAT("SELECT company_id,setting,data,date_created,date_updated
                                                   INTO OUTFILE '/mnt/logs/dmp_files_migrate/company_settings_",newcompany_id,".txt'
                                                   FIELDS TERMINATED BY '||'
                                                   FROM company_settings");
          PREPARE stmt FROM @sql_load_company_settings;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
          SELECT @sql_load_company_settings;

          INSERT IGNORE INTO netcast_webtool_prod.qc_v4_migrated_companies (company_id, status, date_created) VALUES(newcompany_id,'PENDING',NOW());
          SET @sql_update=CONCAT("UPDATE netcast_central_prod.companies SET status='ACTIVE' WHERE company_id=",newcompany_id);
          PREPARE stmt_2 from @sql_update;
          -- EXECUTE stmt_2;
          DEALLOCATE PREPARE stmt_2;
          SELECT @sql_update;

          INSERT IGNORE INTO netcast_webtool_prod.qc_v4_migrated_companies (company_id, status, date_created) VALUES(newcompany_id,'PENDING',NOW());
          SET @sql_update=CONCAT("UPDATE netcast_central_prod.companies SET status='ACTIVE' WHERE company_id=",newcompany_id);
          PREPARE stmt_2 from @sql_update;
          -- EXECUTE stmt_2;
          DEALLOCATE PREPARE stmt_2;
          SELECT @sql_update;

          INSERT IGNORE INTO netcast_webtool_prod.qc_v4_migrated_companies (company_id, status, date_created) VALUES(newcompany_id,'PENDING',NOW());
          SET @sql_update=CONCAT("UPDATE netcast_central_prod.companies SET status='ACTIVE' WHERE company_id=",newcompany_id);
          PREPARE stmt_2 from @sql_update;
          -- EXECUTE stmt_2;
          DEALLOCATE PREPARE stmt_2;
          SELECT @sql_update;

--       call sp_migrate_webservices(companyid);  TURN ON DURING MIGRATION

/*         IF EXISTS (SELECT 1 FROM  netcast3_db.ftpservices_tb where company_id=companyid and active_flag=1) THEN
             call netcast_procedures.sp_migrate_ftpservices(companyid);
          END IF; */

          INSERT IGNORE INTO netcast_webtool_prod.qc_v4_migrated_companies (company_id, status, date_created) VALUES(newcompany_id,'PENDING',NOW());
          SET @sql_update=CONCAT("UPDATE netcast_central_prod.companies SET status='ACTIVE' WHERE company_id=",newcompany_id);
          PREPARE stmt_2 from @sql_update;
          -- EXECUTE stmt_2;
          DEALLOCATE PREPARE stmt_2;
          SELECT @sql_update;

 --      call sp_pst_migrate_stmt(newcompany_id);


     END ;

END
