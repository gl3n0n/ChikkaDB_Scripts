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

my $excel_file = "/home/dba_scripts/oist_stat/oist_stat_".$current_date.".xls";
print $excel_file;

my $dbh_oist = DB::DBconnect(myconstants::OIST_DB,myconstants::OIST_HOST,myconstants::OIST_USER,myconstants::OIST_PASSWORD);

# Create a new Excel workbook
my $workbook = Spreadsheet::WriteExcel->new($excel_file);

my $sth_globe_mobile_revenue;

$strSQLGlobeMobileRevenue = "SELECT * FROM oist_stat_globe where datein like '$current_date%' ORDER BY datein";
$sth_globe_mobile_revenue = $dbh_oist->prepare($strSQLGlobeMobileRevenue);
$sth_globe_mobile_revenue->execute();


my $sth_smart_mobile_revenue;

$strSQLSmartMobileRevenue = "SELECT * FROM oist_stat_smart where datein like '$current_date%' ORDER BY datein";
$sth_smart_mobile_revenue = $dbh_oist->prepare($strSQLSmartMobileRevenue);
$sth_smart_mobile_revenue->execute();

my $sth_sun_mobile_revenue;

$strSQLSunMobileRevenue = "SELECT * FROM oist_stat_sun where datein like '$current_date%' ORDER BY datein";
$sth_sun_mobile_revenue = $dbh_oist->prepare($strSQLSunMobileRevenue);
$sth_sun_mobile_revenue->execute();

# Add a worksheet
$worksheet = $workbook->add_worksheet('Mobile Revenues');
$worksheet1 = $workbook->add_worksheet('Clients Breakdown');
$worksheet2 = $workbook->add_worksheet('Countries');

#  Add and define a format
$format = $workbook->add_format(); # Add a format
$format->set_bold();
$format->set_font('Arial');
$format->set_size('8');
$format->set_color('black');
$format->set_align('left');
$format->set_bg_color(22);
$format->set_border(2);

$format1 = $workbook->add_format(); # Add a format
#$format1->set_bold();
$format1->set_font('Arial');
$format1->set_size('8');
$format1->set_color('black');
$format1->set_align('left');
$format1->set_border(2);

$format2 = $workbook->add_format(); # Add a format
$format2->set_bold();
$format2->set_font('Arial');
$format2->set_size('8');
$format2->set_color('black');
$format2->set_align('left');

# Write a formatted and unformatted string, row and column notation.
$row = 2;
$col = 0;

$worksheet->set_column(0,6,15);
$worksheet->set_column(7,11,20);

$worksheet->write($row, $col, 'GLOBE TELECOM', $format2);

$i=2;

$worksheet->write($row+$i, $col, 'Date', $format);
$worksheet->write($row+$i, $col+1, 'SMS Revenue', $format);
$worksheet->write($row+$i, $col+2, 'SMS Hits', $format);
$worksheet->write($row+$i, $col+3, 'Voice Revenue', $format);
$worksheet->write($row+$i, $col+4, 'Voice Hits', $format);
$worksheet->write($row+$i, $col+5, 'Total Revenue', $format);
$worksheet->write($row+$i, $col+6, 'New Regs', $format);
$worksheet->write($row+$i, $col+7, 'New non-REG BNUMs', $format);
$worksheet->write($row+$i, $col+8, 'Unique Charged MINs', $format);
$worksheet->write($row+$i, $col+9, 'Unique Charged Post', $format);
$worksheet->write($row+$i, $col+10, 'Unique Charged Pre', $format);
$worksheet->write($row+$i, $col+11, 'Unique Charged TM', $format);

my @globe_mobile_revenue;

while (@globe_mobile_revenue = $sth_globe_mobile_revenue->fetchrow()) {
	
$i++;
$worksheet->write($row+$i, $col, $globe_mobile_revenue[0], $format1);
$worksheet->write($row+$i, $col+1, $globe_mobile_revenue[1], $format1);
$worksheet->write($row+$i, $col+2, $globe_mobile_revenue[2], $format1);
$worksheet->write($row+$i, $col+3, $globe_mobile_revenue[3], $format1);
$worksheet->write($row+$i, $col+4, $globe_mobile_revenue[4], $format1);
$worksheet->write($row+$i, $col+5, $globe_mobile_revenue[5], $format1);
$worksheet->write($row+$i, $col+6, $globe_mobile_revenue[6], $format1);
$worksheet->write($row+$i, $col+7, $globe_mobile_revenue[7], $format1);
$worksheet->write($row+$i, $col+8, $globe_mobile_revenue[8], $format1);
$worksheet->write($row+$i, $col+9, $globe_mobile_revenue[9], $format1);
$worksheet->write($row+$i, $col+10, $globe_mobile_revenue[10], $format1);
$worksheet->write($row+$i, $col+11, $globe_mobile_revenue[11], $format1);

	}

$i = $i+3;

$row = $row+$i;

$worksheet->write($row, $col, 'SMART COMMUNICATIONS ', $format2);

$i=2;

$worksheet->write($row+$i, $col, 'Date', $format);
$worksheet->write($row+$i, $col+1, 'SMS Revenue', $format);
$worksheet->write($row+$i, $col+2, 'SMS Hits', $format);
$worksheet->write($row+$i, $col+3, 'Voice Revenue', $format);
$worksheet->write($row+$i, $col+4, 'Voice Hits', $format);
$worksheet->write($row+$i, $col+5, 'Total Revenue', $format);
$worksheet->write($row+$i, $col+6, 'New Regs', $format);
$worksheet->write($row+$i, $col+7, 'New non-REG BNUMs', $format);
$worksheet->write($row+$i, $col+8, 'Unique Charged MINs', $format);
$worksheet->write($row+$i, $col+9, 'Unique Charged Post', $format);
$worksheet->write($row+$i, $col+10, 'Unique Charged Pre', $format);
$worksheet->write($row+$i, $col+11, 'Unique Charged TNT', $format);

my @smart_mobile_revenue;

while (@smart_mobile_revenue = $sth_smart_mobile_revenue->fetchrow()) {
	
$i++;
$worksheet->write($row+$i, $col, $smart_mobile_revenue[0], $format1);
$worksheet->write($row+$i, $col+1, $smart_mobile_revenue[1], $format1);
$worksheet->write($row+$i, $col+2, $smart_mobile_revenue[2], $format1);
$worksheet->write($row+$i, $col+3, $smart_mobile_revenue[3], $format1);
$worksheet->write($row+$i, $col+4, $smart_mobile_revenue[4], $format1);
$worksheet->write($row+$i, $col+5, $smart_mobile_revenue[5], $format1);
$worksheet->write($row+$i, $col+6, $smart_mobile_revenue[6], $format1);
$worksheet->write($row+$i, $col+7, $smart_mobile_revenue[7], $format1);
$worksheet->write($row+$i, $col+8, $smart_mobile_revenue[8], $format1);
$worksheet->write($row+$i, $col+9, $smart_mobile_revenue[9], $format1);
$worksheet->write($row+$i, $col+10, $smart_mobile_revenue[10], $format1);
$worksheet->write($row+$i, $col+11, $smart_mobile_revenue[11], $format1);

	}


	$i = $i+3;

$row = $row+$i;

$worksheet->write($row, $col, 'SUN CELLULAR ', $format2);

$i=2;

$worksheet->write($row+$i, $col, 'Date', $format);
$worksheet->write($row+$i, $col+1, 'SMS Revenue', $format);
$worksheet->write($row+$i, $col+2, 'SMS Hits', $format);
$worksheet->write($row+$i, $col+3, 'Voice Revenue', $format);
$worksheet->write($row+$i, $col+4, 'Voice Hits', $format);
$worksheet->write($row+$i, $col+5, 'Total Revenue', $format);
$worksheet->write($row+$i, $col+6, 'New Regs', $format);
$worksheet->write($row+$i, $col+7, 'New non-REG BNUMs', $format);
$worksheet->write($row+$i, $col+8, 'Unique Charged MINs', $format);
$worksheet->write($row+$i, $col+9, 'Unique Charged Post', $format);
$worksheet->write($row+$i, $col+10, 'Unique Charged Pre', $format);

my @sun_mobile_revenue;

while (@sun_mobile_revenue = $sth_sun_mobile_revenue->fetchrow()) {
	
$i++;
$worksheet->write($row+$i, $col, $sun_mobile_revenue[0], $format1);
$worksheet->write($row+$i, $col+1, $sun_mobile_revenue[1], $format1);
$worksheet->write($row+$i, $col+2, $sun_mobile_revenue[2], $format1);
$worksheet->write($row+$i, $col+3, $sun_mobile_revenue[3], $format1);
$worksheet->write($row+$i, $col+4, $sun_mobile_revenue[4], $format1);
$worksheet->write($row+$i, $col+5, $sun_mobile_revenue[5], $format1);
$worksheet->write($row+$i, $col+6, $sun_mobile_revenue[6], $format1);
$worksheet->write($row+$i, $col+7, $sun_mobile_revenue[7], $format1);
$worksheet->write($row+$i, $col+8, $sun_mobile_revenue[8], $format1);
$worksheet->write($row+$i, $col+9, $sun_mobile_revenue[9], $format1);
$worksheet->write($row+$i, $col+10, $sun_mobile_revenue[10], $format1);

	}

#Creating sheet for Clients Breakdown

#Android
$strSQLAndroidClient ="SELECT * FROM oist_client_breakdown WHERE datein LIKE '$current_date%' AND client_type='android' ORDER BY datein";	
$sth_android_client = $dbh_oist->prepare($strSQLAndroidClient);
$sth_android_client->execute();
	
$row = 2;
$col = 0;

$worksheet1->set_column(0,1,13);
$worksheet1->set_column(2,9,18);
$worksheet1->set_column(10,13,13);

$worksheet1->write($row, $col, 'Android', $format2);


$i=2;

$worksheet1->write($row+$i, $col, 'Date', $format);
$worksheet1->write($row+$i, $col+1, 'Installs', $format);
$worksheet1->write($row+$i, $col+2, 'New Registrations', $format);
$worksheet1->write($row+$i, $col+3, 'New Reg Mobile', $format);
$worksheet1->write($row+$i, $col+4, 'New Reg Facebook', $format);
$worksheet1->write($row+$i, $col+5, 'Unique Msg Senders', $format);
$worksheet1->write($row+$i, $col+6, 'Total Msgs Sent', $format);
$worksheet1->write($row+$i, $col+7, 'Total Msgs Received', $format);
$worksheet1->write($row+$i, $col+8, 'Charged SMS Sent', $format);
$worksheet1->write($row+$i, $col+9, 'Charged SMS Received', $format);
$worksheet1->write($row+$i, $col+10, 'Globe Regs', $format);
$worksheet1->write($row+$i, $col+11, 'Smart Regs', $format);
$worksheet1->write($row+$i, $col+12, 'Sun Regs ', $format);
$worksheet1->write($row+$i, $col+13, 'Others', $format);

my @android_client;

while (@android_client = $sth_android_client->fetchrow()) {
	
$i++;
$worksheet1->write($row+$i, $col, $android_client[0], $format1);
$worksheet1->write($row+$i, $col+1, $android_client[2], $format1);
$worksheet1->write($row+$i, $col+2, $android_client[3], $format1);
$worksheet1->write($row+$i, $col+3, $android_client[4], $format1);
$worksheet1->write($row+$i, $col+4, $android_client[5], $format1);
$worksheet1->write($row+$i, $col+5, $android_client[6], $format1);
$worksheet1->write($row+$i, $col+6, $android_client[7], $format1);
$worksheet1->write($row+$i, $col+7, $android_client[8], $format1);
$worksheet1->write($row+$i, $col+8, $android_client[9], $format1);
$worksheet1->write($row+$i, $col+9, $android_client[10], $format1);
$worksheet1->write($row+$i, $col+10, $android_client[11], $format1);
$worksheet1->write($row+$i, $col+11, $android_client[12], $format1);
$worksheet1->write($row+$i, $col+12, $android_client[13], $format1);
$worksheet1->write($row+$i, $col+13, $android_client[14], $format1);

	}

#Per Country Worksheet
$row = 2;
$col = 0;

$worksheet2->set_column(0,1,13);
$worksheet2->set_column(2,9,18);
$worksheet2->set_column(10,12,13);

#### PHILIPPINES ####

$worksheet2->write($row, $col, 'PHILIPPINES', $format2);

$i=2;

$worksheet2->write($row+$i, $col, 'Date', $format);
$worksheet2->write($row+$i, $col+1, 'Installs', $format);
$worksheet2->write($row+$i, $col+2, 'Registrations', $format);
$worksheet2->write($row+$i, $col+3, 'Total Msgs Sent', $format);
$worksheet2->write($row+$i, $col+4, 'Total Msgs Received', $format);
$worksheet2->write($row+$i, $col+5, 'iOS Install', $format);
$worksheet2->write($row+$i, $col+6, 'Android Install', $format);
$worksheet2->write($row+$i, $col+7, 'BlackBerry Install', $format);
$worksheet2->write($row+$i, $col+8, 'Windows Install', $format);
$worksheet2->write($row+$i, $col+9, 'Facebook Install', $format);
$worksheet2->write($row+$i, $col+10, 'Chrome Install', $format);
$worksheet2->write($row+$i, $col+11, 'Firefox', $format);
$worksheet2->write($row+$i, $col+12, 'Web  ', $format);

$strSQLPH ="SELECT * FROM oist_countries_breakdown WHERE datein LIKE '$current_date%' AND country='PHILIPPINES' ORDER BY datein";	
$sth_ph = $dbh_oist->prepare($strSQLPH);
$sth_ph->execute();

my @countryPH;

while (@countryPH = $sth_ph->fetchrow()) {
	
$i++;
$worksheet2->write($row+$i, $col, $countryPH[0], $format1);
$worksheet2->write($row+$i, $col+1, $countryPH[2], $format1);
$worksheet2->write($row+$i, $col+2, $countryPH[3], $format1);
$worksheet2->write($row+$i, $col+3, $countryPH[4], $format1);
$worksheet2->write($row+$i, $col+4, $countryPH[5], $format1);
$worksheet2->write($row+$i, $col+5, $countryPH[6], $format1);
$worksheet2->write($row+$i, $col+6, $countryPH[7], $format1);
$worksheet2->write($row+$i, $col+7, $countryPH[8], $format1);
$worksheet2->write($row+$i, $col+8, $countryPH[9], $format1);
$worksheet2->write($row+$i, $col+9, $countryPH[10], $format1);
$worksheet2->write($row+$i, $col+10, $countryPH[11], $format1);
$worksheet2->write($row+$i, $col+11, $countryPH[12], $format1);
$worksheet2->write($row+$i, $col+12, $countryPH[13], $format1);

	}
$i = $i+3;

$row = $row+$i;

$worksheet2->write($row, $col, 'UNITED STATES', $format2);

$i=2;

$worksheet2->write($row+$i, $col, 'Date', $format);
$worksheet2->write($row+$i, $col+1, 'Installs', $format);
$worksheet2->write($row+$i, $col+2, 'Registrations', $format);
$worksheet2->write($row+$i, $col+3, 'Total Msgs Sent', $format);
$worksheet2->write($row+$i, $col+4, 'Total Msgs Received', $format);
$worksheet2->write($row+$i, $col+5, 'iOS Install', $format);
$worksheet2->write($row+$i, $col+6, 'Android Install', $format);
$worksheet2->write($row+$i, $col+7, 'BlackBerry Install', $format);
$worksheet2->write($row+$i, $col+8, 'Windows Install', $format);
$worksheet2->write($row+$i, $col+9, 'Facebook Install', $format);
$worksheet2->write($row+$i, $col+10, 'Chrome Install', $format);
$worksheet2->write($row+$i, $col+11, 'Firefox', $format);
$worksheet2->write($row+$i, $col+12, 'Web  ', $format);

$strSQLUS ="SELECT * FROM oist_countries_breakdown WHERE datein LIKE '$current_date%' AND country='UNITED STATES' ORDER BY datein";	
$sth_us = $dbh_oist->prepare($strSQLUS);
$sth_us->execute();

my @countryUS;

while (@countryUS = $sth_us->fetchrow()) {
	
$i++;
$worksheet2->write($row+$i, $col, $countryUS[0], $format1);
$worksheet2->write($row+$i, $col+1, $countryUS[2], $format1);
$worksheet2->write($row+$i, $col+2, $countryUS[3], $format1);
$worksheet2->write($row+$i, $col+3, $countryUS[4], $format1);
$worksheet2->write($row+$i, $col+4, $countryUS[5], $format1);
$worksheet2->write($row+$i, $col+5, $countryUS[6], $format1);
$worksheet2->write($row+$i, $col+6, $countryUS[7], $format1);
$worksheet2->write($row+$i, $col+7, $countryUS[8], $format1);
$worksheet2->write($row+$i, $col+8, $countryUS[9], $format1);
$worksheet2->write($row+$i, $col+9, $countryUS[10], $format1);
$worksheet2->write($row+$i, $col+10, $countryUS[11], $format1);
$worksheet2->write($row+$i, $col+11, $countryUS[12], $format1);
$worksheet2->write($row+$i, $col+12, $countryUS[13], $format1);

	}

#UNITED ARAB EMIRATES	
$i = $i+3;

$row = $row+$i;

$worksheet2->write($row, $col, 'UNITED ARAB EMIRATES', $format2);

$i=2;

$worksheet2->write($row+$i, $col, 'Date', $format);
$worksheet2->write($row+$i, $col+1, 'Installs', $format);
$worksheet2->write($row+$i, $col+2, 'Registrations', $format);
$worksheet2->write($row+$i, $col+3, 'Total Msgs Sent', $format);
$worksheet2->write($row+$i, $col+4, 'Total Msgs Received', $format);
$worksheet2->write($row+$i, $col+5, 'iOS Install', $format);
$worksheet2->write($row+$i, $col+6, 'Android Install', $format);
$worksheet2->write($row+$i, $col+7, 'BlackBerry Install', $format);
$worksheet2->write($row+$i, $col+8, 'Windows Install', $format);
$worksheet2->write($row+$i, $col+9, 'Facebook Install', $format);
$worksheet2->write($row+$i, $col+10, 'Chrome Install', $format);
$worksheet2->write($row+$i, $col+11, 'Firefox', $format);
$worksheet2->write($row+$i, $col+12, 'Web  ', $format);

$strSQLUAE ="SELECT * FROM oist_countries_breakdown WHERE datein LIKE '$current_date%' AND country='UNITED ARAB EMIRATES' ORDER BY datein";	
$sth_uae = $dbh_oist->prepare($strSQLUAE);
$sth_uae->execute();

my @countryUAE;

while (@countryUAE = $sth_uae->fetchrow()) {
	
$i++;
$worksheet2->write($row+$i, $col, $countryUAE[0], $format1);
$worksheet2->write($row+$i, $col+1, $countryUAE[2], $format1);
$worksheet2->write($row+$i, $col+2, $countryUAE[3], $format1);
$worksheet2->write($row+$i, $col+3, $countryUAE[4], $format1);
$worksheet2->write($row+$i, $col+4, $countryUAE[5], $format1);
$worksheet2->write($row+$i, $col+5, $countryUAE[6], $format1);
$worksheet2->write($row+$i, $col+6, $countryUAE[7], $format1);
$worksheet2->write($row+$i, $col+7, $countryUAE[8], $format1);
$worksheet2->write($row+$i, $col+8, $countryUAE[9], $format1);
$worksheet2->write($row+$i, $col+9, $countryUAE[10], $format1);
$worksheet2->write($row+$i, $col+10, $countryUAE[11], $format1);
$worksheet2->write($row+$i, $col+11, $countryUAE[12], $format1);
$worksheet2->write($row+$i, $col+12, $countryUAE[13], $format1);

	}
	
#CHINA	
$i = $i+3;

$row = $row+$i;

$worksheet2->write($row, $col, 'CHINA', $format2);

$i=2;

$worksheet2->write($row+$i, $col, 'Date', $format);
$worksheet2->write($row+$i, $col+1, 'Installs', $format);
$worksheet2->write($row+$i, $col+2, 'Registrations', $format);
$worksheet2->write($row+$i, $col+3, 'Total Msgs Sent', $format);
$worksheet2->write($row+$i, $col+4, 'Total Msgs Received', $format);
$worksheet2->write($row+$i, $col+5, 'iOS Install', $format);
$worksheet2->write($row+$i, $col+6, 'Android Install', $format);
$worksheet2->write($row+$i, $col+7, 'BlackBerry Install', $format);
$worksheet2->write($row+$i, $col+8, 'Windows Install', $format);
$worksheet2->write($row+$i, $col+9, 'Facebook Install', $format);
$worksheet2->write($row+$i, $col+10, 'Chrome Install', $format);
$worksheet2->write($row+$i, $col+11, 'Firefox', $format);
$worksheet2->write($row+$i, $col+12, 'Web  ', $format);

$strSQLCHINA ="SELECT * FROM oist_countries_breakdown WHERE datein LIKE '$current_date%' AND country='CHINA' ORDER BY datein";	
$sth_ch = $dbh_oist->prepare($strSQLCHINA);
$sth_ch->execute();

my @countryCH;

while (@countryCH = $sth_ch->fetchrow()) {
	
$i++;
$worksheet2->write($row+$i, $col, $countryCH[0], $format1);
$worksheet2->write($row+$i, $col+1, $countryCH[2], $format1);
$worksheet2->write($row+$i, $col+2, $countryCH[3], $format1);
$worksheet2->write($row+$i, $col+3, $countryCH[4], $format1);
$worksheet2->write($row+$i, $col+4, $countryCH[5], $format1);
$worksheet2->write($row+$i, $col+5, $countryCH[6], $format1);
$worksheet2->write($row+$i, $col+6, $countryCH[7], $format1);
$worksheet2->write($row+$i, $col+7, $countryCH[8], $format1);
$worksheet2->write($row+$i, $col+8, $countryCH[9], $format1);
$worksheet2->write($row+$i, $col+9, $countryCH[10], $format1);
$worksheet2->write($row+$i, $col+10, $countryCH[11], $format1);
$worksheet2->write($row+$i, $col+11, $countryCH[12], $format1);
$worksheet2->write($row+$i, $col+12, $countryCH[13], $format1);

	}
	
#UNITED KINGDOM	
$i = $i+3;

$row = $row+$i;

$worksheet2->write($row, $col, 'UNITED KINGDOM', $format2);

$i=2;

$worksheet2->write($row+$i, $col, 'Date', $format);
$worksheet2->write($row+$i, $col+1, 'Installs', $format);
$worksheet2->write($row+$i, $col+2, 'Registrations', $format);
$worksheet2->write($row+$i, $col+3, 'Total Msgs Sent', $format);
$worksheet2->write($row+$i, $col+4, 'Total Msgs Received', $format);
$worksheet2->write($row+$i, $col+5, 'iOS Install', $format);
$worksheet2->write($row+$i, $col+6, 'Android Install', $format);
$worksheet2->write($row+$i, $col+7, 'BlackBerry Install', $format);
$worksheet2->write($row+$i, $col+8, 'Windows Install', $format);
$worksheet2->write($row+$i, $col+9, 'Facebook Install', $format);
$worksheet2->write($row+$i, $col+10, 'Chrome Install', $format);
$worksheet2->write($row+$i, $col+11, 'Firefox', $format);
$worksheet2->write($row+$i, $col+12, 'Web  ', $format);

$strSQLUK="SELECT * FROM oist_countries_breakdown WHERE datein LIKE '$current_date%' AND country='UNITED KINGDOM' ORDER BY datein";	
$sth_uk = $dbh_oist->prepare($strSQLUK);
$sth_uk->execute();

my @countryUK;

while (@countryUK = $sth_uk->fetchrow()) {
	
$i++;
$worksheet2->write($row+$i, $col, $countryUK[0], $format1);
$worksheet2->write($row+$i, $col+1, $countryUK[2], $format1);
$worksheet2->write($row+$i, $col+2, $countryUK[3], $format1);
$worksheet2->write($row+$i, $col+3, $countryUK[4], $format1);
$worksheet2->write($row+$i, $col+4, $countryUK[5], $format1);
$worksheet2->write($row+$i, $col+5, $countryUK[6], $format1);
$worksheet2->write($row+$i, $col+6, $countryUK[7], $format1);
$worksheet2->write($row+$i, $col+7, $countryUK[8], $format1);
$worksheet2->write($row+$i, $col+8, $countryUK[9], $format1);
$worksheet2->write($row+$i, $col+9, $countryUK[10], $format1);
$worksheet2->write($row+$i, $col+10, $countryUK[11], $format1);
$worksheet2->write($row+$i, $col+11, $countryUK[12], $format1);
$worksheet2->write($row+$i, $col+12, $countryUK[13], $format1);

	}
	
#SAUDI ARABIA	
$i = $i+3;

$row = $row+$i;

$worksheet2->write($row, $col, 'SAUDI ARABIA', $format2);

$i=2;

$worksheet2->write($row+$i, $col, 'Date', $format);
$worksheet2->write($row+$i, $col+1, 'Installs', $format);
$worksheet2->write($row+$i, $col+2, 'Registrations', $format);
$worksheet2->write($row+$i, $col+3, 'Total Msgs Sent', $format);
$worksheet2->write($row+$i, $col+4, 'Total Msgs Received', $format);
$worksheet2->write($row+$i, $col+5, 'iOS Install', $format);
$worksheet2->write($row+$i, $col+6, 'Android Install', $format);
$worksheet2->write($row+$i, $col+7, 'BlackBerry Install', $format);
$worksheet2->write($row+$i, $col+8, 'Windows Install', $format);
$worksheet2->write($row+$i, $col+9, 'Facebook Install', $format);
$worksheet2->write($row+$i, $col+10, 'Chrome Install', $format);
$worksheet2->write($row+$i, $col+11, 'Firefox', $format);
$worksheet2->write($row+$i, $col+12, 'Web  ', $format);

$strSQLSAUDI="SELECT * FROM oist_countries_breakdown WHERE datein LIKE '$current_date%' AND country='SAUDI ARABIA' ORDER BY datein";	
$sth_saudi = $dbh_oist->prepare($strSQLSAUDI);
$sth_saudi->execute();

my @countrySAUDI;

while (@countrySAUDI = $sth_saudi->fetchrow()) {
	
$i++;
$worksheet2->write($row+$i, $col, $countrySAUDI[0], $format1);
$worksheet2->write($row+$i, $col+1, $countrySAUDI[2], $format1);
$worksheet2->write($row+$i, $col+2, $countrySAUDI[3], $format1);
$worksheet2->write($row+$i, $col+3, $countrySAUDI[4], $format1);
$worksheet2->write($row+$i, $col+4, $countrySAUDI[5], $format1);
$worksheet2->write($row+$i, $col+5, $countrySAUDI[6], $format1);
$worksheet2->write($row+$i, $col+6, $countrySAUDI[7], $format1);
$worksheet2->write($row+$i, $col+7, $countrySAUDI[8], $format1);
$worksheet2->write($row+$i, $col+8, $countrySAUDI[9], $format1);
$worksheet2->write($row+$i, $col+9, $countrySAUDI[10], $format1);
$worksheet2->write($row+$i, $col+10, $countrySAUDI[11], $format1);
$worksheet2->write($row+$i, $col+11, $countrySAUDI[12], $format1);
$worksheet2->write($row+$i, $col+12, $countrySAUDI[13], $format1);

	}

#JAPAN	
$i = $i+3;

$row = $row+$i;

$worksheet2->write($row, $col, 'JAPAN', $format2);

$i=2;

$worksheet2->write($row+$i, $col, 'Date', $format);
$worksheet2->write($row+$i, $col+1, 'Installs', $format);
$worksheet2->write($row+$i, $col+2, 'Registrations', $format);
$worksheet2->write($row+$i, $col+3, 'Total Msgs Sent', $format);
$worksheet2->write($row+$i, $col+4, 'Total Msgs Received', $format);
$worksheet2->write($row+$i, $col+5, 'iOS Install', $format);
$worksheet2->write($row+$i, $col+6, 'Android Install', $format);
$worksheet2->write($row+$i, $col+7, 'BlackBerry Install', $format);
$worksheet2->write($row+$i, $col+8, 'Windows Install', $format);
$worksheet2->write($row+$i, $col+9, 'Facebook Install', $format);
$worksheet2->write($row+$i, $col+10, 'Chrome Install', $format);
$worksheet2->write($row+$i, $col+11, 'Firefox', $format);
$worksheet2->write($row+$i, $col+12, 'Web  ', $format);

$strSQLJPN="SELECT * FROM oist_countries_breakdown WHERE datein LIKE '$current_date%' AND country='JAPAN' ORDER BY datein";	
$sth_jpn = $dbh_oist->prepare($strSQLJPN);
$sth_jpn->execute();

my @countryJPN;

while (@countryJPN = $sth_jpn->fetchrow()) {
	
$i++;
$worksheet2->write($row+$i, $col, $countryJPN[0], $format1);
$worksheet2->write($row+$i, $col+1, $countryJPN[2], $format1);
$worksheet2->write($row+$i, $col+2, $countryJPN[3], $format1);
$worksheet2->write($row+$i, $col+3, $countryJPN[4], $format1);
$worksheet2->write($row+$i, $col+4, $countryJPN[5], $format1);
$worksheet2->write($row+$i, $col+5, $countryJPN[6], $format1);
$worksheet2->write($row+$i, $col+6, $countryJPN[7], $format1);
$worksheet2->write($row+$i, $col+7, $countryJPN[8], $format1);
$worksheet2->write($row+$i, $col+8, $countryJPN[9], $format1);
$worksheet2->write($row+$i, $col+9, $countryJPN[10], $format1);
$worksheet2->write($row+$i, $col+10, $countryJPN[11], $format1);
$worksheet2->write($row+$i, $col+11, $countryJPN[12], $format1);
$worksheet2->write($row+$i, $col+12, $countryJPN[13], $format1);

	}

#SINGAPORE	
$i = $i+3;

$row = $row+$i;

$worksheet2->write($row, $col, 'SINGAPORE', $format2);

$i=2;

$worksheet2->write($row+$i, $col, 'Date', $format);
$worksheet2->write($row+$i, $col+1, 'Installs', $format);
$worksheet2->write($row+$i, $col+2, 'Registrations', $format);
$worksheet2->write($row+$i, $col+3, 'Total Msgs Sent', $format);
$worksheet2->write($row+$i, $col+4, 'Total Msgs Received', $format);
$worksheet2->write($row+$i, $col+5, 'iOS Install', $format);
$worksheet2->write($row+$i, $col+6, 'Android Install', $format);
$worksheet2->write($row+$i, $col+7, 'BlackBerry Install', $format);
$worksheet2->write($row+$i, $col+8, 'Windows Install', $format);
$worksheet2->write($row+$i, $col+9, 'Facebook Install', $format);
$worksheet2->write($row+$i, $col+10, 'Chrome Install', $format);
$worksheet2->write($row+$i, $col+11, 'Firefox', $format);
$worksheet2->write($row+$i, $col+12, 'Web  ', $format);

$strSQLSG="SELECT * FROM oist_countries_breakdown WHERE datein LIKE '$current_date%' AND country='SINGAPORE' ORDER BY datein";	
$sth_sg = $dbh_oist->prepare($strSQLSG);
$sth_sg->execute();

my @countrySG;

while (@countrySG = $sth_sg->fetchrow()) {
	
$i++;
$worksheet2->write($row+$i, $col, $countrySG[0], $format1);
$worksheet2->write($row+$i, $col+1, $countrySG[2], $format1);
$worksheet2->write($row+$i, $col+2, $countrySG[3], $format1);
$worksheet2->write($row+$i, $col+3, $countrySG[4], $format1);
$worksheet2->write($row+$i, $col+4, $countrySG[5], $format1);
$worksheet2->write($row+$i, $col+5, $countrySG[6], $format1);
$worksheet2->write($row+$i, $col+6, $countrySG[7], $format1);
$worksheet2->write($row+$i, $col+7, $countrySG[8], $format1);
$worksheet2->write($row+$i, $col+8, $countrySG[9], $format1);
$worksheet2->write($row+$i, $col+9, $countrySG[10], $format1);
$worksheet2->write($row+$i, $col+10, $countrySG[11], $format1);
$worksheet2->write($row+$i, $col+11, $countrySG[12], $format1);
$worksheet2->write($row+$i, $col+12, $countrySG[13], $format1);

	}

#MALAYSIA	
$i = $i+3;

$row = $row+$i;

$worksheet2->write($row, $col, 'MALAYSIA', $format2);

$i=2;

$worksheet2->write($row+$i, $col, 'Date', $format);
$worksheet2->write($row+$i, $col+1, 'Installs', $format);
$worksheet2->write($row+$i, $col+2, 'Registrations', $format);
$worksheet2->write($row+$i, $col+3, 'Total Msgs Sent', $format);
$worksheet2->write($row+$i, $col+4, 'Total Msgs Received', $format);
$worksheet2->write($row+$i, $col+5, 'iOS Install', $format);
$worksheet2->write($row+$i, $col+6, 'Android Install', $format);
$worksheet2->write($row+$i, $col+7, 'BlackBerry Install', $format);
$worksheet2->write($row+$i, $col+8, 'Windows Install', $format);
$worksheet2->write($row+$i, $col+9, 'Facebook Install', $format);
$worksheet2->write($row+$i, $col+10, 'Chrome Install', $format);
$worksheet2->write($row+$i, $col+11, 'Firefox', $format);
$worksheet2->write($row+$i, $col+12, 'Web  ', $format);

$strSQLMY="SELECT * FROM oist_countries_breakdown WHERE datein LIKE '$current_date%' AND country='MALAYSIA' ORDER BY datein";	
$sth_my = $dbh_oist->prepare($strSQLMY);
$sth_my->execute();

my @countryMY;

while (@countryMY = $sth_my->fetchrow()) {
	
$i++;
$worksheet2->write($row+$i, $col, $countryMY[0], $format1);
$worksheet2->write($row+$i, $col+1, $countryMY[2], $format1);
$worksheet2->write($row+$i, $col+2, $countryMY[3], $format1);
$worksheet2->write($row+$i, $col+3, $countryMY[4], $format1);
$worksheet2->write($row+$i, $col+4, $countryMY[5], $format1);
$worksheet2->write($row+$i, $col+5, $countryMY[6], $format1);
$worksheet2->write($row+$i, $col+6, $countryMY[7], $format1);
$worksheet2->write($row+$i, $col+7, $countryMY[8], $format1);
$worksheet2->write($row+$i, $col+8, $countryMY[9], $format1);
$worksheet2->write($row+$i, $col+9, $countryMY[10], $format1);
$worksheet2->write($row+$i, $col+10, $countryMY[11], $format1);
$worksheet2->write($row+$i, $col+11, $countryMY[12], $format1);
$worksheet2->write($row+$i, $col+12, $countryMY[13], $format1);

	}

#CANADA	
$i = $i+3;

$row = $row+$i;

$worksheet2->write($row, $col, 'CANADA', $format2);

$i=2;

$worksheet2->write($row+$i, $col, 'Date', $format);
$worksheet2->write($row+$i, $col+1, 'Installs', $format);
$worksheet2->write($row+$i, $col+2, 'Registrations', $format);
$worksheet2->write($row+$i, $col+3, 'Total Msgs Sent', $format);
$worksheet2->write($row+$i, $col+4, 'Total Msgs Received', $format);
$worksheet2->write($row+$i, $col+5, 'iOS Install', $format);
$worksheet2->write($row+$i, $col+6, 'Android Install', $format);
$worksheet2->write($row+$i, $col+7, 'BlackBerry Install', $format);
$worksheet2->write($row+$i, $col+8, 'Windows Install', $format);
$worksheet2->write($row+$i, $col+9, 'Facebook Install', $format);
$worksheet2->write($row+$i, $col+10, 'Chrome Install', $format);
$worksheet2->write($row+$i, $col+11, 'Firefox', $format);
$worksheet2->write($row+$i, $col+12, 'Web  ', $format);

$strSQLCAN="SELECT * FROM oist_countries_breakdown WHERE datein LIKE '$current_date%' AND country='CANADA' ORDER BY datein";	
$sth_can = $dbh_oist->prepare($strSQLCAN);
$sth_can->execute();

my @countryCAN;

while (@countryCAN = $sth_can->fetchrow()) {
	
$i++;
$worksheet2->write($row+$i, $col, $countryCAN[0], $format1);
$worksheet2->write($row+$i, $col+1, $countryCAN[2], $format1);
$worksheet2->write($row+$i, $col+2, $countryCAN[3], $format1);
$worksheet2->write($row+$i, $col+3, $countryCAN[4], $format1);
$worksheet2->write($row+$i, $col+4, $countryCAN[5], $format1);
$worksheet2->write($row+$i, $col+5, $countryCAN[6], $format1);
$worksheet2->write($row+$i, $col+6, $countryCAN[7], $format1);
$worksheet2->write($row+$i, $col+7, $countryCAN[8], $format1);
$worksheet2->write($row+$i, $col+8, $countryCAN[9], $format1);
$worksheet2->write($row+$i, $col+9, $countryCAN[10], $format1);
$worksheet2->write($row+$i, $col+10, $countryCAN[11], $format1);
$worksheet2->write($row+$i, $col+11, $countryCAN[12], $format1);
$worksheet2->write($row+$i, $col+12, $countryCAN[13], $format1);

	}
	
#AUSTRALIA	
$i = $i+3;

$row = $row+$i;

$worksheet2->write($row, $col, 'AUSTRALIA', $format2);

$i=2;

$worksheet2->write($row+$i, $col, 'Date', $format);
$worksheet2->write($row+$i, $col+1, 'Installs', $format);
$worksheet2->write($row+$i, $col+2, 'Registrations', $format);
$worksheet2->write($row+$i, $col+3, 'Total Msgs Sent', $format);
$worksheet2->write($row+$i, $col+4, 'Total Msgs Received', $format);
$worksheet2->write($row+$i, $col+5, 'iOS Install', $format);
$worksheet2->write($row+$i, $col+6, 'Android Install', $format);
$worksheet2->write($row+$i, $col+7, 'BlackBerry Install', $format);
$worksheet2->write($row+$i, $col+8, 'Windows Install', $format);
$worksheet2->write($row+$i, $col+9, 'Facebook Install', $format);
$worksheet2->write($row+$i, $col+10, 'Chrome Install', $format);
$worksheet2->write($row+$i, $col+11, 'Firefox', $format);
$worksheet2->write($row+$i, $col+12, 'Web  ', $format);

$strSQLAUS="SELECT * FROM oist_countries_breakdown WHERE datein LIKE '$current_date%' AND country='AUSTRALIA' ORDER BY datein";	
$sth_aus = $dbh_oist->prepare($strSQLAUS);
$sth_aus->execute();

my @countryAUS;

while (@countryAUS = $sth_aus->fetchrow()) {
	
$i++;
$worksheet2->write($row+$i, $col, $countryAUS[0], $format1);
$worksheet2->write($row+$i, $col+1, $countryAUS[2], $format1);
$worksheet2->write($row+$i, $col+2, $countryAUS[3], $format1);
$worksheet2->write($row+$i, $col+3, $countryAUS[4], $format1);
$worksheet2->write($row+$i, $col+4, $countryAUS[5], $format1);
$worksheet2->write($row+$i, $col+5, $countryAUS[6], $format1);
$worksheet2->write($row+$i, $col+6, $countryAUS[7], $format1);
$worksheet2->write($row+$i, $col+7, $countryAUS[8], $format1);
$worksheet2->write($row+$i, $col+8, $countryAUS[9], $format1);
$worksheet2->write($row+$i, $col+9, $countryAUS[10], $format1);
$worksheet2->write($row+$i, $col+10, $countryAUS[11], $format1);
$worksheet2->write($row+$i, $col+11, $countryAUS[12], $format1);
$worksheet2->write($row+$i, $col+12, $countryAUS[13], $format1);

	}

#QATAR	
$i = $i+3;

$row = $row+$i;

$worksheet2->write($row, $col, 'QATAR', $format2);

$i=2;

$worksheet2->write($row+$i, $col, 'Date', $format);
$worksheet2->write($row+$i, $col+1, 'Installs', $format);
$worksheet2->write($row+$i, $col+2, 'Registrations', $format);
$worksheet2->write($row+$i, $col+3, 'Total Msgs Sent', $format);
$worksheet2->write($row+$i, $col+4, 'Total Msgs Received', $format);
$worksheet2->write($row+$i, $col+5, 'iOS Install', $format);
$worksheet2->write($row+$i, $col+6, 'Android Install', $format);
$worksheet2->write($row+$i, $col+7, 'BlackBerry Install', $format);
$worksheet2->write($row+$i, $col+8, 'Windows Install', $format);
$worksheet2->write($row+$i, $col+9, 'Facebook Install', $format);
$worksheet2->write($row+$i, $col+10, 'Chrome Install', $format);
$worksheet2->write($row+$i, $col+11, 'Firefox', $format);
$worksheet2->write($row+$i, $col+12, 'Web  ', $format);

$strSQLQATAR="SELECT * FROM oist_countries_breakdown WHERE datein LIKE '$current_date%' AND country='QATAR' ORDER BY datein";	
$sth_qatar = $dbh_oist->prepare($strSQLQATAR);
$sth_qatar->execute();

my @countryQATAR;

while (@countryQATAR = $sth_qatar->fetchrow()) {
	
$i++;
$worksheet2->write($row+$i, $col, $countryQATAR[0], $format1);
$worksheet2->write($row+$i, $col+1, $countryQATAR[2], $format1);
$worksheet2->write($row+$i, $col+2, $countryQATAR[3], $format1);
$worksheet2->write($row+$i, $col+3, $countryQATAR[4], $format1);
$worksheet2->write($row+$i, $col+4, $countryQATAR[5], $format1);
$worksheet2->write($row+$i, $col+5, $countryQATAR[6], $format1);
$worksheet2->write($row+$i, $col+6, $countryQATAR[7], $format1);
$worksheet2->write($row+$i, $col+7, $countryQATAR[8], $format1);
$worksheet2->write($row+$i, $col+8, $countryQATAR[9], $format1);
$worksheet2->write($row+$i, $col+9, $countryQATAR[10], $format1);
$worksheet2->write($row+$i, $col+10, $countryQATAR[11], $format1);
$worksheet2->write($row+$i, $col+11, $countryQATAR[12], $format1);
$worksheet2->write($row+$i, $col+12, $countryQATAR[13], $format1);

	}

#SOUTH KOREA	
$i = $i+3;

$row = $row+$i;

$worksheet2->write($row, $col, 'SOUTH KOREA', $format2);

$i=2;

$worksheet2->write($row+$i, $col, 'Date', $format);
$worksheet2->write($row+$i, $col+1, 'Installs', $format);
$worksheet2->write($row+$i, $col+2, 'Registrations', $format);
$worksheet2->write($row+$i, $col+3, 'Total Msgs Sent', $format);
$worksheet2->write($row+$i, $col+4, 'Total Msgs Received', $format);
$worksheet2->write($row+$i, $col+5, 'iOS Install', $format);
$worksheet2->write($row+$i, $col+6, 'Android Install', $format);
$worksheet2->write($row+$i, $col+7, 'BlackBerry Install', $format);
$worksheet2->write($row+$i, $col+8, 'Windows Install', $format);
$worksheet2->write($row+$i, $col+9, 'Facebook Install', $format);
$worksheet2->write($row+$i, $col+10, 'Chrome Install', $format);
$worksheet2->write($row+$i, $col+11, 'Firefox', $format);
$worksheet2->write($row+$i, $col+12, 'Web  ', $format);

$strSQLKOREA="SELECT * FROM oist_countries_breakdown WHERE datein LIKE '$current_date%' AND country='SOUTH KOREA' ORDER BY datein";	
$sth_korea = $dbh_oist->prepare($strSQLKOREA);
$sth_korea->execute();

my @countryKOREA;

while (@countryKOREA = $sth_korea->fetchrow()) {
	
$i++;
$worksheet2->write($row+$i, $col, $countryKOREA[0], $format1);
$worksheet2->write($row+$i, $col+1, $countryKOREA[2], $format1);
$worksheet2->write($row+$i, $col+2, $countryKOREA[3], $format1);
$worksheet2->write($row+$i, $col+3, $countryKOREA[4], $format1);
$worksheet2->write($row+$i, $col+4, $countryKOREA[5], $format1);
$worksheet2->write($row+$i, $col+5, $countryKOREA[6], $format1);
$worksheet2->write($row+$i, $col+6, $countryKOREA[7], $format1);
$worksheet2->write($row+$i, $col+7, $countryKOREA[8], $format1);
$worksheet2->write($row+$i, $col+8, $countryKOREA[9], $format1);
$worksheet2->write($row+$i, $col+9, $countryKOREA[10], $format1);
$worksheet2->write($row+$i, $col+10, $countryKOREA[11], $format1);
$worksheet2->write($row+$i, $col+11, $countryKOREA[12], $format1);
$worksheet2->write($row+$i, $col+12, $countryKOREA[13], $format1);

	}

#HONG KONG	
$i = $i+3;

$row = $row+$i;

$worksheet2->write($row, $col, 'HONG KONG', $format2);

$i=2;

$worksheet2->write($row+$i, $col, 'Date', $format);
$worksheet2->write($row+$i, $col+1, 'Installs', $format);
$worksheet2->write($row+$i, $col+2, 'Registrations', $format);
$worksheet2->write($row+$i, $col+3, 'Total Msgs Sent', $format);
$worksheet2->write($row+$i, $col+4, 'Total Msgs Received', $format);
$worksheet2->write($row+$i, $col+5, 'iOS Install', $format);
$worksheet2->write($row+$i, $col+6, 'Android Install', $format);
$worksheet2->write($row+$i, $col+7, 'BlackBerry Install', $format);
$worksheet2->write($row+$i, $col+8, 'Windows Install', $format);
$worksheet2->write($row+$i, $col+9, 'Facebook Install', $format);
$worksheet2->write($row+$i, $col+10, 'Chrome Install', $format);
$worksheet2->write($row+$i, $col+11, 'Firefox', $format);
$worksheet2->write($row+$i, $col+12, 'Web  ', $format);

$strSQLHK="SELECT * FROM oist_countries_breakdown WHERE datein LIKE '$current_date%' AND country='HONG KONG' ORDER BY datein";	
$sth_hk = $dbh_oist->prepare($strSQLHK);
$sth_hk->execute();

my @countryHK;

while (@countryHK = $sth_hk->fetchrow()) {
	
$i++;
$worksheet2->write($row+$i, $col, $countryHK[0], $format1);
$worksheet2->write($row+$i, $col+1, $countryHK[2], $format1);
$worksheet2->write($row+$i, $col+2, $countryHK[3], $format1);
$worksheet2->write($row+$i, $col+3, $countryHK[4], $format1);
$worksheet2->write($row+$i, $col+4, $countryHK[5], $format1);
$worksheet2->write($row+$i, $col+5, $countryHK[6], $format1);
$worksheet2->write($row+$i, $col+6, $countryHK[7], $format1);
$worksheet2->write($row+$i, $col+7, $countryHK[8], $format1);
$worksheet2->write($row+$i, $col+8, $countryHK[9], $format1);
$worksheet2->write($row+$i, $col+9, $countryHK[10], $format1);
$worksheet2->write($row+$i, $col+10, $countryHK[11], $format1);
$worksheet2->write($row+$i, $col+11, $countryHK[12], $format1);
$worksheet2->write($row+$i, $col+12, $countryHK[13], $format1);

	}
	
$workbook->close();
 binmode STDOUT;

$from = "do-not-reply\@chikka.com";
$to = "mbmalano\@chikka.com";
$cc = "mbmalano\@chikka.com";
$Subject = "OIST Stats , ".$current_day;

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
			<span style="font-size:14px;"><span style="font-family: arial, helvetica, sans-serif;">OIST Stats for the Month of $txt_month.</span></span></p>
		<p>
			<span style="font-size:14px;"><span style="font-family: arial, helvetica, sans-serif;">Please refer to the attachment.</span></span></p>
		<p>
			&nbsp;</p>
		<div>
			<span style="font-size:14px;"><span style="font-family: arial, helvetica, sans-serif;">Regards,</span></span></div>
		<div>
			<span style="font-size:14px;"><span style="font-family: arial, helvetica, sans-serif;">CHIKKA DBA TEAM</span></span></div>
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

