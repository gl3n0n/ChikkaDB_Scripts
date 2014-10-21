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

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_Brand_Stats_".$current_date.".xls";
print $excel_file;

my $dbh_hi10 = DB::DBconnect(myconstants::HI10_DB,myconstants::HI10_HOST,myconstants::HI10_USER,myconstants::HI10_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
my $sth_hi_10;
my @rowRst;

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

$format1s = $workbook->add_format(); # Add a format
$format1s->set_font('Calibri');
$format1s->set_size('9');
$format1s->set_color('black');
$format1s->set_align('left');
$format1s->set_border(1);

$format2 = $workbook->add_format(bg_color => 'silver'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('11');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(2);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B1:AW1', 'Hits per Package', $format2);
$worksheet->merge_range('AZ1:CU1', 'Unique Users', $format2);
$worksheet->merge_range('CW1:DD1', 'Hits & Optout Per Day', $format2);
$worksheet->merge_range('DF1:DI1', '', $format2);

$worksheet->merge_range('B2:M2', 'SMART PREPAID', $format2);
$worksheet->merge_range('N2:Y2', 'TNT', $format2);
$worksheet->merge_range('Z2:AK2', 'SMART POSTPAID', $format2);
$worksheet->merge_range('AL2:AW2', 'TOTAL', $format2);

$worksheet->merge_range('AZ2:BK2', 'SMART PREPAID', $format2);
$worksheet->merge_range('BL2:BW2', 'TNT', $format2);
$worksheet->merge_range('BX2:CI2', 'SMART POSTPAID', $format2);
$worksheet->merge_range('CJ2:CU2', 'TOTAL', $format2);

$worksheet->merge_range('CW2:CZ2', 'HITS', $format2);
$worksheet->merge_range('DA2:DD2', 'OPTOUT', $format2);
$worksheet->merge_range('DF2:DI2', 'MINs in Chikka APN', $format2);

$worksheet->set_column(0,0,9);

$worksheet->set_column(1,5,6);
$worksheet->set_column(6,6,10);
$worksheet->set_column(7,7,6);
$worksheet->set_column(8,8,8);
$worksheet->set_column(9,9,7);
$worksheet->set_column(10,11,6);
$worksheet->set_column(12,12,8);

$worksheet->set_column(13,17,6);
$worksheet->set_column(18,18,10);
$worksheet->set_column(19,19,6);
$worksheet->set_column(20,20,8);
$worksheet->set_column(21,21,7);
$worksheet->set_column(22,23,6);
$worksheet->set_column(24,24,8);

$worksheet->set_column(25,29,6);
$worksheet->set_column(30,30,10);
$worksheet->set_column(31,31,6);
$worksheet->set_column(32,32,8);
$worksheet->set_column(33,33,7);
$worksheet->set_column(34,35,6);
$worksheet->set_column(36,36,8);

$worksheet->set_column(37,41,6);
$worksheet->set_column(42,42,10);
$worksheet->set_column(43,43,6);
$worksheet->set_column(44,44,8);
$worksheet->set_column(45,45,7);
$worksheet->set_column(46,47,6);
$worksheet->set_column(48,48,8);

$worksheet->set_column(49,50,1);

$worksheet->set_column(51,55,6);
$worksheet->set_column(56,56,10);
$worksheet->set_column(57,57,6);
$worksheet->set_column(58,58,8);
$worksheet->set_column(59,59,7);
$worksheet->set_column(60,61,6);
$worksheet->set_column(62,62,8);

$worksheet->set_column(63,67,6);
$worksheet->set_column(68,68,10);
$worksheet->set_column(69,69,6);
$worksheet->set_column(70,70,8);
$worksheet->set_column(71,71,7);
$worksheet->set_column(72,73,6);
$worksheet->set_column(74,74,8);

$worksheet->set_column(75,79,6);
$worksheet->set_column(80,80,10);
$worksheet->set_column(81,81,6);
$worksheet->set_column(82,82,8);
$worksheet->set_column(83,83,7);
$worksheet->set_column(84,85,6);
$worksheet->set_column(86,86,8);

$worksheet->set_column(87,91,6);
$worksheet->set_column(92,92,10);
$worksheet->set_column(93,93,6);
$worksheet->set_column(94,94,8);
$worksheet->set_column(95,95,7);
$worksheet->set_column(96,97,6);
$worksheet->set_column(98,98,8);

$worksheet->set_column(99,99,1);
$worksheet->set_column(100,107,7);

$worksheet->set_column(108,108,1);
$worksheet->set_column(109,109,6);
$worksheet->set_column(110,112,12);

$row = 1;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,     'DATE',       $format);
$worksheet->write($row+$i, $col+1,   'UNLI',       $format);
$worksheet->write($row+$i, $col+2,   'EMAIL',      $format);
$worksheet->write($row+$i, $col+3,   'CHAT',       $format);
$worksheet->write($row+$i, $col+4,   'PHOTO',      $format);
$worksheet->write($row+$i, $col+5,   'SOCIAL',     $format);
$worksheet->write($row+$i, $col+6,   'SPEEDBOOST', $format);
$worksheet->write($row+$i, $col+7,   'LINE',       $format);
$worksheet->write($row+$i, $col+8,   'SNAPCHAT',   $format);
$worksheet->write($row+$i, $col+9,   'TUMBLR',     $format);
$worksheet->write($row+$i, $col+10,  'WAZE',       $format);
$worksheet->write($row+$i, $col+11,  'WeCHAT',     $format);
$worksheet->write($row+$i, $col+12,  'WIKIPEDIA',  $format);
$worksheet->write($row+$i, $col+13,  'UNLI',       $format);
$worksheet->write($row+$i, $col+14,  'EMAIL',      $format);
$worksheet->write($row+$i, $col+15,  'CHAT',       $format);
$worksheet->write($row+$i, $col+16,  'PHOTO',      $format);
$worksheet->write($row+$i, $col+17,  'SOCIAL',     $format);
$worksheet->write($row+$i, $col+18,  'SPEEDBOOST', $format);
$worksheet->write($row+$i, $col+19,  'LINE',       $format);
$worksheet->write($row+$i, $col+20,  'SNAPCHAT',   $format);
$worksheet->write($row+$i, $col+21,  'TUMBLR',     $format);
$worksheet->write($row+$i, $col+22,  'WAZE',       $format);
$worksheet->write($row+$i, $col+23,  'WeCHAT',     $format);
$worksheet->write($row+$i, $col+24,  'WIKIPEDIA',  $format);
$worksheet->write($row+$i, $col+25,  'UNLI',       $format);
$worksheet->write($row+$i, $col+26,  'EMAIL',      $format);
$worksheet->write($row+$i, $col+27,  'CHAT',       $format);
$worksheet->write($row+$i, $col+28,  'PHOTO',      $format);
$worksheet->write($row+$i, $col+29,  'SOCIAL',     $format);
$worksheet->write($row+$i, $col+30,  'SPEEDBOOST', $format);
$worksheet->write($row+$i, $col+31,  'LINE',       $format);
$worksheet->write($row+$i, $col+32,  'SNAPCHAT',   $format);
$worksheet->write($row+$i, $col+33,  'TUMBLR',     $format);
$worksheet->write($row+$i, $col+34,  'WAZE',       $format);
$worksheet->write($row+$i, $col+35,  'WeCHAT',     $format);
$worksheet->write($row+$i, $col+36,  'WIKIPEDIA',  $format);
$worksheet->write($row+$i, $col+37,  'UNLI',       $format);
$worksheet->write($row+$i, $col+38,  'EMAIL',      $format);
$worksheet->write($row+$i, $col+39,  'CHAT',       $format);
$worksheet->write($row+$i, $col+40,  'PHOTO',      $format);
$worksheet->write($row+$i, $col+41,  'SOCIAL',     $format);
$worksheet->write($row+$i, $col+42,  'SPEEDBOOST', $format);
$worksheet->write($row+$i, $col+43,  'LINE',       $format);
$worksheet->write($row+$i, $col+44,  'SNAPCHAT',   $format);
$worksheet->write($row+$i, $col+45,  'TUMBLR',     $format);
$worksheet->write($row+$i, $col+46,  'WAZE',       $format);
$worksheet->write($row+$i, $col+47,  'WeCHAT',     $format);
$worksheet->write($row+$i, $col+48,  'WIKIPEDIA',  $format);

$worksheet->write($row+$i, $col+51,  'UNLI',       $format);
$worksheet->write($row+$i, $col+52,  'EMAIL',      $format);
$worksheet->write($row+$i, $col+53,  'CHAT',       $format);
$worksheet->write($row+$i, $col+54,  'PHOTO',      $format);
$worksheet->write($row+$i, $col+55,  'SOCIAL',     $format);
$worksheet->write($row+$i, $col+56,  'SPEEDBOOST', $format);
$worksheet->write($row+$i, $col+57,  'LINE',       $format);
$worksheet->write($row+$i, $col+58,  'SNAPCHAT',   $format);
$worksheet->write($row+$i, $col+59,  'TUMBLR',     $format);
$worksheet->write($row+$i, $col+60,  'WAZE',       $format);
$worksheet->write($row+$i, $col+61,  'WeCHAT',     $format);
$worksheet->write($row+$i, $col+62,  'WIKIPEDIA',  $format);
$worksheet->write($row+$i, $col+63,  'UNLI',       $format);
$worksheet->write($row+$i, $col+64,  'EMAIL',      $format);
$worksheet->write($row+$i, $col+65,  'CHAT',       $format);
$worksheet->write($row+$i, $col+66,  'PHOTO',      $format);
$worksheet->write($row+$i, $col+67,  'SOCIAL',     $format);
$worksheet->write($row+$i, $col+68,  'SPEEDBOOST', $format);
$worksheet->write($row+$i, $col+69,  'LINE',       $format);
$worksheet->write($row+$i, $col+70,  'SNAPCHAT',   $format);
$worksheet->write($row+$i, $col+71,  'TUMBLR',     $format);
$worksheet->write($row+$i, $col+72,  'WAZE',       $format);
$worksheet->write($row+$i, $col+73,  'WeCHAT',     $format);
$worksheet->write($row+$i, $col+74,  'WIKIPEDIA',  $format);
$worksheet->write($row+$i, $col+75,  'UNLI',       $format);
$worksheet->write($row+$i, $col+76,  'EMAIL',      $format);
$worksheet->write($row+$i, $col+77,  'CHAT',       $format);
$worksheet->write($row+$i, $col+78,  'PHOTO',      $format);
$worksheet->write($row+$i, $col+79,  'SOCIAL',     $format);
$worksheet->write($row+$i, $col+80,  'SPEEDBOOST', $format);
$worksheet->write($row+$i, $col+81,  'LINE',       $format);
$worksheet->write($row+$i, $col+82,  'SNAPCHAT',   $format);
$worksheet->write($row+$i, $col+83,  'TUMBLR',     $format);
$worksheet->write($row+$i, $col+84,  'WAZE',       $format);
$worksheet->write($row+$i, $col+85,  'WeCHAT',     $format);
$worksheet->write($row+$i, $col+86,  'WIKIPEDIA',  $format);
$worksheet->write($row+$i, $col+87,  'UNLI',       $format);
$worksheet->write($row+$i, $col+88,  'EMAIL',      $format);
$worksheet->write($row+$i, $col+89,  'CHAT',       $format);
$worksheet->write($row+$i, $col+90,  'PHOTO',      $format);
$worksheet->write($row+$i, $col+91,  'SOCIAL',     $format);
$worksheet->write($row+$i, $col+92,  'SPEEDBOOST', $format);
$worksheet->write($row+$i, $col+93,  'LINE',       $format);
$worksheet->write($row+$i, $col+94,  'SNAPCHAT',   $format);
$worksheet->write($row+$i, $col+95,  'TUMBLR',     $format);
$worksheet->write($row+$i, $col+96,  'WAZE',       $format);
$worksheet->write($row+$i, $col+97,  'WeCHAT',     $format);
$worksheet->write($row+$i, $col+98,  'WIKIPEDIA',  $format);

$worksheet->write($row+$i, $col+100,  'PREPAID',  $format);
$worksheet->write($row+$i, $col+101,  'TNT',  $format);
$worksheet->write($row+$i, $col+102,  'POSTPAID',  $format);
$worksheet->write($row+$i, $col+103,  'TOTAL',  $format);
$worksheet->write($row+$i, $col+104,  'PREPAID',  $format);
$worksheet->write($row+$i, $col+105,  'TNT',  $format);
$worksheet->write($row+$i, $col+106,  'POSTPAID',  $format);
$worksheet->write($row+$i, $col+107,  'TOTAL',  $format);

$worksheet->write($row+$i, $col+109,  'TOTAL',  $format);
$worksheet->write($row+$i, $col+110,  'Max Concurrent',  $format);
$worksheet->write($row+$i, $col+111,  'TIME',  $format);
$worksheet->write($row+$i, $col+112,  'Avg Concurrent',  $format);

# 1st Query
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),
                      unli_pre, email_pre, chat_pre, photo_pre, social_pre, speed_pre, line_pre, snapchat_pre, tumblr_pre, waze_pre, wechat_pre, wiki_pre,
                      unli_tnt, email_tnt, chat_tnt, photo_tnt, social_tnt, speed_tnt, line_tnt, snapchat_tnt, tumblr_tnt, waze_tnt, wechat_tnt, wiki_tnt,
                      unli_ppd, email_ppd, chat_ppd, photo_ppd, social_ppd, speed_ppd, line_ppd, snapchat_ppd, tumblr_ppd, waze_ppd, wechat_ppd, wiki_ppd,
                      unli_tot, email_tot, chat_tot, photo_tot, social_tot, speed_tot, line_tot, snapchat_tot, tumblr_tot, waze_tot, wechat_tot, wiki_tot
               from powerapp_brand_dailyhits_summary
               where left(tran_dt,7) = '".$current_date."' order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
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
   $worksheet->write($row+$i, $col+25, $rowRst[25], $format1);
   $worksheet->write($row+$i, $col+26, $rowRst[26], $format1);
   $worksheet->write($row+$i, $col+27, $rowRst[27], $format1);
   $worksheet->write($row+$i, $col+28, $rowRst[28], $format1);
   $worksheet->write($row+$i, $col+29, $rowRst[29], $format1);
   $worksheet->write($row+$i, $col+30, $rowRst[30], $format1);
   $worksheet->write($row+$i, $col+31, $rowRst[31], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[32], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[33], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[34], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[35], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[36], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[37], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[38], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[39], $format1);
   $worksheet->write($row+$i, $col+40, $rowRst[40], $format1);
   $worksheet->write($row+$i, $col+41, $rowRst[41], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[42], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[43], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[44], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[45], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[46], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[47], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[48], $format1);
}

$i=1;
# 2nd Query
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),
                      unli_pre, email_pre, chat_pre, photo_pre, social_pre, speed_pre, line_pre, snapchat_pre, tumblr_pre, waze_pre, wechat_pre, wiki_pre,
                      unli_tnt, email_tnt, chat_tnt, photo_tnt, social_tnt, speed_tnt, line_tnt, snapchat_tnt, tumblr_tnt, waze_tnt, wechat_tnt, wiki_tnt,
                      unli_ppd, email_ppd, chat_ppd, photo_ppd, social_ppd, speed_ppd, line_ppd, snapchat_ppd, tumblr_ppd, waze_ppd, wechat_ppd, wiki_ppd,
                      unli_tot, email_tot, chat_tot, photo_tot, social_tot, speed_tot, line_tot, snapchat_tot, tumblr_tot, waze_tot, wechat_tot, wiki_tot
               from powerapp_brand_dailyuniq_summary
               where left(tran_dt,7) = '".$current_date."' order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col+51,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+52,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+53,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+54,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+55,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+56,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+57,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+58,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+59,  $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+60, $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+61, $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+62, $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+63, $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+64, $rowRst[14], $format1);
   $worksheet->write($row+$i, $col+65, $rowRst[15], $format1);
   $worksheet->write($row+$i, $col+66, $rowRst[16], $format1);
   $worksheet->write($row+$i, $col+67, $rowRst[17], $format1s);
   $worksheet->write($row+$i, $col+68, $rowRst[18], $format1);
   $worksheet->write($row+$i, $col+69, $rowRst[19], $format1);
   $worksheet->write($row+$i, $col+70, $rowRst[20], $format1);
   $worksheet->write($row+$i, $col+71, $rowRst[21], $format1);
   $worksheet->write($row+$i, $col+72, $rowRst[22], $format1);
   $worksheet->write($row+$i, $col+73, $rowRst[23], $format1);
   $worksheet->write($row+$i, $col+74, $rowRst[24], $format1);
   $worksheet->write($row+$i, $col+75, $rowRst[25], $format1);
   $worksheet->write($row+$i, $col+76, $rowRst[26], $format1);
   $worksheet->write($row+$i, $col+77, $rowRst[27], $format1);
   $worksheet->write($row+$i, $col+78, $rowRst[28], $format1);
   $worksheet->write($row+$i, $col+79, $rowRst[29], $format1);
   $worksheet->write($row+$i, $col+80, $rowRst[30], $format1);
   $worksheet->write($row+$i, $col+81, $rowRst[31], $format1);
   $worksheet->write($row+$i, $col+82, $rowRst[32], $format1);
   $worksheet->write($row+$i, $col+83, $rowRst[33], $format1);
   $worksheet->write($row+$i, $col+84, $rowRst[34], $format1);
   $worksheet->write($row+$i, $col+85, $rowRst[35], $format1);
   $worksheet->write($row+$i, $col+86, $rowRst[36], $format1);
   $worksheet->write($row+$i, $col+87, $rowRst[37], $format1);
   $worksheet->write($row+$i, $col+88, $rowRst[38], $format1);
   $worksheet->write($row+$i, $col+89, $rowRst[39], $format1);
   $worksheet->write($row+$i, $col+90, $rowRst[40], $format1);
   $worksheet->write($row+$i, $col+91, $rowRst[41], $format1);
   $worksheet->write($row+$i, $col+92, $rowRst[42], $format1);
   $worksheet->write($row+$i, $col+93, $rowRst[43], $format1);
   $worksheet->write($row+$i, $col+94, $rowRst[44], $format1);
   $worksheet->write($row+$i, $col+95, $rowRst[45], $format1);
   $worksheet->write($row+$i, $col+96, $rowRst[46], $format1);
   $worksheet->write($row+$i, $col+97, $rowRst[47], $format1);
   $worksheet->write($row+$i, $col+98, $rowRst[48], $format1);
}

$i=1;
# 3rd Query
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),
                      hits_pre, hits_tnt, hits_ppd, hits_tot, 
                      optout_pre, optout_tnt, optout_ppd, optout_tot
               from powerapp_brand_daily_hits_optout_summary
               where left(tran_dt,7) = '".$current_date."' order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col+100,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+101,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+102,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+103,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+104,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+105,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+106,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+107,  $rowRst[8],  $format1);
}

$i=1;
# 4th Query
$strSQLhi10 = "select DATE_FORMAT(a.tran_dt,'%m/%d/%Y'), IFNULL(b.num_subs,0), a.concurrent_max_subs, a.concurrent_max_tm, a.concurrent_avg_subs 
               from powerapp_dailyrep a left outer join powerapp_concurrent_subs b on a.tran_dt = b.tran_dt 
               where left(a.tran_dt,7) = '".$current_date."' order by a.tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col+109,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+110,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+111,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+112,  $rowRst[4],  $format1);
}

$workbook->close();
 binmode STDOUT;

$from = "do-not-reply\@chikka.com";
$to = "glenon\@chikka.com";
$cc = "glenon\@chikka.com";
$Subject = "PowerApp Stats per Brand, ".$current_day;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp Stats per Brand for the Month of $txt_month.</span></span></p>
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

