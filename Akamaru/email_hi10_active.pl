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

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_Active_Stats_".$current_date.".xls";
print $excel_file;

my $dbh_hi10 = DB::DBconnect(myconstants::HI10A_DB,myconstants::HI10A_HOST,myconstants::HI10A_USER,myconstants::HI10A_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
my $sth_hi_10;
my @rowRst;

# Run Storedproc
#$strSQLhi10 = "call sp_generate_retention_main()";
#$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
#$sth_hi_10->execute();


# 1st Worksheet
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'), no_active, no_inactive, total_subs, pct_active, pct_inactive 
               from powerapp_active_stats 
               where left(tran_dt,7) = '".$current_date."' and plan='ALL' and tran_tm='00:00:00' order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

# Add a worksheet
$worksheet = $workbook->add_worksheet($txt_month);

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
$format1->set_num_format('#,###,##0');

$format1p = $workbook->add_format(); # Add a format
$format1p->set_font('Calibri');
$format1p->set_size('9');
$format1p->set_color('black');
$format1p->set_align('right');
$format1p->set_border(1);
$format1p->set_num_format('##0.00');

$format1s = $workbook->add_format(); # Add a format
$format1s->set_font('Calibri');
$format1s->set_size('9');
$format1s->set_color('black');
$format1s->set_align('center');
$format1s->set_border(1);

$format2 = $workbook->add_format(bg_color => 'silver'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('11');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(2);

# Write a formatted and unformatted string, row and column notation.
$row = 1;
$col = 0;
$i=1;
$worksheet->merge_range('B2:F2', 'POWERAPP ACTIVE Stats', $format2);

$worksheet->set_column(0,0,10);
$worksheet->set_column(1,3,10);
$worksheet->set_column(8,8,8);
$worksheet->set_column(9,9,8);
#

$worksheet->write($row+$i, $col,    'DATE', $format);
$worksheet->write($row+$i, $col+1,  'No. Active', $format);
$worksheet->write($row+$i, $col+2,  'No. Inactive', $format);
$worksheet->write($row+$i, $col+3,  'Total MINs', $format);
$worksheet->write($row+$i, $col+4,  '% Active', $format);
$worksheet->write($row+$i, $col+5,  '% Inactive', $format);

while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0], $format1s);
   $worksheet->write($row+$i, $col+1,  $rowRst[1], $format1);
   $worksheet->write($row+$i, $col+2,  $rowRst[2], $format1);
   $worksheet->write($row+$i, $col+3,  $rowRst[3], $format1);
   $worksheet->write($row+$i, $col+4,  $rowRst[4], $format1p);
   $worksheet->write($row+$i, $col+5,  $rowRst[5], $format1p);
}

$workbook->close();
 binmode STDOUT;

$from = "stats\@chikka.com";
$to = "victor\@chikka.com,jomai\@chikka.com";
#$to = "ps.java\@chikka.com,jomai\@chikka.com";
$cc = "dbadmins\@chikka.com";
#$to = "glenon\@chikka.com";
#$cc = "glenon\@chikka.com";
$Subject = "PowerApp Active Stats , ".$current_day;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp Active Stats for the Month of $txt_month.</span></span></p>
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



