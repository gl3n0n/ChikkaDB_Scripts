delimiter //
CREATE PROCEDURE sp_regenerate_hi10_stats_pisonet(p_trandate date)
begin
    SET @tran_dt = p_trandate;
    SET @tran_nw = date_add(p_trandate, interval 1 day);

    select count(1), count(distinct phone) into @piso_hits, @piso_uniq
    from   powerapp_log 
    where  datein > @tran_dt and datein < @tran_nw and free='false' and plan='PISONET';

    update powerapp_dailyrep
    set    piso_hits=@piso_hits,
           piso_uniq=@piso_uniq
    where  tran_dt = @tran_dt;

    select count(1), count(distinct phone) into @piso_hits_15, @piso_uniq_15
    from  powerapp_log 
    where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PISONET' and validity <= 900;

    update powerapp_validity_dailyrep
    set    piso_hits_15 = @piso_hits_15,
           piso_uniq_15 = @piso_uniq_15
    where  tran_dt = @tran_dt;

   set @vCtr = 0;
   WHILE (@vCtr <= 23) DO

      select concat(lpad(@vCtr, 2, '0'), ':00:00') into @tran_tm;
      select 0, 0 into @piso_hits_15, @piso_uniq_15;

      select count(1), count(distinct phone) into @piso_hits_15, @piso_uniq_15 
      from   powerapp_log 
      where  datein > @tran_dt and datein < @tran_nw 
      and    substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PISONET';

      SET @vCtr = @vCtr + 1;

      update powerapp_hourlyrep
      set    piso_hits_15 = @piso_hits_15,
             piso_uniq_15 = @piso_uniq_15
      where  tran_dt = @tran_dt
      and    tran_tm = @tran_tm;
   END WHILE;

END;
//

select '2014-06-12' into @tran_dt;
call sp_regenerate_hi10_stats_pisonet(@tran_dt);
select tran_dt, piso_hits, piso_uniq from powerapp_dailyrep where tran_dt >= @tran_dt;
select tran_dt, piso_hits_15, piso_uniq_15 from powerapp_validity_dailyrep where tran_dt >= @tran_dt;
select tran_dt, piso_hits_15, piso_uniq_15 from powerapp_hourlyrep where tran_dt >= @tran_dt;

call sp_regenerate_hi10_stats_pisonet('2014-06-22');
