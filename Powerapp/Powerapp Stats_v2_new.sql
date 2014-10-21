DROP TABLE powerapp_brand_dailyrep;
CREATE TABLE powerapp_brand_dailyrep (
 tran_dt date NOT NULL,
 unli_hits_pre int(11) default 0 not null,
 emai_hits_pre int(11) default 0 not null,
 soci_hits_pre int(11) default 0 not null,
 phot_hits_pre int(11) default 0 not null,
 chat_hits_pre int(11) default 0 not null,
 spee_hits_pre int(11) default 0 not null,
 unli_hits_ppd int(11) default 0 not null,
 emai_hits_ppd int(11) default 0 not null,
 soci_hits_ppd int(11) default 0 not null,
 phot_hits_ppd int(11) default 0 not null,
 chat_hits_ppd int(11) default 0 not null,
 spee_hits_ppd int(11) default 0 not null,
 unli_hits_tnt int(11) default 0 not null,
 emai_hits_tnt int(11) default 0 not null,
 soci_hits_tnt int(11) default 0 not null,
 phot_hits_tnt int(11) default 0 not null,
 chat_hits_tnt int(11) default 0 not null,
 spee_hits_tnt int(11) default 0 not null,
 unli_hits_tot int(11) default 0 not null,
 emai_hits_tot int(11) default 0 not null,
 soci_hits_tot int(11) default 0 not null,
 phot_hits_tot int(11) default 0 not null,
 chat_hits_tot int(11) default 0 not null,
 spee_hits_tot int(11) default 0 not null,
 bran_hits_pre int(11) default 0 not null,
 bran_hits_ppd int(11) default 0 not null,
 bran_hits_tnt int(11) default 0 not null,
 bran_hits_all int(11) default 0 not null,
 unli_uniq_pre int(11) default 0 not null,
 emai_uniq_pre int(11) default 0 not null,
 soci_uniq_pre int(11) default 0 not null,
 phot_uniq_pre int(11) default 0 not null,
 chat_uniq_pre int(11) default 0 not null,
 spee_uniq_pre int(11) default 0 not null,
 unli_uniq_ppd int(11) default 0 not null,
 emai_uniq_ppd int(11) default 0 not null,
 soci_uniq_ppd int(11) default 0 not null,
 phot_uniq_ppd int(11) default 0 not null,
 chat_uniq_ppd int(11) default 0 not null,
 spee_uniq_ppd int(11) default 0 not null,
 unli_uniq_tnt int(11) default 0 not null,
 emai_uniq_tnt int(11) default 0 not null,
 soci_uniq_tnt int(11) default 0 not null,
 phot_uniq_tnt int(11) default 0 not null,
 chat_uniq_tnt int(11) default 0 not null,
 spee_uniq_tnt int(11) default 0 not null,
 unli_uniq_tot int(11) default 0 not null,
 emai_uniq_tot int(11) default 0 not null,
 soci_uniq_tot int(11) default 0 not null,
 phot_uniq_tot int(11) default 0 not null,
 chat_uniq_tot int(11) default 0 not null,
 spee_uniq_tot int(11) default 0 not null,
 bran_uniq_pre int(11) default 0 not null,
 bran_uniq_ppd int(11) default 0 not null,
 bran_uniq_tnt int(11) default 0 not null,
 bran_uniq_all int(11) default 0 not null, 
 optout_pre    int(11) default 0 not null,
 optout_ppd    int(11) default 0 not null,
 optout_tnt    int(11) default 0 not null,
 optout_all    int(11) default 0 not null, 
 num_optout    int(11) default 0,
 concurrent_max_tm varchar(100) DEFAULT '00:00:00',
 concurrent_max_subs int(11) DEFAULT '0',
 concurrent_avg_subs decimal(10,2) DEFAULT '0.00',
 num_uniq_30d int(11) DEFAULT '0',
 PRIMARY KEY (tran_dt)
);
 
 
DROP PROCEDURE IF EXISTS sp_generate_hi10_brand_stats;
delimiter //
CREATE PROCEDURE sp_generate_hi10_brand_stats(p_date varchar(10))
begin
   delete from powerapp_brand_dailyrep where tran_dt = p_date;
   select count(1) into @brandIsNull from powerapp_brand_dailyrep where tran_dt = p_date and brand is null;
   if @brandIsNull > 0 then
      call sp_optout_add_brand(p_date);
   end if;
   select count(1) into @unli_hits_pre from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='BUDDY' and plan= 'UNLI'; 
   select count(1) into @emai_hits_pre from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='BUDDY' and plan= 'EMAIL'; 
   select count(1) into @soci_hits_pre from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='BUDDY' and plan= 'SOCIAL'; 
   select count(1) into @phot_hits_pre from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='BUDDY' and plan= 'PHOTO'; 
   select count(1) into @chat_hits_pre from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='BUDDY' and plan= 'CHAT'; 
   select count(1) into @spee_hits_pre from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='BUDDY' and plan= 'SPEEDBOOST'; 
   select count(1) into @unli_hits_ppd from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPD' and plan= 'UNLI'; 
   select count(1) into @emai_hits_ppd from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPD' and plan= 'EMAIL'; 
   select count(1) into @soci_hits_ppd from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPD' and plan= 'SOCIAL'; 
   select count(1) into @phot_hits_ppd from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPD' and plan= 'PHOTO'; 
   select count(1) into @chat_hits_ppd from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPD' and plan= 'CHAT'; 
   select count(1) into @spee_hits_ppd from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPD' and plan= 'SPEEDBOOST'; 
   select count(1) into @unli_hits_tnt from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='TNT' and plan= 'UNLI'; 
   select count(1) into @emai_hits_tnt from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='TNT' and plan= 'EMAIL'; 
   select count(1) into @soci_hits_tnt from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='TNT' and plan= 'SOCIAL'; 
   select count(1) into @phot_hits_tnt from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='TNT' and plan= 'PHOTO'; 
   select count(1) into @chat_hits_tnt from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='TNT' and plan= 'CHAT'; 
   select count(1) into @spee_hits_tnt from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='TNT' and plan= 'SPEEDBOOST'; 
   select count(1) into @unli_hits_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and plan= 'UNLI'; 
   select count(1) into @emai_hits_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and plan= 'EMAIL'; 
   select count(1) into @soci_hits_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and plan= 'SOCIAL'; 
   select count(1) into @phot_hits_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and plan= 'PHOTO'; 
   select count(1) into @chat_hits_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and plan= 'CHAT'; 
   select count(1) into @spee_hits_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and plan= 'SPEEDBOOST'; 
   select count(1) into @bran_hits_pre from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='BUDDY'; 
   select count(1) into @bran_hits_ppd from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPD'; 
   select count(1) into @bran_hits_tnt from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='TNT'; 
   select count(1) into @bran_hits_all from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day);

   select count(distinct phone) into @unli_uniq_pre from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='BUDDY' and plan= 'UNLI'; 
   select count(distinct phone) into @emai_uniq_pre from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='BUDDY' and plan= 'EMAIL'; 
   select count(distinct phone) into @soci_uniq_pre from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='BUDDY' and plan= 'SOCIAL'; 
   select count(distinct phone) into @phot_uniq_pre from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='BUDDY' and plan= 'PHOTO'; 
   select count(distinct phone) into @chat_uniq_pre from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='BUDDY' and plan= 'CHAT'; 
   select count(distinct phone) into @spee_uniq_pre from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='BUDDY' and plan= 'SPEEDBOOST'; 
   select count(distinct phone) into @unli_uniq_ppd from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPD' and plan= 'UNLI'; 
   select count(distinct phone) into @emai_uniq_ppd from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPD' and plan= 'EMAIL'; 
   select count(distinct phone) into @soci_uniq_ppd from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPD' and plan= 'SOCIAL'; 
   select count(distinct phone) into @phot_uniq_ppd from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPD' and plan= 'PHOTO'; 
   select count(distinct phone) into @chat_uniq_ppd from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPD' and plan= 'CHAT'; 
   select count(distinct phone) into @spee_uniq_ppd from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPD' and plan= 'SPEEDBOOST'; 
   select count(distinct phone) into @unli_uniq_tnt from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='TNT' and plan= 'UNLI'; 
   select count(distinct phone) into @emai_uniq_tnt from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='TNT' and plan= 'EMAIL'; 
   select count(distinct phone) into @soci_uniq_tnt from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='TNT' and plan= 'SOCIAL'; 
   select count(distinct phone) into @phot_uniq_tnt from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='TNT' and plan= 'PHOTO'; 
   select count(distinct phone) into @chat_uniq_tnt from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='TNT' and plan= 'CHAT'; 
   select count(distinct phone) into @spee_uniq_tnt from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='TNT' and plan= 'SPEEDBOOST'; 
   select count(distinct phone) into @unli_uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and plan= 'UNLI'; 
   select count(distinct phone) into @emai_uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and plan= 'EMAIL'; 
   select count(distinct phone) into @soci_uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and plan= 'SOCIAL'; 
   select count(distinct phone) into @phot_uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and plan= 'PHOTO'; 
   select count(distinct phone) into @chat_uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and plan= 'CHAT'; 
   select count(distinct phone) into @spee_uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and plan= 'SPEEDBOOST'; 
   select count(distinct phone) into @bran_uniq_pre from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='BUDDY'; 
   select count(distinct phone) into @bran_uniq_ppd from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPD'; 
   select count(distinct phone) into @bran_uniq_tnt from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='TNT'; 
   select count(distinct phone) into @bran_uniq_all from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day);

   select count(1) into @optout_pre from powerapp_optout_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='PREPAID'; 
   select count(1) into @optout_ppd from powerapp_optout_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPAID'; 
   select count(1) into @optout_tnt from powerapp_optout_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='TNT'; 
   select count(1) into @optout_all from powerapp_optout_log where datein >= p_date and datein < date_add(p_date, interval 1 day);

   select num_optout, concurrent_max_tm, concurrent_max_subs, concurrent_avg_subs, num_uniq_30d  
   into   @num_optout, @concurrent_max_tm, @concurrent_max_subs, @concurrent_avg_subs, @num_uniq_30d
   from   powerapp_flu.powerapp_dailyrep
   where  tran_dt = p_date;

   insert ignore into powerapp_brand_dailyrep 
          ( tran_dt, unli_hits_pre, emai_hits_pre, soci_hits_pre, phot_hits_pre, chat_hits_pre, spee_hits_pre, 
            unli_hits_ppd, emai_hits_ppd, soci_hits_ppd, phot_hits_ppd, chat_hits_ppd, spee_hits_ppd, 
            unli_hits_tnt, emai_hits_tnt, soci_hits_tnt, phot_hits_tnt, chat_hits_tnt, spee_hits_tnt, 
            unli_hits_tot, emai_hits_tot, soci_hits_tot, phot_hits_tot, chat_hits_tot, spee_hits_tot, 
            bran_hits_pre, bran_hits_ppd, bran_hits_tnt, bran_hits_all, 
            unli_uniq_pre, emai_uniq_pre, soci_uniq_pre, phot_uniq_pre, chat_uniq_pre, spee_uniq_pre, 
            unli_uniq_ppd, emai_uniq_ppd, soci_uniq_ppd, phot_uniq_ppd, chat_uniq_ppd, spee_uniq_ppd, 
            unli_uniq_tnt, emai_uniq_tnt, soci_uniq_tnt, phot_uniq_tnt, chat_uniq_tnt, spee_uniq_tnt, 
            unli_uniq_tot, emai_uniq_tot, soci_uniq_tot, phot_uniq_tot, chat_uniq_tot, spee_uniq_tot, 
            bran_uniq_pre, bran_uniq_ppd, bran_uniq_tnt, bran_uniq_all, 
            optout_pre,    optout_ppd,    optout_tnt,    optout_all, 
            num_optout, concurrent_max_tm, concurrent_max_subs, concurrent_avg_subs, num_uniq_30d )
   values ( p_date, @unli_hits_pre, @emai_hits_pre, @soci_hits_pre, @phot_hits_pre, @chat_hits_pre, @spee_hits_pre, 
            @unli_hits_ppd, @emai_hits_ppd, @soci_hits_ppd, @phot_hits_ppd, @chat_hits_ppd, @spee_hits_ppd, 
            @unli_hits_tnt, @emai_hits_tnt, @soci_hits_tnt, @phot_hits_tnt, @chat_hits_tnt, @spee_hits_tnt, 
            @unli_hits_tot, @emai_hits_tot, @soci_hits_tot, @phot_hits_tot, @chat_hits_tot, @spee_hits_tot, 
            @bran_hits_pre, @bran_hits_ppd, @bran_hits_tnt, @bran_hits_all, 
            @unli_uniq_pre, @emai_uniq_pre, @soci_uniq_pre, @phot_uniq_pre, @chat_uniq_pre, @spee_uniq_pre, 
            @unli_uniq_ppd, @emai_uniq_ppd, @soci_uniq_ppd, @phot_uniq_ppd, @chat_uniq_ppd, @spee_uniq_ppd, 
            @unli_uniq_tnt, @emai_uniq_tnt, @soci_uniq_tnt, @phot_uniq_tnt, @chat_uniq_tnt, @spee_uniq_tnt, 
            @unli_uniq_tot, @emai_uniq_tot, @soci_uniq_tot, @phot_uniq_tot, @chat_uniq_tot, @spee_uniq_tot, 
            @bran_uniq_pre, @bran_uniq_ppd, @bran_uniq_tnt, @bran_uniq_all, 
            @optout_pre,    @optout_ppd,    @optout_tnt,    @optout_all, 
            @num_optout, IFNULL(@concurrent_max_tm, '00:00'), @concurrent_max_subs, @concurrent_avg_subs, @num_uniq_30d );

END;
//
delimiter ; 

ALTER TABLE powerapp_optout_log ADD brand VARCHAR(10);

DROP PROCEDURE IF EXISTS sp_optout_add_brand;
DELIMITER //
CREATE PROCEDURE sp_optout_add_brand (p_date varchar(10))
BEGIN
   declare vPattern, vBrand Varchar(120);
   declare done_p int default 0;
   declare c_pat cursor for select pattern, sim_type
                            from  mobile_pattern
                            where operator = 'SMART'
                            and sim_type <> 'PREPAID';
   declare continue handler for sqlstate '02000' set done_p = 1;
   
   OPEN c_pat;
   REPEAT
      FETCH c_pat into vPattern, vBrand;
      if not done_p then
         SET @vSql = concat('update powerapp_optout_log set brand=''', vBrand, ''' where datein >=''', p_date, ''' and datein < date_add(''', p_date,''', interval 1 day) and brand is null and phone REGEXP ''', vPattern, '''');
         PREPARE stmt FROM @vSql;
         EXECUTE stmt;
         DEALLOCATE PREPARE stmt;
      end if;
   UNTIL done_p
   END REPEAT;
   -- Update all brand, still null, to PREPAID... 
   UPDATE powerapp_optout_log set brand = 'PREPAID' where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand is null; 
end;
//
DELIMITER ;

CREATE TABLE mobile_pattern (
  operator varchar(15) NOT NULL,
  sim_type varchar(20) NOT NULL,
  pattern varchar(150) NOT NULL,
  notes varchar(100) DEFAULT NULL,
  KEY pattern_idx (pattern)
);

insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)90885[0-9]{5,5}$', 'Smart Infinity 0908 series: 85x xxxx');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)90880[0-2][0-1][0-1][0-9]{2,2}$', 'Smart Infinity 0908 series: 8800000 to 8802119');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)9188[0-9]{6,6}$', 'Smart Infinity 0918 series: 8xx xxxx');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)92888[0-9]{5,5}$', 'Smart Infinity 0928 series: 88x xxxx');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)93999[0-9]{5,5}$', 'Smart Infinity 0939 series: 99x xxxx');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)94988[0-9]{5,5}$', 'Smart Infinity 0949 series: 88x xxxx');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)94999[0-9]{5,5}$', 'Smart Infinity 0949 series: 99x xxxx');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)908880[0-1][0-9]{3,3}$', 'Smart Infinity 0908 series: 8800 - 8801');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)90888020[0-9]{2,2}$', 'Smart Infinity 0908 series: 88020xx');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)908880210[0-9]{1,1}$', 'Smart Infinity 0908 series: 880210x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)908880211[0-9]{1,1}$', 'Smart Infinity 0908 series: 880211x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)91893[0,3-9][0-9]{4,4}$', 'Smart Gold 0918 series: 930x, 933x to 939x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)91894[0-8][0-9]{4,4}$', 'Smart Gold 0918 series: 940x to 948x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)9189[5-6][0-9]{5,5}$', 'Smart Gold 0918 series: 95x to 96x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)9189(0(0[1-9][0-9]{3}|[1-9][0-9]{4})|[12][0-9]{5})$', 'Smart Gold 0918 series: 9001x to 9299x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^6391897([0-3][0-9]{4}|4[0-8][0-9]{3})$', 'Smart Gold 0918 series: 9700x to 9748x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)91897[5-9][0-9]{4,4}$', 'Smart Gold 0918 series: 9750x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)9189[8-9][0-9]{5,5}$', 'Smart Gold 0918 series: 98xx to 9999x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)9209[0,1,5-7,9][0-9]{5,5}$', 'Smart Gold 0920 series: 90-91, 95-97, 99');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)920932[6-9][0-9]{3,3}$', 'Smart Gold 0920 series: 9326x to 9329x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)920938[0-9]{4,4}$', 'Smart Gold 0920 series: 938');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)92094[5-9][0-9]{4,4}$', 'Smart Gold 0920 series: 945-949');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)92855[0-9]{5,5}$', 'Smart Gold 0928 series: 55');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)9399[0-378][0-9]{5,5}$', 'Smart Gold 0939 series: 90x to 93x, 97x to 98x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)999(88|99)[0-9]{5,5}$', 'Smart Gold 0999 series: 88, 99');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)91999[0-9]{5,5}$', 'Smart Gold 0919 series: 99');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)9088[1-4,6,9][0-9]{5,5}$', 'Smart Gold 0908 series: 81-84,86, 89');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)90887[2-9][0-9]{4,4}$', 'Smart Gold 0908 series: 872x to 879');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)90888021[2-9][0-9]{1,1}$', 'Smart Gold 0908 series: 880212x to 880219x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)9088802[2-9][0-9]{2,2}$', 'Smart Gold 0908 series: 8802200 to  8802999 (88022xx to 88029xx)');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)908880[3-9][0-9]{3,3}$', 'Smart Gold 0908 series: 8803x to 8809x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)90888[1-9][0-9]{4,4}$', 'Smart Gold 0908 series: 881x to 889x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)947(89|99)[0-9]{5,5}$', 'Smart Gold 0947 series: 89, 99');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)9479171[0-9]{3}$', 'Smart Gold 0947 series: 9171000 to 1999');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)947917[2-6][0-9]{3}$', 'Smart Gold 0947 series: 9172x to 9176x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)92092[0-8][0-9]{4,4}$', 'Addict Mobile Postpaid 0920 series: 920-928');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)920929[0-8][0-9]{3,3}$', 'Addict Mobile Postpaid 0920 series: 9290-9298');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)92094[0-4][0-9]{4,4}$', 'Addict Mobile Postpaid 0920 series: 940-944');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)94790[0-9]{5}$', 'Smart Bro Postpaid: 947 series: 90x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)92098[0-9]{5,5}$', 'Smart 3G Postpaid 920 series: 98xx');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)9285[0-2][0-9]{5,5}$', 'Smart 3G Postpaid 928 series: 50x to 52x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)94938[0-9]{5}$', 'Smart Bro Postpaid: 949 series: 38x');
insert into mobile_pattern values ('SMART', 'POSTPAID', '^(63|0)94791[0-6][0-9]{4}$', 'Smart Bro Postpaid Micro: 910x to 916x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)908[1-7,9][0-9]{6,6}$', 'Smart Buddy 0908 series: 1-7,9xx xxxx');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)918[2,4-6][0-9]{6,6}$', 'Smart Buddy 0918 series: 2,4-6');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9183[0-2][0-9]{5,5}$', 'Smart Buddy 0918 series: 30x to 32x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)91833[0-6][0-9]{4,4}$', 'Smart Buddy 0918 series: 330x to 336x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)918338[0-9]{4}$', 'Smart Buddy 0918 series: 338xxxx');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)918339[0-9]{4,4}$', 'Smart Buddy 0918 series: 339x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9183[4-7][0-9]{5,5}$', 'Smart Buddy 0918 series: (inner interval)');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)91838[0-9]{5,5}$', 'Smart Buddy 0918 series: 339x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)91839[0-9]{5,5}$', 'Smart Buddy 0918 series: 39x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)919[3,4,6,8][0-9]{6,6}$', 'Smart Buddy 0919 series: 3, 4, 6, 8');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9192[0-1][0-9]{5,5}$', 'Smart Buddy 0919 series: 20x to 21x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)91922[1-9][0-9]{4,4}$', 'Smart Buddy 0919 series: 221x to 229x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9192[3-7,9][0-9]{5,5}$', 'Smart Buddy 0919 series: 23x to 27x, 29x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)91928[0-8][0-9]{4,4}$', 'Smart Buddy 0919 series: 280x to 288x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9195[0-3,5-9][0-9]{5,5}$', 'Smart Buddy 0919 series: 50-53, 55-59');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9199[0,2-8][0-9]{5,5}$', 'Smart Buddy 0919 series: 90, 92-98');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)920[1,4,6][0-9]{6,6}$', 'Smart Buddy 0920 series: 1, 4, 6');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9202[0-6][0-9]{5,5}$', 'Smart Buddy 0920 series: 20x to 26x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9205[0-8][0-9]{5,5}$', 'Smart Buddy 0920 series: 50x to 58x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)92059[0-7][0-9]{4,4}$', 'Smart Buddy 0920 series: 590x to 597x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)920599[0-9]{4,4}$', 'Smart Buddy 0920 series:  599x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9208[0-7,9][0-9]{5,5}$', 'Smart Buddy 0920 series: 80x to 87x, 89x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)920880[0-9]{4,4}$', 'Smart Buddy 0920 series: 880x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9202(7(0(0[5-9][0-9]{2}|[1-9][0-9]{3})|[1-9][0-9]{4})|[89][0-9]{5})$', 'Smart Buddy 0920 series: 27005x to 29999x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)921[2,4-7][0-9]{6,6}$', 'Smart Buddy 0921 series: 2, 4-7');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9213[0-2,4-9][0-9]{5,5}$', 'Smart Buddy 0921 series: 30-32, 34-39');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)92133[0-8][0-9]{4,4}$', 'Smart Buddy 0921 series: 330-338');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)921339[0-8][0-9]{3,3}$', 'Smart Buddy 0921 series: 3390-3398');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9219[5-9][0-9]{5,5}$', 'Smart Buddy 0921 series: 95-99');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)928[2-4,7][0-9]{6,6}$', 'Smart Buddy 0928 series: 2-4, 7');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)92859[0-9]{5,5}$', 'Smart Buddy 0928 series: 59');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9286[0-3,5-9][0-9]{5,5}$', 'Smart Buddy 0928 series: 60-63, 65-69');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9289[0,3-9][0-9]{5,5}$', 'Smart Buddy 0928 series: 90, 93-99');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)929[1-8][0-9]{6,6}$', 'Smart Buddy 0929 series: 1-8');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9299[5-7][0-9]{5,5}$', 'Smart Buddy 0929 series: 95-97');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9391[0-9]{6,6}$', 'Smart Buddy 0939 series: 10x to 19x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)939([2-5][0-9]{6}|6[0-5][0-9]{5})$', 'Smart Buddy 0939 series: 2x to 65x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)939(7[6-9][0-9]{5}|80[0-9]{5})$', 'Smart Buddy 0939 series: 76x to 80x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9399[4-6][0-9]{5}$', 'Smart Buddy 0939 series: 94x to 96x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)947([2-5][0-9]{6}|6[0-4][0-9]{5})$', 'Smart Buddy 0947 series: 2x to 64x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)947(69[0-9]{5}|7[0-9]{6}|8[0-8][0-9]{5})$', 'Smart Buddy 0947 series: 69x to 88x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9479[2-8][0-9]{5}$', 'Smart Buddy 0947 series: 92x to 98x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9491[1-9][0-9]{5,5}$', 'Smart Buddy 0949 series: 11-19');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9493[0-7,9][0-9]{5,5}$', 'Smart Buddy 0949 series: 30x to 37x, 39x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)94950[0-9]{5,5}$', 'Smart Buddy 0949 series: 50x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)949[4,6,7][0-9]{6,6}$', 'Smart Buddy 0949 series: 81-86, 89');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9499[0-8][0-9]{5,5}$', 'Smart Buddy 0949 series: 90x to 98x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)94939[0-9]{5}$', 'Smart Buddy 0949 series: 39x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)999[3-5,7][0-9]{6,6}$', 'Smart Buddy 0999 series: 3-5,7');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9996[5-9][0-9]{5,5}$', 'Smart Buddy 0999 series: 65x to 69x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9998[0-7,9][0-9]{5,5}$', 'Smart Buddy 0999 series: 80-87, 89');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9999[0-8][0-9]{5,5}$', 'Smart Buddy 0999 series: 90x to 98x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9991[5-9][0-9]{5,5}$', 'Smart Buddy 0999 series: 15x to 19x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9985[0-2][0-9]{5}$', 'Postpaid Smart Buddy 0998 series: 50x to 52x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)998[2-4][0-9]{6}$', 'Prepaid Smart Buddy 0998 series: 2x to 4x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9981[5-9][0-9]{5}$', 'Prepaid Smart Buddy 0998 series: 15x to 19x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9989[0-4][0-9]{5}$', 'Prepaid Smart Buddy 0998 series: 90x-94x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)947(1[4-9][0-9]{5}|[2-5][0-9]{6}|6[0-4][0-9]{5})$', 'Smart Buddy 947xx series: 14x to 64x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9281[0-9]{6,6}$', 'Smart Bro Prepaid: 098 series: 1x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)9476[5-8][0-9]{5}$', 'Smart Bro Prepaid: 947 series: 65x to 68x');
insert into mobile_pattern values ('SMART', 'PREPAID', '^(63|0)90800[0-9]{5}$', 'Smart NVS: 90800x');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)907[1-9][0-9]{6,6}$', 'Smart TNT 0907 series: 1-9');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)909[1-9][0-9]{6,6}$', 'Smart TNT 0909 series: 1-9');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)910[1-6,8-9][0-9]{6,6}$', 'Smart TNT 0910 series: 1-6, 8, 9');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)9107[0-8][0-9]{5,5}$', 'Smart TNT 0910 series: 70x to 78x');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)91079([0-8][0-9]{4}|9[0-8][0-9]{3})$', 'Smart TNT 0910 series: 7900x to 7998x');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)912[1-9][0-9]{6,6}$', 'Smart TNT 0912 series: 1-9');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)9187[0-8][0-9]{5,5}$', 'Smart TNT 0918 series: 70x to 78x');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)91879([0-8][0-9]{4}|9[0-8][0-9]{3})$', 'Smart TNT 0918 series: 7900x to 7998x');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)9197[0-9]{6,6}$', 'Smart TNT 0919 series: 7');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)920(3|7)[0-9]{6,6}$', 'Smart TNT 0920 series: 3, 7');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)92088[1-9][0-9]{4,4}$', 'Smart TNT 0920 series: 881-889');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)9285[3,4,6-8][0-9]{5,5}$', 'Smart TNT 0928 series: 53-54, 56-58');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)930[1-9][0-9]{6,6}$', 'Smart TNT 0930 series: 1-9');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)946(1[1-9][0-9]{5}|[2-6][0-9]{6}|7[0-5][0-9]{5})$', 'Smart TNT 0946 series: 11x to 19x, 2x to 45x, 46x to 75x');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)946[89][0-9]{6}$', 'Smart TNT 0946 series: 80x to 99x');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)9481[2-5][0-9]{5}$', 'Smart TNT 0948 series: 12x to 15x');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)9482[0-9]{6}$', 'Smart TNT 0948 series: 2x');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)9483[0-9][1-9][5-9][0-9]{3}$', 'Smart TNT 0948 series: 3015x to 3999x');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)948[4-8][0-9]{6}$', 'Smart TNT 0948 series: 4x to 8x');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)9489[0-4][0-9]{5}$', 'Smart TNT 0948 series: 90x to 94x');
insert into mobile_pattern values ('SMART', 'TNT', '^(63|0)9489[6-9][0-9]{5}$', 'Smart TNT 0948 series: 96x to 99x');
insert into mobile_pattern values ('SMART', 'UNKNOWN', '^(63|0)981[0-9]{6,6}$', 'Smart Link 098 series: 1');
insert into mobile_pattern values ('SMART', 'UNKNOWN', '^(63|0)986[0-9]{6,6}$', 'Smart Link 098 series: 6');
insert into mobile_pattern values ('SMART', 'UNKNOWN', '^(63|0)81(2|3)[0-9]{7,7}$', 'Smart Virtual Number 081 series: 2-3');


call sp_generate_hi10_brand_stats('2014-02-01');
call sp_generate_hi10_brand_stats('2014-02-02');
call sp_generate_hi10_brand_stats('2014-02-03');
call sp_generate_hi10_brand_stats('2014-02-04');
call sp_generate_hi10_brand_stats('2014-02-05');
call sp_generate_hi10_brand_stats('2014-02-06');
call sp_generate_hi10_brand_stats('2014-02-07');
call sp_generate_hi10_brand_stats('2014-02-08');
call sp_generate_hi10_brand_stats('2014-02-09');
call sp_generate_hi10_brand_stats('2014-02-10');
call sp_generate_hi10_brand_stats('2014-02-11');
call sp_generate_hi10_brand_stats('2014-02-12');
call sp_generate_hi10_brand_stats('2014-02-13');
call sp_generate_hi10_brand_stats('2014-02-14');
call sp_generate_hi10_brand_stats('2014-02-15');
call sp_generate_hi10_brand_stats('2014-02-16');
call sp_generate_hi10_brand_stats('2014-02-17');
call sp_generate_hi10_brand_stats('2014-02-18');
call sp_generate_hi10_brand_stats('2014-02-19');
call sp_generate_hi10_brand_stats('2014-02-20');
call sp_generate_hi10_brand_stats('2014-02-21');
call sp_generate_hi10_brand_stats('2014-02-22');
call sp_generate_hi10_brand_stats('2014-02-23');
call sp_generate_hi10_brand_stats('2014-02-24');
call sp_generate_hi10_brand_stats('2014-02-25');
call sp_generate_hi10_brand_stats('2014-02-26');
call sp_generate_hi10_brand_stats('2014-02-27');
call sp_generate_hi10_brand_stats('2014-02-28');

call sp_generate_hi10_brand_stats('2014-02-29');
call sp_generate_hi10_brand_stats('2014-02-30');
call sp_generate_hi10_brand_stats('2014-02-31');
