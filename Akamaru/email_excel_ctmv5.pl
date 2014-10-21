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

my $excel_file = "/home/dba_scripts/oist_stat/ctmv5_stat_".$current_date.".xls";
print $excel_file;

my $dbh_ctmv5 = DB::DBconnect(myconstants::CTMV5_DB,myconstants::CTMV5_HOST,myconstants::CTMV5_USER,myconstants::CTMV5_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);

my $sth_ctm_v5;

#$strSQLCTMv5 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),  hits_globe_pre,  hits_globe_post,  mt_globe_pre,  mt_globe_post,  ukmt_globe_pre,  ukmt_globe_post,  mo_globe_pre,  mo_globe_post,  ukmo_globe_pre,  ukmo_globe_post,  reg_globe_pre,  reg_globe_post,  hits_smart_8266_pre,  hits_smart_8266_post,  hits_smart_8267_pre,  hits_smart_8267_post,  mt_smart_pre,  mt_smart_post,  ukmt_smart_pre,  ukmt_smart_post,  mo_smart_pre,  mo_smart_post,  ukmo_smart_pre,  ukmo_smart_post,  reg_smart_pre,  reg_smart_post,  hits_sun_pre,  hits_sun_post,  mt_sun_pre,  mt_sun_post,  ukmt_sun_pre,  ukmt_sun_post,  mo_sun_pre,  mo_sun_post,  ukmo_sun_pre,  ukmo_sun_post,  reg_sun_pre,  reg_sun_post,  login_android,  login_chrome,  login_client,  login_ios,  login_web,  login_others from ctm_stats_summary where tran_mm = left(date_sub(curdate(), interval 1 day), 7)";

$strSQLCTMv5 = "select DATE_FORMAT(tran_dt,'%m/%d/%Y'),(hits_globe_pre+hits_globe_post) as total_hits  ,hits_globe_pre,  hits_globe_post,  mt_globe_pre,  mt_globe_post,  ukmt_globe_pre,  ukmt_globe_post,  mo_globe_pre,  mo_globe_post,  ukmo_globe_pre,  ukmo_globe_post,  reg_globe_pre,  reg_globe_post, (hits_smart_8266_pre+ hits_smart_8266_post) as 8266_total,hits_smart_8266_pre,  hits_smart_8266_post, (hits_smart_8267_pre+hits_smart_8267_post) as 8267_total,hits_smart_8267_pre,  hits_smart_8267_post,  mt_smart_pre,  mt_smart_post,  ukmt_smart_pre,  ukmt_smart_post,  mo_smart_pre,  mo_smart_post,  ukmo_smart_pre,  ukmo_smart_post,  reg_smart_pre,  reg_smart_post,  hits_sun_pre,  hits_sun_post,  mt_sun_pre,  mt_sun_post,  ukmt_sun_pre,  ukmt_sun_post,  mo_sun_pre,  mo_sun_post,  ukmo_sun_pre,  ukmo_sun_post,  reg_sun_pre,  reg_sun_post,  login_android,  login_chrome,  login_client,  login_ios,  login_web,  login_others,p2p_msg from ctm_stats_summary where tran_mm = '".$current_date."'";

$sth_ctm_v5 = $dbh_ctmv5->prepare($strSQLCTMv5);
$sth_ctm_v5->execute();



# Add a worksheet
$worksheet = $workbook->add_worksheet($txt_month);


#  Add and define a format
$format = $workbook->add_format(); # Add a format
$format->set_bold();
$format->set_font('Calibri');
$format->set_size('9');
$format->set_color('black');
$format->set_align('center');
$format->set_border(2);

$format1 = $workbook->add_format(); # Add a format
#$format1->set_bold();
$format1->set_font('Calibri');
$format1->set_size('9');
$format1->set_color('black');
$format1->set_align('right');
$format1->set_border(1);

$format2 = $workbook->add_format(); # Add a format
$format2->set_bold();
$format2->set_font('Calibri');
$format2->set_size('9');
$format2->set_color('black');
$format2->set_align('center');
$format2->set_border(2);

$format3 = $workbook->add_format(); # Add a format
$format3->set_bold();
$format3->set_font('Calibri');
$format3->set_size('9');
$format3->set_color('black');
$format3->set_align('center');
$format3->set_border(2);

$worksheet->set_column(48,48,20);

# Write a formatted and unformatted string, row and column notation.
$row = 1;
$col = 0;
$worksheet->merge_range('B1:N1', 'GLOBE', $format2);
$worksheet->merge_range('O1:AD1', 'SMART', $format2);
$worksheet->merge_range('AE1:AP1', 'SUN', $format2);
$worksheet->merge_range('AQ1:AV1', '', $format2);
$worksheet->merge_range('B2:D2', 'HITS', $format2);
$worksheet->merge_range('E2:F2', 'MT', $format2);
$worksheet->merge_range('G2:H2', 'Unique MT', $format2);
$worksheet->merge_range('I2:J2', 'MO', $format2);
$worksheet->merge_range('K2:L2', 'Unique MO', $format2);
$worksheet->merge_range('M2:N2', 'Registration', $format2);
$worksheet->merge_range('O2:Q2', 'HITS (8266)', $format2);
$worksheet->merge_range('R2:T2', 'HITS (8267)', $format2);
$worksheet->merge_range('U2:V2', 'MT', $format2);
$worksheet->merge_range('W2:X2', 'Unique MT', $format2);
$worksheet->merge_range('Y2:Z2', 'MO', $format2);
$worksheet->merge_range('AA2:AB2', 'Unique MO', $format2);
$worksheet->merge_range('AC2:AD2', 'Registration', $format2);
$worksheet->merge_range('AE2:AF2', 'HITS', $format2);
$worksheet->merge_range('AG2:AH2', 'MT', $format2);
$worksheet->merge_range('AI2:AJ2', 'Unique MT', $format2);
$worksheet->merge_range('AK2:AL2', 'MO', $format2);
$worksheet->merge_range('AM2:AN2', 'Unique MO', $format2);
$worksheet->merge_range('AO2:AP2', 'Registration', $format2);
$worksheet->merge_range('AQ2:AV2', 'Sign-in via', $format2);
$worksheet->write('AW2', 'ONLINE P2P MESSAGES', $format3);
				
#																											

$worksheet->set_column(0,47,10);


#$worksheet->write($row, $col, 'GLOBE TELECOM', $format2);

$i=1;


$worksheet->write($row+$i, $col, 'DATE', $format);
$worksheet->write($row+$i, $col+1, 'TOTAL', $format);
$worksheet->write($row+$i, $col+2, 'PRE', $format);
$worksheet->write($row+$i, $col+3, 'POST', $format);
$worksheet->write($row+$i, $col+4, 'PRE', $format);
$worksheet->write($row+$i, $col+5, 'POST', $format);
$worksheet->write($row+$i, $col+6, 'PRE', $format);
$worksheet->write($row+$i, $col+7, 'POST', $format);
$worksheet->write($row+$i, $col+8, 'PRE', $format);
$worksheet->write($row+$i, $col+9, 'POST', $format);
$worksheet->write($row+$i, $col+10, 'PRE', $format);
$worksheet->write($row+$i, $col+11, 'POST', $format);
$worksheet->write($row+$i, $col+12, 'PRE', $format);
$worksheet->write($row+$i, $col+13, 'POST', $format);
$worksheet->write($row+$i, $col+14, 'TOTAL', $format);
$worksheet->write($row+$i, $col+15, 'PRE', $format);
$worksheet->write($row+$i, $col+16, 'POST', $format);
$worksheet->write($row+$i, $col+17, 'TOTAL', $format);
$worksheet->write($row+$i, $col+18, 'PRE', $format);
$worksheet->write($row+$i, $col+19, 'POST', $format);
$worksheet->write($row+$i, $col+20, 'PRE', $format);
$worksheet->write($row+$i, $col+21, 'POST', $format);
$worksheet->write($row+$i, $col+22, 'PRE', $format);
$worksheet->write($row+$i, $col+23, 'POST', $format);
$worksheet->write($row+$i, $col+24, 'PRE', $format);
$worksheet->write($row+$i, $col+25, 'POST', $format);
$worksheet->write($row+$i, $col+26, 'PRE', $format);
$worksheet->write($row+$i, $col+27, 'POST', $format);
$worksheet->write($row+$i, $col+28, 'PRE', $format);
$worksheet->write($row+$i, $col+29, 'POST', $format);
$worksheet->write($row+$i, $col+30, 'PRE', $format);
$worksheet->write($row+$i, $col+31, 'POST', $format);
$worksheet->write($row+$i, $col+32, 'PRE', $format);
$worksheet->write($row+$i, $col+33, 'POST', $format);
$worksheet->write($row+$i, $col+34, 'PRE', $format);
$worksheet->write($row+$i, $col+35, 'POST', $format);
$worksheet->write($row+$i, $col+36, 'PRE', $format);
$worksheet->write($row+$i, $col+37, 'POST', $format);
$worksheet->write($row+$i, $col+38, 'PRE', $format);
$worksheet->write($row+$i, $col+39, 'POST', $format);
$worksheet->write($row+$i, $col+40, 'PRE', $format);
$worksheet->write($row+$i, $col+41, 'POST', $format);
$worksheet->write($row+$i, $col+42, 'Android', $format);
$worksheet->write($row+$i, $col+43, 'Chrome', $format);
$worksheet->write($row+$i, $col+44, 'Client', $format);
$worksheet->write($row+$i, $col+45, 'iOS', $format);
$worksheet->write($row+$i, $col+46, 'Web', $format);
$worksheet->write($row+$i, $col+47, 'Others', $format);
$worksheet->write($row+$i, $col+48, 'TOTAL', $format);



my @rowRst;

while (@rowRst = $sth_ctm_v5->fetchrow()) {
	
$i++;
$worksheet->write($row+$i, $col, $rowRst[0], $format1);
$worksheet->write($row+$i, $col+1, $rowRst[1], $format1);
$worksheet->write($row+$i, $col+2, $rowRst[2], $format1);
$worksheet->write($row+$i, $col+3, $rowRst[3], $format1);
$worksheet->write($row+$i, $col+4, $rowRst[4], $format1);
$worksheet->write($row+$i, $col+5, $rowRst[5], $format1);
$worksheet->write($row+$i, $col+6, $rowRst[6], $format1);
$worksheet->write($row+$i, $col+7, $rowRst[7], $format1);
$worksheet->write($row+$i, $col+8, $rowRst[8], $format1);
$worksheet->write($row+$i, $col+9, $rowRst[9], $format1);
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


	
$workbook->close();
 binmode STDOUT;

$from = "do-not-reply\@chikka.com";
$to = "jomai\@chikka.com,caguilar\@chikka.com,tdelacruz\@chikka.com,bresos\@chikka.com";
#$to = "bresos\@chikka.com,jojo\@chikka.com";
$cc = "dbadmins\@chikka.com";
$Subject = "CTMV5 Stats , ".$current_day;

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
			<span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">CTM V5 Stats for the Month of $txt_month.</span></span></p>
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

