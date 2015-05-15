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


my $excel_file = "/home/dba_scripts/oist_stat/agt_daily_stats_".$tdate.".xls";
print $excel_file;

my $smartBro = DB::DBconnect(myconstants::agt_DB,myconstants::agt_HOST,myconstants::agt_USER,myconstants::agt_PASSWORD);

##stored proc
#$strgetstat="call sp_si_stats()"; 
#$sth_rt = $smartBro->prepare($strgetstat);
#$sth_rt->execute();

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
my $sth_RT;
my @rowRst;

#  Add and define a format

$format_values = $workbook->add_format(font=>'Calibri',size=>12,color=>'black',align=>'left',border=>1);
$format_values11 = $workbook->add_format(fg_color => 9,bold=>0,font=>'Calibri',size=>11,color=>'black',align=>'right',valign=>'vcenter',border=>1,);
$format_values21 = $workbook->add_format(fg_color => 13,bold=>0,font=>'Calibri',size=>11,color=>'black',align=>'right',valign=>'vcenter',border=>1,);
$format_date = $workbook->add_format(bold=>1,font=>'Calibri',size=>12,fg_color=>'yellow',color=>'black',valign=>'vcenter',align=>'center',border=>2,);

$format2 = $workbook->add_format(fg_color => 'yellow',bold=>1,font=>'Calibri',size=>14,color=>'black',align=>'center',valign=>'vcenter',border=>2,);
$format3 = $workbook->add_format(fg_color => 'white',bold=>1,font=>'Calibri',size=>12,color=>'black',align=>'center',valign=>'vcenter',border=>2,);
$format4 = $workbook->add_format(fg_color => 'yellow',bold=>1,font=>'Calibri',size=>14,color=>'black',align=>'center',valign=>'vcenter',border=>2,);

#add worksheets
 my $tab1 = $workbook->add_worksheet("AGT Stats");

#set columns and rows
$tab1->set_column('a:i',15);


#tab 1
$tab1->write('a3','Date',$format_date);
$tab1->merge_range('b3:c3','Invalids',$format2);
$tab1->merge_range('d3:e3','SMS-IN',$format2);
$tab1->merge_range('f3:g3','SMS-OUT',$format2);
$tab1->merge_range('h3:i3','Delivered',$format2);



$tab1->write('b4',"Smart",$format3);
$tab1->write('c4',"Globe",$format3);
$tab1->write('d4',"Smart",$format3);
$tab1->write('e4',"Globe",$format3);
$tab1->write('f4',"Smart",$format3);
$tab1->write('g4',"Globe",$format3);
$tab1->write('h4',"Smart",$format3);
$tab1->write('i4',"Globe",$format3);

my $row=3;
my $i=0;
my $col=0;
$strgetstat="select tran_dt, max(if(type='sm_invalid', bilang,0)) smart_invalid, max(if(type='gl_invalid', bilang,0)) globe_invalid, 
                             max(if(type='smsms_in', bilang,0)) smsin_smart, max(if(type='glsms_in', bilang,0)) smsin_globe,
                             max(if(type='smsms_out', bilang,0)) smsout_smart, max(if(type='glsms_out', bilang,0)) smsout_globe, 
                             max(if(type='smsms_del', bilang,0)) smart_deliverd, max(if(type='glsms_del', bilang,0)) globe_deliverd 
              from stats_dtl where tran_dt like '".$mdate."%' group by tran_dt  order by tran_dt;";
       
        $sth_rt = $smartBro->prepare($strgetstat);
        $sth_rt->execute();

        while (my @rowRst = $sth_rt->fetchrow())
                {
                        $i++;

                        for ( $f=0; $f <= 8; $f++)
                                {
                                $tab1->write($row+$i, $col+$f,    $rowRst[$f], ($i % 2 ==0)? $format_values11 : $format_values21);
                                }
                }


$workbook->close();
 binmode STDOUT;

$from = "2929agt_stats\@chikka.com";
$to = "nsantos\@chikka.com";
$cc = "dbadmins\@chikka.com, jfgeronimo\@chikka.com, mmuyco\@chikka.com, jomai\@chikka.com, alfie\@chikka.com";
#$to = "jojo\@chikka.com";
#$cc = "dbadmins\@chikka.com";
$Subject = "AGT 2929 Stats Report, ".$tdate;

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
			<span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;"> Daily 2929 AGT Stats Report.</span></span></p>
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

