#!/usr/bin/perl

use MIME::Lite;

$from = "do-not-reply\@chikka.com";
$to = "mbmalano\@chikka.com";
$Subject = "OIST STATS";

# Part using which the attachment is sent to an email #
$msg = MIME::Lite->new(
        From     => $from,
        To       => $to,
        Subject  => $Subject,
        Type     => 'File/xls',
		Encoding => 'base64',
        Path         => "/home/dba_scripts/oist_stat/perl.xls"

);

	
print "Mail Sent\n";
$msg->send; # send via default

