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

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_TopTalker_".$current_day.".xls";
print $excel_file;

my $dbh_hi10 = DB::DBconnect(myconstants::HI10A_DB,myconstants::HI10A_HOST,myconstants::HI10A_USER,myconstants::HI10A_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
my $strMain;
my @mainRst;
my $sth_hi_10n;
my $sth_hi_10u;
my @rowRstn;
my @rowRstu;
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
$format1p->set_text_wrap();

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
      $strSQLhi10n = "select phone, tx_usage, max(buys) buys, max(services) services from (
                     select a.phone, a.tx_usage, 
                            IFNULL(group_concat(concat(b.plan, ':', b.hits) separator ' ^ '), 
                                   (select group_concat(concat('(', e.plan, ':', e.hits, ')') separator ' ^ ')
                                   from   powerapp_udr_toptalker_buys e where a.phone=e.phone and e.tx_date = date_sub('".$current_day."', interval 1 day))
                                   ) buys, 
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

      $strSQLhi10u = "select phone, tx_usage, max(buys) buys, max(services) services, nds_usage from (
                     select a.phone, b.tx_usage, 
                            IFNULL(group_concat(concat(c.plan, ':', c.hits) separator ' ^ '), 
                                   (select group_concat(concat('(', e.plan, ':', e.hits, ')') separator ' ^ ')
                                   from   powerapp_udr_toptalker_buys e where a.phone=e.phone and e.tx_date = date_sub('".$current_day."', interval 1 day))
                                   ) buys, 
                            null services, a.tx_usage nds_usage
                     from powerapp_nds_toptalker a 
                     left outer join powerapp_udr_toptalker b on a.tx_date=b.tx_date and a.phone = b.phone 
                     left outer join powerapp_udr_toptalker_buys c on b.tx_date=c.tx_date and b.phone = c.phone 
                     where a.tx_date = '".$current_day."'
                     and   exists (select 1 from (select tx_date, phone, tx_usage from powerapp_nds_toptalker 
                                            where tx_date = '".$current_day."' 
                                            order by tx_usage desc limit 20
                                           ) d 
                             where a.tx_date=d.tx_date and a.phone = d.phone) 
                     group by a.phone, b.tx_usage, a.tx_usage
                     union
                     select a.phone, b.tx_usage, 
                            null buys, 
                            group_concat(concat(c.service , ':', c.tx_usage) separator ' ^ ') services,
                            a.tx_usage nds_usage
                     from powerapp_nds_toptalker a 
                     left outer join powerapp_udr_toptalker b on a.tx_date=b.tx_date and a.phone = b.phone 
                     left outer join powerapp_udr_toptalker_services c on b.tx_date=c.tx_date and b.phone = c.phone  
                     where a.tx_date = '".$current_day."'
                     and   exists (select 1 from (select tx_date, phone, tx_usage from powerapp_nds_toptalker 
                                                  where tx_date = '".$current_day."' 
                                                  order by tx_usage desc limit 20
                                                 ) d 
                                   where a.tx_date=d.tx_date and a.phone = d.phone) 
                     group by a.phone, b.tx_usage, a.tx_usage
                     ) t1
                     group by phone, tx_usage
                     order by nds_usage desc, phone limit 20";

   }else{
      $strSQLhi10n = "select phone, tx_usage, null buys, max(services) services from (
                     select a.phone, a.tx_usage, 
                            null buys, 
                            group_concat(concat(c.service , ':', c.tx_usage) separator ' ^ ') services
                     from powerapp_nds_toptalker a 
                     inner join powerapp_udr_toptalker b on a.tx_date=b.tx_date and a.phone = b.phone and b.w_buys = 0 and b.w_plan is null
                     left outer join powerapp_nds_toptalker_services c on a.tx_date=c.tx_date and a.phone = c.phone  
                     where a.tx_date = '".$current_day."'
                     group by 1,2 
                     ) t1
                     group by phone, tx_usage
                     order by tx_usage desc,phone limit 20";

      $strSQLhi10u = "select phone, udr_usage, null buys, max(services) services, tx_usage from (
                     select a.phone, a.tx_usage, 
                            null buys, 
                            group_concat(concat(c.service , ':', c.tx_usage) separator ' ^ ') services, b.tx_usage udr_usage
                     from powerapp_nds_toptalker a 
                     inner join powerapp_udr_toptalker b on a.tx_date=b.tx_date and a.phone = b.phone and b.w_buys = 0 and b.w_plan is null
                     left outer join powerapp_udr_toptalker_services c on a.tx_date=c.tx_date and a.phone = c.phone
                     where a.tx_date = '".$current_day."'
                     group by 1,2 
                     ) t1
                     group by phone, udr_usage, tx_usage
                     order by tx_usage desc,phone limit 20";
   }
   print "$strSQLhi10n\n";
   print "$strSQLhi10u\n";
   $sth_hi_10n = $dbh_hi10->prepare($strSQLhi10n);  
   $sth_hi_10n->execute();
   $sth_hi_10u = $dbh_hi10->prepare($strSQLhi10u);
   $sth_hi_10u->execute();

   # Write a formatted and unformatted string, row and column notation.
   $worksheet[$nRowCtr]->merge_range('B2:E2', @mainRst[1]." - NDS", $format2);
   $worksheet[$nRowCtr]->merge_range('G2:J2', @mainRst[1]." - UDR", $format2);
   $worksheet[$nRowCtr]->write(2, 1, 'Phone',     $format21R);
   $worksheet[$nRowCtr]->write(2, 2, 'Usage',     $format21R);
   $worksheet[$nRowCtr]->write(2, 3, 'Buys',      $format21R);
   $worksheet[$nRowCtr]->write(2, 4, 'Services',  $format21R);
   $worksheet[$nRowCtr]->write(2, 6, 'Phone',     $format21R);
   $worksheet[$nRowCtr]->write(2, 7, 'Usage',     $format21R);
   $worksheet[$nRowCtr]->write(2, 8, 'Buys',      $format21R);
   $worksheet[$nRowCtr]->write(2, 9, 'Services',  $format21R);
   $worksheet[$nRowCtr]->write(3, 1, '',        $format3);
   $worksheet[$nRowCtr]->write(3, 2, '(bytes)', $format3);
   $worksheet[$nRowCtr]->write(3, 3, '(txn)',   $format3);
   $worksheet[$nRowCtr]->write(3, 4, '',        $format3);
   $worksheet[$nRowCtr]->write(3, 6, '',        $format3);
   $worksheet[$nRowCtr]->write(3, 7, '(bytes)', $format3);
   $worksheet[$nRowCtr]->write(3, 8, '(txn)',   $format3);
   $worksheet[$nRowCtr]->write(3, 9, '',        $format3);
   $worksheet[$nRowCtr]->set_column(0,0,9);
   $worksheet[$nRowCtr]->set_column(1,2,14);
   $worksheet[$nRowCtr]->set_column(3,3,30);
   $worksheet[$nRowCtr]->set_column(4,4,80);
   $worksheet[$nRowCtr]->set_column(5,5,2);
   $worksheet[$nRowCtr]->set_column(6,7,14);
   $worksheet[$nRowCtr]->set_column(8,8,30);
   $worksheet[$nRowCtr]->set_column(9,9,80);

   $row = 2;
   $col = 0;
   $i=1;
   while (@rowRstn = $sth_hi_10n->fetchrow()) {
      $i++;
      $worksheet[$nRowCtr]->write($row+$i, $col+1,  $rowRstn[0],  $format1n);
      $worksheet[$nRowCtr]->write($row+$i, $col+2,  $rowRstn[1],  $format1);
      $worksheet[$nRowCtr]->write($row+$i, $col+3,  $rowRstn[2],  $format1p);
      $worksheet[$nRowCtr]->write($row+$i, $col+4,  $rowRstn[3],  $format1p);
   }

   $i=1;
   while (@rowRstu = $sth_hi_10u->fetchrow()) {
      $i++;
      $worksheet[$nRowCtr]->write($row+$i, $col+6,  $rowRstu[0],  $format1n);
      $worksheet[$nRowCtr]->write($row+$i, $col+7,  $rowRstu[1],  $format1);
      $worksheet[$nRowCtr]->write($row+$i, $col+8,  $rowRstu[2],  $format1p);
      $worksheet[$nRowCtr]->write($row+$i, $col+9,  $rowRstu[3],  $format1p);
   }
   $nRowCtr++;
}

$workbook->close();
 binmode STDOUT;

$from = "powerapp_stats\@chikka.com";
$to = "victor\@chikka.com";
$cc = "dbadmins\@chikka.com,nbrinas\@chikka.com";
$to = "glenon\@chikka.com";
$cc = "glenon\@chikka.com";
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



