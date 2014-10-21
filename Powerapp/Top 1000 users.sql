drop temporary table tmp_last_week_buyers ; 
drop temporary table tmp_last_week_plans ; 

create temporary table tmp_last_week_buyers (phone varchar(12) not null, primary key (phone));
insert into tmp_last_week_buyers select phone from powerapp_log a where datein >= date_sub(curdate(), interval 7 day) and not exists (select 1 from powerapp_optout_log b where b.phone = a.phone) group by phone;

create temporary table tmp_last_week_plans (phone varchar(12) not null, hits int(11), plan varchar(20), datein datetime, dateout datetime, key phone_idx(phone));
insert into tmp_last_week_plans select a.phone, count(1) hits, a.plan, min(a.datein) datein, max(a.datein) dateout from powerapp_log a, tmp_last_week_buyers c where c.phone = a.phone and a.source = 'smartphone' group by a.phone, a.plan ; 
insert into tmp_last_week_plans select a.phone, count(1) hits, a.plan, min(a.datein) datein, max(a.datein) dateout from powerapp_log a, tmp_last_week_buyers d where d.phone = a.phone and a.source = 'sms_app' group by a.phone, a.plan;

select phone, sum(hits) hits, min(datein) datein, group_concat(concat(plan, '=', hits, '=', date_format(datein, '%Y-%m-%d %H:%i'), ' to ',date_format(dateout, '%Y-%m-%d %H:%i')) order by plan separator '^') plans from (
select phone, sum(hits) hits, plan, min(datein) datein, max(dateout) dateout from (
select phone, hits, plan, datein, dateout from tmp_last_week_plans
) s group by phone, plan 
) t group by phone
order by hits desc limit 1000;


select * from tmp_top_users order by hits desc;
