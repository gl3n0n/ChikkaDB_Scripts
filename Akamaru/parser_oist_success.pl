#!/usr/bin/perl

use strict;
use lib "/home/dba_scripts/oist_stat/Lib";
use common;
use myconstants;
use DB;

my $current_date = "";

#my $event_type = $ARGV[0]; 
if ($ARGV[0]) { 

$current_date = $ARGV[0];

} else {
$current_date = common::currentDate();

}

my $tbl_date = $current_date; 
$tbl_date =~ s/\-//g;

print $tbl_date;

my $dbh_oist = DB::DBconnect(myconstants::OIST_DB,myconstants::OIST_HOST,myconstants::OIST_USER,myconstants::OIST_PASSWORD);
my $dbh_profile = DB::DBconnect(myconstants::PROFILE_DB,myconstants::PROFILE_HOST,myconstants::PROFILE_USER,myconstants::PROFILE_PASSWORD);


######## Retrieve users table ########


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

my $sth_truncate_users;

my $strTruncate = "TRUNCATE temp_users_profile";
$sth_truncate_users = $dbh_oist->prepare($strTruncate);
$sth_truncate_users->execute() or die "SQL Error: $DBI::errstr\n";

	
my $strSQLLoad = "LOAD DATA LOCAL INFILE '".$file_temp."' REPLACE INTO TABLE temp_users_profile";
$sth_load_users = $dbh_oist->prepare($strSQLLoad);
$sth_load_users->execute() or die "SQL Error: $DBI::errstr\n";

######## Retrieve users table ########
 
my $filename = "/var/log/oist/oist_success.log.".$current_date."";
my $insert_data = '';
my $sth1 = "";


my $drop_tbl = "DROP TABLE IF EXISTS `oist_log`.`oist_success_".$tbl_date."`";
my $sth_drop="";
$sth_drop = $dbh_oist->prepare($drop_tbl);
$sth_drop->execute();

my $qry_create = "CREATE TABLE `oist_log`.`oist_success_".$tbl_date."` (
  `reg_date` date DEFAULT NULL,
  `reg_time` varchar(10) DEFAULT NULL,
  `reg_seconds` varchar(30) DEFAULT NULL,
  `event_type` varchar(50) DEFAULT NULL,
  `mobile_number_sender` varchar(20) DEFAULT NULL,
  `mobile_number_recieved` varchar(20) DEFAULT NULL,
  `direction` varchar(30) DEFAULT NULL,
  `client_type` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1";

print $qry_create;

my $sth2="";
$sth2 = $dbh_oist->prepare($qry_create);
$sth2->execute();

       
open(INFILE,"$filename") || die "cannot open config file : $filename";

while(<INFILE>)
{
#2013-03-25 07:43:10,977 oist_success    INFO    +639178544725   +639189087704   outgoing        an-d44c8a2e47ddbdfa


 if($_ =~ m/(\d+-\d+-\d+)\s+(\d+:\d+):(.*)\s+(\w+)\s+\w+\s+(.*)\s+(.*)\s+(\w+)\s+(.*)\s+/g)  
  {
   	
   	  $insert_data = "INSERT into `oist_log`.`oist_success_".$tbl_date."` VALUES ('".$1."','".$2."','".$3."','".$4."',replace('".$5."','\+',''),replace('".$6."','\+',''),'".$7."','".$8."')";
      print "[$1] [$2] [$3] [$4] [$5] [$6] [$7] [$8] \n";
      $sth1 = $dbh_oist->prepare($insert_data);
      $sth1 -> execute();        
   }
}

my $sth_globe_all="";
my $qry_sms_all = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='GLOBE'";
$sth_globe_all = $dbh_oist->prepare($qry_sms_all);
$sth_globe_all->execute();

my $sth_smart_all="";
my $qry_smart_all = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='SMART'";
$sth_smart_all = $dbh_oist->prepare($qry_smart_all);
$sth_smart_all->execute();

my $sth_sun_all="";
my $qry_sun_all = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='SUN'";
$sth_sun_all = $dbh_oist->prepare($qry_sun_all);
$sth_sun_all->execute();


my @globe_all_pattern = $sth_globe_all->fetchrow_array();
my @smart_all_pattern = $sth_smart_all->fetchrow_array();
my @sun_all_pattern = $sth_sun_all->fetchrow_array();

my $sth_globe_cnt_all_sms="";
my $qry_globe_all_sms = "SELECT COUNT(DISTINCT(mobile_number_recieved)) FROM `oist_log`.`oist_success_".$tbl_date."` WHERE mobile_number_recieved REGEXP '^".$globe_all_pattern[0]."\$' AND direction='incoming' and mobile_number_recieved not in (select id FROM oist_stat.temp_users_profile)";
$sth_globe_cnt_all_sms = $dbh_oist->prepare($qry_globe_all_sms);
$sth_globe_cnt_all_sms->execute();

my $sth_smart_cnt_all_sms="";
my $qry_smart_all_sms = "SELECT COUNT(DISTINCT(mobile_number_recieved)) FROM `oist_log`.`oist_success_".$tbl_date."` WHERE mobile_number_recieved REGEXP '^".$smart_all_pattern[0]."\$' AND direction='incoming' and mobile_number_recieved not in (select id FROM oist_stat.temp_users_profile)";
$sth_smart_cnt_all_sms = $dbh_oist->prepare($qry_smart_all_sms);
$sth_smart_cnt_all_sms->execute();

my $sth_sun_cnt_all_sms="";
my $sth_sun_cnt_all_sms = "SELECT COUNT(DISTINCT(mobile_number_recieved)) FROM `oist_log`.`oist_success_".$tbl_date."` WHERE mobile_number_recieved REGEXP '^".$sun_all_pattern[0]."\$' AND direction='incoming' and mobile_number_recieved not in (select id FROM oist_stat.temp_users_profile)";
$sth_sun_cnt_all_sms = $dbh_oist->prepare($sth_sun_cnt_all_sms);
$sth_sun_cnt_all_sms->execute();

#print $qry_smart_all_sms;

my @globe_cnt_all_sms = $sth_globe_cnt_all_sms->fetchrow_array();
my @smart_cnt_all_sms = $sth_smart_cnt_all_sms->fetchrow_array();
my @sun_cnt_all_sms = $sth_sun_cnt_all_sms->fetchrow_array();

print $globe_cnt_all_sms[0]; 
print "\n";
print $smart_cnt_all_sms[0]; 
print "\n";
print $sun_cnt_all_sms[0]; 


my $sth_globe_update_new_reg="";
my $update_globe_stat = "UPDATE oist_stat.oist_stat_globe SET new_non_regs=$globe_cnt_all_sms[0] WHERE datein='$current_date'";
$sth_globe_update_new_reg = $dbh_oist->prepare($update_globe_stat);
$sth_globe_update_new_reg->execute();

my $sth_smart_update_new_reg="";
my $update_smart_stat = "UPDATE oist_stat.oist_stat_smart SET new_non_regs=$smart_cnt_all_sms[0] WHERE datein='$current_date'";
$sth_smart_update_new_reg = $dbh_oist->prepare($update_smart_stat);
$sth_smart_update_new_reg->execute();

my $sth_sun_update_new_reg="";
my $update_sun_stat = "UPDATE oist_stat.oist_stat_sun SET new_non_regs=$sun_cnt_all_sms[0] WHERE datein='$current_date'";
$sth_sun_update_new_reg = $dbh_oist->prepare($update_sun_stat);
$sth_sun_update_new_reg->execute();

	  
close INFILE;

#select android outgoing
my $sth_cnt_outgoing; 

my $strSQLOutgoing="SELECT COUNT(distinct(mobile_number_sender)) as unique_msg_senders ,COUNT(mobile_number_sender) as total_msg_sent FROM `oist_log`.`oist_success_".$tbl_date."` WHERE direction='outgoing' AND mobile_number_sender NOT LIKE 'nagios%' AND client_type REGEXP '^an'";
$sth_cnt_outgoing = $dbh_oist->prepare($strSQLOutgoing);
$sth_cnt_outgoing -> execute();   

#select android incoming
my $sth_cnt_incoming;

my  $strSQLIncoming="SELECT COUNT(mobile_number_recieved) as total_msg_recieved FROM `oist_log`.`oist_success_".$tbl_date."` WHERE direction='incoming' AND mobile_number_recieved NOT LIKE 'nagios%' AND client_type REGEXP '^an'";
$sth_cnt_incoming = $dbh_oist->prepare($strSQLIncoming);
$sth_cnt_incoming -> execute();


my @cnt_outgoing = $sth_cnt_outgoing->fetchrow_array();
my @cnt_incoming = $sth_cnt_incoming->fetchrow_array();

my $sth_update_msg;

my $strSQLUpdatemsg = "UPDATE oist_client_breakdown SET unique_msg_senders=$cnt_outgoing[0],total_msg_sent=$cnt_outgoing[1],total_msg_recieved=$cnt_incoming[0] WHERE datein='$current_date'";
$sth_update_msg = $dbh_oist->prepare($strSQLUpdatemsg);
$sth_update_msg->execute();


#Country Report
#PHILIPPINES
my $sth_ph_all="";
my $qry_pattern_ph = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='PHILIPPINES'";
$sth_ph_all = $dbh_oist->prepare($qry_pattern_ph);
$sth_ph_all->execute();

my @ph_reg_ex = $sth_ph_all->fetchrow_array();

my $sth_ph_cnt_outgoing; 

my $strSQLPHOutgoing="REPLACE INTO oist_countries_breakdown(datein,country,total_msg_sent,total_msg_rcvd) SELECT '$current_date','PHILIPPINES',T1.cnt as total_msg_sent,T2.cnt as total_msg_recieved FROM  (SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_sender NOT LIKE 'nagios%'  AND direction='outgoing' AND mobile_number_sender REGEXP '^".$ph_reg_ex[0]."\$') T1,(SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_recieved NOT LIKE 'nagios%'  AND direction='incoming' AND mobile_number_recieved REGEXP '^".$ph_reg_ex[0]."\$') T2";   
#print $strSQLPHOutgoing;
$sth_ph_cnt_outgoing = $dbh_oist->prepare($strSQLPHOutgoing);
$sth_ph_cnt_outgoing -> execute();

#UNITED STATES
my $sth_us_all="";
my $qry_pattern_us = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='UNITED STATES'";
$sth_us_all = $dbh_oist->prepare($qry_pattern_us);
$sth_us_all->execute();

my @us_reg_ex = $sth_us_all->fetchrow_array();


my $sth_usa_cnt_outgoing; 

my $strSQLUSOutgoing="REPLACE INTO oist_countries_breakdown(datein,country,total_msg_sent,total_msg_rcvd) SELECT '$current_date','UNITED STATES',T1.cnt as total_msg_sent,T2.cnt as total_msg_recieved FROM  (SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_sender NOT LIKE 'nagios%'  AND direction='outgoing' AND mobile_number_sender REGEXP '^".$us_reg_ex[0]."\$') T1,(SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_recieved NOT LIKE 'nagios%'  AND direction='incoming' AND mobile_number_recieved REGEXP '^".$us_reg_ex[0]."\$') T2";   
$sth_usa_cnt_outgoing = $dbh_oist->prepare($strSQLUSOutgoing);
$sth_usa_cnt_outgoing -> execute();

#UNITED ARAB EMIRATES
my $sth_uae_all="";
my $qry_pattern_uae = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='UAE'";
$sth_uae_all = $dbh_oist->prepare($qry_pattern_uae);
$sth_uae_all->execute();

my @uae_reg_ex = $sth_uae_all->fetchrow_array();

my $sth_uae_cnt_outgoing; 

my $strSQLUAEOutgoing="REPLACE INTO oist_countries_breakdown(datein,country,total_msg_sent,total_msg_rcvd) SELECT '$current_date','UNITED ARAB EMIRATES',T1.cnt as total_msg_sent,T2.cnt as total_msg_recieved FROM  (SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_sender NOT LIKE 'nagios%'  AND direction='outgoing' AND mobile_number_sender REGEXP '^".$uae_reg_ex[0]."\$') T1,(SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_recieved NOT LIKE 'nagios%'  AND direction='incoming' AND mobile_number_recieved REGEXP '^".$uae_reg_ex[0]."\$') T2";   
$sth_uae_cnt_outgoing = $dbh_oist->prepare($strSQLUAEOutgoing);
$sth_uae_cnt_outgoing -> execute();


#CHINA
my $sth_china_all="";
my $qry_pattern_china = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='CHINA'";
$sth_china_all = $dbh_oist->prepare($qry_pattern_china);
$sth_china_all->execute();

my @china_reg_ex = $sth_china_all->fetchrow_array();


my $sth_china_cnt_outgoing; 

my $strSQLCHINAOutgoing="REPLACE INTO oist_countries_breakdown(datein,country,total_msg_sent,total_msg_rcvd) SELECT '$current_date','CHINA',T1.cnt as total_msg_sent,T2.cnt as total_msg_recieved FROM  (SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_sender NOT LIKE 'nagios%'  AND direction='outgoing' AND mobile_number_sender REGEXP '^".$china_reg_ex[0]."\$') T1,(SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_recieved NOT LIKE 'nagios%'  AND direction='incoming' AND mobile_number_recieved REGEXP '^".$china_reg_ex[0]."\$') T2";   
$sth_china_cnt_outgoing = $dbh_oist->prepare($strSQLCHINAOutgoing);
$sth_china_cnt_outgoing -> execute();

#UNITED KINGDOM
my $sth_uk_all="";
my $qry_pattern_uk = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='UNITED KINGDOM'";
$sth_uk_all = $dbh_oist->prepare($qry_pattern_uk);
$sth_uk_all->execute();

my @uk_reg_ex = $sth_uk_all->fetchrow_array();

my $sth_uk_cnt_outgoing; 

my $strSQLUKOMsg="REPLACE INTO oist_countries_breakdown(datein,country,total_msg_sent,total_msg_rcvd) SELECT '$current_date','UNITED KINGDOM',T1.cnt as total_msg_sent,T2.cnt as total_msg_recieved FROM  (SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_sender NOT LIKE 'nagios%'  AND direction='outgoing' AND mobile_number_sender REGEXP '^".$uk_reg_ex[0]."\$') T1,(SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_recieved NOT LIKE 'nagios%'  AND direction='incoming' AND mobile_number_recieved REGEXP '^".$uk_reg_ex[0]."\$') T2";   
$sth_uk_cnt_outgoing = $dbh_oist->prepare($strSQLUKOMsg);
$sth_uk_cnt_outgoing -> execute();


#SAUDI ARABIA 
my $sth_saudi_all="";
my $qry_pattern_saudi = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='SAUDI ARABIA'";
$sth_saudi_all = $dbh_oist->prepare($qry_pattern_saudi);
$sth_saudi_all->execute();

my @suadi_reg_ex = $sth_saudi_all->fetchrow_array();

my $sth_suadi_cnt; 

my $strSQLSAUDIMsg="REPLACE INTO oist_countries_breakdown(datein,country,total_msg_sent,total_msg_rcvd) SELECT '$current_date','SAUDI ARABIA',T1.cnt as total_msg_sent,T2.cnt as total_msg_recieved FROM  (SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_sender NOT LIKE 'nagios%'  AND direction='outgoing' AND mobile_number_sender REGEXP '^".$suadi_reg_ex[0]."\$') T1,(SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_recieved NOT LIKE 'nagios%'  AND direction='incoming' AND mobile_number_recieved REGEXP '^".$suadi_reg_ex[0]."\$') T2";   
$sth_suadi_cnt = $dbh_oist->prepare($strSQLSAUDIMsg);
$sth_suadi_cnt -> execute();

#JAPAN
my $sth_japan_all="";
my $qry_pattern_japan = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='JAPAN'";
$sth_japan_all = $dbh_oist->prepare($qry_pattern_japan);
$sth_japan_all->execute();

my @japan_reg_ex = $sth_japan_all->fetchrow_array();

my $sth_japan_cnt; 

my $strSQLJapanMsg="REPLACE INTO oist_countries_breakdown(datein,country,total_msg_sent,total_msg_rcvd) SELECT '$current_date','JAPAN',T1.cnt as total_msg_sent,T2.cnt as total_msg_recieved FROM  (SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_sender NOT LIKE 'nagios%'  AND direction='outgoing' AND mobile_number_sender REGEXP '^".$japan_reg_ex[0]."\$') T1,(SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_recieved NOT LIKE 'nagios%'  AND direction='incoming' AND mobile_number_recieved REGEXP '^".$japan_reg_ex[0]."\$') T2";   
$sth_japan_cnt = $dbh_oist->prepare($strSQLJapanMsg);
$sth_japan_cnt -> execute();

#SINGAPORE
my $sth_sg_all="";
my $qry_pattern_sg = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='SINGAPORE'";
$sth_sg_all = $dbh_oist->prepare($qry_pattern_sg);
$sth_sg_all->execute();

my @sg_reg_ex = $sth_sg_all->fetchrow_array();

my $sth_sg_cnt; 

my $strSQLSGMsg="REPLACE INTO oist_countries_breakdown(datein,country,total_msg_sent,total_msg_rcvd) SELECT '$current_date','SINGAPORE',T1.cnt as total_msg_sent,T2.cnt as total_msg_recieved FROM  (SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_sender NOT LIKE 'nagios%'  AND direction='outgoing' AND mobile_number_sender REGEXP '^".$sg_reg_ex[0]."\$') T1,(SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_recieved NOT LIKE 'nagios%'  AND direction='incoming' AND mobile_number_recieved REGEXP '^".$sg_reg_ex[0]."\$') T2";   
$sth_sg_cnt = $dbh_oist->prepare($strSQLSGMsg);
$sth_sg_cnt -> execute();

#MALAYSIA 
my $sth_my_all="";
my $qry_pattern_my = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='MALAYSIA'";
$sth_my_all = $dbh_oist->prepare($qry_pattern_my);
$sth_my_all->execute();

my @my_reg_ex = $sth_my_all->fetchrow_array();

my $sth_my_cnt; 

my $strSQLMYMsg="REPLACE INTO oist_countries_breakdown(datein,country,total_msg_sent,total_msg_rcvd) SELECT '$current_date','MALAYSIA',T1.cnt as total_msg_sent,T2.cnt as total_msg_recieved FROM  (SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_sender NOT LIKE 'nagios%'  AND direction='outgoing' AND mobile_number_sender REGEXP '^".$my_reg_ex[0]."\$') T1,(SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_recieved NOT LIKE 'nagios%'  AND direction='incoming' AND mobile_number_recieved REGEXP '^".$my_reg_ex[0]."\$') T2";   
$sth_my_cnt = $dbh_oist->prepare($strSQLMYMsg);
$sth_my_cnt -> execute();

#CANADA 
my $sth_can_all="";
my $qry_pattern_can = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='CANADA'";
$sth_can_all = $dbh_oist->prepare($qry_pattern_can);
$sth_can_all->execute();

my @can_reg_ex = $sth_can_all->fetchrow_array();

my $sth_can_cnt; 

my $strSQLCANMsg="REPLACE INTO oist_countries_breakdown(datein,country,total_msg_sent,total_msg_rcvd) SELECT '$current_date','CANADA',T1.cnt as total_msg_sent,T2.cnt as total_msg_recieved FROM  (SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_sender NOT LIKE 'nagios%'  AND direction='outgoing' AND mobile_number_sender REGEXP '^".$can_reg_ex[0]."\$') T1,(SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_recieved NOT LIKE 'nagios%'  AND direction='incoming' AND mobile_number_recieved REGEXP '^".$can_reg_ex[0]."\$') T2";   
$sth_can_cnt = $dbh_oist->prepare($strSQLCANMsg);
$sth_can_cnt -> execute();

#AUSTRALIA  
my $sth_aus_all="";
my $qry_pattern_aus = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='AUSTRALIA'";
$sth_aus_all = $dbh_oist->prepare($qry_pattern_aus);
$sth_aus_all->execute();

my @aus_reg_ex = $sth_aus_all->fetchrow_array();

my $sth_aus_cnt; 

my $strSQLAUSMsg="REPLACE INTO oist_countries_breakdown(datein,country,total_msg_sent,total_msg_rcvd) SELECT '$current_date','AUSTRALIA',T1.cnt as total_msg_sent,T2.cnt as total_msg_recieved FROM  (SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_sender NOT LIKE 'nagios%'  AND direction='outgoing' AND mobile_number_sender REGEXP '^".$aus_reg_ex[0]."\$') T1,(SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_recieved NOT LIKE 'nagios%'  AND direction='incoming' AND mobile_number_recieved REGEXP '^".$aus_reg_ex[0]."\$') T2";   
$sth_aus_cnt = $dbh_oist->prepare($strSQLAUSMsg);
$sth_aus_cnt->execute();

#QATAR  
my $sth_qatar_all="";
my $qry_pattern_qatar = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='QATAR'";
$sth_qatar_all = $dbh_oist->prepare($qry_pattern_qatar);
$sth_qatar_all->execute();

my @qatar_reg_ex = $sth_qatar_all->fetchrow_array();

my $sth_qatar_cnt; 

my $strSQLQATARMsg="REPLACE INTO oist_countries_breakdown(datein,country,total_msg_sent,total_msg_rcvd) SELECT '$current_date','QATAR',T1.cnt as total_msg_sent,T2.cnt as total_msg_recieved FROM  (SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_sender NOT LIKE 'nagios%'  AND direction='outgoing' AND mobile_number_sender REGEXP '^".$qatar_reg_ex[0]."\$') T1,(SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_recieved NOT LIKE 'nagios%'  AND direction='incoming' AND mobile_number_recieved REGEXP '^".$qatar_reg_ex[0]."\$') T2";   
$sth_qatar_cnt = $dbh_oist->prepare($strSQLQATARMsg);
$sth_qatar_cnt -> execute();

#SOUTH KOREA   
my $sth_kor_all="";
my $qry_pattern_kor = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='SOUTH KOREA'";
$sth_kor_all = $dbh_oist->prepare($qry_pattern_kor);
$sth_kor_all->execute();

my @kor_reg_ex = $sth_kor_all->fetchrow_array();

my $sth_kor_cnt; 

my $strSQLKORMsg="REPLACE INTO oist_countries_breakdown(datein,country,total_msg_sent,total_msg_rcvd) SELECT '$current_date','SOUTH KOREA',T1.cnt as total_msg_sent,T2.cnt as total_msg_recieved FROM  (SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_sender NOT LIKE 'nagios%'  AND direction='outgoing' AND mobile_number_sender REGEXP '^".$kor_reg_ex[0]."\$') T1,(SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_recieved NOT LIKE 'nagios%'  AND direction='incoming' AND mobile_number_recieved REGEXP '^".$kor_reg_ex[0]."\$') T2";   
$sth_kor_cnt = $dbh_oist->prepare($strSQLKORMsg);
$sth_kor_cnt -> execute();

#HONG KONG    
my $sth_hk_all="";
my $qry_pattern_hk = "SELECT GROUP_CONCAT(pattern SEPARATOR  '\$\|^') FROM mobile_pattern where operator='HONG KONG'";
$sth_hk_all = $dbh_oist->prepare($qry_pattern_hk);
$sth_hk_all->execute();

my @hk_reg_ex = $sth_hk_all->fetchrow_array();

my $sth_hk_cnt; 

my $strSQLHKMsg="REPLACE INTO oist_countries_breakdown(datein,country,total_msg_sent,total_msg_rcvd) SELECT '$current_date','HONG KONG',T1.cnt as total_msg_sent,T2.cnt as total_msg_recieved FROM  (SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_sender NOT LIKE 'nagios%'  AND direction='outgoing' AND mobile_number_sender REGEXP '^".$hk_reg_ex[0]."\$') T1,(SELECT COUNT(1) as cnt FROM `oist_log`.`oist_success_".$tbl_date."` where mobile_number_recieved NOT LIKE 'nagios%'  AND direction='incoming' AND mobile_number_recieved REGEXP '^".$hk_reg_ex[0]."\$') T2";   
$sth_hk_cnt = $dbh_oist->prepare($strSQLHKMsg);
$sth_hk_cnt -> execute();

#UPDATE REGISTRATION PER COUNTRY
#PHILIPPINES
my $sth_ph_reg="";

my $strSQLPReg = "SELECT COUNT(1) as cnt FROM oist_log.oist_registration_".$tbl_date." WHERE mobile_number REGEXP '^".$ph_reg_ex[0]."\$' AND status='true'";
$sth_ph_reg = $dbh_oist->prepare($strSQLPReg);
$sth_ph_reg -> execute();

my @ph_reg_cnt = $sth_ph_reg->fetchrow_array();

my $sth_update_ph_reg;

my $strSQLUpdatePH = "UPDATE oist_countries_breakdown SET registrations=".$ph_reg_cnt[0]." WHERE datein='$current_date' AND country='PHILIPPINES'";
$sth_update_ph_reg = $dbh_oist->prepare($strSQLUpdatePH);
$sth_update_ph_reg -> execute();

#UNITED STATES
my $sth_us_reg="";

my $strSQLUSReg = "SELECT COUNT(1) as cnt FROM oist_log.oist_registration_".$tbl_date." WHERE mobile_number REGEXP '^".$us_reg_ex[0]."\$' AND status='true'";
$sth_us_reg = $dbh_oist->prepare($strSQLUSReg);
$sth_us_reg -> execute();

my @us_reg_cnt = $sth_us_reg->fetchrow_array();

my $sth_update_us_reg;

my $strSQLUpdateUS = "UPDATE oist_countries_breakdown SET registrations=".$us_reg_cnt[0]." WHERE datein='$current_date' AND country='UNITED STATES'";
$sth_update_us_reg = $dbh_oist->prepare($strSQLUpdateUS);
$sth_update_us_reg -> execute();

#UNITED ARAB EMIRATES
my $sth_uae_reg="";

my $strSQLUAEReg = "SELECT COUNT(1) as cnt FROM oist_log.oist_registration_".$tbl_date." WHERE mobile_number REGEXP '^".$uae_reg_ex[0]."\$' AND status='true'";
$sth_uae_reg = $dbh_oist->prepare($strSQLUAEReg);
$sth_uae_reg -> execute();

my @uae_reg_cnt = $sth_uae_reg->fetchrow_array();

my $sth_update_uae_reg;

my $strSQLUpdateUAE = "UPDATE oist_countries_breakdown SET registrations=".$uae_reg_cnt[0]." WHERE datein='$current_date' AND country='UNITED ARAB EMIRATES'";
$sth_update_uae_reg = $dbh_oist->prepare($strSQLUpdateUAE);
$sth_update_uae_reg -> execute();

#CHINA
my $sth_china_reg="";

my $strSQLCHINAReg = "SELECT COUNT(1) as cnt FROM oist_log.oist_registration_".$tbl_date." WHERE mobile_number REGEXP '^".$china_reg_ex[0]."\$' AND status='true'";
$sth_china_reg = $dbh_oist->prepare($strSQLCHINAReg);
$sth_china_reg -> execute();

my @china_reg_cnt = $sth_china_reg->fetchrow_array();

my $sth_update_china_reg;

my $strSQLUpdateCHINA = "UPDATE oist_countries_breakdown SET registrations=".$china_reg_cnt[0]." WHERE datein='$current_date' AND country='CHINA'";
$sth_update_china_reg = $dbh_oist->prepare($strSQLUpdateCHINA);
$sth_update_china_reg -> execute();

#UNITED KINGDOM
my $sth_uk_reg="";

my $strSQLUKReg = "SELECT COUNT(1) as cnt FROM oist_log.oist_registration_".$tbl_date." WHERE mobile_number REGEXP '^".$uk_reg_ex[0]."\$' AND status='true'";
$sth_uk_reg = $dbh_oist->prepare($strSQLUKReg);
$sth_uk_reg -> execute();

my @uk_reg_cnt = $sth_uk_reg->fetchrow_array();

my $sth_update_uk_reg;

my $strSQLUpdateUK = "UPDATE oist_countries_breakdown SET registrations=".$uk_reg_cnt[0]." WHERE datein='$current_date' AND country='UNITED KINGDOM'";
$sth_update_uk_reg = $dbh_oist->prepare($strSQLUpdateUK);
$sth_update_uk_reg -> execute();

#SAUDI ARABIA
my $sth_saudi_reg="";

my $strSQLSAUDIReg = "SELECT COUNT(1) as cnt FROM oist_log.oist_registration_".$tbl_date." WHERE mobile_number REGEXP '^".$suadi_reg_ex[0]."\$' AND status='true'";
$sth_saudi_reg = $dbh_oist->prepare($strSQLSAUDIReg);
$sth_saudi_reg -> execute();

my @saudi_reg_cnt = $sth_saudi_reg->fetchrow_array();

my $sth_update_saudi_reg;

my $strSQLUpdateSAUDI = "UPDATE oist_countries_breakdown SET registrations=".$saudi_reg_cnt[0]." WHERE datein='$current_date' AND country='SAUDI ARABIA'";
$sth_update_saudi_reg = $dbh_oist->prepare($strSQLUpdateSAUDI);
$sth_update_saudi_reg -> execute();

#JAPAN
my $sth_jpn_reg="";

my $strSQLJPNReg = "SELECT COUNT(1) as cnt FROM oist_log.oist_registration_".$tbl_date." WHERE mobile_number REGEXP '^".$japan_reg_ex[0]."\$' AND status='true'";
$sth_jpn_reg = $dbh_oist->prepare($strSQLJPNReg);
$sth_jpn_reg -> execute();

my @jpn_reg_cnt = $sth_jpn_reg->fetchrow_array();

my $sth_update_jpn_reg;

my $strSQLUpdateJPN = "UPDATE oist_countries_breakdown SET registrations=".$jpn_reg_cnt[0]." WHERE datein='$current_date' AND country='JAPAN'";
$sth_update_jpn_reg = $dbh_oist->prepare($strSQLUpdateJPN);
$sth_update_jpn_reg -> execute();


#SINGAPORE
my $sth_sg_reg="";

my $strSQLSGReg = "SELECT COUNT(1) as cnt FROM oist_log.oist_registration_".$tbl_date." WHERE mobile_number REGEXP '^".$sg_reg_ex[0]."\$' AND status='true'";
$sth_sg_reg = $dbh_oist->prepare($strSQLSGReg);
$sth_sg_reg -> execute();

my @sg_reg_cnt = $sth_sg_reg->fetchrow_array();

my $sth_update_sg_reg;

my $strSQLUpdateSG = "UPDATE oist_countries_breakdown SET registrations=".$sg_reg_cnt[0]." WHERE datein='$current_date' AND country='SINGAPORE'";
$sth_update_sg_reg = $dbh_oist->prepare($strSQLUpdateSG);
$sth_update_sg_reg -> execute();


#MALAYSIA
my $sth_my_reg="";

my $strSQLMYReg = "SELECT COUNT(1) as cnt FROM oist_log.oist_registration_".$tbl_date." WHERE mobile_number REGEXP '^".$my_reg_ex[0]."\$' AND status='true'";
$sth_my_reg = $dbh_oist->prepare($strSQLMYReg);
$sth_my_reg -> execute();

my @my_reg_cnt = $sth_my_reg->fetchrow_array();

my $sth_update_my_reg;

my $strSQLUpdateMY = "UPDATE oist_countries_breakdown SET registrations=".$my_reg_cnt[0]." WHERE datein='$current_date' AND country='MALAYSIA'";
$sth_update_my_reg = $dbh_oist->prepare($strSQLUpdateMY);
$sth_update_my_reg -> execute();

#CANADA
my $sth_can_reg="";

my $strSQLCANReg = "SELECT COUNT(1) as cnt FROM oist_log.oist_registration_".$tbl_date." WHERE mobile_number REGEXP '^".$can_reg_ex[0]."\$' AND status='true'";
$sth_can_reg = $dbh_oist->prepare($strSQLCANReg);
$sth_can_reg -> execute();

my @can_reg_cnt = $sth_can_reg->fetchrow_array();

my $sth_update_can_reg;

my $strSQLUpdateCAN = "UPDATE oist_countries_breakdown SET registrations=".$can_reg_cnt[0]." WHERE datein='$current_date' AND country='CANADA'";
$sth_update_can_reg = $dbh_oist->prepare($strSQLUpdateCAN);
$sth_update_can_reg -> execute();

#AUSTRALIA
my $sth_aus_reg="";

my $strSQLAUSReg = "SELECT COUNT(1) as cnt FROM oist_log.oist_registration_".$tbl_date." WHERE mobile_number REGEXP '^".$aus_reg_ex[0]."\$' AND status='true'";
$sth_aus_reg = $dbh_oist->prepare($strSQLAUSReg);
$sth_aus_reg -> execute();

my @aus_reg_cnt = $sth_aus_reg->fetchrow_array();

my $sth_update_aus_reg;

my $strSQLUpdateAUS = "UPDATE oist_countries_breakdown SET registrations=".$aus_reg_cnt[0]." WHERE datein='$current_date' AND country='AUSTRALIA'";
$sth_update_aus_reg = $dbh_oist->prepare($strSQLUpdateAUS);
$sth_update_aus_reg -> execute();


#QATAR
my $sth_qatar_reg="";

my $strSQLQATARReg = "SELECT COUNT(1) as cnt FROM oist_log.oist_registration_".$tbl_date." WHERE mobile_number REGEXP '^".$qatar_reg_ex[0]."\$' AND status='true'";
$sth_qatar_reg = $dbh_oist->prepare($strSQLQATARReg);
$sth_qatar_reg -> execute();

my @qatar_reg_cnt = $sth_qatar_reg->fetchrow_array();

my $sth_update_qatar_reg;

my $strSQLUpdateQATAR = "UPDATE oist_countries_breakdown SET registrations=".$qatar_reg_cnt[0]." WHERE datein='$current_date' AND country='QATAR'";
$sth_update_qatar_reg = $dbh_oist->prepare($strSQLUpdateQATAR);
$sth_update_qatar_reg -> execute();

#SOUTH KOREA
my $sth_kor_reg="";

my $strSQLQATARReg = "SELECT COUNT(1) as cnt FROM oist_log.oist_registration_".$tbl_date." WHERE mobile_number REGEXP '^".$kor_reg_ex[0]."\$' AND status='true'";
$sth_kor_reg = $dbh_oist->prepare($strSQLQATARReg);
$sth_kor_reg -> execute();

my @kor_reg_cnt = $sth_kor_reg->fetchrow_array();

my $sth_update_kor_reg;

my $strSQLUpdateKOR = "UPDATE oist_countries_breakdown SET registrations=".$kor_reg_cnt[0]." WHERE datein='$current_date' AND country='SOUTH KOREA'";
$sth_update_kor_reg = $dbh_oist->prepare($strSQLUpdateKOR);
$sth_update_kor_reg -> execute();


#HONG KONG
my $sth_hk_reg="";

my $strSQLHKReg = "SELECT COUNT(1) as cnt FROM oist_log.oist_registration_".$tbl_date." WHERE mobile_number REGEXP '^".$hk_reg_ex[0]."\$' AND status='true'";
$sth_hk_reg = $dbh_oist->prepare($strSQLHKReg);
$sth_hk_reg -> execute();

my @hk_reg_cnt = $sth_hk_reg->fetchrow_array();

my $sth_update_hk_reg;

my $strSQLUpdateHK = "UPDATE oist_countries_breakdown SET registrations=".$hk_reg_cnt[0]." WHERE datein='$current_date' AND country='HONG KONG'";
$sth_update_hk_reg = $dbh_oist->prepare($strSQLUpdateHK);
$sth_update_hk_reg -> execute();