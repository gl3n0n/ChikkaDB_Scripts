#!/usr/bin/perl
use Net::SMTP;
#use strict;
use warnings;

my $from = 'no-reply@chikka.com';
my $to = 'mbmalano@chikka.com';
#my $to2 = 'someoneelse@luckylarry.co.uk';
my $attachFile = 'perl.xls';
my $boundary = 'frontier';
my $data_file="/home/dba_scripts/oist_stat/perl.xls";

open(DATA, $data_file) || die("Could not open the file");
  my @csv = DATA;
close(DATA);

my $smtp = Net::SMTP->new('mail.chikka.com');

$smtp->mail($from);
$smtp->recipient($to,{ SkipBad => 1 });
$smtp->data();
$smtp->datasend("Subject: Test mail from you \n");
$smtp->datasend("MIME-Version: 1.0 \n");
$smtp->datasend("Content-type: multipart/mixed;ntboundary=".$boundary."\n");
$smtp->datasend("\n");
$smtp->datasend("--".$boundary."\n");
$smtp->datasend("Content-type: text/plain \n");
$smtp->datasend("Content-Disposition: quoted-printable \n");
$smtp->datasend("\n Test From You \n");
$smtp->datasend("--".$boundary."\n");
$smtp->datasend("Content-Type: application/text; name=".$attachFile."\n");
$smtp->datasend("Content-Disposition: attachment; filename=".$attachFile."\n");
$smtp->datasend("\n");
$smtp->datasend(@csv."\n");
$smtp->datasend("--".$boundary."\n");
$smtp->dataend();
$smtp->quit;

exit;
