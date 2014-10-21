create table powerapp_log (
   id int not null auto_increment,
   datein date not null,
   phone varchar(12) not null,
   brand varchar(16),  -- (BUDDY, BDYSU, TNT, POSTPD)
   action varchar(16), -- (NEW, EXTEND)
   plan varchar(16),   -- (UNLI, EMAIL, CHAT, PHOTO, SOCIAL, SPEEDBOOST)
   validity int default 0,
   free enum('true', 'false') default 'true',
   start_tm datetime,
   end_tm datetime,
   source varchar(30), -- (sms_app, sms_user, smartphone, cs)
   primary key (id, datein),
   key datein_idx (datein)
)PARTITION BY LIST (TO_DAYS(datein))
(PARTITION p_20131201 VALUES IN (to_days('2013-12-01')) ENGINE = MyISAM,
 PARTITION p_20131202 VALUES IN (to_days('2013-12-02')) ENGINE = MyISAM,
 PARTITION p_20131203 VALUES IN (to_days('2013-12-03')) ENGINE = MyISAM,
 PARTITION p_20131204 VALUES IN (to_days('2013-12-04')) ENGINE = MyISAM,
 PARTITION p_20131205 VALUES IN (to_days('2013-12-05')) ENGINE = MyISAM,
 PARTITION p_20131206 VALUES IN (to_days('2013-12-06')) ENGINE = MyISAM,
 PARTITION p_20131207 VALUES IN (to_days('2013-12-07')) ENGINE = MyISAM,
 PARTITION p_20131208 VALUES IN (to_days('2013-12-08')) ENGINE = MyISAM,
 PARTITION p_20131209 VALUES IN (to_days('2013-12-09')) ENGINE = MyISAM,
 PARTITION p_20131210 VALUES IN (to_days('2013-12-10')) ENGINE = MyISAM,
 PARTITION p_20131211 VALUES IN (to_days('2013-12-11')) ENGINE = MyISAM,
 PARTITION p_20131212 VALUES IN (to_days('2013-12-12')) ENGINE = MyISAM,
 PARTITION p_20131213 VALUES IN (to_days('2013-12-13')) ENGINE = MyISAM,
 PARTITION p_20131214 VALUES IN (to_days('2013-12-14')) ENGINE = MyISAM,
 PARTITION p_20131215 VALUES IN (to_days('2013-12-15')) ENGINE = MyISAM,
 PARTITION p_20131216 VALUES IN (to_days('2013-12-16')) ENGINE = MyISAM,
 PARTITION p_20131217 VALUES IN (to_days('2013-12-17')) ENGINE = MyISAM,
 PARTITION p_20131218 VALUES IN (to_days('2013-12-18')) ENGINE = MyISAM,
 PARTITION p_20131219 VALUES IN (to_days('2013-12-19')) ENGINE = MyISAM,
 PARTITION p_20131220 VALUES IN (to_days('2013-12-20')) ENGINE = MyISAM,
 PARTITION p_20131221 VALUES IN (to_days('2013-12-21')) ENGINE = MyISAM,
 PARTITION p_20131222 VALUES IN (to_days('2013-12-22')) ENGINE = MyISAM,
 PARTITION p_20131223 VALUES IN (to_days('2013-12-23')) ENGINE = MyISAM,
 PARTITION p_20131224 VALUES IN (to_days('2013-12-24')) ENGINE = MyISAM,
 PARTITION p_20131225 VALUES IN (to_days('2013-12-25')) ENGINE = MyISAM,
 PARTITION p_20131226 VALUES IN (to_days('2013-12-26')) ENGINE = MyISAM,
 PARTITION p_20131227 VALUES IN (to_days('2013-12-27')) ENGINE = MyISAM,
 PARTITION p_20131228 VALUES IN (to_days('2013-12-28')) ENGINE = MyISAM,
 PARTITION p_20131229 VALUES IN (to_days('2013-12-29')) ENGINE = MyISAM,
 PARTITION p_20131230 VALUES IN (to_days('2013-12-30')) ENGINE = MyISAM,
 PARTITION p_20131231 VALUES IN (to_days('2013-12-31')) ENGINE = MyISAM)
 ;


create table powerapp_stg (
   id int not null auto_increment,
   info text not null
   primary key (id)
);


LOAD DATA LOCAL INFILE 