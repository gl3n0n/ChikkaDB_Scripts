
drop table if exists tmp_reg;
create table tmp_reg as select phone, max(datein) datein, count(1) no_avail from powerapp_log group by phone;
alter table tmp_reg add key (phone);

drop table if exists tmp_opt;
create table tmp_opt as select phone, max(datein) datein, count(1) no_optout from powerapp_optout_log group by phone;
alter table tmp_opt add key (phone);


truncate table tmp_reg;
truncate table tmp_opt;
insert into tmp_reg select phone, max(datein) datein, count(1) no_avail from powerapp_log group by phone;
insert into tmp_opt select phone, max(datein) datein, count(1) no_optout from powerapp_optout_log group by phone;

select sum(OutNoReg) 'No. of Optout and did not register again', 
       sum(OutNoReg_1x) 'Opted-out 1x',     
       sum(OutNoReg_2x) 'Opted-out 2x',     
       sum(OutNoReg_3x) 'Opted-out >2x',  
       sum(OutReg) 'No. of Optout but registers again', 
       sum(OutReg_1x) 'Opted-out 1x', 
       sum(OutReg_2x) 'Opted-out 2x', 
       sum(OutReg_3x) 'Opted-out >2x'
from ( 
select count(1) OutNoReg, 0 OutNoReg_1x, 0 OutNoReg_2x, 0 OutNoReg_3x, 0 OutReg, 0 OutReg_1x, 0 OutReg_2x, 0 OutReg_3x  from tmp_reg a, tmp_opt b where a.phone = b.phone and  a.datein < b.datein union
select 0 OutNoReg, count(1) OutNoReg_1x, 0 OutNoReg_2x, 0 OutNoReg_3x, 0 OutReg, 0 OutReg_1x, 0 OutReg_2x, 0 OutReg_3x  from tmp_reg a, tmp_opt b where a.phone = b.phone and  a.datein < b.datein and b.no_optout = 1 union
select 0 OutNoReg, 0 OutNoReg_1x, count(1) OutNoReg_2x, 0 OutNoReg_3x, 0 OutReg, 0 OutReg_1x, 0 OutReg_2x, 0 OutReg_3x  from tmp_reg a, tmp_opt b where a.phone = b.phone and  a.datein < b.datein and b.no_optout = 2 union
select 0 OutNoReg, 0 OutNoReg_1x, 0 OutNoReg_2x, count(1) OutNoReg_3x, 0 OutReg, 0 OutReg_1x, 0 OutReg_2x, 0 OutReg_3x  from tmp_reg a, tmp_opt b where a.phone = b.phone and  a.datein < b.datein and b.no_optout > 2 union
select 0 OutNoReg, 0 OutNoReg_1x, 0 OutNoReg_2x, 0 OutNoReg_3x, count(1) OutReg, 0 OutReg_1x, 0 OutReg_2x, 0 OutReg_3x  from tmp_reg a, tmp_opt b where a.phone = b.phone and  a.datein > b.datein union
select 0 OutNoReg, 0 OutNoReg_1x, 0 OutNoReg_2x, 0 OutNoReg_3x, 0 OutReg, count(1) OutReg_1x, 0 OutReg_2x, 0 OutReg_3x  from tmp_reg a, tmp_opt b where a.phone = b.phone and  a.datein > b.datein and b.no_optout = 1 union
select 0 OutNoReg, 0 OutNoReg_1x, 0 OutNoReg_2x, 0 OutNoReg_3x, 0 OutReg, 0 OutReg_1x, count(1) OutReg_2x, 0 OutReg_3x  from tmp_reg a, tmp_opt b where a.phone = b.phone and  a.datein > b.datein and b.no_optout = 2 union
select 0 OutNoReg, 0 OutNoReg_1x, 0 OutNoReg_2x, 0 OutNoReg_3x, 0 OutReg, 0 OutReg_1x, 0 OutReg_2x, count(1) OutReg_3x  from tmp_reg a, tmp_opt b where a.phone = b.phone and  a.datein > b.datein and b.no_optout > 2
) t1\G

