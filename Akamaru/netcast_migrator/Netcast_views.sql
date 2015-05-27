CREATE VIEW vw_v3_user_contacts_dtl AS 
select b.company_id AS company_id,
       a.user_id AS user_id,
       b.email AS email,
       b.status_flag AS status_flag,
       b.role AS role 
from   netcast3_db.contacts_tb a left join netcast3_db.users_tb b on (a.user_id = b.id) 
group by 1,2,3 
union all 
select a.company_id AS company_id,
       b.user_id AS user_id,
       a.email AS email,
       a.status_flag AS status_flag,
       a.role AS role 
from   netcast3_db.users_tb a left join netcast3_db.contacts_tb b on (a.id = b.user_id)
group by 1,2,3 
union all 
select company_id AS company_id,
       id AS id,
       email AS email,
       status_flag AS status_flag,
       role AS role 
from netcast3_db.users_tb;

CREATE VIEW vw_v3_user_cont_groups_dtl AS 
select b.company_id AS company_id,
       b.user_id AS user_id,
       b.email AS email,
       b.status_flag AS status_flag,
       b.role AS role 
from   netcast3_db.group_tb a 
       left join netcast_simulator.vw_v3_user_contacts_dtl b on (a.user_id = b.user_id) 
group by 1,2,3 
union all 
select a.company_id AS company_id,
       a.user_id AS user_id,
       a.email AS email,
       a.status_flag AS status_flag,
       a.role AS role
from   netcast_simulator.vw_v3_user_contacts_dtl a 
       left join netcast3_db.group_tb b on (a.user_id = b.user_id)
group by 1,2,3;

CREATE VIEW vw_v3_stg_users AS 
select company_id AS company_id,
       user_id AS user_id,
       email AS email,
       status_flag AS status_flag,
       role AS role 
from   netcast_simulator.vw_v3_user_cont_groups_dtl 
where  user_id is not null
group by 1,2;

CREATE VIEW vw_v3v4_users_dtl AS 
select a.user_id AS id,
       a.email AS email,
       a.status_flag AS status,
       a.role AS role,
       b.user_id AS user_id 
from   netcast_simulator.vw_v3_stg_users a 
       left join netcast_db_migrate.users b on (a.user_id = b.old_user_id)
group  by 1,2,5 
union all 
select a.old_user_id AS id,
       a.email AS email,
       a.status AS status,
       a.role AS role,
       b.user_id AS user_id 
from   netcast_db_migrate.users a 
       left join netcast_simulator.vw_v3_stg_users b on (a.old_user_id = b.user_id)
group by 1,2,5;

CREATE VIEW vw_tot_users AS 
select id AS id,
       email AS email,
       status AS status,
       role AS role,
       user_id AS user_id 
from netcast_simulator.vw_v3v4_users_dtl 
group by vw_v3v4_users_dtl.id,2;


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



