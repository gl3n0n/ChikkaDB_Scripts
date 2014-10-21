#!/usr/bin/perl

use strict;
use lib "/home/dba_scripts/oist_stat/Lib";
use common;
use myconstants;
use DB;

my $current_date = "";

my $event_type = $ARGV[0]; 
if ($ARGV[1]) { 

$current_date = $ARGV[1];

} else {
$current_date = common::currentDate();

}

my $tbl_date = $current_date; 
$tbl_date =~ s/\-//g;

print $tbl_date;

my $dbh_oist = DB::DBconnect(myconstants::OIST_DB,myconstants::OIST_HOST,myconstants::OIST_USER,myconstants::OIST_PASSWORD);
 
 
#my $filename = "/var/log/oist/".$event_type."_success.log.".$current_date."";
#my $insert_data = '';
#my $sth1 = "";
#
#
#my $drop_tbl = "DROP TABLE IF EXISTS `oist_log`.`oist_".$event_type."_".$tbl_date."`";
#my $sth_drop="";
#$sth_drop = $dbh_oist->prepare($drop_tbl);
#$sth_drop->execute();
#
#my $qry_create = "CREATE TABLE `oist_log`.`oist_".$event_type."_".$tbl_date."` (
#  `reg_date` date DEFAULT NULL,
#  `reg_time` varchar(10) DEFAULT NULL,
#  `reg_seconds` varchar(30) DEFAULT NULL,
#  `ts` varchar(50) DEFAULT NULL,
#  `event_type` varchar(50) DEFAULT NULL,
#  `mobile_number` varchar(20) DEFAULT NULL,
#  `client_type` varchar(50) DEFAULT NULL,
#  `client_ip` varchar(30) DEFAULT NULL,
#  `status` varchar(20) DEFAULT NULL
#) ENGINE=MyISAM DEFAULT CHARSET=latin1";
#
#print $qry_create;
#
#my $sth2="";
#$sth2 = $dbh_oist->prepare($qry_create);
#$sth2->execute();
#
#       
#open(INFILE,"$filename") || die "cannot open config file : $filename";
#
#while(<INFILE>)
#{
##2013-03-24 20:38:52,616 registration_success    INFO    1364128732.491166       registration    +639178544725   android 112.199.83.108  false
#
# if($_ =~ m/(\d+-\d+-\d+)\s+(\d+:\d+):(.*)\s+(\w+)\s+\w+\s+(.*)\s+(\w+)\s+(.*)\s+(.*)\s+(.*)\s+(\w+)/g)  
#  {
#   	
#   	  $insert_data = "INSERT into `oist_log`.`oist_".$event_type."_".$tbl_date."` VALUES ('".$1."','".$2."','".$3."','".$5."','".$6."',replace('".$7."','+',''),'".$8."','".$9."','".$10."')";
#      print "[$1] [$2] [$3] [$4] [$5] [$6] [$7] [$8] [$9] [$10]\n";
#      $sth1 = $dbh_oist->prepare($insert_data);
#      $sth1 -> execute();        
#   }
#}


#my $qry_sms_all = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='GLOBE'";
#my $qry_sms_post = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='GLOBE' AND sim_type='POSTPAID'";
#my $qry_sms_tm = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='GLOBE' AND sim_type='TM'";



my $sth_globe_postpaid="";
my $qry_globe_postpaid = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='GLOBE' AND sim_type='POSTPAID'";
$sth_globe_postpaid = $dbh_oist->prepare($qry_globe_postpaid);
$sth_globe_postpaid->execute();

my $sth_globe_prepaid="";
my $qry_globe_prepaid = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='GLOBE' AND sim_type='PREPAID'";
$sth_globe_prepaid = $dbh_oist->prepare($qry_globe_prepaid);
$sth_globe_prepaid->execute();

my $sth_globe_tm="";
my $qry_globe_tm = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='GLOBE' AND sim_type='TM'";
$sth_globe_tm = $dbh_oist->prepare($qry_globe_tm);
$sth_globe_tm->execute();


my @globe_postpaid = $sth_globe_postpaid->fetchrow_array();
my @globe_prepaid = $sth_globe_prepaid->fetchrow_array();
my @globe_tm = $sth_globe_tm->fetchrow_array();

my $sth_globe_cnt_postpaid="";
my $qry_globe_cnt_postpaid = "SELECT COUNT(1) FROM `oist_log`.`oist_".$event_type."_".$tbl_date."` WHERE mobile_number REGEXP '^".$globe_postpaid[0]."\$' AND status='true'";
$sth_globe_cnt_postpaid = $dbh_oist->prepare($qry_globe_cnt_postpaid);
$sth_globe_cnt_postpaid->execute();

my $sth_globe_cnt_prepaid="";
my $qry_globe_cnt_prepaid = "SELECT COUNT(1) FROM `oist_log`.`oist_".$event_type."_".$tbl_date."` WHERE mobile_number REGEXP '^".$globe_prepaid[0]."\$' AND status='true'";
$sth_globe_cnt_prepaid = $dbh_oist->prepare($qry_globe_cnt_prepaid);
$sth_globe_cnt_prepaid->execute();

my $sth_globe_cnt_tm="";
my $qry_globe_cnt_tm = "SELECT COUNT(1) FROM `oist_log`.`oist_".$event_type."_".$tbl_date."` WHERE mobile_number REGEXP '^".$globe_tm[0]."\$' AND status='true'";
$sth_globe_cnt_tm = $dbh_oist->prepare($qry_globe_cnt_tm);
$sth_globe_cnt_tm->execute();

my @globe_cnt_postpaid = $sth_globe_cnt_postpaid->fetchrow_array();
my @globe_cnt_prepaid = $sth_globe_cnt_prepaid->fetchrow_array();
my @globe_cnt_tm = $sth_globe_cnt_tm->fetchrow_array();

print $globe_cnt_postpaid[0]; 
print "\n";
print $globe_cnt_prepaid[0]; 
print "\n";
print $globe_cnt_tm[0]; 


my $sth_qry_insert;
my $qry_insert = "REPLACE INTO oist_globe_daily_registration VALUES ('$current_date',0,$globe_cnt_postpaid[0],$globe_cnt_prepaid[0],$globe_cnt_tm[0]);";
$sth_qry_insert = $dbh_oist->prepare($qry_insert);
$sth_qry_insert->execute();


#my $sth_globe_update_new_reg="";
#my $update_globe_stat = "UPDATE oist_stat.oist_stat_globe SET new_regs=$globe_cnt_all_sms[0] WHERE datein='$current_date'";
#$sth_globe_update_new_reg = $dbh_oist->prepare($update_globe_stat);
#$sth_globe_update_new_reg->execute();
#
#my $sth_smart_update_new_reg="";
#my $update_smart_stat = "UPDATE oist_stat.oist_stat_smart SET new_regs=$smart_cnt_all_sms[0] WHERE datein='$current_date'";
#$sth_smart_update_new_reg = $dbh_oist->prepare($update_smart_stat);
#$sth_smart_update_new_reg->execute();
#
#my $sth_sun_update_new_reg="";
#my $update_sun_stat = "UPDATE oist_stat.oist_stat_sun SET new_regs=$sun_cnt_all_sms[0] WHERE datein='$current_date'";
#$sth_sun_update_new_reg = $dbh_oist->prepare($update_sun_stat);
#$sth_sun_update_new_reg->execute();

#$sth1->finish();

#$qry_cnt_event = "SELECT COUNT(1) FROM `oist_log`.`oist_".$event_type."_".$tbl_date."` WHERE status='true'";
#$sth_cnt_event = $dbh_oist->prepare($qry_cnt_event);
#$sth_cnt_event -> execute();   
#
#my @event_count = $sth_cnt_event->fetchrow_array();	  
#
#UPDATE
	  
close INFILE;

##my $sth_insert_reg_client;
##
##my $strSQLperClient = "REPLACE INTO oist_client_breakdown(datein,client_type,new_registrations,new_reg_mobile,new_reg_facebook,globe_reg,smart_reg,sun_reg) SELECT '$current_date',client_type,COUNT(1) as total_cnt,SUM(CASE WHEN mobile_number NOT REGEXP '^08' THEN 1 ELSE 0 END)as reg_mobile_cnt,SUM(CASE WHEN mobile_number REGEXP '^08' THEN 1 ELSE 0 END) as reg_fb_cnt,SUM(CASE WHEN mobile_number REGEXP '^".$globe_all_pattern[0]."\$'  THEN 1 ELSE 0 END) as globe_reg,SUM(CASE WHEN mobile_number REGEXP '^".$smart_all_pattern[0]."\$'  THEN 1 ELSE 0 END) as smart_reg,SUM(CASE WHEN mobile_number REGEXP '^".$sun_all_pattern[0]."\$'  THEN 1 ELSE 0 END) as sun_reg  FROM `oist_log`.`oist_".$event_type."_".$tbl_date."`  WHERE status='true' GROUP BY client_type";
##print $strSQLperClient;
##$sth_insert_reg_client = $dbh_oist->prepare($strSQLperClient);
##$sth_insert_reg_client->execute();
