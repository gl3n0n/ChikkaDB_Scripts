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

my $excel_file = "/home/dba_scripts/oist_stat/PowerApp_Inactive_Users_".$current_date.".xls";
print $excel_file;
my $dbh_hi10 = DB::DBconnect(myconstants::HI10_DB,myconstants::HI10_HOST,myconstants::HI10_USER,myconstants::HI10_PASSWORD);
my $sth_hi_10;

# run storedproc
$strSQLhi10 = "call sp_generate_inactive_list()";
$sth_hi_10 = $dbh_hi10->prepare($strSQLhi10);
$sth_hi_10->execute();

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);
$strSQLhi10 = "select phone from powerapp_inactive_list";
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
$format1->set_align('left');
$format1->set_border(1);
$format1->set_num_format('############');
$worksheet->set_column(0,0,14);

$row = -1;
$col = 0;
$i=0;
my @rowRst;
while (@rowRst = $sth_hi_10->fetchrow()) {
   $i++;
   if ($i < 65535){
      $worksheet->write($row+$i, $col, $rowRst[0], $format1);
   }else{
      $i=0;
      $row=-1;
      $col=$col+2;
   }
}                      

$workbook->close();
 binmode STDOUT;

$from = "stats\@chikka.com";
$to = "glenon\@chikka.com";
$cc = "glenon\@chikka.com";
$Subject = "PowerApp Inactive Users, ".$current_day;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">PowerApp inactive users as of $current_date.</span></span></p>
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


