#!/usr/bin/perl

use warnings;
use lib "/home/dba_scripts/oist_stat/Lib";
use common;
use netcast_rep_constants;
use DB;

use Spreadsheet::WriteExcel;
use MIME::Lite;
 binmode STDOUT;

$company = $ARGV[0];
my $excel_file =  $ARGV[1];


 $from = "Netcast DBA\@chikka.com";
 #$to = "caparolma\@chikka.com,jomai\@chikka.com, ALBialoglovski\@smart.com.ph,dcjuat\@chikka.com";
 $to = "jojo\@chikka.com";
 $cc = "sjpipit\@chikka.com";
 #$cc = "allan\@chikka.com,mllduran\@chikka.com,jocamat\@chikka.com,pegadraneda\@chikka.com";

$Subject = "Netcast Migration Report : Netcast Company -  ".$company;

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
                        <span style="font-size:14px;"><span style="font-family: Calibri, helvetica, sans-serif;">  Company $company Migrated Successfully.</span></span></p>
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

