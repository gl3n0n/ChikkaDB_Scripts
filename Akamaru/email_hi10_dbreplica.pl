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

my $dbh_hi10 = DB::DBconnect(myconstants::HI10A_DB,myconstants::HI10A_HOST,myconstants::HI10A_USER,myconstants::HI10A_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
my $sth_hi_10;
my @rowRst;


# 1st Worksheet
$strSQLhi10 = "select DATE_FORMAT(a.tran_dt,'%m/%d/%Y') tran_dt, 
                      a.unli_hits, a.email_hits, a.chat_hits,   a.photo_hits, a.social_hits, a.speed_hits, 
                      a.line_hits, a.snap_hits,  a.tumblr_hits, a.waze_hits,  a.wechat_hits,  
                      a.facebook_hits, a.wiki_hits, a.free_social_hits, piso_hits, school_hits, 
                      a.unli_uniq, a.email_uniq, a.chat_uniq,   a.photo_uniq, a.social_uniq, a.speed_uniq, 
                      a.line_uniq, a.snap_uniq,  a.tumblr_uniq, a.waze_uniq,  a.wechat_uniq, 
                      a.facebook_uniq, a.wiki_uniq, a.free_social_uniq, piso_uniq, school_uniq, 
                      a.total_hits, a.num_optout, 
                      IFNULL(b.num_subs,0) num_subs, a.concurrent_max_subs, a.concurrent_max_tm, a.concurrent_avg_subs,
                      a.total_uniq, a.num_uniq_30d, concat(date_format(date_sub(a.tran_dt, interval 30 day), '%b-%d'), ' to ', date_format(a.tran_dt, '%b-%d'))  
               from powerapp_dailyrep a left outer join powerapp_concurrent_subs b on a.tran_dt = b.tran_dt 
               where left(a.tran_dt,7) = '".$current_date."' 
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
$worksheet->merge_range('B2:Q2', 'Hits per Package', $format2);
$worksheet->merge_range('S2:AH2', 'Unique Subs per Package', $format2);
$worksheet->merge_range('AJ2:AK2', 'Hits & Optout per Day', $format2);
$worksheet->merge_range('AM2:AP2', 'MINs in Chikka APN', $format2);
$worksheet->merge_range('AR2:AT2', 'Unique Subs', $format2);

$worksheet->set_column(0,0,9);
$worksheet->set_column(1,1,9);
$worksheet->set_column(2,5,6);
$worksheet->set_column(6,6,10);
$worksheet->set_column(7,7,6);
$worksheet->set_column(8,8,8);
$worksheet->set_column(9,11,6);
$worksheet->set_column(12,15,9);
$worksheet->set_column(16,16,13);
$worksheet->set_column(17,17,1);
$worksheet->set_column(18,22,6);
$worksheet->set_column(23,23,10);
$worksheet->set_column(24,24,6);
$worksheet->set_column(25,25,8);
$worksheet->set_column(26,27,6);
$worksheet->set_column(28,32,9);
$worksheet->set_column(33,33,13);
$worksheet->set_column(34,34,1);
$worksheet->set_column(35,36,10);
$worksheet->set_column(37,37,1);
$worksheet->set_column(38,38,7);
$worksheet->set_column(39,39,12);
$worksheet->set_column(40,40,14);
$worksheet->set_column(41,41,12);
$worksheet->set_column(42,42,1);
$worksheet->set_column(43,44,12);
$worksheet->set_column(45,45,16);
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
$worksheet->write($row+$i, $col+15,  'PISONET',        $format);
$worksheet->write($row+$i, $col+16,  'BACK-TO-SCHOOL', $format);

$worksheet->write($row+$i, $col+18,  'UNLI',           $format);
$worksheet->write($row+$i, $col+19,  'EMAIL',          $format);
$worksheet->write($row+$i, $col+20,  'CHAT',           $format);
$worksheet->write($row+$i, $col+21,  'PHOTO',          $format);
$worksheet->write($row+$i, $col+22,  'SOCIAL',         $format);
$worksheet->write($row+$i, $col+23,  'SPEEDBOOST',     $format);
$worksheet->write($row+$i, $col+24,  'LINE',           $format);
$worksheet->write($row+$i, $col+25,  'SNAPCHAT',       $format);
$worksheet->write($row+$i, $col+26,  'TUMBLR',         $format);
$worksheet->write($row+$i, $col+27,  'WAZE',           $format);
$worksheet->write($row+$i, $col+28,  'WeCHAT',         $format);
$worksheet->write($row+$i, $col+29,  'FACEBOOK',       $format);
$worksheet->write($row+$i, $col+30,  'WIKIPEDIA',      $format);
$worksheet->write($row+$i, $col+31,  'FREE SOCIAL',    $format);
$worksheet->write($row+$i, $col+32,  'PISONET',        $format);
$worksheet->write($row+$i, $col+33,  'BACK-TO-SCHOOL', $format);

$worksheet->write($row+$i, $col+35,  'HITS',           $format);
$worksheet->write($row+$i, $col+36,  'OPTOUT',         $format);

$worksheet->write($row+$i, $col+38,  'TOTAL',          $format);
$worksheet->write($row+$i, $col+39,  'Max Concurrent', $format);
$worksheet->write($row+$i, $col+40,  'TIME',           $format);
$worksheet->write($row+$i, $col+41,  'Avg Concurrent', $format);

$worksheet->write($row+$i, $col+43,  'Daily UNIQ',     $format);
$worksheet->write($row+$i, $col+44,  'Monthly UNIQ',   $format);
$worksheet->write($row+$i, $col+45,  'Monthly (Start-End)', $format);

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
   $worksheet->write($row+$i, $col+15,  $rowRst[15], $format1);
   $worksheet->write($row+$i, $col+16,  $rowRst[16], $format1);

   $worksheet->write($row+$i, $col+18,  $rowRst[17] , $format1);
   $worksheet->write($row+$i, $col+19,  $rowRst[18] , $format1);
   $worksheet->write($row+$i, $col+20,  $rowRst[19] , $format1);
   $worksheet->write($row+$i, $col+21,  $rowRst[20],  $format1);
   $worksheet->write($row+$i, $col+22,  $rowRst[21],  $format1);
   $worksheet->write($row+$i, $col+23,  $rowRst[22],  $format1);
   $worksheet->write($row+$i, $col+24,  $rowRst[23],  $format1);
   $worksheet->write($row+$i, $col+25,  $rowRst[24],  $format1);
   $worksheet->write($row+$i, $col+26,  $rowRst[25],  $format1);
   $worksheet->write($row+$i, $col+27,  $rowRst[26],  $format1);
   $worksheet->write($row+$i, $col+28,  $rowRst[27],  $format1);
   $worksheet->write($row+$i, $col+29,  $rowRst[28],  $format1);
   $worksheet->write($row+$i, $col+30,  $rowRst[29],  $format1);
   $worksheet->write($row+$i, $col+31,  $rowRst[30],  $format1);
   $worksheet->write($row+$i, $col+32,  $rowRst[31],  $format1);
   $worksheet->write($row+$i, $col+33,  $rowRst[32],  $format1);

   $worksheet->write($row+$i, $col+35,  $rowRst[33], $format1);
   $worksheet->write($row+$i, $col+36,  $rowRst[34], $format1);

   $worksheet->write($row+$i, $col+38,  $rowRst[35], $format1);
   $worksheet->write($row+$i, $col+39,  $rowRst[36], $format1);
   $worksheet->write($row+$i, $col+40,  $rowRst[37], $format1s);
   $worksheet->write($row+$i, $col+41,  $rowRst[38], $format1);

   $worksheet->write($row+$i, $col+43,  $rowRst[39], $format1);
   $worksheet->write($row+$i, $col+44,  $rowRst[40], $format1);
   $worksheet->write($row+$i, $col+45,  $rowRst[41], $format1);
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
                      unli_hits_3, unli_hits_24_pp, unli_hits_24, unli_hits_3+unli_hits_24_pp+unli_hits_24, 
                      speed_hits, 
                      social_hits_3, social_hits_24, social_hits_3+social_hits_24,
                      line_hits_24_pp, line_hits_24, line_hits_24_pp+line_hits_24, 
                      snap_hits_24, tumblr_hits_24, waze_hits_24, 
                      wechat_hits_24_pp, wechat_hits_24, wechat_hits_24_pp+wechat_hits_24,
                      facebook_hits_24, wiki_hits_24, free_social_hits_24,
                      piso_hits_15, school_hits_24
                from  powerapp_validity_dailyrep
                where left(tran_dt,7) = '".$current_date."' 
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

$worksheet->set_column(11, 12, 12);
$worksheet->set_column(18, 19, 12);
$worksheet->set_column(21, 21, 11);
$worksheet->set_column(24, 25, 12);
$worksheet->set_column(27, 29, 11);
$worksheet->set_column(31, 31, 16);

$worksheet->merge_range('B2:D2', 'CHAT',        $format2);
$worksheet->merge_range('E2:G2', 'EMAIL',       $format2);
$worksheet->merge_range('H2:J2', 'PHOTO',       $format2);
$worksheet->merge_range('K2:N2', 'UNLI',        $format2);
$worksheet->write(1, 14,         'BOOST',       $format21);
$worksheet->merge_range('P2:R2', 'SOCIAL',      $format2);
$worksheet->merge_range('S2:U2', 'LINE',        $format2);
$worksheet->write(1, 21,         'SNAPCHAT',    $format21);
$worksheet->write(1, 22,         'TUMBLR',      $format21);
$worksheet->write(1, 23,         'WAZE',        $format21);
$worksheet->merge_range('Y2:AA2','WE-CHAT',     $format2);
$worksheet->write(1, 27,         'FACEBOOK',    $format21);
$worksheet->write(1, 28,         'WIKIPEDIA',   $format21);
$worksheet->write(1, 29,         'FREE SOCIAL', $format21);
$worksheet->write(1, 30,         'PISONET',     $format21);
$worksheet->write(1, 31,         'BACK-TO-SCHOOL', $format21);

$worksheet->merge_range('B3:D3', 'HITS',        $format2R);
$worksheet->merge_range('E3:G3', 'HITS',        $format2R);
$worksheet->merge_range('H3:J3', 'HITS',        $format2R);
$worksheet->merge_range('K3:N3', 'HITS',        $format2R);
$worksheet->write(2, 14,         'HITS',        $format21R);
$worksheet->merge_range('P3:R3', 'HITS',        $format2R);
$worksheet->merge_range('S3:U3', 'HITS',        $format2R);
$worksheet->write(2, 21,         'HITS',        $format21R);
$worksheet->write(2, 22,         'HITS',        $format21R);
$worksheet->write(2, 23,         'HITS',        $format21R);
$worksheet->merge_range('Y3:AA3','HITS',        $format2R);
$worksheet->write(2, 27,         'HITS',        $format21R);
$worksheet->write(2, 28,         'HITS',        $format21R);
$worksheet->write(2, 29,         'HITS',        $format21R);
$worksheet->write(2, 30,         'HITS',        $format21R);
$worksheet->write(2, 31,         'HITS',        $format21R);
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
$worksheet->write($row+$i, $col+11, '24hrs (P20)', $format);
$worksheet->write($row+$i, $col+12, '24hrs (P30)', $format);
$worksheet->write($row+$i, $col+13, 'TOTAL',   $format);
$worksheet->write($row+$i, $col+14, '15mins',  $format);
$worksheet->write($row+$i, $col+15, '3hours',  $format);
$worksheet->write($row+$i, $col+16, '24hours', $format);
$worksheet->write($row+$i, $col+17, 'TOTAL',   $format);
$worksheet->write($row+$i, $col+18, '24hrs (P5) ', $format);
$worksheet->write($row+$i, $col+19, '24hrs (P10)', $format);
$worksheet->write($row+$i, $col+20, 'TOTAL',   $format);
$worksheet->write($row+$i, $col+21, '24hours', $format);
$worksheet->write($row+$i, $col+22, '24hours', $format);
$worksheet->write($row+$i, $col+23, '24hours', $format);
$worksheet->write($row+$i, $col+24, '24hrs (P5) ', $format);
$worksheet->write($row+$i, $col+25, '24hrs (P10)', $format);
$worksheet->write($row+$i, $col+26, 'TOTAL',   $format);
$worksheet->write($row+$i, $col+27, '24hours', $format);
$worksheet->write($row+$i, $col+28, '24hours', $format);
$worksheet->write($row+$i, $col+29, '24hours', $format);
$worksheet->write($row+$i, $col+30, '15mins',  $format);
$worksheet->write($row+$i, $col+31, '24hours', $format);

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
   $worksheet->write($row+$i, $col+12, $rowRst[12], $format1);
   $worksheet->write($row+$i, $col+13, $rowRst[13], $formatT);
   $worksheet->write($row+$i, $col+14, $rowRst[14], $formatT);
   $worksheet->write($row+$i, $col+15, $rowRst[15], $format1);
   $worksheet->write($row+$i, $col+16, $rowRst[16], $format1);
   $worksheet->write($row+$i, $col+17, $rowRst[17], $formatT);
   $worksheet->write($row+$i, $col+18, $rowRst[18], $format1);
   $worksheet->write($row+$i, $col+19, $rowRst[19], $format1);
   $worksheet->write($row+$i, $col+20, $rowRst[20], $formatT);
   $worksheet->write($row+$i, $col+21, $rowRst[21], $formatT);
   $worksheet->write($row+$i, $col+22, $rowRst[22], $formatT);
   $worksheet->write($row+$i, $col+23, $rowRst[23], $formatT);
   $worksheet->write($row+$i, $col+24, $rowRst[24], $format1);
   $worksheet->write($row+$i, $col+25, $rowRst[25], $format1);
   $worksheet->write($row+$i, $col+26, $rowRst[26], $formatT);
   $worksheet->write($row+$i, $col+27, $rowRst[27], $formatT);
   $worksheet->write($row+$i, $col+28, $rowRst[28], $formatT);
   $worksheet->write($row+$i, $col+29, $rowRst[29], $formatT);
   $worksheet->write($row+$i, $col+30, $rowRst[30], $formatT);
   $worksheet->write($row+$i, $col+31, $rowRst[31], $formatT);
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
                      unli_uniq_3, unli_uniq_24_pp, unli_uniq_24, unli_uniq_3+unli_uniq_24_pp+unli_uniq_24,
                      unli_hits_3, unli_hits_24_pp, unli_hits_24, unli_hits_3+unli_hits_24_pp+unli_hits_24,
                      unli_hits_3*15, unli_hits_24_pp*20, unli_hits_24*30, (unli_hits_3*15)+(unli_hits_24_pp*20)+(unli_hits_24*30),
                      social_uniq_3, social_uniq_24, social_uniq_3+social_uniq_24,
                      social_hits_3, social_hits_24, social_hits_3+social_hits_24,
                      social_hits_3*10, social_hits_24*20, (social_hits_3*10)+(social_hits_24*20),
                      speed_uniq, speed_hits, speed_hits*15,
                      line_uniq_24_pp, line_uniq_24, line_uniq_24_pp+line_uniq_24,
                      line_hits_24_pp, line_hits_24, line_hits_24_pp+line_hits_24,
                      line_hits_24_pp*5, line_hits_24*10, (line_hits_24_pp*5)+(line_hits_24*10),
                      snap_uniq_24, snap_hits_24, snap_hits_24*5,
                      tumblr_uniq_24, tumblr_hits_24, tumblr_hits_24*5,
                      waze_uniq_24, waze_hits_24, waze_hits_24*5,
                      wechat_uniq_24_pp, wechat_uniq_24, wechat_uniq_24_pp+wechat_uniq_24,
                      wechat_hits_24_pp, wechat_hits_24, wechat_hits_24_pp+wechat_hits_24, 
                      wechat_hits_24_pp*5, wechat_hits_24*10, (wechat_hits_24_pp*5)+(wechat_hits_24*10),
                      facebook_uniq_24, facebook_hits_24, facebook_hits_24*5,
                      wiki_uniq_24, wiki_hits_24, wiki_hits_24*0,
                      free_social_uniq_24, free_social_hits_24, free_social_hits_24*0,
                      piso_uniq_15, piso_hits_15, piso_hits_15*1,
                      school_uniq_24, school_hits_24, school_hits_24*5,
                      total_uniq, total_hits
                from  powerapp_validity_dailyrep
                where left(tran_dt,7) = '".$current_date."' 
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
$worksheet->set_column(31, 38, 8);
$worksheet->set_column(39, 42, 9);
$worksheet->set_column(43, 43, 1);
$worksheet->set_column(44, 49, 7);
$worksheet->set_column(50, 52, 9);
$worksheet->set_column(53, 53, 1);
$worksheet->set_column(54, 54, 11);
$worksheet->set_column(55, 56, 9);
$worksheet->set_column(57, 57, 1);
$worksheet->set_column(58, 63, 8);
$worksheet->set_column(64, 66, 9);
$worksheet->set_column(67, 67, 1);
$worksheet->set_column(68, 68, 11);
$worksheet->set_column(69, 70, 9);
$worksheet->set_column(71, 71, 1);
$worksheet->set_column(72, 72, 11);
$worksheet->set_column(73, 74, 9);
$worksheet->set_column(75, 75, 1);
$worksheet->set_column(76, 76, 11);
$worksheet->set_column(77, 78, 9);
$worksheet->set_column(79, 79, 1);
$worksheet->set_column(80, 85, 8);
$worksheet->set_column(86, 88, 9);
$worksheet->set_column(89, 89, 1);
$worksheet->set_column(90, 90, 11);
$worksheet->set_column(91, 92, 9);
$worksheet->set_column(93, 93, 1);
$worksheet->set_column(94, 94, 11);
$worksheet->set_column(95, 96, 9);
$worksheet->set_column(97, 97, 1);
$worksheet->set_column(98, 98, 11);
$worksheet->set_column(99,100, 9);
$worksheet->set_column(101,101,1);
$worksheet->set_column(102,102,11);
$worksheet->set_column(103,104,9);
$worksheet->set_column(105,105,1);
$worksheet->set_column(106,106,11);
$worksheet->set_column(107,108,9);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:J2',   'CHAT',         $formatC);
$worksheet->merge_range('L2:T2',   'EMAIL',        $formatE);
$worksheet->merge_range('V2:AD2',  'PHOTO',        $formatP);
$worksheet->merge_range('AF2:AQ2', 'UNLI',         $formatU);
$worksheet->merge_range('AS2:BA2', 'SOCIAL',       $formatS);
$worksheet->merge_range('BC2:BE2', 'SPEEDBOOST',   $formatB);
$worksheet->merge_range('BG2:BO2', 'LINE',         $formatB);
$worksheet->merge_range('BQ2:BS2', 'SNAPCHAT',     $formatB);
$worksheet->merge_range('BU2:BW2', 'TUMBLR',       $formatB);
$worksheet->merge_range('BY2:CA2', 'WAZE',         $formatB);
$worksheet->merge_range('CC2:CK2', 'WeCHAT',       $formatB);
$worksheet->merge_range('CM2:CO2', 'FACEBOOK',     $formatB);
$worksheet->merge_range('CQ2:CS2', 'WIKIPEDIA',    $formatB);
$worksheet->merge_range('CU2:CW2', 'FREE SOCIAL',  $formatB);
$worksheet->merge_range('CY2:DA2', 'PISONET',      $formatB);
$worksheet->merge_range('DC2:DE2', 'BACK-TO-SCHOOL',  $formatB);

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
$worksheet->merge_range('AF3:AI3', 'UNIQUE USERS', $formatU);
$worksheet->merge_range('AJ3:AM3', 'HITS', $formatU);
$worksheet->merge_range('AN3:AQ3', 'REVENUE', $formatU);
#SOCIAL
$worksheet->merge_range('AS3:AU3', 'UNIQUE USERS', $formatS);
$worksheet->merge_range('AV3:AX3', 'HITS', $formatS);
$worksheet->merge_range('AY3:BA3', 'REVENUE', $formatS);
#SPEEDBOOST
$worksheet->write(2, 54, 'UNIQUE USERS', $format);
$worksheet->write(2, 55, 'HITS', $format);
$worksheet->write(2, 56, 'REVENUE', $format);
#LINE
$worksheet->merge_range('BG3:BI3', 'UNIQUE USERS', $formatS);
$worksheet->merge_range('BJ3:BL3', 'HITS', $formatS);
$worksheet->merge_range('BM3:BO3', 'REVENUE', $formatS);
#SNAPCHAT
$worksheet->write(2, 68, 'UNIQUE USERS', $format);
$worksheet->write(2, 69, 'HITS', $format);
$worksheet->write(2, 70, 'REVENUE', $format);
#TUMBLR
$worksheet->write(2, 72, 'UNIQUE USERS', $format);
$worksheet->write(2, 73, 'HITS', $format);
$worksheet->write(2, 74, 'REVENUE', $format);
#WAZE
$worksheet->write(2, 76, 'UNIQUE USERS', $format);
$worksheet->write(2, 77, 'HITS', $format);
$worksheet->write(2, 78, 'REVENUE', $format);
#WeCHAT
$worksheet->merge_range('CC3:CE3', 'UNIQUE USERS', $formatS);
$worksheet->merge_range('CF3:CH3', 'HITS', $formatS);
$worksheet->merge_range('CI3:CK3', 'REVENUE', $formatS);
#FACEBOOK
$worksheet->write(2, 90, 'UNIQUE USERS', $format);
$worksheet->write(2, 91, 'HITS', $format);
$worksheet->write(2, 92, 'REVENUE', $format);
#WIKIPEDIA
$worksheet->write(2, 94, 'UNIQUE USERS', $format);
$worksheet->write(2, 95, 'HITS', $format);
$worksheet->write(2, 96, 'REVENUE', $format);
#FREE-SOCIAL
$worksheet->write(2, 98, 'UNIQUE USERS', $format);
$worksheet->write(2, 99, 'HITS', $format);
$worksheet->write(2,100, 'REVENUE', $format);
#PISONET
$worksheet->write(2,102, 'UNIQUE USERS', $format);
$worksheet->write(2,103, 'HITS', $format);
$worksheet->write(2,104, 'REVENUE', $format);
#BACK-TO-SCHOOL
$worksheet->write(2,106, 'UNIQUE USERS', $format);
$worksheet->write(2,107, 'HITS', $format);
$worksheet->write(2,108, 'REVENUE', $format);

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
$worksheet->write($row+$i, $col+32, '24hrs (P5)',  $format);
$worksheet->write($row+$i, $col+33, '24hrs (P10)', $format);
$worksheet->write($row+$i, $col+34, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+35, '3 hours',     $format);
$worksheet->write($row+$i, $col+36, '24hrs (P5)',  $format);
$worksheet->write($row+$i, $col+37, '24hrs (P10)', $format);
$worksheet->write($row+$i, $col+38, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+39, 'P15 (3hrs)',  $format);
$worksheet->write($row+$i, $col+40, 'P20 (24hrs)', $format);
$worksheet->write($row+$i, $col+41, 'P30 (24hrs)', $format);
$worksheet->write($row+$i, $col+42, 'GROSS REV',   $format);
$worksheet->write($row+$i, $col+44, '3 hours',     $format);
$worksheet->write($row+$i, $col+45, '24 hours',    $format);
$worksheet->write($row+$i, $col+46, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+47, '3 hours',     $format);
$worksheet->write($row+$i, $col+48, '24 hours',    $format);
$worksheet->write($row+$i, $col+49, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+50, 'P10 (3hrs)',  $format);
$worksheet->write($row+$i, $col+51, 'P20 (24hrs)', $format);
$worksheet->write($row+$i, $col+52, 'GROSS REV',   $format);
$worksheet->write($row+$i, $col+54, '15 mins',     $format);
$worksheet->write($row+$i, $col+55, '15 mins',     $format);
$worksheet->write($row+$i, $col+56, 'P5 (15mins)', $format);
$worksheet->write($row+$i, $col+58, '24hrs (P5)',  $format);
$worksheet->write($row+$i, $col+59, '24hrs (P10)', $format);
$worksheet->write($row+$i, $col+60, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+61, '24hrs (P5)',  $format);
$worksheet->write($row+$i, $col+62, '24hrs (P10)', $format);
$worksheet->write($row+$i, $col+63, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+64, 'P5 (24hrs)',  $format);
$worksheet->write($row+$i, $col+65, 'P10 (24hrs)', $format);
$worksheet->write($row+$i, $col+66, 'GROSS REV',   $format);
$worksheet->write($row+$i, $col+68, '24 hours',    $format);
$worksheet->write($row+$i, $col+69, '24 hours',    $format);
$worksheet->write($row+$i, $col+70, 'P5 (24hrs)',  $format);
$worksheet->write($row+$i, $col+72, '24 hours',    $format);
$worksheet->write($row+$i, $col+73, '24 hours',    $format);
$worksheet->write($row+$i, $col+74, 'P5 (24hrs)',  $format);
$worksheet->write($row+$i, $col+76, '24 hours',    $format);
$worksheet->write($row+$i, $col+77, '24 hours',    $format);
$worksheet->write($row+$i, $col+78, 'P5 (24hrs)',  $format);
$worksheet->write($row+$i, $col+80, '24hrs (P5)',  $format);
$worksheet->write($row+$i, $col+81, '24hrs (P10)', $format);
$worksheet->write($row+$i, $col+82, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+83, '24hrs (P5)',  $format);
$worksheet->write($row+$i, $col+84, '24hrs (P10)', $format);
$worksheet->write($row+$i, $col+85, 'TOTAL',       $format);
$worksheet->write($row+$i, $col+86, 'P5 (24hrs)',  $format);
$worksheet->write($row+$i, $col+87, 'P10 (24hrs)', $format);
$worksheet->write($row+$i, $col+88, 'GROSS REV',   $format);
$worksheet->write($row+$i, $col+90, '24 hours',    $format);
$worksheet->write($row+$i, $col+91, '24 hours',    $format);
$worksheet->write($row+$i, $col+92, 'P5 (24hrs)',  $format);
$worksheet->write($row+$i, $col+94, '24 hours',    $format);
$worksheet->write($row+$i, $col+95, '24 hours',    $format);
$worksheet->write($row+$i, $col+96, 'FREE',        $format);
$worksheet->write($row+$i, $col+98, '24 hours',    $format);
$worksheet->write($row+$i, $col+99, '24 hours',    $format);
$worksheet->write($row+$i, $col+100,'FREE',        $format);
$worksheet->write($row+$i, $col+102,'15 mins',     $format);
$worksheet->write($row+$i, $col+103,'15 mins',     $format);
$worksheet->write($row+$i, $col+104,'P1 (15mins)', $format);
$worksheet->write($row+$i, $col+106,'24 hours',    $format);
$worksheet->write($row+$i, $col+107,'24 hours',    $format);
$worksheet->write($row+$i, $col+108,'P5 (24hrs)',  $format);

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
   $worksheet->write($row+$i, $col+37, $rowRst[34], $format1);
   $worksheet->write($row+$i, $col+38, $rowRst[35], $format1);
   $worksheet->write($row+$i, $col+39, $rowRst[36], $formatT);
   $worksheet->write($row+$i, $col+40, $rowRst[37], $formatT);
   $worksheet->write($row+$i, $col+41, $rowRst[38], $formatT);
   $worksheet->write($row+$i, $col+42, $rowRst[39], $formatT);
   $worksheet->write($row+$i, $col+44, $rowRst[40], $format1);
   $worksheet->write($row+$i, $col+45, $rowRst[41], $format1);
   $worksheet->write($row+$i, $col+46, $rowRst[42], $format1);
   $worksheet->write($row+$i, $col+47, $rowRst[43], $format1);
   $worksheet->write($row+$i, $col+48, $rowRst[44], $format1);
   $worksheet->write($row+$i, $col+49, $rowRst[45], $format1);
   $worksheet->write($row+$i, $col+50, $rowRst[46], $formatT);
   $worksheet->write($row+$i, $col+51, $rowRst[47], $formatT);
   $worksheet->write($row+$i, $col+52, $rowRst[48], $formatT);
   $worksheet->write($row+$i, $col+54, $rowRst[49], $format1);
   $worksheet->write($row+$i, $col+55, $rowRst[50], $format1);
   $worksheet->write($row+$i, $col+56, $rowRst[51], $formatT);
   $worksheet->write($row+$i, $col+58, $rowRst[52], $format1);
   $worksheet->write($row+$i, $col+59, $rowRst[53], $format1);
   $worksheet->write($row+$i, $col+60, $rowRst[54], $format1);
   $worksheet->write($row+$i, $col+61, $rowRst[55], $format1);
   $worksheet->write($row+$i, $col+62, $rowRst[56], $format1);
   $worksheet->write($row+$i, $col+63, $rowRst[57], $format1);
   $worksheet->write($row+$i, $col+64, $rowRst[58], $formatT);
   $worksheet->write($row+$i, $col+65, $rowRst[59], $formatT);
   $worksheet->write($row+$i, $col+66, $rowRst[60], $formatT);
   $worksheet->write($row+$i, $col+68, $rowRst[61], $format1);
   $worksheet->write($row+$i, $col+69, $rowRst[62], $format1);
   $worksheet->write($row+$i, $col+70, $rowRst[63], $formatT);
   $worksheet->write($row+$i, $col+72, $rowRst[64], $format1);
   $worksheet->write($row+$i, $col+73, $rowRst[65], $format1);
   $worksheet->write($row+$i, $col+74, $rowRst[66], $formatT);
   $worksheet->write($row+$i, $col+76, $rowRst[67], $format1);
   $worksheet->write($row+$i, $col+77, $rowRst[68], $format1);
   $worksheet->write($row+$i, $col+78, $rowRst[69], $formatT);
   $worksheet->write($row+$i, $col+80, $rowRst[70], $format1);
   $worksheet->write($row+$i, $col+81, $rowRst[71], $format1);
   $worksheet->write($row+$i, $col+82, $rowRst[72], $format1);
   $worksheet->write($row+$i, $col+83, $rowRst[73], $format1);
   $worksheet->write($row+$i, $col+84, $rowRst[74], $format1);
   $worksheet->write($row+$i, $col+85, $rowRst[75], $format1);
   $worksheet->write($row+$i, $col+86, $rowRst[76], $formatT);
   $worksheet->write($row+$i, $col+87, $rowRst[77], $formatT);
   $worksheet->write($row+$i, $col+88, $rowRst[78], $formatT);
   $worksheet->write($row+$i, $col+90, $rowRst[79], $format1);
   $worksheet->write($row+$i, $col+91, $rowRst[80], $format1);
   $worksheet->write($row+$i, $col+92, $rowRst[81], $formatT);
   $worksheet->write($row+$i, $col+94, $rowRst[82], $format1);
   $worksheet->write($row+$i, $col+95, $rowRst[83], $format1);
   $worksheet->write($row+$i, $col+96, $rowRst[84], $formatT);
   $worksheet->write($row+$i, $col+98, $rowRst[85], $format1);
   $worksheet->write($row+$i, $col+99, $rowRst[86], $format1);
   $worksheet->write($row+$i, $col+100,$rowRst[87], $formatT);
   $worksheet->write($row+$i, $col+102,$rowRst[88], $format1);
   $worksheet->write($row+$i, $col+103,$rowRst[89], $format1);
   $worksheet->write($row+$i, $col+104,$rowRst[90], $formatT);
   $worksheet->write($row+$i, $col+106,$rowRst[91], $format1);
   $worksheet->write($row+$i, $col+107,$rowRst[92], $format1);
   $worksheet->write($row+$i, $col+108,$rowRst[93], $formatT);
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
   $myFormula = "SUM(AN5:AN".$lrow.")";
   $worksheet->write_formula($row+$i, $col+39, '='.($myFormula), $formatT);
   $myFormula = "SUM(AO5:AO".$lrow.")";
   $worksheet->write_formula($row+$i, $col+40, '='.($myFormula), $formatT);
   $myFormula = "SUM(AP5:AP".$lrow.")";
   $worksheet->write_formula($row+$i, $col+41, '='.($myFormula), $formatT);
   $myFormula = "SUM(AQ5:AQ".$lrow.")";
   $worksheet->write_formula($row+$i, $col+42, '='.($myFormula), $formatT);
   $myFormula = "SUM(AY5:AY".$lrow.")";
   $worksheet->write_formula($row+$i, $col+50, '='.($myFormula), $formatT);
   $myFormula = "SUM(AZ5:AZ".$lrow.")";
   $worksheet->write_formula($row+$i, $col+51, '='.($myFormula), $formatT);
   $myFormula = "SUM(BA5:BA".$lrow.")";
   $worksheet->write_formula($row+$i, $col+52, '='.($myFormula), $formatT);
   $myFormula = "SUM(BE5:BE".$lrow.")";
   $worksheet->write_formula($row+$i, $col+56, '='.($myFormula), $formatT);
   $myFormula = "SUM(BM5:BM".$lrow.")";
   $worksheet->write_formula($row+$i, $col+64, '='.($myFormula), $formatT);
   $myFormula = "SUM(BN5:BN".$lrow.")";
   $worksheet->write_formula($row+$i, $col+65, '='.($myFormula), $formatT);
   $myFormula = "SUM(BO5:BO".$lrow.")";
   $worksheet->write_formula($row+$i, $col+66, '='.($myFormula), $formatT);
   $myFormula = "SUM(BS5:BS".$lrow.")";
   $worksheet->write_formula($row+$i, $col+70, '='.($myFormula), $formatT);
   $myFormula = "SUM(BW5:BW".$lrow.")";
   $worksheet->write_formula($row+$i, $col+74, '='.($myFormula), $formatT);
   $myFormula = "SUM(CA5:CA".$lrow.")";
   $worksheet->write_formula($row+$i, $col+78, '='.($myFormula), $formatT);
   $myFormula = "SUM(CI5:CI".$lrow.")";
   $worksheet->write_formula($row+$i, $col+86, '='.($myFormula), $formatT);
   $myFormula = "SUM(CJ5:CJ".$lrow.")";
   $worksheet->write_formula($row+$i, $col+87, '='.($myFormula), $formatT);
   $myFormula = "SUM(CK5:CK".$lrow.")";
   $worksheet->write_formula($row+$i, $col+88, '='.($myFormula), $formatT);
   $myFormula = "SUM(CO5:CO".$lrow.")";
   $worksheet->write_formula($row+$i, $col+92, '='.($myFormula), $formatT);
   $myFormula = "SUM(CS5:CS".$lrow.")";
   $worksheet->write_formula($row+$i, $col+96, '='.($myFormula), $formatT);
   $myFormula = "SUM(CW5:CW".$lrow.")";
   $worksheet->write_formula($row+$i, $col+100,'='.($myFormula), $formatT);
   $myFormula = "SUM(DA5:DA".$lrow.")";
   $worksheet->write_formula($row+$i, $col+104,'='.($myFormula), $formatT);
   $myFormula = "SUM(DE5:DE".$lrow.")";
   $worksheet->write_formula($row+$i, $col+108,'='.($myFormula), $formatT);



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




