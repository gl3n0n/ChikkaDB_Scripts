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

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_Retention_Stats_".$current_date.".xls";
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
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'), w7_days, w6_days, w5_days, w4_days, w3_days, w2_days, w1_days, new_users, wk_start 
               from powerapp_retention_stats 
               where left(tran_dt,7) = '".$current_date."' order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

# Add a worksheet
$worksheet = $workbook->add_worksheet("Weekly");

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
$worksheet->merge_range('B2:J2', 'WEEKLY Retention Stats', $format2);

$worksheet->set_column(0,0,9);
$worksheet->set_column(1,7,7);
$worksheet->set_column(8,8,8);
$worksheet->set_column(9,9,9);
#

$worksheet->write($row+$i, $col,    'DATE', $format);
$worksheet->write($row+$i, $col+1,  'Day 7', $format);
$worksheet->write($row+$i, $col+2,  'Day 6', $format);
$worksheet->write($row+$i, $col+3,  'Day 5', $format);
$worksheet->write($row+$i, $col+4,  'Day 4', $format);
$worksheet->write($row+$i, $col+5,  'Day 3', $format);
$worksheet->write($row+$i, $col+6,  'Day 2', $format);
$worksheet->write($row+$i, $col+7,  'Day 1', $format);
$worksheet->write($row+$i, $col+8,  'New MINs', $format);
$worksheet->write($row+$i, $col+9,  'START Date', $format);

while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0], $format1s);
   $worksheet->write($row+$i, $col+1,  $rowRst[1], $format1);
   $worksheet->write($row+$i, $col+2,  $rowRst[2], $format1);
   $worksheet->write($row+$i, $col+3,  $rowRst[3], $format1);
   $worksheet->write($row+$i, $col+4,  $rowRst[4], $format1);
   $worksheet->write($row+$i, $col+5,  $rowRst[5], $format1);
   $worksheet->write($row+$i, $col+6,  $rowRst[6], $format1);
   $worksheet->write($row+$i, $col+7,  $rowRst[7], $format1);
   $worksheet->write($row+$i, $col+8,  $rowRst[8], $format1);
   $worksheet->write($row+$i, $col+9,  $rowRst[9], $format1s);
}

###################################################
###################################################
###################################################
# 2nd Worksheet
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'), w31_days, w30_days, 
               w29_days, w28_days, w27_days, w26_days, w25_days, w24_days, w23_days, w22_days, w21_days, w20_days, 
               w19_days, w18_days, w17_days, w16_days, w15_days, w14_days, w13_days, w12_days, w11_days, w10_days, 
               w9_days, w8_days, w7_days, w6_days, w5_days, w4_days, w3_days, w2_days, w1_days, new_users, wk_start 
               from powerapp_retention_stats_monthly 
               where left(tran_dt,7) = '".$current_date."' order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

# Add a worksheet
$worksheet = $workbook->add_worksheet("Monthly");

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

$format1s = $workbook->add_format(); # Add a format
$format1s->set_font('Calibri');
$format1s->set_size('9');
$format1s->set_color('black');
$format1s->set_align('center');
$format1s->set_border(1);

$format2 = $workbook->add_format(bg_color => 'cyan'); # Add a format
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
$worksheet->merge_range('B2:AH2', 'MONTHLY Retention Stats', $format2);

$worksheet->set_column(0,0,8);
$worksheet->set_column(1,30,6);
$worksheet->set_column(31,32,8);
$worksheet->set_column(33,33,9);
#

$worksheet->write($row+$i, $col,     'DATE', $format);
$worksheet->write($row+$i, $col+1,   'Day 31', $format);
$worksheet->write($row+$i, $col+2,   'Day 30', $format);
$worksheet->write($row+$i, $col+3,   'Day 29', $format);
$worksheet->write($row+$i, $col+4,   'Day 28', $format);
$worksheet->write($row+$i, $col+5,   'Day 27', $format);
$worksheet->write($row+$i, $col+6,   'Day 26', $format);
$worksheet->write($row+$i, $col+7,   'Day 25', $format);
$worksheet->write($row+$i, $col+8,   'Day 24', $format);
$worksheet->write($row+$i, $col+9,   'Day 23', $format);
$worksheet->write($row+$i, $col+10,  'Day 22', $format);
$worksheet->write($row+$i, $col+11,  'Day 21', $format);
$worksheet->write($row+$i, $col+12,  'Day 20', $format);
$worksheet->write($row+$i, $col+13,  'Day 19', $format);
$worksheet->write($row+$i, $col+14,  'Day 18', $format);
$worksheet->write($row+$i, $col+15,  'Day 17', $format);
$worksheet->write($row+$i, $col+16,  'Day 16', $format);
$worksheet->write($row+$i, $col+17,  'Day 15', $format);
$worksheet->write($row+$i, $col+18,  'Day 14', $format);
$worksheet->write($row+$i, $col+19,  'Day 13', $format);
$worksheet->write($row+$i, $col+20,  'Day 12', $format);
$worksheet->write($row+$i, $col+21,  'Day 11', $format);
$worksheet->write($row+$i, $col+22,  'Day 10', $format);
$worksheet->write($row+$i, $col+23,  'Day 9',  $format);
$worksheet->write($row+$i, $col+24,  'Day 8',  $format);
$worksheet->write($row+$i, $col+25,  'Day 7',  $format);
$worksheet->write($row+$i, $col+26,  'Day 6',  $format);
$worksheet->write($row+$i, $col+27,  'Day 5',  $format);
$worksheet->write($row+$i, $col+28,  'Day 4',  $format);
$worksheet->write($row+$i, $col+29,  'Day 3',  $format);
$worksheet->write($row+$i, $col+30,  'Day 2',  $format);
$worksheet->write($row+$i, $col+31,  'Day 1',  $format);
$worksheet->write($row+$i, $col+32,  'New MINs', $format);
$worksheet->write($row+$i, $col+33,  'START Date', $format);

while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1s);
   $worksheet->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+2,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+3,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+4,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+5,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+6,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+7,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+8,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+9,  $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+10, $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+11, $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+12, $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+13, $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+14, $rowRst[14], $format1);
   $worksheet->write($row+$i, $col+15, $rowRst[15], $format1);
   $worksheet->write($row+$i, $col+16, $rowRst[16], $format1);
   $worksheet->write($row+$i, $col+17, $rowRst[17], $format1);
   $worksheet->write($row+$i, $col+18, $rowRst[18], $format1);
   $worksheet->write($row+$i, $col+19, $rowRst[19], $format1);
   $worksheet->write($row+$i, $col+20, $rowRst[20], $format1);
   $worksheet->write($row+$i, $col+21, $rowRst[21], $format1);
   $worksheet->write($row+$i, $col+22, $rowRst[22], $format1);
   $worksheet->write($row+$i, $col+23, $rowRst[23], $format1);
   $worksheet->write($row+$i, $col+24, $rowRst[24], $format1);
   $worksheet->write($row+$i, $col+25, $rowRst[25], $format1);
   $worksheet->write($row+$i, $col+26, $rowRst[26], $format1);
   $worksheet->write($row+$i, $col+27, $rowRst[27], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[28], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[29], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[30], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[31], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[32], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[33], $format1s);
}


$workbook->close();
 binmode STDOUT;

$from = "stats\@chikka.com";
$to = "victor\@chikka.com,jomai\@chikka.com";
#$to = "ps.java\@chikka.com,jomai\@chikka.com";
#$cc = "dbadmins\@chikka.com";
#$to = "glenon\@chikka.com";
$cc = "glenon\@chikka.com";
$Subject = "PowerApp Retention Stats , ".$current_day;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp Retention Stats for the Month of $txt_month.</span></span></p>
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



