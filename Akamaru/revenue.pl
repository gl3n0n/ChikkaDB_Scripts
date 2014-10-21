#!/usr/bin/perl

use strict;
use DBI;

my $dbtype = "DBI:mysql"; 

#DB connection stat
my $dbase = "oist_stat";
my $host = "localhost";
my $user = "root";
my $password = "\$CRIPT\$";

#DB connection sms_in
my $dbase1 = "csg_v3";
my $host1 = "10.11.6.116";
my $user1 = "oist_stat";
my $password1 = "oist_stat";
 
my $cstring = "${dbtype}:${dbase}:${host}";
#print "Connecting to $cstring\n";

my $cstring1 = "${dbtype}:${dbase1}:${host1}";
#print "Connecting to $cstring\n";


my $dbh = DBI->connect($cstring,$user,$password);
if (! $dbh) {
        die ("database connection failed - $DBI::errstr\n"); }
       
my $dbh1 = DBI->connect($cstring1,$user1,$password1);
if (! $dbh) {
        die ("database connection failed - $DBI::errstr\n"); }

my $select_globe_numbers ="SELECT GROUP_CONCAT(prefix) FROM mobile_number_mapping WHERE operator='GLOBE'"; 
		

my $sth1 = $dbh->prepare($select_globe_numbers);
$sth1->execute();

my $select_globe_hits ="";

while (my @prefix_number = $sth1->fetchrow_array()) {

$select_globe_hits ="SELECT datein,(COUNT(1)*2.50),COUNT(1) FROM sms_in WHERE left(gsm_num,5) IN (".$prefix_number[0].")  GROUP BY 1; ";

print $select_globe_hits;
	
}
$sth1->finish();
	   
my $sth2 = $dbh1->prepare($select_globe_hits);
$sth2->execute();

my $insert_stat_table = "";
my $sth3 = "";

while (my @globe_hits = $sth2->fetchrow_array()) {

print $globe_hits[0].' '.$globe_hits[1].' '.$globe_hits[2];
print "\n";
$insert_stat_table = "INSERT INTO oist_stat.oist_stat_globe (datein,sms_revenue,sms_hits) VALUES ('".$globe_hits[0]."',".$globe_hits[1].",".$globe_hits[2].")";

$sth3 = $dbh->prepare($insert_stat_table);
$sth3->execute();

}

$sth2->finish();
$sth3->finish();



