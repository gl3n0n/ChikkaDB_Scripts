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

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_stats_rev_".$current_date.".xls";
print $excel_file;

my $dbh_hi10 = DB::DBconnect(myconstants::HI10_DB,myconstants::HI10_HOST,myconstants::HI10_USER,myconstants::HI10_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);

my $sth_hi_10;

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
                      social_hits_3*if(tran_dt<'2014-02-01',0,5), social_hits_24*if(tran_dt<'2014-02-01',0,10), (social_hits_3*if(tran_dt<'2014-02-01',0,5))+(social_hits_24*if(tran_dt<'2014-02-01',0,10)),
                      speed_uniq, speed_hits, speed_hits*5,
                      total_uniq, total_hits
                from  powerapp_validity_dailyrep
                where left(tran_dt,7) = '".$current_date."' order by tran_dt";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet($txt_month);


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


$worksheet->set_column(10, 10, 2);
$worksheet->set_column(7, 9, 11);
$worksheet->set_column(20, 20, 2);
$worksheet->set_column(17, 19, 11);
$worksheet->set_column(30, 30, 2);
$worksheet->set_column(27, 29, 11);
$worksheet->set_column(40, 40, 2);
$worksheet->set_column(37, 39, 11);
$worksheet->set_column(50, 50, 2);
$worksheet->set_column(47, 49, 11);
$worksheet->set_column(53, 53, 11);

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('B2:J2', 'CHAT', $formatC);
$worksheet->merge_range('L2:T2', 'EMAIL', $formatE);
$worksheet->merge_range('V2:AD2', 'PHOTO', $formatP);
$worksheet->merge_range('AF2:AN2', 'UNLI', $formatU);
$worksheet->merge_range('AP2:AX2', 'SOCIAL', $formatS);
$worksheet->merge_range('AZ2:BB2', 'SPEEDBOOST', $formatB);

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
$worksheet->set_column(51, 51, 12);
$worksheet->write(2, 51, 'UNIQUE USERS', $format);
$worksheet->write(2, 52, 'HITS', $format);
$worksheet->write(2, 53, 'REVENUE', $format);

$row = 2;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col, 'DATE', $format);
$worksheet->write($row+$i, $col+1, '3 hours', $format);
$worksheet->write($row+$i, $col+2, '24 hours', $format);
$worksheet->write($row+$i, $col+3, 'TOTAL', $format);
$worksheet->write($row+$i, $col+4, '3 hours', $format);
$worksheet->write($row+$i, $col+5, '24 hours', $format);
$worksheet->write($row+$i, $col+6, 'TOTAL', $format);
$worksheet->write($row+$i, $col+7, 'P5 (3hrs)', $format);
$worksheet->write($row+$i, $col+8, 'P10 (24hrs)', $format);
$worksheet->write($row+$i, $col+9, 'GROSS REV', $format);
$worksheet->write($row+$i, $col+11, '3 hours', $format);
$worksheet->write($row+$i, $col+12, '24 hours', $format);
$worksheet->write($row+$i, $col+13, 'TOTAL', $format);
$worksheet->write($row+$i, $col+14, '3 hours', $format);
$worksheet->write($row+$i, $col+15, '24 hours', $format);
$worksheet->write($row+$i, $col+16, 'TOTAL', $format);
$worksheet->write($row+$i, $col+17, 'P5 (3hrs)', $format);
$worksheet->write($row+$i, $col+18, 'P10 (24hrs)', $format);
$worksheet->write($row+$i, $col+19, 'GROSS REV', $format);
$worksheet->write($row+$i, $col+21, '3 hours', $format);
$worksheet->write($row+$i, $col+22, '24 hours', $format);
$worksheet->write($row+$i, $col+23, 'TOTAL', $format);
$worksheet->write($row+$i, $col+24, '3 hours', $format);
$worksheet->write($row+$i, $col+25, '24 hours', $format);
$worksheet->write($row+$i, $col+26, 'TOTAL', $format);
$worksheet->write($row+$i, $col+27, 'P10 (3hrs)', $format);
$worksheet->write($row+$i, $col+28, 'P20 (24hrs)', $format);
$worksheet->write($row+$i, $col+29, 'GROSS REV', $format);
$worksheet->write($row+$i, $col+31, '3 hours', $format);
$worksheet->write($row+$i, $col+32, '24 hours', $format);
$worksheet->write($row+$i, $col+33, 'TOTAL', $format);
$worksheet->write($row+$i, $col+34, '3 hours', $format);
$worksheet->write($row+$i, $col+35, '24 hours', $format);
$worksheet->write($row+$i, $col+36, 'TOTAL', $format);
$worksheet->write($row+$i, $col+37, 'P15 (3hrs)', $format);
$worksheet->write($row+$i, $col+38, 'P30 (24hrs)', $format);
$worksheet->write($row+$i, $col+39, 'GROSS REV', $format);
$worksheet->write($row+$i, $col+41, '3 hours', $format);
$worksheet->write($row+$i, $col+42, '24 hours', $format);
$worksheet->write($row+$i, $col+43, 'TOTAL', $format);
$worksheet->write($row+$i, $col+44, '3 hours', $format);
$worksheet->write($row+$i, $col+45, '24 hours', $format);
$worksheet->write($row+$i, $col+46, 'TOTAL', $format);
$worksheet->write($row+$i, $col+47, 'P5 (3hrs)', $format);
$worksheet->write($row+$i, $col+48, 'P10 (24hrs)', $format);
$worksheet->write($row+$i, $col+49, 'GROSS REV', $format);
$worksheet->write($row+$i, $col+51, '15 mins', $format);
$worksheet->write($row+$i, $col+52, '15 mins', $format);
$worksheet->write($row+$i, $col+53, 'P5 (15mins)', $format);




my @rowRst;

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
                               
                               
#$strSQLhi10 = "select DATE_FORMAT(tran_dt,'%b %Y'), num_subs from powerapp_concurrent_subs b where exists (select 1 from (select date_format(tran_dt, '%b %Y') month_, max(tran_dt) tran_dt from powerapp_concurrent_subs group by 1) t1 where b.tran_dt = t1.tran_dt) ";
#                               
#$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
#$sth_hi_10->execute();         
#                               
#$i++;                          
#$i++;
#$i++;
#$i++;
#
#$worksheet->write($row+$i, $col, 'MONTH', $format);
#$worksheet->write($row+$i, $col+1, 'UNIQUE SUBS', $format);

#while (@rowRst = $sth_hi_10->fetchrow()) {
#
#   $i++;
#   $worksheet->write($row+$i, $col, $rowRst[0], $format1);
#   $worksheet->write($row+$i, $col+1, $rowRst[1], $format1);
#}





$workbook->close();
 binmode STDOUT;

$from = "stats\@chikka.com";
$to = "jomai\@chikka.com,ps.java\@chikka.com,ra\@chikka.com";
#$to = "jomai\@chikka.com";
$cc = "dbadmins\@chikka.com";
$Subject = "PowerApp Stats (Hits & Revenue), ".$current_day;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp Stats for the Month of $txt_month.</span></span></p>
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


