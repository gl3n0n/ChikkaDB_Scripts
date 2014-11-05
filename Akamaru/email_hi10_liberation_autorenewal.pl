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

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_Liberation_Usage_".$current_day.".xls";
print $excel_file;

#my $dbh_hi10 = DB::DBconnect(myconstants::HI10_DB,myconstants::HI10_HOST,myconstants::HI10_USER,myconstants::HI10_PASSWORD);
my $dbh_hi10 = DB::DBconnect(myconstants::HI10A_DB,myconstants::HI10A_HOST,myconstants::HI10A_USER,myconstants::HI10A_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);

my $sth_hi_10;

$strSQLhi10 = "select DATE_FORMAT(tx_date,'%m/%d/%Y'), count(1) Total 
               from  powerapp_log
               where datein >= concat(left('".$current_day."',8), '01') and datein < curdate()
               and   plan = 'MYVOLUME' and source = 'auto_opt_in_liberation'
               and   brand = 'TNT'
               group by 1 order by 1";

$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();


# Add a worksheet
$worksheet = $workbook->add_worksheet($current_day);

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

# Write a formatted and unformatted string, row and column notation.
$worksheet->merge_range('A2:B2', 'Liberation Auto-Renewal Stats', $formatC);
$worksheet->set_column(1, 1, 12);
$row = 1;
$col = 0;
$i=1;

$worksheet->write($row+$i, $col, 'DATE', $format);
$worksheet->write($row+$i, $col+1, 'TOTAL', $format);

my @rowRst;

while (@rowRst = $sth_hi_10->fetchrow()) {

   $i++;
   $worksheet->write($row+$i, $col,    $rowRst[0], $format1);
   $worksheet->write($row+$i, $col+1,  $rowRst[1], $formatT);
}                      


$workbook->close();
 binmode STDOUT;

$from = "stats\@chikka.com";
$to = "jomai\@chikka.com,ps.java\@chikka.com,ra\@chikka.com";
$to = "glenon\@chikka.com";
$cc = "glenon\@chikka.com";
$Subject = "PowerApp Liberation Auto-Renewal Stats, ".$current_day;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp Liberation Auto-Renewal for $txt_month.</span></span></p>
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


