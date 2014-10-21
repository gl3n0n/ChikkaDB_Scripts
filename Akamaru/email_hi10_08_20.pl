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
my $current_time = "";
my $txt_month = "";

$current_date = $ARGV[0];
$current_day = $ARGV[1];
$current_time=`date '+%H'`;
$txt_month = $ARGV[2];

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_stats_".$current_date.".xls";
print $excel_file."\n";

my $dbh_hi10 = DB::DBconnect(myconstants::HI10_DB,myconstants::HI10_HOST,myconstants::HI10_USER,myconstants::HI10_PASSWORD);

# run storedproc
$strSQLhi10 = "call sp_generate_hi10_stats_now()";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


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
   $worksheet->write($row+$i, $col+14, $rowRst[14], $formatT);
   $worksheet->write($row+$i, $col+15, $rowRst[15], $formatT);
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

$workbook->close();
 binmode STDOUT;

$from = "stats\@chikka.com";
$to = "speralta\@chikka.com";
$cc = "dbadmins\@chikka.com";
#$to = "glenon\@chikka.com";
#$cc = "glenon\@chikka.com";
$Subject = "PowerApp Stats as of ".$current_day." ".$current_time.":00";

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp Stats as of $current_day $current_time:00</span></span></p>
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



