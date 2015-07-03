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


my $excel_file = "/home/dba_scripts/oist_stat/smartbro_daily_stats_".$tdate.".xls";
print $excel_file;

my $smartBro = DB::DBconnect(myconstants::smartbiggie_DB,myconstants::smartbiggie_HOST,myconstants::smartbiggie_USER,myconstants::smartbiggie_PASSWORD);

##stored proc
$strgetstat="call sp_si_stats()"; 
$sth_rt = $smartBro->prepare($strgetstat);
$sth_rt->execute();

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
 my $tab1 = $workbook->add_worksheet("Smart Bro Stats");

#set columns and rows
$tab1->set_column('a:g',15);


#tab 1
$tab1->write('a3','Date',$format_date);
$tab1->merge_range('b3:c3','Payment',$format2);
$tab1->merge_range('d3:e3','Availment',$format2);
$tab1->merge_range('f3:g3','Black List',$format2);

$tab1->write('b4',"Transaction",$format3);
$tab1->write('c4',"Unique",$format3);
$tab1->write('d4',"Transaction",$format3);
$tab1->write('e4',"Unique",$format3);
$tab1->write('f4',"Transaction",$format3);
$tab1->write('g4',"Unique",$format3);

my $row=3;
my $i=0;
my $col=0;
$strgetstat="select * from biggie_summary_excel where tx_date like '".$mdate."%' order by 1;";
       
        $sth_rt = $smartBro->prepare($strgetstat);
        $sth_rt->execute();

        while (my @rowRst = $sth_rt->fetchrow())
                {
                        $i++;

                        for ( $f=0; $f <= 6; $f++)
                                {
                                $tab1->write($row+$i, $col+$f,    $rowRst[$f], ($i % 2 ==0)? $format_values11 : $format_values21);
                                }
                }


$workbook->close();
 binmode STDOUT;

$from = "smart_bro\@chikka.com";
#$to = "jojo\@chikka.com";
#$cc = "dbadmins\@chikka.com";
$to = "kpsese\@chikka.com,ra\@chikka.com";
$cc = "dbadmins\@chikka.com,alfie\@chikka.com,jomai\@chikka.com ";
$Subject = "SmartBro Internet Services Stats Report, ".$tdate;

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
			<span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;"> Daily SmartBro Internet Report .</span></span></p>
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

