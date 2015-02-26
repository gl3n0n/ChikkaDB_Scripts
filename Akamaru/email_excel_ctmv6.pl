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

my $excel_file = "/home/dba_scripts/oist_stat/ctmv6_stat_".$current_date.".xls";
print $excel_file;

my $dbh_ctmv6 = DB::DBconnect(myconstants::CTMV6_DB,myconstants::CTMV6_HOST,myconstants::CTMV6_USER,myconstants::CTMV6_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
my $sth_ctm_v6;
my @rowRst;

############################################
# 1st Worksheet
############################################
# Add a worksheet[0]
$worksheet[0] = $workbook->add_worksheet($txt_month);
$worksheet[1] = $workbook->add_worksheet('Reg_per_Country');
$worksheet[2] = $workbook->add_worksheet('Summary');
$worksheet[3] = $workbook->add_worksheet('Voice');

#  Add and define a format
$format = $workbook->add_format(bg_color => 'gray'); # Add a format
$format->set_bold();
$format->set_font('Calibri');
$format->set_size('9');
$format->set_color('black');
$format->set_align('center');
$format->set_border(2);

$formatNumber = $workbook->add_format(); # Add a format
$formatNumber->set_font('Calibri');
$formatNumber->set_size('9');
$formatNumber->set_color('black');
$formatNumber->set_align('right');
$formatNumber->set_border(1);
$formatNumber->set_num_format('###,###,##0');

$formatString = $workbook->add_format(); # Add a format
$formatString->set_font('Calibri');
$formatString->set_size('9');
$formatString->set_color('black');
$formatString->set_align('center');
$formatString->set_border(1);

$format2 = $workbook->add_format(bg_color => 'yellow'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(2);
$format2->set_align('vcenter');

$format3 = $workbook->add_format(bg_color => 'green'); # Add a format
$format3->set_bold();
$format3->set_font('Calibri');
$format3->set_size('9');
$format3->set_color('black');
$format3->set_align('center');
$format3->set_border(2);

$format4 = $workbook->add_format(bg_color => 'green'); # Add a format
$format4->set_bold();
$format4->set_font('Calibri');
$format4->set_size('9');
$format4->set_color('black');
$format4->set_align('center');
$format4->set_border(2);


# Write a formatted and unformatted string, row and column notation.
# $worksheet[0] = $workbook->add_worksheet($txt_month);
# hits,registration,logins,ussd,...
$worksheet[0]->merge_range('B2:V2',   'GLOBE',        $format2);
$worksheet[0]->merge_range('X2:AW2',  'SMART',        $format2);
$worksheet[0]->merge_range('AY2:BN2', 'SUN',          $format2);
$worksheet[0]->merge_range('BP2:BW2', 'REGISTRATION', $format2);
$worksheet[0]->merge_range('BY2:CC2', 'MIGRATION',    $format2);
$worksheet[0]->merge_range('CE2:CH2', 'LOGIN',        $format2);
$worksheet[0]->merge_range('CJ2:CK2', 'USSD',         $format2);

$worksheet[0]->merge_range('B3:E3',    'HITS',                               $format3);
$worksheet[0]->merge_range('F3:I3',    'Unique Charged',                     $format3);
$worksheet[0]->merge_range('J3:M3',    'Mobile Terminating Messages (Free)', $format3);
$worksheet[0]->write(2, 13,            'Unique Non-Reg',                     $format4);
$worksheet[0]->merge_range('O3:R3',    'Registration',                       $format3);
$worksheet[0]->merge_range('S3:V3',    'Migration',                          $format3);

$worksheet[0]->merge_range('X3:AB3',   'HITS',                               $format3);
$worksheet[0]->merge_range('AC3:AG3',  'Unique Charged',                     $format3);
$worksheet[0]->merge_range('AH3:AL3',  'Mobile Terminating Messages (Free)', $format3);
$worksheet[0]->write(2, 38,            'Unique Non-Reg',                     $format4);
$worksheet[0]->merge_range('AN3:AR3',  'Registration',                       $format3);
$worksheet[0]->merge_range('AS3:AW3',  'Migration',                          $format3);

$worksheet[0]->merge_range('AY3:BA3',  'HITS',                               $format3);
$worksheet[0]->merge_range('BB3:BD3',  'Unique Charged',                     $format3);
$worksheet[0]->merge_range('BE3:BG3',  'Mobile Terminating Messages (Free)', $format3);
$worksheet[0]->write(2, 59,            'Unique Non-Reg',                     $format4);
$worksheet[0]->merge_range('BI3:BK3',  'Registration',                       $format3);
$worksheet[0]->merge_range('BL3:BN3',  'Migration',                          $format3);

$worksheet[0]->merge_range('BP3:BW3', 'per Carrier or SN', $format3);
$worksheet[0]->merge_range('BY3:CC3', ' ',                 $format3);
$worksheet[0]->merge_range('CE3:CH3', 'Sign-in via',       $format3);
$worksheet[0]->merge_range('CJ3:CK3', ' ',                 $format3);

$worksheet[0]->set_column(0,0,10);
$worksheet[0]->set_column(1,12,8);
$worksheet[0]->set_column(13,13,12);
$worksheet[0]->set_column(14,21,8);
$worksheet[0]->set_column(22,22,1);
$worksheet[0]->set_column(23,37,8);
$worksheet[0]->set_column(38,38,12);
$worksheet[0]->set_column(39,48,8);
$worksheet[0]->set_column(49,49,1);
$worksheet[0]->set_column(50,58,8);
$worksheet[0]->set_column(59,59,12);
$worksheet[0]->set_column(60,65,8);
$worksheet[0]->set_column(66,66,1);
$worksheet[0]->set_column(67,74,8);
$worksheet[0]->set_column(75,75,1);
$worksheet[0]->set_column(76,80,7);
$worksheet[0]->set_column(81,81,1);
$worksheet[0]->set_column(82,85,8);
$worksheet[0]->set_column(86,86,1);
$worksheet[0]->set_column(87,87,12);
$worksheet[0]->set_column(88,88,8);

$row = 2;
$col = 0;
$i=1;
#GLOBE
$worksheet[0]->write($row+$i, $col,    'DATE',     $format);
$worksheet[0]->write($row+$i, $col+1,  'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+2,  'Postpaid', $format);
$worksheet[0]->write($row+$i, $col+3,  'Prepaid',  $format);
$worksheet[0]->write($row+$i, $col+4,  'TM',       $format);
$worksheet[0]->write($row+$i, $col+5,  'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+6,  'Postpaid', $format);
$worksheet[0]->write($row+$i, $col+7,  'Prepaid',  $format);
$worksheet[0]->write($row+$i, $col+8,  'TM',       $format);
$worksheet[0]->write($row+$i, $col+9,  'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+10, 'Postpaid', $format);
$worksheet[0]->write($row+$i, $col+11, 'Prepaid',  $format);
$worksheet[0]->write($row+$i, $col+12, 'TM',       $format);
$worksheet[0]->write($row+$i, $col+13, 'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+14, 'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+15, 'Postpaid', $format);
$worksheet[0]->write($row+$i, $col+16, 'Prepaid',  $format);
$worksheet[0]->write($row+$i, $col+17, 'TM',       $format);
$worksheet[0]->write($row+$i, $col+18, 'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+19, 'Postpaid', $format);
$worksheet[0]->write($row+$i, $col+20, 'Prepaid',  $format);
$worksheet[0]->write($row+$i, $col+21, 'TM',       $format);

#SMART
$worksheet[0]->write($row+$i, $col+23, 'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+24, 'Postpaid', $format);
$worksheet[0]->write($row+$i, $col+25, 'Prepaid',  $format);
$worksheet[0]->write($row+$i, $col+26, 'TNT',      $format);
$worksheet[0]->write($row+$i, $col+27, 'Bro',      $format);
$worksheet[0]->write($row+$i, $col+28, 'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+29, 'Postpaid', $format);
$worksheet[0]->write($row+$i, $col+30, 'Prepaid',  $format);
$worksheet[0]->write($row+$i, $col+31, 'TNT',      $format);
$worksheet[0]->write($row+$i, $col+32, 'Bro',      $format);
$worksheet[0]->write($row+$i, $col+33, 'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+34, 'Postpaid', $format);
$worksheet[0]->write($row+$i, $col+35, 'Prepaid',  $format);
$worksheet[0]->write($row+$i, $col+36, 'TNT',      $format);
$worksheet[0]->write($row+$i, $col+37, 'Bro',      $format);
$worksheet[0]->write($row+$i, $col+38, 'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+39, 'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+40, 'Postpaid', $format);
$worksheet[0]->write($row+$i, $col+41, 'Prepaid',  $format);
$worksheet[0]->write($row+$i, $col+42, 'TNT',      $format);
$worksheet[0]->write($row+$i, $col+43, 'Bro',      $format);
$worksheet[0]->write($row+$i, $col+44, 'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+45, 'Postpaid', $format);
$worksheet[0]->write($row+$i, $col+46, 'Prepaid',  $format);
$worksheet[0]->write($row+$i, $col+47, 'TNT',      $format);
$worksheet[0]->write($row+$i, $col+48, 'Bro',      $format);
#SUN
$worksheet[0]->write($row+$i, $col+50, 'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+51, 'Postpaid', $format);
$worksheet[0]->write($row+$i, $col+52, 'Prepaid',  $format);
$worksheet[0]->write($row+$i, $col+53, 'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+54, 'Postpaid', $format);
$worksheet[0]->write($row+$i, $col+55, 'Prepaid',  $format);
$worksheet[0]->write($row+$i, $col+56, 'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+57, 'Postpaid', $format);
$worksheet[0]->write($row+$i, $col+58, 'Prepaid',  $format);
$worksheet[0]->write($row+$i, $col+59, 'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+60, 'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+61, 'Postpaid', $format);
$worksheet[0]->write($row+$i, $col+62, 'Prepaid',  $format);
$worksheet[0]->write($row+$i, $col+63, 'TOTAL',    $format);
$worksheet[0]->write($row+$i, $col+64, 'Postpaid', $format);
$worksheet[0]->write($row+$i, $col+65, 'Prepaid',  $format);
#REGISTRATION PER Carrier/SN
$worksheet[0]->write($row+$i, $col+67, 'Globe',    $format);
$worksheet[0]->write($row+$i, $col+68, 'Smart',    $format);
$worksheet[0]->write($row+$i, $col+69, 'Sun',      $format);
$worksheet[0]->write($row+$i, $col+70, 'Facebook', $format);
$worksheet[0]->write($row+$i, $col+71, 'Twitter',  $format);
$worksheet[0]->write($row+$i, $col+72, 'Google+',  $format);
$worksheet[0]->write($row+$i, $col+73, 'LinkedIN', $format);
$worksheet[0]->write($row+$i, $col+74, 'TOTAL',    $format);
#LOGIN PER Carrier/Device
$worksheet[0]->write($row+$i, $col+76, 'Globe',    $format);
$worksheet[0]->write($row+$i, $col+77, 'Smart',    $format);
$worksheet[0]->write($row+$i, $col+78, 'Sun',      $format);
$worksheet[0]->write($row+$i, $col+79, 'PC',       $format);
$worksheet[0]->write($row+$i, $col+80, 'TOTAL',    $format);

$worksheet[0]->write($row+$i, $col+82, 'Android',  $format);
$worksheet[0]->write($row+$i, $col+83, 'iOS',      $format);
$worksheet[0]->write($row+$i, $col+84, 'Web',      $format);
$worksheet[0]->write($row+$i, $col+85, 'Total',    $format);
#USSD
$worksheet[0]->write($row+$i, $col+87, 'Trans (MT)', $format);
$worksheet[0]->write($row+$i, $col+88, 'USSD',       $format);

#$row = 2;
#$col = 0;
#$i=1;
$strSQLCTMv6 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  
                       hits_total, hits_post, hits_pre, hits_tm_tnt,  
                       uniq_total, uniq_post, uniq_pre, uniq_tm_tnt,  
                       free_total, free_post, free_pre, free_tm_tnt, 
                       uniq_nonreg, 
                       reg_total, reg_post, reg_pre, reg_tm_tnt, 
                       regm_total, regm_post, regm_pre, regm_tm_tnt
                 from ctmv6_carrier_stats where carrier='globe' and left(tran_dt,7) = '".$current_date."' order by tran_dt";
$sth_ctm_v6 = $dbh_ctmv6->prepare($strSQLCTMv6);
$sth_ctm_v6->execute();

while (@rowRst = $sth_ctm_v6->fetchrow()) {
   $i++;
   $worksheet[0]->write($row+$i, $col,    $rowRst[0],  $formatString);
   $worksheet[0]->write($row+$i, $col+1,  $rowRst[1],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+2,  $rowRst[2],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+3,  $rowRst[3],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+4,  $rowRst[4],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+5,  $rowRst[5],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+6,  $rowRst[6],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+7,  $rowRst[7],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+8,  $rowRst[8],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+9,  $rowRst[9],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+10, $rowRst[10], $formatNumber);
   $worksheet[0]->write($row+$i, $col+11, $rowRst[11], $formatNumber);
   $worksheet[0]->write($row+$i, $col+12, $rowRst[12], $formatNumber);
   $worksheet[0]->write($row+$i, $col+13, $rowRst[13], $formatNumber);
   $worksheet[0]->write($row+$i, $col+14, $rowRst[14], $formatNumber);
   $worksheet[0]->write($row+$i, $col+15, $rowRst[15], $formatNumber);
   $worksheet[0]->write($row+$i, $col+16, $rowRst[16], $formatNumber);
   $worksheet[0]->write($row+$i, $col+17, $rowRst[17], $formatNumber);
   $worksheet[0]->write($row+$i, $col+18, $rowRst[18], $formatNumber);
   $worksheet[0]->write($row+$i, $col+19, $rowRst[19], $formatNumber);
   $worksheet[0]->write($row+$i, $col+20, $rowRst[20], $formatNumber);
   $worksheet[0]->write($row+$i, $col+21, $rowRst[21], $formatNumber);
}

$row = 2;
$col = 0;
$i=1;
$strSQLCTMv6 = "select hits_total, hits_post, hits_pre, hits_tm_tnt, hits_tat_bro, 
                       uniq_total, uniq_post, uniq_pre, uniq_tm_tnt, uniq_tat_bro,  
                       free_total, free_post, free_pre, free_tm_tnt, free_tat_bro,
                       uniq_nonreg, 
                       reg_total, reg_post, reg_pre, reg_tm_tnt, reg_tat_bro,
                       regm_total, regm_post, regm_pre, regm_tm_tnt, regm_tat_bro
                 from ctmv6_carrier_stats where carrier='smart' and left(tran_dt,7) = '".$current_date."' order by tran_dt";
$sth_ctm_v6 = $dbh_ctmv6->prepare($strSQLCTMv6);
$sth_ctm_v6->execute();

while (@rowRst = $sth_ctm_v6->fetchrow()) {
   $i++;
   $worksheet[0]->write($row+$i, $col+23, $rowRst[0],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+24, $rowRst[1],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+25, $rowRst[2],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+26, $rowRst[3],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+27, $rowRst[4],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+28, $rowRst[5],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+29, $rowRst[6],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+30, $rowRst[7],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+31, $rowRst[8],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+32, $rowRst[9],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+33, $rowRst[10], $formatNumber);
   $worksheet[0]->write($row+$i, $col+34, $rowRst[11], $formatNumber);
   $worksheet[0]->write($row+$i, $col+35, $rowRst[12], $formatNumber);
   $worksheet[0]->write($row+$i, $col+36, $rowRst[13], $formatNumber);
   $worksheet[0]->write($row+$i, $col+37, $rowRst[14], $formatNumber);
   $worksheet[0]->write($row+$i, $col+38, $rowRst[15], $formatNumber);
   $worksheet[0]->write($row+$i, $col+39, $rowRst[16], $formatNumber);
   $worksheet[0]->write($row+$i, $col+40, $rowRst[17], $formatNumber);
   $worksheet[0]->write($row+$i, $col+41, $rowRst[18], $formatNumber);
   $worksheet[0]->write($row+$i, $col+42, $rowRst[19], $formatNumber);
   $worksheet[0]->write($row+$i, $col+43, $rowRst[20], $formatNumber);
   $worksheet[0]->write($row+$i, $col+44, $rowRst[21], $formatNumber);
   $worksheet[0]->write($row+$i, $col+45, $rowRst[22], $formatNumber);
   $worksheet[0]->write($row+$i, $col+46, $rowRst[23], $formatNumber);
   $worksheet[0]->write($row+$i, $col+47, $rowRst[24], $formatNumber);
   $worksheet[0]->write($row+$i, $col+48, $rowRst[25], $formatNumber);
}

$row = 2;
$col = 0;
$i=1;
$strSQLCTMv6 = "select hits_total, hits_post, hits_pre,  
                       uniq_total, uniq_post, uniq_pre,   
                       free_total, free_post, free_pre, 
                       uniq_nonreg, 
                       reg_total, reg_post, reg_pre, 
                       regm_total, regm_post, regm_pre
                 from ctmv6_carrier_stats where carrier='sun' and left(tran_dt,7) = '".$current_date."' order by tran_dt";
$sth_ctm_v6 = $dbh_ctmv6->prepare($strSQLCTMv6);
$sth_ctm_v6->execute();

while (@rowRst = $sth_ctm_v6->fetchrow()) {
   $i++;
   $worksheet[0]->write($row+$i, $col+50, $rowRst[0],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+51, $rowRst[1],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+52, $rowRst[2],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+53, $rowRst[3],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+54, $rowRst[4],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+55, $rowRst[5],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+56, $rowRst[6],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+57, $rowRst[7],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+58, $rowRst[8],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+59, $rowRst[9],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+60, $rowRst[10], $formatNumber);
   $worksheet[0]->write($row+$i, $col+61, $rowRst[11], $formatNumber);
   $worksheet[0]->write($row+$i, $col+62, $rowRst[12], $formatNumber);
   $worksheet[0]->write($row+$i, $col+63, $rowRst[13], $formatNumber);
   $worksheet[0]->write($row+$i, $col+64, $rowRst[14], $formatNumber);
   $worksheet[0]->write($row+$i, $col+65, $rowRst[15], $formatNumber);
}

$row = 2;
$col = 0;
$i=1;
$strSQLCTMv6 = "select reg_globe, reg_smart, reg_sun, reg_fb, reg_tw, reg_go, reg_li, reg_total, 
                       regm_globe, regm_smart, regm_sun, regm_pc, regm_total, 
                       sign_and, sign_ios, sign_web, sign_total,
                       ussd_mt, ussd_hits
                from ctmv6_registration_stats 
                where left(tran_dt,7) = '".$current_date."' 
                order by tran_dt";
$sth_ctm_v6 = $dbh_ctmv6->prepare($strSQLCTMv6);
$sth_ctm_v6->execute();

while (@rowRst = $sth_ctm_v6->fetchrow()) {
   $i++;
   $worksheet[0]->write($row+$i, $col+67, $rowRst[0],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+68, $rowRst[1],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+69, $rowRst[2],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+70, $rowRst[3],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+71, $rowRst[4],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+72, $rowRst[5],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+73, $rowRst[6],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+74, $rowRst[7],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+76, $rowRst[8],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+77, $rowRst[9],  $formatNumber);
   $worksheet[0]->write($row+$i, $col+78, $rowRst[10], $formatNumber);
   $worksheet[0]->write($row+$i, $col+79, $rowRst[11], $formatNumber);
   $worksheet[0]->write($row+$i, $col+80, $rowRst[12], $formatNumber);
   $worksheet[0]->write($row+$i, $col+82, $rowRst[13], $formatNumber);
   $worksheet[0]->write($row+$i, $col+83, $rowRst[14], $formatNumber);
   $worksheet[0]->write($row+$i, $col+84, $rowRst[15], $formatNumber);
   $worksheet[0]->write($row+$i, $col+85, $rowRst[16], $formatNumber);
   $worksheet[0]->write($row+$i, $col+87, $rowRst[17], $formatNumber);
   $worksheet[0]->write($row+$i, $col+88, $rowRst[18], $formatNumber);
}

# $worksheet[1] = $workbook->add_worksheet('Reg_per_Country');
# reg_per_country
$row=2;
$worksheet[1]->set_column(0,0,10);
$worksheet[1]->set_column(1,41,9);
$worksheet[1]->set_column(9,9,10);
$worksheet[1]->set_column(16,16,11);
$worksheet[1]->set_column(22,22,11);
$worksheet[1]->set_column(30,30,11);
$worksheet[1]->set_column(40,40,11);
$worksheet[1]->merge_range('B2:AP2', 'R E G I S T R A T I O N   p e r   C O  U N T R Y', $format2);

$worksheet[1]->write($row, $col+0,  'Date',         $format);
$worksheet[1]->write($row, $col+1,  'AUSTRALIA',    $format);
$worksheet[1]->write($row, $col+2,  'BAHRAIN',      $format);
$worksheet[1]->write($row, $col+3,  'BRAZIL',       $format);
$worksheet[1]->write($row, $col+4,  'CANADA',       $format);
$worksheet[1]->write($row, $col+5,  'CHINA',        $format);
$worksheet[1]->write($row, $col+6,  'FRANCE',       $format);
$worksheet[1]->write($row, $col+7,  'GREECE',       $format);
$worksheet[1]->write($row, $col+8,  'GUAM',         $format);
$worksheet[1]->write($row, $col+9,  'HONG KONG',    $format);
$worksheet[1]->write($row, $col+10, 'INDIA',        $format);
$worksheet[1]->write($row, $col+11, 'IRAQ',         $format);
$worksheet[1]->write($row, $col+12, 'IRELAND',      $format);
$worksheet[1]->write($row, $col+13, 'ITALY',        $format);
$worksheet[1]->write($row, $col+14, 'JAPAN',        $format);
$worksheet[1]->write($row, $col+15, 'JORDAN',       $format);
$worksheet[1]->write($row, $col+16, 'KAZAKHSTAN',   $format);
$worksheet[1]->write($row, $col+17, 'KUWAIT',       $format);
$worksheet[1]->write($row, $col+18, 'LEBANON',      $format);
$worksheet[1]->write($row, $col+19, 'MACAU',        $format);
$worksheet[1]->write($row, $col+20, 'MALAYSIA',     $format);
$worksheet[1]->write($row, $col+21, 'MEXICO',       $format);
$worksheet[1]->write($row, $col+22, 'NEW ZEALAND',  $format);
$worksheet[1]->write($row, $col+23, 'NIGERIA',      $format);
$worksheet[1]->write($row, $col+24, 'N KOREA',      $format);
$worksheet[1]->write($row, $col+25, 'NORWAY',       $format);
$worksheet[1]->write($row, $col+26, 'OMAN',         $format);
$worksheet[1]->write($row, $col+27, 'PAKISTAN',     $format);
$worksheet[1]->write($row, $col+28, 'PHIL',         $format);
$worksheet[1]->write($row, $col+29, 'QATAR',        $format);
$worksheet[1]->write($row, $col+30, 'SAUDI ARABIA', $format);
$worksheet[1]->write($row, $col+31, 'SINGAPORE',    $format);
$worksheet[1]->write($row, $col+32, 'S KOREA',      $format);
$worksheet[1]->write($row, $col+33, 'SPAIN',        $format);
$worksheet[1]->write($row, $col+34, 'SWEDEN',       $format);
$worksheet[1]->write($row, $col+35, 'TAIWAN',       $format);
$worksheet[1]->write($row, $col+36, 'THAILAND',     $format);
$worksheet[1]->write($row, $col+37, 'UAE',          $format);
$worksheet[1]->write($row, $col+38, 'UK',           $format);
$worksheet[1]->write($row, $col+39, 'US',           $format);
$worksheet[1]->write($row, $col+40, 'VENENZUELA',   $format);
$worksheet[1]->write($row, $col+41, 'VIETNAM',      $format);

$row = 1;
$col = 0;
$i=1;
$strSQLCTMv6 = "select tran_dt,
                       AUSTRALIA, BAHRAIN, BRAZIL, CANADA, CHINA, FRANCE, GREECE, GUAM, HKONG, 
                       INDIA, IRAQ, IRELAND, ITALY, JAPAN, JORDAN, KAZAKHSTAN, KUWAIT, LEBANON, 
                       MACAU, MALAYSIA, MEXICO, ZEALAND, NIGERIA, NKOREA, NORWAY, OMAN, PAKISTAN, 
                       PHIL, QATAR, SARABIA, SINGAPORE, SKOREA, SPAIN, SWEDEN, TAIWAN, THAILAND, 
                       UAE, UKINGDOM, USTATES, VENEZUELA, VIETNAM 
                from   ctmv6_registration_per_country 
                where  left(tran_dt,7) = '".$current_date."' 
                order  by tran_dt";
$sth_ctm_v6 = $dbh_ctmv6->prepare($strSQLCTMv6);
$sth_ctm_v6->execute();

while (@rowRst = $sth_ctm_v6->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col+0,  $rowRst[0],   $formatString);
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],   $formatNumber);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],   $formatNumber);
   $worksheet[1]->write($row+$i, $col+3,  $rowRst[3],   $formatNumber);
   $worksheet[1]->write($row+$i, $col+4,  $rowRst[4],   $formatNumber);
   $worksheet[1]->write($row+$i, $col+5,  $rowRst[5],   $formatNumber);
   $worksheet[1]->write($row+$i, $col+6,  $rowRst[6],   $formatNumber);
   $worksheet[1]->write($row+$i, $col+7,  $rowRst[7],   $formatNumber);
   $worksheet[1]->write($row+$i, $col+8,  $rowRst[8],   $formatNumber);
   $worksheet[1]->write($row+$i, $col+9,  $rowRst[9],   $formatNumber);
   $worksheet[1]->write($row+$i, $col+10, $rowRst[10],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+11, $rowRst[11],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+12, $rowRst[12],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+13, $rowRst[13],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+14, $rowRst[14],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+15, $rowRst[15],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+16, $rowRst[16],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+17, $rowRst[17],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+18, $rowRst[18],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+19, $rowRst[19],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+20, $rowRst[20],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+21, $rowRst[21],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+22, $rowRst[22],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+23, $rowRst[23],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+24, $rowRst[24],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+25, $rowRst[25],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+26, $rowRst[26],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+27, $rowRst[27],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+28, $rowRst[28],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+29, $rowRst[29],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+30, $rowRst[30],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+31, $rowRst[31],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+32, $rowRst[32],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+33, $rowRst[33],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+34, $rowRst[34],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+35, $rowRst[35],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+36, $rowRst[36],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+37, $rowRst[37],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+38, $rowRst[38],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+39, $rowRst[39],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+40, $rowRst[40],  $formatNumber);
   $worksheet[1]->write($row+$i, $col+41, $rowRst[41],  $formatNumber);
  
}

## summary
# $worksheet[2] = $workbook->add_worksheet('Summary');
## summary
$worksheet[2]->merge_range('B1:D1', 'HITS',         $format2);
$worksheet[2]->merge_range('E1:H1', 'REVENUE',      $format2);
$worksheet[2]->merge_range('I1:P1', 'REGISTRATION', $format2);

$row=1;
$worksheet[2]->set_column(0,0,12);
$worksheet[2]->set_column(1,15,9);
$worksheet[2]->write($row, $col+0,  'MONTH',    $format4);
$worksheet[2]->write($row, $col+1,  'SMART',    $format4);
$worksheet[2]->write($row, $col+2,  'GLOBE',    $format4);
$worksheet[2]->write($row, $col+3,  'SUN',      $format4);
$worksheet[2]->write($row, $col+4,  'SMART',    $format4);
$worksheet[2]->write($row, $col+5,  'GLOBE',    $format4);
$worksheet[2]->write($row, $col+6,  'SUN',      $format4);
$worksheet[2]->write($row, $col+7,  'TOTAL',    $format4);
$worksheet[2]->write($row, $col+8,  'SMART',    $format4);
$worksheet[2]->write($row, $col+9,  'GLOBE',    $format4);
$worksheet[2]->write($row, $col+10, 'SUN',      $format4);
$worksheet[2]->write($row, $col+11, 'FACEBOOK', $format4);
$worksheet[2]->write($row, $col+12, 'TWITTER',  $format4);
$worksheet[2]->write($row, $col+13, 'GOOGLE+',  $format4);
$worksheet[2]->write($row, $col+14, 'LINKEDIN', $format4);
$worksheet[2]->write($row, $col+15, 'TOTAL',    $format4);

$row = 0;
$col = 0;
$i=1;
$strSQLCTMv6 = "select tx_month,
                       h_smart, h_globe, h_sun, 
                       r_smart, r_globe, r_sun, r_total,
                       reg_smart, reg_globe, reg_sun, 
                       reg_fb, reg_tw, reg_google, reg_link, reg_total
                from  ctmv6_monthly_stats
                where tx_year = left('".$current_date."',4) order by tx_yrmo";

$sth_ctm_v6 = $dbh_ctmv6->prepare($strSQLCTMv6);
$sth_ctm_v6->execute();

while (@rowRst = $sth_ctm_v6->fetchrow()) {
   $i++;
   $worksheet[2]->write($row+$i, $col+0,  $rowRst[0],  $formatString);
   $worksheet[2]->write($row+$i, $col+1,  $rowRst[1],  $formatNumber);
   $worksheet[2]->write($row+$i, $col+2,  $rowRst[2],  $formatNumber);
   $worksheet[2]->write($row+$i, $col+3,  $rowRst[3],  $formatNumber);
   $worksheet[2]->write($row+$i, $col+4,  $rowRst[4],  $formatNumber);
   $worksheet[2]->write($row+$i, $col+5,  $rowRst[5],  $formatNumber);
   $worksheet[2]->write($row+$i, $col+6,  $rowRst[6],  $formatNumber);
   $worksheet[2]->write($row+$i, $col+7,  $rowRst[7],  $formatNumber);
   $worksheet[2]->write($row+$i, $col+8,  $rowRst[8],  $formatNumber);
   $worksheet[2]->write($row+$i, $col+9,  $rowRst[9],  $formatNumber);
   $worksheet[2]->write($row+$i, $col+10, $rowRst[10], $formatNumber);
   $worksheet[2]->write($row+$i, $col+11, $rowRst[11], $formatNumber);
   $worksheet[2]->write($row+$i, $col+12, $rowRst[12], $formatNumber);
   $worksheet[2]->write($row+$i, $col+13, $rowRst[13], $formatNumber);
   $worksheet[2]->write($row+$i, $col+14, $rowRst[14], $formatNumber);
   $worksheet[2]->write($row+$i, $col+15, $rowRst[15], $formatNumber);

}

## worksheet voice
#$worksheet[3] voice
#
#
#
$worksheet[3]->set_column('a:a',15);
$worksheet[3]->set_column('b:c',10);

$worksheet[3]->write(1, $col+0,  'Date',         $format4);
$worksheet[3]->write(1, $col+1,  'VM Sent',    $format4);
$worksheet[3]->write(1, $col+2,  'Uniq VM Sent',      $format4);

$row = 0;
$col = 0;
$i=1;
$strSQLCTMv6 = "SELECT tran_dt,
        MAX(IF(type='voice',total, 0)) as voice,
        MAX(IF(type='uniq_voice',total, 0)) as uniq_voice
        FROM  ctmv6_stats_dtl
       where left(tran_dt,7) like '".$current_date."%'
       GROUP BY tran_dt;";

$sth_ctm_v6 = $dbh_ctmv6->prepare($strSQLCTMv6);
$sth_ctm_v6->execute();

while (@rowRst = $sth_ctm_v6->fetchrow()) 
{
   $i++;
   $worksheet[3]->write($row+$i, $col+0,  $rowRst[0],  $formatString);
   $worksheet[3]->write($row+$i, $col+1,  $rowRst[1],  $formatNumber);
   $worksheet[3]->write($row+$i, $col+2,  $rowRst[2],  $formatNumber);
} 




$workbook->close();
 binmode STDOUT;

$from = "ctm_stats\@chikka.com";
$to = "jomai\@chikka.com,bresos\@chikka.com,jldespanol\@chikka.com,caparolma\@chikka.com";
$cc = "dbadmins\@chikka.com,nbrinas\@chikka.com,jojo\@chikka.com,ra\@chikka.com";
#$to = "jojo\@chikka.com";
#$cc = "jojo\@chikka.com";
$Subject = "CTMV6 Stats, ".$current_day;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">CTM V6 Stats for the Month of $txt_month.</span></span></p>
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


