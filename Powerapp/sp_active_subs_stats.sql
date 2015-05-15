delimiter //
CREATE PROCEDURE sp_active_subs_stats(p_trandate date)
begin
    SET @tran_dt = p_trandate;
    SET @tran_nw = date_add(p_trandate, interval 1 day);
    if @tran_dt = last_day(@tran_dt) then
       select count(distinct phone)
       into  @NumActive30d_tnt
       from powerapp_log
       where left(datein,7) = left(@tran_dt, 7)
       and   brand = 'TNT'
       and   free='false';
       select count(distinct phone)
       into  @NumActive30d_buddy
       from powerapp_log
       where left(datein,7) = left(@tran_dt, 7)
       and   brand = 'BUDDY'
       and   free='false';
       select count(distinct phone)
       into  @NumActive30d_postpd
       from powerapp_log
       where left(datein,7) = left(@tran_dt, 7)
       and   brand = 'POSTPD'
       and   free='false';
    else
       select count(distinct phone)
       into  @NumActive30d_tnt
       from powerapp_log
       where datein >= date_sub(@tran_dt, interval 30 day)
       and datein < @tran_nw
       and   brand = 'TNT'
       and   free='false';
       select count(distinct phone)
       into  @NumActive30d_buddy
       from powerapp_log
       where datein >= date_sub(@tran_dt, interval 30 day)
       and datein < @tran_nw
       and   brand = 'BUDDY'
       and   free='false';
       select count(distinct phone)
       into  @NumActive30d_postpd
       from powerapp_log
       where datein >= date_sub(@tran_dt, interval 30 day)
       and datein < @tran_nw
       and   brand = 'POSTPD'
       and   free='false';
    end if;
    SET @NumActive30d = IFNULL(@NumActive30d_tnt,0) + IFNULL(@NumActive30d_buddy,0) + IFNULL(@NumActive30d_postpd,0) ;

    update powerapp_dailyrep
    set    num_actv_30d=IFNULL(@NumActive30d,0),
           num_actv_30d_tnt=IFNULL(@NumActive30d_tnt,0),
           num_actv_30d_buddy=IFNULL(@NumActive30d_buddy,0),
           num_actv_30d_postpd=IFNULL(@NumActive30d_postpd,0)
    where  tran_dt = @tran_dt;
END;
//
delimiter ;


call sp_active_subs_stats ('2015-01-01');
call sp_active_subs_stats ('2015-01-02');
call sp_active_subs_stats ('2015-01-03');
call sp_active_subs_stats ('2015-01-04');
call sp_active_subs_stats ('2015-01-05');
call sp_active_subs_stats ('2015-01-06');
call sp_active_subs_stats ('2015-01-07');
call sp_active_subs_stats ('2015-01-08');
call sp_active_subs_stats ('2015-01-09');
call sp_active_subs_stats ('2015-01-10');
call sp_active_subs_stats ('2015-01-11');
call sp_active_subs_stats ('2015-01-12');
call sp_active_subs_stats ('2015-01-13');
call sp_active_subs_stats ('2015-01-14');
call sp_active_subs_stats ('2015-01-15');
call sp_active_subs_stats ('2015-01-16');
call sp_active_subs_stats ('2015-01-17');
call sp_active_subs_stats ('2015-01-18');
call sp_active_subs_stats ('2015-01-19');
call sp_active_subs_stats ('2015-01-20');
call sp_active_subs_stats ('2015-01-21');
call sp_active_subs_stats ('2015-01-22');
call sp_active_subs_stats ('2015-01-23');
call sp_active_subs_stats ('2015-01-24');
call sp_active_subs_stats ('2015-01-25');
call sp_active_subs_stats ('2015-01-26');
call sp_active_subs_stats ('2015-01-27');
call sp_active_subs_stats ('2015-01-28');
call sp_active_subs_stats ('2015-01-29');
call sp_active_subs_stats ('2015-01-30');
call sp_active_subs_stats ('2015-01-31');
call sp_active_subs_stats ('2015-02-01');
call sp_active_subs_stats ('2015-02-02');
call sp_active_subs_stats ('2015-02-03');
call sp_active_subs_stats ('2015-02-04');
call sp_active_subs_stats ('2015-02-05');
call sp_active_subs_stats ('2015-02-06');
call sp_active_subs_stats ('2015-02-07');
call sp_active_subs_stats ('2015-02-08');
call sp_active_subs_stats ('2015-02-09');
call sp_active_subs_stats ('2015-02-10');
call sp_active_subs_stats ('2015-02-11');
call sp_active_subs_stats ('2015-02-12');
call sp_active_subs_stats ('2015-02-13');
call sp_active_subs_stats ('2015-02-14');
call sp_active_subs_stats ('2015-02-15');
call sp_active_subs_stats ('2015-02-16');
call sp_active_subs_stats ('2015-02-17');
call sp_active_subs_stats ('2015-02-18');
call sp_active_subs_stats ('2015-02-19');
call sp_active_subs_stats ('2015-02-20');
call sp_active_subs_stats ('2015-02-21');
call sp_active_subs_stats ('2015-02-22');
call sp_active_subs_stats ('2015-02-23');
call sp_active_subs_stats ('2015-02-24');
call sp_active_subs_stats ('2015-02-25');
call sp_active_subs_stats ('2015-02-26');
call sp_active_subs_stats ('2015-02-27');
call sp_active_subs_stats ('2015-02-28');
call sp_active_subs_stats ('2015-03-01');
call sp_active_subs_stats ('2015-03-02');
call sp_active_subs_stats ('2015-03-03');
call sp_active_subs_stats ('2015-03-04');
call sp_active_subs_stats ('2015-03-05');
call sp_active_subs_stats ('2015-03-06');
call sp_active_subs_stats ('2015-03-07');
call sp_active_subs_stats ('2015-03-08');
call sp_active_subs_stats ('2015-03-09');
call sp_active_subs_stats ('2015-03-10');
call sp_active_subs_stats ('2015-03-11');
call sp_active_subs_stats ('2015-03-12');
call sp_active_subs_stats ('2015-03-13');
call sp_active_subs_stats ('2015-03-14');
call sp_active_subs_stats ('2015-03-15');
call sp_active_subs_stats ('2015-03-16');
call sp_active_subs_stats ('2015-03-17');
call sp_active_subs_stats ('2015-03-18');
call sp_active_subs_stats ('2015-03-19');
call sp_active_subs_stats ('2015-03-20');
call sp_active_subs_stats ('2015-03-21');
call sp_active_subs_stats ('2015-03-22');
call sp_active_subs_stats ('2015-03-23');
call sp_active_subs_stats ('2015-03-24');
call sp_active_subs_stats ('2015-03-25');
call sp_active_subs_stats ('2015-03-26');
call sp_active_subs_stats ('2015-03-27');
call sp_active_subs_stats ('2015-03-28');
call sp_active_subs_stats ('2015-03-29');
call sp_active_subs_stats ('2015-03-30');
call sp_active_subs_stats ('2015-03-31');
call sp_active_subs_stats ('2015-04-01');
call sp_active_subs_stats ('2015-04-02');
call sp_active_subs_stats ('2015-04-03');
call sp_active_subs_stats ('2015-04-04');
call sp_active_subs_stats ('2015-04-05');
call sp_active_subs_stats ('2015-04-06');
call sp_active_subs_stats ('2015-04-07');
call sp_active_subs_stats ('2015-04-08');
call sp_active_subs_stats ('2015-04-09');
call sp_active_subs_stats ('2015-04-10');
call sp_active_subs_stats ('2015-04-11');
call sp_active_subs_stats ('2015-04-12');
call sp_active_subs_stats ('2015-04-13');
call sp_active_subs_stats ('2015-04-14');
call sp_active_subs_stats ('2015-04-15');
call sp_active_subs_stats ('2015-04-16');
call sp_active_subs_stats ('2015-04-17');
call sp_active_subs_stats ('2015-04-18');
call sp_active_subs_stats ('2015-04-19');
call sp_active_subs_stats ('2015-04-20');
call sp_active_subs_stats ('2015-04-21');

