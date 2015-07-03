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


my $excel_file = "/home/dba_scripts/oist_stat/magic_text_stats_".$tdate.".xls";
print $excel_file;

my $magictext = DB::DBconnect(myconstants::magictext_DB,myconstants::magictext_HOST,myconstants::magictext_USER,myconstants::magictext_PASSWORD);
#my $v4 = DB::DBconnect(myconstants::netcast_DB1,myconstants::netcast_HOST,myconstants::netcast_USER,myconstants::netcast_PASSWORD);

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
 my $tab1 = $workbook->add_worksheet("PH SMART");
 my $tab2 = $workbook->add_worksheet("PH SUN");

#set columns and rows
$tab1->set_column('a:i',17);
$tab2->set_column('a:i',17);


#tab 1
$tab1->write('a4','Date',$format_date);
$tab1->merge_range('a3:i3','S M A R T',$format2);


$tab1->write('b4',"Success 1.00",$format3);
$tab1->write('c4',"Failed 1.00",$format3);
$tab1->write('d4',"Success .50",$format3);
$tab1->write('e4',"Failed .50",$format3);
$tab1->write('f4',"Free",$format3);
$tab1->write('g4',"Failed",$format3);
$tab1->write('h4',"Unique Recipient",$format3);
$tab1->write('i4',"Unique Sender",$format3);


my $row=3;
my $i=0;
my $col=0;

$strgetstat="select  tx_date,
 max(if((type = '1.00_success'),`bilang`,0)) AS `success_1`,
 max(if((type = '1.00_failed'),`bilang`,0)) AS `failed_1`,
 max(if((type = '0.50_success'),`bilang`,0)) AS `success_5`,
 max(if((type = '0.50_failed'),`bilang`,0)) AS `failed_5`,
 max(if((type = 'free_sms'), `bilang`,0)) AS `free`,
 max(if((type = 'failed'),`bilang`,0)) AS `failed`,
 max(if((type = 'unique_recipient'),`bilang`,0)) AS `uniq_recipient`,
 max(if((type = 'unique_sender'),`bilang`,0)) AS `uniq_sender`
 from `magic_text` where telco='PH_SMART' and  tx_date like '".$mdate."%' group by 1 order by tx_date;";

       
        $sth_rt = $magictext->prepare($strgetstat);
        $sth_rt->execute();

        while (my @rowRst = $sth_rt->fetchrow())
                {
                        $i++;

                        for ( $f=0; $f <= 8; $f++)
                                {
                                $tab1->write($row+$i, $col+$f,    $rowRst[$f], ($i % 2 ==0)? $format_values11 : $format_values21);
                                }
                }




#tab 1
$tab2->write('a4','Date',$format_date);
$tab2->merge_range('A3:i3','S U N ',$format2);

$tab2->write('b4',"Success 1.00",$format3);
$tab2->write('c4',"Failed 1.00",$format3);
$tab2->write('d4',"Success .50",$format3);
$tab2->write('e4',"Failed .50",$format3);
$tab2->write('f4',"Free",$format3);
$tab2->write('g4',"Failed",$format3);
$tab2->write('h4',"Unique Recipient",$format3);
$tab2->write('i4',"Unique Sender",$format3);



my $row=3;
my $i=0;
my $col=0;

$strgetstat="select  tx_date,
 max(if((type = '1.00_success'),`bilang`,0)) AS `success_1`,
 max(if((type = '1.00_failed'),`bilang`,0)) AS `failed_1`,
 max(if((type = '0.50_success'),`bilang`,0)) AS `success_5`,
 max(if((type = '0.50_failed'),`bilang`,0)) AS `failed_5`,
 max(if((type = 'free_sms'), `bilang`,0)) AS `free`,
 max(if((type = 'failed'),`bilang`,0)) AS `failed`,
 max(if((type = 'unique_recipient'),`bilang`,0)) AS `uniq_recipient`,
 max(if((type = 'unique_sender'),`bilang`,0)) AS `uniq_sender`
 from `magic_text` where telco='PH_SUN' and  tx_date like '".$mdate."%' group by 1 order by tx_date;";


        $sth_rt = $magictext->prepare($strgetstat);
                $sth_rt->execute();

                        while (my @rowRst = $sth_rt->fetchrow())
                                        {
                                            $i++;
                                           for ( $f=0; $f <= 8; $f++)
                                              {
                                                $tab2->write($row+$i, $col+$f,    $rowRst[$f], ($i % 2 ==0)? $format_values11 : $format_values21);
                                              }
                                        }


$workbook->close();
 binmode STDOUT;

$from = "MagicText_stats\@chikka.com";
$to = "caparolma\@chikka.com,jomai\@chikka.com ";
$cc = "dbadmins\@chikka.com,nbrinas\@chikka.com ";
#$to = "jojo\@chikka.com";
#$cc = "dbadmins\@chikka.com ";
$Subject = "Magic Text Stats Report -  ".$tdate;

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
			<span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;"> Magic Text Stats Report.</span></span></p>
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

