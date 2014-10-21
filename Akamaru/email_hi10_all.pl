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

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_stats_".$current_date.".xls";
print $excel_file;

my $dbh_hi10 = DB::DBconnect(myconstants::HI10_DB,myconstants::HI10_HOST,myconstants::HI10_USER,myconstants::HI10_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
my $sth_hi_10;
my @rowRst;


# 1st Worksheet
$strSQLhi10 = "select DATE_FORMAT(a.tran_dt,'%m/%d/%Y') tran_dt, 
                      a.unli_hits, a.email_hits, a.chat_hits,   a.photo_hits, a.social_hits, a.speed_hits, 
                      a.line_hits, a.snap_hits,  a.tumblr_hits, a.waze_hits,  a.wechat_hits,  
                      a.facebook_hits, a.wiki_hits, a.free_social_hits,
                      a.unli_uniq, a.email_uniq, a.chat_uniq,   a.photo_uniq, a.social_uniq, a.speed_uniq, 
                      a.line_uniq, a.snap_uniq,  a.tumblr_uniq, a.waze_uniq,  a.wechat_uniq, 
                      a.facebook_uniq, a.wiki_uniq, a.free_social_uniq,
                      a.total_hits, a.num_optout, 
                      IFNULL(b.num_subs,0) num_subs, a.concurrent_max_subs, a.concurrent_max_tm, a.concurrent_avg_subs,
                      a.total_uniq, a.num_uniq_30d, concat(date_format(date_sub(a.tran_dt, interval 30 day), '%b-%d'), ' to ', date_format(a.tran_dt, '%b-%d'))  
               from powerapp_dailyrep a left outer join powerapp_concurrent_subs b on a.tran_dt = b.tran_dt 
               order by a.tran_dt";
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
$row = 1;
$col = 0;
$i=1;
$worksheet->merge_range('B2:O2', 'Hits per Package', $format2);
$worksheet->merge_range('Q2:AD2', 'Unique Subs per Package', $format2);
$worksheet->merge_range('AF2:AG2', 'Hits & Optout per Day', $format2);
$worksheet->merge_range('AI2:AL2', 'MINs in Chikka APN', $format2);
$worksheet->merge_range('AN2:AP2', 'Unique Subs', $format2);

$worksheet->set_column(0,0,9);
$worksheet->set_column(1,1,9);
$worksheet->set_column(2,5,6);
$worksheet->set_column(6,6,10);
$worksheet->set_column(7,7,6);
$worksheet->set_column(8,8,8);
$worksheet->set_column(9,11,6);
$worksheet->set_column(12,14,9);
$worksheet->set_column(15,15,1);
$worksheet->set_column(16,20,6);
$worksheet->set_column(21,21,10);
$worksheet->set_column(22,22,6);
$worksheet->set_column(23,23,8);
$worksheet->set_column(24,25,6);
$worksheet->set_column(27,29,9);
$worksheet->set_column(30,30,1);
$worksheet->set_column(31,32,10);
$worksheet->set_column(33,33,1);
$worksheet->set_column(34,34,7);
$worksheet->set_column(35,35,12);
$worksheet->set_column(36,36,14);
$worksheet->set_column(37,37,12);
$worksheet->set_column(38,38,1);
$worksheet->set_column(39,40,12);
$worksheet->set_column(41,41,16);
#

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

$worksheet->write($row+$i, $col+16,  'UNLI',           $format);
$worksheet->write($row+$i, $col+17,  'EMAIL',          $format);
$worksheet->write($row+$i, $col+18,  'CHAT',           $format);
$worksheet->write($row+$i, $col+19,  'PHOTO',          $format);
$worksheet->write($row+$i, $col+20,  'SOCIAL',         $format);
$worksheet->write($row+$i, $col+21,  'SPEEDBOOST',     $format);
$worksheet->write($row+$i, $col+22,  'LINE',           $format);
$worksheet->write($row+$i, $col+23,  'SNAPCHAT',       $format);
$worksheet->write($row+$i, $col+24,  'TUMBLR',         $format);
$worksheet->write($row+$i, $col+25,  'WAZE',           $format);
$worksheet->write($row+$i, $col+26,  'WeCHAT',         $format);
$worksheet->write($row+$i, $col+27,  'FACEBOOK',       $format);
$worksheet->write($row+$i, $col+28,  'WIKIPEDIA',      $format);
$worksheet->write($row+$i, $col+29,  'FREE SOCIAL',    $format);

$worksheet->write($row+$i, $col+31,  'HITS',           $format);
$worksheet->write($row+$i, $col+32,  'OPTOUT',         $format);

$worksheet->write($row+$i, $col+34,  'TOTAL',          $format);
$worksheet->write($row+$i, $col+35,  'Max Concurrent', $format);
$worksheet->write($row+$i, $col+36,  'TIME',           $format);
$worksheet->write($row+$i, $col+37,  'Avg Concurrent', $format);

$worksheet->write($row+$i, $col+39,  'Daily UNIQ',     $format);
$worksheet->write($row+$i, $col+40,  'Monthly UNIQ',   $format);
$worksheet->write($row+$i, $col+41,  'Monthly (Start-End)', $format);

while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,     $rowRst[0],  $format1);
   $worksheet->write($row+$i, $col+1,   $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+2,   $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+3,   $rowRst[3],  $format1);
   $worksheet->write($row+$i, $col+4,   $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+5,   $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+6,   $rowRst[6],  $format1);
   $worksheet->write($row+$i, $col+7,   $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+8,   $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+9,   $rowRst[9],  $format1);
   $worksheet->write($row+$i, $col+10,  $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+11,  $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+12,  $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+13,  $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+14,  $rowRst[14], $format1);

   $worksheet->write($row+$i, $col+16,  $rowRst[15] , $format1);
   $worksheet->write($row+$i, $col+17,  $rowRst[16] , $format1);
   $worksheet->write($row+$i, $col+18,  $rowRst[17] , $format1);
   $worksheet->write($row+$i, $col+19,  $rowRst[18],  $format1);
   $worksheet->write($row+$i, $col+20,  $rowRst[19],  $format1);
   $worksheet->write($row+$i, $col+21,  $rowRst[20],  $format1);
   $worksheet->write($row+$i, $col+22,  $rowRst[21],  $format1);
   $worksheet->write($row+$i, $col+23,  $rowRst[22],  $format1);
   $worksheet->write($row+$i, $col+24,  $rowRst[23],  $format1);
   $worksheet->write($row+$i, $col+25,  $rowRst[24],  $format1);
   $worksheet->write($row+$i, $col+26,  $rowRst[25],  $format1);
   $worksheet->write($row+$i, $col+27,  $rowRst[26],  $format1);
   $worksheet->write($row+$i, $col+28,  $rowRst[27],  $format1);
   $worksheet->write($row+$i, $col+29,  $rowRst[28],  $format1);

   $worksheet->write($row+$i, $col+31,  $rowRst[29], $format1);
   $worksheet->write($row+$i, $col+32,  $rowRst[30], $format1);

   $worksheet->write($row+$i, $col+34,  $rowRst[31], $format1);
   $worksheet->write($row+$i, $col+35,  $rowRst[32], $format1);
   $worksheet->write($row+$i, $col+36,  $rowRst[33], $format1s);
   $worksheet->write($row+$i, $col+37,  $rowRst[34], $format1);

   $worksheet->write($row+$i, $col+39,  $rowRst[35], $format1);
   $worksheet->write($row+$i, $col+40,  $rowRst[36], $format1);
   $worksheet->write($row+$i, $col+41,  $rowRst[37], $format1);
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
$i++;

$worksheet->write($row+$i, $col, 'MONTH', $format);
$worksheet->write($row+$i, $col+1, 'CHIKKA APN', $format);

while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col, $rowRst[0], $format1);
   $worksheet->write($row+$i, $col+1, $rowRst[1], $format1);
}


###################################################
###################################################
###################################################
# 2nd Worksheet
$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),
                      chat_hits_3, chat_hits_24, chat_hits_3+chat_hits_24, 
                      email_hits_3, email_hits_24, email_hits_3+email_hits_24, 
                      photo_hits_3, photo_hits_24, photo_hits_3+photo_hits_24, 
                      unli_hits_3, unli_hits_24, unli_hits_3+unli_hits_24, 
                      speed_hits, 
                      social_hits_3, social_hits_24, social_hits_3+social_hits_24,
                      line_hits_24, snap_hits_24, 
                      tumblr_hits_24, waze_hits_24, 
                      wechat_hits_24, facebook_hits_24, 
                      wiki_hits_24, free_social_hits_24
                from  powerapp_validity_dailyrep
                order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

# Add a worksheet
$worksheet = $workbook->add_worksheet($txt_month."-Hits");

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

$format2 = $workbook->add_format(bg_color => 'cyan'); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('11');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(2);

#  Add and define a format
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

#  Add and define a format
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

# Write a formatted and unformatted string, row and column notation.
$row = 1;
$col = 0;

$worksheet->set_column(18, 18, 11);
$worksheet->set_column(22, 24, 11);

$worksheet->merge_range('B2:D2', 'CHAT',        $format2);
$worksheet->merge_range('E2:G2', 'EMAIL',       $format2);
$worksheet->merge_range('H2:J2', 'PHOTO',       $format2);
$worksheet->merge_range('K2:M2', 'UNLI',        $format2);
$worksheet->write(1, 13,         'BOOST',       $format21);
$worksheet->merge_range('O2:Q2', 'SOCIAL',      $format2);
$worksheet->write(1, 17,         'LINE',        $format21);
$worksheet->write(1, 18,         'SNAPCHAT',    $format21);
$worksheet->write(1, 19,         'TUMBLR',      $format21);
$worksheet->write(1, 20,         'WAZE',        $format21);
$worksheet->write(1, 21,         'WeCHAT',      $format21);
$worksheet->write(1, 22,         'FACEBOOK',    $format21);
$worksheet->write(1, 23,         'WIKIPEDIA',   $format21);
$worksheet->write(1, 24,         'FREE SOCIAL', $format21);
$worksheet->merge_range('B3:D3', 'HITS',        $format2R);
$worksheet->merge_range('E3:G3', 'HITS',        $format2R);
$worksheet->merge_range('H3:J3', 'HITS',        $format2R);
$worksheet->merge_range('K3:M3', 'HITS',        $format2R);
$worksheet->write(2, 13,         'HITS',        $format21R);
$worksheet->merge_range('O3:Q3', 'HITS',        $format2R);
$worksheet->write(2, 17,         'HITS',        $format21R);
$worksheet->write(2, 18,         'HITS',        $format21R);
$worksheet->write(2, 19,         'HITS',        $format21R);
$worksheet->write(2, 20,         'HITS',        $format21R);
$worksheet->write(2, 21,         'HITS',        $format21R);
$worksheet->write(2, 22,         'HITS',        $format21R);
$worksheet->write(2, 23,         'HITS',        $format21R);
$worksheet->write(2, 24,         'HITS',        $format21R);
#
$i=2;
$worksheet->write($row+$i, $col,    'Date',    $format);
$worksheet->write($row+$i, $col+1,  '3hours',  $format);
$worksheet->write($row+$i, $col+2,  '24hours', $format);
$worksheet->write($row+$i, $col+3,  'TOTAL',   $format);
$worksheet->write($row+$i, $col+4,  '3hours',  $format);
$worksheet->write($row+$i, $col+5,  '24hours', $format);
$worksheet->write($row+$i, $col+6,  'TOTAL',   $format);
$worksheet->write($row+$i, $col+7,  '3hours',  $format);
$worksheet->write($row+$i, $col+8,  '24hours', $format);
$worksheet->write($row+$i, $col+9,  'TOTAL',   $format);
$worksheet->write($row+$i, $col+10, '3hours',  $format);
$worksheet->write($row+$i, $col+11, '24hours', $format);
$worksheet->write($row+$i, $col+12, 'TOTAL',   $format);
$worksheet->write($row+$i, $col+13, '15mins',  $format);
$worksheet->write($row+$i, $col+14, '3hours',  $format);
$worksheet->write($row+$i, $col+15, '24hours', $format);
$worksheet->write($row+$i, $col+16, 'TOTAL',   $format);
$worksheet->write($row+$i, $col+17, '24hours', $format);
$worksheet->write($row+$i, $col+18, '24hours', $format);
$worksheet->write($row+$i, $col+19, '24hours', $format);
$worksheet->write($row+$i, $col+20, '24hours', $format);
$worksheet->write($row+$i, $col+21, '24hours', $format);
$worksheet->write($row+$i, $col+22, '24hours', $format);
$worksheet->write($row+$i, $col+23, '24hours', $format);
$worksheet->write($row+$i, $col+24, '24hours', $format);

while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0],  $formatT);
   $worksheet->write($row+$i, $col+1,  $rowRst[1],  $format1);
   $worksheet->write($row+$i, $col+2,  $rowRst[2],  $format1);
   $worksheet->write($row+$i, $col+3,  $rowRst[3],  $formatT);
   $worksheet->write($row+$i, $col+4,  $rowRst[4],  $format1);
   $worksheet->write($row+$i, $col+5,  $rowRst[5],  $format1);
   $worksheet->write($row+$i, $col+6,  $rowRst[6],  $formatT);
   $worksheet->write($row+$i, $col+7,  $rowRst[7],  $format1);
   $worksheet->write($row+$i, $col+8,  $rowRst[8],  $format1);
   $worksheet->write($row+$i, $col+9,  $rowRst[9],  $formatT);
   $worksheet->write($row+$i, $col+10, $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+11, $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+12, $rowRst[12], $formatT);
   $worksheet->write($row+$i, $col+13, $rowRst[13], $formatT);
   $worksheet->write($row+$i, $col+14, $rowRst[14], $format1);
   $worksheet->write($row+$i, $col+15, $rowRst[15], $format1);
   $worksheet->write($row+$i, $col+16, $rowRst[16], $formatT);
   $worksheet->write($row+$i, $col+17, $rowRst[17], $formatT);
   $worksheet->write($row+$i, $col+18, $rowRst[18], $formatT);
   $worksheet->write($row+$i, $col+19, $rowRst[19], $formatT);
   $worksheet->write($row+$i, $col+20, $rowRst[20], $formatT);
   $worksheet->write($row+$i, $col+21, $rowRst[21], $formatT);
   $worksheet->write($row+$i, $col+22, $rowRst[22], $formatT);
   $worksheet->write($row+$i, $col+23, $rowRst[23], $formatT);
   $worksheet->write($row+$i, $col+24, $rowRst[24], $formatT);
}


#######################################################
#######################################################
#######################################################
# 3rd worksheet

$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),
                      chat_uniq_3, chat_uniq_24, chat_uniq_3+chat_uniq_24,
                      chat_hits_3, chat_hits_24, chat_hits_3+chat_hits_24,
                      chat_hits_3*5, chat_hits_24*10, (chat_hits_3*5)+(chat_hits_24*10),
                      email_uniq_3, email_uniq_24, email_uniq_3+email_uniq_24,
                      email_hits_3, email_hits_24,email_hits_3+email_hits_24,
                      email_hits_3*5, email_hits_24*10, (email_hits_3*5)+(email_hits_24*10),
                      photo_uniq_3, photo_uniq_24, photo_uniq_3+photo_uniq_24,
                      photo_hits_3, photo_hits_24, photo_hits_3+photo_hits_24,
                      photo_hits_3*10, photo_hits_24*20, (photo_hits_3*10)+(photo_hits_24*20),
                      unli_uniq_3, unli_uniq_24, unli_uniq_3+unli_uniq_24,
                      unli_hits_3, unli_hits_24, unli_hits_3+unli_hits_24,
                      unli_hits_3*15, unli_hits_24*30, (unli_hits_3*15)+(unli_hits_24*30),
                      social_uniq_3, social_uniq_24, social_uniq_3+social_uniq_24,
                      social_hits_3, social_hits_24, social_hits_3+social_hits_24,
                      social_hits_3*10, social_hits_24*20, (social_hits_3*10)+(social_hits_24*20),
                      speed_uniq, speed_hits, speed_hits*15,
                      line_uniq_24, line_hits_24, line_hits_24*10,
                      snap_uniq_24, snap_hits_24, snap_hits_24*5,
                      tumblr_uniq_24, tumblr_hits_24, tumblr_hits_24*5,
                      waze_uniq_24, waze_hits_24, waze_hits_24*5,
                      wechat_uniq_24, wechat_hits_24, wechat_hits_24*10,
                      facebook_uniq_24, facebook_hits_24, facebook_hits_24*5,
                      wiki_uniq_24, wiki_hits_24, wiki_hits_24*0,
                      free_social_uniq_24, free_social_hits_24, free_social_hits_24*0,
                      total_uniq, total_hits
                from  powerapp_validity_dailyrep
                order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet($txt_month."-Rev");

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
$formatT->set_num_format('#,##0.00');

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

$worksheet->set_column(0, 0, 10);
$worksheet->set_column(1, 6, 7);
$worksheet->set_column(7, 9, 9);
$worksheet->set_column(10, 10, 1);
$worksheet->set_column(11, 16, 7);
$worksheet->set_column(17, 19, 9);
$worksheet->set_column(20, 20, 1);
$worksheet->set_column(21, 26, 7);
$worksheet->set_column(27, 29, 9);
$worksheet->set_column(30, 30, 1);
$worksheet->set_column(31, 36, 7);
$worksheet->set_column(37, 39, 9);
$worksheet->set_column(40, 40, 1);
$worksheet->set_column(41, 46, 7);
$worksheet->set_column(47, 49, 9);
$worksheet->set_column(50, 50, 1);
$worksheet->set_column(51, 51, 11);
$worksheet->set_column(52, 53, 9);
$worksheet->set_column(54, 54, 1);
$worksheet->set_column(55, 55, 11);
$worksheet->set_column(56, 57, 9);
$worksheet->set_column(58, 58, 1);
$worksheet->set_column(59, 59, 11);
$worksheet->set_column(60, 61, 9);
$worksheet->set_column(62, 62, 1);
$worksheet->set_column(63, 63, 11);
$worksheet->set_column(64, 65, 9);
$worksheet->set_column(66, 66, 1);
$worksheet->set_column(67, 67, 11);
$worksheet->set_column(68, 69, 9);
$worksheet->set_column(70, 70, 1);
$worksheet->set_column(71, 71, 11);
$worksheet->set_column(72, 73, 9);
$worksheet->set_column(74, 74, 1);
$worksheet->set_column(75, 75, 11);
$worksheet->set_column(76, 77, 9);
$worksheet->set_column(78, 78, 1);
$worksheet->set_column(79, 79, 11);
$worksheet->set_column(80, 81, 9);
$worksheet->set_column(82, 82, 1);
$worksheet->set_column(83, 83, 11);
$worksheet->set_column(84, 85, 9);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:J2',   'CHAT',         $formatC);
$worksheet->merge_range('L2:T2',   'EMAIL',        $formatE);
$worksheet->merge_range('V2:AD2',  'PHOTO',        $formatP);
$worksheet->merge_range('AF2:AN2', 'UNLI',         $formatU);
$worksheet->merge_range('AP2:AX2', 'SOCIAL',       $formatS);
$worksheet->merge_range('AZ2:BB2', 'SPEEDBOOST',   $formatB);
$worksheet->merge_range('BD2:BF2', 'LINE',         $formatB);
$worksheet->merge_range('BH2:BJ2', 'SNAPCHAT',     $formatB);
$worksheet->merge_range('BL2:BN2', 'TUMBLR',       $formatB);
$worksheet->merge_range('BP2:BR2', 'WAZE',         $formatB);
$worksheet->merge_range('BT2:BV2', 'WeCHAT',       $formatB);
$worksheet->merge_range('BX2:BZ2', 'FACEBOOK',     $formatB);
$worksheet->merge_range('CB2:CD2', 'WIKIPEDIA',    $formatB);
$worksheet->merge_range('CF2:CH2', 'FREE SOCIAL',  $formatB);

#CHAT
$worksheet->merge_range('B3:D3', 'UNIQUE USERS', $formatC);
$worksheet->merge_range('E3:G3', 'HITS', $formatC);
$worksheet->merge_range('H3:J3', 'REVENUE', $formatC);
#EMAIL
$worksheet->merge_range('L3:N3', 'UNIQUE USERS', $formatE);
$worksheet->merge_range('O3:Q3', 'HITS', $formatE);
$worksheet->merge_range('R3:T3', 'REVENUE', $formatE);
#PHOTO
$worksheet->merge_range('V3:X3', 'UNIQUE USERS', $formatP);
$worksheet->merge_range('Y3:AA3', 'HITS', $formatP);
$worksheet->merge_range('AB3:AD3', 'REVENUE', $formatP);
#UNLI
$worksheet->merge_range('AF3:AH3', 'UNIQUE USERS', $formatU);
$worksheet->merge_range('AI3:AK3', 'HITS', $formatU);
$worksheet->merge_range('AL3:AN3', 'REVENUE', $formatU);
#SOCIAL
$worksheet->merge_range('AP3:AR3', 'UNIQUE USERS', $formatS);
$worksheet->merge_range('AS3:AU3', 'HITS', $formatS);
$worksheet->merge_range('AV3:AX3', 'REVENUE', $formatS);
#
$worksheet->write(2, 51, 'UNIQUE USERS', $format);
$worksheet->write(2, 52, 'HITS', $format);
$worksheet->write(2, 53, 'REVENUE', $format);
#
$worksheet->write(2, 55, 'UNIQUE USERS', $format);
$worksheet->write(2, 56, 'HITS', $format);
$worksheet->write(2, 57, 'REVENUE', $format);
#
$worksheet->write(2, 59, 'UNIQUE USERS', $format);
$worksheet->write(2, 60, 'HITS', $format);
$worksheet->write(2, 61, 'REVENUE', $format);
#
$worksheet->write(2, 63, 'UNIQUE USERS', $format);
$worksheet->write(2, 64, 'HITS', $format);
$worksheet->write(2, 65, 'REVENUE', $format);
#
$worksheet->write(2, 67, 'UNIQUE USERS', $format);
$worksheet->write(2, 68, 'HITS', $format);
$worksheet->write(2, 69, 'REVENUE', $format);
#
$worksheet->write(2, 71, 'UNIQUE USERS', $format);
$worksheet->write(2, 72, 'HITS', $format);
$worksheet->write(2, 73, 'REVENUE', $format);
#
$worksheet->write(2, 75, 'UNIQUE USERS', $format);
$worksheet->write(2, 76, 'HITS', $format);
$worksheet->write(2, 77, 'REVENUE', $format);
#
$worksheet->write(2, 79, 'UNIQUE USERS', $format);
$worksheet->write(2, 80, 'HITS', $format);
$worksheet->write(2, 81, 'REVENUE', $format);
#
$worksheet->write(2, 83, 'UNIQUE USERS', $format);
$worksheet->write(2, 84, 'HITS', $format);
$worksheet->write(2, 85, 'REVENUE', $format);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col,    'DATE',        $format);
$worksheet->write($row+$i, $col+1,  '3 hours',     $format);
$worksheet->write($row+$i, $col+2,  '24 hours',    $format);
$worksheet->write($row+$i, $col+3,  'TOTAL',       $format);
$worksheet->write($row+$i, $col+4,  '3 hours',     $format);
$worksheet->write($row+$i, $col+5,  '24 hours',    $format);
$worksheet->write($row+$i, $col+6,  'TOTAL',       $format);
$worksheet->write($row+$i, $col+7,  'P5 (3hrs)',   $format);
$worksheet->write($row+$i, $col+8,  'P10 (24hrs)', $format);
$worksheet->write($row+$i, $col+9,  'GROSS REV',   $format);
$worksheet->write($row+$i, $col+11, '3 hours',     $format);
$worksheet->write($row+$i, $col+12, '24 hours',    $format);
$worksheet->write($row+$i, $col+13, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+14, '3 hours',     $format);
$worksheet->write($row+$i, $col+15, '24 hours',    $format);
$worksheet->write($row+$i, $col+16, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+17, 'P5 (3hrs)',   $format);
$worksheet->write($row+$i, $col+18, 'P10 (24hrs)', $format);
$worksheet->write($row+$i, $col+19, 'GROSS REV',   $format);
$worksheet->write($row+$i, $col+21, '3 hours',     $format);
$worksheet->write($row+$i, $col+22, '24 hours',    $format);
$worksheet->write($row+$i, $col+23, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+24, '3 hours',     $format);
$worksheet->write($row+$i, $col+25, '24 hours',    $format);
$worksheet->write($row+$i, $col+26, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+27, 'P10 (3hrs)',  $format);
$worksheet->write($row+$i, $col+28, 'P20 (24hrs)', $format);
$worksheet->write($row+$i, $col+29, 'GROSS REV',   $format);
$worksheet->write($row+$i, $col+31, '3 hours',     $format);
$worksheet->write($row+$i, $col+32, '24 hours',    $format);
$worksheet->write($row+$i, $col+33, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+34, '3 hours',     $format);
$worksheet->write($row+$i, $col+35, '24 hours',    $format);
$worksheet->write($row+$i, $col+36, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+37, 'P15 (3hrs)',  $format);
$worksheet->write($row+$i, $col+38, 'P30 (24hrs)', $format);
$worksheet->write($row+$i, $col+39, 'GROSS REV',   $format);
$worksheet->write($row+$i, $col+41, '3 hours',     $format);
$worksheet->write($row+$i, $col+42, '24 hours',    $format);
$worksheet->write($row+$i, $col+43, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+44, '3 hours',     $format);
$worksheet->write($row+$i, $col+45, '24 hours',    $format);
$worksheet->write($row+$i, $col+46, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+47, 'P10 (3hrs)',  $format);
$worksheet->write($row+$i, $col+48, 'P20 (24hrs)', $format);
$worksheet->write($row+$i, $col+49, 'GROSS REV',   $format);
$worksheet->write($row+$i, $col+51, '15 mins',     $format);
$worksheet->write($row+$i, $col+52, '15 mins',     $format);
$worksheet->write($row+$i, $col+53, 'P5 (15mins)', $format);
$worksheet->write($row+$i, $col+55, '24 hours',    $format);
$worksheet->write($row+$i, $col+56, '24 hours',    $format);
$worksheet->write($row+$i, $col+57, 'P10 (24hrs)', $format);
$worksheet->write($row+$i, $col+59, '24 hours',    $format);
$worksheet->write($row+$i, $col+60, '24 hours',    $format);
$worksheet->write($row+$i, $col+61, 'P5 (24hrs)',  $format);
$worksheet->write($row+$i, $col+63, '24 hours',    $format);
$worksheet->write($row+$i, $col+64, '24 hours',    $format);
$worksheet->write($row+$i, $col+65, 'P5 (24hrs)',  $format);
$worksheet->write($row+$i, $col+67, '24 hours',    $format);
$worksheet->write($row+$i, $col+68, '24 hours',    $format);
$worksheet->write($row+$i, $col+69, 'P5 (24hrs)',  $format);
$worksheet->write($row+$i, $col+71, '24 hours',    $format);
$worksheet->write($row+$i, $col+72, '24 hours',    $format);
$worksheet->write($row+$i, $col+73, 'P10 (24hrs)', $format);
$worksheet->write($row+$i, $col+75, '24 hours',    $format);
$worksheet->write($row+$i, $col+76, '24 hours',    $format);
$worksheet->write($row+$i, $col+77, 'P5 (24hrs)',  $format);
$worksheet->write($row+$i, $col+79, '24 hours',    $format);
$worksheet->write($row+$i, $col+80, '24 hours',    $format);
$worksheet->write($row+$i, $col+81, 'FREE',        $format);
$worksheet->write($row+$i, $col+83, '24 hours',    $format);
$worksheet->write($row+$i, $col+84, '24 hours',    $format);
$worksheet->write($row+$i, $col+85, 'FREE',        $format);

while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0], $format1);
   $worksheet->write($row+$i, $col+1,  $rowRst[1], $format1);
   $worksheet->write($row+$i, $col+2,  $rowRst[2], $format1);
   $worksheet->write($row+$i, $col+3,  $rowRst[3], $format1);
   $worksheet->write($row+$i, $col+4,  $rowRst[4], $format1);
   $worksheet->write($row+$i, $col+5,  $rowRst[5], $format1);
   $worksheet->write($row+$i, $col+6,  $rowRst[6], $format1);
   $worksheet->write($row+$i, $col+7,  $rowRst[7], $formatT);
   $worksheet->write($row+$i, $col+8,  $rowRst[8], $formatT);
   $worksheet->write($row+$i, $col+9,  $rowRst[9], $formatT);
   $worksheet->write($row+$i, $col+11, $rowRst[10], $format1);
   $worksheet->write($row+$i, $col+12, $rowRst[11], $format1);
   $worksheet->write($row+$i, $col+13, $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+14, $rowRst[13], $format1);
   $worksheet->write($row+$i, $col+15, $rowRst[14], $format1);
   $worksheet->write($row+$i, $col+16, $rowRst[15], $format1);
   $worksheet->write($row+$i, $col+17, $rowRst[16], $formatT);
   $worksheet->write($row+$i, $col+18, $rowRst[17], $formatT);
   $worksheet->write($row+$i, $col+19, $rowRst[18], $formatT);
   $worksheet->write($row+$i, $col+21, $rowRst[19], $format1);
   $worksheet->write($row+$i, $col+22, $rowRst[20], $format1);
   $worksheet->write($row+$i, $col+23, $rowRst[21], $format1);
   $worksheet->write($row+$i, $col+24, $rowRst[22], $format1);
   $worksheet->write($row+$i, $col+25, $rowRst[23], $format1);
   $worksheet->write($row+$i, $col+26, $rowRst[24], $format1);
   $worksheet->write($row+$i, $col+27, $rowRst[25], $formatT);
   $worksheet->write($row+$i, $col+28, $rowRst[26], $formatT);
   $worksheet->write($row+$i, $col+29, $rowRst[27], $formatT);
   $worksheet->write($row+$i, $col+31, $rowRst[28], $format1);
   $worksheet->write($row+$i, $col+32, $rowRst[29], $format1);
   $worksheet->write($row+$i, $col+33, $rowRst[30], $format1);
   $worksheet->write($row+$i, $col+34, $rowRst[31], $format1);
   $worksheet->write($row+$i, $col+35, $rowRst[32], $format1);
   $worksheet->write($row+$i, $col+36, $rowRst[33], $format1);
   $worksheet->write($row+$i, $col+37, $rowRst[34], $formatT);
   $worksheet->write($row+$i, $col+38, $rowRst[35], $formatT);
   $worksheet->write($row+$i, $col+39, $rowRst[36], $formatT);
   $worksheet->write($row+$i, $col+41, $rowRst[37], $format1);
   $worksheet->write($row+$i, $col+42, $rowRst[38], $format1);
   $worksheet->write($row+$i, $col+43, $rowRst[39], $format1);
   $worksheet->write($row+$i, $col+44, $rowRst[40], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[41], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[42], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[43], $formatT);
   $worksheet->write($row+$i, $col+48, $rowRst[44], $formatT);
   $worksheet->write($row+$i, $col+49, $rowRst[45], $formatT);
   $worksheet->write($row+$i, $col+51, $rowRst[46], $format1);
   $worksheet->write($row+$i, $col+52, $rowRst[47], $format1);
   $worksheet->write($row+$i, $col+53, $rowRst[48], $formatT);
   $worksheet->write($row+$i, $col+55, $rowRst[49], $format1);
   $worksheet->write($row+$i, $col+56, $rowRst[50], $format1);
   $worksheet->write($row+$i, $col+57, $rowRst[51], $formatT);
   $worksheet->write($row+$i, $col+59, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+60, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+61, $rowRst[54], $formatT);
   $worksheet->write($row+$i, $col+63, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+64, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+65, $rowRst[57], $formatT);
   $worksheet->write($row+$i, $col+67, $rowRst[58], $format1);
   $worksheet->write($row+$i, $col+68, $rowRst[59], $format1);
   $worksheet->write($row+$i, $col+69, $rowRst[60], $formatT);
   $worksheet->write($row+$i, $col+71, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+72, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+73, $rowRst[63], $formatT);
   $worksheet->write($row+$i, $col+75, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+76, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+77, $rowRst[66], $formatT);
   $worksheet->write($row+$i, $col+79, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+80, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+81, $rowRst[69], $formatT);
   $worksheet->write($row+$i, $col+83, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+84, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+85, $rowRst[72], $formatT);
}                                               
                                                
   $i++;                                        
   $lrow = $i+2;
   $myFormula = "SUM(H5:H".$lrow.")";
   $worksheet->write_formula($row+$i, $col+7, '='.($myFormula), $formatT);
   $myFormula = "SUM(I5:I".$lrow.")";
   $worksheet->write_formula($row+$i, $col+8, '='.($myFormula), $formatT);
   $myFormula = "SUM(J5:J".$lrow.")";
   $worksheet->write_formula($row+$i, $col+9, '='.($myFormula), $formatT);
   $myFormula = "SUM(R5:R".$lrow.")";
   $worksheet->write_formula($row+$i, $col+17, '='.($myFormula), $formatT);
   $myFormula = "SUM(S5:S".$lrow.")";
   $worksheet->write_formula($row+$i, $col+18, '='.($myFormula), $formatT);
   $myFormula = "SUM(T5:T".$lrow.")";
   $worksheet->write_formula($row+$i, $col+19, '='.($myFormula), $formatT);
   $myFormula = "SUM(AB5:AB".$lrow.")";
   $worksheet->write_formula($row+$i, $col+27, '='.($myFormula), $formatT);
   $myFormula = "SUM(AC5:AC".$lrow.")";
   $worksheet->write_formula($row+$i, $col+28, '='.($myFormula), $formatT);
   $myFormula = "SUM(AD5:AD".$lrow.")";
   $worksheet->write_formula($row+$i, $col+29, '='.($myFormula), $formatT);
   $myFormula = "SUM(AL5:AL".$lrow.")";
   $worksheet->write_formula($row+$i, $col+37, '='.($myFormula), $formatT);
   $myFormula = "SUM(AM5:AM".$lrow.")";
   $worksheet->write_formula($row+$i, $col+38, '='.($myFormula), $formatT);
   $myFormula = "SUM(AN5:AN".$lrow.")";
   $worksheet->write_formula($row+$i, $col+39, '='.($myFormula), $formatT);
   $myFormula = "SUM(AV5:AV".$lrow.")";
   $worksheet->write_formula($row+$i, $col+47, '='.($myFormula), $formatT);
   $myFormula = "SUM(AW5:AW".$lrow.")";
   $worksheet->write_formula($row+$i, $col+48, '='.($myFormula), $formatT);
   $myFormula = "SUM(AX5:AX".$lrow.")";
   $worksheet->write_formula($row+$i, $col+49, '='.($myFormula), $formatT);
   $myFormula = "SUM(BB5:BB".$lrow.")";
   $worksheet->write_formula($row+$i, $col+53, '='.($myFormula), $formatT);
   $myFormula = "SUM(BF5:BF".$lrow.")";
   $worksheet->write_formula($row+$i, $col+57, '='.($myFormula), $formatT);
   $myFormula = "SUM(BJ5:BJ".$lrow.")";
   $worksheet->write_formula($row+$i, $col+61, '='.($myFormula), $formatT);
   $myFormula = "SUM(BN5:BN".$lrow.")";
   $worksheet->write_formula($row+$i, $col+65, '='.($myFormula), $formatT);
   $myFormula = "SUM(BR5:BR".$lrow.")";
   $worksheet->write_formula($row+$i, $col+69, '='.($myFormula), $formatT);
   $myFormula = "SUM(BV5:BV".$lrow.")";
   $worksheet->write_formula($row+$i, $col+73, '='.($myFormula), $formatT);
   $myFormula = "SUM(BZ5:BZ".$lrow.")";
   $worksheet->write_formula($row+$i, $col+77, '='.($myFormula), $formatT);
   $myFormula = "SUM(CD5:CD".$lrow.")";
   $worksheet->write_formula($row+$i, $col+81, '='.($myFormula), $formatT);
   $myFormula = "SUM(CH5:CH".$lrow.")";
   $worksheet->write_formula($row+$i, $col+85, '='.($myFormula), $formatT);



$workbook->close();
 binmode STDOUT;

$from = "stats\@chikka.com";
$to = "glenon\@chikka.com";
$cc = "glenon\@chikka.com";
$Subject = "PowerApp Stats, ".$current_day;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp Stats (Hits & Revenue) for the Month of $txt_month.</span></span></p>
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




