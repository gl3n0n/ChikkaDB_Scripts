select a.datein, sum(a.download) download, sum(a.upload) upload, sum(b.count) uniq 
from   usage_per_plan a, unique_subs b 
where  a.datein = b.datein 
and    a.service=b.service 
and    b.type='RX'
group by 1; 


select a.datein, a.service, sum(a.download) download, sum(a.upload) upload, sum(b.count) uniq 
from   usage_per_plan a, unique_subs b 
where  a.datein = b.datein 
and    a.service=b.service 
and    b.type='RX'
group by 1, 2
order by service, datein; 



select a.datein, 'BacktoschoolService '
select a.datein, 'ChatService         '
select a.datein, 'ClashofclansService '
select a.datein, 'EmailService        '
select a.datein, 'FacebookService     '
select a.datein, 'LineService         '
select a.datein, 'PhotoService        '
select a.datein, 'PisonetService      '
select a.datein, 'SnapchatService     '
select a.datein, 'SocialService       '
select a.datein, 'SpeedBoostService   '
select a.datein, 'TumblrService       '
select a.datein, 'UnlimitedService    '
select a.datein, 'WazeService         '
select a.datein, 'WechatService       '
select a.datein, 'Whitelisted         '
select a.datein, 'WikipediaService    '
select a.datein, 'YoutubeService      '

select a.datein, a.service, a.download, a.upload, b.type, b.count from usage_per_plan a, unique_subs b where a.datein = b.datein and a.service=b.service limit 10;

