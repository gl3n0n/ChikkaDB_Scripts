drop view powerapp_brand_hits;
create view powerapp_brand_hits as
select left(datein,10) datein, count(1) unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='BUDDY'  and plan= 'UNLI' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, count(1) email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='BUDDY'  and plan= 'EMAIL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, count(1) social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='BUDDY'  and plan= 'SOCIAL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, count(1) photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='BUDDY'  and plan= 'PHOTO' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, count(1) chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='BUDDY'  and plan= 'CHAT' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, count(1) speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='BUDDY'  and plan= 'SPEEDBOOST' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, count(1) unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='POSTPD' and plan= 'UNLI' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, count(1) email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='POSTPD' and plan= 'EMAIL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, count(1) social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='POSTPD' and plan= 'SOCIAL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, count(1) photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='POSTPD' and plan= 'PHOTO' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, count(1) chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='POSTPD' and plan= 'CHAT' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, count(1) speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='POSTPD' and plan= 'SPEEDBOOST' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, count(1) unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='TNT'    and plan= 'UNLI' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, count(1) email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='TNT'    and plan= 'EMAIL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, count(1) social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='TNT'    and plan= 'SOCIAL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, count(1) photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='TNT'    and plan= 'PHOTO' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, count(1) chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='TNT'    and plan= 'CHAT' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, count(1) speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='TNT'    and plan= 'SPEEDBOOST' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, count(1) unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and plan= 'UNLI'       group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, count(1) email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and plan= 'EMAIL'      group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, count(1) social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and plan= 'SOCIAL'     group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, count(1) photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and plan= 'PHOTO'      group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, count(1) chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and plan= 'CHAT'       group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, count(1) speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and plan= 'SPEEDBOOST' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, count(1) hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='BUDDY'  group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, count(1) hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='POSTPD' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, count(1) hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='TNT'    group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, count(1) hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) group by left(datein,10);

drop view powerapp_brand_uniq;
create view powerapp_brand_uniq as
select left(datein,10) datein, count(distinct phone) unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='BUDDY'  and plan= 'UNLI' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, count(distinct phone) email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='BUDDY'  and plan= 'EMAIL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, count(distinct phone) social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='BUDDY'  and plan= 'SOCIAL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, count(distinct phone) photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='BUDDY'  and plan= 'PHOTO' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, count(distinct phone) chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='BUDDY'  and plan= 'CHAT' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, count(distinct phone) speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='BUDDY'  and plan= 'SPEEDBOOST' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, count(distinct phone) unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='POSTPD' and plan= 'UNLI' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, count(distinct phone) email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='POSTPD' and plan= 'EMAIL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, count(distinct phone) social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='POSTPD' and plan= 'SOCIAL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, count(distinct phone) photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='POSTPD' and plan= 'PHOTO' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, count(distinct phone) chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='POSTPD' and plan= 'CHAT' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, count(distinct phone) speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='POSTPD' and plan= 'SPEEDBOOST' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, count(distinct phone) unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='TNT'    and plan= 'UNLI' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, count(distinct phone) email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='TNT'    and plan= 'EMAIL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, count(distinct phone) social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='TNT'    and plan= 'SOCIAL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, count(distinct phone) photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='TNT'    and plan= 'PHOTO' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, count(distinct phone) chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='TNT'    and plan= 'CHAT' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, count(distinct phone) speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='TNT'    and plan= 'SPEEDBOOST' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, count(distinct phone) unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and plan= 'UNLI' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, count(distinct phone) email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and plan= 'EMAIL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, count(distinct phone) social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and plan= 'SOCIAL' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, count(distinct phone) photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and plan= 'PHOTO' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, count(distinct phone) chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and plan= 'CHAT' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, count(distinct phone) speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and plan= 'SPEEDBOOST' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, count(distinct phone) hits_pre, 0 hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='BUDDY' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, count(distinct phone) hits_post, 0 hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='POSTPD' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, count(distinct phone) hits_tnt, 0 hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) and brand='TNT' group by left(datein,10) union 
select left(datein,10) datein, 0 unli_pre, 0 email_pre, 0 social_pre, 0 photo_pre, 0 chat_pre, 0 speedboost_pre, 0 unli_post, 0 email_post, 0 social_post, 0 photo_post, 0 chat_post, 0 speedboost_post, 0 unli_tnt, 0 email_tnt, 0 social_tnt, 0 photo_tnt, 0 chat_tnt, 0 speedboost_tnt, 0 unli_total, 0 email_total, 0 social_total, 0 photo_total, 0 chat_total, 0 speedboost_total, 0 hits_pre, 0 hits_post, 0 hits_tnt, count(distinct phone) hits_total from powerapp_log where datein >= date_sub(curdate(), interval 109 day) group by left(datein,10);

drop view powerapp_brand_ctr;
create view powerapp_brand_ctr as
select datein, 
       sum(unli_pre) unli_pre_h, sum(email_pre) email_pre_h, sum(social_pre) social_pre_h, sum(photo_pre) photo_pre_h, sum(chat_pre) chat_pre_h, sum(speedboost_pre) speedboost_pre_h, 
       sum(unli_post) unli_post_h, sum(email_post) email_post_h, sum(social_post) social_post_h, sum(photo_post) photo_post_h, sum(chat_post) chat_post_h, sum(speedboost_post) speedboost_post_h, 
       sum(unli_tnt) unli_tnt_h, sum(email_tnt) email_tnt_h, sum(social_tnt) social_tnt_h, sum(photo_tnt) photo_tnt_h, sum(chat_tnt) chat_tnt_h, sum(speedboost_tnt) speedboost_tnt_h, 
       sum(unli_total) unli_total_h, sum(email_total) email_total_h, sum(social_total) social_total_h, sum(photo_total) photo_total_h, sum(chat_total) chat_total_h, sum(speedboost_total) speedboost_total_h, 
       sum(hits_pre) hits_pre_h, sum(hits_post) hits_post_h, sum(hits_tnt) hits_tnt_h, sum(hits_total) hits_total_h,
       0 unli_pre_u, 0 email_pre_u, 0 social_pre_u, 0 photo_pre_u, 0 chat_pre_u, 0 speedboost_pre_u, 
       0 unli_post_u, 0 email_post_u, 0 social_post_u, 0 photo_post_u, 0 chat_post_u, 0 speedboost_post_u, 
       0 unli_tnt_u, 0 email_tnt_u, 0 social_tnt_u, 0 photo_tnt_u, 0 chat_tnt_u, 0 speedboost_tnt_u, 
       0 unli_total_u, 0 email_total_u, 0 social_total_u, 0 photo_total_u, 0 chat_total_u, 0 speedboost_total_u, 
       0 hits_pre_u, 0 hits_post_u, 0 hits_tnt_u, 0 hits_total_u
from powerapp_brand_hits 
group  by datein
union all
select datein, 
       0 unli_pre_h, 0 email_pre_h, 0 social_pre_h, 0 photo_pre_h, 0 chat_pre_h, 0 speedboost_pre_h, 
       0 unli_post_h, 0 email_post_h, 0 social_post_h, 0 photo_post_h, 0 chat_post_h, 0 speedboost_post_h, 
       0 unli_tnt_h, 0 email_tnt_h, 0 social_tnt_h, 0 photo_tnt_h, 0 chat_tnt_h, 0 speedboost_tnt_h, 
       0 unli_total_h, 0 email_total_h, 0 social_total_h, 0 photo_total_h, 0 chat_total_h, 0 speedboost_total_h, 
       0 hits_pre_h, 0 hits_post_h, 0 hits_tnt_h, 0 hits_total_h,
       sum(unli_pre) unli_pre_u, sum(email_pre) email_pre_u, sum(social_pre) social_pre_u, sum(photo_pre) photo_pre_u, sum(chat_pre) chat_pre_u, sum(speedboost_pre) speedboost_pre_u, 
       sum(unli_post) unli_post_u, sum(email_post) email_post_u, sum(social_post) social_post_u, sum(photo_post) photo_post_u, sum(chat_post) chat_post_u, sum(speedboost_post) speedboost_post_u, 
       sum(unli_tnt) unli_tnt_u, sum(email_tnt) email_tnt_u, sum(social_tnt) social_tnt_u, sum(photo_tnt) photo_tnt_u, sum(chat_tnt) chat_tnt_u, sum(speedboost_tnt) speedboost_tnt_u, 
       sum(unli_total) unli_total_u, sum(email_total) email_total_u, sum(social_total) social_total_u, sum(photo_total) photo_total_u, sum(chat_total) chat_total_u, sum(speedboost_total) speedboost_total_u, 
       sum(hits_pre) hits_pre_u, sum(hits_post) hits_post_u, sum(hits_tnt) hits_tnt_u, sum(hits_total) hits_total_u
from powerapp_brand_uniq
group  by datein;


create view powerapp_brand_summary as
select datein, 
       sum(unli_pre_h) unli_pre_h,
       sum(email_pre_h) email_pre_h,
       sum(social_pre_h) social_pre_h,
       sum(photo_pre_h) photo_pre_h,
       sum(chat_pre_h) chat_pre_h,
       sum(speedboost_pre_h) speedboost_pre_h,
       sum(unli_post_h) unli_post_h,
       sum(email_post_h) email_post_h,
       sum(social_post_h) social_post_h,
       sum(photo_post_h) photo_post_h,
       sum(chat_post_h) chat_post_h,
       sum(speedboost_post_h) speedboost_post_h,
       sum(unli_tnt_h) unli_tnt_h,
       sum(email_tnt_h) email_tnt_h,
       sum(social_tnt_h) social_tnt_h,
       sum(photo_tnt_h) photo_tnt_h,
       sum(chat_tnt_h) chat_tnt_h,
       sum(speedboost_tnt_h) speedboost_tnt_h,
       sum(unli_total_h) unli_total_h,
       sum(email_total_h) email_total_h,
       sum(social_total_h) social_total_h,
       sum(photo_total_h) photo_total_h,
       sum(chat_total_h) chat_total_h,
       sum(speedboost_total_h) speedboost_total_h,
       sum(hits_pre_h) hits_pre_h,
       sum(hits_post_h) hits_post_h,
       sum(hits_tnt_h) hits_tnt_h,
       sum(hits_total_h) hits_total_h,
       sum(unli_pre_u) unli_pre_u,
       sum(email_pre_u) email_pre_u,
       sum(social_pre_u) social_pre_u,
       sum(photo_pre_u) photo_pre_u,
       sum(chat_pre_u) chat_pre_u,
       sum(speedboost_pre_u) speedboost_pre_u,
       sum(unli_post_u) unli_post_u,
       sum(email_post_u) email_post_u,
       sum(social_post_u) social_post_u,
       sum(photo_post_u) photo_post_u,
       sum(chat_post_u) chat_post_u,
       sum(speedboost_post_u) speedboost_post_u,
       sum(unli_tnt_u) unli_tnt_u,
       sum(email_tnt_u) email_tnt_u,
       sum(social_tnt_u) social_tnt_u,
       sum(photo_tnt_u) photo_tnt_u,
       sum(chat_tnt_u) chat_tnt_u,
       sum(speedboost_tnt_u) speedboost_tnt_u,
       sum(unli_total_u) unli_total_u,
       sum(email_total_u) email_total_u,
       sum(social_total_u) social_total_u,
       sum(photo_total_u) photo_total_u,
       sum(chat_total_u) chat_total_u,
       sum(speedboost_total_u) speedboost_total_u,
       sum(hits_pre_u) hits_pre_u,
       sum(hits_post_u) hits_post_u,
       sum(hits_tnt_u) hits_tnt_u,
       sum(hits_total_u) hits_total_u
from powerapp_brand_ctr
group  by datein;


CREATE TABLE powerapp_brand_dailyrep (
 tran_dt date NOT NULL,
 unli_pre int(11) default 0,
 email_pre int(11) default 0,
 social_pre int(11) default 0,
 photo_pre int(11) default 0,
 chat_pre int(11) default 0,
 speedboost_pre int(11) default 0,
 unli_post int(11) default 0,
 email_post int(11) default 0,
 social_post int(11) default 0,
 photo_post int(11) default 0,
 chat_post int(11) default 0,
 speedboost_post int(11) default 0,
 unli_tnt int(11) default 0,
 email_tnt int(11) default 0,
 social_tnt int(11) default 0,
 photo_tnt int(11) default 0,
 chat_tnt int(11) default 0,
 speedboost_tnt int(11) default 0,
 unli_total int(11) default 0,
 email_total int(11) default 0,
 social_total int(11) default 0,
 photo_total int(11) default 0,
 chat_total int(11) default 0,
 speedboost_total int(11) default 0,
 hits_pre int(11) default 0,
 hits_post int(11) default 0,
 hits_tnt int(11) default 0,
 hits_total int(11) default 0,
 num_optout int(11) default 0,
 concurrent_max_tm varchar(100) DEFAULT '00:00:00',
 concurrent_max_subs int(11) DEFAULT '0',
 concurrent_avg_subs decimal(10,2) DEFAULT '0.00',
 num_uniq_30d int(11) DEFAULT '0',
 PRIMARY KEY (tran_dt)
);
 
DROP PROCEDURE IF EXISTS sp_generate_hi10_brand_stats;
delimiter //
CREATE PROCEDURE sp_generate_hi10_brand_stats()
begin
    delete from powerapp_brand_dailyrep where tran_dt >= date_sub(curdate(), interval 1 day);

    insert ignore into powerapp_brand_dailyrep (tran_dt, unli_pre, email_pre, social_pre, photo_pre, chat_pre, speedboost_pre, unli_post, email_post, social_post, photo_post, chat_post, speedboost_post, unli_tnt, email_tnt, social_tnt, photo_tnt, chat_tnt, speedboost_tnt, unli_total, email_total, social_total, photo_total, chat_total, speedboost_total, hits_pre, hits_post, hits_tnt, hits_total, concurrent_max_tm, concurrent_max_subs, concurrent_avg_subs, num_uniq_30d)
    select datein, unli_pre, email_pre, social_pre, photo_pre, chat_pre, speedboost_pre, unli_post, email_post, social_post, photo_post, chat_post, speedboost_post, unli_tnt, email_tnt, social_tnt, photo_tnt, chat_tnt, speedboost_tnt, unli_total, email_total, social_total, photo_total, chat_total, speedboost_total, hits_pre, hits_post, hits_tnt, hits_total, 0 concurrent_max_tm, 0 concurrent_max_subs, 0 concurrent_avg_subs, 0 num_uniq_30d
    from   powerapp_brand_summary
    where  datein = date_sub(curdate(), interval 1 day);

    select num_optout, concurrent_max_tm, concurrent_max_subs, concurrent_avg_subs, num_uniq_30d  
    into   @vNumOptout, @vTimeIn, @vNumSubs, @vAvgSubs, @NumUniq30d
    from   powerapp_dailyrep
    where  tran_dt = date_sub(curdate(), interval 1 day);

    update powerapp_brand_dailyrep
    set    num_optout= IFNULL(@vNumOptout,0),
           concurrent_max_tm= IFNULL(@vTimeIn,'00:00'),
           concurrent_max_subs=IFNULL(@vNumSubs,0),
           concurrent_avg_subs=IFNULL(@vAvgSubs,0),
           num_uniq_30d=IFNULL(@NumUniq30d,0)
    where  tran_dt = date_sub(curdate(), interval 1 day);


END;
//
delimiter ; 

insert into powerapp_dailyrep (tran_dt, unli_hits, email_hits, social_hits, photo_hits, chat_hits, speed_hits, unli_uniq, email_uniq, social_uniq, photo_uniq, chat_uniq, speed_uniq, total_hits, total_uniq)
select datein DATE, sum(unli) UNLI, sum(email) EMAIL, sum(social) SOCIAL, sum(photo) PHOTO, sum(chat) CHAT, sum(speedboost) SPEEDBOOST, 
                    sum(unli_u) UNLI_U, sum(email_u) EMAIL_U, sum(social_u) SOCIAL_U, sum(photo_u) PHOTO_U, sum(chat_u) CHAT_U, sum(speedboost_u) SPEEDBOOST_U,
                    sum(total_hits), suM(total_uniq)
from (
select left(datein,10) datein, count(1) unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'UNLI' group by left(datein,10) union
select left(datein,10) datein, 0 unli, count(1) email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'EMAIL' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, count(1) social, 0 photo, 0 chat, 0 speedboost, 0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'SOCIAL' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, count(1) photo, 0 chat, 0 speedboost, 0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'PHOTO' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, count(1) chat, 0 speedboost, 0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'CHAT' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, count(1) speedboost, 0 unli_u, 0 email_u, 0 social_u, 0 photo_u, 0 chat_u, 0 speedboost_u, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'SPEEDBOOST' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, count(distinct phone) unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'UNLI' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, count(distinct phone) email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'EMAIL' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, count(distinct phone) social, 0 photo, 0 chat, 0 speedboost, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'SOCIAL' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, 0 social, count(distinct phone) photo, 0 chat, 0 speedboost, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'PHOTO' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, 0 social, 0 photo, count(distinct phone) chat, 0 speedboost, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'CHAT' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, 0 social, 0 photo, 0 chat, count(distinct phone) speedboost, 0 total_hits, 0 total_uniq from powerapp_log where plan= 'SPEEDBOOST' group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, count(1) total_hits, 0 total_uniq from powerapp_log group by left(datein,10) union
select left(datein,10) datein, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 unli, 0 email, 0 social, 0 photo, 0 chat, 0 speedboost, 0 total_hits, count(distinct phone) total_uniq from powerapp_log group by left(datein,10) 
) as t1
group by  datein;



DROP table powerapp_dailyrep ;
create table powerapp_dailyrep (
tran_dt date not null,
unli_hits int default 0,
unli_uniq int default 0,
email_hits int default 0,
email_uniq int default 0,
chat_hits int default 0,
chat_uniq int default 0,
photo_hits int default 0,
photo_uniq int default 0,
social_hits int default 0,
social_uniq int default 0,
speed_hits int default 0,
speed_uniq int default 0,
total_hits int default 0,
total_uniq int default 0,
primary key (tran_dt)
);

create table powerapp_concurrent_subs (
   tran_dt date not null,
   num_subs int default 0,
   primary key (tran_dt)
);
 

select tran_dt, unli_hits, email_hits, chat_hits, photo_hits, social_hits, speed_hits from powerapp_dailyrep where tran_dt >= '2013-12-01' and tran_dt < '2014-01-01';
select tran_dt, unli_uniq, email_uniq, chat_uniq, photo_uniq, social_uniq, speed_uniq from powerapp_dailyrep where tran_dt >= '2013-12-01' and tran_dt < '2014-01-01';
select tran_dt, total_hits from powerapp_dailyrep where tran_dt >= '2013-12-01' and tran_dt < '2014-01-01';
select tran_dt, total_uniq from powerapp_dailyrep where tran_dt >= '2013-12-01' and tran_dt < '2014-01-01';

select date_format(tran_dt, '%y-%b'), total_hits from powerapp_dailyrep group by 1;

select '2013-12-01' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-01' union
select '2013-12-02' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-02' union
select '2013-12-03' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-03' union
select '2013-12-04' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-04' union
select '2013-12-05' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-05' union
select '2013-12-06' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-06' union
select '2013-12-07' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-07' union
select '2013-12-08' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-08' union
select '2013-12-09' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-09' union
select '2013-12-10' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-10' union
select '2013-12-11' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-11' union
select '2013-12-12' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-12' union
select '2013-12-13' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-13' union
select '2013-12-14' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-14' union
select '2013-12-15' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-15' union
select '2013-12-16' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-16' union
select '2013-12-17' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-17' union
select '2013-12-18' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-18' union
select '2013-12-19' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-19' union
select '2013-12-20' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-20' union
select '2013-12-21' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-21' union
select '2013-12-22' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-22' union
select '2013-12-23' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-23' union
select '2013-12-24' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-24' union
select '2013-12-25' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-25' union
select '2013-12-26' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-26' union
select '2013-12-27' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-27' union
select '2013-12-28' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-28' union
select '2013-12-29' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-29' union
select '2013-12-30' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-30' union
select '2013-12-31' datein, count( distinct phone) uniq from powerapp_log where datein < '2013-12-31' 


insert into powerapp_concurrent_subs values ('2013-12-01',    38);
insert into powerapp_concurrent_subs values ('2013-12-02',    35);
insert into powerapp_concurrent_subs values ('2013-12-03',    40);
insert into powerapp_concurrent_subs values ('2013-12-04',   419);
insert into powerapp_concurrent_subs values ('2013-12-05',   588);
insert into powerapp_concurrent_subs values ('2013-12-06',   654);
insert into powerapp_concurrent_subs values ('2013-12-07',   712);
insert into powerapp_concurrent_subs values ('2013-12-08',   875);
insert into powerapp_concurrent_subs values ('2013-12-09',  1061);
insert into powerapp_concurrent_subs values ('2013-12-10',  1133);
insert into powerapp_concurrent_subs values ('2013-12-11',  1119);
insert into powerapp_concurrent_subs values ('2013-12-12',  1336);
insert into powerapp_concurrent_subs values ('2013-12-13',  1607);
insert into powerapp_concurrent_subs values ('2013-12-14',  1802);
insert into powerapp_concurrent_subs values ('2013-12-15',  2050);
insert into powerapp_concurrent_subs values ('2013-12-16',  3718);
insert into powerapp_concurrent_subs values ('2013-12-17',  5154);
insert into powerapp_concurrent_subs values ('2013-12-18',  7100);
insert into powerapp_concurrent_subs values ('2013-12-19',  8569);
insert into powerapp_concurrent_subs values ('2013-12-20', 10098);
insert into powerapp_concurrent_subs values ('2013-12-21', 14004);
insert into powerapp_concurrent_subs values ('2013-12-22', 17128);
insert into powerapp_concurrent_subs values ('2013-12-23', 20360);
insert into powerapp_concurrent_subs values ('2013-12-24', 23236);
insert into powerapp_concurrent_subs values ('2013-12-25', 25682);
insert into powerapp_concurrent_subs values ('2013-12-26', 25992);
insert into powerapp_concurrent_subs values ('2013-12-27', 26790);
insert into powerapp_concurrent_subs values ('2013-12-28', 27750);
insert into powerapp_concurrent_subs values ('2013-12-29', 28439);
insert into powerapp_concurrent_subs values ('2013-12-30', 30034);
insert into powerapp_concurrent_subs values ('2013-12-31', 31274);
+------------+-------+

Total Concurrent subs
+------------+-------+
| datein     | uniq  |
+------------+-------+
| 2013-12    | 31274 |
+------------+-------+


select DATE_FORMAT(a.tran_dt,'%m/%d/%Y'), a.unli_hits, a.email_hits, a.chat_hits, a.photo_hits, a.social_hits, a.speed_hits, a.unli_uniq, a.email_uniq, a.chat_uniq, a.photo_uniq, a.social_uniq, a.speed_uniq, a.total_hits, a.total_uniq, IFNULL(b.num_subs,0) from powerapp_dailyrep a left outer join powerapp_concurrent_subs b on a.tran_dt = b.tran_dt
