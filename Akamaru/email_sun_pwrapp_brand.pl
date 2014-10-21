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

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_Sun_Stats_Brand_".$current_date.".xls";
print $excel_file;

my $dbh_hi10 = DB::DBconnect(myconstants::PWR_SUN_DB,myconstants::HI10_HOST,myconstants::HI10_USER,myconstants::HI10_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
my $sth_hi_10;
my @rowRst;

# Create Worksheet
$worksheet[0] = $workbook->add_worksheet($txt_month);
$worksheet[1] = $workbook->add_worksheet($txt_month."-HITS");


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

$format21R = $workbook->add_format(bg_color => 'silver'); # Add a format
$format21R->set_bold();
$format21R->set_font('Calibri');
$format21R->set_size('11');
$format21R->set_color('black');
$format21R->set_align('center');
$format21R->set_border(2);

$format3 = $workbook->add_format(bg_color => 'cyan'); # Add a format
$format3->set_bold();
$format3->set_font('Calibri');
$format3->set_size('11');
$format3->set_color('black');
$format3->set_align('center');
$format3->set_border(2);


# 1st worksheet
# Write a formatted and unformatted string, row and column notation.
$row=1;
$col=0;
$worksheet[0]->merge_range($row,   $col+1,  $row,   $col+45, 'H  I  T  S     p e r     P  A  C  K  A  G  E', $format2);
$worksheet[0]->merge_range($row,   $col+47, $row,   $col+91, 'U  N    I  Q  U  E      U  S  E  R  S', $format2);
$worksheet[0]->merge_range($row,   $col+93, $row,   $col+98, 'Hits & Optout Per Day', $format2);
$worksheet[0]->merge_range($row+1, $col+1,  $row+1, $col+15, 'SUN PREPAID',  $format3);
$worksheet[0]->merge_range($row+1, $col+16, $row+1, $col+30, 'SUN POSTPAID', $format3);
$worksheet[0]->merge_range($row+1, $col+31, $row+1, $col+45, 'TOTAL',        $format3);
$worksheet[0]->merge_range($row+1, $col+47, $row+1, $col+61, 'SUN PREPAID',  $format3);
$worksheet[0]->merge_range($row+1, $col+62, $row+1, $col+76, 'SUN POSTPAID', $format3);
$worksheet[0]->merge_range($row+1, $col+77, $row+1, $col+91, 'TOTAL',        $format3);
$worksheet[0]->merge_range($row+1, $col+93, $row+1, $col+95, 'HITS',         $format3);
$worksheet[0]->merge_range($row+1, $col+96, $row+1, $col+98, 'OPTOUT',       $format3);

$worksheet[0]->write($row+2, $col, 'DATE', $format);
for ($i=0;$i<6;$i++){
   $worksheet[0]->set_column($col+1,  $col+15, 6);
   $worksheet[0]->set_column($col+6,  $col+6,  10);
   $worksheet[0]->set_column($col+8,  $col+8,  8);
   $worksheet[0]->set_column($col+12, $col+13, 9);
   $worksheet[0]->set_column($col+14, $col+14, 11);
   $worksheet[0]->set_column($col+15, $col+15, 14);
   $worksheet[0]->write($row+2, $col+1,   'UNLI',           $format);
   $worksheet[0]->write($row+2, $col+2,   'EMAIL',          $format);
   $worksheet[0]->write($row+2, $col+3,   'CHAT',           $format);
   $worksheet[0]->write($row+2, $col+4,   'PHOTO',          $format);
   $worksheet[0]->write($row+2, $col+5,   'SOCIAL',         $format);
   $worksheet[0]->write($row+2, $col+6,   'SPEEDBOOST',     $format);
   $worksheet[0]->write($row+2, $col+7,   'LINE',           $format);
   $worksheet[0]->write($row+2, $col+8,   'SNAPCHAT',       $format);
   $worksheet[0]->write($row+2, $col+9,   'TUMBLR',         $format);
   $worksheet[0]->write($row+2, $col+10,  'WAZE',           $format);
   $worksheet[0]->write($row+2, $col+11,  'WeCHAT',         $format);
   $worksheet[0]->write($row+2, $col+12,  'FACEBOOK',       $format);
   $worksheet[0]->write($row+2, $col+13,  'WIKIPEDIA',      $format);
   $worksheet[0]->write($row+2, $col+14,  'FREE SOCIAL',    $format);
   $worksheet[0]->write($row+2, $col+15,  'BACK-TO-SCHOOL', $format);
   $col = $col+15;
   if ($i==2){
      $col = $col+1;
      $worksheet[0]->set_column($col, $col, 1);
   }
}
$worksheet[0]->set_column($col+1, $col+1, 1);
$worksheet[0]->write($row+2, $col+2,   'PREPAID',       $format);
$worksheet[0]->write($row+2, $col+3,   'POSTPAID',      $format);
$worksheet[0]->write($row+2, $col+4,   'TOTAL',         $format);
$worksheet[0]->write($row+2, $col+5,   'PREPAID',       $format);
$worksheet[0]->write($row+2, $col+6,   'POSTPAID',      $format);
$worksheet[0]->write($row+2, $col+7,   'TOTAL',         $format);

$row=$row+2;
$col=0;
$i=0;

# 1st Query
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),
                      unli_pre, email_pre, chat_pre, photo_pre, social_pre, speed_pre, line_pre, snapchat_pre, tumblr_pre, waze_pre, wechat_pre, facebook_pre, wiki_pre, free_social_pre, school_pre,
                      unli_ppd, email_ppd, chat_ppd, photo_ppd, social_ppd, speed_ppd, line_ppd, snapchat_ppd, tumblr_ppd, waze_ppd, wechat_ppd, facebook_ppd, wiki_ppd, free_social_ppd, school_ppd,
                      unli_tot, email_tot, chat_tot, photo_tot, social_tot, speed_tot, line_tot, snapchat_tot, tumblr_tot, waze_tot, wechat_tot, facebook_tot, wiki_tot, free_social_tot, school_tot
               from powerapp_brand_dailyhits_summary                                                                                           
               where left(tran_dt,7) = '".$current_date."' order by tran_dt";                                                                  
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);                                                                                                  
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[0]->write($row+$i, $col,      $rowRst[0],  $format1);
   $worksheet[0]->write($row+$i, $col+1,    $rowRst[1],  $format1);
   $worksheet[0]->write($row+$i, $col+2,    $rowRst[2],  $format1);
   $worksheet[0]->write($row+$i, $col+3,    $rowRst[3],  $format1);
   $worksheet[0]->write($row+$i, $col+4,    $rowRst[4],  $format1);
   $worksheet[0]->write($row+$i, $col+5,    $rowRst[5],  $format1);
   $worksheet[0]->write($row+$i, $col+6,    $rowRst[6],  $format1);
   $worksheet[0]->write($row+$i, $col+7,    $rowRst[7],  $format1);
   $worksheet[0]->write($row+$i, $col+8,    $rowRst[8],  $format1);
   $worksheet[0]->write($row+$i, $col+9,    $rowRst[9],  $format1);
   $worksheet[0]->write($row+$i, $col+10,   $rowRst[10], $format1);
   $worksheet[0]->write($row+$i, $col+11,   $rowRst[11], $format1);
   $worksheet[0]->write($row+$i, $col+12,   $rowRst[12], $format1);
   $worksheet[0]->write($row+$i, $col+13,   $rowRst[13], $format1);
   $worksheet[0]->write($row+$i, $col+14,   $rowRst[14], $format1);
   $worksheet[0]->write($row+$i, $col+15,   $rowRst[15], $format1);
   $worksheet[0]->write($row+$i, $col+16,   $rowRst[16], $format1);
   $worksheet[0]->write($row+$i, $col+17,   $rowRst[17], $format1);
   $worksheet[0]->write($row+$i, $col+18,   $rowRst[18], $format1);
   $worksheet[0]->write($row+$i, $col+19,   $rowRst[19], $format1);
   $worksheet[0]->write($row+$i, $col+20,   $rowRst[20], $format1);
   $worksheet[0]->write($row+$i, $col+21,   $rowRst[21], $format1);
   $worksheet[0]->write($row+$i, $col+22,   $rowRst[22], $format1);
   $worksheet[0]->write($row+$i, $col+23,   $rowRst[23], $format1);
   $worksheet[0]->write($row+$i, $col+24,   $rowRst[24], $format1);
   $worksheet[0]->write($row+$i, $col+25,   $rowRst[25], $format1);
   $worksheet[0]->write($row+$i, $col+26,   $rowRst[26], $format1);
   $worksheet[0]->write($row+$i, $col+27,   $rowRst[27], $format1);
   $worksheet[0]->write($row+$i, $col+28,   $rowRst[28], $format1);
   $worksheet[0]->write($row+$i, $col+29,   $rowRst[29], $format1);
   $worksheet[0]->write($row+$i, $col+30,   $rowRst[30], $format1);
   $worksheet[0]->write($row+$i, $col+31,   $rowRst[31], $format1);
   $worksheet[0]->write($row+$i, $col+32,   $rowRst[32], $format1);
   $worksheet[0]->write($row+$i, $col+33,   $rowRst[33], $format1);
   $worksheet[0]->write($row+$i, $col+34,   $rowRst[34], $format1);
   $worksheet[0]->write($row+$i, $col+35,   $rowRst[35], $format1);
   $worksheet[0]->write($row+$i, $col+36,   $rowRst[36], $format1);
   $worksheet[0]->write($row+$i, $col+37,   $rowRst[37], $format1);
   $worksheet[0]->write($row+$i, $col+38,   $rowRst[38], $format1);
   $worksheet[0]->write($row+$i, $col+39,   $rowRst[39], $format1);
   $worksheet[0]->write($row+$i, $col+40,   $rowRst[40], $format1);
   $worksheet[0]->write($row+$i, $col+41,   $rowRst[41], $format1);
   $worksheet[0]->write($row+$i, $col+42,   $rowRst[42], $format1);
   $worksheet[0]->write($row+$i, $col+43,   $rowRst[43], $format1);
   $worksheet[0]->write($row+$i, $col+44,   $rowRst[44], $format1);
   $worksheet[0]->write($row+$i, $col+45,   $rowRst[45], $format1);
}

$i=0;
# 2nd Query
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),
                      unli_pre, email_pre, chat_pre, photo_pre, social_pre, speed_pre, line_pre, snapchat_pre, tumblr_pre, waze_pre, wechat_pre, facebook_pre, wiki_pre, free_social_pre, school_pre,
                      unli_ppd, email_ppd, chat_ppd, photo_ppd, social_ppd, speed_ppd, line_ppd, snapchat_ppd, tumblr_ppd, waze_ppd, wechat_ppd, facebook_ppd, wiki_ppd, free_social_ppd, school_ppd,
                      unli_tot, email_tot, chat_tot, photo_tot, social_tot, speed_tot, line_tot, snapchat_tot, tumblr_tot, waze_tot, wechat_tot, facebook_tot, wiki_tot, free_social_tot, school_tot 
               from powerapp_brand_dailyuniq_summary
               where left(tran_dt,7) = '".$current_date."' order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet[0]->write($row+$i, $col+47,   $rowRst[1],  $format1);
   $worksheet[0]->write($row+$i, $col+48,   $rowRst[2],  $format1);
   $worksheet[0]->write($row+$i, $col+49,   $rowRst[3],  $format1);
   $worksheet[0]->write($row+$i, $col+50,   $rowRst[4],  $format1);
   $worksheet[0]->write($row+$i, $col+51,   $rowRst[5],  $format1);
   $worksheet[0]->write($row+$i, $col+52,   $rowRst[6],  $format1);
   $worksheet[0]->write($row+$i, $col+53,   $rowRst[7],  $format1);
   $worksheet[0]->write($row+$i, $col+54,   $rowRst[8],  $format1);
   $worksheet[0]->write($row+$i, $col+55,   $rowRst[9],  $format1);
   $worksheet[0]->write($row+$i, $col+56,   $rowRst[10], $format1);
   $worksheet[0]->write($row+$i, $col+57,   $rowRst[11], $format1);
   $worksheet[0]->write($row+$i, $col+58,   $rowRst[12], $format1);
   $worksheet[0]->write($row+$i, $col+59,   $rowRst[13], $format1);
   $worksheet[0]->write($row+$i, $col+60,   $rowRst[14], $format1);
   $worksheet[0]->write($row+$i, $col+61,   $rowRst[15], $format1);
   $worksheet[0]->write($row+$i, $col+62,   $rowRst[16], $format1);
   $worksheet[0]->write($row+$i, $col+63,   $rowRst[17], $format1);
   $worksheet[0]->write($row+$i, $col+64,   $rowRst[18], $format1);
   $worksheet[0]->write($row+$i, $col+65,   $rowRst[19], $format1);
   $worksheet[0]->write($row+$i, $col+66,   $rowRst[20], $format1);
   $worksheet[0]->write($row+$i, $col+67,   $rowRst[21], $format1);
   $worksheet[0]->write($row+$i, $col+68,   $rowRst[22], $format1);
   $worksheet[0]->write($row+$i, $col+69,   $rowRst[23], $format1);
   $worksheet[0]->write($row+$i, $col+70,   $rowRst[24], $format1);
   $worksheet[0]->write($row+$i, $col+71,   $rowRst[25], $format1);
   $worksheet[0]->write($row+$i, $col+72,   $rowRst[26], $format1);
   $worksheet[0]->write($row+$i, $col+73,   $rowRst[27], $format1);
   $worksheet[0]->write($row+$i, $col+74,   $rowRst[28], $format1);
   $worksheet[0]->write($row+$i, $col+75,   $rowRst[29], $format1);
   $worksheet[0]->write($row+$i, $col+76,   $rowRst[30], $format1);
   $worksheet[0]->write($row+$i, $col+77,   $rowRst[31], $format1);
   $worksheet[0]->write($row+$i, $col+78,   $rowRst[32], $format1);
   $worksheet[0]->write($row+$i, $col+79,   $rowRst[33], $format1);
   $worksheet[0]->write($row+$i, $col+80,  $rowRst[34], $format1);
   $worksheet[0]->write($row+$i, $col+81,  $rowRst[35], $format1);
   $worksheet[0]->write($row+$i, $col+82,  $rowRst[36], $format1);
   $worksheet[0]->write($row+$i, $col+83,  $rowRst[37], $format1);
   $worksheet[0]->write($row+$i, $col+84,  $rowRst[38], $format1);
   $worksheet[0]->write($row+$i, $col+85,  $rowRst[39], $format1);
   $worksheet[0]->write($row+$i, $col+86,  $rowRst[40], $format1);
   $worksheet[0]->write($row+$i, $col+87,  $rowRst[41], $format1);
   $worksheet[0]->write($row+$i, $col+88,  $rowRst[42], $format1);
   $worksheet[0]->write($row+$i, $col+89,  $rowRst[43], $format1);
   $worksheet[0]->write($row+$i, $col+90,  $rowRst[44], $format1);
   $worksheet[0]->write($row+$i, $col+91,  $rowRst[45], $format1);
}                                               
                                                
$i=0;                                           
# 3rd Query                                     
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),
                      hits_pre, hits_ppd, hits_tot, 
                      optout_pre, optout_ppd, optout_tot
               from powerapp_brand_daily_hits_optout_summary
               where left(tran_dt,7) = '".$current_date."' order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet[0]->write($row+$i, $col+93,  $rowRst[1],  $format1);
   $worksheet[0]->write($row+$i, $col+94,  $rowRst[2],  $format1);
   $worksheet[0]->write($row+$i, $col+95,  $rowRst[3],  $format1);
   $worksheet[0]->write($row+$i, $col+96,  $rowRst[4],  $format1);
   $worksheet[0]->write($row+$i, $col+97,  $rowRst[5],  $format1);
   $worksheet[0]->write($row+$i, $col+98,  $rowRst[6],  $format1);
}


# 2nd worksheet
# Write a formatted and unformatted string, row and column notation.
$row=1;
$col=0;
$worksheet[1]->merge_range($row,   $col+1,  $row,   $col+2,  'CHAT',           $format2);
$worksheet[1]->merge_range($row,   $col+4,  $row,   $col+5,  'EMAIL',          $format2);
$worksheet[1]->merge_range($row,   $col+7,  $row,   $col+8,  'PHOTO',          $format2);
$worksheet[1]->merge_range($row,   $col+10, $row,   $col+11, 'UNLI',           $format2);
$worksheet[1]->merge_range($row,   $col+13, $row,   $col+14, 'BOOST',          $format2);
$worksheet[1]->merge_range($row,   $col+16, $row,   $col+17, 'SOCIAL',         $format2);
$worksheet[1]->merge_range($row,   $col+19, $row,   $col+20, 'LINE',           $format2);
$worksheet[1]->merge_range($row,   $col+22, $row,   $col+23, 'SNAPCHAT',       $format2);
$worksheet[1]->merge_range($row,   $col+25, $row,   $col+26, 'TUMBLR',         $format2);
$worksheet[1]->merge_range($row,   $col+28, $row,   $col+29, 'WAZE',           $format2);
$worksheet[1]->merge_range($row,   $col+31, $row,   $col+32, 'WECHAT',         $format2);
$worksheet[1]->merge_range($row,   $col+34, $row,   $col+35, 'FACEBOOK',       $format2);
$worksheet[1]->merge_range($row,   $col+37, $row,   $col+38, 'WIKIPEDIA',      $format2);
$worksheet[1]->merge_range($row,   $col+40, $row,   $col+41, 'FREE SOCIAL',    $format2);
$worksheet[1]->merge_range($row,   $col+43, $row,   $col+44, 'BACK-TO-SCHOOL', $format2);

$row++;
$col=0;
$worksheet[1]->write($row+1, $col, 'DATE', $format);
for ($i=0;$i<15;$i++){
   $worksheet[1]->write($row, $col+1, 'PREPAID',  $format21R);
   $worksheet[1]->write($row, $col+2, 'POSTPAID', $format21R);
   $worksheet[1]->set_column( $col+3, $col+3, 1);
   $worksheet[1]->write($row+1, $col+1, '24hours', $format);
   $worksheet[1]->write($row+1, $col+2, '24hours', $format);
   $col = $col+3;
}

$row++;
$col=0;
$i=0;
# 1st Query
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, sum(plan_tot_pre) plan_tot_pre, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_chat_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by 1 order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col,    $rowRst[0],  $format1);
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],  $format1);
}

# 2nd Query
$i=0;
$col=$col+3;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, sum(plan_tot_pre) plan_tot_pre, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_email_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by 1 order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],  $format1);
}

# 3rd Query
$i=0;
$col=$col+3;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, sum(plan_tot_pre) plan_tot_pre, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_photo_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by 1 order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],  $format1);
}

# 4th Query
$i=0;
$col=$col+3;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, sum(plan_tot_pre) plan_tot_pre, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_unli_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],  $format1);
}

# 5th Query
$i=0;
$col=$col+3;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, sum(plan_tot_pre) plan_tot_pre, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_boost_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],  $format1);
}

# 6th Query
$i=0;
$col=$col+3;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, sum(plan_tot_pre) plan_tot_pre, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_social_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],  $format1);
}

# 7th Query
$i=0;
$col=$col+3;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, sum(plan_tot_pre) plan_tot_pre, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_line_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],  $format1);
}

# 8th Query
$i=0;
$col=$col+3;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, sum(plan_tot_pre) plan_tot_pre, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_snapchat_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],  $format1);
}

# 9th Query
$i=0;
$col=$col+3;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, sum(plan_tot_pre) plan_tot_pre, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_tumblr_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],  $format1);
}

# 10th Query
$i=0;
$col=$col+3;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, sum(plan_tot_pre) plan_tot_pre, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_waze_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],  $format1);
}

# 11th Query
$i=0;
$col=$col+3;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, sum(plan_tot_pre) plan_tot_pre, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_wechat_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],  $format1);
}

# 12th Query
$i=0;
$col=$col+3;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, sum(plan_tot_pre) plan_tot_pre, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_facebook_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],  $format1);
}

# 13th Query
$i=0;
$col=$col+3;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, sum(plan_tot_pre) plan_tot_pre, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_wiki_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],  $format1);
}

# 14th Query
$i=0;
$col=$col+3;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, sum(plan_tot_pre) plan_tot_pre, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_free_social_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],  $format1);
}

# 15th Query
$i=0;
$col=$col+3;
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y') tran_dt, sum(plan_tot_pre) plan_tot_pre, sum(plan_tot_ppd) plan_tot_ppd
               from powerapp_brand_school_dailyhits 
               where left(tran_dt,7) = '".$current_date."' group by tran_dt order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[1]->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row+$i, $col+2,  $rowRst[2],  $format1);
}


$workbook->close();
 binmode STDOUT;

$from = "powerapp_stats\@chikka.com";
$to = "victor\@chikka.com,jomai\@chikka.com,dikster424\@gmail.com,dungomichelle\@yahoo.com,elusivefaith\@gmail.com,mariefe.rivera1012\@gmail.com,noei17\@yahoo.com.ph,maine.gorospe\@gmail.com";
$cc = "dbadmins\@chikka.com";
$to = "jomai\@chikka.com";
$cc = "glenon\@chikka.com";
$Subject = "PowerApp SUN Stats per Brand, ".$current_day;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp SUN Stats per Brand for the Month of $txt_month.</span></span></p>
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


