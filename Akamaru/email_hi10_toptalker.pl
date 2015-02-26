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

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_TopTalker_".$current_date.".xls";
print $excel_file;

my $dbh_hi10 = DB::DBconnect(myconstants::HI10A_DB,myconstants::HI10A_HOST,myconstants::HI10A_USER,myconstants::HI10A_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
my $strMain;
my @mainRst;
my $sth_hi_10;
my @rowRst;
my @nRowCtr;

# Add a worksheet[0]
$strMain  = "select 0 seq_no, 'TOP TALKER' service, 'TopTalker' service_desc union 
             select 1 seq_no, 'w/o BUYS' service, 'woBuys' service_desc order by 1,2,3";
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
$format1p->set_align('left');
$format1p->set_border(1);

$format1n = $workbook->add_format(); # Add a format
$format1n->set_font('Calibri');
$format1n->set_size('9');
$format1n->set_color('black');
$format1n->set_align('center');
$format1n->set_border(1);
$format1n->set_num_format('###############0');

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
$strMain  = "select 0 seq_no, 'TOP TALKER' service, 'TopTalker' service_desc union 
             select 1 seq_no, 'w/o BUYS' service, 'woBuys' service_desc order by 1,2,3";
$sth_main = $dbh_hi10->prepare($strMain);                                                                                                  
$sth_main->execute();
$nRowCtr=0;
while (@mainRst = $sth_main->fetchrow()) {
   if (@mainRst[0] == 0) {
      $strSQLhi10 = "select phone, tx_usage, max(buys) buys, max(services) services from (
                     select a.phone, a.tx_usage, 
                            group_concat(concat(b.plan, ':', b.hits) separator ' ^ ') buys, 
                            null services
                     from powerapp_nds_toptalker a 
                     left outer join powerapp_nds_toptalker_buys b on a.tx_date=b.tx_date and a.phone = b.phone 
                     where a.tx_date = '".$current_day."'
                     group by 1,2 
                     union
                     select a.phone, a.tx_usage, 
                            null buys, 
                            group_concat(concat(c.service , ':', c.tx_usage) separator ' ^ ') services
                     from powerapp_nds_toptalker a 
                     left outer join powerapp_nds_toptalker_services c on a.tx_date=c.tx_date and a.phone = c.phone  
                     where a.tx_date = '".$current_day."'
                     group by 1,2 
                     ) t1
                     group by phone, tx_usage
                     order by tx_usage desc,phone limit 20";
   }else{
      $strSQLhi10 = "select phone, tx_usage, max(buys) buys, max(services) services from (
                     select a.phone, a.tx_usage, 
                            group_concat(concat(b.plan, ':', b.hits) separator ' ^ ') buys, 
                            null services
                     from powerapp_nds_toptalker a 
                     left outer join powerapp_nds_toptalker_buys b on a.tx_date=b.tx_date and a.phone = b.phone 
                     where a.tx_date = '".$current_day."'
                     group by 1,2 
                     union
                     select a.phone, a.tx_usage, 
                            null buys, 
                            group_concat(concat(c.service , ':', c.tx_usage) separator ' ^ ') services
                     from powerapp_nds_toptalker a 
                     left outer join powerapp_nds_toptalker_services c on a.tx_date=c.tx_date and a.phone = c.phone  
                     where a.tx_date = '".$current_day."'
                     group by 1,2 
                     ) t1
                     group by phone, tx_usage
                     having max(buys) is null
                     order by tx_usage desc,phone limit 20";
   }
   print "$strSQLhi10\n";
   $sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);                                                                                                  
   $sth_hi_10->execute();

   # Write a formatted and unformatted string, row and column notation.
   $worksheet[$nRowCtr]->merge_range('B2:E2', @mainRst[1], $format2);
   $worksheet[$nRowCtr]->write(2, 1, 'Phone',     $format21R);
   $worksheet[$nRowCtr]->write(2, 2, 'Usage',     $format21R);
   $worksheet[$nRowCtr]->write(2, 3, 'Buys',      $format21R);
   $worksheet[$nRowCtr]->write(2, 4, 'Services',  $format21R);
   $worksheet[$nRowCtr]->write(3, 1, '',        $format3);
   $worksheet[$nRowCtr]->write(3, 2, '(bytes)', $format3);
   $worksheet[$nRowCtr]->write(3, 3, '(txn)',   $format3);
   $worksheet[$nRowCtr]->write(3, 4, '',        $format3);
   $worksheet[$nRowCtr]->set_column(0,0,9);
   $worksheet[$nRowCtr]->set_column(1,2,14);
   $worksheet[$nRowCtr]->set_column(3,3,30);
   $worksheet[$nRowCtr]->set_column(4,4,80);

   $row = 2;
   $col = 0;
   $i=1;

   while (@rowRst = $sth_hi_10->fetchrow()) {
      $i++;
      $worksheet[$nRowCtr]->write($row+$i, $col+1,  $rowRst[0],  $format1n);
      $worksheet[$nRowCtr]->write($row+$i, $col+2,  $rowRst[1],  $format1);
      $worksheet[$nRowCtr]->write($row+$i, $col+3,  $rowRst[2],  $format1p);
      $worksheet[$nRowCtr]->write($row+$i, $col+4,  $rowRst[3],  $format1p);
   }
   $nRowCtr++;
}

$workbook->close();
 binmode STDOUT;

$from = "powerapp_stats\@chikka.com";
$to = "glenon\@chikka.com";
$cc = "dbadmins\@chikka.com";
#$to = "glenon\@chikka.com";
#$cc = "glenon\@chikka.com";
$Subject = "PowerApp Top Talker, ".$current_day;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp Top Talker for $current_day.</span></span></p>
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


