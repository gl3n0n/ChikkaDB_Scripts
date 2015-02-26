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

# 1st worksheet
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

$format2 = $workbook->add_format(bg_color => 'green'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('11');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(2);

$format3 = $workbook->add_format(bg_color => 'cyan'); # Add a format
$format3->set_bold();
$format3->set_font('Calibri');
$format3->set_size('11');
$format3->set_color('black');
$format3->set_align('center');
$format3->set_border(2);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B1:BM1', ' H  I  T  S     p e r     P  A  C  K  A  G  E', $format2);
$worksheet->merge_range('BP1:EA1', 'U  N    I  Q  U  E      U  S  E  R  S', $format2);
$worksheet->merge_range('EC1:EJ1', 'Hits & Optout Per Day', $format2);
$worksheet->merge_range('EL1:EO1', '', $format2);

$worksheet->merge_range('B2:Q2', 'SMART PREPAID', $format3);
$worksheet->merge_range('R2:AG2', 'TNT', $format3);
$worksheet->merge_range('AH2:AW2', 'SMART POSTPAID', $format3);
$worksheet->merge_range('AX2:BM2', 'TOTAL', $format3);

$worksheet->merge_range('BP2:CE2', 'SMART PREPAID', $format3);
$worksheet->merge_range('CF2:CU2', 'TNT', $format3);
$worksheet->merge_range('CV2:DK2', 'SMART POSTPAID', $format3);
$worksheet->merge_range('DL2:EA2', 'TOTAL', $format3);

$worksheet->merge_range('EC2:EF2', 'HITS', $format3);
$worksheet->merge_range('EG2:EJ2', 'OPTOUT', $format3);
$worksheet->merge_range('EL2:EO2', 'MINs in Chikka APN', $format3);

$worksheet->set_column(0,0,9);

$worksheet->set_column(1,5,6);
$worksheet->set_column(6,6,10);
$worksheet->set_column(7,7,6);
$worksheet->set_column(8,8,8);
$worksheet->set_column(9,9,7);
$worksheet->set_column(10,11,7);
$worksheet->set_column(12,15,9);
$worksheet->set_column(16,16,13);

$worksheet->set_column(17,21,6);
$worksheet->set_column(22,22,10);
$worksheet->set_column(23,27,7);
$worksheet->set_column(28,31,9);
$worksheet->set_column(32,32,13);

$worksheet->set_column(33,37,6);
$worksheet->set_column(38,38,10);
$worksheet->set_column(39,43,7);
$worksheet->set_column(44,47,9);
$worksheet->set_column(48,48,13);

$worksheet->set_column(49,53,6);
$worksheet->set_column(54,54,10);
$worksheet->set_column(55,59,7);
$worksheet->set_column(60,63,9);
$worksheet->set_column(64,64,13);

$worksheet->set_column(65,66,1);

$worksheet->set_column(67,71,6);
$worksheet->set_column(72,72,10);
$worksheet->set_column(73,77,7);
$worksheet->set_column(78,81,9);
$worksheet->set_column(82,82,13);

$worksheet->set_column(83,87,6);
$worksheet->set_column(88,88,10);
$worksheet->set_column(89,93,7);
$worksheet->set_column(94,97,9);
$worksheet->set_column(98,98,13);

$worksheet->set_column(99,103,6);
$worksheet->set_column(104,104,10);
$worksheet->set_column(105,109,7);
$worksheet->set_column(110,113,9);
$worksheet->set_column(114,114,13);

$worksheet->set_column(115,119,6);
$worksheet->set_column(120,120,10);
$worksheet->set_column(121,125,7);
$worksheet->set_column(126,129,9);
$worksheet->set_column(130,130,13);

$worksheet->set_column(131,131,1);
$worksheet->set_column(132,139,7);

$worksheet->set_column(140,140,1);
$worksheet->set_column(141,141,7);
$worksheet->set_column(142,142,12);
$worksheet->set_column(143,143,7);
$worksheet->set_column(144,144,12);

$row = 1;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,     'DATE',           $format);
$worksheet->write($row+$i, $col+1,   'UNLI',           $format);
$worksheet->write($row+$i, $col+2,   'EMAIL',          $format);
$worksheet->write($row+$i, $col+3,   'CHAT',           $format);
$worksheet->write($row+$i, $col+4,   'PHOTO',          $format);
$worksheet->write($row+$i, $col+5,   'SOCIAL',         $format);
$worksheet->write($row+$i, $col+6,   'SPEEDBOOST',     $format);
$worksheet->write($row+$i, $col+7,   'LINE',           $format);
$worksheet->write($row+$i, $col+8,   'SNAPCHAT',       $format);
$worksheet->write($row+$i, $col+9,   'TUMBLR',         $format);
$worksheet->write($row+$i, $col+10,  'WAZE',           $format);
$worksheet->write($row+$i, $col+11,  'WeCHAT',         $format);
$worksheet->write($row+$i, $col+12,  'FACEBOOK',       $format);
$worksheet->write($row+$i, $col+13,  'WIKIPEDIA',      $format);
$worksheet->write($row+$i, $col+14,  'FREE SOCIAL',    $format);
$worksheet->write($row+$i, $col+15,  'PISONET',        $format);
$worksheet->write($row+$i, $col+16,  'BACK-TO-SCHOOL', $format);

$worksheet->write($row+$i, $col+17,  'UNLI',           $format);
$worksheet->write($row+$i, $col+18,  'EMAIL',          $format);
$worksheet->write($row+$i, $col+19,  'CHAT',           $format);
$worksheet->write($row+$i, $col+20,  'PHOTO',          $format);
$worksheet->write($row+$i, $col+21,  'SOCIAL',         $format);
$worksheet->write($row+$i, $col+22,  'SPEEDBOOST',     $format);
$worksheet->write($row+$i, $col+23,  'LINE',           $format);
$worksheet->write($row+$i, $col+24,  'SNAPCHAT',       $format);
$worksheet->write($row+$i, $col+25,  'TUMBLR',         $format);
$worksheet->write($row+$i, $col+26,  'WAZE',           $format);
$worksheet->write($row+$i, $col+27,  'WeCHAT',         $format);
$worksheet->write($row+$i, $col+28,  'FACEBOOK',       $format);
$worksheet->write($row+$i, $col+29,  'WIKIPEDIA',      $format);
$worksheet->write($row+$i, $col+30,  'FREE SOCIAL',    $format);
$worksheet->write($row+$i, $col+31,  'PISONET',        $format);
$worksheet->write($row+$i, $col+32,  'BACK-TO-SCHOOL', $format);

$worksheet->write($row+$i, $col+33,  'UNLI',           $format);
$worksheet->write($row+$i, $col+34,  'EMAIL',          $format);
$worksheet->write($row+$i, $col+35,  'CHAT',           $format);
$worksheet->write($row+$i, $col+36,  'PHOTO',          $format);
$worksheet->write($row+$i, $col+37,  'SOCIAL',         $format);
$worksheet->write($row+$i, $col+38,  'SPEEDBOOST',     $format);
$worksheet->write($row+$i, $col+39,  'LINE',           $format);
$worksheet->write($row+$i, $col+40,  'SNAPCHAT',       $format);
$worksheet->write($row+$i, $col+41,  'TUMBLR',         $format);
$worksheet->write($row+$i, $col+42,  'WAZE',           $format);
$worksheet->write($row+$i, $col+43,  'WeCHAT',         $format);
$worksheet->write($row+$i, $col+44,  'FACEBOOK',       $format);
$worksheet->write($row+$i, $col+45,  'WIKIPEDIA',      $format);
$worksheet->write($row+$i, $col+46,  'FREE SOCIAL',    $format);
$worksheet->write($row+$i, $col+47,  'PISONET',        $format);
$worksheet->write($row+$i, $col+48,  'BACK-TO-SCHOOL', $format);

$worksheet->write($row+$i, $col+49,  'UNLI',           $format);
$worksheet->write($row+$i, $col+50,  'EMAIL',          $format);
$worksheet->write($row+$i, $col+51,  'CHAT',           $format);
$worksheet->write($row+$i, $col+52,  'PHOTO',          $format);
$worksheet->write($row+$i, $col+53,  'SOCIAL',         $format);
$worksheet->write($row+$i, $col+54,  'SPEEDBOOST',     $format);
$worksheet->write($row+$i, $col+55,  'LINE',           $format);
$worksheet->write($row+$i, $col+56,  'SNAPCHAT',       $format);
$worksheet->write($row+$i, $col+57,  'TUMBLR',         $format);
$worksheet->write($row+$i, $col+58,  'WAZE',           $format);
$worksheet->write($row+$i, $col+59,  'WeCHAT',         $format);
$worksheet->write($row+$i, $col+60,  'FACEBOOK',       $format);
$worksheet->write($row+$i, $col+61,  'WIKIPEDIA',      $format);
$worksheet->write($row+$i, $col+62,  'FREE SOCIAL',    $format);
$worksheet->write($row+$i, $col+63,  'PISONET',        $format);
$worksheet->write($row+$i, $col+64,  'BACK-TO-SCHOOL', $format);

$worksheet->write($row+$i, $col+67,  'UNLI',          $format);
$worksheet->write($row+$i, $col+68,  'EMAIL',         $format);
$worksheet->write($row+$i, $col+69,  'CHAT',          $format);
$worksheet->write($row+$i, $col+70,  'PHOTO',         $format);
$worksheet->write($row+$i, $col+71,  'SOCIAL',        $format);
$worksheet->write($row+$i, $col+72,  'SPEEDBOOST',    $format);
$worksheet->write($row+$i, $col+73,  'LINE',          $format);
$worksheet->write($row+$i, $col+74,  'SNAPCHAT',      $format);
$worksheet->write($row+$i, $col+75,  'TUMBLR',        $format);
$worksheet->write($row+$i, $col+76,  'WAZE',          $format);
$worksheet->write($row+$i, $col+77,  'WeCHAT',        $format);
$worksheet->write($row+$i, $col+78,  'FACEBOOK',      $format);
$worksheet->write($row+$i, $col+79,  'WIKIPEDIA',     $format);
$worksheet->write($row+$i, $col+80,  'FREE SOCIAL',   $format);
$worksheet->write($row+$i, $col+81,  'PISONET',       $format);
$worksheet->write($row+$i, $col+82,  'BACK-TO-SCHOOL',$format);

$worksheet->write($row+$i, $col+83,  'UNLI',          $format);
$worksheet->write($row+$i, $col+84,  'EMAIL',         $format);
$worksheet->write($row+$i, $col+85,  'CHAT',          $format);
$worksheet->write($row+$i, $col+86,  'PHOTO',         $format);
$worksheet->write($row+$i, $col+87,  'SOCIAL',        $format);
$worksheet->write($row+$i, $col+88,  'SPEEDBOOST',    $format);
$worksheet->write($row+$i, $col+89,  'LINE',          $format);
$worksheet->write($row+$i, $col+90,  'SNAPCHAT',      $format);
$worksheet->write($row+$i, $col+91,  'TUMBLR',        $format);
$worksheet->write($row+$i, $col+92,  'WAZE',          $format);
$worksheet->write($row+$i, $col+93,  'WeCHAT',        $format);
$worksheet->write($row+$i, $col+94,  'FACEBOOK',      $format);
$worksheet->write($row+$i, $col+95,  'WIKIPEDIA',     $format);
$worksheet->write($row+$i, $col+96,  'FREE SOCIAL',   $format);
$worksheet->write($row+$i, $col+97,  'PISONET',       $format);
$worksheet->write($row+$i, $col+98,  'BACK-TO-SCHOOL',$format);
                                 
$worksheet->write($row+$i, $col+99,  'UNLI',          $format);
$worksheet->write($row+$i, $col+100, 'EMAIL',         $format);
$worksheet->write($row+$i, $col+101, 'CHAT',          $format);
$worksheet->write($row+$i, $col+102, 'PHOTO',         $format);
$worksheet->write($row+$i, $col+103, 'SOCIAL',        $format);
$worksheet->write($row+$i, $col+104, 'SPEEDBOOST',    $format);
$worksheet->write($row+$i, $col+105, 'LINE',          $format);
$worksheet->write($row+$i, $col+106, 'SNAPCHAT',      $format);
$worksheet->write($row+$i, $col+107, 'TUMBLR',        $format);
$worksheet->write($row+$i, $col+108, 'WAZE',          $format);
$worksheet->write($row+$i, $col+109, 'WeCHAT',        $format);
$worksheet->write($row+$i, $col+110, 'FACEBOOK',      $format);
$worksheet->write($row+$i, $col+111, 'WIKIPEDIA',     $format);
$worksheet->write($row+$i, $col+112, 'FREE SOCIAL',   $format);
$worksheet->write($row+$i, $col+113, 'PISONET',       $format);
$worksheet->write($row+$i, $col+114, 'BACK-TO-SCHOOL',$format);

$worksheet->write($row+$i, $col+115, 'UNLI',          $format);
$worksheet->write($row+$i, $col+116, 'EMAIL',         $format);
$worksheet->write($row+$i, $col+117, 'CHAT',          $format);
$worksheet->write($row+$i, $col+118, 'PHOTO',         $format);
$worksheet->write($row+$i, $col+119, 'SOCIAL',        $format);
$worksheet->write($row+$i, $col+120, 'SPEEDBOOST',    $format);
$worksheet->write($row+$i, $col+121, 'LINE',          $format);
$worksheet->write($row+$i, $col+122, 'SNAPCHAT',      $format);
$worksheet->write($row+$i, $col+123, 'TUMBLR',        $format);
$worksheet->write($row+$i, $col+124, 'WAZE',          $format);
$worksheet->write($row+$i, $col+125, 'WeCHAT',        $format);
$worksheet->write($row+$i, $col+126, 'FACEBOOK',      $format);
$worksheet->write($row+$i, $col+127, 'WIKIPEDIA',     $format);
$worksheet->write($row+$i, $col+128, 'FREE SOCIAL',   $format);
$worksheet->write($row+$i, $col+129, 'PISONET',       $format);
$worksheet->write($row+$i, $col+130, 'BACK-TO-SCHOOL',$format);

$worksheet->write($row+$i, $col+132,  'PREPAID',      $format);
$worksheet->write($row+$i, $col+133,  'TNT',          $format);
$worksheet->write($row+$i, $col+134,  'POSTPAID',     $format);
$worksheet->write($row+$i, $col+135,  'TOTAL',        $format);
$worksheet->write($row+$i, $col+136,  'PREPAID',      $format);
$worksheet->write($row+$i, $col+137,  'TNT',          $format);
$worksheet->write($row+$i, $col+138,  'POSTPAID',     $format);
$worksheet->write($row+$i, $col+139,  'TOTAL',        $format);
                                  
$worksheet->write($row+$i, $col+141,  'TOTAL',           $format);
$worksheet->write($row+$i, $col+142,  'Max Concurrent',  $format);
$worksheet->write($row+$i, $col+143,  'TIME',            $format);
$worksheet->write($row+$i, $col+144,  'Avg Concurrent',  $format);

# 1st Query
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),
                      unli_pre, email_pre, chat_pre, photo_pre, social_pre, speed_pre, line_pre, snapchat_pre, tumblr_pre, waze_pre, wechat_pre, facebook_pre, wiki_pre, free_social_pre, pisonet_pre, school_pre,
                      unli_tnt, email_tnt, chat_tnt, photo_tnt, social_tnt, speed_tnt, line_tnt, snapchat_tnt, tumblr_tnt, waze_tnt, wechat_tnt, facebook_tnt, wiki_tnt, free_social_tnt, pisonet_tnt, school_tnt,
                      unli_ppd, email_ppd, chat_ppd, photo_ppd, social_ppd, speed_ppd, line_ppd, snapchat_ppd, tumblr_ppd, waze_ppd, wechat_ppd, facebook_ppd, wiki_ppd, free_social_ppd, pisonet_ppd, school_ppd,
                      unli_tot, email_tot, chat_tot, photo_tot, social_tot, speed_tot, line_tot, snapchat_tot, tumblr_tot, waze_tot, wechat_tot, facebook_tot, wiki_tot, free_social_tot, pisonet_tot, school_tot
               from powerapp_brand_dailyhits_summary                                                                                           
               where left(tran_dt,7) = '".$current_date."' order by tran_dt";                                                                  
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);                                                                                                  
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,      $rowRst[0],  $format1);
   $worksheet->write($row+$i, $col+1,    $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+2,    $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+3,    $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+4,    $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+5,    $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+6,    $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+7,    $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+8,    $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+9,    $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+10,   $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+11,   $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+12,   $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+13,   $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+14,   $rowRst[14], $format1);
   $worksheet->write($row+$i, $col+15,   $rowRst[15], $format1);
   $worksheet->write($row+$i, $col+16,   $rowRst[16], $format1);
   $worksheet->write($row+$i, $col+17,   $rowRst[17], $format1);
   $worksheet->write($row+$i, $col+18,   $rowRst[18], $format1);
   $worksheet->write($row+$i, $col+19,   $rowRst[19], $format1);
   $worksheet->write($row+$i, $col+20,   $rowRst[20], $format1);
   $worksheet->write($row+$i, $col+21,   $rowRst[21], $format1);
   $worksheet->write($row+$i, $col+22,   $rowRst[22], $format1);
   $worksheet->write($row+$i, $col+23,   $rowRst[23], $format1);
   $worksheet->write($row+$i, $col+24,   $rowRst[24], $format1);
   $worksheet->write($row+$i, $col+25,   $rowRst[25], $format1);
   $worksheet->write($row+$i, $col+26,   $rowRst[26], $format1);
   $worksheet->write($row+$i, $col+27,   $rowRst[27], $format1);
   $worksheet->write($row+$i, $col+28,   $rowRst[28], $format1);
   $worksheet->write($row+$i, $col+29,   $rowRst[29], $format1);
   $worksheet->write($row+$i, $col+30,   $rowRst[30], $format1);
   $worksheet->write($row+$i, $col+31,   $rowRst[31], $format1);
   $worksheet->write($row+$i, $col+32,   $rowRst[32], $format1);
   $worksheet->write($row+$i, $col+33,   $rowRst[33], $format1);
   $worksheet->write($row+$i, $col+34,   $rowRst[34], $format1);
   $worksheet->write($row+$i, $col+35,   $rowRst[35], $format1);
   $worksheet->write($row+$i, $col+36,   $rowRst[36], $format1);
   $worksheet->write($row+$i, $col+37,   $rowRst[37], $format1);
   $worksheet->write($row+$i, $col+38,   $rowRst[38], $format1);
   $worksheet->write($row+$i, $col+39,   $rowRst[39], $format1);
   $worksheet->write($row+$i, $col+40,   $rowRst[40], $format1);
   $worksheet->write($row+$i, $col+41,   $rowRst[41], $format1);
   $worksheet->write($row+$i, $col+42,   $rowRst[42], $format1);
   $worksheet->write($row+$i, $col+43,   $rowRst[43], $format1);
   $worksheet->write($row+$i, $col+44,   $rowRst[44], $format1);
   $worksheet->write($row+$i, $col+45,   $rowRst[45], $format1);
   $worksheet->write($row+$i, $col+46,   $rowRst[46], $format1);
   $worksheet->write($row+$i, $col+47,   $rowRst[47], $format1);
   $worksheet->write($row+$i, $col+48,   $rowRst[48], $format1);
   $worksheet->write($row+$i, $col+49,   $rowRst[49], $format1);
   $worksheet->write($row+$i, $col+50,   $rowRst[50], $format1);
   $worksheet->write($row+$i, $col+51,   $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+52,   $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+53,   $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+54,   $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+55,   $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+56,   $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+57,   $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+58,   $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+59,   $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+60,   $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+61,   $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+62,   $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+63,   $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+64,   $rowRst[64], $format1);
}

$i=1;
# 2nd Query
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),
                      unli_pre, email_pre, chat_pre, photo_pre, social_pre, speed_pre, line_pre, snapchat_pre, tumblr_pre, waze_pre, wechat_pre, facebook_pre, wiki_pre, free_social_pre, pisonet_pre, school_pre,
                      unli_tnt, email_tnt, chat_tnt, photo_tnt, social_tnt, speed_tnt, line_tnt, snapchat_tnt, tumblr_tnt, waze_tnt, wechat_tnt, facebook_tnt, wiki_tnt, free_social_tnt, pisonet_tnt, school_tnt,
                      unli_ppd, email_ppd, chat_ppd, photo_ppd, social_ppd, speed_ppd, line_ppd, snapchat_ppd, tumblr_ppd, waze_ppd, wechat_ppd, facebook_ppd, wiki_ppd, free_social_ppd, pisonet_ppd, school_ppd,
                      unli_tot, email_tot, chat_tot, photo_tot, social_tot, speed_tot, line_tot, snapchat_tot, tumblr_tot, waze_tot, wechat_tot, facebook_tot, wiki_tot, free_social_tot, pisonet_tot, school_tot 
               from powerapp_brand_dailyuniq_summary
               where left(tran_dt,7) = '".$current_date."' order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col+67,   $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+68,   $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+69,   $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+70,   $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+71,   $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+72,   $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+73,   $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+74,   $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+75,   $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+76,   $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+77,   $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+78,   $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+79,   $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+80,   $rowRst[14], $format1);
   $worksheet->write($row+$i, $col+81,   $rowRst[15], $format1);
   $worksheet->write($row+$i, $col+82,   $rowRst[16], $format1);
   $worksheet->write($row+$i, $col+83,   $rowRst[17], $format1);
   $worksheet->write($row+$i, $col+84,   $rowRst[18], $format1);
   $worksheet->write($row+$i, $col+85,   $rowRst[19], $format1);
   $worksheet->write($row+$i, $col+86,   $rowRst[20], $format1);
   $worksheet->write($row+$i, $col+87,   $rowRst[21], $format1);
   $worksheet->write($row+$i, $col+88,   $rowRst[22], $format1);
   $worksheet->write($row+$i, $col+89,   $rowRst[23], $format1);
   $worksheet->write($row+$i, $col+90,   $rowRst[24], $format1);
   $worksheet->write($row+$i, $col+91,   $rowRst[25], $format1);
   $worksheet->write($row+$i, $col+92,   $rowRst[26], $format1);
   $worksheet->write($row+$i, $col+93,   $rowRst[27], $format1);
   $worksheet->write($row+$i, $col+94,   $rowRst[28], $format1);
   $worksheet->write($row+$i, $col+95,   $rowRst[29], $format1);
   $worksheet->write($row+$i, $col+96,   $rowRst[30], $format1);
   $worksheet->write($row+$i, $col+97,   $rowRst[31], $format1);
   $worksheet->write($row+$i, $col+98,   $rowRst[32], $format1);
   $worksheet->write($row+$i, $col+99,   $rowRst[33], $format1);
   $worksheet->write($row+$i, $col+100,  $rowRst[34], $format1);
   $worksheet->write($row+$i, $col+101,  $rowRst[35], $format1);
   $worksheet->write($row+$i, $col+102,  $rowRst[36], $format1);
   $worksheet->write($row+$i, $col+103,  $rowRst[37], $format1);
   $worksheet->write($row+$i, $col+104,  $rowRst[38], $format1);
   $worksheet->write($row+$i, $col+105,  $rowRst[39], $format1);
   $worksheet->write($row+$i, $col+106,  $rowRst[40], $format1);
   $worksheet->write($row+$i, $col+107,  $rowRst[41], $format1);
   $worksheet->write($row+$i, $col+108,  $rowRst[42], $format1);
   $worksheet->write($row+$i, $col+109,  $rowRst[43], $format1);
   $worksheet->write($row+$i, $col+110,  $rowRst[44], $format1);
   $worksheet->write($row+$i, $col+111,  $rowRst[45], $format1);
   $worksheet->write($row+$i, $col+112,  $rowRst[46], $format1);
   $worksheet->write($row+$i, $col+113,  $rowRst[47], $format1);
   $worksheet->write($row+$i, $col+114,  $rowRst[48], $format1);
   $worksheet->write($row+$i, $col+115,  $rowRst[49], $format1);
   $worksheet->write($row+$i, $col+116,  $rowRst[50], $format1);
   $worksheet->write($row+$i, $col+117,  $rowRst[51], $format1);
   $worksheet->write($row+$i, $col+118,  $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+119,  $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+120,  $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+121,  $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+122,  $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+123,  $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+124,  $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+125,  $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+126,  $rowRst[60], $format1);
   $worksheet->write($row+$i, $col+127,  $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+128,  $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+129,  $rowRst[63], $format1);
   $worksheet->write($row+$i, $col+130,  $rowRst[64], $format1);
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
   $worksheet->write($row+$i, $col+132,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+133,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+134,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+135,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+136,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+137,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+138,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+139,  $rowRst[8],  $format1);
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
   $worksheet->write($row+$i, $col+141,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+142,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+143,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+144,  $rowRst[4],  $format1);
}









# 2nd worksheet
$worksheet = $workbook->add_worksheet($txt_month."-HITS");

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

$format21R = $workbook->add_format(bg_color => 'silver'); # Add a format
$format21R->set_bold();
$format21R->set_font('Calibri');
$format21R->set_size('11');
$format21R->set_color('black');
$format21R->set_align('center');
$format21R->set_border(2);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B1:J1', 'CHAT', $format2);
$worksheet->merge_range('L1:T1', 'EMAIL', $format2);
$worksheet->merge_range('V1:AD1', 'PHOTO', $format2);
$worksheet->merge_range('AF1:AN1', 'UNLI', $format2);
$worksheet->merge_range('AP1:AR1', 'BOOST', $format2);
$worksheet->merge_range('AT1:BB1', 'SOCIAL', $format2);
$worksheet->merge_range('BD1:BF1', 'LINE', $format2);
$worksheet->merge_range('BH1:BJ1', 'SNAPCHAT', $format2);
$worksheet->merge_range('BL1:BN1', 'TUMBLR', $format2);
$worksheet->merge_range('BP1:BR1', 'WAZE', $format2);
$worksheet->merge_range('BT1:BV1', 'WeCHAT', $format2);
$worksheet->merge_range('BX1:BZ1', 'FACEBOOK', $format2);
$worksheet->merge_range('CB1:CD1', 'WIKIPEDIA', $format2);
$worksheet->merge_range('CF1:CH1', 'FREE SOCIAL', $format2);
$worksheet->merge_range('CJ1:CL1', 'PISONET', $format2);
$worksheet->merge_range('CN1:CP1', 'BACK-TO-SCHOOL', $format2);

$worksheet->merge_range('B2:D2', 'SMART PREPAID', $format2);
$worksheet->merge_range('E2:G2', 'TNT', $format2);
$worksheet->merge_range('H2:J2', 'SMART POSTPAID', $format2);
$worksheet->merge_range('L2:N2', 'SMART PREPAID', $format2);
$worksheet->merge_range('O2:Q2', 'TNT', $format2);
$worksheet->merge_range('R2:T2', 'SMART POSTPAID', $format2);
$worksheet->merge_range('V2:X2', 'SMART PREPAID', $format2);
$worksheet->merge_range('Y2:AA2', 'TNT', $format2);
$worksheet->merge_range('AB2:AD2', 'SMART POSTPAID', $format2);
$worksheet->merge_range('AF2:AH2', 'SMART PREPAID', $format2);
$worksheet->merge_range('AI2:AK2', 'TNT', $format2);
$worksheet->merge_range('AL2:AN2', 'SMART POSTPAID', $format2);
$worksheet->write(1, 41, 'SMART PREPAID', $format21R);
$worksheet->write(1, 42, 'TNT', $format21R);
$worksheet->write(1, 43, 'SMART POSTPAID', $format21R);

$worksheet->merge_range('AT2:AV2', 'SMART PREPAID', $format2);
$worksheet->merge_range('AW2:AY2', 'TNT', $format2);
$worksheet->merge_range('AZ2:BB2', 'SMART POSTPAID', $format2);

$worksheet->write(1, 55, 'SMART PREPAID', $format21R);
$worksheet->write(1, 56, 'TNT', $format21R);
$worksheet->write(1, 57, 'SMART POSTPAID', $format21R);
$worksheet->write(1, 59, 'SMART PREPAID', $format21R);
$worksheet->write(1, 60, 'TNT', $format21R);
$worksheet->write(1, 61, 'SMART POSTPAID', $format21R);
$worksheet->write(1, 63, 'SMART PREPAID', $format21R);
$worksheet->write(1, 64, 'TNT', $format21R);
$worksheet->write(1, 65, 'SMART POSTPAID', $format21R);
$worksheet->write(1, 67, 'SMART PREPAID', $format21R);
$worksheet->write(1, 68, 'TNT', $format21R);
$worksheet->write(1, 69, 'SMART POSTPAID', $format21R);
$worksheet->write(1, 71, 'SMART PREPAID', $format21R);
$worksheet->write(1, 72, 'TNT', $format21R);
$worksheet->write(1, 73, 'SMART POSTPAID', $format21R);
$worksheet->write(1, 75, 'SMART PREPAID', $format21R);
$worksheet->write(1, 76, 'TNT', $format21R);
$worksheet->write(1, 77, 'SMART POSTPAID', $format21R);
$worksheet->write(1, 79, 'SMART PREPAID', $format21R);
$worksheet->write(1, 80, 'TNT', $format21R);
$worksheet->write(1, 81, 'SMART POSTPAID', $format21R);
$worksheet->write(1, 83, 'SMART PREPAID', $format21R);
$worksheet->write(1, 84, 'TNT', $format21R);
$worksheet->write(1, 85, 'SMART POSTPAID', $format21R);
$worksheet->write(1, 87, 'SMART PREPAID', $format21R);
$worksheet->write(1, 88, 'TNT', $format21R);
$worksheet->write(1, 89, 'SMART POSTPAID', $format21R);
$worksheet->write(1, 91, 'SMART PREPAID', $format21R);
$worksheet->write(1, 92, 'TNT', $format21R);
$worksheet->write(1, 93, 'SMART POSTPAID', $format21R);

$worksheet->set_column(0,0,9);
$worksheet->set_column(1,9,6);
$worksheet->set_column(10,10,1);
$worksheet->set_column(11,19,6);
$worksheet->set_column(20,20,1);
$worksheet->set_column(21,29,6);
$worksheet->set_column(30,30,1);
$worksheet->set_column(31,39,6);
$worksheet->set_column(40,40,1);
$worksheet->set_column(41,41,15);
$worksheet->set_column(42,42,8);
$worksheet->set_column(43,43,16);
$worksheet->set_column(44,44,1);
$worksheet->set_column(45,53,6);

$worksheet->set_column(54,54,1);
$worksheet->set_column(55,55,15);
$worksheet->set_column(56,56,8);
$worksheet->set_column(57,57,16);
$worksheet->set_column(58,58,1);
$worksheet->set_column(59,59,15);
$worksheet->set_column(60,60,8);
$worksheet->set_column(61,61,16);
$worksheet->set_column(62,62,1);
$worksheet->set_column(63,63,15);
$worksheet->set_column(64,64,8);
$worksheet->set_column(65,65,16);
$worksheet->set_column(66,66,1);
$worksheet->set_column(67,67,15);
$worksheet->set_column(68,68,8);
$worksheet->set_column(69,69,16);
$worksheet->set_column(70,70,1);
$worksheet->set_column(71,71,15);
$worksheet->set_column(72,72,8);
$worksheet->set_column(73,73,16);
$worksheet->set_column(74,74,1);
$worksheet->set_column(75,75,15);
$worksheet->set_column(76,76,8);
$worksheet->set_column(77,77,16);

$worksheet->set_column(78,78,1);
$worksheet->set_column(79,79,15);
$worksheet->set_column(80,80,8);
$worksheet->set_column(81,81,16);
$worksheet->set_column(82,82,1);
$worksheet->set_column(83,83,15);
$worksheet->set_column(84,84,8);
$worksheet->set_column(85,85,16);
$worksheet->set_column(86,86,1);
$worksheet->set_column(87,87,15);
$worksheet->set_column(88,88,8);
$worksheet->set_column(89,89,16);
$worksheet->set_column(90,90,1);
$worksheet->set_column(91,91,15);
$worksheet->set_column(92,92,8);
$worksheet->set_column(93,93,16);

$row = 1;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,      'DATE',       $format);
$worksheet->write($row+$i, $col+1,    '3hours',     $format);
$worksheet->write($row+$i, $col+2,    '24hours',    $format);
$worksheet->write($row+$i, $col+3,    'TOTAL',      $format);
$worksheet->write($row+$i, $col+4,    '3hours',     $format);
$worksheet->write($row+$i, $col+5,    '24hours',    $format);
$worksheet->write($row+$i, $col+6,    'TOTAL',      $format);
$worksheet->write($row+$i, $col+7,    '3hours',     $format);
$worksheet->write($row+$i, $col+8,    '24hours',    $format);
$worksheet->write($row+$i, $col+9,    'TOTAL',      $format);
$worksheet->write($row+$i, $col+11,   '3hours',     $format);
$worksheet->write($row+$i, $col+12,   '24hours',    $format);
$worksheet->write($row+$i, $col+13,   'TOTAL',      $format);
$worksheet->write($row+$i, $col+14,   '3hours',     $format);
$worksheet->write($row+$i, $col+15,   '24hours',    $format);
$worksheet->write($row+$i, $col+16,   'TOTAL',      $format);
$worksheet->write($row+$i, $col+17,   '3hours',     $format);
$worksheet->write($row+$i, $col+18,   '24hours',    $format);
$worksheet->write($row+$i, $col+19,   'TOTAL',      $format);
$worksheet->write($row+$i, $col+21,   '3hours',     $format);
$worksheet->write($row+$i, $col+22,   '24hours',    $format);
$worksheet->write($row+$i, $col+23,   'TOTAL',      $format);
$worksheet->write($row+$i, $col+24,   '3hours',     $format);
$worksheet->write($row+$i, $col+25,   '24hours',    $format);
$worksheet->write($row+$i, $col+26,   'TOTAL',      $format);
$worksheet->write($row+$i, $col+27,   '3hours',     $format);
$worksheet->write($row+$i, $col+28,   '24hours',    $format);
$worksheet->write($row+$i, $col+29,   'TOTAL',      $format);
$worksheet->write($row+$i, $col+31,   '3hours',     $format);
$worksheet->write($row+$i, $col+32,   '24hours',    $format);
$worksheet->write($row+$i, $col+33,   'TOTAL',      $format);
$worksheet->write($row+$i, $col+34,   '3hours',     $format);
$worksheet->write($row+$i, $col+35,   '24hours',    $format);
$worksheet->write($row+$i, $col+36,   'TOTAL',      $format);
$worksheet->write($row+$i, $col+37,   '3hours',     $format);
$worksheet->write($row+$i, $col+38,   '24hours',    $format);
$worksheet->write($row+$i, $col+39,   'TOTAL',      $format);
$worksheet->write($row+$i, $col+41,   '15mins',     $format);
$worksheet->write($row+$i, $col+42,   '15mins',     $format);
$worksheet->write($row+$i, $col+43,   '15mins',     $format);

$worksheet->write($row+$i, $col+45,   '3hours',     $format);
$worksheet->write($row+$i, $col+46,   '24hours',    $format);
$worksheet->write($row+$i, $col+47,   'TOTAL',      $format);
$worksheet->write($row+$i, $col+48,   '3hours',     $format);
$worksheet->write($row+$i, $col+49,   '24hours',    $format);
$worksheet->write($row+$i, $col+50,   'TOTAL',      $format);
$worksheet->write($row+$i, $col+51,   '3hours',     $format);
$worksheet->write($row+$i, $col+52,   '24hours',    $format);
$worksheet->write($row+$i, $col+53,   'TOTAL',      $format);

$worksheet->write($row+$i, $col+55,   '24hours',    $format);
$worksheet->write($row+$i, $col+56,   '24hours',    $format);
$worksheet->write($row+$i, $col+57,   '24hours',    $format);
$worksheet->write($row+$i, $col+59,   '24hours',    $format);
$worksheet->write($row+$i, $col+60,   '24hours',    $format);
$worksheet->write($row+$i, $col+61,   '24hours',    $format);
$worksheet->write($row+$i, $col+63,   '24hours',    $format);
$worksheet->write($row+$i, $col+64,   '24hours',    $format);
$worksheet->write($row+$i, $col+65,   '24hours',    $format);
$worksheet->write($row+$i, $col+67,   '24hours',    $format);
$worksheet->write($row+$i, $col+68,   '24hours',    $format);
$worksheet->write($row+$i, $col+69,   '24hours',    $format);
$worksheet->write($row+$i, $col+71,   '24hours',    $format);
$worksheet->write($row+$i, $col+72,   '24hours',    $format);
$worksheet->write($row+$i, $col+73,   '24hours',    $format);
$worksheet->write($row+$i, $col+75,   '24hours',    $format);
$worksheet->write($row+$i, $col+76,   '24hours',    $format);
$worksheet->write($row+$i, $col+77,   '24hours',    $format);
$worksheet->write($row+$i, $col+79,   '24hours',    $format);
$worksheet->write($row+$i, $col+80,   '24hours',    $format);
$worksheet->write($row+$i, $col+81,   '24hours',    $format);
$worksheet->write($row+$i, $col+83,   '24hours',    $format);
$worksheet->write($row+$i, $col+84,   '24hours',    $format);
$worksheet->write($row+$i, $col+85,   '24hours',    $format);
$worksheet->write($row+$i, $col+87,   '15min',      $format);
$worksheet->write($row+$i, $col+88,   '15min',      $format);
$worksheet->write($row+$i, $col+89,   '15min',      $format);
$worksheet->write($row+$i, $col+91,   '24hours',    $format);
$worksheet->write($row+$i, $col+92,   '24hours',    $format);
$worksheet->write($row+$i, $col+93,   '24hours',    $format);


# 1st Query
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_chat_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by 1 order by tran_dt";
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
}

# 2nd Query
$i=1;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_email_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by 1 order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+11,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+12,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+13,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+14,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+15,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+16,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+17,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+18,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+19,  $rowRst[9],  $format1);
}

# 3rd Query
$i=1;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_photo_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by 1 order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+21,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+22,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+23,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+24,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+25,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+26,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+27,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+28,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+29,  $rowRst[9],  $format1);
}

# 4th Query
$i=1;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_unli_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+31,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+32,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+33,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+34,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+35,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+36,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+37,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+38,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+39,  $rowRst[9],  $format1);
}

# 5th Query
$i=1;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_boost_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+41,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+42,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+43,  $rowRst[9],  $format1);
}

# 6th Query
$i=1;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_social_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+45,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+46,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+47,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+48,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+49,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+50,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+51,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+52,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+53,  $rowRst[9],  $format1);
}

# 7th Query
$i=1;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_line_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+55,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+56,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+57,  $rowRst[9],  $format1);
}


# 8th Query
$i=1;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_snapchat_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+59,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+60,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+61,  $rowRst[9],  $format1);
}



# 9th Query
$i=1;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_tumblr_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+63,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+64,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+65,  $rowRst[9],  $format1);
}



# 10th Query
$i=1;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_waze_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+67,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+68,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+69,  $rowRst[9],  $format1);
}



# 11th Query
$i=1;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_wechat_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+71,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+72,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+73,  $rowRst[9],  $format1);
}



# 12th Query
$i=1;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_facebook_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+75,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+76,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+77,  $rowRst[9],  $format1);
}



# 13th Query
$i=1;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_wiki_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+79,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+80,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+81,  $rowRst[9],  $format1);
}


# 13th Query
$i=1;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_free_social_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+83,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+84,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+85,  $rowRst[9],  $format1);
}


# 14th Query
$i=1;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_pisonet_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+87,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+88,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+89,  $rowRst[9],  $format1);
}

# 15th Query
$i=1;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt,
                     sum(plan_3_pre) plan_3_pre, sum(plan_24_pre) plan_24_pre, sum(plan_tot_pre) plan_tot_pre, 
                     sum(plan_3_tnt) plan_3_tnt, sum(plan_24_tnt) plan_24_tnt, sum(plan_tot_tnt) plan_tot_tnt, 
                     sum(plan_3_ppd) plan_3_ppd, sum(plan_24_ppd) plan_24_ppd, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_school_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet->write($row+$i, $col+91,  $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+92,  $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+93,  $rowRst[9],  $format1);
}


$workbook->close();
 binmode STDOUT;

$from = "powerapp_stats\@chikka.com";
$to = "victor\@chikka.com,jomai\@chikka.com,dikster424\@gmail.com,dungomichelle\@yahoo.com,elusivefaith\@gmail.com,mariefe.rivera1012\@gmail.com,noei17\@yahoo.com.ph,maine.gorospe\@gmail.com";
$cc = "dbadmins\@chikka.com";
#$to = "glenon\@chikka.com";
#$cc = "glenon\@chikka.com";
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


