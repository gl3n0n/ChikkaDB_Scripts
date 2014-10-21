DROP PROCEDURE IF EXISTS sp_generate_hi10_stats;
delimiter //
CREATE PROCEDURE sp_generate_hi10_stats()
begin
    delete from powerapp_dailyrep where tran_dt >= date_sub(curdate(), interval 1 day);
    delete from powerapp_validity_dailyrep where tran_dt >= date_sub(curdate(), interval 1 day);
    delete from powerapp_hourlyrep where tran_dt >= date_sub(curdate(), interval 1 day);

    insert ignore into powerapp_dailyrep (tran_dt, unli_hits, email_hits, social_hits, photo_hits, chat_hits, speed_hits, unli_uniq, email_uniq, social_uniq, photo_uniq, chat_uniq, speed_uniq, total_hits, total_uniq)
    select tran_dt, unli, email, social, photo, chat, speedboost, unli_u, email_u, social_u, photo_u, chat_u, speedboost_u, total_hits, total_uniq
    from   powerapp_plan_summary
    where  tran_dt = date_sub(curdate(), interval 1 day);

    select max(timein)
    into   @vTimeIn
    from   powerapp_concurrent_log
    where  datein = date_sub(curdate(), interval 1 day);

    if (@vTimeIn = '23:59:00') then

       select group_concat(left(timein,5) SEPARATOR ','), num_subs
       into   @vTimeIn, @vNumSubs
       from   powerapp_concurrent_log
       where  datein = date_sub(curdate(), interval 1 day)
       and    num_subs = (select max(num_subs)
                          from   powerapp_concurrent_log
                          where  datein = date_sub(curdate(), interval 1 day)
                         );


       select avg(num_subs)
       into   @vAvgSubs
       from   powerapp_concurrent_log
       where  datein = date_sub(curdate(), interval 1 day);


       select count(1)
       into   @vNumOptout
       from   powerapp_optout_log
       where  datein >= date_sub(curdate(), interval 1 day)
       and    datein < curdate();
    else
       SET @vTimeIn  = '00:00';
       SET @vNumSubs = 0;
       SET @vAvgSubs = 0;
    end if;

    select count(distinct phone) 
    into  @NumUniq30d
    from powerapp_log 
    where datein >= date_sub(curdate(), interval 31 day) 
    and datein < curdate();

    update powerapp_dailyrep
    set    num_optout= IFNULL(@vNumOptout,0),
           concurrent_max_tm= IFNULL(@vTimeIn,'00:00'),
           concurrent_max_subs=IFNULL(@vNumSubs,0),
           concurrent_avg_subs=IFNULL(@vAvgSubs,0),
           num_uniq_30d=IFNULL(@NumUniq30d,0)
    where  tran_dt = date_sub(curdate(), interval 1 day);

    insert ignore into powerapp_validity_dailyrep
          (tran_dt, unli_hits_3, unli_hits_24, unli_uniq_3, unli_uniq_24, email_hits_3, email_hits_24, email_uniq_3, email_uniq_24, chat_hits_3, chat_hits_24, chat_uniq_3, chat_uniq_24, photo_hits_3, photo_hits_24, photo_uniq_3, photo_uniq_24, social_hits_3, social_hits_24, social_uniq_3, social_uniq_24, speed_hits,   speed_uniq, total_hits, total_uniq)
    select tran_dt,      unli_3,      unli_24,    unli_u_3,    unli_u_24,      email_3,      email_24,    email_u_3,    email_u_24,      chat_3,      chat_24,    chat_u_3,    chat_u_24,      photo_3,      photo_24,    photo_u_3,    photo_u_24,      social_3,      social_24,    social_u_3,    social_u_24, speedboost, speedboost_u, total_hits, total_uniq
    from   powerapp_plan_validity_summary
    where  tran_dt = date_sub(curdate(), interval 1 day);

    insert ignore into powerapp_hourlyrep
          (tran_dt, tran_tm, unli_hits_3, unli_hits_24, unli_uniq_3, unli_uniq_24, email_hits_3, email_hits_24, email_uniq_3, email_uniq_24, chat_hits_3, chat_hits_24, chat_uniq_3, chat_uniq_24, photo_hits_3, photo_hits_24, photo_uniq_3, photo_uniq_24, social_hits_3, social_hits_24, social_uniq_3, social_uniq_24, speed_hits,   speed_uniq, total_hits, total_uniq)
    select tran_dt, right(tran_tm,5), unli_3,           unli_24,    unli_u_3,    unli_u_24,      email_3,      email_24,    email_u_3,    email_u_24,      chat_3,      chat_24,    chat_u_3,    chat_u_24,      photo_3,      photo_24,    photo_u_3,    photo_u_24,      social_3,      social_24,    social_u_3,    social_u_24, speedboost, speedboost_u, total_hits, total_uniq
    from   powerapp_plan_summary_hh
    where  tran_dt = date_sub(curdate(), interval 1 day);

    call sp_generate_hi10_brand_stats (date_sub(curdate(), interval 1 day));

END;
//

delimiter ;

GRANT EXECUTE ON PROCEDURE `powerapp_flu`.`sp_generate_hi10_stats` TO 'stats'@'10.11.4.164';


select count(distinct phone) from powerapp_log where datein >= date_sub(curdate(), interval 30 day) and datein < curdate()

select date_sub(curdate(), interval 1 day) tran_dt, count(distinct phone) from (
select phone from powerapp_log where datein >= date_sub(curdate(), interval 31 day) and datein < curdate() group by phone
union
select phone from powerapp_flu.powerapp_log where datein >= date_sub(curdate(), interval 31 day) and datein < curdate() group by phone
) t ;

+------------+-----------------------+
| tran_dt    | count(distinct phone) |
+------------+-----------------------+
| 2014-03-01 |                348400 |
| 2014-03-02 |                355887 |
| 2014-03-03 |                369414 |
+------------+-----------------------+

update powerapp_dailyrep set num_uniq_30d = 348400 where tran_dt = '2014-03-01';
update powerapp_dailyrep set num_uniq_30d = 355887 where tran_dt = '2014-03-02';
update powerapp_dailyrep set num_uniq_30d = 369414 where tran_dt = '2014-03-03';
update powerapp_dailyrep set num_uniq_30d = 382699 where tran_dt = '2014-03-04';



DROP PROCEDURE IF EXISTS sp_regenerate_hi10_stats;
delimiter //
CREATE PROCEDURE sp_regenerate_hi10_stats(p_trandate date)
begin

    delete from powerapp_dailyrep where tran_dt = p_trandate;
    delete from powerapp_validity_dailyrep where tran_dt = p_trandate;
    delete from powerapp_hourlyrep where tran_dt = p_trandate;

    insert ignore into powerapp_dailyrep (tran_dt, unli_hits, email_hits, social_hits, photo_hits, chat_hits, speed_hits, unli_uniq, email_uniq, social_uniq, photo_uniq, chat_uniq, speed_uniq, total_hits, total_uniq)
    select tran_dt, unli, email, social, photo, chat, speedboost, unli_u, email_u, social_u, photo_u, chat_u, speedboost_u, total_hits, total_uniq
    from   powerapp_plan_summary
    where  tran_dt = p_trandate;

    select max(timein)
    into   @vTimeIn
    from   powerapp_concurrent_log
    where  datein = p_trandate;

    if (@vTimeIn = '23:59:00') then

       select group_concat(left(timein,5) SEPARATOR ','), num_subs
       into   @vTimeIn, @vNumSubs
       from   powerapp_concurrent_log
       where  datein = p_trandate
       and    num_subs = (select max(num_subs)
                          from   powerapp_concurrent_log
                          where  datein = p_trandate
                         );


       select avg(num_subs)
       into   @vAvgSubs
       from   powerapp_concurrent_log
       where  datein = p_trandate;


       select count(1)
       into   @vNumOptout
       from   powerapp_optout_log
       where  datein >= p_trandate
       and    datein < date_add(p_trandate, interval 1 day);
    else
       SET @vTimeIn  = '00:00';
       SET @vNumSubs = 0;
       SET @vAvgSubs = 0;
    end if;

    select count(distinct phone) 
    into  @NumUniq30d
    from powerapp_log 
    where datein >= p_trandate
    and datein < date_add(p_trandate, interval 1 day);

    update powerapp_dailyrep
    set    num_optout= IFNULL(@vNumOptout,0),
           concurrent_max_tm= IFNULL(@vTimeIn,'00:00'),
           concurrent_max_subs=IFNULL(@vNumSubs,0),
           concurrent_avg_subs=IFNULL(@vAvgSubs,0),
           num_uniq_30d=IFNULL(@NumUniq30d,0)
    where  tran_dt = p_trandate;

    insert ignore into powerapp_validity_dailyrep
          (tran_dt, unli_hits_3, unli_hits_24, unli_uniq_3, unli_uniq_24, email_hits_3, email_hits_24, email_uniq_3, email_uniq_24, chat_hits_3, chat_hits_24, chat_uniq_3, chat_uniq_24, photo_hits_3, photo_hits_24, photo_uniq_3, photo_uniq_24, social_hits_3, social_hits_24, social_uniq_3, social_uniq_24, speed_hits,   speed_uniq, total_hits, total_uniq)
    select tran_dt,      unli_3,      unli_24,    unli_u_3,    unli_u_24,      email_3,      email_24,    email_u_3,    email_u_24,      chat_3,      chat_24,    chat_u_3,    chat_u_24,      photo_3,      photo_24,    photo_u_3,    photo_u_24,      social_3,      social_24,    social_u_3,    social_u_24, speedboost, speedboost_u, total_hits, total_uniq
    from   powerapp_plan_validity_summary
    where  tran_dt = p_trandate;

    insert ignore into powerapp_hourlyrep
          (tran_dt, tran_tm, unli_hits_3, unli_hits_24, unli_uniq_3, unli_uniq_24, email_hits_3, email_hits_24, email_uniq_3, email_uniq_24, chat_hits_3, chat_hits_24, chat_uniq_3, chat_uniq_24, photo_hits_3, photo_hits_24, photo_uniq_3, photo_uniq_24, social_hits_3, social_hits_24, social_uniq_3, social_uniq_24, speed_hits,   speed_uniq, total_hits, total_uniq)
    select tran_dt, right(tran_tm,5), unli_3,           unli_24,    unli_u_3,    unli_u_24,      email_3,      email_24,    email_u_3,    email_u_24,      chat_3,      chat_24,    chat_u_3,    chat_u_24,      photo_3,      photo_24,    photo_u_3,    photo_u_24,      social_3,      social_24,    social_u_3,    social_u_24, speedboost, speedboost_u, total_hits, total_uniq
    from   powerapp_plan_summary_hh
    where  tran_dt = p_trandate;

    call sp_generate_hi10_brand_stats (p_trandate);

END;
//

delimiter ;
call sp_regenerate_hi10_stats('2014-03-01');
call sp_regenerate_hi10_stats('2014-03-02');
call sp_regenerate_hi10_stats('2014-03-03');
call sp_regenerate_hi10_stats('2014-03-04');
call sp_regenerate_hi10_stats('2014-03-05');
call sp_regenerate_hi10_stats('2014-03-06');
call sp_regenerate_hi10_stats('2014-03-07');
call sp_regenerate_hi10_stats('2014-03-08');
call sp_regenerate_hi10_stats('2014-03-09');



ALTER TABLE powerapp_dailyrep CHARACTER SET utf8 COLLATE utf8_general_ci;
ALTER TABLE powerapp_dailyrep CHARACTER SET latin1 COLLATE latin1_swedish_ci;
