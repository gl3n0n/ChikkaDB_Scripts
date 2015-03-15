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

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_stats_hourly_".$current_date.".xls";
print $excel_file;

my $dbh_hi10 = DB::DBconnect(myconstants::HI10_DB,myconstants::HI10_HOST,myconstants::HI10_USER,myconstants::HI10_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);

my $sth_hi_10;


###################################################
###################################################
###################################################

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  
                      sum(tm_00_3h+tm_00_24h), 
                      sum(tm_01_3h+tm_01_24h), 
                      sum(tm_02_3h+tm_02_24h), 
                      sum(tm_03_3h+tm_03_24h), 
                      sum(tm_04_3h+tm_04_24h), 
                      sum(tm_05_3h+tm_05_24h), 
                      sum(tm_06_3h+tm_06_24h), 
                      sum(tm_07_3h+tm_07_24h), 
                      sum(tm_08_3h+tm_08_24h), 
                      sum(tm_09_3h+tm_09_24h), 
                      sum(tm_10_3h+tm_10_24h), 
                      sum(tm_11_3h+tm_11_24h), 
                      sum(tm_12_3h+tm_12_24h), 
                      sum(tm_13_3h+tm_13_24h), 
                      sum(tm_14_3h+tm_14_24h), 
                      sum(tm_15_3h+tm_15_24h), 
                      sum(tm_16_3h+tm_16_24h), 
                      sum(tm_17_3h+tm_17_24h), 
                      sum(tm_18_3h+tm_18_24h), 
                      sum(tm_19_3h+tm_19_24h), 
                      sum(tm_20_3h+tm_20_24h), 
                      sum(tm_21_3h+tm_21_24h), 
                      sum(tm_22_3h+tm_22_24h), 
                      sum(tm_23_3h+tm_23_24h), 
                      sum(tm_tot_3h+tm_tot_24h)
               from powerapp_hourlyrep_hits_summary 
               where left(tran_dt,7) = '".$current_date."' 
               group by tran_dt order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet("SUMMARY");


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

$format2 = $workbook->add_format(bg_color => 'gray'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(1);

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
$formatC->set_size('12');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('12');
$formatS->set_color('black');
$formatS->set_align('center');
$formatS->set_border(1);

$formatB = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatB->set_bold();
$formatB->set_font('Calibri');
$formatB->set_size('10');
$formatB->set_color('black');
$formatB->set_align('center');
$formatB->set_border(1);

$formatE = $workbook->add_format(bg_color => 'magenta'); # Add a format
$formatE->set_bold();
$formatE->set_font('Calibri');
$formatE->set_size('10');
$formatE->set_color('black');
$formatE->set_align('center');
$formatE->set_border(1);

$formatP = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP->set_bold();
$formatP->set_font('Calibri');
$formatP->set_size('10');
$formatP->set_color('black');
$formatP->set_align('center');
$formatP->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);



$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 24, 6);
$worksheet->set_column(25, 25, 8);
$worksheet->set_column(26, 26, 1);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:Z2',  'S  U  M  M  A  R  Y', $formatC);

$worksheet->merge_range('B3:Z3', 'HITS', $formatP);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',  $format);
$worksheet->write($row+$i, $col+1,  '\'00',  $format);
$worksheet->write($row+$i, $col+2,  '\'01',  $format);
$worksheet->write($row+$i, $col+3,  '\'02',  $format);
$worksheet->write($row+$i, $col+4,  '\'03',  $format);
$worksheet->write($row+$i, $col+5,  '\'04',  $format);
$worksheet->write($row+$i, $col+6,  '\'05',  $format);
$worksheet->write($row+$i, $col+7,  '\'06',  $format);
$worksheet->write($row+$i, $col+8,  '\'07',  $format);
$worksheet->write($row+$i, $col+9,  '\'08',  $format);
$worksheet->write($row+$i, $col+10, '\'09',  $format);
$worksheet->write($row+$i, $col+11, '\'10',  $format);
$worksheet->write($row+$i, $col+12, '\'11',  $format);
$worksheet->write($row+$i, $col+13, '\'12',  $format);
$worksheet->write($row+$i, $col+14, '\'13',  $format);
$worksheet->write($row+$i, $col+15, '\'14',  $format);
$worksheet->write($row+$i, $col+16, '\'15',  $format);
$worksheet->write($row+$i, $col+17, '\'16',  $format);
$worksheet->write($row+$i, $col+18, '\'17',  $format);
$worksheet->write($row+$i, $col+19, '\'18',  $format);
$worksheet->write($row+$i, $col+20, '\'19',  $format);
$worksheet->write($row+$i, $col+21, '\'20',  $format);
$worksheet->write($row+$i, $col+22, '\'21',  $format);
$worksheet->write($row+$i, $col+23, '\'22',  $format);
$worksheet->write($row+$i, $col+24, '\'23',  $format);
$worksheet->write($row+$i, $col+25, 'TOTAL', $format);


while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1);
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $formatT);
}





################################################
################################################
################################################


$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  tm_00_3h, tm_01_3h, tm_02_3h, tm_03_3h, tm_04_3h, tm_05_3h, tm_06_3h, tm_07_3h, tm_08_3h, tm_09_3h, tm_10_3h, tm_11_3h, tm_12_3h, tm_13_3h, tm_14_3h, tm_15_3h, tm_16_3h, tm_17_3h, tm_18_3h, tm_19_3h, tm_20_3h, tm_21_3h, tm_22_3h, tm_23_3h, tm_tot_3h, tm_00_24h, tm_01_24h, tm_02_24h, tm_03_24h, tm_04_24h, tm_05_24h, tm_06_24h, tm_07_24h, tm_08_24h, tm_09_24h, tm_10_24h, tm_11_24h, tm_12_24h, tm_13_24h, tm_14_24h, tm_15_24h, tm_16_24h, tm_17_24h, tm_18_24h, tm_19_24h, tm_20_24h, tm_21_24h, tm_22_24h, tm_23_24h, tm_tot_24h, tm_00_3u, tm_01_3u, tm_02_3u, tm_03_3u, tm_04_3u, tm_05_3u, tm_06_3u, tm_07_3u, tm_08_3u, tm_09_3u, tm_10_3u, tm_11_3u, tm_12_3u, tm_13_3u, tm_14_3u, tm_15_3u, tm_16_3u, tm_17_3u, tm_18_3u, tm_19_3u, tm_20_3u, tm_21_3u, tm_22_3u, tm_23_3u, tm_tot_3u, tm_00_24u, tm_01_24u, tm_02_24u, tm_03_24u, tm_04_24u, tm_05_24u, tm_06_24u, tm_07_24u, tm_08_24u, tm_09_24u, tm_10_24u, tm_11_24u, tm_12_24u, tm_13_24u, tm_14_24u, tm_15_24u, tm_16_24u, tm_17_24u, tm_18_24u, tm_19_24u, tm_20_24u, tm_21_24u, tm_22_24u, tm_23_24u, tm_tot_24u from powerapp_hourlyrep_hits_summary where plan = 'CHAT' and left(tran_dt,7) = '".$current_date."' order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet("CHAT");


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

$format2 = $workbook->add_format(bg_color => 'gray'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(1);

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
$formatC->set_size('12');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('12');
$formatS->set_color('black');
$formatS->set_align('center');
$formatS->set_border(1);

$formatB = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatB->set_bold();
$formatB->set_font('Calibri');
$formatB->set_size('10');
$formatB->set_color('black');
$formatB->set_align('center');
$formatB->set_border(1);

$formatE = $workbook->add_format(bg_color => 'magenta'); # Add a format
$formatE->set_bold();
$formatE->set_font('Calibri');
$formatE->set_size('10');
$formatE->set_color('black');
$formatE->set_align('center');
$formatE->set_border(1);

$formatP = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP->set_bold();
$formatP->set_font('Calibri');
$formatP->set_size('10');
$formatP->set_color('black');
$formatP->set_align('center');
$formatP->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);



$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 24, 4);
$worksheet->set_column(25, 25, 6);
$worksheet->set_column(26, 26, 1);
$worksheet->set_column(27, 50, 4);
$worksheet->set_column(51, 51, 6);

$worksheet->set_column(52, 52, 3);

$worksheet->set_column(53, 76, 4);
$worksheet->set_column(77, 77, 6);
$worksheet->set_column(78, 78, 1);
$worksheet->set_column(79, 102, 4);
$worksheet->set_column(103,103, 6);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:AZ2',  'C H A T  (HITS)', $formatC);
$worksheet->merge_range('BB2:CZ2', 'C H A T (UNIQUE USERS)', $formatS);

$worksheet->merge_range('B3:Z3', '3 HOURS', $formatP);
$worksheet->merge_range('AB3:AZ3', '24 HOURS', $formatU);
$worksheet->merge_range('BB3:BZ3', '3 HOURS', $formatP);
$worksheet->merge_range('CB3:CZ3', '24 HOURS', $formatU);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',  $format);
$worksheet->write($row+$i, $col+1,  '\'00',  $format);
$worksheet->write($row+$i, $col+2,  '\'01',  $format);
$worksheet->write($row+$i, $col+3,  '\'02',  $format);
$worksheet->write($row+$i, $col+4,  '\'03',  $format);
$worksheet->write($row+$i, $col+5,  '\'04',  $format);
$worksheet->write($row+$i, $col+6,  '\'05',  $format);
$worksheet->write($row+$i, $col+7,  '\'06',  $format);
$worksheet->write($row+$i, $col+8,  '\'07',  $format);
$worksheet->write($row+$i, $col+9,  '\'08',  $format);
$worksheet->write($row+$i, $col+10, '\'09',  $format);
$worksheet->write($row+$i, $col+11, '\'10',  $format);
$worksheet->write($row+$i, $col+12, '\'11',  $format);
$worksheet->write($row+$i, $col+13, '\'12',  $format);
$worksheet->write($row+$i, $col+14, '\'13',  $format);
$worksheet->write($row+$i, $col+15, '\'14',  $format);
$worksheet->write($row+$i, $col+16, '\'15',  $format);
$worksheet->write($row+$i, $col+17, '\'16',  $format);
$worksheet->write($row+$i, $col+18, '\'17',  $format);
$worksheet->write($row+$i, $col+19, '\'18',  $format);
$worksheet->write($row+$i, $col+20, '\'19',  $format);
$worksheet->write($row+$i, $col+21, '\'20',  $format);
$worksheet->write($row+$i, $col+22, '\'21',  $format);
$worksheet->write($row+$i, $col+23, '\'22',  $format);
$worksheet->write($row+$i, $col+24, '\'23',  $format);
$worksheet->write($row+$i, $col+25, 'TOTAL', $format);

$worksheet->write($row+$i, $col+27, '\'00',  $format);
$worksheet->write($row+$i, $col+28, '\'01',  $format);
$worksheet->write($row+$i, $col+29, '\'02',  $format);
$worksheet->write($row+$i, $col+30, '\'03',  $format);
$worksheet->write($row+$i, $col+31, '\'04',  $format);
$worksheet->write($row+$i, $col+32, '\'05',  $format);
$worksheet->write($row+$i, $col+33, '\'06',  $format);
$worksheet->write($row+$i, $col+34, '\'07',  $format);
$worksheet->write($row+$i, $col+35, '\'08',  $format);
$worksheet->write($row+$i, $col+36, '\'09',  $format);
$worksheet->write($row+$i, $col+37, '\'10',  $format);
$worksheet->write($row+$i, $col+38, '\'11',  $format);
$worksheet->write($row+$i, $col+39, '\'12',  $format);
$worksheet->write($row+$i, $col+40, '\'13',  $format);
$worksheet->write($row+$i, $col+41, '\'14',  $format);
$worksheet->write($row+$i, $col+42, '\'15',  $format);
$worksheet->write($row+$i, $col+43, '\'16',  $format);
$worksheet->write($row+$i, $col+44, '\'17',  $format);
$worksheet->write($row+$i, $col+45, '\'18',  $format);
$worksheet->write($row+$i, $col+46, '\'19',  $format);
$worksheet->write($row+$i, $col+47, '\'20',  $format);
$worksheet->write($row+$i, $col+48, '\'21',  $format);
$worksheet->write($row+$i, $col+49, '\'22',  $format);
$worksheet->write($row+$i, $col+50, '\'23',  $format);
$worksheet->write($row+$i, $col+51, 'TOTAL', $format);

$worksheet->write($row+$i, $col+53, '\'00',  $format);
$worksheet->write($row+$i, $col+54, '\'01',  $format);
$worksheet->write($row+$i, $col+55, '\'02',  $format);
$worksheet->write($row+$i, $col+56, '\'03',  $format);
$worksheet->write($row+$i, $col+57, '\'04',  $format);
$worksheet->write($row+$i, $col+58, '\'05',  $format);
$worksheet->write($row+$i, $col+59, '\'06',  $format);
$worksheet->write($row+$i, $col+60, '\'07',  $format);
$worksheet->write($row+$i, $col+61, '\'08',  $format);
$worksheet->write($row+$i, $col+62, '\'09',  $format);
$worksheet->write($row+$i, $col+63, '\'10',  $format);
$worksheet->write($row+$i, $col+64, '\'11',  $format);
$worksheet->write($row+$i, $col+65, '\'12',  $format);
$worksheet->write($row+$i, $col+66, '\'13',  $format);
$worksheet->write($row+$i, $col+67, '\'14',  $format);
$worksheet->write($row+$i, $col+68, '\'15',  $format);
$worksheet->write($row+$i, $col+69, '\'16',  $format);
$worksheet->write($row+$i, $col+70, '\'17',  $format);
$worksheet->write($row+$i, $col+71, '\'18',  $format);
$worksheet->write($row+$i, $col+72, '\'19',  $format);
$worksheet->write($row+$i, $col+73, '\'20',  $format);
$worksheet->write($row+$i, $col+74, '\'21',  $format);
$worksheet->write($row+$i, $col+75, '\'22',  $format);
$worksheet->write($row+$i, $col+76, '\'23',  $format);
$worksheet->write($row+$i, $col+77, 'TOTAL', $format);

$worksheet->write($row+$i, $col+79,  '\'00',  $format);
$worksheet->write($row+$i, $col+80,  '\'01',  $format);
$worksheet->write($row+$i, $col+81,  '\'02',  $format);
$worksheet->write($row+$i, $col+82,  '\'03',  $format);
$worksheet->write($row+$i, $col+83,  '\'04',  $format);
$worksheet->write($row+$i, $col+84,  '\'05',  $format);
$worksheet->write($row+$i, $col+85,  '\'06',  $format);
$worksheet->write($row+$i, $col+86,  '\'07',  $format);
$worksheet->write($row+$i, $col+87,  '\'08',  $format);
$worksheet->write($row+$i, $col+88,  '\'09',  $format);
$worksheet->write($row+$i, $col+89,  '\'10',  $format);
$worksheet->write($row+$i, $col+90,  '\'11',  $format);
$worksheet->write($row+$i, $col+91,  '\'12',  $format);
$worksheet->write($row+$i, $col+92,  '\'13',  $format);
$worksheet->write($row+$i, $col+93,  '\'14',  $format);
$worksheet->write($row+$i, $col+94,  '\'15',  $format);
$worksheet->write($row+$i, $col+95,  '\'16',  $format);
$worksheet->write($row+$i, $col+96,  '\'17',  $format);
$worksheet->write($row+$i, $col+97,  '\'18',  $format);
$worksheet->write($row+$i, $col+98,  '\'19',  $format);
$worksheet->write($row+$i, $col+99,  '\'20',  $format);
$worksheet->write($row+$i, $col+100, '\'21',  $format);
$worksheet->write($row+$i, $col+101, '\'22',  $format);
$worksheet->write($row+$i, $col+102, '\'23',  $format);
$worksheet->write($row+$i, $col+103, 'TOTAL', $format);


my @rowRst;

while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1);
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $formatT);

   $worksheet->write($row+$i, $col+27, $rowRst[26], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[27], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[28], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[29], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[30], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[31], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[32], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[33], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[34], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[35], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[36], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[37], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[38], $format1);
   $worksheet->write($row+$i, $col+40, $rowRst[39], $format1);
   $worksheet->write($row+$i, $col+41, $rowRst[40], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[41], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[42], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[43], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[44], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[45], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[46], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[47], $format1);
   $worksheet->write($row+$i, $col+49, $rowRst[48], $format1);
   $worksheet->write($row+$i, $col+50, $rowRst[49], $format1);
   $worksheet->write($row+$i, $col+51, $rowRst[50], $formatT);
                                                    
   $worksheet->write($row+$i, $col+53, $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+54, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+55, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+56, $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+57, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+58, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+59, $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+60, $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+61, $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+62, $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+63, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+64, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+65, $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+66, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+67, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+68, $rowRst[66], $format1);
   $worksheet->write($row+$i, $col+69, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+70, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+71, $rowRst[69], $format1);
   $worksheet->write($row+$i, $col+72, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+73, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+74, $rowRst[72], $format1);
   $worksheet->write($row+$i, $col+75, $rowRst[73], $format1);
   $worksheet->write($row+$i, $col+76, $rowRst[74], $format1);
   $worksheet->write($row+$i, $col+77, $rowRst[75], $formatT);

   $worksheet->write($row+$i, $col+79,  $rowRst[76],  $format1);
   $worksheet->write($row+$i, $col+80,  $rowRst[77],  $format1);
   $worksheet->write($row+$i, $col+81,  $rowRst[78],  $format1);
   $worksheet->write($row+$i, $col+82,  $rowRst[79],  $format1);
   $worksheet->write($row+$i, $col+83,  $rowRst[80],  $format1);
   $worksheet->write($row+$i, $col+84,  $rowRst[81],  $format1);
   $worksheet->write($row+$i, $col+85,  $rowRst[82],  $format1);
   $worksheet->write($row+$i, $col+86,  $rowRst[83],  $format1);
   $worksheet->write($row+$i, $col+87,  $rowRst[84],  $format1);
   $worksheet->write($row+$i, $col+88,  $rowRst[85],  $format1);
   $worksheet->write($row+$i, $col+89,  $rowRst[86],  $format1);
   $worksheet->write($row+$i, $col+90,  $rowRst[87],  $format1);
   $worksheet->write($row+$i, $col+91,  $rowRst[88],  $format1);
   $worksheet->write($row+$i, $col+92,  $rowRst[89],  $format1);
   $worksheet->write($row+$i, $col+93,  $rowRst[90],  $format1);
   $worksheet->write($row+$i, $col+94,  $rowRst[91],  $format1);
   $worksheet->write($row+$i, $col+95,  $rowRst[92],  $format1);
   $worksheet->write($row+$i, $col+96,  $rowRst[93],  $format1);
   $worksheet->write($row+$i, $col+97,  $rowRst[94],  $format1);
   $worksheet->write($row+$i, $col+98,  $rowRst[95],  $format1);
   $worksheet->write($row+$i, $col+99,  $rowRst[96],  $format1);
   $worksheet->write($row+$i, $col+100, $rowRst[97],  $format1);
   $worksheet->write($row+$i, $col+101, $rowRst[98],  $format1);
   $worksheet->write($row+$i, $col+102, $rowRst[99],  $format1);
   $worksheet->write($row+$i, $col+103, $rowRst[100], $formatT);
}



###################################################
###################################################
###################################################

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  tm_00_3h, tm_01_3h, tm_02_3h, tm_03_3h, tm_04_3h, tm_05_3h, tm_06_3h, tm_07_3h, tm_08_3h, tm_09_3h, tm_10_3h, tm_11_3h, tm_12_3h, tm_13_3h, tm_14_3h, tm_15_3h, tm_16_3h, tm_17_3h, tm_18_3h, tm_19_3h, tm_20_3h, tm_21_3h, tm_22_3h, tm_23_3h, tm_tot_3h, tm_00_24h, tm_01_24h, tm_02_24h, tm_03_24h, tm_04_24h, tm_05_24h, tm_06_24h, tm_07_24h, tm_08_24h, tm_09_24h, tm_10_24h, tm_11_24h, tm_12_24h, tm_13_24h, tm_14_24h, tm_15_24h, tm_16_24h, tm_17_24h, tm_18_24h, tm_19_24h, tm_20_24h, tm_21_24h, tm_22_24h, tm_23_24h, tm_tot_24h, tm_00_3u, tm_01_3u, tm_02_3u, tm_03_3u, tm_04_3u, tm_05_3u, tm_06_3u, tm_07_3u, tm_08_3u, tm_09_3u, tm_10_3u, tm_11_3u, tm_12_3u, tm_13_3u, tm_14_3u, tm_15_3u, tm_16_3u, tm_17_3u, tm_18_3u, tm_19_3u, tm_20_3u, tm_21_3u, tm_22_3u, tm_23_3u, tm_tot_3u, tm_00_24u, tm_01_24u, tm_02_24u, tm_03_24u, tm_04_24u, tm_05_24u, tm_06_24u, tm_07_24u, tm_08_24u, tm_09_24u, tm_10_24u, tm_11_24u, tm_12_24u, tm_13_24u, tm_14_24u, tm_15_24u, tm_16_24u, tm_17_24u, tm_18_24u, tm_19_24u, tm_20_24u, tm_21_24u, tm_22_24u, tm_23_24u, tm_tot_24u from powerapp_hourlyrep_hits_summary where plan = 'EMAIL' and left(tran_dt,7) = '".$current_date."' order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet("EMAIL");


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

$format2 = $workbook->add_format(bg_color => 'gray'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(1);

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
$formatC->set_size('12');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('12');
$formatS->set_color('black');
$formatS->set_align('center');
$formatS->set_border(1);

$formatB = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatB->set_bold();
$formatB->set_font('Calibri');
$formatB->set_size('10');
$formatB->set_color('black');
$formatB->set_align('center');
$formatB->set_border(1);

$formatE = $workbook->add_format(bg_color => 'magenta'); # Add a format
$formatE->set_bold();
$formatE->set_font('Calibri');
$formatE->set_size('10');
$formatE->set_color('black');
$formatE->set_align('center');
$formatE->set_border(1);

$formatP = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP->set_bold();
$formatP->set_font('Calibri');
$formatP->set_size('10');
$formatP->set_color('black');
$formatP->set_align('center');
$formatP->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);



$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 24, 4);
$worksheet->set_column(25, 25, 6);
$worksheet->set_column(26, 26, 1);
$worksheet->set_column(27, 50, 4);
$worksheet->set_column(51, 51, 6);

$worksheet->set_column(52, 52, 3);

$worksheet->set_column(53, 76, 4);
$worksheet->set_column(77, 77, 6);
$worksheet->set_column(78, 78, 1);
$worksheet->set_column(79, 102, 4);
$worksheet->set_column(103,103, 6);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:AZ2',  'E M A I L  (HITS)', $formatC);
$worksheet->merge_range('BB2:CZ2', 'E M A I L  (UNIQUE USERS)', $formatS);

$worksheet->merge_range('B3:Z3', '3 HOURS', $formatP);
$worksheet->merge_range('AB3:AZ3', '24 HOURS', $formatU);
$worksheet->merge_range('BB3:BZ3', '3 HOURS', $formatP);
$worksheet->merge_range('CB3:CZ3', '24 HOURS', $formatU);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',  $format);
$worksheet->write($row+$i, $col+1,  '\'00',  $format);
$worksheet->write($row+$i, $col+2,  '\'01',  $format);
$worksheet->write($row+$i, $col+3,  '\'02',  $format);
$worksheet->write($row+$i, $col+4,  '\'03',  $format);
$worksheet->write($row+$i, $col+5,  '\'04',  $format);
$worksheet->write($row+$i, $col+6,  '\'05',  $format);
$worksheet->write($row+$i, $col+7,  '\'06',  $format);
$worksheet->write($row+$i, $col+8,  '\'07',  $format);
$worksheet->write($row+$i, $col+9,  '\'08',  $format);
$worksheet->write($row+$i, $col+10, '\'09',  $format);
$worksheet->write($row+$i, $col+11, '\'10',  $format);
$worksheet->write($row+$i, $col+12, '\'11',  $format);
$worksheet->write($row+$i, $col+13, '\'12',  $format);
$worksheet->write($row+$i, $col+14, '\'13',  $format);
$worksheet->write($row+$i, $col+15, '\'14',  $format);
$worksheet->write($row+$i, $col+16, '\'15',  $format);
$worksheet->write($row+$i, $col+17, '\'16',  $format);
$worksheet->write($row+$i, $col+18, '\'17',  $format);
$worksheet->write($row+$i, $col+19, '\'18',  $format);
$worksheet->write($row+$i, $col+20, '\'19',  $format);
$worksheet->write($row+$i, $col+21, '\'20',  $format);
$worksheet->write($row+$i, $col+22, '\'21',  $format);
$worksheet->write($row+$i, $col+23, '\'22',  $format);
$worksheet->write($row+$i, $col+24, '\'23',  $format);
$worksheet->write($row+$i, $col+25, 'TOTAL', $format);

$worksheet->write($row+$i, $col+27, '\'00',  $format);
$worksheet->write($row+$i, $col+28, '\'01',  $format);
$worksheet->write($row+$i, $col+29, '\'02',  $format);
$worksheet->write($row+$i, $col+30, '\'03',  $format);
$worksheet->write($row+$i, $col+31, '\'04',  $format);
$worksheet->write($row+$i, $col+32, '\'05',  $format);
$worksheet->write($row+$i, $col+33, '\'06',  $format);
$worksheet->write($row+$i, $col+34, '\'07',  $format);
$worksheet->write($row+$i, $col+35, '\'08',  $format);
$worksheet->write($row+$i, $col+36, '\'09',  $format);
$worksheet->write($row+$i, $col+37, '\'10',  $format);
$worksheet->write($row+$i, $col+38, '\'11',  $format);
$worksheet->write($row+$i, $col+39, '\'12',  $format);
$worksheet->write($row+$i, $col+40, '\'13',  $format);
$worksheet->write($row+$i, $col+41, '\'14',  $format);
$worksheet->write($row+$i, $col+42, '\'15',  $format);
$worksheet->write($row+$i, $col+43, '\'16',  $format);
$worksheet->write($row+$i, $col+44, '\'17',  $format);
$worksheet->write($row+$i, $col+45, '\'18',  $format);
$worksheet->write($row+$i, $col+46, '\'19',  $format);
$worksheet->write($row+$i, $col+47, '\'20',  $format);
$worksheet->write($row+$i, $col+48, '\'21',  $format);
$worksheet->write($row+$i, $col+49, '\'22',  $format);
$worksheet->write($row+$i, $col+50, '\'23',  $format);
$worksheet->write($row+$i, $col+51, 'TOTAL', $format);

$worksheet->write($row+$i, $col+53, '\'00',  $format);
$worksheet->write($row+$i, $col+54, '\'01',  $format);
$worksheet->write($row+$i, $col+55, '\'02',  $format);
$worksheet->write($row+$i, $col+56, '\'03',  $format);
$worksheet->write($row+$i, $col+57, '\'04',  $format);
$worksheet->write($row+$i, $col+58, '\'05',  $format);
$worksheet->write($row+$i, $col+59, '\'06',  $format);
$worksheet->write($row+$i, $col+60, '\'07',  $format);
$worksheet->write($row+$i, $col+61, '\'08',  $format);
$worksheet->write($row+$i, $col+62, '\'09',  $format);
$worksheet->write($row+$i, $col+63, '\'10',  $format);
$worksheet->write($row+$i, $col+64, '\'11',  $format);
$worksheet->write($row+$i, $col+65, '\'12',  $format);
$worksheet->write($row+$i, $col+66, '\'13',  $format);
$worksheet->write($row+$i, $col+67, '\'14',  $format);
$worksheet->write($row+$i, $col+68, '\'15',  $format);
$worksheet->write($row+$i, $col+69, '\'16',  $format);
$worksheet->write($row+$i, $col+70, '\'17',  $format);
$worksheet->write($row+$i, $col+71, '\'18',  $format);
$worksheet->write($row+$i, $col+72, '\'19',  $format);
$worksheet->write($row+$i, $col+73, '\'20',  $format);
$worksheet->write($row+$i, $col+74, '\'21',  $format);
$worksheet->write($row+$i, $col+75, '\'22',  $format);
$worksheet->write($row+$i, $col+76, '\'23',  $format);
$worksheet->write($row+$i, $col+77, 'TOTAL', $format);

$worksheet->write($row+$i, $col+79,  '\'00',  $format);
$worksheet->write($row+$i, $col+80,  '\'01',  $format);
$worksheet->write($row+$i, $col+81,  '\'02',  $format);
$worksheet->write($row+$i, $col+82,  '\'03',  $format);
$worksheet->write($row+$i, $col+83,  '\'04',  $format);
$worksheet->write($row+$i, $col+84,  '\'05',  $format);
$worksheet->write($row+$i, $col+85,  '\'06',  $format);
$worksheet->write($row+$i, $col+86,  '\'07',  $format);
$worksheet->write($row+$i, $col+87,  '\'08',  $format);
$worksheet->write($row+$i, $col+88,  '\'09',  $format);
$worksheet->write($row+$i, $col+89,  '\'10',  $format);
$worksheet->write($row+$i, $col+90,  '\'11',  $format);
$worksheet->write($row+$i, $col+91,  '\'12',  $format);
$worksheet->write($row+$i, $col+92,  '\'13',  $format);
$worksheet->write($row+$i, $col+93,  '\'14',  $format);
$worksheet->write($row+$i, $col+94,  '\'15',  $format);
$worksheet->write($row+$i, $col+95,  '\'16',  $format);
$worksheet->write($row+$i, $col+96,  '\'17',  $format);
$worksheet->write($row+$i, $col+97,  '\'18',  $format);
$worksheet->write($row+$i, $col+98,  '\'19',  $format);
$worksheet->write($row+$i, $col+99,  '\'20',  $format);
$worksheet->write($row+$i, $col+100, '\'21',  $format);
$worksheet->write($row+$i, $col+101, '\'22',  $format);
$worksheet->write($row+$i, $col+102, '\'23',  $format);
$worksheet->write($row+$i, $col+103, 'TOTAL', $format);


while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1);
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $formatT);

   $worksheet->write($row+$i, $col+27, $rowRst[26], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[27], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[28], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[29], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[30], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[31], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[32], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[33], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[34], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[35], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[36], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[37], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[38], $format1);
   $worksheet->write($row+$i, $col+40, $rowRst[39], $format1);
   $worksheet->write($row+$i, $col+41, $rowRst[40], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[41], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[42], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[43], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[44], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[45], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[46], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[47], $format1);
   $worksheet->write($row+$i, $col+49, $rowRst[48], $format1);
   $worksheet->write($row+$i, $col+50, $rowRst[49], $format1);
   $worksheet->write($row+$i, $col+51, $rowRst[50], $formatT);
                                                    
   $worksheet->write($row+$i, $col+53, $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+54, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+55, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+56, $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+57, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+58, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+59, $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+60, $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+61, $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+62, $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+63, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+64, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+65, $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+66, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+67, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+68, $rowRst[66], $format1);
   $worksheet->write($row+$i, $col+69, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+70, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+71, $rowRst[69], $format1);
   $worksheet->write($row+$i, $col+72, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+73, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+74, $rowRst[72], $format1);
   $worksheet->write($row+$i, $col+75, $rowRst[73], $format1);
   $worksheet->write($row+$i, $col+76, $rowRst[74], $format1);
   $worksheet->write($row+$i, $col+77, $rowRst[75], $formatT);

   $worksheet->write($row+$i, $col+79,  $rowRst[76],  $format1);
   $worksheet->write($row+$i, $col+80,  $rowRst[77],  $format1);
   $worksheet->write($row+$i, $col+81,  $rowRst[78],  $format1);
   $worksheet->write($row+$i, $col+82,  $rowRst[79],  $format1);
   $worksheet->write($row+$i, $col+83,  $rowRst[80],  $format1);
   $worksheet->write($row+$i, $col+84,  $rowRst[81],  $format1);
   $worksheet->write($row+$i, $col+85,  $rowRst[82],  $format1);
   $worksheet->write($row+$i, $col+86,  $rowRst[83],  $format1);
   $worksheet->write($row+$i, $col+87,  $rowRst[84],  $format1);
   $worksheet->write($row+$i, $col+88,  $rowRst[85],  $format1);
   $worksheet->write($row+$i, $col+89,  $rowRst[86],  $format1);
   $worksheet->write($row+$i, $col+90,  $rowRst[87],  $format1);
   $worksheet->write($row+$i, $col+91,  $rowRst[88],  $format1);
   $worksheet->write($row+$i, $col+92,  $rowRst[89],  $format1);
   $worksheet->write($row+$i, $col+93,  $rowRst[90],  $format1);
   $worksheet->write($row+$i, $col+94,  $rowRst[91],  $format1);
   $worksheet->write($row+$i, $col+95,  $rowRst[92],  $format1);
   $worksheet->write($row+$i, $col+96,  $rowRst[93],  $format1);
   $worksheet->write($row+$i, $col+97,  $rowRst[94],  $format1);
   $worksheet->write($row+$i, $col+98,  $rowRst[95],  $format1);
   $worksheet->write($row+$i, $col+99,  $rowRst[96],  $format1);
   $worksheet->write($row+$i, $col+100, $rowRst[97],  $format1);
   $worksheet->write($row+$i, $col+101, $rowRst[98],  $format1);
   $worksheet->write($row+$i, $col+102, $rowRst[99],  $format1);
   $worksheet->write($row+$i, $col+103, $rowRst[100], $formatT);
}




###################################################
###################################################
###################################################

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  tm_00_3h, tm_01_3h, tm_02_3h, tm_03_3h, tm_04_3h, tm_05_3h, tm_06_3h, tm_07_3h, tm_08_3h, tm_09_3h, tm_10_3h, tm_11_3h, tm_12_3h, tm_13_3h, tm_14_3h, tm_15_3h, tm_16_3h, tm_17_3h, tm_18_3h, tm_19_3h, tm_20_3h, tm_21_3h, tm_22_3h, tm_23_3h, tm_tot_3h, tm_00_24h, tm_01_24h, tm_02_24h, tm_03_24h, tm_04_24h, tm_05_24h, tm_06_24h, tm_07_24h, tm_08_24h, tm_09_24h, tm_10_24h, tm_11_24h, tm_12_24h, tm_13_24h, tm_14_24h, tm_15_24h, tm_16_24h, tm_17_24h, tm_18_24h, tm_19_24h, tm_20_24h, tm_21_24h, tm_22_24h, tm_23_24h, tm_tot_24h, tm_00_3u, tm_01_3u, tm_02_3u, tm_03_3u, tm_04_3u, tm_05_3u, tm_06_3u, tm_07_3u, tm_08_3u, tm_09_3u, tm_10_3u, tm_11_3u, tm_12_3u, tm_13_3u, tm_14_3u, tm_15_3u, tm_16_3u, tm_17_3u, tm_18_3u, tm_19_3u, tm_20_3u, tm_21_3u, tm_22_3u, tm_23_3u, tm_tot_3u, tm_00_24u, tm_01_24u, tm_02_24u, tm_03_24u, tm_04_24u, tm_05_24u, tm_06_24u, tm_07_24u, tm_08_24u, tm_09_24u, tm_10_24u, tm_11_24u, tm_12_24u, tm_13_24u, tm_14_24u, tm_15_24u, tm_16_24u, tm_17_24u, tm_18_24u, tm_19_24u, tm_20_24u, tm_21_24u, tm_22_24u, tm_23_24u, tm_tot_24u from powerapp_hourlyrep_hits_summary where plan = 'PHOTO' and left(tran_dt,7) = '".$current_date."' order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet("PHOTO");


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

$format2 = $workbook->add_format(bg_color => 'gray'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(1);

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
$formatC->set_size('12');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('12');
$formatS->set_color('black');
$formatS->set_align('center');
$formatS->set_border(1);

$formatB = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatB->set_bold();
$formatB->set_font('Calibri');
$formatB->set_size('10');
$formatB->set_color('black');
$formatB->set_align('center');
$formatB->set_border(1);

$formatE = $workbook->add_format(bg_color => 'magenta'); # Add a format
$formatE->set_bold();
$formatE->set_font('Calibri');
$formatE->set_size('10');
$formatE->set_color('black');
$formatE->set_align('center');
$formatE->set_border(1);

$formatP = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP->set_bold();
$formatP->set_font('Calibri');
$formatP->set_size('10');
$formatP->set_color('black');
$formatP->set_align('center');
$formatP->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);



$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 24, 4);
$worksheet->set_column(25, 25, 6);
$worksheet->set_column(26, 26, 1);
$worksheet->set_column(27, 50, 4);
$worksheet->set_column(51, 51, 6);

$worksheet->set_column(52, 52, 3);

$worksheet->set_column(53, 76, 4);
$worksheet->set_column(77, 77, 6);
$worksheet->set_column(78, 78, 1);
$worksheet->set_column(79, 102, 4);
$worksheet->set_column(103,103, 6);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:AZ2',  'P H O T O  (HITS)', $formatC);
$worksheet->merge_range('BB2:CZ2', 'P H O T O  (UNIQUE USERS)', $formatS);

$worksheet->merge_range('B3:Z3', '3 HOURS', $formatP);
$worksheet->merge_range('AB3:AZ3', '24 HOURS', $formatU);
$worksheet->merge_range('BB3:BZ3', '3 HOURS', $formatP);
$worksheet->merge_range('CB3:CZ3', '24 HOURS', $formatU);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',  $format);
$worksheet->write($row+$i, $col+1,  '\'00',  $format);
$worksheet->write($row+$i, $col+2,  '\'01',  $format);
$worksheet->write($row+$i, $col+3,  '\'02',  $format);
$worksheet->write($row+$i, $col+4,  '\'03',  $format);
$worksheet->write($row+$i, $col+5,  '\'04',  $format);
$worksheet->write($row+$i, $col+6,  '\'05',  $format);
$worksheet->write($row+$i, $col+7,  '\'06',  $format);
$worksheet->write($row+$i, $col+8,  '\'07',  $format);
$worksheet->write($row+$i, $col+9,  '\'08',  $format);
$worksheet->write($row+$i, $col+10, '\'09',  $format);
$worksheet->write($row+$i, $col+11, '\'10',  $format);
$worksheet->write($row+$i, $col+12, '\'11',  $format);
$worksheet->write($row+$i, $col+13, '\'12',  $format);
$worksheet->write($row+$i, $col+14, '\'13',  $format);
$worksheet->write($row+$i, $col+15, '\'14',  $format);
$worksheet->write($row+$i, $col+16, '\'15',  $format);
$worksheet->write($row+$i, $col+17, '\'16',  $format);
$worksheet->write($row+$i, $col+18, '\'17',  $format);
$worksheet->write($row+$i, $col+19, '\'18',  $format);
$worksheet->write($row+$i, $col+20, '\'19',  $format);
$worksheet->write($row+$i, $col+21, '\'20',  $format);
$worksheet->write($row+$i, $col+22, '\'21',  $format);
$worksheet->write($row+$i, $col+23, '\'22',  $format);
$worksheet->write($row+$i, $col+24, '\'23',  $format);
$worksheet->write($row+$i, $col+25, 'TOTAL', $format);

$worksheet->write($row+$i, $col+27, '\'00',  $format);
$worksheet->write($row+$i, $col+28, '\'01',  $format);
$worksheet->write($row+$i, $col+29, '\'02',  $format);
$worksheet->write($row+$i, $col+30, '\'03',  $format);
$worksheet->write($row+$i, $col+31, '\'04',  $format);
$worksheet->write($row+$i, $col+32, '\'05',  $format);
$worksheet->write($row+$i, $col+33, '\'06',  $format);
$worksheet->write($row+$i, $col+34, '\'07',  $format);
$worksheet->write($row+$i, $col+35, '\'08',  $format);
$worksheet->write($row+$i, $col+36, '\'09',  $format);
$worksheet->write($row+$i, $col+37, '\'10',  $format);
$worksheet->write($row+$i, $col+38, '\'11',  $format);
$worksheet->write($row+$i, $col+39, '\'12',  $format);
$worksheet->write($row+$i, $col+40, '\'13',  $format);
$worksheet->write($row+$i, $col+41, '\'14',  $format);
$worksheet->write($row+$i, $col+42, '\'15',  $format);
$worksheet->write($row+$i, $col+43, '\'16',  $format);
$worksheet->write($row+$i, $col+44, '\'17',  $format);
$worksheet->write($row+$i, $col+45, '\'18',  $format);
$worksheet->write($row+$i, $col+46, '\'19',  $format);
$worksheet->write($row+$i, $col+47, '\'20',  $format);
$worksheet->write($row+$i, $col+48, '\'21',  $format);
$worksheet->write($row+$i, $col+49, '\'22',  $format);
$worksheet->write($row+$i, $col+50, '\'23',  $format);
$worksheet->write($row+$i, $col+51, 'TOTAL', $format);

$worksheet->write($row+$i, $col+53, '\'00',  $format);
$worksheet->write($row+$i, $col+54, '\'01',  $format);
$worksheet->write($row+$i, $col+55, '\'02',  $format);
$worksheet->write($row+$i, $col+56, '\'03',  $format);
$worksheet->write($row+$i, $col+57, '\'04',  $format);
$worksheet->write($row+$i, $col+58, '\'05',  $format);
$worksheet->write($row+$i, $col+59, '\'06',  $format);
$worksheet->write($row+$i, $col+60, '\'07',  $format);
$worksheet->write($row+$i, $col+61, '\'08',  $format);
$worksheet->write($row+$i, $col+62, '\'09',  $format);
$worksheet->write($row+$i, $col+63, '\'10',  $format);
$worksheet->write($row+$i, $col+64, '\'11',  $format);
$worksheet->write($row+$i, $col+65, '\'12',  $format);
$worksheet->write($row+$i, $col+66, '\'13',  $format);
$worksheet->write($row+$i, $col+67, '\'14',  $format);
$worksheet->write($row+$i, $col+68, '\'15',  $format);
$worksheet->write($row+$i, $col+69, '\'16',  $format);
$worksheet->write($row+$i, $col+70, '\'17',  $format);
$worksheet->write($row+$i, $col+71, '\'18',  $format);
$worksheet->write($row+$i, $col+72, '\'19',  $format);
$worksheet->write($row+$i, $col+73, '\'20',  $format);
$worksheet->write($row+$i, $col+74, '\'21',  $format);
$worksheet->write($row+$i, $col+75, '\'22',  $format);
$worksheet->write($row+$i, $col+76, '\'23',  $format);
$worksheet->write($row+$i, $col+77, 'TOTAL', $format);

$worksheet->write($row+$i, $col+79,  '\'00',  $format);
$worksheet->write($row+$i, $col+80,  '\'01',  $format);
$worksheet->write($row+$i, $col+81,  '\'02',  $format);
$worksheet->write($row+$i, $col+82,  '\'03',  $format);
$worksheet->write($row+$i, $col+83,  '\'04',  $format);
$worksheet->write($row+$i, $col+84,  '\'05',  $format);
$worksheet->write($row+$i, $col+85,  '\'06',  $format);
$worksheet->write($row+$i, $col+86,  '\'07',  $format);
$worksheet->write($row+$i, $col+87,  '\'08',  $format);
$worksheet->write($row+$i, $col+88,  '\'09',  $format);
$worksheet->write($row+$i, $col+89,  '\'10',  $format);
$worksheet->write($row+$i, $col+90,  '\'11',  $format);
$worksheet->write($row+$i, $col+91,  '\'12',  $format);
$worksheet->write($row+$i, $col+92,  '\'13',  $format);
$worksheet->write($row+$i, $col+93,  '\'14',  $format);
$worksheet->write($row+$i, $col+94,  '\'15',  $format);
$worksheet->write($row+$i, $col+95,  '\'16',  $format);
$worksheet->write($row+$i, $col+96,  '\'17',  $format);
$worksheet->write($row+$i, $col+97,  '\'18',  $format);
$worksheet->write($row+$i, $col+98,  '\'19',  $format);
$worksheet->write($row+$i, $col+99,  '\'20',  $format);
$worksheet->write($row+$i, $col+100, '\'21',  $format);
$worksheet->write($row+$i, $col+101, '\'22',  $format);
$worksheet->write($row+$i, $col+102, '\'23',  $format);
$worksheet->write($row+$i, $col+103, 'TOTAL', $format);


while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1);
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $formatT);

   $worksheet->write($row+$i, $col+27, $rowRst[26], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[27], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[28], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[29], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[30], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[31], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[32], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[33], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[34], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[35], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[36], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[37], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[38], $format1);
   $worksheet->write($row+$i, $col+40, $rowRst[39], $format1);
   $worksheet->write($row+$i, $col+41, $rowRst[40], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[41], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[42], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[43], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[44], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[45], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[46], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[47], $format1);
   $worksheet->write($row+$i, $col+49, $rowRst[48], $format1);
   $worksheet->write($row+$i, $col+50, $rowRst[49], $format1);
   $worksheet->write($row+$i, $col+51, $rowRst[50], $formatT);
                                                    
   $worksheet->write($row+$i, $col+53, $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+54, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+55, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+56, $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+57, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+58, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+59, $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+60, $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+61, $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+62, $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+63, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+64, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+65, $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+66, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+67, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+68, $rowRst[66], $format1);
   $worksheet->write($row+$i, $col+69, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+70, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+71, $rowRst[69], $format1);
   $worksheet->write($row+$i, $col+72, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+73, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+74, $rowRst[72], $format1);
   $worksheet->write($row+$i, $col+75, $rowRst[73], $format1);
   $worksheet->write($row+$i, $col+76, $rowRst[74], $format1);
   $worksheet->write($row+$i, $col+77, $rowRst[75], $formatT);

   $worksheet->write($row+$i, $col+79,  $rowRst[76],  $format1);
   $worksheet->write($row+$i, $col+80,  $rowRst[77],  $format1);
   $worksheet->write($row+$i, $col+81,  $rowRst[78],  $format1);
   $worksheet->write($row+$i, $col+82,  $rowRst[79],  $format1);
   $worksheet->write($row+$i, $col+83,  $rowRst[80],  $format1);
   $worksheet->write($row+$i, $col+84,  $rowRst[81],  $format1);
   $worksheet->write($row+$i, $col+85,  $rowRst[82],  $format1);
   $worksheet->write($row+$i, $col+86,  $rowRst[83],  $format1);
   $worksheet->write($row+$i, $col+87,  $rowRst[84],  $format1);
   $worksheet->write($row+$i, $col+88,  $rowRst[85],  $format1);
   $worksheet->write($row+$i, $col+89,  $rowRst[86],  $format1);
   $worksheet->write($row+$i, $col+90,  $rowRst[87],  $format1);
   $worksheet->write($row+$i, $col+91,  $rowRst[88],  $format1);
   $worksheet->write($row+$i, $col+92,  $rowRst[89],  $format1);
   $worksheet->write($row+$i, $col+93,  $rowRst[90],  $format1);
   $worksheet->write($row+$i, $col+94,  $rowRst[91],  $format1);
   $worksheet->write($row+$i, $col+95,  $rowRst[92],  $format1);
   $worksheet->write($row+$i, $col+96,  $rowRst[93],  $format1);
   $worksheet->write($row+$i, $col+97,  $rowRst[94],  $format1);
   $worksheet->write($row+$i, $col+98,  $rowRst[95],  $format1);
   $worksheet->write($row+$i, $col+99,  $rowRst[96],  $format1);
   $worksheet->write($row+$i, $col+100, $rowRst[97],  $format1);
   $worksheet->write($row+$i, $col+101, $rowRst[98],  $format1);
   $worksheet->write($row+$i, $col+102, $rowRst[99],  $format1);
   $worksheet->write($row+$i, $col+103, $rowRst[100], $formatT);
}




###################################################
###################################################
###################################################

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  tm_00_3h, tm_01_3h, tm_02_3h, tm_03_3h, tm_04_3h, tm_05_3h, tm_06_3h, tm_07_3h, tm_08_3h, tm_09_3h, tm_10_3h, tm_11_3h, tm_12_3h, tm_13_3h, tm_14_3h, tm_15_3h, tm_16_3h, tm_17_3h, tm_18_3h, tm_19_3h, tm_20_3h, tm_21_3h, tm_22_3h, tm_23_3h, tm_tot_3h, tm_00_24h, tm_01_24h, tm_02_24h, tm_03_24h, tm_04_24h, tm_05_24h, tm_06_24h, tm_07_24h, tm_08_24h, tm_09_24h, tm_10_24h, tm_11_24h, tm_12_24h, tm_13_24h, tm_14_24h, tm_15_24h, tm_16_24h, tm_17_24h, tm_18_24h, tm_19_24h, tm_20_24h, tm_21_24h, tm_22_24h, tm_23_24h, tm_tot_24h, tm_00_3u, tm_01_3u, tm_02_3u, tm_03_3u, tm_04_3u, tm_05_3u, tm_06_3u, tm_07_3u, tm_08_3u, tm_09_3u, tm_10_3u, tm_11_3u, tm_12_3u, tm_13_3u, tm_14_3u, tm_15_3u, tm_16_3u, tm_17_3u, tm_18_3u, tm_19_3u, tm_20_3u, tm_21_3u, tm_22_3u, tm_23_3u, tm_tot_3u, tm_00_24u, tm_01_24u, tm_02_24u, tm_03_24u, tm_04_24u, tm_05_24u, tm_06_24u, tm_07_24u, tm_08_24u, tm_09_24u, tm_10_24u, tm_11_24u, tm_12_24u, tm_13_24u, tm_14_24u, tm_15_24u, tm_16_24u, tm_17_24u, tm_18_24u, tm_19_24u, tm_20_24u, tm_21_24u, tm_22_24u, tm_23_24u, tm_tot_24u from powerapp_hourlyrep_hits_summary where plan = 'UNLI' and left(tran_dt,7) = '".$current_date."' order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet("UNLI");


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

$format2 = $workbook->add_format(bg_color => 'gray'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(1);

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
$formatC->set_size('12');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('12');
$formatS->set_color('black');
$formatS->set_align('center');
$formatS->set_border(1);

$formatB = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatB->set_bold();
$formatB->set_font('Calibri');
$formatB->set_size('10');
$formatB->set_color('black');
$formatB->set_align('center');
$formatB->set_border(1);

$formatE = $workbook->add_format(bg_color => 'magenta'); # Add a format
$formatE->set_bold();
$formatE->set_font('Calibri');
$formatE->set_size('10');
$formatE->set_color('black');
$formatE->set_align('center');
$formatE->set_border(1);

$formatP = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP->set_bold();
$formatP->set_font('Calibri');
$formatP->set_size('10');
$formatP->set_color('black');
$formatP->set_align('center');
$formatP->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);



$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 24, 4);
$worksheet->set_column(25, 25, 6);
$worksheet->set_column(26, 26, 1);
$worksheet->set_column(27, 50, 4);
$worksheet->set_column(51, 51, 6);

$worksheet->set_column(52, 52, 3);

$worksheet->set_column(53, 76, 4);
$worksheet->set_column(77, 77, 6);
$worksheet->set_column(78, 78, 1);
$worksheet->set_column(79, 102, 4);
$worksheet->set_column(103,103, 6);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:AZ2',  'U N L I  (HITS)', $formatC);
$worksheet->merge_range('BB2:CZ2', 'U N L I  (UNIQUE USERS)', $formatS);

$worksheet->merge_range('B3:Z3', '3 HOURS', $formatP);
$worksheet->merge_range('AB3:AZ3', '24 HOURS', $formatU);
$worksheet->merge_range('BB3:BZ3', '3 HOURS', $formatP);
$worksheet->merge_range('CB3:CZ3', '24 HOURS', $formatU);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',  $format);
$worksheet->write($row+$i, $col+1,  '\'00',  $format);
$worksheet->write($row+$i, $col+2,  '\'01',  $format);
$worksheet->write($row+$i, $col+3,  '\'02',  $format);
$worksheet->write($row+$i, $col+4,  '\'03',  $format);
$worksheet->write($row+$i, $col+5,  '\'04',  $format);
$worksheet->write($row+$i, $col+6,  '\'05',  $format);
$worksheet->write($row+$i, $col+7,  '\'06',  $format);
$worksheet->write($row+$i, $col+8,  '\'07',  $format);
$worksheet->write($row+$i, $col+9,  '\'08',  $format);
$worksheet->write($row+$i, $col+10, '\'09',  $format);
$worksheet->write($row+$i, $col+11, '\'10',  $format);
$worksheet->write($row+$i, $col+12, '\'11',  $format);
$worksheet->write($row+$i, $col+13, '\'12',  $format);
$worksheet->write($row+$i, $col+14, '\'13',  $format);
$worksheet->write($row+$i, $col+15, '\'14',  $format);
$worksheet->write($row+$i, $col+16, '\'15',  $format);
$worksheet->write($row+$i, $col+17, '\'16',  $format);
$worksheet->write($row+$i, $col+18, '\'17',  $format);
$worksheet->write($row+$i, $col+19, '\'18',  $format);
$worksheet->write($row+$i, $col+20, '\'19',  $format);
$worksheet->write($row+$i, $col+21, '\'20',  $format);
$worksheet->write($row+$i, $col+22, '\'21',  $format);
$worksheet->write($row+$i, $col+23, '\'22',  $format);
$worksheet->write($row+$i, $col+24, '\'23',  $format);
$worksheet->write($row+$i, $col+25, 'TOTAL', $format);

$worksheet->write($row+$i, $col+27, '\'00',  $format);
$worksheet->write($row+$i, $col+28, '\'01',  $format);
$worksheet->write($row+$i, $col+29, '\'02',  $format);
$worksheet->write($row+$i, $col+30, '\'03',  $format);
$worksheet->write($row+$i, $col+31, '\'04',  $format);
$worksheet->write($row+$i, $col+32, '\'05',  $format);
$worksheet->write($row+$i, $col+33, '\'06',  $format);
$worksheet->write($row+$i, $col+34, '\'07',  $format);
$worksheet->write($row+$i, $col+35, '\'08',  $format);
$worksheet->write($row+$i, $col+36, '\'09',  $format);
$worksheet->write($row+$i, $col+37, '\'10',  $format);
$worksheet->write($row+$i, $col+38, '\'11',  $format);
$worksheet->write($row+$i, $col+39, '\'12',  $format);
$worksheet->write($row+$i, $col+40, '\'13',  $format);
$worksheet->write($row+$i, $col+41, '\'14',  $format);
$worksheet->write($row+$i, $col+42, '\'15',  $format);
$worksheet->write($row+$i, $col+43, '\'16',  $format);
$worksheet->write($row+$i, $col+44, '\'17',  $format);
$worksheet->write($row+$i, $col+45, '\'18',  $format);
$worksheet->write($row+$i, $col+46, '\'19',  $format);
$worksheet->write($row+$i, $col+47, '\'20',  $format);
$worksheet->write($row+$i, $col+48, '\'21',  $format);
$worksheet->write($row+$i, $col+49, '\'22',  $format);
$worksheet->write($row+$i, $col+50, '\'23',  $format);
$worksheet->write($row+$i, $col+51, 'TOTAL', $format);

$worksheet->write($row+$i, $col+53, '\'00',  $format);
$worksheet->write($row+$i, $col+54, '\'01',  $format);
$worksheet->write($row+$i, $col+55, '\'02',  $format);
$worksheet->write($row+$i, $col+56, '\'03',  $format);
$worksheet->write($row+$i, $col+57, '\'04',  $format);
$worksheet->write($row+$i, $col+58, '\'05',  $format);
$worksheet->write($row+$i, $col+59, '\'06',  $format);
$worksheet->write($row+$i, $col+60, '\'07',  $format);
$worksheet->write($row+$i, $col+61, '\'08',  $format);
$worksheet->write($row+$i, $col+62, '\'09',  $format);
$worksheet->write($row+$i, $col+63, '\'10',  $format);
$worksheet->write($row+$i, $col+64, '\'11',  $format);
$worksheet->write($row+$i, $col+65, '\'12',  $format);
$worksheet->write($row+$i, $col+66, '\'13',  $format);
$worksheet->write($row+$i, $col+67, '\'14',  $format);
$worksheet->write($row+$i, $col+68, '\'15',  $format);
$worksheet->write($row+$i, $col+69, '\'16',  $format);
$worksheet->write($row+$i, $col+70, '\'17',  $format);
$worksheet->write($row+$i, $col+71, '\'18',  $format);
$worksheet->write($row+$i, $col+72, '\'19',  $format);
$worksheet->write($row+$i, $col+73, '\'20',  $format);
$worksheet->write($row+$i, $col+74, '\'21',  $format);
$worksheet->write($row+$i, $col+75, '\'22',  $format);
$worksheet->write($row+$i, $col+76, '\'23',  $format);
$worksheet->write($row+$i, $col+77, 'TOTAL', $format);

$worksheet->write($row+$i, $col+79,  '\'00',  $format);
$worksheet->write($row+$i, $col+80,  '\'01',  $format);
$worksheet->write($row+$i, $col+81,  '\'02',  $format);
$worksheet->write($row+$i, $col+82,  '\'03',  $format);
$worksheet->write($row+$i, $col+83,  '\'04',  $format);
$worksheet->write($row+$i, $col+84,  '\'05',  $format);
$worksheet->write($row+$i, $col+85,  '\'06',  $format);
$worksheet->write($row+$i, $col+86,  '\'07',  $format);
$worksheet->write($row+$i, $col+87,  '\'08',  $format);
$worksheet->write($row+$i, $col+88,  '\'09',  $format);
$worksheet->write($row+$i, $col+89,  '\'10',  $format);
$worksheet->write($row+$i, $col+90,  '\'11',  $format);
$worksheet->write($row+$i, $col+91,  '\'12',  $format);
$worksheet->write($row+$i, $col+92,  '\'13',  $format);
$worksheet->write($row+$i, $col+93,  '\'14',  $format);
$worksheet->write($row+$i, $col+94,  '\'15',  $format);
$worksheet->write($row+$i, $col+95,  '\'16',  $format);
$worksheet->write($row+$i, $col+96,  '\'17',  $format);
$worksheet->write($row+$i, $col+97,  '\'18',  $format);
$worksheet->write($row+$i, $col+98,  '\'19',  $format);
$worksheet->write($row+$i, $col+99,  '\'20',  $format);
$worksheet->write($row+$i, $col+100, '\'21',  $format);
$worksheet->write($row+$i, $col+101, '\'22',  $format);
$worksheet->write($row+$i, $col+102, '\'23',  $format);
$worksheet->write($row+$i, $col+103, 'TOTAL', $format);


while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1);
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $formatT);

   $worksheet->write($row+$i, $col+27, $rowRst[26], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[27], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[28], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[29], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[30], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[31], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[32], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[33], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[34], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[35], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[36], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[37], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[38], $format1);
   $worksheet->write($row+$i, $col+40, $rowRst[39], $format1);
   $worksheet->write($row+$i, $col+41, $rowRst[40], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[41], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[42], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[43], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[44], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[45], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[46], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[47], $format1);
   $worksheet->write($row+$i, $col+49, $rowRst[48], $format1);
   $worksheet->write($row+$i, $col+50, $rowRst[49], $format1);
   $worksheet->write($row+$i, $col+51, $rowRst[50], $formatT);
                                                    
   $worksheet->write($row+$i, $col+53, $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+54, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+55, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+56, $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+57, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+58, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+59, $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+60, $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+61, $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+62, $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+63, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+64, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+65, $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+66, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+67, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+68, $rowRst[66], $format1);
   $worksheet->write($row+$i, $col+69, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+70, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+71, $rowRst[69], $format1);
   $worksheet->write($row+$i, $col+72, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+73, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+74, $rowRst[72], $format1);
   $worksheet->write($row+$i, $col+75, $rowRst[73], $format1);
   $worksheet->write($row+$i, $col+76, $rowRst[74], $format1);
   $worksheet->write($row+$i, $col+77, $rowRst[75], $formatT);

   $worksheet->write($row+$i, $col+79,  $rowRst[76],  $format1);
   $worksheet->write($row+$i, $col+80,  $rowRst[77],  $format1);
   $worksheet->write($row+$i, $col+81,  $rowRst[78],  $format1);
   $worksheet->write($row+$i, $col+82,  $rowRst[79],  $format1);
   $worksheet->write($row+$i, $col+83,  $rowRst[80],  $format1);
   $worksheet->write($row+$i, $col+84,  $rowRst[81],  $format1);
   $worksheet->write($row+$i, $col+85,  $rowRst[82],  $format1);
   $worksheet->write($row+$i, $col+86,  $rowRst[83],  $format1);
   $worksheet->write($row+$i, $col+87,  $rowRst[84],  $format1);
   $worksheet->write($row+$i, $col+88,  $rowRst[85],  $format1);
   $worksheet->write($row+$i, $col+89,  $rowRst[86],  $format1);
   $worksheet->write($row+$i, $col+90,  $rowRst[87],  $format1);
   $worksheet->write($row+$i, $col+91,  $rowRst[88],  $format1);
   $worksheet->write($row+$i, $col+92,  $rowRst[89],  $format1);
   $worksheet->write($row+$i, $col+93,  $rowRst[90],  $format1);
   $worksheet->write($row+$i, $col+94,  $rowRst[91],  $format1);
   $worksheet->write($row+$i, $col+95,  $rowRst[92],  $format1);
   $worksheet->write($row+$i, $col+96,  $rowRst[93],  $format1);
   $worksheet->write($row+$i, $col+97,  $rowRst[94],  $format1);
   $worksheet->write($row+$i, $col+98,  $rowRst[95],  $format1);
   $worksheet->write($row+$i, $col+99,  $rowRst[96],  $format1);
   $worksheet->write($row+$i, $col+100, $rowRst[97],  $format1);
   $worksheet->write($row+$i, $col+101, $rowRst[98],  $format1);
   $worksheet->write($row+$i, $col+102, $rowRst[99],  $format1);
   $worksheet->write($row+$i, $col+103, $rowRst[100], $formatT);
}



###################################################
###################################################
###################################################

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  tm_00_3h, tm_01_3h, tm_02_3h, tm_03_3h, tm_04_3h, tm_05_3h, tm_06_3h, tm_07_3h, tm_08_3h, tm_09_3h, tm_10_3h, tm_11_3h, tm_12_3h, tm_13_3h, tm_14_3h, tm_15_3h, tm_16_3h, tm_17_3h, tm_18_3h, tm_19_3h, tm_20_3h, tm_21_3h, tm_22_3h, tm_23_3h, tm_tot_3h, tm_00_24h, tm_01_24h, tm_02_24h, tm_03_24h, tm_04_24h, tm_05_24h, tm_06_24h, tm_07_24h, tm_08_24h, tm_09_24h, tm_10_24h, tm_11_24h, tm_12_24h, tm_13_24h, tm_14_24h, tm_15_24h, tm_16_24h, tm_17_24h, tm_18_24h, tm_19_24h, tm_20_24h, tm_21_24h, tm_22_24h, tm_23_24h, tm_tot_24h, tm_00_3u, tm_01_3u, tm_02_3u, tm_03_3u, tm_04_3u, tm_05_3u, tm_06_3u, tm_07_3u, tm_08_3u, tm_09_3u, tm_10_3u, tm_11_3u, tm_12_3u, tm_13_3u, tm_14_3u, tm_15_3u, tm_16_3u, tm_17_3u, tm_18_3u, tm_19_3u, tm_20_3u, tm_21_3u, tm_22_3u, tm_23_3u, tm_tot_3u, tm_00_24u, tm_01_24u, tm_02_24u, tm_03_24u, tm_04_24u, tm_05_24u, tm_06_24u, tm_07_24u, tm_08_24u, tm_09_24u, tm_10_24u, tm_11_24u, tm_12_24u, tm_13_24u, tm_14_24u, tm_15_24u, tm_16_24u, tm_17_24u, tm_18_24u, tm_19_24u, tm_20_24u, tm_21_24u, tm_22_24u, tm_23_24u, tm_tot_24u from powerapp_hourlyrep_hits_summary where plan = 'SOCIAL' and left(tran_dt,7) = '".$current_date."' order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet("SOCIAL");


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

$format2 = $workbook->add_format(bg_color => 'gray'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(1);

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
$formatC->set_size('12');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('12');
$formatS->set_color('black');
$formatS->set_align('center');
$formatS->set_border(1);

$formatB = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatB->set_bold();
$formatB->set_font('Calibri');
$formatB->set_size('10');
$formatB->set_color('black');
$formatB->set_align('center');
$formatB->set_border(1);

$formatE = $workbook->add_format(bg_color => 'magenta'); # Add a format
$formatE->set_bold();
$formatE->set_font('Calibri');
$formatE->set_size('10');
$formatE->set_color('black');
$formatE->set_align('center');
$formatE->set_border(1);

$formatP = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP->set_bold();
$formatP->set_font('Calibri');
$formatP->set_size('10');
$formatP->set_color('black');
$formatP->set_align('center');
$formatP->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);



$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 24, 4);
$worksheet->set_column(25, 25, 6);
$worksheet->set_column(26, 26, 1);
$worksheet->set_column(27, 50, 4);
$worksheet->set_column(51, 51, 6);

$worksheet->set_column(52, 52, 3);

$worksheet->set_column(53, 76, 4);
$worksheet->set_column(77, 77, 6);
$worksheet->set_column(78, 78, 1);
$worksheet->set_column(79, 102, 4);
$worksheet->set_column(103,103, 6);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:AZ2',  'S O C I A L  (HITS)', $formatC);
$worksheet->merge_range('BB2:CZ2', 'S O C I A L  (UNIQUE USERS)', $formatS);

$worksheet->merge_range('B3:Z3', '3 HOURS', $formatP);
$worksheet->merge_range('AB3:AZ3', '24 HOURS', $formatU);
$worksheet->merge_range('BB3:BZ3', '3 HOURS', $formatP);
$worksheet->merge_range('CB3:CZ3', '24 HOURS', $formatU);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',  $format);
$worksheet->write($row+$i, $col+1,  '\'00',  $format);
$worksheet->write($row+$i, $col+2,  '\'01',  $format);
$worksheet->write($row+$i, $col+3,  '\'02',  $format);
$worksheet->write($row+$i, $col+4,  '\'03',  $format);
$worksheet->write($row+$i, $col+5,  '\'04',  $format);
$worksheet->write($row+$i, $col+6,  '\'05',  $format);
$worksheet->write($row+$i, $col+7,  '\'06',  $format);
$worksheet->write($row+$i, $col+8,  '\'07',  $format);
$worksheet->write($row+$i, $col+9,  '\'08',  $format);
$worksheet->write($row+$i, $col+10, '\'09',  $format);
$worksheet->write($row+$i, $col+11, '\'10',  $format);
$worksheet->write($row+$i, $col+12, '\'11',  $format);
$worksheet->write($row+$i, $col+13, '\'12',  $format);
$worksheet->write($row+$i, $col+14, '\'13',  $format);
$worksheet->write($row+$i, $col+15, '\'14',  $format);
$worksheet->write($row+$i, $col+16, '\'15',  $format);
$worksheet->write($row+$i, $col+17, '\'16',  $format);
$worksheet->write($row+$i, $col+18, '\'17',  $format);
$worksheet->write($row+$i, $col+19, '\'18',  $format);
$worksheet->write($row+$i, $col+20, '\'19',  $format);
$worksheet->write($row+$i, $col+21, '\'20',  $format);
$worksheet->write($row+$i, $col+22, '\'21',  $format);
$worksheet->write($row+$i, $col+23, '\'22',  $format);
$worksheet->write($row+$i, $col+24, '\'23',  $format);
$worksheet->write($row+$i, $col+25, 'TOTAL', $format);

$worksheet->write($row+$i, $col+27, '\'00',  $format);
$worksheet->write($row+$i, $col+28, '\'01',  $format);
$worksheet->write($row+$i, $col+29, '\'02',  $format);
$worksheet->write($row+$i, $col+30, '\'03',  $format);
$worksheet->write($row+$i, $col+31, '\'04',  $format);
$worksheet->write($row+$i, $col+32, '\'05',  $format);
$worksheet->write($row+$i, $col+33, '\'06',  $format);
$worksheet->write($row+$i, $col+34, '\'07',  $format);
$worksheet->write($row+$i, $col+35, '\'08',  $format);
$worksheet->write($row+$i, $col+36, '\'09',  $format);
$worksheet->write($row+$i, $col+37, '\'10',  $format);
$worksheet->write($row+$i, $col+38, '\'11',  $format);
$worksheet->write($row+$i, $col+39, '\'12',  $format);
$worksheet->write($row+$i, $col+40, '\'13',  $format);
$worksheet->write($row+$i, $col+41, '\'14',  $format);
$worksheet->write($row+$i, $col+42, '\'15',  $format);
$worksheet->write($row+$i, $col+43, '\'16',  $format);
$worksheet->write($row+$i, $col+44, '\'17',  $format);
$worksheet->write($row+$i, $col+45, '\'18',  $format);
$worksheet->write($row+$i, $col+46, '\'19',  $format);
$worksheet->write($row+$i, $col+47, '\'20',  $format);
$worksheet->write($row+$i, $col+48, '\'21',  $format);
$worksheet->write($row+$i, $col+49, '\'22',  $format);
$worksheet->write($row+$i, $col+50, '\'23',  $format);
$worksheet->write($row+$i, $col+51, 'TOTAL', $format);

$worksheet->write($row+$i, $col+53, '\'00',  $format);
$worksheet->write($row+$i, $col+54, '\'01',  $format);
$worksheet->write($row+$i, $col+55, '\'02',  $format);
$worksheet->write($row+$i, $col+56, '\'03',  $format);
$worksheet->write($row+$i, $col+57, '\'04',  $format);
$worksheet->write($row+$i, $col+58, '\'05',  $format);
$worksheet->write($row+$i, $col+59, '\'06',  $format);
$worksheet->write($row+$i, $col+60, '\'07',  $format);
$worksheet->write($row+$i, $col+61, '\'08',  $format);
$worksheet->write($row+$i, $col+62, '\'09',  $format);
$worksheet->write($row+$i, $col+63, '\'10',  $format);
$worksheet->write($row+$i, $col+64, '\'11',  $format);
$worksheet->write($row+$i, $col+65, '\'12',  $format);
$worksheet->write($row+$i, $col+66, '\'13',  $format);
$worksheet->write($row+$i, $col+67, '\'14',  $format);
$worksheet->write($row+$i, $col+68, '\'15',  $format);
$worksheet->write($row+$i, $col+69, '\'16',  $format);
$worksheet->write($row+$i, $col+70, '\'17',  $format);
$worksheet->write($row+$i, $col+71, '\'18',  $format);
$worksheet->write($row+$i, $col+72, '\'19',  $format);
$worksheet->write($row+$i, $col+73, '\'20',  $format);
$worksheet->write($row+$i, $col+74, '\'21',  $format);
$worksheet->write($row+$i, $col+75, '\'22',  $format);
$worksheet->write($row+$i, $col+76, '\'23',  $format);
$worksheet->write($row+$i, $col+77, 'TOTAL', $format);

$worksheet->write($row+$i, $col+79,  '\'00',  $format);
$worksheet->write($row+$i, $col+80,  '\'01',  $format);
$worksheet->write($row+$i, $col+81,  '\'02',  $format);
$worksheet->write($row+$i, $col+82,  '\'03',  $format);
$worksheet->write($row+$i, $col+83,  '\'04',  $format);
$worksheet->write($row+$i, $col+84,  '\'05',  $format);
$worksheet->write($row+$i, $col+85,  '\'06',  $format);
$worksheet->write($row+$i, $col+86,  '\'07',  $format);
$worksheet->write($row+$i, $col+87,  '\'08',  $format);
$worksheet->write($row+$i, $col+88,  '\'09',  $format);
$worksheet->write($row+$i, $col+89,  '\'10',  $format);
$worksheet->write($row+$i, $col+90,  '\'11',  $format);
$worksheet->write($row+$i, $col+91,  '\'12',  $format);
$worksheet->write($row+$i, $col+92,  '\'13',  $format);
$worksheet->write($row+$i, $col+93,  '\'14',  $format);
$worksheet->write($row+$i, $col+94,  '\'15',  $format);
$worksheet->write($row+$i, $col+95,  '\'16',  $format);
$worksheet->write($row+$i, $col+96,  '\'17',  $format);
$worksheet->write($row+$i, $col+97,  '\'18',  $format);
$worksheet->write($row+$i, $col+98,  '\'19',  $format);
$worksheet->write($row+$i, $col+99,  '\'20',  $format);
$worksheet->write($row+$i, $col+100, '\'21',  $format);
$worksheet->write($row+$i, $col+101, '\'22',  $format);
$worksheet->write($row+$i, $col+102, '\'23',  $format);
$worksheet->write($row+$i, $col+103, 'TOTAL', $format);


while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1);
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $formatT);

   $worksheet->write($row+$i, $col+27, $rowRst[26], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[27], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[28], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[29], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[30], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[31], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[32], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[33], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[34], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[35], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[36], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[37], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[38], $format1);
   $worksheet->write($row+$i, $col+40, $rowRst[39], $format1);
   $worksheet->write($row+$i, $col+41, $rowRst[40], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[41], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[42], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[43], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[44], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[45], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[46], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[47], $format1);
   $worksheet->write($row+$i, $col+49, $rowRst[48], $format1);
   $worksheet->write($row+$i, $col+50, $rowRst[49], $format1);
   $worksheet->write($row+$i, $col+51, $rowRst[50], $formatT);
                                                    
   $worksheet->write($row+$i, $col+53, $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+54, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+55, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+56, $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+57, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+58, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+59, $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+60, $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+61, $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+62, $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+63, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+64, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+65, $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+66, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+67, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+68, $rowRst[66], $format1);
   $worksheet->write($row+$i, $col+69, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+70, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+71, $rowRst[69], $format1);
   $worksheet->write($row+$i, $col+72, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+73, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+74, $rowRst[72], $format1);
   $worksheet->write($row+$i, $col+75, $rowRst[73], $format1);
   $worksheet->write($row+$i, $col+76, $rowRst[74], $format1);
   $worksheet->write($row+$i, $col+77, $rowRst[75], $formatT);

   $worksheet->write($row+$i, $col+79,  $rowRst[76],  $format1);
   $worksheet->write($row+$i, $col+80,  $rowRst[77],  $format1);
   $worksheet->write($row+$i, $col+81,  $rowRst[78],  $format1);
   $worksheet->write($row+$i, $col+82,  $rowRst[79],  $format1);
   $worksheet->write($row+$i, $col+83,  $rowRst[80],  $format1);
   $worksheet->write($row+$i, $col+84,  $rowRst[81],  $format1);
   $worksheet->write($row+$i, $col+85,  $rowRst[82],  $format1);
   $worksheet->write($row+$i, $col+86,  $rowRst[83],  $format1);
   $worksheet->write($row+$i, $col+87,  $rowRst[84],  $format1);
   $worksheet->write($row+$i, $col+88,  $rowRst[85],  $format1);
   $worksheet->write($row+$i, $col+89,  $rowRst[86],  $format1);
   $worksheet->write($row+$i, $col+90,  $rowRst[87],  $format1);
   $worksheet->write($row+$i, $col+91,  $rowRst[88],  $format1);
   $worksheet->write($row+$i, $col+92,  $rowRst[89],  $format1);
   $worksheet->write($row+$i, $col+93,  $rowRst[90],  $format1);
   $worksheet->write($row+$i, $col+94,  $rowRst[91],  $format1);
   $worksheet->write($row+$i, $col+95,  $rowRst[92],  $format1);
   $worksheet->write($row+$i, $col+96,  $rowRst[93],  $format1);
   $worksheet->write($row+$i, $col+97,  $rowRst[94],  $format1);
   $worksheet->write($row+$i, $col+98,  $rowRst[95],  $format1);
   $worksheet->write($row+$i, $col+99,  $rowRst[96],  $format1);
   $worksheet->write($row+$i, $col+100, $rowRst[97],  $format1);
   $worksheet->write($row+$i, $col+101, $rowRst[98],  $format1);
   $worksheet->write($row+$i, $col+102, $rowRst[99],  $format1);
   $worksheet->write($row+$i, $col+103, $rowRst[100], $formatT);
}




###################################################
###################################################
###################################################

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  tm_00_3h, tm_01_3h, tm_02_3h, tm_03_3h, tm_04_3h, tm_05_3h, tm_06_3h, tm_07_3h, tm_08_3h, tm_09_3h, tm_10_3h, tm_11_3h, tm_12_3h, tm_13_3h, tm_14_3h, tm_15_3h, tm_16_3h, tm_17_3h, tm_18_3h, tm_19_3h, tm_20_3h, tm_21_3h, tm_22_3h, tm_23_3h, tm_tot_3h, tm_00_24h, tm_01_24h, tm_02_24h, tm_03_24h, tm_04_24h, tm_05_24h, tm_06_24h, tm_07_24h, tm_08_24h, tm_09_24h, tm_10_24h, tm_11_24h, tm_12_24h, tm_13_24h, tm_14_24h, tm_15_24h, tm_16_24h, tm_17_24h, tm_18_24h, tm_19_24h, tm_20_24h, tm_21_24h, tm_22_24h, tm_23_24h, tm_tot_24h, tm_00_3u, tm_01_3u, tm_02_3u, tm_03_3u, tm_04_3u, tm_05_3u, tm_06_3u, tm_07_3u, tm_08_3u, tm_09_3u, tm_10_3u, tm_11_3u, tm_12_3u, tm_13_3u, tm_14_3u, tm_15_3u, tm_16_3u, tm_17_3u, tm_18_3u, tm_19_3u, tm_20_3u, tm_21_3u, tm_22_3u, tm_23_3u, tm_tot_3u, tm_00_24u, tm_01_24u, tm_02_24u, tm_03_24u, tm_04_24u, tm_05_24u, tm_06_24u, tm_07_24u, tm_08_24u, tm_09_24u, tm_10_24u, tm_11_24u, tm_12_24u, tm_13_24u, tm_14_24u, tm_15_24u, tm_16_24u, tm_17_24u, tm_18_24u, tm_19_24u, tm_20_24u, tm_21_24u, tm_22_24u, tm_23_24u, tm_tot_24u from powerapp_hourlyrep_hits_summary where plan = 'SPEEDBOOST' and left(tran_dt,7) = '".$current_date."' order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet("SPEEDBOOST");


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

$format2 = $workbook->add_format(bg_color => 'gray'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(1);

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
$formatC->set_size('12');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('12');
$formatS->set_color('black');
$formatS->set_align('center');
$formatS->set_border(1);

$formatB = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatB->set_bold();
$formatB->set_font('Calibri');
$formatB->set_size('10');
$formatB->set_color('black');
$formatB->set_align('center');
$formatB->set_border(1);

$formatE = $workbook->add_format(bg_color => 'magenta'); # Add a format
$formatE->set_bold();
$formatE->set_font('Calibri');
$formatE->set_size('10');
$formatE->set_color('black');
$formatE->set_align('center');
$formatE->set_border(1);

$formatP = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP->set_bold();
$formatP->set_font('Calibri');
$formatP->set_size('10');
$formatP->set_color('black');
$formatP->set_align('center');
$formatP->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);



$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 24, 4);
$worksheet->set_column(25, 25, 6);
$worksheet->set_column(26, 26, 1);
$worksheet->set_column(27, 50, 4);
$worksheet->set_column(51, 51, 6);

$worksheet->set_column(52, 52, 3);

$worksheet->set_column(53, 76, 4);
$worksheet->set_column(77, 77, 6);
$worksheet->set_column(78, 78, 1);
$worksheet->set_column(79, 102, 4);
$worksheet->set_column(103,103, 6);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:AZ2',  'S P E E D B O O S T', $formatC);

$worksheet->merge_range('B3:Z3', 'HITS', $formatP);
$worksheet->merge_range('AB3:AZ3', 'UNIQUE USERS', $formatU);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',  $format);
$worksheet->write($row+$i, $col+1,  '\'00',  $format);
$worksheet->write($row+$i, $col+2,  '\'01',  $format);
$worksheet->write($row+$i, $col+3,  '\'02',  $format);
$worksheet->write($row+$i, $col+4,  '\'03',  $format);
$worksheet->write($row+$i, $col+5,  '\'04',  $format);
$worksheet->write($row+$i, $col+6,  '\'05',  $format);
$worksheet->write($row+$i, $col+7,  '\'06',  $format);
$worksheet->write($row+$i, $col+8,  '\'07',  $format);
$worksheet->write($row+$i, $col+9,  '\'08',  $format);
$worksheet->write($row+$i, $col+10, '\'09',  $format);
$worksheet->write($row+$i, $col+11, '\'10',  $format);
$worksheet->write($row+$i, $col+12, '\'11',  $format);
$worksheet->write($row+$i, $col+13, '\'12',  $format);
$worksheet->write($row+$i, $col+14, '\'13',  $format);
$worksheet->write($row+$i, $col+15, '\'14',  $format);
$worksheet->write($row+$i, $col+16, '\'15',  $format);
$worksheet->write($row+$i, $col+17, '\'16',  $format);
$worksheet->write($row+$i, $col+18, '\'17',  $format);
$worksheet->write($row+$i, $col+19, '\'18',  $format);
$worksheet->write($row+$i, $col+20, '\'19',  $format);
$worksheet->write($row+$i, $col+21, '\'20',  $format);
$worksheet->write($row+$i, $col+22, '\'21',  $format);
$worksheet->write($row+$i, $col+23, '\'22',  $format);
$worksheet->write($row+$i, $col+24, '\'23',  $format);
$worksheet->write($row+$i, $col+25, 'TOTAL', $format);

$worksheet->write($row+$i, $col+27, '\'00',  $format);
$worksheet->write($row+$i, $col+28, '\'01',  $format);
$worksheet->write($row+$i, $col+29, '\'02',  $format);
$worksheet->write($row+$i, $col+30, '\'03',  $format);
$worksheet->write($row+$i, $col+31, '\'04',  $format);
$worksheet->write($row+$i, $col+32, '\'05',  $format);
$worksheet->write($row+$i, $col+33, '\'06',  $format);
$worksheet->write($row+$i, $col+34, '\'07',  $format);
$worksheet->write($row+$i, $col+35, '\'08',  $format);
$worksheet->write($row+$i, $col+36, '\'09',  $format);
$worksheet->write($row+$i, $col+37, '\'10',  $format);
$worksheet->write($row+$i, $col+38, '\'11',  $format);
$worksheet->write($row+$i, $col+39, '\'12',  $format);
$worksheet->write($row+$i, $col+40, '\'13',  $format);
$worksheet->write($row+$i, $col+41, '\'14',  $format);
$worksheet->write($row+$i, $col+42, '\'15',  $format);
$worksheet->write($row+$i, $col+43, '\'16',  $format);
$worksheet->write($row+$i, $col+44, '\'17',  $format);
$worksheet->write($row+$i, $col+45, '\'18',  $format);
$worksheet->write($row+$i, $col+46, '\'19',  $format);
$worksheet->write($row+$i, $col+47, '\'20',  $format);
$worksheet->write($row+$i, $col+48, '\'21',  $format);
$worksheet->write($row+$i, $col+49, '\'22',  $format);
$worksheet->write($row+$i, $col+50, '\'23',  $format);
$worksheet->write($row+$i, $col+51, 'TOTAL', $format);



while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1);
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $formatT);

   $worksheet->write($row+$i, $col+27, $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+40, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+41, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[66], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[69], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[72], $format1);
   $worksheet->write($row+$i, $col+49, $rowRst[73], $format1);
   $worksheet->write($row+$i, $col+50, $rowRst[74], $format1);
   $worksheet->write($row+$i, $col+51, $rowRst[75], $formatT);

}




###################################################
###################################################
###################################################

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  tm_00_3h, tm_01_3h, tm_02_3h, tm_03_3h, tm_04_3h, tm_05_3h, tm_06_3h, tm_07_3h, tm_08_3h, tm_09_3h, tm_10_3h, tm_11_3h, tm_12_3h, tm_13_3h, tm_14_3h, tm_15_3h, tm_16_3h, tm_17_3h, tm_18_3h, tm_19_3h, tm_20_3h, tm_21_3h, tm_22_3h, tm_23_3h, tm_tot_3h, tm_00_24h, tm_01_24h, tm_02_24h, tm_03_24h, tm_04_24h, tm_05_24h, tm_06_24h, tm_07_24h, tm_08_24h, tm_09_24h, tm_10_24h, tm_11_24h, tm_12_24h, tm_13_24h, tm_14_24h, tm_15_24h, tm_16_24h, tm_17_24h, tm_18_24h, tm_19_24h, tm_20_24h, tm_21_24h, tm_22_24h, tm_23_24h, tm_tot_24h, tm_00_3u, tm_01_3u, tm_02_3u, tm_03_3u, tm_04_3u, tm_05_3u, tm_06_3u, tm_07_3u, tm_08_3u, tm_09_3u, tm_10_3u, tm_11_3u, tm_12_3u, tm_13_3u, tm_14_3u, tm_15_3u, tm_16_3u, tm_17_3u, tm_18_3u, tm_19_3u, tm_20_3u, tm_21_3u, tm_22_3u, tm_23_3u, tm_tot_3u, tm_00_24u, tm_01_24u, tm_02_24u, tm_03_24u, tm_04_24u, tm_05_24u, tm_06_24u, tm_07_24u, tm_08_24u, tm_09_24u, tm_10_24u, tm_11_24u, tm_12_24u, tm_13_24u, tm_14_24u, tm_15_24u, tm_16_24u, tm_17_24u, tm_18_24u, tm_19_24u, tm_20_24u, tm_21_24u, tm_22_24u, tm_23_24u, tm_tot_24u from powerapp_hourlyrep_hits_summary where plan = 'LINE' and left(tran_dt,7) = '".$current_date."' order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet("LINE");


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

$format2 = $workbook->add_format(bg_color => 'gray'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(1);

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
$formatC->set_size('12');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('12');
$formatS->set_color('black');
$formatS->set_align('center');
$formatS->set_border(1);

$formatB = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatB->set_bold();
$formatB->set_font('Calibri');
$formatB->set_size('10');
$formatB->set_color('black');
$formatB->set_align('center');
$formatB->set_border(1);

$formatE = $workbook->add_format(bg_color => 'magenta'); # Add a format
$formatE->set_bold();
$formatE->set_font('Calibri');
$formatE->set_size('10');
$formatE->set_color('black');
$formatE->set_align('center');
$formatE->set_border(1);

$formatP = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP->set_bold();
$formatP->set_font('Calibri');
$formatP->set_size('10');
$formatP->set_color('black');
$formatP->set_align('center');
$formatP->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);



$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 24, 4);
$worksheet->set_column(25, 25, 6);
$worksheet->set_column(26, 26, 1);
$worksheet->set_column(27, 50, 4);
$worksheet->set_column(51, 51, 6);

$worksheet->set_column(52, 52, 3);

$worksheet->set_column(53, 76, 4);
$worksheet->set_column(77, 77, 6);
$worksheet->set_column(78, 78, 1);
$worksheet->set_column(79, 102, 4);
$worksheet->set_column(103,103, 6);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:AZ2',  'L  I  N  E', $formatC);

$worksheet->merge_range('B3:Z3', 'HITS', $formatP);
$worksheet->merge_range('AB3:AZ3', 'UNIQUE USERS', $formatU);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',  $format);
$worksheet->write($row+$i, $col+1,  '\'00',  $format);
$worksheet->write($row+$i, $col+2,  '\'01',  $format);
$worksheet->write($row+$i, $col+3,  '\'02',  $format);
$worksheet->write($row+$i, $col+4,  '\'03',  $format);
$worksheet->write($row+$i, $col+5,  '\'04',  $format);
$worksheet->write($row+$i, $col+6,  '\'05',  $format);
$worksheet->write($row+$i, $col+7,  '\'06',  $format);
$worksheet->write($row+$i, $col+8,  '\'07',  $format);
$worksheet->write($row+$i, $col+9,  '\'08',  $format);
$worksheet->write($row+$i, $col+10, '\'09',  $format);
$worksheet->write($row+$i, $col+11, '\'10',  $format);
$worksheet->write($row+$i, $col+12, '\'11',  $format);
$worksheet->write($row+$i, $col+13, '\'12',  $format);
$worksheet->write($row+$i, $col+14, '\'13',  $format);
$worksheet->write($row+$i, $col+15, '\'14',  $format);
$worksheet->write($row+$i, $col+16, '\'15',  $format);
$worksheet->write($row+$i, $col+17, '\'16',  $format);
$worksheet->write($row+$i, $col+18, '\'17',  $format);
$worksheet->write($row+$i, $col+19, '\'18',  $format);
$worksheet->write($row+$i, $col+20, '\'19',  $format);
$worksheet->write($row+$i, $col+21, '\'20',  $format);
$worksheet->write($row+$i, $col+22, '\'21',  $format);
$worksheet->write($row+$i, $col+23, '\'22',  $format);
$worksheet->write($row+$i, $col+24, '\'23',  $format);
$worksheet->write($row+$i, $col+25, 'TOTAL', $format);

$worksheet->write($row+$i, $col+27, '\'00',  $format);
$worksheet->write($row+$i, $col+28, '\'01',  $format);
$worksheet->write($row+$i, $col+29, '\'02',  $format);
$worksheet->write($row+$i, $col+30, '\'03',  $format);
$worksheet->write($row+$i, $col+31, '\'04',  $format);
$worksheet->write($row+$i, $col+32, '\'05',  $format);
$worksheet->write($row+$i, $col+33, '\'06',  $format);
$worksheet->write($row+$i, $col+34, '\'07',  $format);
$worksheet->write($row+$i, $col+35, '\'08',  $format);
$worksheet->write($row+$i, $col+36, '\'09',  $format);
$worksheet->write($row+$i, $col+37, '\'10',  $format);
$worksheet->write($row+$i, $col+38, '\'11',  $format);
$worksheet->write($row+$i, $col+39, '\'12',  $format);
$worksheet->write($row+$i, $col+40, '\'13',  $format);
$worksheet->write($row+$i, $col+41, '\'14',  $format);
$worksheet->write($row+$i, $col+42, '\'15',  $format);
$worksheet->write($row+$i, $col+43, '\'16',  $format);
$worksheet->write($row+$i, $col+44, '\'17',  $format);
$worksheet->write($row+$i, $col+45, '\'18',  $format);
$worksheet->write($row+$i, $col+46, '\'19',  $format);
$worksheet->write($row+$i, $col+47, '\'20',  $format);
$worksheet->write($row+$i, $col+48, '\'21',  $format);
$worksheet->write($row+$i, $col+49, '\'22',  $format);
$worksheet->write($row+$i, $col+50, '\'23',  $format);
$worksheet->write($row+$i, $col+51, 'TOTAL', $format);



while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1);
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $formatT);

   $worksheet->write($row+$i, $col+27, $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+40, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+41, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[66], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[69], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[72], $format1);
   $worksheet->write($row+$i, $col+49, $rowRst[73], $format1);
   $worksheet->write($row+$i, $col+50, $rowRst[74], $format1);
   $worksheet->write($row+$i, $col+51, $rowRst[75], $formatT);

}



###################################################
###################################################
###################################################

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  tm_00_3h, tm_01_3h, tm_02_3h, tm_03_3h, tm_04_3h, tm_05_3h, tm_06_3h, tm_07_3h, tm_08_3h, tm_09_3h, tm_10_3h, tm_11_3h, tm_12_3h, tm_13_3h, tm_14_3h, tm_15_3h, tm_16_3h, tm_17_3h, tm_18_3h, tm_19_3h, tm_20_3h, tm_21_3h, tm_22_3h, tm_23_3h, tm_tot_3h, tm_00_24h, tm_01_24h, tm_02_24h, tm_03_24h, tm_04_24h, tm_05_24h, tm_06_24h, tm_07_24h, tm_08_24h, tm_09_24h, tm_10_24h, tm_11_24h, tm_12_24h, tm_13_24h, tm_14_24h, tm_15_24h, tm_16_24h, tm_17_24h, tm_18_24h, tm_19_24h, tm_20_24h, tm_21_24h, tm_22_24h, tm_23_24h, tm_tot_24h, tm_00_3u, tm_01_3u, tm_02_3u, tm_03_3u, tm_04_3u, tm_05_3u, tm_06_3u, tm_07_3u, tm_08_3u, tm_09_3u, tm_10_3u, tm_11_3u, tm_12_3u, tm_13_3u, tm_14_3u, tm_15_3u, tm_16_3u, tm_17_3u, tm_18_3u, tm_19_3u, tm_20_3u, tm_21_3u, tm_22_3u, tm_23_3u, tm_tot_3u, tm_00_24u, tm_01_24u, tm_02_24u, tm_03_24u, tm_04_24u, tm_05_24u, tm_06_24u, tm_07_24u, tm_08_24u, tm_09_24u, tm_10_24u, tm_11_24u, tm_12_24u, tm_13_24u, tm_14_24u, tm_15_24u, tm_16_24u, tm_17_24u, tm_18_24u, tm_19_24u, tm_20_24u, tm_21_24u, tm_22_24u, tm_23_24u, tm_tot_24u from powerapp_hourlyrep_hits_summary where plan = 'SNAPCHAT' and left(tran_dt,7) = '".$current_date."' order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet("SNAPCHAT");


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

$format2 = $workbook->add_format(bg_color => 'gray'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(1);

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
$formatC->set_size('12');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('12');
$formatS->set_color('black');
$formatS->set_align('center');
$formatS->set_border(1);

$formatB = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatB->set_bold();
$formatB->set_font('Calibri');
$formatB->set_size('10');
$formatB->set_color('black');
$formatB->set_align('center');
$formatB->set_border(1);

$formatE = $workbook->add_format(bg_color => 'magenta'); # Add a format
$formatE->set_bold();
$formatE->set_font('Calibri');
$formatE->set_size('10');
$formatE->set_color('black');
$formatE->set_align('center');
$formatE->set_border(1);

$formatP = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP->set_bold();
$formatP->set_font('Calibri');
$formatP->set_size('10');
$formatP->set_color('black');
$formatP->set_align('center');
$formatP->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);



$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 24, 4);
$worksheet->set_column(25, 25, 6);
$worksheet->set_column(26, 26, 1);
$worksheet->set_column(27, 50, 4);
$worksheet->set_column(51, 51, 6);

$worksheet->set_column(52, 52, 3);

$worksheet->set_column(53, 76, 4);
$worksheet->set_column(77, 77, 6);
$worksheet->set_column(78, 78, 1);
$worksheet->set_column(79, 102, 4);
$worksheet->set_column(103,103, 6);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:AZ2',  'S N A P C H A T', $formatC);

$worksheet->merge_range('B3:Z3', 'HITS', $formatP);
$worksheet->merge_range('AB3:AZ3', 'UNIQUE USERS', $formatU);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',  $format);
$worksheet->write($row+$i, $col+1,  '\'00',  $format);
$worksheet->write($row+$i, $col+2,  '\'01',  $format);
$worksheet->write($row+$i, $col+3,  '\'02',  $format);
$worksheet->write($row+$i, $col+4,  '\'03',  $format);
$worksheet->write($row+$i, $col+5,  '\'04',  $format);
$worksheet->write($row+$i, $col+6,  '\'05',  $format);
$worksheet->write($row+$i, $col+7,  '\'06',  $format);
$worksheet->write($row+$i, $col+8,  '\'07',  $format);
$worksheet->write($row+$i, $col+9,  '\'08',  $format);
$worksheet->write($row+$i, $col+10, '\'09',  $format);
$worksheet->write($row+$i, $col+11, '\'10',  $format);
$worksheet->write($row+$i, $col+12, '\'11',  $format);
$worksheet->write($row+$i, $col+13, '\'12',  $format);
$worksheet->write($row+$i, $col+14, '\'13',  $format);
$worksheet->write($row+$i, $col+15, '\'14',  $format);
$worksheet->write($row+$i, $col+16, '\'15',  $format);
$worksheet->write($row+$i, $col+17, '\'16',  $format);
$worksheet->write($row+$i, $col+18, '\'17',  $format);
$worksheet->write($row+$i, $col+19, '\'18',  $format);
$worksheet->write($row+$i, $col+20, '\'19',  $format);
$worksheet->write($row+$i, $col+21, '\'20',  $format);
$worksheet->write($row+$i, $col+22, '\'21',  $format);
$worksheet->write($row+$i, $col+23, '\'22',  $format);
$worksheet->write($row+$i, $col+24, '\'23',  $format);
$worksheet->write($row+$i, $col+25, 'TOTAL', $format);

$worksheet->write($row+$i, $col+27, '\'00',  $format);
$worksheet->write($row+$i, $col+28, '\'01',  $format);
$worksheet->write($row+$i, $col+29, '\'02',  $format);
$worksheet->write($row+$i, $col+30, '\'03',  $format);
$worksheet->write($row+$i, $col+31, '\'04',  $format);
$worksheet->write($row+$i, $col+32, '\'05',  $format);
$worksheet->write($row+$i, $col+33, '\'06',  $format);
$worksheet->write($row+$i, $col+34, '\'07',  $format);
$worksheet->write($row+$i, $col+35, '\'08',  $format);
$worksheet->write($row+$i, $col+36, '\'09',  $format);
$worksheet->write($row+$i, $col+37, '\'10',  $format);
$worksheet->write($row+$i, $col+38, '\'11',  $format);
$worksheet->write($row+$i, $col+39, '\'12',  $format);
$worksheet->write($row+$i, $col+40, '\'13',  $format);
$worksheet->write($row+$i, $col+41, '\'14',  $format);
$worksheet->write($row+$i, $col+42, '\'15',  $format);
$worksheet->write($row+$i, $col+43, '\'16',  $format);
$worksheet->write($row+$i, $col+44, '\'17',  $format);
$worksheet->write($row+$i, $col+45, '\'18',  $format);
$worksheet->write($row+$i, $col+46, '\'19',  $format);
$worksheet->write($row+$i, $col+47, '\'20',  $format);
$worksheet->write($row+$i, $col+48, '\'21',  $format);
$worksheet->write($row+$i, $col+49, '\'22',  $format);
$worksheet->write($row+$i, $col+50, '\'23',  $format);
$worksheet->write($row+$i, $col+51, 'TOTAL', $format);



while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1);
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $formatT);

   $worksheet->write($row+$i, $col+27, $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+40, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+41, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[66], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[69], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[72], $format1);
   $worksheet->write($row+$i, $col+49, $rowRst[73], $format1);
   $worksheet->write($row+$i, $col+50, $rowRst[74], $format1);
   $worksheet->write($row+$i, $col+51, $rowRst[75], $formatT);

}


###################################################
###################################################
###################################################

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  tm_00_3h, tm_01_3h, tm_02_3h, tm_03_3h, tm_04_3h, tm_05_3h, tm_06_3h, tm_07_3h, tm_08_3h, tm_09_3h, tm_10_3h, tm_11_3h, tm_12_3h, tm_13_3h, tm_14_3h, tm_15_3h, tm_16_3h, tm_17_3h, tm_18_3h, tm_19_3h, tm_20_3h, tm_21_3h, tm_22_3h, tm_23_3h, tm_tot_3h, tm_00_24h, tm_01_24h, tm_02_24h, tm_03_24h, tm_04_24h, tm_05_24h, tm_06_24h, tm_07_24h, tm_08_24h, tm_09_24h, tm_10_24h, tm_11_24h, tm_12_24h, tm_13_24h, tm_14_24h, tm_15_24h, tm_16_24h, tm_17_24h, tm_18_24h, tm_19_24h, tm_20_24h, tm_21_24h, tm_22_24h, tm_23_24h, tm_tot_24h, tm_00_3u, tm_01_3u, tm_02_3u, tm_03_3u, tm_04_3u, tm_05_3u, tm_06_3u, tm_07_3u, tm_08_3u, tm_09_3u, tm_10_3u, tm_11_3u, tm_12_3u, tm_13_3u, tm_14_3u, tm_15_3u, tm_16_3u, tm_17_3u, tm_18_3u, tm_19_3u, tm_20_3u, tm_21_3u, tm_22_3u, tm_23_3u, tm_tot_3u, tm_00_24u, tm_01_24u, tm_02_24u, tm_03_24u, tm_04_24u, tm_05_24u, tm_06_24u, tm_07_24u, tm_08_24u, tm_09_24u, tm_10_24u, tm_11_24u, tm_12_24u, tm_13_24u, tm_14_24u, tm_15_24u, tm_16_24u, tm_17_24u, tm_18_24u, tm_19_24u, tm_20_24u, tm_21_24u, tm_22_24u, tm_23_24u, tm_tot_24u from powerapp_hourlyrep_hits_summary where plan = 'TUMBLR' and left(tran_dt,7) = '".$current_date."' order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet("TUMBLR");


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

$format2 = $workbook->add_format(bg_color => 'gray'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(1);

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
$formatC->set_size('12');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('12');
$formatS->set_color('black');
$formatS->set_align('center');
$formatS->set_border(1);

$formatB = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatB->set_bold();
$formatB->set_font('Calibri');
$formatB->set_size('10');
$formatB->set_color('black');
$formatB->set_align('center');
$formatB->set_border(1);

$formatE = $workbook->add_format(bg_color => 'magenta'); # Add a format
$formatE->set_bold();
$formatE->set_font('Calibri');
$formatE->set_size('10');
$formatE->set_color('black');
$formatE->set_align('center');
$formatE->set_border(1);

$formatP = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP->set_bold();
$formatP->set_font('Calibri');
$formatP->set_size('10');
$formatP->set_color('black');
$formatP->set_align('center');
$formatP->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);



$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 24, 4);
$worksheet->set_column(25, 25, 6);
$worksheet->set_column(26, 26, 1);
$worksheet->set_column(27, 50, 4);
$worksheet->set_column(51, 51, 6);

$worksheet->set_column(52, 52, 3);

$worksheet->set_column(53, 76, 4);
$worksheet->set_column(77, 77, 6);
$worksheet->set_column(78, 78, 1);
$worksheet->set_column(79, 102, 4);
$worksheet->set_column(103,103, 6);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:AZ2',  'T U M B L R', $formatC);

$worksheet->merge_range('B3:Z3', 'HITS', $formatP);
$worksheet->merge_range('AB3:AZ3', 'UNIQUE USERS', $formatU);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',  $format);
$worksheet->write($row+$i, $col+1,  '\'00',  $format);
$worksheet->write($row+$i, $col+2,  '\'01',  $format);
$worksheet->write($row+$i, $col+3,  '\'02',  $format);
$worksheet->write($row+$i, $col+4,  '\'03',  $format);
$worksheet->write($row+$i, $col+5,  '\'04',  $format);
$worksheet->write($row+$i, $col+6,  '\'05',  $format);
$worksheet->write($row+$i, $col+7,  '\'06',  $format);
$worksheet->write($row+$i, $col+8,  '\'07',  $format);
$worksheet->write($row+$i, $col+9,  '\'08',  $format);
$worksheet->write($row+$i, $col+10, '\'09',  $format);
$worksheet->write($row+$i, $col+11, '\'10',  $format);
$worksheet->write($row+$i, $col+12, '\'11',  $format);
$worksheet->write($row+$i, $col+13, '\'12',  $format);
$worksheet->write($row+$i, $col+14, '\'13',  $format);
$worksheet->write($row+$i, $col+15, '\'14',  $format);
$worksheet->write($row+$i, $col+16, '\'15',  $format);
$worksheet->write($row+$i, $col+17, '\'16',  $format);
$worksheet->write($row+$i, $col+18, '\'17',  $format);
$worksheet->write($row+$i, $col+19, '\'18',  $format);
$worksheet->write($row+$i, $col+20, '\'19',  $format);
$worksheet->write($row+$i, $col+21, '\'20',  $format);
$worksheet->write($row+$i, $col+22, '\'21',  $format);
$worksheet->write($row+$i, $col+23, '\'22',  $format);
$worksheet->write($row+$i, $col+24, '\'23',  $format);
$worksheet->write($row+$i, $col+25, 'TOTAL', $format);

$worksheet->write($row+$i, $col+27, '\'00',  $format);
$worksheet->write($row+$i, $col+28, '\'01',  $format);
$worksheet->write($row+$i, $col+29, '\'02',  $format);
$worksheet->write($row+$i, $col+30, '\'03',  $format);
$worksheet->write($row+$i, $col+31, '\'04',  $format);
$worksheet->write($row+$i, $col+32, '\'05',  $format);
$worksheet->write($row+$i, $col+33, '\'06',  $format);
$worksheet->write($row+$i, $col+34, '\'07',  $format);
$worksheet->write($row+$i, $col+35, '\'08',  $format);
$worksheet->write($row+$i, $col+36, '\'09',  $format);
$worksheet->write($row+$i, $col+37, '\'10',  $format);
$worksheet->write($row+$i, $col+38, '\'11',  $format);
$worksheet->write($row+$i, $col+39, '\'12',  $format);
$worksheet->write($row+$i, $col+40, '\'13',  $format);
$worksheet->write($row+$i, $col+41, '\'14',  $format);
$worksheet->write($row+$i, $col+42, '\'15',  $format);
$worksheet->write($row+$i, $col+43, '\'16',  $format);
$worksheet->write($row+$i, $col+44, '\'17',  $format);
$worksheet->write($row+$i, $col+45, '\'18',  $format);
$worksheet->write($row+$i, $col+46, '\'19',  $format);
$worksheet->write($row+$i, $col+47, '\'20',  $format);
$worksheet->write($row+$i, $col+48, '\'21',  $format);
$worksheet->write($row+$i, $col+49, '\'22',  $format);
$worksheet->write($row+$i, $col+50, '\'23',  $format);
$worksheet->write($row+$i, $col+51, 'TOTAL', $format);



while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1);
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $formatT);

   $worksheet->write($row+$i, $col+27, $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+40, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+41, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[66], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[69], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[72], $format1);
   $worksheet->write($row+$i, $col+49, $rowRst[73], $format1);
   $worksheet->write($row+$i, $col+50, $rowRst[74], $format1);
   $worksheet->write($row+$i, $col+51, $rowRst[75], $formatT);

}



###################################################
###################################################
###################################################

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  tm_00_3h, tm_01_3h, tm_02_3h, tm_03_3h, tm_04_3h, tm_05_3h, tm_06_3h, tm_07_3h, tm_08_3h, tm_09_3h, tm_10_3h, tm_11_3h, tm_12_3h, tm_13_3h, tm_14_3h, tm_15_3h, tm_16_3h, tm_17_3h, tm_18_3h, tm_19_3h, tm_20_3h, tm_21_3h, tm_22_3h, tm_23_3h, tm_tot_3h, tm_00_24h, tm_01_24h, tm_02_24h, tm_03_24h, tm_04_24h, tm_05_24h, tm_06_24h, tm_07_24h, tm_08_24h, tm_09_24h, tm_10_24h, tm_11_24h, tm_12_24h, tm_13_24h, tm_14_24h, tm_15_24h, tm_16_24h, tm_17_24h, tm_18_24h, tm_19_24h, tm_20_24h, tm_21_24h, tm_22_24h, tm_23_24h, tm_tot_24h, tm_00_3u, tm_01_3u, tm_02_3u, tm_03_3u, tm_04_3u, tm_05_3u, tm_06_3u, tm_07_3u, tm_08_3u, tm_09_3u, tm_10_3u, tm_11_3u, tm_12_3u, tm_13_3u, tm_14_3u, tm_15_3u, tm_16_3u, tm_17_3u, tm_18_3u, tm_19_3u, tm_20_3u, tm_21_3u, tm_22_3u, tm_23_3u, tm_tot_3u, tm_00_24u, tm_01_24u, tm_02_24u, tm_03_24u, tm_04_24u, tm_05_24u, tm_06_24u, tm_07_24u, tm_08_24u, tm_09_24u, tm_10_24u, tm_11_24u, tm_12_24u, tm_13_24u, tm_14_24u, tm_15_24u, tm_16_24u, tm_17_24u, tm_18_24u, tm_19_24u, tm_20_24u, tm_21_24u, tm_22_24u, tm_23_24u, tm_tot_24u from powerapp_hourlyrep_hits_summary where plan = 'WAZE' and left(tran_dt,7) = '".$current_date."' order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet("WAZE");


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

$format2 = $workbook->add_format(bg_color => 'gray'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(1);

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
$formatC->set_size('12');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('12');
$formatS->set_color('black');
$formatS->set_align('center');
$formatS->set_border(1);

$formatB = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatB->set_bold();
$formatB->set_font('Calibri');
$formatB->set_size('10');
$formatB->set_color('black');
$formatB->set_align('center');
$formatB->set_border(1);

$formatE = $workbook->add_format(bg_color => 'magenta'); # Add a format
$formatE->set_bold();
$formatE->set_font('Calibri');
$formatE->set_size('10');
$formatE->set_color('black');
$formatE->set_align('center');
$formatE->set_border(1);

$formatP = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP->set_bold();
$formatP->set_font('Calibri');
$formatP->set_size('10');
$formatP->set_color('black');
$formatP->set_align('center');
$formatP->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);



$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 24, 4);
$worksheet->set_column(25, 25, 6);
$worksheet->set_column(26, 26, 1);
$worksheet->set_column(27, 50, 4);
$worksheet->set_column(51, 51, 6);

$worksheet->set_column(52, 52, 3);

$worksheet->set_column(53, 76, 4);
$worksheet->set_column(77, 77, 6);
$worksheet->set_column(78, 78, 1);
$worksheet->set_column(79, 102, 4);
$worksheet->set_column(103,103, 6);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:AZ2',  'W  A  Z  E', $formatC);

$worksheet->merge_range('B3:Z3', 'HITS', $formatP);
$worksheet->merge_range('AB3:AZ3', 'UNIQUE USERS', $formatU);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',  $format);
$worksheet->write($row+$i, $col+1,  '\'00',  $format);
$worksheet->write($row+$i, $col+2,  '\'01',  $format);
$worksheet->write($row+$i, $col+3,  '\'02',  $format);
$worksheet->write($row+$i, $col+4,  '\'03',  $format);
$worksheet->write($row+$i, $col+5,  '\'04',  $format);
$worksheet->write($row+$i, $col+6,  '\'05',  $format);
$worksheet->write($row+$i, $col+7,  '\'06',  $format);
$worksheet->write($row+$i, $col+8,  '\'07',  $format);
$worksheet->write($row+$i, $col+9,  '\'08',  $format);
$worksheet->write($row+$i, $col+10, '\'09',  $format);
$worksheet->write($row+$i, $col+11, '\'10',  $format);
$worksheet->write($row+$i, $col+12, '\'11',  $format);
$worksheet->write($row+$i, $col+13, '\'12',  $format);
$worksheet->write($row+$i, $col+14, '\'13',  $format);
$worksheet->write($row+$i, $col+15, '\'14',  $format);
$worksheet->write($row+$i, $col+16, '\'15',  $format);
$worksheet->write($row+$i, $col+17, '\'16',  $format);
$worksheet->write($row+$i, $col+18, '\'17',  $format);
$worksheet->write($row+$i, $col+19, '\'18',  $format);
$worksheet->write($row+$i, $col+20, '\'19',  $format);
$worksheet->write($row+$i, $col+21, '\'20',  $format);
$worksheet->write($row+$i, $col+22, '\'21',  $format);
$worksheet->write($row+$i, $col+23, '\'22',  $format);
$worksheet->write($row+$i, $col+24, '\'23',  $format);
$worksheet->write($row+$i, $col+25, 'TOTAL', $format);

$worksheet->write($row+$i, $col+27, '\'00',  $format);
$worksheet->write($row+$i, $col+28, '\'01',  $format);
$worksheet->write($row+$i, $col+29, '\'02',  $format);
$worksheet->write($row+$i, $col+30, '\'03',  $format);
$worksheet->write($row+$i, $col+31, '\'04',  $format);
$worksheet->write($row+$i, $col+32, '\'05',  $format);
$worksheet->write($row+$i, $col+33, '\'06',  $format);
$worksheet->write($row+$i, $col+34, '\'07',  $format);
$worksheet->write($row+$i, $col+35, '\'08',  $format);
$worksheet->write($row+$i, $col+36, '\'09',  $format);
$worksheet->write($row+$i, $col+37, '\'10',  $format);
$worksheet->write($row+$i, $col+38, '\'11',  $format);
$worksheet->write($row+$i, $col+39, '\'12',  $format);
$worksheet->write($row+$i, $col+40, '\'13',  $format);
$worksheet->write($row+$i, $col+41, '\'14',  $format);
$worksheet->write($row+$i, $col+42, '\'15',  $format);
$worksheet->write($row+$i, $col+43, '\'16',  $format);
$worksheet->write($row+$i, $col+44, '\'17',  $format);
$worksheet->write($row+$i, $col+45, '\'18',  $format);
$worksheet->write($row+$i, $col+46, '\'19',  $format);
$worksheet->write($row+$i, $col+47, '\'20',  $format);
$worksheet->write($row+$i, $col+48, '\'21',  $format);
$worksheet->write($row+$i, $col+49, '\'22',  $format);
$worksheet->write($row+$i, $col+50, '\'23',  $format);
$worksheet->write($row+$i, $col+51, 'TOTAL', $format);



while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1);
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $formatT);

   $worksheet->write($row+$i, $col+27, $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+40, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+41, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[66], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[69], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[72], $format1);
   $worksheet->write($row+$i, $col+49, $rowRst[73], $format1);
   $worksheet->write($row+$i, $col+50, $rowRst[74], $format1);
   $worksheet->write($row+$i, $col+51, $rowRst[75], $formatT);

}



###################################################
###################################################
###################################################

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  tm_00_3h, tm_01_3h, tm_02_3h, tm_03_3h, tm_04_3h, tm_05_3h, tm_06_3h, tm_07_3h, tm_08_3h, tm_09_3h, tm_10_3h, tm_11_3h, tm_12_3h, tm_13_3h, tm_14_3h, tm_15_3h, tm_16_3h, tm_17_3h, tm_18_3h, tm_19_3h, tm_20_3h, tm_21_3h, tm_22_3h, tm_23_3h, tm_tot_3h, tm_00_24h, tm_01_24h, tm_02_24h, tm_03_24h, tm_04_24h, tm_05_24h, tm_06_24h, tm_07_24h, tm_08_24h, tm_09_24h, tm_10_24h, tm_11_24h, tm_12_24h, tm_13_24h, tm_14_24h, tm_15_24h, tm_16_24h, tm_17_24h, tm_18_24h, tm_19_24h, tm_20_24h, tm_21_24h, tm_22_24h, tm_23_24h, tm_tot_24h, tm_00_3u, tm_01_3u, tm_02_3u, tm_03_3u, tm_04_3u, tm_05_3u, tm_06_3u, tm_07_3u, tm_08_3u, tm_09_3u, tm_10_3u, tm_11_3u, tm_12_3u, tm_13_3u, tm_14_3u, tm_15_3u, tm_16_3u, tm_17_3u, tm_18_3u, tm_19_3u, tm_20_3u, tm_21_3u, tm_22_3u, tm_23_3u, tm_tot_3u, tm_00_24u, tm_01_24u, tm_02_24u, tm_03_24u, tm_04_24u, tm_05_24u, tm_06_24u, tm_07_24u, tm_08_24u, tm_09_24u, tm_10_24u, tm_11_24u, tm_12_24u, tm_13_24u, tm_14_24u, tm_15_24u, tm_16_24u, tm_17_24u, tm_18_24u, tm_19_24u, tm_20_24u, tm_21_24u, tm_22_24u, tm_23_24u, tm_tot_24u from powerapp_hourlyrep_hits_summary where plan = 'WECHAT' and left(tran_dt,7) = '".$current_date."' order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet("WECHAT");


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

$format2 = $workbook->add_format(bg_color => 'gray'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(1);

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
$formatC->set_size('12');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('12');
$formatS->set_color('black');
$formatS->set_align('center');
$formatS->set_border(1);

$formatB = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatB->set_bold();
$formatB->set_font('Calibri');
$formatB->set_size('10');
$formatB->set_color('black');
$formatB->set_align('center');
$formatB->set_border(1);

$formatE = $workbook->add_format(bg_color => 'magenta'); # Add a format
$formatE->set_bold();
$formatE->set_font('Calibri');
$formatE->set_size('10');
$formatE->set_color('black');
$formatE->set_align('center');
$formatE->set_border(1);

$formatP = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP->set_bold();
$formatP->set_font('Calibri');
$formatP->set_size('10');
$formatP->set_color('black');
$formatP->set_align('center');
$formatP->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);



$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 24, 4);
$worksheet->set_column(25, 25, 6);
$worksheet->set_column(26, 26, 1);
$worksheet->set_column(27, 50, 4);
$worksheet->set_column(51, 51, 6);

$worksheet->set_column(52, 52, 3);

$worksheet->set_column(53, 76, 4);
$worksheet->set_column(77, 77, 6);
$worksheet->set_column(78, 78, 1);
$worksheet->set_column(79, 102, 4);
$worksheet->set_column(103,103, 6);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:AZ2',  'W E  C H A T', $formatC);

$worksheet->merge_range('B3:Z3', 'HITS', $formatP);
$worksheet->merge_range('AB3:AZ3', 'UNIQUE USERS', $formatU);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',  $format);
$worksheet->write($row+$i, $col+1,  '\'00',  $format);
$worksheet->write($row+$i, $col+2,  '\'01',  $format);
$worksheet->write($row+$i, $col+3,  '\'02',  $format);
$worksheet->write($row+$i, $col+4,  '\'03',  $format);
$worksheet->write($row+$i, $col+5,  '\'04',  $format);
$worksheet->write($row+$i, $col+6,  '\'05',  $format);
$worksheet->write($row+$i, $col+7,  '\'06',  $format);
$worksheet->write($row+$i, $col+8,  '\'07',  $format);
$worksheet->write($row+$i, $col+9,  '\'08',  $format);
$worksheet->write($row+$i, $col+10, '\'09',  $format);
$worksheet->write($row+$i, $col+11, '\'10',  $format);
$worksheet->write($row+$i, $col+12, '\'11',  $format);
$worksheet->write($row+$i, $col+13, '\'12',  $format);
$worksheet->write($row+$i, $col+14, '\'13',  $format);
$worksheet->write($row+$i, $col+15, '\'14',  $format);
$worksheet->write($row+$i, $col+16, '\'15',  $format);
$worksheet->write($row+$i, $col+17, '\'16',  $format);
$worksheet->write($row+$i, $col+18, '\'17',  $format);
$worksheet->write($row+$i, $col+19, '\'18',  $format);
$worksheet->write($row+$i, $col+20, '\'19',  $format);
$worksheet->write($row+$i, $col+21, '\'20',  $format);
$worksheet->write($row+$i, $col+22, '\'21',  $format);
$worksheet->write($row+$i, $col+23, '\'22',  $format);
$worksheet->write($row+$i, $col+24, '\'23',  $format);
$worksheet->write($row+$i, $col+25, 'TOTAL', $format);

$worksheet->write($row+$i, $col+27, '\'00',  $format);
$worksheet->write($row+$i, $col+28, '\'01',  $format);
$worksheet->write($row+$i, $col+29, '\'02',  $format);
$worksheet->write($row+$i, $col+30, '\'03',  $format);
$worksheet->write($row+$i, $col+31, '\'04',  $format);
$worksheet->write($row+$i, $col+32, '\'05',  $format);
$worksheet->write($row+$i, $col+33, '\'06',  $format);
$worksheet->write($row+$i, $col+34, '\'07',  $format);
$worksheet->write($row+$i, $col+35, '\'08',  $format);
$worksheet->write($row+$i, $col+36, '\'09',  $format);
$worksheet->write($row+$i, $col+37, '\'10',  $format);
$worksheet->write($row+$i, $col+38, '\'11',  $format);
$worksheet->write($row+$i, $col+39, '\'12',  $format);
$worksheet->write($row+$i, $col+40, '\'13',  $format);
$worksheet->write($row+$i, $col+41, '\'14',  $format);
$worksheet->write($row+$i, $col+42, '\'15',  $format);
$worksheet->write($row+$i, $col+43, '\'16',  $format);
$worksheet->write($row+$i, $col+44, '\'17',  $format);
$worksheet->write($row+$i, $col+45, '\'18',  $format);
$worksheet->write($row+$i, $col+46, '\'19',  $format);
$worksheet->write($row+$i, $col+47, '\'20',  $format);
$worksheet->write($row+$i, $col+48, '\'21',  $format);
$worksheet->write($row+$i, $col+49, '\'22',  $format);
$worksheet->write($row+$i, $col+50, '\'23',  $format);
$worksheet->write($row+$i, $col+51, 'TOTAL', $format);



while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1);
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $formatT);

   $worksheet->write($row+$i, $col+27, $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+40, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+41, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[66], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[69], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[72], $format1);
   $worksheet->write($row+$i, $col+49, $rowRst[73], $format1);
   $worksheet->write($row+$i, $col+50, $rowRst[74], $format1);
   $worksheet->write($row+$i, $col+51, $rowRst[75], $formatT);

}



###################################################
###################################################
###################################################

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  tm_00_3h, tm_01_3h, tm_02_3h, tm_03_3h, tm_04_3h, tm_05_3h, tm_06_3h, tm_07_3h, tm_08_3h, tm_09_3h, tm_10_3h, tm_11_3h, tm_12_3h, tm_13_3h, tm_14_3h, tm_15_3h, tm_16_3h, tm_17_3h, tm_18_3h, tm_19_3h, tm_20_3h, tm_21_3h, tm_22_3h, tm_23_3h, tm_tot_3h, tm_00_24h, tm_01_24h, tm_02_24h, tm_03_24h, tm_04_24h, tm_05_24h, tm_06_24h, tm_07_24h, tm_08_24h, tm_09_24h, tm_10_24h, tm_11_24h, tm_12_24h, tm_13_24h, tm_14_24h, tm_15_24h, tm_16_24h, tm_17_24h, tm_18_24h, tm_19_24h, tm_20_24h, tm_21_24h, tm_22_24h, tm_23_24h, tm_tot_24h, tm_00_3u, tm_01_3u, tm_02_3u, tm_03_3u, tm_04_3u, tm_05_3u, tm_06_3u, tm_07_3u, tm_08_3u, tm_09_3u, tm_10_3u, tm_11_3u, tm_12_3u, tm_13_3u, tm_14_3u, tm_15_3u, tm_16_3u, tm_17_3u, tm_18_3u, tm_19_3u, tm_20_3u, tm_21_3u, tm_22_3u, tm_23_3u, tm_tot_3u, tm_00_24u, tm_01_24u, tm_02_24u, tm_03_24u, tm_04_24u, tm_05_24u, tm_06_24u, tm_07_24u, tm_08_24u, tm_09_24u, tm_10_24u, tm_11_24u, tm_12_24u, tm_13_24u, tm_14_24u, tm_15_24u, tm_16_24u, tm_17_24u, tm_18_24u, tm_19_24u, tm_20_24u, tm_21_24u, tm_22_24u, tm_23_24u, tm_tot_24u from powerapp_hourlyrep_hits_summary where plan = 'FACEBOOK' and left(tran_dt,7) = '".$current_date."' order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet("FACEBOOK");


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

$format2 = $workbook->add_format(bg_color => 'gray'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(1);

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
$formatC->set_size('12');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('12');
$formatS->set_color('black');
$formatS->set_align('center');
$formatS->set_border(1);

$formatB = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatB->set_bold();
$formatB->set_font('Calibri');
$formatB->set_size('10');
$formatB->set_color('black');
$formatB->set_align('center');
$formatB->set_border(1);

$formatE = $workbook->add_format(bg_color => 'magenta'); # Add a format
$formatE->set_bold();
$formatE->set_font('Calibri');
$formatE->set_size('10');
$formatE->set_color('black');
$formatE->set_align('center');
$formatE->set_border(1);

$formatP = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP->set_bold();
$formatP->set_font('Calibri');
$formatP->set_size('10');
$formatP->set_color('black');
$formatP->set_align('center');
$formatP->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);



$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 24, 4);
$worksheet->set_column(25, 25, 6);
$worksheet->set_column(26, 26, 1);
$worksheet->set_column(27, 50, 4);
$worksheet->set_column(51, 51, 6);

$worksheet->set_column(52, 52, 3);

$worksheet->set_column(53, 76, 4);
$worksheet->set_column(77, 77, 6);
$worksheet->set_column(78, 78, 1);
$worksheet->set_column(79, 102, 4);
$worksheet->set_column(103,103, 6);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:AZ2',  'F  A  C  E  B  O  O  K', $formatC);

$worksheet->merge_range('B3:Z3', 'HITS', $formatP);
$worksheet->merge_range('AB3:AZ3', 'UNIQUE USERS', $formatU);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',  $format);
$worksheet->write($row+$i, $col+1,  '\'00',  $format);
$worksheet->write($row+$i, $col+2,  '\'01',  $format);
$worksheet->write($row+$i, $col+3,  '\'02',  $format);
$worksheet->write($row+$i, $col+4,  '\'03',  $format);
$worksheet->write($row+$i, $col+5,  '\'04',  $format);
$worksheet->write($row+$i, $col+6,  '\'05',  $format);
$worksheet->write($row+$i, $col+7,  '\'06',  $format);
$worksheet->write($row+$i, $col+8,  '\'07',  $format);
$worksheet->write($row+$i, $col+9,  '\'08',  $format);
$worksheet->write($row+$i, $col+10, '\'09',  $format);
$worksheet->write($row+$i, $col+11, '\'10',  $format);
$worksheet->write($row+$i, $col+12, '\'11',  $format);
$worksheet->write($row+$i, $col+13, '\'12',  $format);
$worksheet->write($row+$i, $col+14, '\'13',  $format);
$worksheet->write($row+$i, $col+15, '\'14',  $format);
$worksheet->write($row+$i, $col+16, '\'15',  $format);
$worksheet->write($row+$i, $col+17, '\'16',  $format);
$worksheet->write($row+$i, $col+18, '\'17',  $format);
$worksheet->write($row+$i, $col+19, '\'18',  $format);
$worksheet->write($row+$i, $col+20, '\'19',  $format);
$worksheet->write($row+$i, $col+21, '\'20',  $format);
$worksheet->write($row+$i, $col+22, '\'21',  $format);
$worksheet->write($row+$i, $col+23, '\'22',  $format);
$worksheet->write($row+$i, $col+24, '\'23',  $format);
$worksheet->write($row+$i, $col+25, 'TOTAL', $format);

$worksheet->write($row+$i, $col+27, '\'00',  $format);
$worksheet->write($row+$i, $col+28, '\'01',  $format);
$worksheet->write($row+$i, $col+29, '\'02',  $format);
$worksheet->write($row+$i, $col+30, '\'03',  $format);
$worksheet->write($row+$i, $col+31, '\'04',  $format);
$worksheet->write($row+$i, $col+32, '\'05',  $format);
$worksheet->write($row+$i, $col+33, '\'06',  $format);
$worksheet->write($row+$i, $col+34, '\'07',  $format);
$worksheet->write($row+$i, $col+35, '\'08',  $format);
$worksheet->write($row+$i, $col+36, '\'09',  $format);
$worksheet->write($row+$i, $col+37, '\'10',  $format);
$worksheet->write($row+$i, $col+38, '\'11',  $format);
$worksheet->write($row+$i, $col+39, '\'12',  $format);
$worksheet->write($row+$i, $col+40, '\'13',  $format);
$worksheet->write($row+$i, $col+41, '\'14',  $format);
$worksheet->write($row+$i, $col+42, '\'15',  $format);
$worksheet->write($row+$i, $col+43, '\'16',  $format);
$worksheet->write($row+$i, $col+44, '\'17',  $format);
$worksheet->write($row+$i, $col+45, '\'18',  $format);
$worksheet->write($row+$i, $col+46, '\'19',  $format);
$worksheet->write($row+$i, $col+47, '\'20',  $format);
$worksheet->write($row+$i, $col+48, '\'21',  $format);
$worksheet->write($row+$i, $col+49, '\'22',  $format);
$worksheet->write($row+$i, $col+50, '\'23',  $format);
$worksheet->write($row+$i, $col+51, 'TOTAL', $format);



while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1);
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $formatT);

   $worksheet->write($row+$i, $col+27, $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+40, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+41, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[66], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[69], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[72], $format1);
   $worksheet->write($row+$i, $col+49, $rowRst[73], $format1);
   $worksheet->write($row+$i, $col+50, $rowRst[74], $format1);
   $worksheet->write($row+$i, $col+51, $rowRst[75], $formatT);

}


###################################################
###################################################
###################################################

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  tm_00_3h, tm_01_3h, tm_02_3h, tm_03_3h, tm_04_3h, tm_05_3h, tm_06_3h, tm_07_3h, tm_08_3h, tm_09_3h, tm_10_3h, tm_11_3h, tm_12_3h, tm_13_3h, tm_14_3h, tm_15_3h, tm_16_3h, tm_17_3h, tm_18_3h, tm_19_3h, tm_20_3h, tm_21_3h, tm_22_3h, tm_23_3h, tm_tot_3h, tm_00_24h, tm_01_24h, tm_02_24h, tm_03_24h, tm_04_24h, tm_05_24h, tm_06_24h, tm_07_24h, tm_08_24h, tm_09_24h, tm_10_24h, tm_11_24h, tm_12_24h, tm_13_24h, tm_14_24h, tm_15_24h, tm_16_24h, tm_17_24h, tm_18_24h, tm_19_24h, tm_20_24h, tm_21_24h, tm_22_24h, tm_23_24h, tm_tot_24h, tm_00_3u, tm_01_3u, tm_02_3u, tm_03_3u, tm_04_3u, tm_05_3u, tm_06_3u, tm_07_3u, tm_08_3u, tm_09_3u, tm_10_3u, tm_11_3u, tm_12_3u, tm_13_3u, tm_14_3u, tm_15_3u, tm_16_3u, tm_17_3u, tm_18_3u, tm_19_3u, tm_20_3u, tm_21_3u, tm_22_3u, tm_23_3u, tm_tot_3u, tm_00_24u, tm_01_24u, tm_02_24u, tm_03_24u, tm_04_24u, tm_05_24u, tm_06_24u, tm_07_24u, tm_08_24u, tm_09_24u, tm_10_24u, tm_11_24u, tm_12_24u, tm_13_24u, tm_14_24u, tm_15_24u, tm_16_24u, tm_17_24u, tm_18_24u, tm_19_24u, tm_20_24u, tm_21_24u, tm_22_24u, tm_23_24u, tm_tot_24u from powerapp_hourlyrep_hits_summary where plan = 'WIKIPEDIA' and left(tran_dt,7) = '".$current_date."' order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet("WIKIPEDIA");


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

$format2 = $workbook->add_format(bg_color => 'gray'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(1);

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
$formatC->set_size('12');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('12');
$formatS->set_color('black');
$formatS->set_align('center');
$formatS->set_border(1);

$formatB = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatB->set_bold();
$formatB->set_font('Calibri');
$formatB->set_size('10');
$formatB->set_color('black');
$formatB->set_align('center');
$formatB->set_border(1);

$formatE = $workbook->add_format(bg_color => 'magenta'); # Add a format
$formatE->set_bold();
$formatE->set_font('Calibri');
$formatE->set_size('10');
$formatE->set_color('black');
$formatE->set_align('center');
$formatE->set_border(1);

$formatP = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP->set_bold();
$formatP->set_font('Calibri');
$formatP->set_size('10');
$formatP->set_color('black');
$formatP->set_align('center');
$formatP->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);



$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 24, 4);
$worksheet->set_column(25, 25, 6);
$worksheet->set_column(26, 26, 1);
$worksheet->set_column(27, 50, 4);
$worksheet->set_column(51, 51, 6);

$worksheet->set_column(52, 52, 3);

$worksheet->set_column(53, 76, 4);
$worksheet->set_column(77, 77, 6);
$worksheet->set_column(78, 78, 1);
$worksheet->set_column(79, 102, 4);
$worksheet->set_column(103,103, 6);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:AZ2',  'W I K I P E D I A', $formatC);

$worksheet->merge_range('B3:Z3', 'HITS', $formatP);
$worksheet->merge_range('AB3:AZ3', 'UNIQUE USERS', $formatU);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',  $format);
$worksheet->write($row+$i, $col+1,  '\'00',  $format);
$worksheet->write($row+$i, $col+2,  '\'01',  $format);
$worksheet->write($row+$i, $col+3,  '\'02',  $format);
$worksheet->write($row+$i, $col+4,  '\'03',  $format);
$worksheet->write($row+$i, $col+5,  '\'04',  $format);
$worksheet->write($row+$i, $col+6,  '\'05',  $format);
$worksheet->write($row+$i, $col+7,  '\'06',  $format);
$worksheet->write($row+$i, $col+8,  '\'07',  $format);
$worksheet->write($row+$i, $col+9,  '\'08',  $format);
$worksheet->write($row+$i, $col+10, '\'09',  $format);
$worksheet->write($row+$i, $col+11, '\'10',  $format);
$worksheet->write($row+$i, $col+12, '\'11',  $format);
$worksheet->write($row+$i, $col+13, '\'12',  $format);
$worksheet->write($row+$i, $col+14, '\'13',  $format);
$worksheet->write($row+$i, $col+15, '\'14',  $format);
$worksheet->write($row+$i, $col+16, '\'15',  $format);
$worksheet->write($row+$i, $col+17, '\'16',  $format);
$worksheet->write($row+$i, $col+18, '\'17',  $format);
$worksheet->write($row+$i, $col+19, '\'18',  $format);
$worksheet->write($row+$i, $col+20, '\'19',  $format);
$worksheet->write($row+$i, $col+21, '\'20',  $format);
$worksheet->write($row+$i, $col+22, '\'21',  $format);
$worksheet->write($row+$i, $col+23, '\'22',  $format);
$worksheet->write($row+$i, $col+24, '\'23',  $format);
$worksheet->write($row+$i, $col+25, 'TOTAL', $format);

$worksheet->write($row+$i, $col+27, '\'00',  $format);
$worksheet->write($row+$i, $col+28, '\'01',  $format);
$worksheet->write($row+$i, $col+29, '\'02',  $format);
$worksheet->write($row+$i, $col+30, '\'03',  $format);
$worksheet->write($row+$i, $col+31, '\'04',  $format);
$worksheet->write($row+$i, $col+32, '\'05',  $format);
$worksheet->write($row+$i, $col+33, '\'06',  $format);
$worksheet->write($row+$i, $col+34, '\'07',  $format);
$worksheet->write($row+$i, $col+35, '\'08',  $format);
$worksheet->write($row+$i, $col+36, '\'09',  $format);
$worksheet->write($row+$i, $col+37, '\'10',  $format);
$worksheet->write($row+$i, $col+38, '\'11',  $format);
$worksheet->write($row+$i, $col+39, '\'12',  $format);
$worksheet->write($row+$i, $col+40, '\'13',  $format);
$worksheet->write($row+$i, $col+41, '\'14',  $format);
$worksheet->write($row+$i, $col+42, '\'15',  $format);
$worksheet->write($row+$i, $col+43, '\'16',  $format);
$worksheet->write($row+$i, $col+44, '\'17',  $format);
$worksheet->write($row+$i, $col+45, '\'18',  $format);
$worksheet->write($row+$i, $col+46, '\'19',  $format);
$worksheet->write($row+$i, $col+47, '\'20',  $format);
$worksheet->write($row+$i, $col+48, '\'21',  $format);
$worksheet->write($row+$i, $col+49, '\'22',  $format);
$worksheet->write($row+$i, $col+50, '\'23',  $format);
$worksheet->write($row+$i, $col+51, 'TOTAL', $format);



while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1);
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $formatT);

   $worksheet->write($row+$i, $col+27, $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+40, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+41, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[66], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[69], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[72], $format1);
   $worksheet->write($row+$i, $col+49, $rowRst[73], $format1);
   $worksheet->write($row+$i, $col+50, $rowRst[74], $format1);
   $worksheet->write($row+$i, $col+51, $rowRst[75], $formatT);

}


###################################################
###################################################
###################################################

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  tm_00_3h, tm_01_3h, tm_02_3h, tm_03_3h, tm_04_3h, tm_05_3h, tm_06_3h, tm_07_3h, tm_08_3h, tm_09_3h, tm_10_3h, tm_11_3h, tm_12_3h, tm_13_3h, tm_14_3h, tm_15_3h, tm_16_3h, tm_17_3h, tm_18_3h, tm_19_3h, tm_20_3h, tm_21_3h, tm_22_3h, tm_23_3h, tm_tot_3h, tm_00_24h, tm_01_24h, tm_02_24h, tm_03_24h, tm_04_24h, tm_05_24h, tm_06_24h, tm_07_24h, tm_08_24h, tm_09_24h, tm_10_24h, tm_11_24h, tm_12_24h, tm_13_24h, tm_14_24h, tm_15_24h, tm_16_24h, tm_17_24h, tm_18_24h, tm_19_24h, tm_20_24h, tm_21_24h, tm_22_24h, tm_23_24h, tm_tot_24h, tm_00_3u, tm_01_3u, tm_02_3u, tm_03_3u, tm_04_3u, tm_05_3u, tm_06_3u, tm_07_3u, tm_08_3u, tm_09_3u, tm_10_3u, tm_11_3u, tm_12_3u, tm_13_3u, tm_14_3u, tm_15_3u, tm_16_3u, tm_17_3u, tm_18_3u, tm_19_3u, tm_20_3u, tm_21_3u, tm_22_3u, tm_23_3u, tm_tot_3u, tm_00_24u, tm_01_24u, tm_02_24u, tm_03_24u, tm_04_24u, tm_05_24u, tm_06_24u, tm_07_24u, tm_08_24u, tm_09_24u, tm_10_24u, tm_11_24u, tm_12_24u, tm_13_24u, tm_14_24u, tm_15_24u, tm_16_24u, tm_17_24u, tm_18_24u, tm_19_24u, tm_20_24u, tm_21_24u, tm_22_24u, tm_23_24u, tm_tot_24u from powerapp_hourlyrep_hits_summary where plan = 'FREE_SOCIAL' and left(tran_dt,7) = '".$current_date."' order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet("FREE_SOCIAL");


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

$format2 = $workbook->add_format(bg_color => 'gray'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(1);

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
$formatC->set_size('12');
$formatC->set_color('black');
$formatC->set_align('center');
$formatC->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('12');
$formatS->set_color('black');
$formatS->set_align('center');
$formatS->set_border(1);

$formatB = $workbook->add_format(bg_color => 'gray'); # Add a format
$formatB->set_bold();
$formatB->set_font('Calibri');
$formatB->set_size('10');
$formatB->set_color('black');
$formatB->set_align('center');
$formatB->set_border(1);

$formatE = $workbook->add_format(bg_color => 'magenta'); # Add a format
$formatE->set_bold();
$formatE->set_font('Calibri');
$formatE->set_size('10');
$formatE->set_color('black');
$formatE->set_align('center');
$formatE->set_border(1);

$formatP = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP->set_bold();
$formatP->set_font('Calibri');
$formatP->set_size('10');
$formatP->set_color('black');
$formatP->set_align('center');
$formatP->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);



$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 24, 4);
$worksheet->set_column(25, 25, 6);
$worksheet->set_column(26, 26, 1);
$worksheet->set_column(27, 50, 4);
$worksheet->set_column(51, 51, 6);

$worksheet->set_column(52, 52, 3);

$worksheet->set_column(53, 76, 4);
$worksheet->set_column(77, 77, 6);
$worksheet->set_column(78, 78, 1);
$worksheet->set_column(79, 102, 4);
$worksheet->set_column(103,103, 6);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:AZ2',  'F  R  E  E      S  O  C  I  A  L', $formatC);

$worksheet->merge_range('B3:Z3', 'HITS', $formatP);
$worksheet->merge_range('AB3:AZ3', 'UNIQUE USERS', $formatU);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',  $format);
$worksheet->write($row+$i, $col+1,  '\'00',  $format);
$worksheet->write($row+$i, $col+2,  '\'01',  $format);
$worksheet->write($row+$i, $col+3,  '\'02',  $format);
$worksheet->write($row+$i, $col+4,  '\'03',  $format);
$worksheet->write($row+$i, $col+5,  '\'04',  $format);
$worksheet->write($row+$i, $col+6,  '\'05',  $format);
$worksheet->write($row+$i, $col+7,  '\'06',  $format);
$worksheet->write($row+$i, $col+8,  '\'07',  $format);
$worksheet->write($row+$i, $col+9,  '\'08',  $format);
$worksheet->write($row+$i, $col+10, '\'09',  $format);
$worksheet->write($row+$i, $col+11, '\'10',  $format);
$worksheet->write($row+$i, $col+12, '\'11',  $format);
$worksheet->write($row+$i, $col+13, '\'12',  $format);
$worksheet->write($row+$i, $col+14, '\'13',  $format);
$worksheet->write($row+$i, $col+15, '\'14',  $format);
$worksheet->write($row+$i, $col+16, '\'15',  $format);
$worksheet->write($row+$i, $col+17, '\'16',  $format);
$worksheet->write($row+$i, $col+18, '\'17',  $format);
$worksheet->write($row+$i, $col+19, '\'18',  $format);
$worksheet->write($row+$i, $col+20, '\'19',  $format);
$worksheet->write($row+$i, $col+21, '\'20',  $format);
$worksheet->write($row+$i, $col+22, '\'21',  $format);
$worksheet->write($row+$i, $col+23, '\'22',  $format);
$worksheet->write($row+$i, $col+24, '\'23',  $format);
$worksheet->write($row+$i, $col+25, 'TOTAL', $format);

$worksheet->write($row+$i, $col+27, '\'00',  $format);
$worksheet->write($row+$i, $col+28, '\'01',  $format);
$worksheet->write($row+$i, $col+29, '\'02',  $format);
$worksheet->write($row+$i, $col+30, '\'03',  $format);
$worksheet->write($row+$i, $col+31, '\'04',  $format);
$worksheet->write($row+$i, $col+32, '\'05',  $format);
$worksheet->write($row+$i, $col+33, '\'06',  $format);
$worksheet->write($row+$i, $col+34, '\'07',  $format);
$worksheet->write($row+$i, $col+35, '\'08',  $format);
$worksheet->write($row+$i, $col+36, '\'09',  $format);
$worksheet->write($row+$i, $col+37, '\'10',  $format);
$worksheet->write($row+$i, $col+38, '\'11',  $format);
$worksheet->write($row+$i, $col+39, '\'12',  $format);
$worksheet->write($row+$i, $col+40, '\'13',  $format);
$worksheet->write($row+$i, $col+41, '\'14',  $format);
$worksheet->write($row+$i, $col+42, '\'15',  $format);
$worksheet->write($row+$i, $col+43, '\'16',  $format);
$worksheet->write($row+$i, $col+44, '\'17',  $format);
$worksheet->write($row+$i, $col+45, '\'18',  $format);
$worksheet->write($row+$i, $col+46, '\'19',  $format);
$worksheet->write($row+$i, $col+47, '\'20',  $format);
$worksheet->write($row+$i, $col+48, '\'21',  $format);
$worksheet->write($row+$i, $col+49, '\'22',  $format);
$worksheet->write($row+$i, $col+50, '\'23',  $format);
$worksheet->write($row+$i, $col+51, 'TOTAL', $format);



while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $format1);
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $formatT);

   $worksheet->write($row+$i, $col+27, $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+40, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+41, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[66], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[69], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[72], $format1);
   $worksheet->write($row+$i, $col+49, $rowRst[73], $format1);
   $worksheet->write($row+$i, $col+50, $rowRst[74], $format1);
   $worksheet->write($row+$i, $col+51, $rowRst[75], $formatT);

}



$workbook->close();
binmode STDOUT;

$from = "powerapp_stats\@chikka.com";
$to = "jomai\@chikka.com,ian\@chikka.com,victor\@chikka.com,speralta\@chikka.com";
$cc = "dbadmins\@chikka.com";
#$to = "glenon\@chikka.com";
#$cc = "glenon\@chikka.com";
$Subject = "PowerApp Stats (Hourly), ".$current_day;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp Stats (hourly breakdown) for the Month of $txt_month.</span></span></p>
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




