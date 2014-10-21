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

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_Act_N_Ret_Stats_".$current_date.".xls";
print $excel_file;

my $dbh_hi10 = DB::DBconnect(myconstants::HI10A_DB,myconstants::HI10A_HOST,myconstants::HI10A_USER,myconstants::HI10A_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
my $sth_hi_10;
my @rowRst;


###################################################
# 1st Worksheet
###################################################
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, 
                      new_subs, new_old, no_active, no_inactive, total_subs, pct_active, pct_inactive, 
                      pre_active, pre_inactive, (pre_active+pre_inactive) pre_total, round((pre_active/(pre_active+pre_inactive))*100,0) pre_pct_active, round((pre_inactive/(pre_active+pre_inactive))*100,0) pct_inactive, 
                      tnt_active, tnt_inactive, (tnt_active+tnt_inactive) tnt_total, round((tnt_active/(tnt_active+tnt_inactive))*100,0) tnt_pct_active, round((tnt_inactive/(tnt_active+tnt_inactive))*100,0) pct_inactive, 
                      ppd_active, ppd_inactive, (ppd_active+ppd_inactive) ppd_total, round((ppd_active/(ppd_active+ppd_inactive))*100,0) ppd_pct_active, round((ppd_inactive/(ppd_active+ppd_inactive))*100,0) pct_inactive
               from powerapp_active_stats 
               where left(tran_dt,7) = '".$current_date."' and plan='ALL' and tran_tm='00:00:00' order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

# Add a worksheet
$worksheet = $workbook->add_worksheet("ActiveStats");

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
$worksheet->merge_range('B2:H2', 'POWERAPP ACTIVE Stats', $format2);
$worksheet->merge_range('J2:N2', 'PREPAID', $format2);
$worksheet->merge_range('P2:T2', 'TNT', $format2);
$worksheet->merge_range('V2:Z2', 'POSTPAID', $format2);

$worksheet->set_column(0,0,9);
$worksheet->set_column(3,3,8);
$worksheet->set_column(4,4,9);
$worksheet->set_column(5,7,8);
$worksheet->set_column(8,8,1);
$worksheet->set_column(9,9,8);
$worksheet->set_column(10,10,9);
$worksheet->set_column(11,13,8);
$worksheet->set_column(14,14,1);
$worksheet->set_column(15,15,8);
$worksheet->set_column(16,16,9);
$worksheet->set_column(17,19,8);
$worksheet->set_column(20,20,1);
$worksheet->set_column(21,21,8);
$worksheet->set_column(22,22,9);
$worksheet->set_column(23,25,8);
#

$worksheet->write($row+$i, $col,     'DATE',         $format);
$worksheet->write($row+$i, $col+ 1,  'New MINs',     $format);
$worksheet->write($row+$i, $col+ 2,  'New OLD',      $format);
$worksheet->write($row+$i, $col+ 3,  'No. Active',   $format);
$worksheet->write($row+$i, $col+ 4,  'No. Inactive', $format);
$worksheet->write($row+$i, $col+ 5,  'Total MINs',   $format);
$worksheet->write($row+$i, $col+ 6,  '% Active',     $format);
$worksheet->write($row+$i, $col+ 7,  '% Inactive',   $format);
$worksheet->write($row+$i, $col+ 9,  'No. Active',   $format);
$worksheet->write($row+$i, $col+10,  'No. Inactive', $format);
$worksheet->write($row+$i, $col+11,  'Total MINs',   $format);
$worksheet->write($row+$i, $col+12,  '% Active',     $format);
$worksheet->write($row+$i, $col+13,  '% Inactive',   $format);
$worksheet->write($row+$i, $col+15,  'No. Active',   $format);
$worksheet->write($row+$i, $col+16,  'No. Inactive', $format);
$worksheet->write($row+$i, $col+17,  'Total MINs',   $format);
$worksheet->write($row+$i, $col+18,  '% Active',     $format);
$worksheet->write($row+$i, $col+19,  '% Inactive',   $format);
$worksheet->write($row+$i, $col+21,  'No. Active',   $format);
$worksheet->write($row+$i, $col+22,  'No. Inactive', $format);
$worksheet->write($row+$i, $col+23,  'Total MINs',   $format);
$worksheet->write($row+$i, $col+24,  '% Active',     $format);
$worksheet->write($row+$i, $col+25,  '% Inactive',   $format);

while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,     $rowRst[0],  $format1s);
   $worksheet->write($row+$i, $col+ 1,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+ 2,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+ 3,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+ 4,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+ 5,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+ 6,  $rowRst[6],  $format1p);
   $worksheet->write($row+$i, $col+ 7,  $rowRst[7],  $format1p);
   $worksheet->write($row+$i, $col+ 9,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+10,  $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+11,  $rowRst[10],  $format1);
   $worksheet->write($row+$i, $col+12,  $rowRst[11],  $format1p);
   $worksheet->write($row+$i, $col+13,  $rowRst[12], $format1p);
   $worksheet->write($row+$i, $col+15,  $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+16,  $rowRst[14], $format1);
   $worksheet->write($row+$i, $col+17,  $rowRst[15], $format1);
   $worksheet->write($row+$i, $col+18,  $rowRst[16], $format1p);
   $worksheet->write($row+$i, $col+19,  $rowRst[17], $format1p);
   $worksheet->write($row+$i, $col+21,  $rowRst[18], $format1);
   $worksheet->write($row+$i, $col+22,  $rowRst[19], $format1);
   $worksheet->write($row+$i, $col+23,  $rowRst[20], $format1);
   $worksheet->write($row+$i, $col+24,  $rowRst[21], $format1p);
   $worksheet->write($row+$i, $col+25,  $rowRst[22], $format1p);
}


# Run Storedproc
#$strSQLhi10 = "call sp_generate_retention_main()";
#$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
#$sth_hi_10->execute();


###################################################
# 2nd Worksheet
###################################################
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'), w7_days, w6_days, w5_days, w4_days, w3_days, w2_days, w1_days, 
                      old_users, new_users, wk_start,
                      round((w7_days/(w7_days+w6_days+w5_days+w4_days+w3_days+w2_days+w1_days))*100,2) w7_pct,
                      round((w6_days/(w7_days+w6_days+w5_days+w4_days+w3_days+w2_days+w1_days))*100,2) w6_pct,
                      round((w5_days/(w7_days+w6_days+w5_days+w4_days+w3_days+w2_days+w1_days))*100,2) w5_pct,
                      round((w4_days/(w7_days+w6_days+w5_days+w4_days+w3_days+w2_days+w1_days))*100,2) w4_pct,
                      round((w3_days/(w7_days+w6_days+w5_days+w4_days+w3_days+w2_days+w1_days))*100,2) w3_pct,
                      round((w2_days/(w7_days+w6_days+w5_days+w4_days+w3_days+w2_days+w1_days))*100,2) w2_pct,
                      round((w1_days/(w7_days+w6_days+w5_days+w4_days+w3_days+w2_days+w1_days))*100,2) w1_pct,
                      round((old_users/(w7_days+w6_days+w5_days+w4_days+w3_days+w2_days+w1_days))*100,2) newold_pct,
                      round((new_users/(w7_days+w6_days+w5_days+w4_days+w3_days+w2_days+w1_days))*100,2) newuser_pct 
               from powerapp_retention_stats 
               where left(tran_dt,7) = '".$current_date."' order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

# Add a worksheet
$worksheet = $workbook->add_worksheet("Weekly Retention");

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

$format1d = $workbook->add_format(); # Add a format
$format1d->set_font('Calibri');
$format1d->set_size('9');
$format1d->set_color('black');
$format1d->set_align('right');
$format1d->set_border(1);
$format1d->set_num_format('##0.00');

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
$worksheet->merge_range('B2:K2', 'WEEKLY Retention Stats', $format2);
$worksheet->merge_range('M2:U2', 'WEEKLY Retention Percentage', $format2);

$worksheet->set_column(0,0,9);
$worksheet->set_column(1,7,7);
$worksheet->set_column(8,8,8);
$worksheet->set_column(9,10,9);
$worksheet->set_column(11,11,1);
$worksheet->set_column(12,18,7);
$worksheet->set_column(19,20,11);
#

$worksheet->write($row+$i, $col,    'DATE',          $format);
$worksheet->write($row+$i, $col+1,  'Day 7',         $format);
$worksheet->write($row+$i, $col+2,  'Day 6',         $format);
$worksheet->write($row+$i, $col+3,  'Day 5',         $format);
$worksheet->write($row+$i, $col+4,  'Day 4',         $format);
$worksheet->write($row+$i, $col+5,  'Day 3',         $format);
$worksheet->write($row+$i, $col+6,  'Day 2',         $format);
$worksheet->write($row+$i, $col+7,  'Day 1',         $format);
$worksheet->write($row+$i, $col+8,  'New OLD',       $format);
$worksheet->write($row+$i, $col+9,  'New MINs',      $format);
$worksheet->write($row+$i, $col+10,  'START Date',   $format);
$worksheet->write($row+$i, $col+12,  'D7 (%)',       $format);
$worksheet->write($row+$i, $col+13,  'D6 (%)',       $format);
$worksheet->write($row+$i, $col+14,  'D5 (%)',       $format);
$worksheet->write($row+$i, $col+15,  'D4 (%)',       $format);
$worksheet->write($row+$i, $col+16,  'D3 (%)',       $format);
$worksheet->write($row+$i, $col+17,  'D2 (%)',       $format);
$worksheet->write($row+$i, $col+18,  'D1 (%)',       $format);
$worksheet->write($row+$i, $col+19,  'New OLD (%)',  $format);
$worksheet->write($row+$i, $col+20,  'New MINs (%)', $format);

while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,     $rowRst[0],  $format1s);
   $worksheet->write($row+$i, $col+1,   $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+2,   $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+3,   $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+4,   $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+5,   $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+6,   $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+7,   $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+8,   $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+9,   $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+10,  $rowRst[10], $format1s);
   $worksheet->write($row+$i, $col+12,  $rowRst[11], $format1d);
   $worksheet->write($row+$i, $col+13,  $rowRst[12], $format1d);
   $worksheet->write($row+$i, $col+14,  $rowRst[13], $format1d);
   $worksheet->write($row+$i, $col+15,  $rowRst[14], $format1d);
   $worksheet->write($row+$i, $col+16,  $rowRst[15], $format1d);
   $worksheet->write($row+$i, $col+17,  $rowRst[16], $format1d);
   $worksheet->write($row+$i, $col+18,  $rowRst[17], $format1d);
   $worksheet->write($row+$i, $col+19,  $rowRst[18], $format1d);
   $worksheet->write($row+$i, $col+20,  $rowRst[19], $format1d);
}

###################################################
# 3rd Worksheet
###################################################
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'), 
                      w15_days, w14_days, w13_days, w12_days, w11_days, w10_days, w09_days, w08_days, 
                      w07_days, w06_days, w05_days, w04_days, w03_days, w02_days, w01_days, new_old, new_users, wk_start,
                      round((w15_days/w_total)*100,2) w15_pct,
                      round((w14_days/w_total)*100,2) w14_pct,
                      round((w13_days/w_total)*100,2) w13_pct,
                      round((w12_days/w_total)*100,2) w12_pct,
                      round((w11_days/w_total)*100,2) w11_pct,
                      round((w10_days/w_total)*100,2) w10_pct,
                      round((w09_days/w_total)*100,2) w09_pct,
                      round((w08_days/w_total)*100,2) w08_pct,
                      round((w07_days/w_total)*100,2) w07_pct,
                      round((w06_days/w_total)*100,2) w06_pct,
                      round((w05_days/w_total)*100,2) w05_pct,
                      round((w04_days/w_total)*100,2) w04_pct,
                      round((w03_days/w_total)*100,2) w03_pct,
                      round((w02_days/w_total)*100,2) w02_pct,
                      round((w01_days/w_total)*100,2) w01_pct,
                      round((new_old /w_total)*100,2) newold_pct,
                      round((new_users/w_total)*100,2) newuser_pct 
               from powerapp_15day_retention_stats 
               where left(tran_dt,7) = '".$current_date."' order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

# Add a worksheet
$worksheet = $workbook->add_worksheet("15Day Retention");

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

$format1d = $workbook->add_format(); # Add a format
$format1d->set_font('Calibri');
$format1d->set_size('9');
$format1d->set_color('black');
$format1d->set_align('right');
$format1d->set_border(1);
$format1d->set_num_format('##0.00');

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
$worksheet->merge_range('B2:S2',  '15Day Retention Stats',      $format2);
$worksheet->merge_range('U2:AK2', '15Day Retention Percentage', $format2);

$worksheet->set_column(0,0,9);
$worksheet->set_column(1,15,7);
$worksheet->set_column(16,17,8);
$worksheet->set_column(18,18,9);
$worksheet->set_column(19,19,1);
$worksheet->set_column(20,34,7);
$worksheet->set_column(35,36,11);
#

$worksheet->write($row+$i, $col,     'DATE',         $format);
$worksheet->write($row+$i, $col+ 1,  'Day 15',       $format);
$worksheet->write($row+$i, $col+ 2,  'Day 14',       $format);
$worksheet->write($row+$i, $col+ 3,  'Day 13',       $format);
$worksheet->write($row+$i, $col+ 4,  'Day 12',       $format);
$worksheet->write($row+$i, $col+ 5,  'Day 11',       $format);
$worksheet->write($row+$i, $col+ 6,  'Day 10',       $format);
$worksheet->write($row+$i, $col+ 7,  'Day 9',        $format);
$worksheet->write($row+$i, $col+ 8,  'Day 8',        $format);
$worksheet->write($row+$i, $col+ 9,  'Day 7',        $format);
$worksheet->write($row+$i, $col+10,  'Day 6',        $format);
$worksheet->write($row+$i, $col+11,  'Day 5',        $format);
$worksheet->write($row+$i, $col+12,  'Day 4',        $format);
$worksheet->write($row+$i, $col+13,  'Day 3',        $format);
$worksheet->write($row+$i, $col+14,  'Day 2',        $format);
$worksheet->write($row+$i, $col+15,  'Day 1',        $format);
$worksheet->write($row+$i, $col+16,  'New OLD',      $format);
$worksheet->write($row+$i, $col+17,  'New MINs',     $format);
$worksheet->write($row+$i, $col+18,  'START Date',   $format);
$worksheet->write($row+$i, $col+20,  'D15 (%)',      $format);
$worksheet->write($row+$i, $col+21,  'D14 (%)',      $format);
$worksheet->write($row+$i, $col+22,  'D13 (%)',      $format);
$worksheet->write($row+$i, $col+23,  'D12 (%)',      $format);
$worksheet->write($row+$i, $col+24,  'D11 (%)',      $format);
$worksheet->write($row+$i, $col+25,  'D10 (%)',      $format);
$worksheet->write($row+$i, $col+26,  'D9 (%)',       $format);
$worksheet->write($row+$i, $col+27,  'D8 (%)',       $format);
$worksheet->write($row+$i, $col+28,  'D7 (%)',       $format);
$worksheet->write($row+$i, $col+29,  'D6 (%)',       $format);
$worksheet->write($row+$i, $col+30,  'D5 (%)',       $format);
$worksheet->write($row+$i, $col+31,  'D4 (%)',       $format);
$worksheet->write($row+$i, $col+32,  'D3 (%)',       $format);
$worksheet->write($row+$i, $col+33,  'D2 (%)',       $format);
$worksheet->write($row+$i, $col+34,  'D1 (%)',       $format);
$worksheet->write($row+$i, $col+35,  'New OLD (%)',  $format);
$worksheet->write($row+$i, $col+36,  'New MINs (%)', $format);

while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,     $rowRst[0],  $format1s);
   $worksheet->write($row+$i, $col+ 1,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+ 2,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+ 3,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+ 4,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+ 5,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+ 6,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+ 7,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+ 8,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+ 9,  $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+10,  $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+11,  $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+12,  $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+13,  $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+14,  $rowRst[14], $format1);
   $worksheet->write($row+$i, $col+15,  $rowRst[15], $format1);
   $worksheet->write($row+$i, $col+16,  $rowRst[16], $format1);
   $worksheet->write($row+$i, $col+17,  $rowRst[17], $format1);
   $worksheet->write($row+$i, $col+18,  $rowRst[18], $format1s);
   $worksheet->write($row+$i, $col+20,  $rowRst[19], $format1d);
   $worksheet->write($row+$i, $col+21,  $rowRst[20], $format1d);
   $worksheet->write($row+$i, $col+22,  $rowRst[21], $format1d);
   $worksheet->write($row+$i, $col+23,  $rowRst[22], $format1d);
   $worksheet->write($row+$i, $col+24,  $rowRst[23], $format1d);
   $worksheet->write($row+$i, $col+25,  $rowRst[24], $format1d);
   $worksheet->write($row+$i, $col+26,  $rowRst[25], $format1d);
   $worksheet->write($row+$i, $col+27,  $rowRst[26], $format1d);
   $worksheet->write($row+$i, $col+28,  $rowRst[27], $format1d);
   $worksheet->write($row+$i, $col+29,  $rowRst[28], $format1d);
   $worksheet->write($row+$i, $col+30,  $rowRst[29], $format1d);
   $worksheet->write($row+$i, $col+31,  $rowRst[30], $format1d);
   $worksheet->write($row+$i, $col+32,  $rowRst[31], $format1d);
   $worksheet->write($row+$i, $col+33,  $rowRst[32], $format1d);
   $worksheet->write($row+$i, $col+34,  $rowRst[33], $format1d);
   $worksheet->write($row+$i, $col+35,  $rowRst[34], $format1d);
   $worksheet->write($row+$i, $col+36,  $rowRst[35], $format1d);
}                                  
                                   


###################################################
# 4th Worksheet
###################################################

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'), w31_days, w30_days, 
               w29_days, w28_days, w27_days, w26_days, w25_days, w24_days, w23_days, w22_days, w21_days, w20_days, 
               w19_days, w18_days, w17_days, w16_days, w15_days, w14_days, w13_days, w12_days, w11_days, w10_days, 
               w9_days, w8_days, w7_days, w6_days, w5_days, w4_days, w3_days, w2_days, w1_days, new_old, new_users, wk_start 
               from powerapp_retention_stats_monthly 
               where left(tran_dt,7) = '".$current_date."' order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

# Add a worksheet
$worksheet = $workbook->add_worksheet("Monthly Retention");

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
$worksheet->merge_range('B2:AI2', 'MONTHLY Retention Stats', $format2);

$worksheet->set_column(0,0,8);
$worksheet->set_column(1,30,6);
$worksheet->set_column(31,33,8);
$worksheet->set_column(34,34,9);
#

$worksheet->write($row+$i, $col,     'DATE',       $format);
$worksheet->write($row+$i, $col+1,   'Day 31',     $format);
$worksheet->write($row+$i, $col+2,   'Day 30',     $format);
$worksheet->write($row+$i, $col+3,   'Day 29',     $format);
$worksheet->write($row+$i, $col+4,   'Day 28',     $format);
$worksheet->write($row+$i, $col+5,   'Day 27',     $format);
$worksheet->write($row+$i, $col+6,   'Day 26',     $format);
$worksheet->write($row+$i, $col+7,   'Day 25',     $format);
$worksheet->write($row+$i, $col+8,   'Day 24',     $format);
$worksheet->write($row+$i, $col+9,   'Day 23',     $format);
$worksheet->write($row+$i, $col+10,  'Day 22',     $format);
$worksheet->write($row+$i, $col+11,  'Day 21',     $format);
$worksheet->write($row+$i, $col+12,  'Day 20',     $format);
$worksheet->write($row+$i, $col+13,  'Day 19',     $format);
$worksheet->write($row+$i, $col+14,  'Day 18',     $format);
$worksheet->write($row+$i, $col+15,  'Day 17',     $format);
$worksheet->write($row+$i, $col+16,  'Day 16',     $format);
$worksheet->write($row+$i, $col+17,  'Day 15',     $format);
$worksheet->write($row+$i, $col+18,  'Day 14',     $format);
$worksheet->write($row+$i, $col+19,  'Day 13',     $format);
$worksheet->write($row+$i, $col+20,  'Day 12',     $format);
$worksheet->write($row+$i, $col+21,  'Day 11',     $format);
$worksheet->write($row+$i, $col+22,  'Day 10',     $format);
$worksheet->write($row+$i, $col+23,  'Day 9',      $format);
$worksheet->write($row+$i, $col+24,  'Day 8',      $format);
$worksheet->write($row+$i, $col+25,  'Day 7',      $format);
$worksheet->write($row+$i, $col+26,  'Day 6',      $format);
$worksheet->write($row+$i, $col+27,  'Day 5',      $format);
$worksheet->write($row+$i, $col+28,  'Day 4',      $format);
$worksheet->write($row+$i, $col+29,  'Day 3',      $format);
$worksheet->write($row+$i, $col+30,  'Day 2',      $format);
$worksheet->write($row+$i, $col+31,  'Day 1',      $format);
$worksheet->write($row+$i, $col+32,  'New OLD',    $format);
$worksheet->write($row+$i, $col+33,  'New MINs',   $format);
$worksheet->write($row+$i, $col+34,  'START Date', $format);

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
   $worksheet->write($row+$i, $col+33, $rowRst[33], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[34], $format1s);
}


###################################################
# 5th Worksheet
###################################################
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y'), new_mins, 
                      day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_retention 
               where left(tx_date,7) = '".$current_date."' order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

# Add a worksheet
$worksheet = $workbook->add_worksheet("NEW MINs Retention");

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

$format1d = $workbook->add_format(); # Add a format
$format1d->set_font('Calibri');
$format1d->set_size('9');
$format1d->set_color('black');
$format1d->set_align('right');
$format1d->set_border(1);
$format1d->set_num_format('##0.00');

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
$worksheet->merge_range('B2:H2',   'NEW MINs Retention Stats', $format2);
$worksheet->merge_range('J2:O2',   'NEW MINs Retention Percentage', $format2);
$worksheet->merge_range('Q2:AE2',  'FACEBOOK New MINs Retention', $format2);
$worksheet->merge_range('AG2:AU2', 'SOCIAL New MINs Retention', $format2);
$worksheet->merge_range('AW2:BK2', 'FREE_SOCIAL New MINs Retention', $format2);
$worksheet->merge_range('BM2:CA2', 'SPEEDBOOST New MINs Retention', $format2);

$worksheet->set_column(0,0,9);
$worksheet->set_column(1,1,8);
$worksheet->set_column(2,7,7);
$worksheet->set_column(8,8,1);
$worksheet->set_column(9,14,6);
$worksheet->set_column(15,15,1);
$worksheet->set_column(16,22,6);
$worksheet->set_column(23,23,1);
$worksheet->set_column(24,30,5);
$worksheet->set_column(31,31,1);
$worksheet->set_column(32,38,6);
$worksheet->set_column(39,39,1);
$worksheet->set_column(40,46,5);
$worksheet->set_column(47,47,1);
$worksheet->set_column(48,54,6);
$worksheet->set_column(55,55,1);
$worksheet->set_column(56,62,5);
$worksheet->set_column(63,63,1);
$worksheet->set_column(65,70,6);
$worksheet->set_column(71,71,1);
$worksheet->set_column(72,78,6);
$worksheet->set_column(79,79,1);
#

$worksheet->write($row+$i, $col,     'DATE',      $format);
$worksheet->write($row+$i, $col+1,   'New MINs',  $format);
$worksheet->write($row+$i, $col+2,   'Day 2',     $format);
$worksheet->write($row+$i, $col+3,   'Day 3',     $format);
$worksheet->write($row+$i, $col+4,   'Day 4',     $format);
$worksheet->write($row+$i, $col+5,   'Day 5',     $format);
$worksheet->write($row+$i, $col+6,   'Day 6',     $format);
$worksheet->write($row+$i, $col+7,   'Day 7',     $format);
$worksheet->write($row+$i, $col+9,   'D2(%)',     $format);
$worksheet->write($row+$i, $col+10,  'D3(%)',     $format);
$worksheet->write($row+$i, $col+11,  'D4(%)',     $format);
$worksheet->write($row+$i, $col+12,  'D5(%)',     $format);
$worksheet->write($row+$i, $col+13,  'D6(%)',     $format);
$worksheet->write($row+$i, $col+14,  'D7(%)',     $format);
#FACEBOOK
$worksheet->write($row+$i, $col+16,  'Day 1',     $format);
$worksheet->write($row+$i, $col+17,  'Day 2',     $format);
$worksheet->write($row+$i, $col+18,  'Day 3',     $format);
$worksheet->write($row+$i, $col+19,  'Day 4',     $format);
$worksheet->write($row+$i, $col+20,  'Day 5',     $format);
$worksheet->write($row+$i, $col+21,  'Day 6',     $format);
$worksheet->write($row+$i, $col+22,  'Day 7',     $format);
$worksheet->write($row+$i, $col+24,  'D1(%)',     $format);
$worksheet->write($row+$i, $col+25,  'D2(%)',     $format);
$worksheet->write($row+$i, $col+26,  'D3(%)',     $format);
$worksheet->write($row+$i, $col+27,  'D4(%)',     $format);
$worksheet->write($row+$i, $col+28,  'D5(%)',     $format);
$worksheet->write($row+$i, $col+29,  'D6(%)',     $format);
$worksheet->write($row+$i, $col+30,  'D7(%)',     $format);
#SOCIAL
$worksheet->write($row+$i, $col+32,  'Day 1',      $format);
$worksheet->write($row+$i, $col+33,  'Day 2',     $format);
$worksheet->write($row+$i, $col+34,  'Day 3',     $format);
$worksheet->write($row+$i, $col+35,  'Day 4',     $format);
$worksheet->write($row+$i, $col+36,  'Day 5',     $format);
$worksheet->write($row+$i, $col+37,  'Day 6',     $format);
$worksheet->write($row+$i, $col+38,  'Day 7',     $format);
$worksheet->write($row+$i, $col+40,  'D1(%)',     $format);
$worksheet->write($row+$i, $col+41,  'D2(%)',     $format);
$worksheet->write($row+$i, $col+42,  'D3(%)',     $format);
$worksheet->write($row+$i, $col+43,  'D4(%)',     $format);
$worksheet->write($row+$i, $col+44,  'D5(%)',     $format);
$worksheet->write($row+$i, $col+45,  'D6(%)',     $format);
$worksheet->write($row+$i, $col+46,  'D7(%)',     $format);
#FREE_SOCIAL
$worksheet->write($row+$i, $col+48,  'Day 1',      $format);
$worksheet->write($row+$i, $col+49,  'Day 2',     $format);
$worksheet->write($row+$i, $col+50,  'Day 3',     $format);
$worksheet->write($row+$i, $col+51,  'Day 4',     $format);
$worksheet->write($row+$i, $col+52,  'Day 5',     $format);
$worksheet->write($row+$i, $col+53,  'Day 6',     $format);
$worksheet->write($row+$i, $col+54,  'Day 7',     $format);
$worksheet->write($row+$i, $col+56,  'D1(%)',     $format);
$worksheet->write($row+$i, $col+57,  'D2(%)',     $format);
$worksheet->write($row+$i, $col+58,  'D3(%)',     $format);
$worksheet->write($row+$i, $col+59,  'D4(%)',     $format);
$worksheet->write($row+$i, $col+60,  'D5(%)',     $format);
$worksheet->write($row+$i, $col+61,  'D6(%)',     $format);
$worksheet->write($row+$i, $col+62,  'D7(%)',     $format);
#SPEEDBOOST
$worksheet->write($row+$i, $col+64,  'Day 1',      $format);
$worksheet->write($row+$i, $col+65,  'Day 2',     $format);
$worksheet->write($row+$i, $col+66,  'Day 3',     $format);
$worksheet->write($row+$i, $col+67,  'Day 4',     $format);
$worksheet->write($row+$i, $col+68,  'Day 5',     $format);
$worksheet->write($row+$i, $col+69,  'Day 6',     $format);
$worksheet->write($row+$i, $col+70,  'Day 7',     $format);
$worksheet->write($row+$i, $col+72,  'D1(%)',     $format);
$worksheet->write($row+$i, $col+73,  'D2(%)',     $format);
$worksheet->write($row+$i, $col+74,  'D3(%)',     $format);
$worksheet->write($row+$i, $col+75,  'D4(%)',     $format);
$worksheet->write($row+$i, $col+76,  'D5(%)',     $format);
$worksheet->write($row+$i, $col+77,  'D6(%)',     $format);
$worksheet->write($row+$i, $col+78,  'D7(%)',     $format);

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
   $worksheet->write($row+$i, $col+9,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+10, $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+11, $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+12, $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+13, $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+14, $rowRst[13], $format1);
}

# FACEBOOK
# FACEBOOK
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'FACEBOOK' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+16,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+17,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+18,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+19,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+20,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+21,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+22,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+24,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+25,  $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+26,  $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+27,  $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+28,  $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+29,  $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+30,  $rowRst[14], $format1);
}

# SOCIAL
# SOCIAL
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'SOCIAL' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+32,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+33,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+34,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+35,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+36,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+37,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+38,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+40,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+41,  $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+42,  $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+43,  $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+44,  $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+45,  $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+46,  $rowRst[14], $format1);
}

# FREE_SOCIAL
# FREE_SOCIAL
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'FREE_SOCIAL' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+48,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+49,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+50,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+51,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+52,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+53,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+54,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+56,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+57,  $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+58,  $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+59,  $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+60,  $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+61,  $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+62,  $rowRst[14], $format1);
}

# SPEEDBOOST
# SPEEDBOOST
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'SPEEDBOOST' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+64,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+65,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+66,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+67,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+68,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+69,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+70,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+72,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+73,  $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+74,  $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+75,  $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+76,  $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+77,  $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+78,  $rowRst[14], $format1);
}



###################################################
# 6th Worksheet
###################################################
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y'), new_mins, 
                      day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_retention 
               where left(tx_date,7) = '".$current_date."' order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

# Add a worksheet
$worksheet = $workbook->add_worksheet("NEW MINs Retention 2");

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

$format1d = $workbook->add_format(); # Add a format
$format1d->set_font('Calibri');
$format1d->set_size('9');
$format1d->set_color('black');
$format1d->set_align('right');
$format1d->set_border(1);
$format1d->set_num_format('##0.00');

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
$worksheet->merge_range('Q2:AE2',  'UNLIMITED New MINs Retention', $format2);
$worksheet->merge_range('AG2:AU2', 'PISONET New MINs Retention', $format2);
$worksheet->merge_range('AW2:BK2', 'YOUTUBE New MINs Retention', $format2);
$worksheet->merge_range('BM2:CA2', 'BACK-TO-SCHOOL New MINs Retention', $format2);
$worksheet->merge_range('CC2:CQ2', 'WIKIPEDIA New MINs Retention', $format2);
$worksheet->merge_range('CS2:DG2', 'PHOTO New MINs Retention', $format2);
$worksheet->merge_range('DI2:DW2', 'CHAT New MINs Retention', $format2);
$worksheet->merge_range('DY2:EM2', 'EMAIL New MINs Retention', $format2);
$worksheet->merge_range('EO2:FC2', 'LINE New MINs Retention', $format2);
$worksheet->merge_range('FE2:FS2', 'WECHAT New MINs Retention', $format2);
$worksheet->merge_range('FU2:GI2', 'SNAPCHAT New MINs Retention', $format2);
$worksheet->merge_range('GK2:GY2', 'WAZE New MINs Retention', $format2);
$worksheet->merge_range('HA2:HO2', 'TUMBLR New MINs Retention', $format2);

$worksheet->set_column(0,0,9);
$worksheet->set_column(1,1,8);
$worksheet->set_column(2,14,0.1);
$worksheet->set_column(15,15,1);
$worksheet->set_column(16,22,6);
$worksheet->set_column(23,23,1);
$worksheet->set_column(24,30,5);
$worksheet->set_column(31,31,1);
$worksheet->set_column(32,38,6);
$worksheet->set_column(39,39,1);
$worksheet->set_column(40,46,5);
$worksheet->set_column(47,47,1);
$worksheet->set_column(48,54,6);
$worksheet->set_column(55,55,1);
$worksheet->set_column(56,62,5);
$worksheet->set_column(63,63,1);
$worksheet->set_column(65,70,6);
$worksheet->set_column(71,71,1);
$worksheet->set_column(72,78,5);
$worksheet->set_column(79,79,1);
$worksheet->set_column(80,86,6);
$worksheet->set_column(87,87,1);
$worksheet->set_column(88,94,5);
$worksheet->set_column(95,95,1);
$worksheet->set_column(96,102,6);
$worksheet->set_column(103,103,1);
$worksheet->set_column(104,110,5);
$worksheet->set_column(111,111,1);
$worksheet->set_column(112,118,6);
$worksheet->set_column(119,119,1);
$worksheet->set_column(120,126,5);
$worksheet->set_column(127,127,1);
$worksheet->set_column(128,134,6);
$worksheet->set_column(135,135,1);
$worksheet->set_column(136,142,5);
$worksheet->set_column(143,143,1);
$worksheet->set_column(144,150,6);
$worksheet->set_column(151,151,1);
$worksheet->set_column(152,158,5);
$worksheet->set_column(159,159,1);
$worksheet->set_column(160,166,6);
$worksheet->set_column(167,167,1);
$worksheet->set_column(168,174,5);
$worksheet->set_column(175,175,1);
$worksheet->set_column(176,182,6);
$worksheet->set_column(183,183,1);
$worksheet->set_column(184,190,5);
$worksheet->set_column(191,191,1);
$worksheet->set_column(192,298,6);
$worksheet->set_column(199,199,1);
$worksheet->set_column(200,206,5);
$worksheet->set_column(207,207,1);
$worksheet->set_column(208,214,6);
$worksheet->set_column(215,215,1);
$worksheet->set_column(216,222,5);
$worksheet->set_column(223,223,1);
$worksheet->set_column(224,230,6);
$worksheet->set_column(231,231,1);
$worksheet->set_column(232,238,5);
$worksheet->set_column(239,239,1);
#

$worksheet->write($row+$i, $col,     'DATE',      $format);
$worksheet->write($row+$i, $col+1,   'New MINs',  $format);
#UNLIMITED
$worksheet->write($row+$i, $col+16,  'Day 1',     $format);
$worksheet->write($row+$i, $col+17,  'Day 2',     $format);
$worksheet->write($row+$i, $col+18,  'Day 3',     $format);
$worksheet->write($row+$i, $col+19,  'Day 4',     $format);
$worksheet->write($row+$i, $col+20,  'Day 5',     $format);
$worksheet->write($row+$i, $col+21,  'Day 6',     $format);
$worksheet->write($row+$i, $col+22,  'Day 7',     $format);
$worksheet->write($row+$i, $col+24,  'D1(%)',     $format);
$worksheet->write($row+$i, $col+25,  'D2(%)',     $format);
$worksheet->write($row+$i, $col+26,  'D3(%)',     $format);
$worksheet->write($row+$i, $col+27,  'D4(%)',     $format);
$worksheet->write($row+$i, $col+28,  'D5(%)',     $format);
$worksheet->write($row+$i, $col+29,  'D6(%)',     $format);
$worksheet->write($row+$i, $col+30,  'D7(%)',     $format);
#PISONET
$worksheet->write($row+$i, $col+32,  'Day 1',      $format);
$worksheet->write($row+$i, $col+33,  'Day 2',     $format);
$worksheet->write($row+$i, $col+34,  'Day 3',     $format);
$worksheet->write($row+$i, $col+35,  'Day 4',     $format);
$worksheet->write($row+$i, $col+36,  'Day 5',     $format);
$worksheet->write($row+$i, $col+37,  'Day 6',     $format);
$worksheet->write($row+$i, $col+38,  'Day 7',     $format);
$worksheet->write($row+$i, $col+40,  'D1(%)',     $format);
$worksheet->write($row+$i, $col+41,  'D2(%)',     $format);
$worksheet->write($row+$i, $col+42,  'D3(%)',     $format);
$worksheet->write($row+$i, $col+43,  'D4(%)',     $format);
$worksheet->write($row+$i, $col+44,  'D5(%)',     $format);
$worksheet->write($row+$i, $col+45,  'D6(%)',     $format);
$worksheet->write($row+$i, $col+46,  'D7(%)',     $format);
#YOUTUBE
$worksheet->write($row+$i, $col+48,  'Day 1',      $format);
$worksheet->write($row+$i, $col+49,  'Day 2',     $format);
$worksheet->write($row+$i, $col+50,  'Day 3',     $format);
$worksheet->write($row+$i, $col+51,  'Day 4',     $format);
$worksheet->write($row+$i, $col+52,  'Day 5',     $format);
$worksheet->write($row+$i, $col+53,  'Day 6',     $format);
$worksheet->write($row+$i, $col+54,  'Day 7',     $format);
$worksheet->write($row+$i, $col+56,  'D1(%)',     $format);
$worksheet->write($row+$i, $col+57,  'D2(%)',     $format);
$worksheet->write($row+$i, $col+58,  'D3(%)',     $format);
$worksheet->write($row+$i, $col+59,  'D4(%)',     $format);
$worksheet->write($row+$i, $col+60,  'D5(%)',     $format);
$worksheet->write($row+$i, $col+61,  'D6(%)',     $format);
$worksheet->write($row+$i, $col+62,  'D7(%)',     $format);
#BACKTOSCHOOL
$worksheet->write($row+$i, $col+64,  'Day 1',      $format);
$worksheet->write($row+$i, $col+65,  'Day 2',     $format);
$worksheet->write($row+$i, $col+66,  'Day 3',     $format);
$worksheet->write($row+$i, $col+67,  'Day 4',     $format);
$worksheet->write($row+$i, $col+68,  'Day 5',     $format);
$worksheet->write($row+$i, $col+69,  'Day 6',     $format);
$worksheet->write($row+$i, $col+70,  'Day 7',     $format);
$worksheet->write($row+$i, $col+72,  'D1(%)',     $format);
$worksheet->write($row+$i, $col+73,  'D2(%)',     $format);
$worksheet->write($row+$i, $col+74,  'D3(%)',     $format);
$worksheet->write($row+$i, $col+75,  'D4(%)',     $format);
$worksheet->write($row+$i, $col+76,  'D5(%)',     $format);
$worksheet->write($row+$i, $col+77,  'D6(%)',     $format);
$worksheet->write($row+$i, $col+78,  'D7(%)',     $format);
#WIKIPEDIA
$worksheet->write($row+$i, $col+80,  'Day 1',      $format);
$worksheet->write($row+$i, $col+81,  'Day 2',     $format);
$worksheet->write($row+$i, $col+82,  'Day 3',     $format);
$worksheet->write($row+$i, $col+83,  'Day 4',     $format);
$worksheet->write($row+$i, $col+84,  'Day 5',     $format);
$worksheet->write($row+$i, $col+85,  'Day 6',     $format);
$worksheet->write($row+$i, $col+86,  'Day 7',     $format);
$worksheet->write($row+$i, $col+88,  'D1(%)',     $format);
$worksheet->write($row+$i, $col+89,  'D2(%)',     $format);
$worksheet->write($row+$i, $col+90,  'D3(%)',     $format);
$worksheet->write($row+$i, $col+91,  'D4(%)',     $format);
$worksheet->write($row+$i, $col+92,  'D5(%)',     $format);
$worksheet->write($row+$i, $col+93,  'D6(%)',     $format);
$worksheet->write($row+$i, $col+94,  'D7(%)',     $format);
#PHOTO
$worksheet->write($row+$i, $col+96,  'Day 1',      $format);
$worksheet->write($row+$i, $col+97,  'Day 2',     $format);
$worksheet->write($row+$i, $col+98,  'Day 3',     $format);
$worksheet->write($row+$i, $col+99,  'Day 4',     $format);
$worksheet->write($row+$i, $col+100, 'Day 5',     $format);
$worksheet->write($row+$i, $col+101, 'Day 6',     $format);
$worksheet->write($row+$i, $col+102, 'Day 7',     $format);
$worksheet->write($row+$i, $col+104, 'D1(%)',     $format);
$worksheet->write($row+$i, $col+105, 'D2(%)',     $format);
$worksheet->write($row+$i, $col+106, 'D3(%)',     $format);
$worksheet->write($row+$i, $col+107, 'D4(%)',     $format);
$worksheet->write($row+$i, $col+108, 'D5(%)',     $format);
$worksheet->write($row+$i, $col+109, 'D6(%)',     $format);
$worksheet->write($row+$i, $col+110, 'D7(%)',     $format);
#CHAT
$worksheet->write($row+$i, $col+112, 'Day 1',      $format);
$worksheet->write($row+$i, $col+113, 'Day 2',     $format);
$worksheet->write($row+$i, $col+114, 'Day 3',     $format);
$worksheet->write($row+$i, $col+115, 'Day 4',     $format);
$worksheet->write($row+$i, $col+116, 'Day 5',     $format);
$worksheet->write($row+$i, $col+117, 'Day 6',     $format);
$worksheet->write($row+$i, $col+118, 'Day 7',     $format);
$worksheet->write($row+$i, $col+120, 'D1(%)',     $format);
$worksheet->write($row+$i, $col+121, 'D2(%)',     $format);
$worksheet->write($row+$i, $col+122, 'D3(%)',     $format);
$worksheet->write($row+$i, $col+123, 'D4(%)',     $format);
$worksheet->write($row+$i, $col+124, 'D5(%)',     $format);
$worksheet->write($row+$i, $col+125, 'D6(%)',     $format);
$worksheet->write($row+$i, $col+126, 'D7(%)',     $format);
#EMAIL
$worksheet->write($row+$i, $col+128, 'Day 1',      $format);
$worksheet->write($row+$i, $col+129, 'Day 2',     $format);
$worksheet->write($row+$i, $col+130, 'Day 3',     $format);
$worksheet->write($row+$i, $col+131, 'Day 4',     $format);
$worksheet->write($row+$i, $col+132, 'Day 5',     $format);
$worksheet->write($row+$i, $col+133, 'Day 6',     $format);
$worksheet->write($row+$i, $col+134, 'Day 7',     $format);
$worksheet->write($row+$i, $col+136, 'D1(%)',     $format);
$worksheet->write($row+$i, $col+137, 'D2(%)',     $format);
$worksheet->write($row+$i, $col+138, 'D3(%)',     $format);
$worksheet->write($row+$i, $col+139, 'D4(%)',     $format);
$worksheet->write($row+$i, $col+140, 'D5(%)',     $format);
$worksheet->write($row+$i, $col+141, 'D6(%)',     $format);
$worksheet->write($row+$i, $col+142, 'D7(%)',     $format);
#LINE
$worksheet->write($row+$i, $col+144, 'Day 1',      $format);
$worksheet->write($row+$i, $col+145, 'Day 2',     $format);
$worksheet->write($row+$i, $col+146, 'Day 3',     $format);
$worksheet->write($row+$i, $col+147, 'Day 4',     $format);
$worksheet->write($row+$i, $col+148, 'Day 5',     $format);
$worksheet->write($row+$i, $col+149, 'Day 6',     $format);
$worksheet->write($row+$i, $col+150, 'Day 7',     $format);
$worksheet->write($row+$i, $col+152, 'D1(%)',     $format);
$worksheet->write($row+$i, $col+153, 'D2(%)',     $format);
$worksheet->write($row+$i, $col+154, 'D3(%)',     $format);
$worksheet->write($row+$i, $col+155, 'D4(%)',     $format);
$worksheet->write($row+$i, $col+156, 'D5(%)',     $format);
$worksheet->write($row+$i, $col+157, 'D6(%)',     $format);
$worksheet->write($row+$i, $col+158, 'D7(%)',     $format);
#WECHAT
$worksheet->write($row+$i, $col+160, 'Day 1',      $format);
$worksheet->write($row+$i, $col+161, 'Day 2',     $format);
$worksheet->write($row+$i, $col+162, 'Day 3',     $format);
$worksheet->write($row+$i, $col+163, 'Day 4',     $format);
$worksheet->write($row+$i, $col+164, 'Day 5',     $format);
$worksheet->write($row+$i, $col+165, 'Day 6',     $format);
$worksheet->write($row+$i, $col+166, 'Day 7',     $format);
$worksheet->write($row+$i, $col+168, 'D1(%)',     $format);
$worksheet->write($row+$i, $col+169, 'D2(%)',     $format);
$worksheet->write($row+$i, $col+170, 'D3(%)',     $format);
$worksheet->write($row+$i, $col+171, 'D4(%)',     $format);
$worksheet->write($row+$i, $col+172, 'D5(%)',     $format);
$worksheet->write($row+$i, $col+173, 'D6(%)',     $format);
$worksheet->write($row+$i, $col+174, 'D7(%)',     $format);
#SNAPCHAT
$worksheet->write($row+$i, $col+176, 'Day 1',      $format);
$worksheet->write($row+$i, $col+177, 'Day 2',     $format);
$worksheet->write($row+$i, $col+178, 'Day 3',     $format);
$worksheet->write($row+$i, $col+179, 'Day 4',     $format);
$worksheet->write($row+$i, $col+180, 'Day 5',     $format);
$worksheet->write($row+$i, $col+181, 'Day 6',     $format);
$worksheet->write($row+$i, $col+182, 'Day 7',     $format);
$worksheet->write($row+$i, $col+184, 'D1(%)',     $format);
$worksheet->write($row+$i, $col+185, 'D2(%)',     $format);
$worksheet->write($row+$i, $col+186, 'D3(%)',     $format);
$worksheet->write($row+$i, $col+187, 'D4(%)',     $format);
$worksheet->write($row+$i, $col+188, 'D5(%)',     $format);
$worksheet->write($row+$i, $col+189, 'D6(%)',     $format);
$worksheet->write($row+$i, $col+190, 'D7(%)',     $format);
#WAZE
$worksheet->write($row+$i, $col+192, 'Day 1',      $format);
$worksheet->write($row+$i, $col+193, 'Day 2',     $format);
$worksheet->write($row+$i, $col+194, 'Day 3',     $format);
$worksheet->write($row+$i, $col+195, 'Day 4',     $format);
$worksheet->write($row+$i, $col+196, 'Day 5',     $format);
$worksheet->write($row+$i, $col+197, 'Day 6',     $format);
$worksheet->write($row+$i, $col+198, 'Day 7',     $format);
$worksheet->write($row+$i, $col+200, 'D1(%)',     $format);
$worksheet->write($row+$i, $col+201, 'D2(%)',     $format);
$worksheet->write($row+$i, $col+202, 'D3(%)',     $format);
$worksheet->write($row+$i, $col+203, 'D4(%)',     $format);
$worksheet->write($row+$i, $col+204, 'D5(%)',     $format);
$worksheet->write($row+$i, $col+205, 'D6(%)',     $format);
$worksheet->write($row+$i, $col+206, 'D7(%)',     $format);
#TUMBLR
$worksheet->write($row+$i, $col+208, 'Day 1',      $format);
$worksheet->write($row+$i, $col+209, 'Day 2',     $format);
$worksheet->write($row+$i, $col+210, 'Day 3',     $format);
$worksheet->write($row+$i, $col+211, 'Day 4',     $format);
$worksheet->write($row+$i, $col+212, 'Day 5',     $format);
$worksheet->write($row+$i, $col+213, 'Day 6',     $format);
$worksheet->write($row+$i, $col+214, 'Day 7',     $format);
$worksheet->write($row+$i, $col+216, 'D1(%)',     $format);
$worksheet->write($row+$i, $col+217, 'D2(%)',     $format);
$worksheet->write($row+$i, $col+218, 'D3(%)',     $format);
$worksheet->write($row+$i, $col+219, 'D4(%)',     $format);
$worksheet->write($row+$i, $col+220, 'D5(%)',     $format);
$worksheet->write($row+$i, $col+221, 'D6(%)',     $format);
$worksheet->write($row+$i, $col+222, 'D7(%)',     $format);


while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1s);
   $worksheet->write($row+$i, $col+1,  $rowRst[1],  $format1);
}

# UNLIMITED
# UNLIMITED
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'UNLI' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+16,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+17,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+18,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+19,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+20,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+21,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+22,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+24,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+25,  $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+26,  $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+27,  $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+28,  $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+29,  $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+30,  $rowRst[14], $format1);
}

# PISONET
# PISONET
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'PISONET' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+32,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+33,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+34,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+35,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+36,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+37,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+38,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+40,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+41,  $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+42,  $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+43,  $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+44,  $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+45,  $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+46,  $rowRst[14], $format1);
}

# YOUTUBE
# YOUTUBE
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'YOUTUBE' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+48,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+49,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+50,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+51,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+52,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+53,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+54,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+56,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+57,  $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+58,  $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+59,  $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+60,  $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+61,  $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+62,  $rowRst[14], $format1);
}

# BACKTOSCHOOL
# BACKTOSCHOOL
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'BACKTOSCHOOL' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+64,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+65,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+66,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+67,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+68,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+69,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+70,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+72,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+73,  $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+74,  $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+75,  $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+76,  $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+77,  $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+78,  $rowRst[14], $format1);
}

# WIKIPEDIA
# WIKIPEDIA
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'WIKIPEDIA' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+80,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+81,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+82,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+83,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+84,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+85,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+86,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+88,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+89,  $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+90,  $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+91,  $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+92,  $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+93,  $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+94,  $rowRst[14], $format1);
}

# PHOTO
# PHOTO
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'PHOTO' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+96,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+97,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+98,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+99,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+100, $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+101, $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+102, $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+104, $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+105, $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+106, $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+107, $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+108, $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+109, $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+110, $rowRst[14], $format1);
}


# CHAT
# CHAT
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'CHAT' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+112, $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+113, $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+114, $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+115, $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+116, $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+117, $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+118, $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+120, $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+121, $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+122, $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+123, $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+124, $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+125, $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+126, $rowRst[14], $format1);
}

# EMAIL
# EMAIL
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'EMAIL' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+128, $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+129, $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+130, $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+131, $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+132, $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+133, $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+134, $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+136, $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+137, $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+138, $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+139, $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+140, $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+141, $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+142, $rowRst[14], $format1);
}


# LINE
# LINE
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'LINE' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+144, $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+145, $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+146, $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+147, $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+148, $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+149, $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+150, $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+152, $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+153, $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+154, $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+155, $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+156, $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+157, $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+158, $rowRst[14], $format1);
}


# WECHAT
# WECHAT
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'WECHAT' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+160, $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+161, $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+162, $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+163, $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+164, $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+165, $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+166, $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+168, $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+169, $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+170, $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+171, $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+172, $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+173, $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+174, $rowRst[14], $format1);
}

# SNAPCHAT
# SNAPCHAT
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'SNAPCHAT' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+176, $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+177, $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+178, $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+179, $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+180, $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+181, $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+182, $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+184, $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+185, $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+186, $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+187, $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+188, $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+189, $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+190, $rowRst[14], $format1);
}


# WAZE
# WAZE
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'WAZE' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+192, $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+193, $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+194, $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+195, $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+196, $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+197, $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+198, $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+200, $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+201, $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+202, $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+203, $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+204, $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+205, $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+206, $rowRst[14], $format1);
}

# TUMBLR
# TUMBLR
$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y') tx_month,  
                      day_1, day_2, day_3, day_4, day_5, day_6, day_7,
                      pct_1, pct_2, pct_3, pct_4, pct_5, pct_6, pct_7 
               from powerapp_new_mins_plan_retention 
               where plan = 'TUMBLR' and left(tx_date,7) = '".$current_date."' 
               order by tx_date";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
$row = 1;
$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+208, $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+209, $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+210, $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+211, $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+212, $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+213, $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+214, $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+216, $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+217, $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+218, $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+219, $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+220, $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+221, $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+222, $rowRst[14], $format1);
}



$workbook->close();
 binmode STDOUT;

$from = "stats\@chikka.com";
$to = "victor\@chikka.com";
$cc = "dbadmins\@chikka.com,jldespanol\@chikka.com";
#$to = "glenon\@chikka.com";
#$cc = "glenon\@chikka.com";
$Subject = "PowerApp Active & Retention Stats , ".$current_day;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp Active Stats & Retention Stats for the Month of $txt_month.</span></span></p>
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




