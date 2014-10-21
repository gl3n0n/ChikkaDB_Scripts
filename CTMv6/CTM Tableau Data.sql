create table tmp_sms_out as select * from sms_out where datesent='2014-09-01' limit 0;
-- truncate table tmp_sms_out;
select '2014-09-06' into @trandt;
insert into tmp_sms_out select * from sms_out where datesent = @trandt and operator='GLOBE' and status in ('DELIVERED', 'CHARGED') order by rand() limit 10000;
insert into tmp_sms_out select * from sms_out where datesent = @trandt and operator='SMART' and status in ('DELIVERED', 'CHARGED') order by rand() limit 10000;
insert into tmp_sms_out select * from sms_out where datesent = @trandt and operator='SUN' and status in ('DELIVERED', 'CHARGED') order by rand() limit 10000;

create table tmp_daily_login as select * from ctmv6_daily_logins where tx_date='2014-09-01' limit 0;
-- truncate table tmp_daily_login;
select '2014-09-06' into @trandt;
insert into tmp_daily_login select * from ctmv6_daily_logins where tx_date=@trandt and src='ios' limit 10000;
insert into tmp_daily_login select * from ctmv6_daily_logins where tx_date=@trandt and src='android' limit 10000;
insert into tmp_daily_login select * from ctmv6_daily_logins where tx_date=@trandt and src='web' limit 10000;
insert into tmp_daily_login select * from ctmv6_daily_logins where tx_date=@trandt and carrier='GLOBE' limit 10000;
insert into tmp_daily_login select * from ctmv6_daily_logins where tx_date=@trandt and carrier='SMART' limit 10000;
insert into tmp_daily_login select * from ctmv6_daily_logins where tx_date=@trandt and carrier='SUN' limit 10000;

alter table tmp_daily_login add key (phone);
create table tmp_ctm_account as select * from  ctmv6.ctm_accounts a where exists (select 1 from tmp_daily_login b where b.phone=b.ctm_accnt) 
create table tmp_ctm_account as select * from  ctmv6.ctm_accounts a where exists (select 1 from tmp_daily_login b where b.phone=b.ctm_accnt) 


mysqldump -uroot -p --socket=/mnt/cartman/s_cart_3320.sock --port=3320 ctmv6_stats tmp_sms_out  tmp_daily_login tmp_ctm_account > /tmp/ctmv6_tableau.sql

