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

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_SUN_stats_".$current_date.".xls";
print $excel_file;

#my $dbh_hi10 = DB::DBconnect(myconstants::HI10_DB,myconstants::HI10_HOST,myconstants::HI10_USER,myconstants::HI10_PASSWORD);
my $dbh_hi10 = DB::DBconnect(myconstants::PWR_SUN_DB,myconstants::HI10_HOST,myconstants::HI10_USER,myconstants::HI10_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
my $sth_hi_10;
my @rowRst;

# Add a worksheet
$worksheet[0] = $workbook->add_worksheet($txt_month);
$worksheet[1] = $workbook->add_worksheet($txt_month."-Hits");
$worksheet[2] = $workbook->add_worksheet($txt_month."-Rev");


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

$format21 = $workbook->add_format(bg_color => 'cyan'); # Add a format
$format21->set_bold();
$format21->set_font('Calibri');
$format21->set_size('11');
$format21->set_color('black');
$format21->set_align('center');
$format21->set_border(2);

$format2R = $workbook->add_format(bg_color => 'blue'); # Add a format
$format2R->set_bold();
$format2R->set_font('Calibri');
$format2R->set_size('11');
$format2R->set_color('black');
$format2R->set_align('center');
$format2R->set_border(2);

$format21R = $workbook->add_format(bg_color => 'blue'); # Add a format
$format21R->set_bold();
$format21R->set_font('Calibri');
$format21R->set_size('11');
$format21R->set_color('black');
$format21R->set_align('center');
$format21R->set_border(2);

$formatT = $workbook->add_format(bg_color => 'silver'); # Add a format
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

$formatP1 = $workbook->add_format(bg_color => 'cyan'); # Add a format
$formatP1->set_bold();
$formatP1->set_font('Calibri');
$formatP1->set_size('10');
$formatP1->set_color('black');
$formatP1->set_align('center');
$formatP1->set_border(1);

$formatU = $workbook->add_format(bg_color => 'blue'); # Add a format
$formatU->set_bold();
$formatU->set_font('Calibri');
$formatU->set_size('10');
$formatU->set_color('black');
$formatU->set_align('center');
$formatU->set_border(1);

$formatS = $workbook->add_format(bg_color => 'yellow'); # Add a format
$formatS->set_bold();
$formatS->set_font('Calibri');
$formatS->set_size('10');
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

# 1st Worksheet
$strSQLhi10 = "select DATE_FORMAT(a.tran_dt,'%m/%d/%Y') tran_dt, 
                      a.unli_hits, a.email_hits, a.chat_hits,   a.photo_hits, a.social_hits, a.speed_hits, 
                      a.line_hits, a.snap_hits,  a.tumblr_hits, a.waze_hits,  a.wechat_hits,  
                      a.facebook_hits, a.wiki_hits, a.free_social_hits, school_hits, 
                      a.unli_uniq, a.email_uniq, a.chat_uniq,   a.photo_uniq, a.social_uniq, a.speed_uniq, 
                      a.line_uniq, a.snap_uniq,  a.tumblr_uniq, a.waze_uniq,  a.wechat_uniq, 
                      a.facebook_uniq, a.wiki_uniq, a.free_social_uniq, school_uniq, 
                      a.total_hits, a.num_optout, 
                      IFNULL(b.num_subs,0) num_subs, a.concurrent_max_subs, a.concurrent_max_tm, a.concurrent_avg_subs,
                      a.total_uniq, a.num_uniq_30d, 
                      IF(a.tran_dt=last_day(a.tran_dt), concat(date_format(concat(left(a.tran_dt,8),'01') , '%b-%d'), ' to ', date_format(a.tran_dt, '%b-%d')), 
                                                        concat(date_format(date_sub(a.tran_dt, interval 30 day), '%b-%d'), ' to ', date_format(a.tran_dt, '%b-%d'))
                        ) period_covered
               from powerapp_dailyrep a left outer join powerapp_concurrent_subs b on a.tran_dt = b.tran_dt 
               where left(a.tran_dt,7) = '".$current_date."' 
               order by a.tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

# Write a formatted and unformatted string, row and column notation.
$row=1;
$col=0;
$worksheet[0]->merge_range($row, $col+1,  $row, $col+15, 'Hits per Package',        $format2);
$worksheet[0]->merge_range($row, $col+17, $row, $col+31, 'Unique Subs per Package', $format2);
$worksheet[0]->merge_range($row, $col+33, $row, $col+34, 'Hits & Optout Per Day',   $format2);
$worksheet[0]->merge_range($row, $col+36, $row, $col+39, 'MINs in Chikka APN',      $format2);
$worksheet[0]->merge_range($row, $col+41, $row, $col+43, 'Unique Subs',             $format2);

$row++;
$col=0;
$worksheet[0]->write($row, $col, 'DATE', $format);
for ($i=0;$i<2;$i++){
   $worksheet[0]->set_column($col+1,  $col+15, 6);
   if ($i==0){
      $worksheet[0]->set_column($col+1,  $col+1, 10);
   }
   $worksheet[0]->set_column($col+6,  $col+6,  10);
   $worksheet[0]->set_column($col+8,  $col+8,  8);
   $worksheet[0]->set_column($col+12, $col+13, 9);
   $worksheet[0]->set_column($col+14, $col+14, 11);
   $worksheet[0]->set_column($col+15, $col+15, 14);
   $worksheet[0]->write($row, $col+1,   'UNLI',           $format);
   $worksheet[0]->write($row, $col+2,   'EMAIL',          $format);
   $worksheet[0]->write($row, $col+3,   'CHAT',           $format);
   $worksheet[0]->write($row, $col+4,   'PHOTO',          $format);
   $worksheet[0]->write($row, $col+5,   'SOCIAL',         $format);
   $worksheet[0]->write($row, $col+6,   'SPEEDBOOST',     $format);
   $worksheet[0]->write($row, $col+7,   'LINE',           $format);
   $worksheet[0]->write($row, $col+8,   'SNAPCHAT',       $format);
   $worksheet[0]->write($row, $col+9,   'TUMBLR',         $format);
   $worksheet[0]->write($row, $col+10,  'WAZE',           $format);
   $worksheet[0]->write($row, $col+11,  'WeCHAT',         $format);
   $worksheet[0]->write($row, $col+12,  'FACEBOOK',       $format);
   $worksheet[0]->write($row, $col+13,  'WIKIPEDIA',      $format);
   $worksheet[0]->write($row, $col+14,  'FREE SOCIAL',    $format);
   $worksheet[0]->write($row, $col+15,  'BACK-TO-SCHOOL', $format);
   $worksheet[0]->set_column($col+16, $col+16, 1);
   $col = $col+16;
}
$worksheet[0]->set_column($col+1, $col+2, 10);
$worksheet[0]->write($row, $col+1,   'HITS',           $format);
$worksheet[0]->write($row, $col+2,   'OPTOUT',         $format);
$worksheet[0]->set_column($col+3, $col+3, 1);
$worksheet[0]->set_column($col+5, $col+6, 12);
$worksheet[0]->set_column($col+7, $col+7, 12);
$worksheet[0]->write($row, $col+4,   'TOTAL',          $format);
$worksheet[0]->write($row, $col+5,   'Max Concurrent', $format);
$worksheet[0]->write($row, $col+6,   'TIME',           $format);
$worksheet[0]->write($row, $col+7,   'Avg Concurrent', $format);
$worksheet[0]->set_column($col+8, $col+8, 1);
$worksheet[0]->set_column($col+9, $col+10, 12);
$worksheet[0]->set_column($col+11, $col+11, 15);
$worksheet[0]->write($row, $col+9,   'Daily UNIQ',     $format);
$worksheet[0]->write($row, $col+10,  'Monthly UNIQ',   $format);
$worksheet[0]->write($row, $col+11,  'Monthly (Start-End)', $format);

$col=0;
$i=0;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $k=0;
   $col=0;
   for ($j=0;$j<2;$j++){
      if ($j==0){
         $worksheet[0]->write($row+$i, $col,  $rowRst[$k],   $format1);
      }
      $worksheet[0]->write($row+$i, $col+1,   $rowRst[$k+1],   $format1);
      $worksheet[0]->write($row+$i, $col+2,   $rowRst[$k+2],   $format1);
      $worksheet[0]->write($row+$i, $col+3,   $rowRst[$k+3],   $format1);
      $worksheet[0]->write($row+$i, $col+4,   $rowRst[$k+4],   $format1);
      $worksheet[0]->write($row+$i, $col+5,   $rowRst[$k+5],   $format1);
      $worksheet[0]->write($row+$i, $col+6,   $rowRst[$k+6],   $format1);
      $worksheet[0]->write($row+$i, $col+7,   $rowRst[$k+7],   $format1);
      $worksheet[0]->write($row+$i, $col+8,   $rowRst[$k+8],   $format1);
      $worksheet[0]->write($row+$i, $col+9,   $rowRst[$k+9],   $format1);
      $worksheet[0]->write($row+$i, $col+10,  $rowRst[$k+10],  $format1);
      $worksheet[0]->write($row+$i, $col+11,  $rowRst[$k+11],  $format1);
      $worksheet[0]->write($row+$i, $col+12,  $rowRst[$k+12],  $format1);
      $worksheet[0]->write($row+$i, $col+13,  $rowRst[$k+13],  $format1);
      $worksheet[0]->write($row+$i, $col+14,  $rowRst[$k+14],  $format1);
      $worksheet[0]->write($row+$i, $col+15,  $rowRst[$k+15],  $format1);
      $worksheet[0]->set_column($col+16, $col+16, 1);
      $col = $col+16;
      $k=$k+15;
   }
   $worksheet[0]->write($row+$i, $col+1,   $rowRst[$k+1],  $format1);
   $worksheet[0]->write($row+$i, $col+2,   $rowRst[$k+2],  $format1);
   $worksheet[0]->write($row+$i, $col+4,   $rowRst[$k+3],  $format1);
   $worksheet[0]->write($row+$i, $col+5,   $rowRst[$k+4],  $format1);
   $worksheet[0]->write($row+$i, $col+6,   $rowRst[$k+5],  $format1s);
   $worksheet[0]->write($row+$i, $col+7,   $rowRst[$k+6],  $format1);
   $worksheet[0]->write($row+$i, $col+9,   $rowRst[$k+7],  $format1);
   $worksheet[0]->write($row+$i, $col+10,  $rowRst[$k+8],  $format1);
   $worksheet[0]->write($row+$i, $col+11,  $rowRst[$k+9],  $format1);
}

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%b %Y'), num_subs 
               from   powerapp_concurrent_subs b 
               where exists (select 1 from (select date_format(tran_dt, '%b %Y') month_, max(tran_dt) tran_dt 
                             from powerapp_concurrent_subs group by 1) t1 
               where b.tran_dt = t1.tran_dt) ";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

$i++;
$i++;
$i++;

$col=0;
$worksheet[0]->write($row+$i, $col, 'MONTH', $format);
$worksheet[0]->write($row+$i, $col+1, 'CHIKKA APN', $format);

while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet[0]->write($row+$i, $col, $rowRst[0], $format1);
   $worksheet[0]->write($row+$i, $col+1, $rowRst[1], $format1);
}


###################################################
###################################################
###################################################
# 2nd Worksheet
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),
                      chat_hits_24, 
                      email_hits_24, 
                      photo_hits_3+photo_hits_24_pp+photo_hits_24, 
                      unli_hits_24_pp+unli_hits_24, 
                      speed_hits, 
                      social_hits_24_pp+social_hits_24,
                      line_hits_24_pp+line_hits_24, 
                      snap_hits_24, tumblr_hits_24, waze_hits_24, 
                      wechat_hits_24_pp+wechat_hits_24,
                      facebook_hits_24, wiki_hits_24, 
                      free_social_hits_24, school_hits_24
                from  powerapp_validity_dailyrep
                where left(tran_dt,7) = '".$current_date."' 
                order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

# Write a formatted and unformatted string, row and column notation.
$worksheet[1]->set_column(8,   8, 11); # Snapchat
$worksheet[1]->set_column(12, 13, 11); # FB and WIKI
$worksheet[1]->set_column(14, 14, 12); # FB and WIKI
$worksheet[1]->set_column(15, 15, 15); # BACK-TO-SCHOOL

$row = 1;
$col = 0;
$worksheet[1]->write($row, $col+1,  'CHAT',           $format21);
$worksheet[1]->write($row, $col+2,  'EMAIL',          $format21);
$worksheet[1]->write($row, $col+3,  'PHOTO',          $format21);
$worksheet[1]->write($row, $col+4,  'UNLI',           $format21);
$worksheet[1]->write($row, $col+5,  'BOOST',          $format21);
$worksheet[1]->write($row, $col+6,  'SOCIAL',         $format21);
$worksheet[1]->write($row, $col+7,  'LINE',           $format21);
$worksheet[1]->write($row, $col+8,  'SNAPCHAT',       $format21);
$worksheet[1]->write($row, $col+9,  'TUMBLR',         $format21);
$worksheet[1]->write($row, $col+10, 'WAZE',           $format21);
$worksheet[1]->write($row, $col+11, 'WE-CHAT',        $format21);
$worksheet[1]->write($row, $col+12, 'FACEBOOK',       $format21);
$worksheet[1]->write($row, $col+13, 'WIKIPEDIA',      $format21);
$worksheet[1]->write($row, $col+14, 'FREE SOCIAL',    $format21);
$worksheet[1]->write($row, $col+15, 'BACK-TO-SCHOOL', $format21);
$row++;
$worksheet[1]->write($row, $col+1,  'HITS', $format21R);
$worksheet[1]->write($row, $col+2,  'HITS', $format21R);
$worksheet[1]->write($row, $col+3,  'HITS', $format21R);
$worksheet[1]->write($row, $col+4,  'HITS', $format21R);
$worksheet[1]->write($row, $col+5,  'HITS', $format21R);
$worksheet[1]->write($row, $col+6,  'HITS', $format21R);
$worksheet[1]->write($row, $col+7,  'HITS', $format21R);
$worksheet[1]->write($row, $col+8,  'HITS', $format21R);
$worksheet[1]->write($row, $col+9,  'HITS', $format21R);
$worksheet[1]->write($row, $col+10, 'HITS', $format21R);
$worksheet[1]->write($row, $col+11, 'HITS', $format21R);
$worksheet[1]->write($row, $col+12, 'HITS', $format21R);
$worksheet[1]->write($row, $col+13, 'HITS', $format21R);
$worksheet[1]->write($row, $col+14, 'HITS', $format21R);
$worksheet[1]->write($row, $col+15, 'HITS', $format21R);
$row++;
$worksheet[1]->write($row, $col,    'Date',        $format);
$worksheet[1]->write($row, $col+1,  'TOTAL',       $format);
$worksheet[1]->write($row, $col+2,  'TOTAL',       $format);
$worksheet[1]->write($row, $col+3,  'TOTAL',       $format);
$worksheet[1]->write($row, $col+4,  'TOTAL',       $format);
$worksheet[1]->write($row, $col+5,  'TOTAL',       $format);
$worksheet[1]->write($row, $col+6,  'TOTAL',       $format);
$worksheet[1]->write($row, $col+7,  'TOTAL',       $format);
$worksheet[1]->write($row, $col+8,  'TOTAL',       $format);
$worksheet[1]->write($row, $col+9,  'TOTAL',       $format);
$worksheet[1]->write($row, $col+10, 'TOTAL',       $format);
$worksheet[1]->write($row, $col+11, 'TOTAL',       $format);
$worksheet[1]->write($row, $col+12, 'TOTAL',       $format);
$worksheet[1]->write($row, $col+13, 'TOTAL',       $format);
$worksheet[1]->write($row, $col+14, 'TOTAL',       $format);
$worksheet[1]->write($row, $col+15, 'TOTAL',       $format);

while (@rowRst = $sth_hi_10->fetchrow()) {
   $row++;
   $worksheet[1]->write($row, $col,    $rowRst[0],  $formatT);
   $worksheet[1]->write($row, $col+1,  $rowRst[1],  $format1);
   $worksheet[1]->write($row, $col+2,  $rowRst[2],  $format1);
   $worksheet[1]->write($row, $col+3,  $rowRst[3],  $format1);
   $worksheet[1]->write($row, $col+4,  $rowRst[4],  $format1);
   $worksheet[1]->write($row, $col+5,  $rowRst[5],  $format1);
   $worksheet[1]->write($row, $col+6,  $rowRst[6],  $format1);
   $worksheet[1]->write($row, $col+7,  $rowRst[7],  $format1);
   $worksheet[1]->write($row, $col+8,  $rowRst[8],  $format1);
   $worksheet[1]->write($row, $col+9,  $rowRst[9],  $format1);
   $worksheet[1]->write($row, $col+10, $rowRst[10], $format1);
   $worksheet[1]->write($row, $col+11, $rowRst[11], $format1);
   $worksheet[1]->write($row, $col+12, $rowRst[12], $format1);
   $worksheet[1]->write($row, $col+13, $rowRst[13], $format1);
   $worksheet[1]->write($row, $col+14, $rowRst[14], $format1);
   $worksheet[1]->write($row, $col+15, $rowRst[15], $format1);
}

#######################################################
#######################################################
#######################################################
# 3rd worksheet

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),
                      chat_uniq_24, chat_hits_24, chat_hits_24*10,
                      email_uniq_24, email_hits_24, email_hits_24*10,
                      photo_uniq_24_pp+photo_uniq_24, photo_hits_24_pp+photo_hits_24, (photo_hits_24_pp*10)+(photo_hits_24*10),
                      unli_uniq_24_pp+unli_uniq_24, unli_hits_24_pp+unli_hits_24, (unli_hits_24_pp*20)+(unli_hits_24*20),
                      speed_uniq, speed_hits, speed_hits*5,
                      social_uniq_24_pp+social_uniq_24, social_hits_24_pp+social_hits_24, (social_hits_24_pp*10)+(social_hits_24*10),
                      line_uniq_24_pp+line_uniq_24, line_hits_24_pp+line_hits_24, (line_hits_24_pp*5)+(line_hits_24*5),
                      snap_uniq_24, snap_hits_24, snap_hits_24*5,
                      tumblr_uniq_24, tumblr_hits_24, tumblr_hits_24*5,
                      waze_uniq_24, waze_hits_24, waze_hits_24*5,
                      wechat_uniq_24_pp+wechat_uniq_24, wechat_hits_24_pp+wechat_hits_24, (wechat_hits_24_pp*5)+(wechat_hits_24*5),
                      facebook_uniq_24, facebook_hits_24, facebook_hits_24*5,
                      wiki_uniq_24, wiki_hits_24, wiki_hits_24*0,
                      free_social_uniq_24, free_social_hits_24, free_social_hits_24*0,
                      school_uniq_24, school_hits_24, school_hits_24*5,
                      total_uniq, total_hits
                from  powerapp_validity_dailyrep
                where left(tran_dt,7) = '".$current_date."' 
                order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

$row = 1;
$col = 0;
# Write a formatted and unformatted string, row and column notation.
$worksheet[2]->merge_range($row,$col+1, $row,$col+3,  'CHAT',            $formatP);
$worksheet[2]->merge_range($row,$col+5, $row,$col+7,  'EMAIL',           $formatB);
$worksheet[2]->merge_range($row,$col+9, $row,$col+11, 'PHOTO' ,          $formatB);
$worksheet[2]->merge_range($row,$col+13,$row,$col+15, 'UNLI',            $formatC);
$worksheet[2]->merge_range($row,$col+17,$row,$col+19, 'SPEEDBOOST',      $formatE);
$worksheet[2]->merge_range($row,$col+21,$row,$col+23, 'SOCIAL',          $formatU);
$worksheet[2]->merge_range($row,$col+25,$row,$col+27, 'LINE',            $formatS);
$worksheet[2]->merge_range($row,$col+29,$row,$col+31, 'SNAPCHAT',        $formatB);
$worksheet[2]->merge_range($row,$col+33,$row,$col+35, 'TUMBLR',          $formatB);
$worksheet[2]->merge_range($row,$col+37,$row,$col+39, 'WAZE',            $formatB);
$worksheet[2]->merge_range($row,$col+41,$row,$col+43, 'WECHAT',          $formatB);
$worksheet[2]->merge_range($row,$col+45,$row,$col+47, 'FACEBOOK',        $formatB);
$worksheet[2]->merge_range($row,$col+49,$row,$col+51, 'WIKIPEDIA',       $formatB);
$worksheet[2]->merge_range($row,$col+53,$row,$col+55, 'FREE SOCIAL',     $formatB);
$worksheet[2]->merge_range($row,$col+57,$row,$col+59, 'BACK-TO-SCHOOL',  $formatB);

$row++;
$col=0;
$worksheet[2]->write($row+1, $col, 'DATE', $format);

#PHOTO
#LINE
#WeCHAT
#CHAT
#EMAIL
#UNLI
#SOCIAL
#SPEEDBOOST
#SNAPCHAT
#TUMBLR
#WAZE
#FACEBOOK
#WIKIPEDIA
#FREE-SOCIAL
#BACK-TO-SCHOOL
for ($i=0;$i<15;$i++){
   $worksheet[2]->set_column($col+1,$col+1,12);
   $worksheet[2]->set_column($col+2,$col+3,9);
   $worksheet[2]->set_column($col+4,$col+4,1);
   $worksheet[2]->write($row, $col+1,   'UNIQUE USERS',   $formatP1);
   $worksheet[2]->write($row, $col+2,   'HITS',           $formatP1);
   $worksheet[2]->write($row, $col+3,   'REVENUE',        $formatP1);
   $worksheet[2]->write($row+1, $col+1, 'TOTAL',          $format);
   $worksheet[2]->write($row+1, $col+2, 'TOTAL',          $format);
   $worksheet[2]->write($row+1, $col+3, 'GROSS REV',      $format);
   $col = $col+4;
}

$row++;
$col=0;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $row++;
   $i++;
   $k=0;
   $col=0;
   for ($j=0;$j<15;$j++){
      if ($j==0){
         $worksheet[2]->write($row, $col,  $rowRst[$k],   $format1);
      }
      $worksheet[2]->write($row, $col+1,   $rowRst[$k+1],   $format1);
      $worksheet[2]->write($row, $col+2,   $rowRst[$k+2],   $format1);
      $worksheet[2]->write($row, $col+3,   $rowRst[$k+3],   $format1);
      $col = $col+4;
      $k=$k+3;
   }

}                                               

# $col=0;
# for ($i=0;$i<3;$i++){
#    $worksheet[2]->write($row+1, $col+9, 'GROSS REV',      $format);
#    $col = $col+10;
#    $worksheet[2]->set_column($col,$col,1);
# }
# for ($i=0;$i<13;$i++){
#    $worksheet[2]->write($row+1, $col+3, 'GROSS REV',      $format);
#    $col = $col+4;
# }

#   $lrow = $row;
#   $myFormula = "SUM(J5:J".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+7, '='.($myFormula), $formatT);
#   $myFormula = "SUM(T5:T".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+8, '='.($myFormula), $formatT);
#   $myFormula = "SUM(AD5:AD".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+9, '='.($myFormula), $formatT);
#   $myFormula = "SUM(R5:R".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+17, '='.($myFormula), $formatT);
#   $myFormula = "SUM(S5:S".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+18, '='.($myFormula), $formatT);
#   $myFormula = "SUM(T5:T".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+19, '='.($myFormula), $formatT);
#   $myFormula = "SUM(AD5:AD".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+29, '='.($myFormula), $formatT);
#   $myFormula = "SUM(AE5:AE".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+30, '='.($myFormula), $formatT);
#   $myFormula = "SUM(AF5:AF".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+31, '='.($myFormula), $formatT);
#   $myFormula = "SUM(AG5:AG".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+32, '='.($myFormula), $formatT);
#   $myFormula = "SUM(AQ5:AQ".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+42, '='.($myFormula), $formatT);
#   $myFormula = "SUM(AR5:AR".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+43, '='.($myFormula), $formatT);
#   $myFormula = "SUM(AS5:AS".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+44, '='.($myFormula), $formatT);
#   $myFormula = "SUM(AT5:AT".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+45, '='.($myFormula), $formatT);
#   $myFormula = "SUM(BD5:BD".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+55, '='.($myFormula), $formatT);
#   $myFormula = "SUM(BE5:BE".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+56, '='.($myFormula), $formatT);
#   $myFormula = "SUM(BF5:BF".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+57, '='.($myFormula), $formatT);
#   $myFormula = "SUM(BG5:BG".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+58, '='.($myFormula), $formatT);
#   $myFormula = "SUM(BK5:BK".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+62, '='.($myFormula), $formatT);
#   $myFormula = "SUM(BS5:BS".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+70, '='.($myFormula), $formatT);
#   $myFormula = "SUM(BT5:BT".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+71, '='.($myFormula), $formatT);
#   $myFormula = "SUM(BU5:BU".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+72, '='.($myFormula), $formatT);
#   $myFormula = "SUM(BY5:BY".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+76, '='.($myFormula), $formatT);
#   $myFormula = "SUM(CC5:CC".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+80, '='.($myFormula), $formatT);
#   $myFormula = "SUM(CG5:CG".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+84, '='.($myFormula), $formatT);
#   $myFormula = "SUM(CO5:CO".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+92, '='.($myFormula), $formatT);
#   $myFormula = "SUM(CP5:CP".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+93, '='.($myFormula), $formatT);
#   $myFormula = "SUM(CQ5:CQ".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+94, '='.($myFormula), $formatT);
#   $myFormula = "SUM(CU5:CU".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+98, '='.($myFormula), $formatT);
#   $myFormula = "SUM(CY5:CY".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+102,'='.($myFormula), $formatT);
#   $myFormula = "SUM(DC5:DC".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+106,'='.($myFormula), $formatT);
#   $myFormula = "SUM(DG5:DG".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+110,'='.($myFormula), $formatT);
#   $myFormula = "SUM(DK5:DK".$lrow.")";
#   $worksheet[2]->write_formula($row+$i, $col+114,'='.($myFormula), $formatT);



$workbook->close();
 binmode STDOUT;

$from = "powerapp_stats\@chikka.com";
$to = "victor\@chikka.com,ps.java\@chikka.com,jomai\@chikka.com,ra\@chikka.com,ian\@chikka.com";
$cc = "dbadmins\@chikka.com,jldespanol\@chikka.com";
$to = "jomai\@chikka.com";
$cc = "dbadmins\@chikka.com";
$Subject = "PowerApp Stats SUN, ".$current_day;

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
                    <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp Stats SUN for the Month of $txt_month.</span></span></p>
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




