DELIMITER //
DROP PROCEDURE IF EXISTS sp_premigration_req //
CREATE PROCEDURE `sp_premigration_req`(
)
BEGIN
   -- get all contacts per user
   INSERT INTO v3_pivot_report
   SELECT a.company_id,a.user_id,count(1),'total_contacts'
   FROM netcast3_db.contacts_tb a
   LEFT JOIN  netcast3_db.users_tb b ON (a.user_id=b.id AND a.company_id=b.company_id)
   GROUP BY 1,2 ;

   INSERT INTO v3_pivot_report
   SELECT a.company_id,a.user_id,count(1),'active_contacts'
   FROM netcast3_db.contacts_tb a
   LEFT JOIN  netcast3_db.users_tb b ON (a.user_id=b.id AND a.company_id=b.company_id)
   WHERE a.status_flag=1
   GROUP BY 1,2;

   INSERT INTO v3_pivot_report
   SELECT a.company_id,a.user_id,count(1),'deact_contacts'
   FROM netcast3_db.contacts_tb a
   LEFT JOIN  netcast3_db.users_tb b ON (a.user_id=b.id AND a.company_id=b.company_id)
   WHERE a.status_flag=0
   GROUP BY 1,2;

   INSERT INTO v3_pivot_report
   select a.company_id,a.user_id,count(1),'deleted_owner_contacts'
   FROM netcast3_db.contacts_tb a
   LEFT JOIN netcast3_db.users_tb b ON (a.user_id=b.id AND a.company_id=b.company_id)
   WHERE b.id is null
   GROUP BY 1,2 ;

   INSERT INTO v3_pivot_report
   select a.company_id,a.user_id,count(1),'total_group'
   FROM netcast3_db.group_tb a
   LEFT JOIN  netcast3_db.users_tb b ON (a.user_id=b.id AND a.company_id=b.company_id)
   GROUP BY 1,2 ;

   INSERT INTO v3_pivot_report
   SELECT a.company_id,a.user_id,count(1),'active_group'
   FROM netcast3_db.group_tb a
   LEFT JOIN  netcast3_db.users_tb b ON (a.user_id=b.id AND a.company_id=b.company_id)
   WHERE a.status_flag=1 GROUP BY 1,2 ;

   INSERT INTO v3_pivot_report
   SELECT a.company_id,a.user_id,count(1),'deact_group'
   FROM netcast3_db.group_tb a
   LEFT JOIN  netcast3_db.users_tb b ON(a.user_id=b.id AND a.company_id=b.company_id)
   WHERE a.status_flag=0
   GROUP BY 1,2 ;

   INSERT INTO v3_pivot_report
   select a.company_id,a.user_id,count(1),'deleted_owner_group'
   FROM netcast3_db.group_tb a
   LEFT JOIN  netcast3_db.users_tb b ON(a.user_id=b.id AND a.company_id=b.company_id)
   WHERE b.id is null
   GROUP BY 1,2 ;

   INSERT INTO v3_pivot_report
   SELECT a.company_id,a.user_id,count(1),'deleted_contacts_msisdn'
   FROM netcast3_db.contacts_tb a
   LEFT JOIN netcast3_db.msisdn_tb b on (a.msisdn_id=b.id)
   WHERE b.id is null
   GROUP BY a.user_id;

   INSERT INTO v3_pivot_report
   SELECT a.company_id,a.user_id,count(1),'active_contact_wd_msisdn'
   FROM netcast3_db.contacts_tb a
   LEFT JOIN netcast3_db.msisdn_tb b on (a.msisdn_id=b.id)
   WHERE b.id is not null
   GROUP BY a.user_id;

   INSERT INTO v3_pivot_report
   SELECT b.company_id,b.user_id,count(1),'invalid_msisdn_len'
   FROM netcast3_db.msisdn_tb a
   INNER JOIN netcast3_db.contacts_tb b on (a.id=b.msisdn_id)
   WHERE length(a.msisdn) != 9
   GROUP BY b.company_id,b.user_id;

   INSERT INTO v3_pivot_report
   SELECT b.company_id,b.user_id,count(1),'unsupported carrier'
   FROM netcast_simulator.tmp_msisdn_v3 a
   LEFT JOIN netcast3_db.contacts_tb b on (a.id=b.msisdn_id)
   WHERE a.brand IS NULL
   GROUP BY b.company_id,b.user_id ;

   DROP VIEW IF EXISTS netcast_simulator.vw_reps;
   CREATE VIEW netcast_simulator.vw_reps AS
   SELECT
          IFNULL(a.id,'DELETED') as v3id,
          CASE WHEN a.user_id=0 THEN 'DELETED' ELSE a.user_id END as v4id,
          IFNULL(a.email, 'DELETED') as user,
          CASE WHEN a.role=1 THEN 'COMPANY ADMIN' ELSE 'CONTENT PROVIDER' END as 'role',
          CASE WHEN a.status=1 THEN 'ACTIVE' WHEN a.status=0 THEN 'DISABLED' ELSE 'DELETED' END as status,
          MAX(CASE WHEN b.type='total_contacts' THEN b.num_count ELSE 0  END) as total_contacts,
          MAX(CASE WHEN b.type='active_contacts' THEN b.num_count ELSE 0  END) as active_contacts,
          MAX(CASE WHEN b.type='active_contact_wd_msisdn' THEN b.num_count ELSE 0  END) as contacts_with_msisdn,
          MAX(CASE WHEN b.type='deact_contacts' THEN b.num_count ELSE 0  END) as deactivated_contacts,
          MAX(CASE WHEN b.type='Invalid_msisdn_len' THEN b.num_count ELSE 0  END) as msisdn_inv_length,
          MAX(CASE WHEN b.type='unsupported carrier' THEN b.num_count ELSE 0  END) as unsupported_carrier,
          MAX(CASE WHEN b.type='deleted_contacts_msisdn' THEN b.num_count ELSE 0  END) as 'contacts_w/o_msisdn',
          MAX(CASE WHEN b.type='duplicate_msisdn_userid' THEN b.num_count ELSE 0  END) as duplicat_msisdn_userid,
          MAX(CASE WHEN c.type='transferred_to_admin' THEN c.num_count ELSE 0  END) as adm_transferred_contacts,
          MAX(CASE WHEN c.type='v4_migrated_contacts' THEN c.num_count ELSE 0  END) as v4_migrated_contacts,
          MAX(CASE WHEN b.type='total_group' THEN b.num_count ELSE 0  END) as v3_total_group,
          MAX(CASE WHEN b.type='active_group' THEN b.num_count ELSE 0  END) as active_group,
          MAX(CASE WHEN b.type='deact_group' THEN b.num_count ELSE 0  END) as deactivated_group,
          MAX(CASE WHEN c.type='group_xfer_to_admin' THEN c.num_count ELSE 0  END) as adm_transferred_groups,
          MAX(CASE WHEN c.type='split_groups' THEN c.num_count ELSE 0  END) as split_groups,
          MAX(CASE WHEN c.type='migrated_groups' THEN c.num_count ELSE 0  END) as v4_migrated_groups
   FROM netcast_simulator.vw_tot_users a
   LEFT JOIN netcast_simulator.v3_pivot_report b on(a.id=b.user_id)
   LEFT JOIN netcast_simulator.v4_pivot_report c on(a.id=c.v3_userid)
   GROUP BY 1,3;

END
//

DELIMITER ;
