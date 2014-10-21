create table powerapp_price_list (
  eff_dt    datetime not null,
  plan      varchar(20) not null,
  brand     varchar(20) not null,
  validity  int(11) not null,
  price     int(11) default 0 not null,
  primary key (eff_dt, plan, brand, validity)
);

create table powerapp_stats_dtl (
  tran_dt  date not null,
  plan     varchar(20) not null,
  brand    varchar(20) not null,
  validity int(11) not null,
  hits     int(11) default 0 not null,
  uniq     int(11) default 0 not null,
  primary key (tran_dt, plan, brand, validity)
);


insert into powerapp_stats_dtl select left(datein,10) date, plan, brand, validity, count(1), count(distinct phone) uniq 
from powerapp_log 
where datein >= '2014-08-01' and free='false' group by 1,2,3,4;


insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('BACKTOSCHOOL'),  87300, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('BESTEVER    '),  86400, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('CHAT        '),  10800, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('CHAT        '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('CLASHOFCLANS'), 172800, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('EMAIL       '),  10800, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('EMAIL       '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('FACEBOOK    '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('FREE_SOCIAL '),  86400, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('LINE        '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('PHOTO       '),  10800, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('PHOTO       '),  86400, 20);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('PISONET     '),    600, 1 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('SNAPCHAT    '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('SOCIAL      '),  10800, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('SOCIAL      '),  86400, 20);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('SPEEDBOOST  '),    900, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('TUMBLR      '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('UNLI        '),  10800, 15);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('UNLI        '),  86400, 20);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('WAZE        '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('WECHAT      '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('WIKIPEDIA   '),  86400, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('BUDDY '), rtrim('YOUTUBE     '),   1800, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('BACKTOSCHOOL'),  87300, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('BESTEVER    '),  86400, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('CHAT        '),  10800, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('CHAT        '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('CLASHOFCLANS'), 172800, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('EMAIL       '),  10800, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('EMAIL       '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('FACEBOOK    '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('LINE        '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('PHOTO       '),  10800, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('PHOTO       '),  86400, 20);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('PISONET     '),    600, 1 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('SNAPCHAT    '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('SOCIAL      '),  10800, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('SOCIAL      '),  86400, 20);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('SPEEDBOOST  '),    900, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('TUMBLR      '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('UNLI        '),  10800, 15);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('UNLI        '),  86400, 30);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('WAZE        '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('WECHAT      '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('WIKIPEDIA   '),  86400, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('POSTPD'), rtrim('YOUTUBE     '),   1800, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('BACKTOSCHOOL'),  87300, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('BESTEVER    '),  86400, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('CHAT        '),  10800, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('CHAT        '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('CLASHOFCLANS'), 172800, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('EMAIL       '),  10800, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('EMAIL       '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('FACEBOOK    '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('FREE_SOCIAL '),  86400, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('LINE        '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('PHOTO       '),  10800, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('PHOTO       '),  86400, 20);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('PISONET     '),    600, 1 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('SNAPCHAT    '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('SOCIAL      '),  10800, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('SOCIAL      '),  86400, 20);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('SPEEDBOOST  '),    900, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('TUMBLR      '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('UNLI        '),  10800, 15);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('UNLI        '),  86400, 30);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('WAZE        '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('WECHAT      '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('WIKIPEDIA   '),  86400, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-03 12:00:00', rtrim('TNT '), rtrim('YOUTUBE     '),   1800, 0 );



insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('BACKTOSCHOOL'),  87300, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('BESTEVER    '),  86400, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('CHAT        '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('CLASHOFCLANS'), 172800, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('EMAIL       '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('FACEBOOK    '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('FREE_SOCIAL '),  86400, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('LINE        '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('PHOTO       '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('PISONET     '),    600, 1 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('SNAPCHAT    '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('SOCIAL      '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('SPEEDBOOST  '),    900, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('TUMBLR      '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('UNLI        '),  86400, 20);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('WAZE        '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('WECHAT      '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('WIKIPEDIA   '),  86400, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('BUDDY '), rtrim('YOUTUBE     '),   1800, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('BACKTOSCHOOL'),  87300, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('BESTEVER    '),  86400, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('CHAT        '),  10800, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('CHAT        '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('CLASHOFCLANS'), 172800, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('EMAIL       '),  10800, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('EMAIL       '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('FACEBOOK    '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('LINE        '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('PHOTO       '),  10800, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('PHOTO       '),  86400, 20);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('PISONET     '),    600, 1 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('SNAPCHAT    '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('SOCIAL      '),  10800, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('SOCIAL      '),  86400, 20);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('SPEEDBOOST  '),    900, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('TUMBLR      '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('UNLI        '),  10800, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('UNLI        '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('WAZE        '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('WECHAT      '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('WIKIPEDIA   '),  86400, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('POSTPD'), rtrim('YOUTUBE     '),   1800, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('TNT   '), rtrim('BACKTOSCHOOL'),  87300, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('TNT   '), rtrim('BESTEVER    '),  86400, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('TNT   '), rtrim('CHAT        '),  10800, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('TNT   '), rtrim('CLASHOFCLANS'), 172800, 0 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('TNT   '), rtrim('EMAIL       '),  10800, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('TNT   '), rtrim('FACEBOOK    '),  86400, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('TNT   '), rtrim('PHOTO       '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('TNT   '), rtrim('PISONET     '),    600, 1 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('TNT   '), rtrim('SOCIAL      '),  86400, 10);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('TNT   '), rtrim('SPEEDBOOST  '),    900, 5 );
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('TNT   '), rtrim('UNLI        '),  86400, 20);
insert into powerapp_price_list (eff_dt, brand, plan, validity, price) values ('2014-08-27 00:00:00', rtrim('TNT   '), rtrim('YOUTUBE     '),   1800, 0 );
                                                                                                                                                      
                      chat_hits_3*5,                                                                                                                  
                      chat_hits_24*10,                                                                                                                
                      email_hits_3*5,                                                                                                                 
                      email_hits_24*10,                                                                                                               
                      photo_hits_3*10,                                                                                                                
                      photo_hits_24_pp*10, 
                      photo_hits_24*20, 
                      unli_hits_3*15, 
                      unli_hits_24_pp*20, 
                      unli_hits_24*30, 
                      social_hits_3*10, 
                      social_hits_24_pp*10, 
                      social_hits_24*20, 
                      speed_hits*5,
                      line_hits_24_pp*5, 
                      line_hits_24*10, 
                      snap_hits_24*5,
                      tumblr_hits_24*5,
                      waze_hits_24*5,
                      wechat_hits_24_pp*5, 
                      wechat_hits_24*10, 
                      facebook_hits_24*5,
                      wiki_hits_24*0,
                      free_social_hits_24*0,
                      piso_hits_15*1,
                      school_hits_24*5,


August 27
POSTPAID                  PREPAID, TNT, SUN  
Photo 3hrs - P10          Photo 24hrs - P10  
Photo 24hrs - P20         
Email 3hrs - P5           Email 24hrs - P10   
Email 24hrs - P10         
Social 3hrs - P10         Social 24hrs - P10  
Social 24hrs - P20        
Chat 3hrs - P5            Chat 24hrs - P10    
Chat 24hrs - P10          
Unli 3hrs - P15           Unli 24hrs - P20             
Unli 24hrs - P30          
Boost 15mins - P5         Boost 15mins - P5             
                          Back-to-school - P5           
                           
App Deals - 24hrs         App Deals - 24hrs  
SnapChat - P5             SnapChat - P5 
Tumblr - P5               Tumblr - P5        
Wechat - P10              Wechat - P5        
Line - P10                Line - P5         
Waze - P5                 Waze - P5         
Wiki - Free               Wiki - Free       
Facebook - P5             Facebook - P5     
                               
drop procedure sp_generate_rev_stats;
delimiter //
create procedure sp_generate_rev_stats (p_trandate)
begin
   begin
      declare vValidity, done_p int default 0;
      declare vPlan, vBrands varchar(60);
      declare vPrice decimal(12,2);
      declare c_prices for 
      select select plan, brand, validity from powerapp_stats_dtl where tran_dt = p_trandate;
      declare continue handler for sqlstate '02000' set done_p = 1;
      OPEN c_prices;
      REPEAT
         FETCH c_prices into vPlan, vValidity, vPrice, vBrands;
         if not done_p then
            if 
         end if;
      UNTIL done_p
      END REPEAT;
   end;
   
end;
//
delimiter ;



update powerapp_stats_dtl 
set rev=(select b.price from powerapp_price_list b 
         where powerapp_stats_dtl.plan=b.plan 
         and   powerapp_stats_dtl.brand=b.brand 
         and   powerapp_stats_dtl.validity=b.validity 
         and   b.eff_dt = (select max(c.eff_dt)
                           from  powerapp_price_list c 
                           where b.plan=c.plan 
                           and   b.brand=c.brand 
                           and   b.validity=c.validity 
                           and   c.eff_dt <= powerapp_stats_dtl.tran_dt)
        );

select * from powerapp_stats_dtl order by tran_dt asc limit 10;
select * from powerapp_stats_dtl order by tran_dt desc limit 10;
select plan, validity, sum(hits) hits, 
       group_concat(distinct(brand) order by brand) brands, 
       group_concat(distinct(tran_dt) order by tran_dt) dates 
from powerapp_stats_dtl where rev is null group by plan, validity;
