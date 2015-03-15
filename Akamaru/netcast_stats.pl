#!/usr/bin/perl

use warnings;
use lib "/home/dba_scripts/oist_stat/Lib";
use common;
use myconstants;
use DB;
use Spreadsheet::WriteExcel;
use MIME::Lite;


$current_date = $ARGV[0];
$txt_month = $ARGV[1];
$vday=substr($current_date,8);
 

my $excel_file = "/home/dba_scripts/oist_stat/Netcast_Stats_".$current_date.".xls";
print $excel_file;

my $dbh_netcast = DB::DBconnect(myconstants::netcast_DB,myconstants::netcast_HOST,myconstants::netcast_USER,myconstants::netcast_PASSWORD);

#call stored proc
	$strgetstat="call sp_generate_netcast_stats('".$current_date."')";
        $sth_netcast = $dbh_netcast->prepare($strgetstat);
        $sth_netcast->execute();

                                                                   
# Create a new Excel workbook
 my $workbook = Spreadsheet::WriteExcel->new($excel_file);
 $workbook->set_custom_color(60, '#0066CC'       );
 $workbook->set_custom_color(61, '#99CCFF'       );
 $workbook->set_custom_color(62, '#CCFFFF'       );
 my $sth_RT;
 my @rowRst;
# formats
$format2 = $workbook->add_format(fg_color => 60,bold=>0,font=>'Calibri',size=>11,color=>'white',align=>'center',valign=>'vcenter',border=>1,);
$format3 = $workbook->add_format(fg_color => 60,bold=>0,font=>'Calibri',size=>11,color=>'white',align=>'center',valign=>'vcenter',border=>1,);
$format_values1 = $workbook->add_format(fg_color => 61,bold=>0,font=>'Calibri',size=>11,color=>'black',align=>'left',valign=>'vcenter',border=>1,);
$format_values2 = $workbook->add_format(fg_color => 62,bold=>0,font=>'Calibri',size=>11,color=>'black',align=>'left',valign=>'vcenter',border=>1,);
$format_values11 = $workbook->add_format(fg_color => 61,bold=>0,font=>'Calibri',size=>11,color=>'black',align=>'right',valign=>'vcenter',border=>1,);
$format_values21 = $workbook->add_format(fg_color => 62,bold=>0,font=>'Calibri',size=>11,color=>'black',align=>'right',valign=>'vcenter',border=>1,);


my $row=1;
my $i=0;
my @telco=('SMART','GLOBE','SUN');
my $wrksht_cnt=0;
my $col=0;
foreach  $telco(@telco)
{
     # Add a worksheet
      $worksheet[$wrksht_cnt] = $workbook->add_worksheet($telco);
     # set column
      $worksheet[$wrksht_cnt]->set_column('a:a',10);
      $worksheet[$wrksht_cnt]->set_column('b:b',45);
      $worksheet[$wrksht_cnt]->set_column('c:c',15);
      $worksheet[$wrksht_cnt]->set_column('d:d',12);
      $worksheet[$wrksht_cnt]->set_column('e:e',30);
      $worksheet[$wrksht_cnt]->set_column('f:al',8);
      
     # header
      $worksheet[$wrksht_cnt]->write(0,0,$txt_month,$format2);
      $worksheet[$wrksht_cnt]->write('a2',"ID",$format3);
      $worksheet[$wrksht_cnt]->write('b2',"Name",$format3);
      $worksheet[$wrksht_cnt]->write('c2',"Virtual No.",$format3);
      $worksheet[$wrksht_cnt]->write('d2',"Type",$format3);
      $worksheet[$wrksht_cnt]->write('e2',"Suffix",$format3);
      
      for ( $f=1; $f <= $vday; $f++)
       {
           $worksheet[$wrksht_cnt]->write(1, $f+4,    $f, $format3);
       }
           $worksheet[$wrksht_cnt]->write(1, $f+4, 'TOTAL', $format3);
      #write data
     	$strgetstat="SELECT company_id, company_name, virtual_no, account_type, suffix,
                             day01,day02,day03,day04,day05,day06,day07,day08,day09,day10,
                             day11,day12,day13,day14,day15,day16,day17,day18,day19,day20,
                             day21,day22,day23,day24,day25,day26,day27,day28,day29,day30,day31,
                             day01+day02+day03+day04+day05+day06+day07+day08+day09+day10+
                             day11+day12+day13+day14+day15+day16+day17+day18+day19+day20+
                             day21+day22+day23+day24+day25+day26+day27+day28+day29+day30+day31 t_days
		    FROM  excelview_stats_dtl_companies1
	            WHERE carrier='".$telco."' and yr_month='".$txt_month."'
	            ORDER BY company_name desc";

        $sth_netcast = $dbh_netcast->prepare($strgetstat);
        $sth_netcast->execute();
      
        while ( @rowRst = $sth_netcast->fetchrow())
                {
                        $i++;

                        for ( $f=0; $f <= $vday+4; $f++)
                                {
                                 if ($f <=4) 
                                    {
                                	$worksheet[$wrksht_cnt]->write_string($row+$i, $col+$f,    $rowRst[$f], ($i % 2 ==0)? $format_values1 : $format_values2);
                                    }
                                 else
                                    {
                                       $worksheet[$wrksht_cnt]->write($row+$i, $col+$f,    $rowRst[$f], ($i % 2 ==0)? $format_values11 : $format_values21);
                                    }  
                                }
                         #Total per company(t_days)
                         #$worksheet[$wrksht_cnt]->write(1, $f,    "Total", $format3);
                         $worksheet[$wrksht_cnt]->write($row+$i, $col+$f,    $rowRst[36], ($i % 2 ==0)? $format_values11 : $format_values21);
                }
                    


	$row=1;
 	$i=0;
 	$col=0;
        $worksheet[$wrksht_cnt]->freeze_panes(2,5);
 	$wrksht_cnt++;
}
                                                               
$workbook->close();
 binmode STDOUT;

$from = "netcast_stats\@chikka.com";
#$to = "caparolma\@chikka.com, mibraga\@chikka.com,zcabatuan\@chikka.com";
#$cc = "dbadmins\@chikka.com, ra\@chikka.com";
$to = "jojo\@chikka.com";
$cc = "jojo\@chikka.com";
$Subject = "Netcast Stats, ".$current_date;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">Netcast  Stats for the Month of $txt_month.</span></span></p>
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


