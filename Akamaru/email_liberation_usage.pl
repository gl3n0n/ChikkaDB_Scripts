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

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_Liberation_Usage_".$current_day.".xls";
print $excel_file;

#my $dbh_hi10 = DB::DBconnect(myconstants::HI10_DB,myconstants::HI10_HOST,myconstants::HI10_USER,myconstants::HI10_PASSWORD);
my $dbh_hi10 = DB::DBconnect(myconstants::HI10A_DB,myconstants::HI10A_HOST,myconstants::HI10A_USER,myconstants::HI10A_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);

my $sth_hi_10;
my @rowRst;


# START: Worksheet
$worksheet[0] = $workbook->add_worksheet("wUsage");
$worksheet[1] = $workbook->add_worksheet("woUsage");

#  Add and define a format
$format = $workbook->add_format(bg_color => 'gray'); # Add a format
$format->set_bold();
$format->set_font('Calibri');
$format->set_size('9');
$format->set_color('black');
$format->set_align('center');
$format->set_border(1);

$format1 = $workbook->add_format(); # Add a format
$format1->set_font('Calibri');
$format1->set_size('9');
$format1->set_color('black');
$format1->set_align('right');
$format1->set_border(1);
$format1->set_num_format('#,##0');

$format1s = $workbook->add_format(); # Add a format
$format1s->set_font('Calibri');
$format1s->set_size('9');
$format1s->set_color('black');
$format1s->set_align('left');
$format1s->set_border(1);
$format1s->set_num_format('###########');

$formatT = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatT->set_bold();
$formatT->set_font('Calibri');
$formatT->set_size('8');
$formatT->set_color('black');
$formatT->set_align('right');
$formatT->set_border(1);
$formatT->set_num_format('#,##0');

$formatC = $workbook->add_format(bg_color => 'green'); # Add a format
$formatC->set_bold();
$formatC->set_font('Calibri');
$formatC->set_size('10');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);



$strSQLhi10 = "select phone, transmitted, received, transmitted+received total_usage
                from  tmp_liberation_usage
                where tx_date = '".$current_day."' and (transmitted+received) > 0 order by 3 desc";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Write a formatted and unformatted string, row and column notation.
$row = 0;
$col = 0;
$i=1;
$worksheet[0]->merge_range($row,$col,$row,$col+3, 'LIBERATION USAGE', $formatC);
$worksheet[0]->set_column(0, 3, 12);
$worksheet[0]->write($row+$i, $col,   'PHONE', $format);
$worksheet[0]->write($row+$i, $col+1, 'TRANSMITTED', $format);
$worksheet[0]->write($row+$i, $col+2, 'RECEIVED', $format);
$worksheet[0]->write($row+$i, $col+3, 'TOTAL', $format);

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[0]->write($row+$i, $col,    $rowRst[0], $format1s);
   $worksheet[0]->write($row+$i, $col+1,  $rowRst[1], $format1);
   $worksheet[0]->write($row+$i, $col+2,  $rowRst[2], $format1);
   $worksheet[0]->write($row+$i, $col+3,  $rowRst[3], $formatT);
   if ($i == 65530) {
      $i = 1;
      $col = $col + 5;
      $worksheet[0]->set_column($col-1, $col-1, 1);
      $worksheet[0]->set_column($col, $col+3, 12);
      $worksheet[0]->merge_range($row,$col,$row,$col+3, 'LIBERATION USAGE', $formatC);
      $worksheet[0]->write($row+$i, $col,   'PHONE', $format);
      $worksheet[0]->write($row+$i, $col+1, 'TRANSMITTED', $format);
      $worksheet[0]->write($row+$i, $col+2, 'RECEIVED', $format);
      $worksheet[0]->write($row+$i, $col+3, 'TOTAL', $format);
   }
}


$strSQLhi10 = "select phone from  tmp_liberation_usage
                where tx_date = '".$current_day."' and (transmitted+received) = 0 and phone like '63%' order by phone";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

# Write a formatted and unformatted string, row and column notation.
$row = 0;
$col = 0;
$i=1;
$worksheet[1]->set_column($col, $col, 12);
$worksheet[1]->write($row+$i, $col, 'PHONE', $format);
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col,    $rowRst[0], $format1s);
   if ($i == 65530) {
      $i = 1;
      $col = $col + 2;
      $worksheet[1]->set_column($col-1, $col-1, 1);
      $worksheet[1]->set_column($col, $col, 12);
      $worksheet[1]->write($row+$i, $col, 'PHONE', $format);
   }
}



$workbook->close();
 binmode STDOUT;

$from = "stats\@chikka.com";
$to = "jomai\@chikka.com,ps.java\@chikka.com,ra\@chikka.com";
$to = "glenon\@chikka.com";
$cc = "glenon\@chikka.com";
$Subject = "PowerApp Liberation Usage, ".$current_day;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp Liberation Usage for $current_day.</span></span></p>
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
# $msg->send; # send via default

