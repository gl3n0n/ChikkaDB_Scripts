#!/usr/bin/perl

use strict;
use warnings;
use lib "/home/dba_scripts/oist_stat/Lib";
use common;
use myconstants;
use DB;
use File::Copy;

#my @lines = read_file('/tmp/user.txt');

my $current_date = "";

if ($ARGV[0]) { 

$current_date = $ARGV[0];

} else {
$current_date = common::currentDate();

}

my $dbh_oist = DB::DBconnect(myconstants::OIST_DB,myconstants::OIST_HOST,myconstants::OIST_USER,myconstants::OIST_PASSWORD);
my $dbh_csg = DB::DBconnect(myconstants::CSG_V3_DB,myconstants::CSG_V3_HOST,myconstants::CSG_V3_USER,myconstants::CSG_V3_PASSWORD);
my $dbh_profile = DB::DBconnect(myconstants::PROFILE_DB,myconstants::PROFILE_HOST,myconstants::PROFILE_USER,myconstants::PROFILE_PASSWORD);

#NON REGISTERED

my $sth_qry_users="";

my $strSQLSELECTusers = "SELECT replace(id,'+','') FROM users";
$sth_qry_users = $dbh_profile->prepare($strSQLSELECTusers);
$sth_qry_users->execute();


my @results;

my $sth_insert_users;

my $file_temp = "/tmp/user.csv";

unless(open FILE, '>'.$file_temp) {
	# Die with error message 
	# if we can't open it.
	die "\nUnable to create $file_temp\n";
}

while (@results = $sth_qry_users->fetchrow()) {
	print FILE "$results[0]\n";

	}

binmode FILE;

my $sth_load_users;

#move($file_temp,$file_final);

my $strTruncate = "TRUNCATE temp_users_profile";
$sth_truncate_users = $dbh_oist->prepare($strTruncate);
$sth_truncate_users->execute() or die "SQL Error: $DBI::errstr\n";

	
my $strSQLLoad = "LOAD DATA LOCAL INFILE '".$file_temp."' REPLACE INTO TABLE temp_users_profile";
$sth_load_users = $dbh_oist->prepare($strSQLLoad);
$sth_load_users->execute() or die "SQL Error: $DBI::errstr\n";


$dbh_profile->disconnect;

$dbh_oist->commit;
$dbh_oist->disconnect;
