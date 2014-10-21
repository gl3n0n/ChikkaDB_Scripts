
select left(last_update, 10) date, count(1) from ctm_accounts a where exists (select 1 from migrate_user b where a.ctm_accnt=b.v6_username) group by 1;

+------------+----------+
| Date       | Migrated |
+------------+----------+
| 2014-01-29 |    49695 |
| 2014-01-30 |    43994 |
| 2014-01-31 |    31652 |
| 2014-02-01 |    24044 |
| 2014-02-02 |    25806 |
| 2014-02-03 |    22582 |
| 2014-02-04 |    18183 |
| 2014-02-05 |    15542 |
| 2014-02-06 |    14832 |
| 2014-02-07 |     4540 |
+------------+----------+
10 rows in set (5.26 sec)




select d.sn_provider, count(1) from ctm_sns_link c, sns_id_lookup d where c.sn_provider_id=d.id and exists (select 1 from ctm_accounts a,  migrate_user b where a.ctm_accnt=b.v6_username and a.ctm_accnt=c.ctm_accnt) group by 1;

+----------------+-------------+----------+
| sn_provider_id | sn_provider | count(1) |
+----------------+-------------+----------+
|              1 | facebook    |    32402 |
|              2 | linkedin    |      346 |
|              3 | googleplus  |     4743 |
|              4 | twitter     |     1941 |
+----------------+-------------+----------+
4 rows in set (2.48 sec)      4 rows in set (0.00 sec)

select count(1) ALL_cnt from ctm_accounts a where exists (select 1 from migrate_user b where a.ctm_accnt=b.v6_username);
select count(1) PC_cnt from ctm_accounts a where msisdn is null and exists (select 1 from migrate_user b where a.ctm_accnt=b.v6_username);
+----------+
|   PC_cnt |
+----------+
|    53235 |
+----------+
1 row in set (1.74 sec)

create table tmp_migrated_msisdn (ctm_accnt varchar(12), msisdn varchar(19), reg_date date, key msisdn_idx(msisdn));
insert into tmp_migrated_msisdn select ctm_accnt, msisdn, left(last_update,10) from a where exists (select 1 from migrate_user b where a.ctm_accnt=b.v6_username)

select b.operator, b.sim_type, count(a.msisdn) Cnt 
from tmp_migrated_msisdn a left join mobile_pattern b on (a.msisdn regexp b.pattern)
group by 1,2;

+----------------+----------+--------+
| operator       | sim_type | Cnt    |
+----------------+----------+--------+
| GLOBE          | POSTPAID |   5196 |
| GLOBE          | PREPAID  |  58162 |
| GLOBE          | TM       |  15538 |
| SMART          | POSTPAID |   1357 |
| SMART          | PREPAID  |  76452 |
| SMART          | TNT      |  23205 |
| SUN            | POSTPAID |   1272 |
| SUN            | PREPAID  |  12150 |
| PC ACCOUNT     | ALL      |  53235 |
+----------------+----------+--------+

+----------------+--------+
| country        | Cnt    |
+----------------+--------+
| AUSTRALIA      |     19 |
| CHINA          |      6 |
| HONG KONG      |      8 |
| JAPAN          |    110 |
| MALAYSIA       |      2 |
| SAUDI ARABIA   |     68 |
| SINGAPORE      |     69 |
| UAE            |    108 |
| UNITED KINGDOM |     61 |
| UNITED STATES  |    598 |
+----------------+--------+

+-------------+----------+
| sn_provider | count(1) |
+-------------+----------+
| facebook    |    32402 |
| linkedin    |      346 |
| googleplus  |     4743 |
| twitter     |     1941 |
+-------------+----------+
