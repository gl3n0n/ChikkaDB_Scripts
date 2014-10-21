#!/usr/bin/perl

use strict;
use lib "/home/dba_scripts/oist_stat/Lib";
use common;
use myconstants;
use DB;

my $current_date = "";

if ($ARGV[0]) { 

$current_date = $ARGV[0];

} else {
$current_date = common::currentDate();

}


my $charging = common::chargingOperator('SMART');
#
#print "charging:".$charging;

print "Current Date:".$current_date;

my $dbh_oist = DB::DBconnect(myconstants::OIST_DB,myconstants::OIST_HOST,myconstants::OIST_USER,myconstants::OIST_PASSWORD);
my $dbh_csg = DB::DBconnect(myconstants::CSG_V3_DB,myconstants::CSG_V3_HOST,myconstants::CSG_V3_USER,myconstants::CSG_V3_PASSWORD);



my $sth_globe_all = "";
my $sth_globe_post = "";
my $sth_globe_tm  = "";
#$qry_sms_mobile = "SELECT gsm_num FROM sms_out WHERE datesent ='$current_date' AND left(gsm_num,5) IN (".$prefix_mobile.")  GROUP BY 1";

my $qry_sms_all = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='SMART'";
my $qry_sms_post = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='SMART' AND sim_type='POSTPAID'";
my $qry_sms_tm = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='SMART' AND sim_type='TNT'";



$sth_globe_all = $dbh_oist->prepare($qry_sms_all);
$sth_globe_all->execute();

$sth_globe_post = $dbh_oist->prepare($qry_sms_post);
$sth_globe_post->execute();

$sth_globe_tm = $dbh_oist->prepare($qry_sms_tm);
$sth_globe_tm->execute();



my @globe_all_pattern = $sth_globe_all->fetchrow_array();
my @globe_post_pattern = $sth_globe_post->fetchrow_array();
my @globe_tm_pattern = $sth_globe_tm->fetchrow_array();



#my $qry_globe_all_sms = "SELECT COUNT(1) FROM sms_out WHERE datesent ='$current_date' AND  gsm_num REGEXP '^".$globe_all_pattern[0]."\$'";
my $qry_globe_all_sms = "SELECT COUNT(1) FROM sms_out WHERE datesent ='$current_date' AND  access_code LIKE '277%'";

my $qry_globe_all_unique = "SELECT COUNT(DISTINCT(gsm_num)) FROM sms_out WHERE datesent ='$current_date' AND  gsm_num REGEXP '^".$globe_all_pattern[0]."\$'";
my $qry_globe_postpaid_unique = "SELECT COUNT(DISTINCT(gsm_num)) FROM sms_out WHERE datesent ='$current_date' AND  gsm_num REGEXP '^".$globe_post_pattern[0]."\$'";
my $qry_globe_tm_unique = "SELECT COUNT(DISTINCT(gsm_num)) FROM sms_out WHERE datesent ='$current_date' AND  gsm_num REGEXP '^".$globe_tm_pattern[0]."\$'";

#print $qry_globe_all_sms;

my $sth_globe_cnt_all_sms = "";
my $sth_globe_cnt_all = "";
my $sth_globe_cnt_postpaid = "";
my $sth_globe_cnt_tm = "";

#$qry_insert_unique = "INSERT INTO temp_table_".lc($operator)." VALUES(".$unique_mobile[0].")";
$sth_globe_cnt_all_sms = $dbh_csg->prepare($qry_globe_all_sms);
$sth_globe_cnt_all_sms->execute();
$sth_globe_cnt_all = $dbh_csg->prepare($qry_globe_all_unique);
$sth_globe_cnt_all->execute();
$sth_globe_cnt_postpaid = $dbh_csg->prepare($qry_globe_postpaid_unique);
$sth_globe_cnt_postpaid->execute();
$sth_globe_cnt_tm = $dbh_csg->prepare($qry_globe_tm_unique);
$sth_globe_cnt_tm->execute();


my @globe_cnt_all_sms = $sth_globe_cnt_all_sms->fetchrow_array();
my @globe_cnt_all_unique = $sth_globe_cnt_all->fetchrow_array();
my @globe_cnt_postpaid_unique = $sth_globe_cnt_postpaid->fetchrow_array();
my @globe_cnt_tm_unique = $sth_globe_cnt_tm->fetchrow_array();

print "\n";
print $globe_cnt_all_sms[0];
print "\n";
print "\n";
print $globe_cnt_all_unique[0];
print "\n";
print "\n";
print $globe_cnt_postpaid_unique[0];
print "\n";
print "\n";
print $globe_cnt_tm_unique[0];
print "\n";

my $sth_qry_insert  = "";
my $qry_insert = "REPLACE INTO oist_stat_smart_out (datein,sms_revenue,sms_hits,unique_charged_mins,unique_charged_post,unique_charged_pre,unique_charged_tnt) 
VALUES ('$current_date',$globe_cnt_all_sms[0]*$charging,$globe_cnt_all_sms[0],$globe_cnt_all_unique[0],$globe_cnt_postpaid_unique[0],$globe_cnt_all_unique[0]-($globe_cnt_postpaid_unique[0]+$globe_cnt_tm_unique[0]),$globe_cnt_tm_unique[0])";

$sth_qry_insert = $dbh_oist->prepare($qry_insert);
$sth_qry_insert->execute();


my $sth_qry_update;

my $strUpdateTotalRevenue = "UPDATE oist_stat_smart_out SET total_revenue=sms_revenue+voice_revenue WHERE datein ='$current_date'";
$sth_qry_update = $dbh_oist->prepare($strUpdateTotalRevenue);
$sth_qry_update->execute();



