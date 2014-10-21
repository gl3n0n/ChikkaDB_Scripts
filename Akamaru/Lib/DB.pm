package DB;

use strict;
use DBI;


sub DBconnect  {

my ($dbase, $host,$user,$password) = @_;

my $dbtype = "DBI:mysql"; 

my $cstring = "${dbtype}:${dbase}:${host}";

my $dbh = DBI->connect($cstring,$user,$password);             
if (! $dbh) {                                                 
        die ("database connection failed - $DBI::errstr\n"); }       
return $dbh;
}


1;
