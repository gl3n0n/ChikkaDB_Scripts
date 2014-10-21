drop procedure sp_generate_bcast_stats;
delimiter //
create procedure sp_generate_bcast_stats(p_trandate date)
begin
   select * from powerapp_bcast_stats where tran_dt=p_trandate;
   delete from powerapp_bcast_stats where tran_dt=p_trandate;
   drop temporary table if exists tmp_buys;
   create temporary table tmp_buys (phone varchar(12) not null, brand varchar(12) not null, 
                                    plan varchar(20) not null, hits int(11) default 0 not null, 
                                    primary key (phone, brand, plan));
   insert into tmp_buys (phone, brand, plan, hits)
   select phone, brand, plan, count(1) hits 
   from   powerapp_log 
   where  datein >= concat(p_trandate, ' 08:00:00') and datein <= concat(p_trandate, ' 23:59:59')
   group  by phone, brand, plan;
   
   SET @vSql = concat('insert into powerapp_bcast_stats (tran_dt, brand, plan, hits, uniq, source)
                       select ''', p_trandate, ''' Date, b.brand, b.plan, sum(b.hits) hits, count(distinct a.phone) uniq, max(source) source
                       from   tmp_plan_users_', date_format(p_trandate, '%m%d'), ' a, tmp_buys b 
                       where  a.phone = b.phone
                       and    a.brand=b.brand
                       and    a.plan=b.plan
                       group  by 1,2,3'
                     );
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;

   SET @vSql = concat('update powerapp_bcast_stats set no_mins=(select count(1) 
                       from tmp_plan_users_', date_format(p_trandate, '%m%d'), ' a 
                       where a.brand=powerapp_bcast_stats.brand 
                       and a.plan=powerapp_bcast_stats.plan)
                       where  tran_dt = ''', p_trandate, ''''
                     ); 
   PREPARE stmt FROM @vSql;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
end;
//
delimiter ;
