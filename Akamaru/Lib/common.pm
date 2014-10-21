package common;

use strict;
use Switch;

sub currentDate {

(my $Second, 
 my $Minute, 
 my $Hour, 
 my $Day, 
 my $Month, 
 my $Year, 
 my $WeekDay, 
 my $DayOfYear, 
 my $IsDST) = localtime(time) ;
 
 $Year += 1900 ; $Month += 1;

my $dt = sprintf("%04d-%02d-%02d", $Year, $Month, $Day, );

return $dt;

}


sub chargingOperator {

my $operator = shift;

my $charging = "";

switch ($operator) {
    case "GLOBE"  { $charging = 2.50 }
    case "SMART"  { $charging = 2.50  }
    case "SUN"    { $charging = 2.00  }
    else          { $charging = 2.50  }
}

return $charging;

}

1;