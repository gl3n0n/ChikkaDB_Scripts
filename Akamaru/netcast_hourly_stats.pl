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


my $excel_file = "/home/dba_scripts/oist_stat/netcast_hourly_stats_".$tdate.".xls";
print $excel_file;

my $v3 = DB::DBconnect(myconstants::csg_archive_DB,myconstants::csg_archive_HOST,myconstants::csg_archive_USER,myconstants::csg_archive_PASSWORD);
my $v4 = DB::DBconnect(myconstants::netcast_DB1,myconstants::netcast_HOST,myconstants::netcast_USER,myconstants::netcast_PASSWORD);

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
 my $tab1 = $workbook->add_worksheet("Netcast V3");
 my $tab2 = $workbook->add_worksheet("Netcast V4");

#set columns and rows
$tab1->set_column('a:aa',15);
$tab2->set_column('a:aa',15);


#tab 1
$tab1->write('a3','Date',$format_date);
$tab1->merge_range('b3:y3','H O U R ',$format2);


$tab1->write('b4',"0",$format3);
$tab1->write('c4',"1",$format3);
$tab1->write('d4',"2",$format3);
$tab1->write('e4',"3",$format3);
$tab1->write('f4',"4",$format3);
$tab1->write('g4',"5",$format3);
$tab1->write('h4',"6",$format3);
$tab1->write('i4',"7",$format3);
$tab1->write('j4',"8",$format3);
$tab1->write('k4',"9",$format3);
$tab1->write('l4',"10",$format3);
$tab1->write('m4',"11",$format3);
$tab1->write('n4',"12",$format3);
$tab1->write('o4',"13",$format3);
$tab1->write('p4',"14",$format3);
$tab1->write('q4',"15",$format3);
$tab1->write('r4',"16",$format3);
$tab1->write('s4',"17",$format3);
$tab1->write('t4',"18",$format3);
$tab1->write('u4',"19",$format3);
$tab1->write('v4',"20",$format3);
$tab1->write('w4',"21",$format3);
$tab1->write('x4',"22",$format3);
$tab1->write('y4',"23",$format3);



my $row=3;
my $i=0;
my $col=0;

$strgetstat="SELECT  datesent,
        MAX(IF(hr = 0,  total, 0)) hour0,
        MAX(IF(hr = 1,  total, 0)) hour1,
	MAX(IF(hr = 2,  total, 0)) hour2,
	MAX(IF(hr = 3,  total, 0)) hour3,
	MAX(IF(hr = 4,  total, 0)) hour4,
	MAX(IF(hr = 5,  total, 0)) hour5,
	MAX(IF(hr = 6,  total, 0)) hour6,
	MAX(IF(hr = 7,  total, 0)) hour7,
        MAX(IF(hr = 8,  total, 0)) hour8,
	MAX(IF(hr = 9,  total, 0)) hour9,
	MAX(IF(hr = 10, total, 0)) hour10,
	MAX(IF(hr = 11, total, 0)) hour11,
	MAX(IF(hr = 12, total, 0)) hour12,
	MAX(IF(hr = 13, total, 0)) hour13,
	MAX(IF(hr = 14, total, 0)) hour14,
	MAX(IF(hr = 15, total, 0)) hour15,
	MAX(IF(hr = 16, total, 0)) hour16,
	MAX(IF(hr = 17, total, 0)) hour17,
	MAX(IF(hr = 18, total, 0)) hour18,
	MAX(IF(hr = 19, total, 0)) hour19,
	MAX(IF(hr = 20, total, 0)) hour20,
        MAX(IF(hr = 21, total, 0)) hour21,
	MAX(IF(hr = 22, total, 0)) hour22,
	MAX(IF(hr = 23, total, 0)) hour23
from hourly1  group by 1;";

       
        $sth_rt = $v3->prepare($strgetstat);
        $sth_rt->execute();

        while (my @rowRst = $sth_rt->fetchrow())
                {
                        $i++;

                        for ( $f=0; $f <= 25; $f++)
                                {
                                $tab1->write($row+$i, $col+$f,    $rowRst[$f], ($i % 2 ==0)? $format_values11 : $format_values21);
                                }
                }




#tab 1
$tab2->write('a3','Date',$format_date);
$tab2->merge_range('b3:y3','H O U R ',$format2);


$tab2->write('b4',"0",$format3);
$tab2->write('c4',"1",$format3);
$tab2->write('d4',"2",$format3);
$tab2->write('e4',"3",$format3);
$tab2->write('f4',"4",$format3);
$tab2->write('g4',"5",$format3);
$tab2->write('h4',"6",$format3);
$tab2->write('i4',"7",$format3);
$tab2->write('j4',"8",$format3);
$tab2->write('k4',"9",$format3);
$tab2->write('l4',"10",$format3);
$tab2->write('m4',"11",$format3);
$tab2->write('n4',"12",$format3);
$tab2->write('o4',"13",$format3);
$tab2->write('p4',"14",$format3);
$tab2->write('q4',"15",$format3);
$tab2->write('r4',"16",$format3);
$tab2->write('s4',"17",$format3);
$tab2->write('t4',"18",$format3);
$tab2->write('u4',"19",$format3);
$tab2->write('v4',"20",$format3);
$tab2->write('w4',"21",$format3);
$tab2->write('x4',"22",$format3);
$tab2->write('y4',"23",$format3);



my $row=3;
my $i=0;
my $col=0;

$strgetstat="SELECT  datesent,
        MAX(IF(hr = 0,  total, 0)) hour0,
        MAX(IF(hr = 1,  total, 0)) hour1,
        MAX(IF(hr = 2,  total, 0)) hour2,
        MAX(IF(hr = 3,  total, 0)) hour3,
        MAX(IF(hr = 4,  total, 0)) hour4,
        MAX(IF(hr = 5,  total, 0)) hour5,
        MAX(IF(hr = 6,  total, 0)) hour6,
        MAX(IF(hr = 7,  total, 0)) hour7,
        MAX(IF(hr = 8,  total, 0)) hour8,
        MAX(IF(hr = 9,  total, 0)) hour9,
        MAX(IF(hr = 10, total, 0)) hour10,
        MAX(IF(hr = 11, total, 0)) hour11,
        MAX(IF(hr = 12, total, 0)) hour12,
        MAX(IF(hr = 13, total, 0)) hour13,
        MAX(IF(hr = 14, total, 0)) hour14,
        MAX(IF(hr = 15, total, 0)) hour15,
        MAX(IF(hr = 16, total, 0)) hour16,
        MAX(IF(hr = 17, total, 0)) hour17,
        MAX(IF(hr = 18, total, 0)) hour18,
        MAX(IF(hr = 19, total, 0)) hour19,
        MAX(IF(hr = 20, total, 0)) hour20,
        MAX(IF(hr = 21, total, 0)) hour21,
        MAX(IF(hr = 22, total, 0)) hour22,
        MAX(IF(hr = 23, total, 0)) hour23
from hourly1  group by 1;";


        $sth_rt = $v4->prepare($strgetstat);
                $sth_rt->execute();

                        while (my @rowRst = $sth_rt->fetchrow())
                                        {
                                            $i++;
                                           for ( $f=0; $f <= 25; $f++)
                                              {
                                                $tab2->write($row+$i, $col+$f,    $rowRst[$f], ($i % 2 ==0)? $format_values11 : $format_values21);
                                              }
                                        }


$workbook->close();
 binmode STDOUT;

$from = "Netcast_hourly_stats\@chikka.com";
#$to = "caparolma\@chikka.com,jomai\@chikka.com, ALBialoglovski\@smart.com.ph,dcjuat\@chikka.com";
#$cc = "dbadmins\@chikka.com ";
$to = "jojo\@chikka.com";
$cc = "dbadmins\@chikka.com ";
$Subject = "Netcast_hourly  Reports -  ".$tdate;

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
			<span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;"> Netcast houly Stats Report.</span></span></p>
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

