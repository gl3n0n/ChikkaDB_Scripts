#!/usr/bin/perl

use warnings;
use strict;

use Net::SCP qw/ scp /;
use Net::SCP::Expect;
use Try::Tiny;
use Email::MIME;

use lib "/home/dba_scripts/oist_stat/Lib";
use common;


my $current_date = "";

if ($ARGV[0]) { 

$current_date = $ARGV[0];

} else {
$current_date = common::currentDate();

}

my $host = "carbine.internal.chikka.com";
my $user  = "noc";
#my $pass  = "p0rkb\@rr3l3tp\!";
#my $pass = "\$n\!ck3r\$3tp\!";
my $pass = "d4t43tp\!";

try {
  
my $scpe = Net::SCP::Expect->new(user=>$user,password=>$pass) || die "Cannot Connect";


$scpe->scp($host.':/var/log/oist/*'.$current_date,'/var/log/oist/');
   
} catch {

	print $_;
	
	my $message = Email::MIME->create(
  header_str => [
    From    => 'no-reply@chikka.com',
    To      => 'dbadmins@chikka.com',
    Subject => 'OIST STAT - Error downloading files',
  ],
  attributes => {
    encoding => 'quoted-printable',
    charset  => 'ISO-8859-1',
  },
  body_str => "$_",
);

# send the message
use Email::Sender::Simple qw(sendmail);
sendmail($message);
}
