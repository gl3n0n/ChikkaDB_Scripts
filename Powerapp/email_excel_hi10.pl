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

my $excel_file = "/home/dba_scripts/oist_stat/hi10_stats_".$current_date.".xls";
print $excel_file;

my $dbh_hi10 = DB::DBconnect(myconstants::HI10_DB,myconstants::HI10_HOST,myconstants::HI10_USER,myconstants::HI10_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);

my $sth_hi_10;

#$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'), unli_hits, email_hits, chat_hits, photo_hits, social_hits, speed_hits, unli_uniq, email_uniq, chat_uniq, photo_uniq, social_uniq, speed_uniq, total_hits, total_uniq from powerapp_daily_report where tran_mm = left(date_sub(curdate(), interval 1 day), 7)";

$strSQLhi10 = "select DATE_FORMAT(a.tran_dt,'%m/%d/%Y'), a.unli_hits, a.email_hits, a.chat_hits, a.photo_hits, a.social_hits, a.speed_hits, a.unli_uniq, a.email_uniq, a.chat_uniq, a.photo_uniq, a.social_uniq, a.speed_uniq, a.total_hits, a.total_uniq, IFNULL(b.num_subs,0) from powerapp_dailyrep a left outer join powerapp_concurrent_subs b on a.tran_dt = b.tran_dt where left(a.tran_dt,7) = '".$current_date."'";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();



# Add a worksheet
$worksheet = $workbook->add_worksheet($txt_month);


#  Add and define a format
$format = $workbook->add_format(); # Add a format
$format->set_bold();
$format->set_font('Calibri');
$format->set_size('9');
$format->set_color('black');
$format->set_align('center');
$format->set_border(2);

$format1 = $workbook->add_format(); # Add a format
#$format1->set_bold();
$format1->set_font('Calibri');
$format1->set_size('9');
$format1->set_color('black');
$format1->set_align('right');
$format1->set_border(1);

$format2 = $workbook->add_format(); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(2);

$format3 = $workbook->add_format(); # Add a format
$format3->set_bold();
$format3->set_font('Calibri');
$format3->set_size('9');
$format3->set_color('black');
$format3->set_align('center');
$format3->set_border(2);

$worksheet->set_column(20,20,20);

# Write a formatted and unformatted string, row and column notation.
$row = 0;
$col = 0;
$worksheet->merge_range('B1:G1', 'Hits per Package', $format2);
$worksheet->merge_range('J1:O1', 'Unique Subs per Package', $format2);
$worksheet->merge_range('Q1:R1', 'Total Hits per Day', $format2);
$worksheet->merge_range('T1:U1', 'Concurrent Subs per Day', $format2);
#

$worksheet->set_column(0,19,10);

$i=0;

$worksheet->write($row+$i, $col, 'DATE', $format);
$worksheet->write($row+$i, $col+1, 'UNLI', $format);
$worksheet->write($row+$i, $col+2, 'EMAIL', $format);
$worksheet->write($row+$i, $col+3, 'CHAT', $format);
$worksheet->write($row+$i, $col+4, 'PHOTO', $format);
$worksheet->write($row+$i, $col+5, 'SOCIAL', $format);
$worksheet->write($row+$i, $col+6, 'SPEEDBOOST', $format);
$worksheet->write($row+$i, $col+8, 'DATE', $format);
$worksheet->write($row+$i, $col+9, 'UNLI', $format);
$worksheet->write($row+$i, $col+10, 'EMAIL', $format);
$worksheet->write($row+$i, $col+11, 'CHAT', $format);
$worksheet->write($row+$i, $col+12, 'PHOTO', $format);
$worksheet->write($row+$i, $col+13, 'SOCIAL', $format);
$worksheet->write($row+$i, $col+14, 'SPEEDBOOST', $format);
$worksheet->write($row+$i, $col+16, 'DATE', $format);
$worksheet->write($row+$i, $col+17, 'TOTAL', $format);
$worksheet->write($row+$i, $col+19, 'DATE', $format);
$worksheet->write($row+$i, $col+20, 'TOTAL', $format);



my @rowRst;

while (@rowRst = $sth_hi_10->fetchrow()) {

$i++;
$worksheet->write($row+$i, $col, $rowRst[0], $format1);
$worksheet->write($row+$i, $col+1, $rowRst[1], $format1);
$worksheet->write($row+$i, $col+2, $rowRst[2], $format1);
$worksheet->write($row+$i, $col+3, $rowRst[3], $format1);
$worksheet->write($row+$i, $col+4, $rowRst[4], $format1);
$worksheet->write($row+$i, $col+5, $rowRst[5], $format1);
$worksheet->write($row+$i, $col+6, $rowRst[6], $format1);
$worksheet->write($row+$i, $col+8, $rowRst[0], $format1);
$worksheet->write($row+$i, $col+9, $rowRst[7], $format1);
$worksheet->write($row+$i, $col+10, $rowRst[8], $format1);
$worksheet->write($row+$i, $col+11, $rowRst[9], $format1);
$worksheet->write($row+$i, $col+12, $rowRst[10], $format1);
$worksheet->write($row+$i, $col+13, $rowRst[11], $format1);
$worksheet->write($row+$i, $col+14, $rowRst[12], $format1);
$worksheet->write($row+$i, $col+16, $rowRst[0], $format1);
$worksheet->write($row+$i, $col+17, $rowRst[13], $format1);
$worksheet->write($row+$i, $col+19, $rowRst[0], $format1);
$worksheet->write($row+$i, $col+20, $rowRst[15], $format1);


        }



$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%b %Y'), num_subs from powerapp_concurrent_subs b where exists (select 1 from (select date_format(tran_dt, '%b %Y') month_, max(tran_dt) tran_dt from powerapp_concurrent_subs group by 1) t1 where b.tran_dt = t1.tran_dt) ";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

$i++;
$i++;
$i++;
$i++;

$worksheet->write($row+$i, $col, 'MONTH', $format);
$worksheet->write($row+$i, $col+1, 'UNIQUE SUBS', $format);

my @rowRst;

while (@rowRst = $sth_hi_10->fetchrow()) {

$i++;
$worksheet->write($row+$i, $col, $rowRst[0], $format1);
$worksheet->write($row+$i, $col+1, $rowRst[1], $format1);
}



$workbook->close();
 binmode STDOUT;

$from = "do-not-reply\@chikka.com";
$to = "glenon\@chikka.com";
$cc = "glenon\@chikka.com";
$Subject = "HI-10 Stats , ".$current_day;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">HI-10 Stats for the Month of $txt_month.</span></span></p>
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
