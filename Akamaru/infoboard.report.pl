#!/usr/bin/perl

use warnings;
use lib "/home/dba_scripts/oist_stat/Lib";
use common;
use myconstants;
use DB;
use Spreadsheet::WriteExcel;
use MIME::Lite;


#$current_date = $ARGV[0];
$current_date = '2014-11-27';
$txt_month = $ARGV[1];
#$vday=substr($current_date,8);
 

my $excel_file = "/home/dba_scripts/oist_stat/infoboard_Stats_".$current_date.".xls";
print $excel_file;

my $dbh_netcast = DB::DBconnect(myconstants::infoboard_DB,myconstants::infoboard_HOST,myconstants::infoboard_USER,myconstants::infoboard_PASSWORD);


#	$strgetstat="call sp_generate_netcast_stats('".$current_date."')";
#        $sth_netcast = $dbh_netcast->prepare($strgetstat);
#        $sth_netcast->execute();

                                                                   
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
my @service=('Broadcast','TextCast',' mo','feedback','ws','gw','mx','qp');
my $wrksht_cnt=0;
my $col=0;
foreach  $service(@service)
{
     # Add a worksheet
      $worksheet[$wrksht_cnt] = $workbook->add_worksheet($service);
     # set column
      $worksheet[$wrksht_cnt]->set_column('a:a',15);
      $worksheet[$wrksht_cnt]->set_column('b:al',8);
      
     # header
      $worksheet[$wrksht_cnt]->write(0,0,$service,$format2);
      $worksheet[$wrksht_cnt]->write('a2',"Date",$format3);
      
      for ( $f=1; $f <= 24; $f++)
       {
           $worksheet[$wrksht_cnt]->write(1, $f,    $f-1, $format3);
       }
         #  $worksheet[$wrksht_cnt]->write(1, $f, 'TOTAL', $format3);
      #write data
     	$strgetstat="SELECT  araw,
       max(IF(oras = 0,  bilang, 0)) hour0,
       max(IF(oras = 1,  bilang, 0)) hour1,
       max(IF(oras = 2,  bilang, 0)) hour2,
       max(IF(oras = 3,  bilang, 0)) hour3,
       max(IF(oras = 4,  bilang, 0)) hour4,
       max(IF(oras = 5,  bilang, 0)) hour5,
       max(IF(oras = 6,  bilang, 0)) hour6,
       max(IF(oras = 7,  bilang, 0)) hour7,
       max(IF(oras = 8,  bilang, 0)) hour8,
       max(IF(oras = 9,  bilang, 0)) hour9,
       max(IF(oras = 10, bilang, 0)) hour10,
       max(IF(oras = 11, bilang, 0)) hour11,
       max(IF(oras = 12, bilang, 0)) hour12,
       max(IF(oras = 13, bilang, 0)) hour13,
       max(IF(oras = 14, bilang, 0)) hour14,
       max(IF(oras = 15, bilang, 0)) hour15,
       max(IF(oras = 16, bilang, 0)) hour16,
       max(IF(oras = 17, bilang, 0)) hour17,
       max(IF(oras = 18, bilang, 0)) hour18,
       max(IF(oras = 19, bilang, 0)) hour19,
       max(IF(oras = 20, bilang, 0)) hour20,
       max(IF(oras = 21, bilang, 0)) hour21,
       max(IF(oras = 22, bilang, 0)) hour22,
       max(IF(oras = 23, bilang, 0)) hour23
 from stats_service_hour
 where araw >='2014-08-01' and araw <= '2014-11-27'
 and service='".$service."'
 group by araw  
 order by araw;";

        $sth_netcast = $dbh_netcast->prepare($strgetstat);
        $sth_netcast->execute();
      
        while ( @rowRst = $sth_netcast->fetchrow())
                {
                        $i++;

                        for ( $f=0; $f <= 24; $f++)
                                {
                                 if ($f==0) 
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
                       #  $worksheet[$wrksht_cnt]->write($row+$i, $col+$f,    $rowRst[36], ($i % 2 ==0)? $format_values11 : $format_values21);
                }
                    


	$row=1;
 	$i=0;
 	$col=0;
        $worksheet[$wrksht_cnt]->freeze_panes(2,1);
 	$wrksht_cnt++;
}
                                                               
$workbook->close();
 binmode STDOUT;

$from = "infoboard_stats\@chikka.com";
#$to = "caparolma\@chikka.com, mibraga\@chikka.com,zcabatuan\@chikka.com";
#$cc = "dbadmins\@chikka.com, ra\@chikka.com";
$to = "jojo\@chikka.com";
$cc = "jojo\@chikka.com";
$Subject = "Infoboard Daily per hour Stats, Sept to October 2014 ";

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">Infoboard Hourly Stats</span></span></p>
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


