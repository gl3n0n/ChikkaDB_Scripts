-- MySQL dump 10.13  Distrib 5.5.34, for Linux (x86_64)
--
-- Host: localhost    Database: archive_powerapp_flu
-- ------------------------------------------------------
-- Server version	5.5.34-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `active_user`
--

DROP TABLE IF EXISTS `active_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_user` (
  `phone` varchar(12) NOT NULL,
  `datein` datetime,
  PRIMARY KEY (`phone`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inactive_user`
--

DROP TABLE IF EXISTS `inactive_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inactive_user` (
  `phone` varchar(12) NOT NULL,
  `datein` datetime,
  PRIMARY KEY (`phone`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `plan_user`
--

DROP TABLE IF EXISTS `plan_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plan_user` (
  `plan` varchar(16) NOT NULL DEFAULT '',
  `phone` varchar(12) NOT NULL,
  `datein` datetime,
  PRIMARY KEY (`plan`,`phone`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `powerapp_active_stats`
--

DROP TABLE IF EXISTS `powerapp_active_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_active_stats` (
  `tran_dt` date NOT NULL,
  `tran_tm` time NOT NULL,
  `plan` varchar(16) DEFAULT NULL,
  `no_active` int(11) NOT NULL DEFAULT '0',
  `no_inactive` int(11) NOT NULL DEFAULT '0',
  `total_subs` int(11) NOT NULL DEFAULT '0',
  `pct_active` float NOT NULL DEFAULT '0',
  `pct_inactive` float NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `powerapp_log`
--

DROP TABLE IF EXISTS `powerapp_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datein` datetime NOT NULL,
  `phone` varchar(12) NOT NULL,
  `brand` varchar(16) DEFAULT NULL,
  `action` varchar(16) DEFAULT NULL,
  `plan` varchar(16) DEFAULT NULL,
  `validity` int(11) DEFAULT '0',
  `free` enum('true','false') DEFAULT 'true',
  `start_tm` datetime DEFAULT NULL,
  `end_tm` datetime DEFAULT NULL,
  `source` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`,`datein`),
  KEY `datein_idx` (`datein`)
) ENGINE=MyISAM AUTO_INCREMENT=1052533 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `powerapp_optout_log`
--

DROP TABLE IF EXISTS `powerapp_optout_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_optout_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datein` datetime NOT NULL,
  `phone` varchar(12) NOT NULL,
  `source` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`,`datein`),
  UNIQUE KEY `phone` (`phone`,`datein`),
  KEY `datein_idx` (`datein`)
) ENGINE=MyISAM AUTO_INCREMENT=377484 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `powerapp_retention_stats`
--

DROP TABLE IF EXISTS `powerapp_retention_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_retention_stats` (
  `tran_dt` date NOT NULL,
  `w7_days` int(11) NOT NULL DEFAULT '0',
  `w6_days` int(11) NOT NULL DEFAULT '0',
  `w5_days` int(11) NOT NULL DEFAULT '0',
  `w4_days` int(11) NOT NULL DEFAULT '0',
  `w3_days` int(11) NOT NULL DEFAULT '0',
  `w2_days` int(11) NOT NULL DEFAULT '0',
  `w1_days` int(11) NOT NULL DEFAULT '0',
  `new_users` int(11) NOT NULL DEFAULT '0',
  `wk_start` date NOT NULL,
  PRIMARY KEY (`tran_dt`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `powerapp_retention_stats_1st`
--

DROP TABLE IF EXISTS `powerapp_retention_stats_1st`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_retention_stats_1st` (
  `tran_dt` date NOT NULL,
  `w7_days` int(11) NOT NULL DEFAULT '0',
  `w6_days` int(11) NOT NULL DEFAULT '0',
  `w5_days` int(11) NOT NULL DEFAULT '0',
  `w4_days` int(11) NOT NULL DEFAULT '0',
  `w3_days` int(11) NOT NULL DEFAULT '0',
  `w2_days` int(11) NOT NULL DEFAULT '0',
  `w1_days` int(11) NOT NULL DEFAULT '0',
  `new_users` int(11) NOT NULL DEFAULT '0',
  `wk_start` date NOT NULL,
  PRIMARY KEY (`tran_dt`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `powerapp_retention_stats_monthly`
--

DROP TABLE IF EXISTS `powerapp_retention_stats_monthly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_retention_stats_monthly` (
  `tran_dt` date NOT NULL,
  `w31_days` int(11) NOT NULL DEFAULT '0',
  `w30_days` int(11) NOT NULL DEFAULT '0',
  `w29_days` int(11) NOT NULL DEFAULT '0',
  `w28_days` int(11) NOT NULL DEFAULT '0',
  `w27_days` int(11) NOT NULL DEFAULT '0',
  `w26_days` int(11) NOT NULL DEFAULT '0',
  `w25_days` int(11) NOT NULL DEFAULT '0',
  `w24_days` int(11) NOT NULL DEFAULT '0',
  `w23_days` int(11) NOT NULL DEFAULT '0',
  `w22_days` int(11) NOT NULL DEFAULT '0',
  `w21_days` int(11) NOT NULL DEFAULT '0',
  `w20_days` int(11) NOT NULL DEFAULT '0',
  `w19_days` int(11) NOT NULL DEFAULT '0',
  `w18_days` int(11) NOT NULL DEFAULT '0',
  `w17_days` int(11) NOT NULL DEFAULT '0',
  `w16_days` int(11) NOT NULL DEFAULT '0',
  `w15_days` int(11) NOT NULL DEFAULT '0',
  `w14_days` int(11) NOT NULL DEFAULT '0',
  `w13_days` int(11) NOT NULL DEFAULT '0',
  `w12_days` int(11) NOT NULL DEFAULT '0',
  `w11_days` int(11) NOT NULL DEFAULT '0',
  `w10_days` int(11) NOT NULL DEFAULT '0',
  `w9_days` int(11) NOT NULL DEFAULT '0',
  `w8_days` int(11) NOT NULL DEFAULT '0',
  `w7_days` int(11) NOT NULL DEFAULT '0',
  `w6_days` int(11) NOT NULL DEFAULT '0',
  `w5_days` int(11) NOT NULL DEFAULT '0',
  `w4_days` int(11) NOT NULL DEFAULT '0',
  `w3_days` int(11) NOT NULL DEFAULT '0',
  `w2_days` int(11) NOT NULL DEFAULT '0',
  `w1_days` int(11) NOT NULL DEFAULT '0',
  `new_users` int(11) NOT NULL DEFAULT '0',
  `wk_start` date NOT NULL,
  PRIMARY KEY (`tran_dt`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `powerapp_retention_stats_plan`
--

DROP TABLE IF EXISTS `powerapp_retention_stats_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_retention_stats_plan` (
  `tran_dt` date NOT NULL,
  `plan` varchar(16) NOT NULL,
  `w7_days` int(11) NOT NULL DEFAULT '0',
  `w6_days` int(11) NOT NULL DEFAULT '0',
  `w5_days` int(11) NOT NULL DEFAULT '0',
  `w4_days` int(11) NOT NULL DEFAULT '0',
  `w3_days` int(11) NOT NULL DEFAULT '0',
  `w2_days` int(11) NOT NULL DEFAULT '0',
  `w1_days` int(11) NOT NULL DEFAULT '0',
  `new_users` int(11) NOT NULL DEFAULT '0',
  `wk_start` date NOT NULL,
  PRIMARY KEY (`tran_dt`,`plan`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `powerapp_weekly_users`
--

DROP TABLE IF EXISTS `powerapp_weekly_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_weekly_users` (
  `datein` varchar(10) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `phone` varchar(12) NOT NULL DEFAULT '',
  `hits` bigint(21) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `social_user`
--

DROP TABLE IF EXISTS `social_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `social_user` (
  `phone` varchar(12) NOT NULL,
  `datein` datetime,
  PRIMARY KEY (`phone`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'archive_powerapp_flu'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_generate_active_stats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generate_active_stats`(p_plan varchar(16))
begin
   truncate table active_user;
   truncate table inactive_user;

   if p_plan is not null then
      SET @vPlan = p_plan;

      insert ignore into active_user select phone, max(datein) datein from powerapp_flu.powerapp_log where plan = p_plan and datein >= date_sub(now(), interval 1 day) group by phone;
      insert ignore into inactive_user select phone, max(datein) from (
                                       select phone, max(datein) datein from powerapp_log a where plan = p_plan and datein < date_sub(now(), interval 1 day) group by phone
                                       union select phone, max(datein) datein from powerapp_flu.powerapp_log a where plan = p_plan and datein < date_sub(now(), interval 1 day) group by phone
                                       ) as t group by phone;

   else 
      SET @vPlan = 'ALL';
      insert ignore into active_user select phone, max(datein) datein from powerapp_flu.powerapp_log where datein >= date_sub(now(), interval 1 day) group by phone;
      insert ignore into inactive_user select phone, max(datein) from (
                                       select phone, max(datein) datein from powerapp_log a where datein < date_sub(now(), interval 1 day) group by phone
                                       union select phone, max(datein) datein from powerapp_flu.powerapp_log a where datein < date_sub(now(), interval 1 day) group by phone
                                       ) as t group by phone;

   end if;

   insert into powerapp_active_stats
   select curdate(), curtime(), @vPlan, sum(active_user) Active_User, sum(inactive_user) Inactive_User, 
          sum(active_user+inactive_user) TotalUser,
          (sum(active_user) / sum(active_user+inactive_user)) * 100 Pct_Active,
          (sum(inactive_user) / sum(active_user+inactive_user)) * 100 Pct_Inactive  
   from (
   select count(1) active_user, 0 inactive_user from active_user union
   select 0 active_user, count(1) inactive_user from inactive_user a where not exists (select 1 from active_user b where a.phone=b.phone) 
   ) a;

   select * from powerapp_active_stats order by tran_dt desc, tran_tm desc limit 1;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_generate_retention_stats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generate_retention_stats`(p_trandate varchar(10))
begin
   declare vNoDay, vHits int default 0;
   declare done_p int default 0;
   declare c_pat cursor for 
      select no_day, count(distinct phone) hits from (
      select phone, count(1) no_day from (
      select left(datein,10) datein, phone, count(1) hits from powerapp_log 
      where datein < date_add(p_trandate, interval 1 day) and  datein >= date_sub(p_trandate, interval 6 day) 
      group by left(datein,10), phone
      union
      select left(datein,10) datein, phone, count(1) hits from powerapp_flu.powerapp_log 
      where datein < date_add(p_trandate, interval 1 day) and  datein >= date_sub(p_trandate, interval 6 day) 
      group by left(datein,10), phone
      ) t1 group by phone
      ) t2
      group by no_day order by no_day;
   
   declare continue handler for sqlstate '02000' set done_p = 1;

   SET @Day_1 = 0;
   SET @Day_2 = 0;
   SET @Day_3 = 0;
   SET @Day_4 = 0;
   SET @Day_5 = 0;
   SET @Day_6 = 0;
   SET @Day_7 = 0;
   SET @NewUsers = 0;

   OPEN c_pat;
   REPEAT
   FETCH c_pat into vNoDay, vHits;
      if not done_p then
         if vNoDay = 1    then SET @Day_1 = vHits;
         elseif vNoDay = 2 then SET @Day_2 = vHits;
         elseif vNoDay = 3 then SET @Day_3 = vHits;
         elseif vNoDay = 4 then SET @Day_4 = vHits;
         elseif vNoDay = 5 then SET @Day_5 = vHits;
         elseif vNoDay = 6 then SET @Day_6 = vHits;
         elseif vNoDay = 7 then SET @Day_7 = vHits;
         end if;
      end if;
   UNTIL done_p
   END REPEAT;

   
   
   create table powerapp_last_week_users ( phone varchar(12) not null, primary key (phone) );

   insert into powerapp_last_week_users 
   select phone from (
   select phone from powerapp_log
   where  datein >= date_sub(p_trandate, interval 7 day) 
   and    datein < p_trandate group by phone
   union
   select phone from powerapp_flu.powerapp_log
   where  datein >= date_sub(p_trandate, interval 7 day) 
   and    datein < p_trandate group by phone 
   ) t group by phone;


   select count(distinct phone) 
   into   @NewUsers 
   from (
   select phone from powerapp_log a 
   where  a.datein < date_add(p_trandate, interval 1 day)
   and    a.datein >= p_trandate
   and    not exists (
   select 1 from powerapp_last_week_users b
   where  a.phone = b.phone)
   union
   select phone from powerapp_flu.powerapp_log a 
   where  a.datein < date_add(p_trandate, interval 1 day)
   and    a.datein >= p_trandate
   and    not exists (
   select 1 from powerapp_last_week_users b
   where  a.phone = b.phone)
   ) t;
    
   drop table powerapp_last_week_users;
   
   

   insert into powerapp_retention_stats values (p_trandate, @Day_7, @Day_6, @Day_5, @Day_4, @Day_3, @Day_2, @Day_1, @NewUsers, date_sub(p_trandate, interval 7 day) );

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_generate_retention_stats_monthly` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generate_retention_stats_monthly`(p_trandate varchar(10))
begin
   declare vNoDay, vHits int default 0;
   declare done_p int default 0;
   declare c_pat cursor for 
      select no_day, count(distinct phone) hits from (
      select phone, count(1) no_day from (
      select left(datein,10) datein, phone, count(1) hits from powerapp_log 
      where datein < date_add(p_trandate, interval 1 day) and  datein >= date_sub(p_trandate, interval 31 day) 
      group by left(datein,10), phone
      union
      select left(datein,10) datein, phone, count(1) hits from powerapp_flu.powerapp_log 
      where datein < date_add(p_trandate, interval 1 day) and  datein >= date_sub(p_trandate, interval 31 day) 
      group by left(datein,10), phone
      ) t1 group by phone
      ) t2
      group by no_day order by no_day;
   
   declare continue handler for sqlstate '02000' set done_p = 1;

   SET @Day_1 = 0;
   SET @Day_2 = 0;
   SET @Day_3 = 0;
   SET @Day_4 = 0;
   SET @Day_5 = 0;
   SET @Day_6 = 0;
   SET @Day_7 = 0;
   SET @NewUsers = 0;

   OPEN c_pat;
   REPEAT
   FETCH c_pat into vNoDay, vHits;
      if not done_p then
         if     vNoDay = 1 then  SET @Day_1  = vHits;
         elseif vNoDay = 2 then  SET @Day_2  = vHits;
         elseif vNoDay = 3 then  SET @Day_3  = vHits;
         elseif vNoDay = 4 then  SET @Day_4  = vHits;
         elseif vNoDay = 5 then  SET @Day_5  = vHits;
         elseif vNoDay = 6 then  SET @Day_6  = vHits;
         elseif vNoDay = 7 then  SET @Day_7  = vHits;
         elseif vNoDay = 8 then  SET @Day_8  = vHits;
         elseif vNoDay = 9 then  SET @Day_9  = vHits;
         elseif vNoDay = 10 then SET @Day_10 = vHits;
         elseif vNoDay = 11 then SET @Day_11 = vHits;
         elseif vNoDay = 12 then SET @Day_12 = vHits;
         elseif vNoDay = 13 then SET @Day_13 = vHits;
         elseif vNoDay = 14 then SET @Day_14 = vHits;
         elseif vNoDay = 15 then SET @Day_15 = vHits;
         elseif vNoDay = 16 then SET @Day_16 = vHits;
         elseif vNoDay = 17 then SET @Day_17 = vHits;
         elseif vNoDay = 18 then SET @Day_18 = vHits;
         elseif vNoDay = 19 then SET @Day_19 = vHits;
         elseif vNoDay = 20 then SET @Day_20 = vHits;
         elseif vNoDay = 21 then SET @Day_21 = vHits;
         elseif vNoDay = 22 then SET @Day_22 = vHits;
         elseif vNoDay = 23 then SET @Day_23 = vHits;
         elseif vNoDay = 24 then SET @Day_24 = vHits;
         elseif vNoDay = 25 then SET @Day_25 = vHits;
         elseif vNoDay = 26 then SET @Day_26 = vHits;
         elseif vNoDay = 27 then SET @Day_27 = vHits;
         elseif vNoDay = 28 then SET @Day_28 = vHits;
         elseif vNoDay = 29 then SET @Day_29 = vHits;
         elseif vNoDay = 30 then SET @Day_30 = vHits;
         elseif vNoDay = 31 then SET @Day_31 = vHits;
         end if;
      end if;
   UNTIL done_p
   END REPEAT;

   
   
   create table powerapp_last_week_users ( phone varchar(12) not null, primary key (phone) );

   insert into powerapp_last_week_users 
   select phone from (
   select phone from powerapp_log
   where  datein >= date_sub(p_trandate, interval 32 day) 
   and    datein < p_trandate group by phone
   union
   select phone from powerapp_flu.powerapp_log
   where  datein >= date_sub(p_trandate, interval 32 day) 
   and    datein < p_trandate group by phone 
   ) t group by phone;


   select count(distinct phone) 
   into   @NewUsers 
   from (
   select phone from powerapp_log a 
   where  a.datein < date_add(p_trandate, interval 1 day)
   and    a.datein >= p_trandate
   and    not exists (
   select 1 from powerapp_last_week_users b
   where  a.phone = b.phone)
   union
   select phone from powerapp_flu.powerapp_log a 
   where  a.datein < date_add(p_trandate, interval 1 day)
   and    a.datein >= p_trandate
   and    not exists (
   select 1 from powerapp_last_week_users b
   where  a.phone = b.phone)
   ) t;
    
   drop table powerapp_last_week_users;
   
   

   insert into powerapp_retention_stats_monthly values (p_trandate, @Day_31, @Day_30,
    @Day_29, @Day_28, @Day_27, @Day_26, @Day_25, @Day_24, @Day_13, @Day_22, @Day_21, @Day_20, 
    @Day_19, @Day_18, @Day_17, @Day_16, @Day_15, @Day_14, @Day_13, @Day_12, @Day_11, @Day_10,
    @Day_9, @Day_8, @Day_7, @Day_6, @Day_5, @Day_4, @Day_3, @Day_2, @Day_1, 
    @NewUsers, date_sub(p_trandate, interval 31 day) );

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_generate_retention_stats_plan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generate_retention_stats_plan`(p_plan varchar(16), p_trandate varchar(10))
begin
   declare vNoDay, vHits int default 0;
   declare done_p int default 0;
   declare c_pat cursor for 
      select no_day, count(distinct phone) hits from (
      select phone, count(1) no_day from (
      select left(datein,10) datein, phone, count(1) hits from powerapp_log 
      where datein < date_add(p_trandate, interval 1 day) and  datein >= date_sub(p_trandate, interval 6 day) 
      and   plan = p_plan
      group by left(datein,10), phone
      union
      select left(datein,10) datein, phone, count(1) hits from powerapp_flu.powerapp_log 
      where datein < date_add(p_trandate, interval 1 day) and  datein >= date_sub(p_trandate, interval 6 day) 
      and   plan = p_plan
      group by left(datein,10), phone
      ) t1 group by phone
      ) t2
      group by no_day order by no_day;
   
   declare continue handler for sqlstate '02000' set done_p = 1;

   SET @Day_1 = 0;
   SET @Day_2 = 0;
   SET @Day_3 = 0;
   SET @Day_4 = 0;
   SET @Day_5 = 0;
   SET @Day_6 = 0;
   SET @Day_7 = 0;
   SET @NewUsers = 0;

   OPEN c_pat;
   REPEAT
   FETCH c_pat into vNoDay, vHits;
      if not done_p then
         if vNoDay = 1    then SET @Day_1 = vHits;
         elseif vNoDay = 2 then SET @Day_2 = vHits;
         elseif vNoDay = 3 then SET @Day_3 = vHits;
         elseif vNoDay = 4 then SET @Day_4 = vHits;
         elseif vNoDay = 5 then SET @Day_5 = vHits;
         elseif vNoDay = 6 then SET @Day_6 = vHits;
         elseif vNoDay = 7 then SET @Day_7 = vHits;
         end if;
      end if;
   UNTIL done_p
   END REPEAT;

   
   
   create table powerapp_last_week_users ( phone varchar(12) not null, primary key (phone) );

   insert into powerapp_last_week_users 
   select phone from (
   select phone from powerapp_log
   where  datein >= date_sub(p_trandate, interval 7 day) 
   and    plan = p_plan
   and    datein < p_trandate group by phone
   union
   select phone from powerapp_flu.powerapp_log
   where  datein >= date_sub(p_trandate, interval 7 day) 
   and    plan = p_plan
   and    datein < p_trandate group by phone 
   ) t group by phone;


   select count(distinct phone) 
   into   @NewUsers 
   from (
   select phone from powerapp_log a 
   where  a.datein < date_add(p_trandate, interval 1 day)
   and    a.datein >= p_trandate
   and    plan = p_plan
   and    not exists (
   select 1 from powerapp_last_week_users b
   where  a.phone = b.phone)
   union
   select phone from powerapp_flu.powerapp_log a 
   where  a.datein < date_add(p_trandate, interval 1 day)
   and    a.datein >= p_trandate
   and    plan = p_plan
   and    not exists (
   select 1 from powerapp_last_week_users b
   where  a.phone = b.phone)
   ) t;
    
   drop table powerapp_last_week_users;
   
   

   insert into powerapp_retention_stats_plan values (p_trandate, p_plan, @Day_7, @Day_6, @Day_5, @Day_4, @Day_3, @Day_2, @Day_1, @NewUsers, date_sub(p_trandate, interval 7 day) );

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_generate_retention_stats_plan_main` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generate_retention_stats_plan_main`()
begin
   set @vCtr = 2;
   WHILE (@vCtr <= 84) DO
      SET @vSql = concat('select date_sub(curdate(), interval ', @vCtr, ' day) into @vDate');
      PREPARE stmt FROM @vSql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
      SET @vCtr = @vCtr + 1; 
      call sp_generate_retention_stats_plan('UNLI', @vDate);
      call sp_generate_retention_stats_plan('SOCIAL', @vDate);
      call sp_generate_retention_stats_plan('SPEEDBOOST', @vDate);
   END WHILE;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-02-27 14:50:04
