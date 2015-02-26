#!/usr/bin/perl

use warnings;
use lib "/home/dba_scripts/oist_stat/Lib";
use common;
use myconstants;
use DB;

use Spreadsheet::WriteExcel;
use MIME::Lite;

my $current_date = "";
my $current_day = "";

$current_date = $ARGV[0];
$current_day = $ARGV[1];
$txt_month = $ARGV[2];

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_Usage_Stats_".$current_date.".xls";
print $excel_file;

my $dbh_hi10 = DB::DBconnect(myconstants::HI10_DB,myconstants::HI10_HOST,myconstants::HI10_USER,myconstants::HI10_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
my $strMain;
my @mainRst;
my $sth_hi_10;
my @rowRst;
my @nRowCtr;

# Add a worksheet[0]
$strMain  = "select 0 seq_no, 'Summary' service, 'Summary' service_desc union 
             select 1 seq_no, service, replace(service, 'Service', '') service_desc from powerapp_plan_services_mapping order by 1,2,3";
$sth_main = $dbh_hi10->prepare($strMain);                                                                                                  
$sth_main->execute();
$nRowCtr=0;
while (@mainRst = $sth_main->fetchrow()) {
   print "$nRowCtr - @mainRst[0] - @mainRst[1] - @mainRst[2]\n";
   $worksheet[$nRowCtr] = $workbook->add_worksheet("@mainRst[2]");
   $nRowCtr++;
}

# formats
#  Add and define a format
$format = $workbook->add_format(bg_color => 'silver'); # Add a format
$format->set_bold();
$format->set_font('Calibri');
$format->set_size('9');
$format->set_color('black');
$format->set_align('center');
$format->set_border(2);

$format1 = $workbook->add_format(); # Add a format
$format1->set_font('Calibri');
$format1->set_size('9');
$format1->set_color('black');
$format1->set_align('right');
$format1->set_border(1);
$format1->set_num_format('###,###,###,##0');

$format1p = $workbook->add_format(); # Add a format
$format1p->set_font('Calibri');
$format1p->set_size('9');
$format1p->set_color('black');
$format1p->set_align('right');
$format1p->set_border(1);
$format1p->set_num_format('###,###,###,##0.00');


$format2 = $workbook->add_format(bg_color => 'yellow'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('11');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(2);

$format21R = $workbook->add_format(bg_color => 'cyan'); # Add a format
$format21R->set_bold();
$format21R->set_font('Calibri');
$format21R->set_size('11');
$format21R->set_color('black');
$format21R->set_align('center');
$format21R->set_border(2);

$format3 = $workbook->add_format(bg_color => 'silver'); # Add a format
$format3->set_bold();
$format3->set_font('Calibri');
$format3->set_size('11');
$format3->set_color('black');
$format3->set_align('center');
$format3->set_border(2);

# generate worksheets
$strMain  = "select 0 seq_no, 'Summary' service, 'SUMMARY' service_desc union select 1 seq_no, service, upper(replace(service, 'Service', '')) service_desc from powerapp_plan_services_mapping order by 1,2,3";
$sth_main = $dbh_hi10->prepare($strMain);                                                                                                  
$sth_main->execute();
$nRowCtr=0;
while (@mainRst = $sth_main->fetchrow()) {
   if (@mainRst[0] == 0) {
      $strSQLhi10 = "select DATE_FORMAT(a.datein,'%m/%d/%Y') datein,
                            sum(a.download) download, sum(a.upload) upload, sum(c.no_buys) no_buys, sum(b.count) uniq, round(sum(a.download+a.upload)/1000000,2) total_mb,
                            round((sum(a.download+a.upload)/1000000) / sum(b.count),2) avg_total,
                            round((sum(a.download)/1000000) / sum(b.count),2) avg_download
                     from   usage_per_plan a, unique_subs b, buys_per_plan c
                     where  a.datein  = b.datein 
                     and    a.service = b.service 
                     and    a.datein  = c.datein 
                     and    a.service = c.service 
                     and    b.datein  = c.datein 
                     and    b.service = c.service 
                     and    b.type='RX'
                     and    left(a.datein,7) = '".$current_date."'
                     group  by a.datein
                     order  by a.datein";
   }else{
      $strSQLhi10 = "select DATE_FORMAT(a.datein,'%m/%d/%Y') datein,
                            a.download download, a.upload upload, c.no_buys no_buys, b.count uniq, round((a.download+a.upload)/1000000,2) total_mb,
                            round(((a.download+a.upload)/1000000)/c.no_buys,2) avg_total,
                            round((a.download/1000000)/c.no_buys,2) avg_download
                     from   usage_per_plan a, unique_subs b, buys_per_plan c
                     where  a.datein  = b.datein 
                     and    a.service = b.service 
                     and    a.datein  = c.datein 
                     and    a.service = c.service 
                     and    b.datein  = c.datein 
                     and    b.service = c.service 
                     and    b.type='RX'
                     and    a.service = '".@mainRst[1]."'
                     and    left(a.datein,7) = '".$current_date."'
                     order  by a.datein";
   }
   print "$strSQLhi10\n";
   $sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);                                                                                                  
   $sth_hi_10->execute();

   # Write a formatted and unformatted string, row and column notation.
   $worksheet[$nRowCtr]->merge_range('B2:H2', @mainRst[2], $format2);
   $worksheet[$nRowCtr]->write(2, 1, 'Download',     $format21R);
   $worksheet[$nRowCtr]->write(2, 2, 'Upload',       $format21R);
   $worksheet[$nRowCtr]->write(2, 3, 'Buys',         $format21R);
   $worksheet[$nRowCtr]->write(2, 4, 'Uniq',         $format21R);
   $worksheet[$nRowCtr]->write(2, 5, 'Total Usage',  $format21R);
   $worksheet[$nRowCtr]->write(2, 6, 'Average Usage',$format21R);
   $worksheet[$nRowCtr]->write(2, 7, 'Avg Download', $format21R);
   $worksheet[$nRowCtr]->write(3, 0, 'Date',         $format3);
   $worksheet[$nRowCtr]->write(3, 1, '(bytes)',      $format3);
   $worksheet[$nRowCtr]->write(3, 2, '(bytes)',      $format3);
   $worksheet[$nRowCtr]->write(3, 3, '(txn)',        $format3);
   $worksheet[$nRowCtr]->write(3, 4, '(MINs)',        $format3);
   $worksheet[$nRowCtr]->write(3, 5, '(mb)',         $format3);
   $worksheet[$nRowCtr]->write(3, 6, '(mb)',         $format3);
   $worksheet[$nRowCtr]->write(3, 7, '(mb)',         $format3);
   $worksheet[$nRowCtr]->set_column(0,0,9);
   $worksheet[$nRowCtr]->set_column(1,2,14);
   $worksheet[$nRowCtr]->set_column(3,4,10);
   $worksheet[$nRowCtr]->set_column(5,7,14);

   $row = 2;
   $col = 0;
   $i=1;

   while (@rowRst = $sth_hi_10->fetchrow()) {
      $i++;
      $worksheet[$nRowCtr]->write($row+$i, $col,    $rowRst[0],  $format1);
      $worksheet[$nRowCtr]->write($row+$i, $col+1,  $rowRst[1],  $format1);
      $worksheet[$nRowCtr]->write($row+$i, $col+2,  $rowRst[2],  $format1);
      $worksheet[$nRowCtr]->write($row+$i, $col+3,  $rowRst[3],  $format1);
      $worksheet[$nRowCtr]->write($row+$i, $col+4,  $rowRst[4],  $format1);
      $worksheet[$nRowCtr]->write($row+$i, $col+5,  $rowRst[5],  $format1p);
      $worksheet[$nRowCtr]->write($row+$i, $col+6,  $rowRst[6],  $format1p);
      $worksheet[$nRowCtr]->write($row+$i, $col+7,  $rowRst[7],  $format1p);
   }
   $nRowCtr++;
}

$workbook->close();
 binmode STDOUT;

$from = "powerapp_stats\@chikka.com";
$to = "victor\@chikka.com";
$cc = "dbadmins\@chikka.com";
#$to = "glenon\@chikka.com";
#$cc = "glenon\@chikka.com";
$Subject = "PowerApp Usage Stats, ".$current_day;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp Usage Stats for the Month of $txt_month.</span></span></p>
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


