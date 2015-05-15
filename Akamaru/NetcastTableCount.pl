#!/usr/bin/perl

use warnings;
use lib "/home/dba_scripts/oist_stat/Lib";
use common;
use myconstants;
use DB;

use Spreadsheet::WriteExcel;
use MIME::Lite;


$tdate = $ARGV[0];
$mdate = $ARGV[1];
#$txt_month = $ARGV[2];
#$vday=substr($tdate,8);


my $excel_file = "/home/dba_scripts/oist_stat/NetcastTableCount".$tdate.".xls";
print $excel_file;

my $smartBro = DB::DBconnect(myconstants::netcast_DB,myconstants::netcast_HOST,myconstants::netcast_USER,myconstants::netcast_PASSWORD);

##stored proc
#$strgetstat="call sp_si_stats()"; 
#$sth_rt = $smartBro->prepare($strgetstat);
#$sth_rt->execute();

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
my $sth_RT;
my @rowRst;

#  Add and define a format

#$format_values = $workbook->add_format(font=>'Calibri',size=>12,color=>'black',align=>'left',border=>1);
$format_values11 = $workbook->add_format(fg_color => 9,bold=>0,font=>'Calibri',size=>11,color=>'black',align=>'right',valign=>'vcenter',border=>1,);
$format_values21 = $workbook->add_format(fg_color => 13,bold=>0,font=>'Calibri',size=>11,color=>'black',align=>'right',valign=>'vcenter',border=>1,);
$format_date = $workbook->add_format(bold=>1,font=>'Calibri',size=>12,fg_color=>'yellow',color=>'black',valign=>'vcenter',align=>'center',border=>2,);

$format2 = $workbook->add_format(fg_color => 'yellow',bold=>1,font=>'Calibri',size=>14,color=>'black',align=>'center',valign=>'vcenter',border=>2,);
#$format3 = $workbook->add_format(fg_color => 'white',bold=>1,font=>'Calibri',size=>12,color=>'black',align=>'center',valign=>'vcenter',border=>2,);
#$format4 = $workbook->add_format(fg_color => 'yellow',bold=>1,font=>'Calibri',size=>14,color=>'black',align=>'center',valign=>'vcenter',border=>2,);

#add worksheets
 my $tab1 = $workbook->add_worksheet("Table counts");

#set columns and rows
$tab1->set_column('a:a',35);
$tab1->set_column('b:aa',20);


#tab 1
$tab1->write('a4','Company_name',$format_date);
#tab1->merge_range('b3:aa3','T A B L E S',$format2);



$tab1->write('b4','AuthAssignment    ',$format2);
$tab1->write('c4','AuthItem          ',$format2);
$tab1->write('d4','AuthItemChild     ',$format2);
$tab1->write('e4','Activity_Logs     ',$format2);
$tab1->write('f4','Brand_Names       ',$format2);
$tab1->write('g4','Broadcast_Messages',$format2);
$tab1->write('h4','Company_Contacts  ',$format2);
$tab1->write('i4','Company_Settings  ',$format2);
$tab1->write('j4','Contacts          ',$format2);
$tab1->write('k4','Contacts_Sharing  ',$format2);
$tab1->write('l4','Custom_Messages   ',$format2);
$tab1->write('m4','Exclusion_List    ',$format2);
$tab1->write('n4','Groups            ',$format2);
$tab1->write('o4','Groups_Contacts   ',$format2);
$tab1->write('p4','Inbox             ',$format2);
$tab1->write('q4','Inbox_Replies     ',$format2);
$tab1->write('r4','Message_Templates ',$format2);
$tab1->write('s4','Modules           ',$format2);
$tab1->write('t4','Mt_Log            ',$format2);
$tab1->write('u4','Reply_Messages    ',$format2);
$tab1->write('v4','Sent_Messages     ',$format2);
$tab1->write('w4','SFTP_Details      ',$format2);
$tab1->write('x4','Shared_Contacts   ',$format2);
$tab1->write('y4','Shared_Groups     ',$format2);
$tab1->write('z4','User_Roles        ',$format2);
$tab1->write('aa4','WS_Logs        ',$format2);

my $row=3;
my $i=0;
my $col=0;
$strgetstat='select b.company_name, 
max(if(a.table_name="AuthAssignment    ",table_rows,0)) AuthAssignment    ,              
max(if(a.table_name="AuthItem          ",table_rows,0)) AuthItem          ,         
max(if(a.table_name="AuthItemChild     ",table_rows,0)) AuthItemChild     ,         
max(if(a.table_name="activity_logs     ",table_rows,0)) activity_logs     ,               
max(if(a.table_name="brand_names       ",table_rows,0)) brand_names       ,                 
max(if(a.table_name="broadcast_messages",table_rows,0)) broadcast_messages,          
max(if(a.table_name="company_contacts  ",table_rows,0)) company_contacts  ,         
max(if(a.table_name="company_settings  ",table_rows,0)) company_settings  ,         
max(if(a.table_name="contacts          ",table_rows,0)) contacts          ,                    
max(if(a.table_name="contacts_sharing  ",table_rows,0)) contacts_sharing  ,         
max(if(a.table_name="custom_messages   ",table_rows,0)) custom_messages   ,             
max(if(a.table_name="exclusion_list    ",table_rows,0)) exclusion_list    ,         
max(if(a.table_name="groups            ",table_rows,0)) groups            ,         
max(if(a.table_name="groups_contacts   ",table_rows,0)) groups_contacts   ,             
max(if(a.table_name="inbox             ",table_rows,0)) inbox             ,         
max(if(a.table_name="inbox_replies     ",table_rows,0)) inbox_replies     ,         
max(if(a.table_name="message_templates ",table_rows,0)) message_templates ,           
max(if(a.table_name="modules           ",table_rows,0)) modules           ,         
max(if(a.table_name="mt_log            ",table_rows,0)) mt_log            ,         
max(if(a.table_name="reply_messages    ",table_rows,0)) reply_messages    ,             
max(if(a.table_name="sent_messages     ",table_rows,0)) sent_messages     ,              
max(if(a.table_name="sftp_details      ",table_rows,0)) sftp_details      ,         
max(if(a.table_name="shared_contacts   ",table_rows,0)) shared_contacts   ,         
max(if(a.table_name="shared_groups     ",table_rows,0)) shared_groups     ,         
max(if(a.table_name="user_roles        ",table_rows,0)) user_roles        ,         
max(if(a.table_name="ws_logs           ",table_rows,0)) ws_logs                    
from information_schema.tables a, companies b where a.table_schema regexp "netcast_[[:digit:]]+$" and substring(a.table_schema,9)=b.company_id
group by 1;';
       
        $sth_rt = $smartBro->prepare($strgetstat);
        $sth_rt->execute();

        while (my @rowRst = $sth_rt->fetchrow())
                {
                        $i++;

                        for ( $f=0; $f <= 26; $f++)
                                {
                                $tab1->write($row+$i, $col+$f,    $rowRst[$f], ($i % 2 ==0)? $format_values11 : $format_values21);
                                }
                }


$workbook->close();
 binmode STDOUT;

$from = "netcast_stats\@chikka.com";
#$to = "nsantos\@chikka.com";
#$cc = "dbadmins\@chikka.com, jfgeronimo\@chikka.com, mmuyco\@chikka.com, jomai\@chikka.com, alfie\@chikka.com";
$to = "jojo\@chikka.com";
$cc = "jojo\@chikka.com";
$Subject = "Monthly Netcast Table Count Report, ".$mdate;

# Part using which the attachment is sent to an email #
$msg = MIME::Lite->new(
        From     => $from,
        To       => $to,
		Cc      => $cc,
        Subject  => $Subject,
        Type     => 'File/xls',
        Path     => $excel_file
);

    $msg->attach(
        Type => 'text/html',
        Data => qq{
            <body>
      		<p>
			<span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;"> Monthly Table Count Report.</span></span></p>
		<p>
			<span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">Please refer to the attachment.</span></span></p>
		<p>
			&nbsp;</p>
		<div>
			<span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">Regards,</span></span></div>
		<div>
			<span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">CHIKKA DBA TEAM</span></span></div>
		<p>
			&nbsp;</p>
		<p>
			<br />
			&nbsp;</p>
            </body>
        },
    );
	
print "Mail Sent\n";
$msg->send; # send via default


#######

