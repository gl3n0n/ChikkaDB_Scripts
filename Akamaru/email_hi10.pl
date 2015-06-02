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

my $dbh_hi10  = DB::DBconnect(myconstants::HI10_DB,myconstants::HI10_HOST,myconstants::HI10_USER,myconstants::HI10_PASSWORD);
my $dbh_hi10a = DB::DBconnect(myconstants::HI10A_DB,myconstants::HI10A_HOST,myconstants::HI10A_USER,myconstants::HI10A_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
my $sth_hi_10;
my $sth_hi_10a;
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
                      a.facebook_hits, a.wiki_hits, a.free_social_hits, piso_hits, school_hits, 
                      a.youtube_hits, a.fy5_hits, a.myvolume_hits, 
                      a.unli_uniq, a.email_uniq, a.chat_uniq,   a.photo_uniq, a.social_uniq, a.speed_uniq, 
                      a.line_uniq, a.snap_uniq,  a.tumblr_uniq, a.waze_uniq,  a.wechat_uniq, 
                      a.facebook_uniq, a.wiki_uniq, a.free_social_uniq, piso_uniq, school_uniq, 
                      a.youtube_uniq, a.fy5_uniq, a.myvolume_uniq, 
                      a.total_hits, a.num_optout, 
                      IFNULL(b.num_subs,0) num_subs, a.concurrent_max_subs, a.concurrent_max_tm, a.concurrent_avg_subs,
                      a.total_uniq, a.num_uniq_30d, 
                      IF(a.tran_dt=last_day(a.tran_dt), concat(date_format(concat(left(a.tran_dt,8),'01') , '%b-%d'), ' to ', date_format(a.tran_dt, '%b-%d')), 
                                                        concat(date_format(date_sub(a.tran_dt, interval 30 day), '%b-%d'), ' to ', date_format(a.tran_dt, '%b-%d'))
                        ) period_covered,
                      a.buddy_uniq, a.postpd_uniq, a.tnt_uniq, a.sun_uniq, a.tnt_auto_rn, a.buddy_auto_rn,
                      c.from_selected, c.to_selected
               from powerapp_dailyrep a left outer join powerapp_concurrent_subs b on a.tran_dt = b.tran_dt 
                                        left outer join upload_download_bandwidth c on a.tran_dt = c.tran_dt 
               where left(a.tran_dt,7) = '".$current_date."' and a.tran_dt < curdate() 
               order by a.tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

$strSQLhi10a = "select DATE_FORMAT(a.tran_dt,'%m/%d/%Y') tran_dt, 
                      a.buddy, a.postpd, a.tnt, a.others, a.total
               from powerapp_apn_stats a
               where left(a.tran_dt,7) = '".$current_date."' 
               order by a.tran_dt";
$sth_hi_10a = $dbh_hi10a->prepare($strSQLhi10a);
$sth_hi_10a->execute();

# Write a formatted and unformatted string, row and column notation.
$row = 1;
$col = 0;
$i=1;
$worksheet[0]->merge_range($row, $col+ 1, $row, $col+19, 'Hits per Package',        $format2);
$worksheet[0]->merge_range($row, $col+21, $row, $col+39, 'Unique Subs per Package', $format2);
$worksheet[0]->merge_range($row, $col+41, $row, $col+42, 'Hits & Optout per Day',   $format2);
$worksheet[0]->merge_range($row, $col+44, $row, $col+47, 'MINs in Chikka APN',      $format2);
$worksheet[0]->merge_range($row, $col+49, $row, $col+51, 'Unique Subs',             $format2);
$worksheet[0]->merge_range($row, $col+53, $row, $col+56, 'Active Subs per Brand',   $format2);
$worksheet[0]->merge_range($row, $col+58, $row, $col+59, 'Liberation Auto-Renewal', $format2);
$worksheet[0]->merge_range($row, $col+61, $row, $col+65, 'MINs in Chikka APN', $format2);
$worksheet[0]->merge_range($row, $col+67, $row, $col+68, 'Powerapp BANDWIDTH', $format2);

$worksheet[0]->set_column(0,0,9);
$worksheet[0]->set_column(1,1,9);
$worksheet[0]->set_column(2,5,6);
$worksheet[0]->set_column(6,6,10);
$worksheet[0]->set_column(7,7,6);
$worksheet[0]->set_column(8,8,8);
$worksheet[0]->set_column(9,11,6);
$worksheet[0]->set_column(12,15,9);
$worksheet[0]->set_column(16,16,13);
$worksheet[0]->set_column(17,19,9);
$worksheet[0]->set_column(20,20,1);
$worksheet[0]->set_column(21,22,6);
$worksheet[0]->set_column(23,23,10);
$worksheet[0]->set_column(24,24,6);
$worksheet[0]->set_column(25,25,8);
$worksheet[0]->set_column(26,27,6);
$worksheet[0]->set_column(28,33,9);
$worksheet[0]->set_column(34,35,10);
$worksheet[0]->set_column(36,36,13);
$worksheet[0]->set_column(37,39,9);
$worksheet[0]->set_column(40,40,1);
$worksheet[0]->set_column(41,42,10);
$worksheet[0]->set_column(43,43,1);
$worksheet[0]->set_column(44,44,8);
$worksheet[0]->set_column(45,45,12);
$worksheet[0]->set_column(46,46,8);
$worksheet[0]->set_column(47,47,12);
$worksheet[0]->set_column(48,48,1);
$worksheet[0]->set_column(49,50,12);
$worksheet[0]->set_column(51,51,16);
$worksheet[0]->set_column(52,52,1);
$worksheet[0]->set_column(53,56,9);
$worksheet[0]->set_column(57,57,1);
$worksheet[0]->set_column(58,59,12);
$worksheet[0]->set_column(60,60,1);
$worksheet[0]->set_column(61,65,12);
$worksheet[0]->set_column(66,66,1);
$worksheet[0]->set_column(67,68,16);
#
$worksheet[0]->write($row+$i, $col,     'DATE',           $format);
$worksheet[0]->write($row+$i, $col+1,   'UNLI',           $format);
$worksheet[0]->write($row+$i, $col+2,   'EMAIL',          $format);
$worksheet[0]->write($row+$i, $col+3,   'CHAT',           $format);
$worksheet[0]->write($row+$i, $col+4,   'PHOTO',          $format);
$worksheet[0]->write($row+$i, $col+5,   'SOCIAL',         $format);
$worksheet[0]->write($row+$i, $col+6,   'SPEEDBOOST',     $format);
$worksheet[0]->write($row+$i, $col+7,   'LINE',           $format);
$worksheet[0]->write($row+$i, $col+8,   'SNAPCHAT',       $format);
$worksheet[0]->write($row+$i, $col+9,   'TUMBLR',         $format);
$worksheet[0]->write($row+$i, $col+10,  'WAZE',           $format);
$worksheet[0]->write($row+$i, $col+11,  'WeCHAT',         $format);
$worksheet[0]->write($row+$i, $col+12,  'FACEBOOK',       $format);
$worksheet[0]->write($row+$i, $col+13,  'WIKIPEDIA',      $format);
$worksheet[0]->write($row+$i, $col+14,  'FREE SOCIAL',    $format);
$worksheet[0]->write($row+$i, $col+15,  'PISONET',        $format);
$worksheet[0]->write($row+$i, $col+16,  'BACK-TO-SCHOOL', $format);
$worksheet[0]->write($row+$i, $col+17,  'VIDEO',          $format);
$worksheet[0]->write($row+$i, $col+18,  'FY5',            $format);
$worksheet[0]->write($row+$i, $col+19,  'LIBERATION',     $format);

$worksheet[0]->write($row+$i, $col+21,  'UNLI',           $format);
$worksheet[0]->write($row+$i, $col+22,  'EMAIL',          $format);
$worksheet[0]->write($row+$i, $col+23,  'CHAT',           $format);
$worksheet[0]->write($row+$i, $col+24,  'PHOTO',          $format);
$worksheet[0]->write($row+$i, $col+25,  'SOCIAL',         $format);
$worksheet[0]->write($row+$i, $col+26,  'SPEEDBOOST',     $format);
$worksheet[0]->write($row+$i, $col+27,  'LINE',           $format);
$worksheet[0]->write($row+$i, $col+28,  'SNAPCHAT',       $format);
$worksheet[0]->write($row+$i, $col+29,  'TUMBLR',         $format);
$worksheet[0]->write($row+$i, $col+30,  'WAZE',           $format);
$worksheet[0]->write($row+$i, $col+31,  'WeCHAT',         $format);
$worksheet[0]->write($row+$i, $col+32,  'FACEBOOK',       $format);
$worksheet[0]->write($row+$i, $col+33,  'WIKIPEDIA',      $format);
$worksheet[0]->write($row+$i, $col+34,  'FREE SOCIAL',    $format);
$worksheet[0]->write($row+$i, $col+35,  'PISONET',        $format);
$worksheet[0]->write($row+$i, $col+36,  'BACK-TO-SCHOOL', $format);
$worksheet[0]->write($row+$i, $col+37,  'VIDEO',          $format);
$worksheet[0]->write($row+$i, $col+38,  'FY5',            $format);
$worksheet[0]->write($row+$i, $col+39,  'LIBERATION',     $format);

$worksheet[0]->write($row+$i, $col+41,  'HITS',           $format);
$worksheet[0]->write($row+$i, $col+42,  'OPTOUT',         $format);

$worksheet[0]->write($row+$i, $col+44,  'TOTAL',          $format);
$worksheet[0]->write($row+$i, $col+45,  'Max Concurrent', $format);
$worksheet[0]->write($row+$i, $col+46,  'TIME',           $format);
$worksheet[0]->write($row+$i, $col+47,  'Avg Concurrent', $format);

$worksheet[0]->write($row+$i, $col+49,  'Daily UNIQ',     $format);
$worksheet[0]->write($row+$i, $col+50,  'Monthly UNIQ',   $format);
$worksheet[0]->write($row+$i, $col+51,  'Monthly (Start-End)', $format);

$worksheet[0]->write($row+$i, $col+53,  'PREPAID',        $format);
$worksheet[0]->write($row+$i, $col+54,  'POSTPAID',       $format);
$worksheet[0]->write($row+$i, $col+55,  'TNT',            $format);
$worksheet[0]->write($row+$i, $col+56,  'SUN',            $format);

$worksheet[0]->write($row+$i, $col+58,  'TNT',            $format);
$worksheet[0]->write($row+$i, $col+59,  'BUDDY',          $format);

$worksheet[0]->write($row+$i, $col+61,  'PREPAID',        $format);
$worksheet[0]->write($row+$i, $col+62,  'POSTPAID',       $format);
$worksheet[0]->write($row+$i, $col+63,  'TNT',            $format);
$worksheet[0]->write($row+$i, $col+64,  'OTHERS',         $format);
$worksheet[0]->write($row+$i, $col+65,  'TOTAL',          $format);

$worksheet[0]->write($row+$i, $col+67,  'RECEIVED',       $format);
$worksheet[0]->write($row+$i, $col+68,  'TRANSMIT',     $format);

while (@rowRst = $sth_hi_10a->fetchrow()) {
   $i++;
   $worksheet[0]->write($row+$i, $col+61,   $rowRst[1],   $format1);
   $worksheet[0]->write($row+$i, $col+62,   $rowRst[2],   $format1);
   $worksheet[0]->write($row+$i, $col+63,   $rowRst[3],   $format1);
   $worksheet[0]->write($row+$i, $col+64,   $rowRst[4],   $format1);
   $worksheet[0]->write($row+$i, $col+65,   $rowRst[5],   $format1);
}

$i=1;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   $worksheet[0]->write($row+$i, $col,     $rowRst[0],   $format1);
   $worksheet[0]->write($row+$i, $col+1,   $rowRst[1],   $format1);
   $worksheet[0]->write($row+$i, $col+2,   $rowRst[2],   $format1);
   $worksheet[0]->write($row+$i, $col+3,   $rowRst[3],   $format1);
   $worksheet[0]->write($row+$i, $col+4,   $rowRst[4],   $format1);
   $worksheet[0]->write($row+$i, $col+5,   $rowRst[5],   $format1);
   $worksheet[0]->write($row+$i, $col+6,   $rowRst[6],   $format1);
   $worksheet[0]->write($row+$i, $col+7,   $rowRst[7],   $format1);
   $worksheet[0]->write($row+$i, $col+8,   $rowRst[8],   $format1);
   $worksheet[0]->write($row+$i, $col+9,   $rowRst[9],   $format1);
   $worksheet[0]->write($row+$i, $col+10,  $rowRst[10],  $format1);
   $worksheet[0]->write($row+$i, $col+11,  $rowRst[11],  $format1);
   $worksheet[0]->write($row+$i, $col+12,  $rowRst[12],  $format1);
   $worksheet[0]->write($row+$i, $col+13,  $rowRst[13],  $format1);
   $worksheet[0]->write($row+$i, $col+14,  $rowRst[14],  $format1);
   $worksheet[0]->write($row+$i, $col+15,  $rowRst[15],  $format1);
   $worksheet[0]->write($row+$i, $col+16,  $rowRst[16],  $format1);
   $worksheet[0]->write($row+$i, $col+17,  $rowRst[17],  $format1);
   $worksheet[0]->write($row+$i, $col+18,  $rowRst[18] , $format1);
   $worksheet[0]->write($row+$i, $col+19,  $rowRst[19] , $format1);
   $worksheet[0]->write($row+$i, $col+21,  $rowRst[20] , $format1);
   $worksheet[0]->write($row+$i, $col+22,  $rowRst[21],  $format1);
   $worksheet[0]->write($row+$i, $col+23,  $rowRst[22],  $format1);
   $worksheet[0]->write($row+$i, $col+24,  $rowRst[23],  $format1);
   $worksheet[0]->write($row+$i, $col+25,  $rowRst[24],  $format1);
   $worksheet[0]->write($row+$i, $col+26,  $rowRst[25],  $format1);
   $worksheet[0]->write($row+$i, $col+27,  $rowRst[26],  $format1);
   $worksheet[0]->write($row+$i, $col+28,  $rowRst[27],  $format1);
   $worksheet[0]->write($row+$i, $col+29,  $rowRst[28],  $format1);
   $worksheet[0]->write($row+$i, $col+30,  $rowRst[29],  $format1);
   $worksheet[0]->write($row+$i, $col+31,  $rowRst[30],  $format1);
   $worksheet[0]->write($row+$i, $col+32,  $rowRst[31],  $format1);
   $worksheet[0]->write($row+$i, $col+33,  $rowRst[32],  $format1);
   $worksheet[0]->write($row+$i, $col+34,  $rowRst[33],  $format1);
   $worksheet[0]->write($row+$i, $col+35,  $rowRst[34],  $format1);
   $worksheet[0]->write($row+$i, $col+36,  $rowRst[35],  $format1);
   $worksheet[0]->write($row+$i, $col+37,  $rowRst[36],  $format1);
   $worksheet[0]->write($row+$i, $col+38,  $rowRst[37],  $format1);
   $worksheet[0]->write($row+$i, $col+39,  $rowRst[38],  $format1);
   $worksheet[0]->write($row+$i, $col+41,  $rowRst[39],  $format1);
   $worksheet[0]->write($row+$i, $col+42,  $rowRst[40],  $format1);
   $worksheet[0]->write($row+$i, $col+44,  $rowRst[41],  $format1);
   $worksheet[0]->write($row+$i, $col+45,  $rowRst[42],  $format1s);
   $worksheet[0]->write($row+$i, $col+46,  $rowRst[43],  $format1);
   $worksheet[0]->write($row+$i, $col+47,  $rowRst[44],  $format1);
   $worksheet[0]->write($row+$i, $col+49,  $rowRst[45],  $format1);
   $worksheet[0]->write($row+$i, $col+50,  $rowRst[46],  $format1);
   $worksheet[0]->write($row+$i, $col+51,  $rowRst[47],  $format1);
   $worksheet[0]->write($row+$i, $col+53,  $rowRst[48],  $format1);
   $worksheet[0]->write($row+$i, $col+54,  $rowRst[49],  $format1);
   $worksheet[0]->write($row+$i, $col+55,  $rowRst[50],  $format1);
   $worksheet[0]->write($row+$i, $col+56,  $rowRst[51],  $format1);
   $worksheet[0]->write($row+$i, $col+58,  $rowRst[52],  $format1);
   $worksheet[0]->write($row+$i, $col+59,  $rowRst[53],  $format1);
   $worksheet[0]->write($row+$i, $col+67,  $rowRst[54],  $format1);
   $worksheet[0]->write($row+$i, $col+68,  $rowRst[55],  $format1);
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
                      facebook_hits_24, wiki_hits_24, free_social_hits_24,
                      piso_hits_15, school_hits_24,
                      youtube_hits_5+youtube_hits_15+youtube_hits_50+youtube_hits_120,
                      fy5_hits_5
                from  powerapp_validity_dailyrep
                where left(tran_dt,7) = '".$current_date."' 
                order by tran_dt";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

# Write a formatted and unformatted string, row and column notation.
$worksheet[1]->set_column(8,   8, 11); # Snapchat
$worksheet[1]->set_column(12, 13, 11); # FB and WIKI
$worksheet[1]->set_column(16, 16, 16); # BACK-TO-SCHOOL

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
$worksheet[1]->write($row, $col+15, 'PISONET',        $format21);
$worksheet[1]->write($row, $col+16, 'BACK-TO-SCHOOL', $format21);
$worksheet[1]->write($row, $col+17, 'VIDEO',          $format21);
$worksheet[1]->write($row, $col+18, 'FY5',            $format21);
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
$worksheet[1]->write($row, $col+16, 'HITS', $format21R);
$worksheet[1]->write($row, $col+17, 'HITS', $format21R);
$worksheet[1]->write($row, $col+18, 'HITS', $format21R);
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
$worksheet[1]->write($row, $col+16, 'TOTAL',       $format);
$worksheet[1]->write($row, $col+17, 'TOTAL',       $format);
$worksheet[1]->write($row, $col+18, 'TOTAL',       $format);

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
   $worksheet[1]->write($row, $col+16, $rowRst[16], $format1);
   $worksheet[1]->write($row, $col+17, $rowRst[17], $format1);
   $worksheet[1]->write($row, $col+18, $rowRst[18], $format1);
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
                      piso_uniq_15, piso_hits_15, piso_hits_15*1,
                      school_uniq_24, school_hits_24, school_hits_24*5,
                      youtube_uniq_5, youtube_hits_5, youtube_hits_5*5,
                      youtube_uniq_15, youtube_hits_15, youtube_hits_15*15,
                      youtube_uniq_50, youtube_hits_50, youtube_hits_50*50,
                      youtube_uniq_120, youtube_hits_120, youtube_hits_120*120,
                      fy5_uniq_5, fy5_hits_5, fy5_hits_5*5,
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
$worksheet[2]->merge_range($row,$col+57,$row,$col+59, 'PISONET',         $formatB);
$worksheet[2]->merge_range($row,$col+61,$row,$col+63, 'BACK-TO-SCHOOL',  $formatB);
$worksheet[2]->merge_range($row,$col+65,$row,$col+67, 'VIDEO 5',         $formatB);
$worksheet[2]->merge_range($row,$col+69,$row,$col+71, 'VIDEO 15',        $formatB);
$worksheet[2]->merge_range($row,$col+73,$row,$col+75, 'VIDEO 50',        $formatB);
$worksheet[2]->merge_range($row,$col+77,$row,$col+79, 'VIDEO 120',       $formatB);
$worksheet[2]->merge_range($row,$col+81,$row,$col+83, 'FY 5',            $formatB);

$row++;
$col=0;
$worksheet[2]->write($row+1, $col, 'DATE', $format);
for ($i=0;$i<21;$i++){
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
   $worksheet[2]->write($row, $col,     $rowRst[0],  $formatT);
   $worksheet[2]->write($row, $col+1,   $rowRst[1],  $format1);
   $worksheet[2]->write($row, $col+2,   $rowRst[2],  $format1);
   $worksheet[2]->write($row, $col+3,   $rowRst[3],  $formatT);
   $worksheet[2]->write($row, $col+5,   $rowRst[4],  $format1);
   $worksheet[2]->write($row, $col+6,   $rowRst[5],  $format1);
   $worksheet[2]->write($row, $col+7,   $rowRst[6],  $formatT);
   $worksheet[2]->write($row, $col+9,   $rowRst[7],  $format1);
   $worksheet[2]->write($row, $col+10,  $rowRst[8],  $format1);
   $worksheet[2]->write($row, $col+11,  $rowRst[9],  $formatT);
   $worksheet[2]->write($row, $col+13,  $rowRst[10], $format1);
   $worksheet[2]->write($row, $col+14,  $rowRst[11], $format1);
   $worksheet[2]->write($row, $col+15,  $rowRst[12], $formatT);
   $worksheet[2]->write($row, $col+17,  $rowRst[13], $format1);
   $worksheet[2]->write($row, $col+18,  $rowRst[14], $format1);
   $worksheet[2]->write($row, $col+19,  $rowRst[15], $formatT);
   $worksheet[2]->write($row, $col+21,  $rowRst[16], $format1);
   $worksheet[2]->write($row, $col+22,  $rowRst[17], $format1);
   $worksheet[2]->write($row, $col+23,  $rowRst[18], $formatT);
   $worksheet[2]->write($row, $col+25,  $rowRst[19], $format1);
   $worksheet[2]->write($row, $col+26,  $rowRst[20], $format1);
   $worksheet[2]->write($row, $col+27,  $rowRst[21], $formatT);
   $worksheet[2]->write($row, $col+29,  $rowRst[22], $format1);
   $worksheet[2]->write($row, $col+30,  $rowRst[23], $format1);
   $worksheet[2]->write($row, $col+31,  $rowRst[24], $formatT);
   $worksheet[2]->write($row, $col+33,  $rowRst[25], $format1);
   $worksheet[2]->write($row, $col+34,  $rowRst[26], $format1);
   $worksheet[2]->write($row, $col+35,  $rowRst[27], $formatT);
   $worksheet[2]->write($row, $col+37,  $rowRst[28], $format1);
   $worksheet[2]->write($row, $col+38,  $rowRst[29], $format1);
   $worksheet[2]->write($row, $col+39,  $rowRst[30], $formatT);
   $worksheet[2]->write($row, $col+41,  $rowRst[31], $format1);
   $worksheet[2]->write($row, $col+42,  $rowRst[32], $format1);
   $worksheet[2]->write($row, $col+43,  $rowRst[33], $formatT);
   $worksheet[2]->write($row, $col+45,  $rowRst[34], $format1);
   $worksheet[2]->write($row, $col+46,  $rowRst[35], $format1);
   $worksheet[2]->write($row, $col+47,  $rowRst[36], $formatT);
   $worksheet[2]->write($row, $col+49,  $rowRst[37], $format1);
   $worksheet[2]->write($row, $col+50,  $rowRst[38], $format1);
   $worksheet[2]->write($row, $col+51,  $rowRst[39], $formatT);
   $worksheet[2]->write($row, $col+53,  $rowRst[40], $format1);
   $worksheet[2]->write($row, $col+54,  $rowRst[41], $format1);
   $worksheet[2]->write($row, $col+55,  $rowRst[42], $formatT);
   $worksheet[2]->write($row, $col+57,  $rowRst[43], $format1);
   $worksheet[2]->write($row, $col+58,  $rowRst[44], $format1);
   $worksheet[2]->write($row, $col+59,  $rowRst[45], $formatT);
   $worksheet[2]->write($row, $col+61,  $rowRst[46], $format1);
   $worksheet[2]->write($row, $col+62,  $rowRst[47], $format1);
   $worksheet[2]->write($row, $col+63,  $rowRst[48], $formatT);
   $worksheet[2]->write($row, $col+65,  $rowRst[49], $format1);
   $worksheet[2]->write($row, $col+66,  $rowRst[50], $format1);
   $worksheet[2]->write($row, $col+67,  $rowRst[51], $formatT);
   $worksheet[2]->write($row, $col+69,  $rowRst[52], $format1);
   $worksheet[2]->write($row, $col+70,  $rowRst[53], $format1);
   $worksheet[2]->write($row, $col+71,  $rowRst[54], $formatT);
   $worksheet[2]->write($row, $col+73,  $rowRst[55], $format1);
   $worksheet[2]->write($row, $col+74,  $rowRst[56], $format1);
   $worksheet[2]->write($row, $col+75,  $rowRst[57], $formatT);
   $worksheet[2]->write($row, $col+77,  $rowRst[58], $format1);
   $worksheet[2]->write($row, $col+78,  $rowRst[59], $format1);
   $worksheet[2]->write($row, $col+79,  $rowRst[60], $formatT);
   $worksheet[2]->write($row, $col+81,  $rowRst[61], $format1);
   $worksheet[2]->write($row, $col+82,  $rowRst[62], $format1);
   $worksheet[2]->write($row, $col+83,  $rowRst[63], $formatT);
}



$workbook->close();
 binmode STDOUT;

$from = "powerapp_stats\@chikka.com";
$to = "victor\@chikka.com,ps.java\@chikka.com,jomai\@chikka.com,ra\@chikka.com,ian\@chikka.com,jldespanol\@voyagerinnovation.com";
$cc = "dbadmins\@chikka.com";
#$to = "glenon\@chikka.com";
#$cc = "glenon\@chikka.com";
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





