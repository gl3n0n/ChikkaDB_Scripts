-- MySQL dump 10.13  Distrib 5.5.34, for Linux (x86_64)
--
-- Host: localhost    Database: powerapp_sun
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
-- Table structure for table `new_subscribers`
--

DROP TABLE IF EXISTS `new_subscribers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `new_subscribers` (
  `phone` varchar(20) NOT NULL,
  `brand` varchar(20) NOT NULL DEFAULT '',
  `datein` date NOT NULL DEFAULT '0000-00-00',
  `timein` time NOT NULL DEFAULT '00:00:00',
  PRIMARY KEY (`phone`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `powerapp_brand_boost_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_boost_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_boost_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_boost_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_chat_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_chat_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_chat_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_chat_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_daily_hits_optout`
--

DROP TABLE IF EXISTS `powerapp_brand_daily_hits_optout`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_daily_hits_optout`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_daily_hits_optout` (
  `tran_dt` tinyint NOT NULL,
  `hits_pre` tinyint NOT NULL,
  `hits_tnt` tinyint NOT NULL,
  `hits_ppd` tinyint NOT NULL,
  `hits_tot` tinyint NOT NULL,
  `optout_pre` tinyint NOT NULL,
  `optout_tnt` tinyint NOT NULL,
  `optout_ppd` tinyint NOT NULL,
  `optout_tot` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_daily_hits_optout_summary`
--

DROP TABLE IF EXISTS `powerapp_brand_daily_hits_optout_summary`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_daily_hits_optout_summary`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_daily_hits_optout_summary` (
  `tran_dt` tinyint NOT NULL,
  `hits_pre` tinyint NOT NULL,
  `hits_tnt` tinyint NOT NULL,
  `hits_ppd` tinyint NOT NULL,
  `hits_tot` tinyint NOT NULL,
  `optout_pre` tinyint NOT NULL,
  `optout_tnt` tinyint NOT NULL,
  `optout_ppd` tinyint NOT NULL,
  `optout_tot` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `unli_pre` tinyint NOT NULL,
  `email_pre` tinyint NOT NULL,
  `chat_pre` tinyint NOT NULL,
  `photo_pre` tinyint NOT NULL,
  `social_pre` tinyint NOT NULL,
  `speed_pre` tinyint NOT NULL,
  `line_pre` tinyint NOT NULL,
  `snapchat_pre` tinyint NOT NULL,
  `tumblr_pre` tinyint NOT NULL,
  `waze_pre` tinyint NOT NULL,
  `wechat_pre` tinyint NOT NULL,
  `facebook_pre` tinyint NOT NULL,
  `wiki_pre` tinyint NOT NULL,
  `free_social_pre` tinyint NOT NULL,
  `pisonet_pre` tinyint NOT NULL,
  `school_pre` tinyint NOT NULL,
  `unli_tnt` tinyint NOT NULL,
  `email_tnt` tinyint NOT NULL,
  `chat_tnt` tinyint NOT NULL,
  `photo_tnt` tinyint NOT NULL,
  `social_tnt` tinyint NOT NULL,
  `speed_tnt` tinyint NOT NULL,
  `line_tnt` tinyint NOT NULL,
  `snapchat_tnt` tinyint NOT NULL,
  `tumblr_tnt` tinyint NOT NULL,
  `waze_tnt` tinyint NOT NULL,
  `wechat_tnt` tinyint NOT NULL,
  `facebook_tnt` tinyint NOT NULL,
  `wiki_tnt` tinyint NOT NULL,
  `free_social_tnt` tinyint NOT NULL,
  `pisonet_tnt` tinyint NOT NULL,
  `school_tnt` tinyint NOT NULL,
  `unli_ppd` tinyint NOT NULL,
  `email_ppd` tinyint NOT NULL,
  `chat_ppd` tinyint NOT NULL,
  `photo_ppd` tinyint NOT NULL,
  `social_ppd` tinyint NOT NULL,
  `speed_ppd` tinyint NOT NULL,
  `line_ppd` tinyint NOT NULL,
  `snapchat_ppd` tinyint NOT NULL,
  `tumblr_ppd` tinyint NOT NULL,
  `waze_ppd` tinyint NOT NULL,
  `wechat_ppd` tinyint NOT NULL,
  `facebook_ppd` tinyint NOT NULL,
  `wiki_ppd` tinyint NOT NULL,
  `free_social_ppd` tinyint NOT NULL,
  `pisonet_ppd` tinyint NOT NULL,
  `school_ppd` tinyint NOT NULL,
  `unli_tot` tinyint NOT NULL,
  `email_tot` tinyint NOT NULL,
  `chat_tot` tinyint NOT NULL,
  `photo_tot` tinyint NOT NULL,
  `social_tot` tinyint NOT NULL,
  `speed_tot` tinyint NOT NULL,
  `line_tot` tinyint NOT NULL,
  `snapchat_tot` tinyint NOT NULL,
  `tumblr_tot` tinyint NOT NULL,
  `waze_tot` tinyint NOT NULL,
  `wechat_tot` tinyint NOT NULL,
  `facebook_tot` tinyint NOT NULL,
  `wiki_tot` tinyint NOT NULL,
  `free_social_tot` tinyint NOT NULL,
  `pisonet_tot` tinyint NOT NULL,
  `school_tot` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_dailyhits_summary`
--

DROP TABLE IF EXISTS `powerapp_brand_dailyhits_summary`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_dailyhits_summary`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_dailyhits_summary` (
  `tran_dt` tinyint NOT NULL,
  `unli_pre` tinyint NOT NULL,
  `email_pre` tinyint NOT NULL,
  `chat_pre` tinyint NOT NULL,
  `photo_pre` tinyint NOT NULL,
  `social_pre` tinyint NOT NULL,
  `speed_pre` tinyint NOT NULL,
  `line_pre` tinyint NOT NULL,
  `snapchat_pre` tinyint NOT NULL,
  `tumblr_pre` tinyint NOT NULL,
  `waze_pre` tinyint NOT NULL,
  `wechat_pre` tinyint NOT NULL,
  `facebook_pre` tinyint NOT NULL,
  `wiki_pre` tinyint NOT NULL,
  `free_social_pre` tinyint NOT NULL,
  `pisonet_pre` tinyint NOT NULL,
  `school_pre` tinyint NOT NULL,
  `unli_tnt` tinyint NOT NULL,
  `email_tnt` tinyint NOT NULL,
  `chat_tnt` tinyint NOT NULL,
  `photo_tnt` tinyint NOT NULL,
  `social_tnt` tinyint NOT NULL,
  `speed_tnt` tinyint NOT NULL,
  `line_tnt` tinyint NOT NULL,
  `snapchat_tnt` tinyint NOT NULL,
  `tumblr_tnt` tinyint NOT NULL,
  `waze_tnt` tinyint NOT NULL,
  `wechat_tnt` tinyint NOT NULL,
  `facebook_tnt` tinyint NOT NULL,
  `wiki_tnt` tinyint NOT NULL,
  `free_social_tnt` tinyint NOT NULL,
  `pisonet_tnt` tinyint NOT NULL,
  `school_tnt` tinyint NOT NULL,
  `unli_ppd` tinyint NOT NULL,
  `email_ppd` tinyint NOT NULL,
  `chat_ppd` tinyint NOT NULL,
  `photo_ppd` tinyint NOT NULL,
  `social_ppd` tinyint NOT NULL,
  `speed_ppd` tinyint NOT NULL,
  `line_ppd` tinyint NOT NULL,
  `snapchat_ppd` tinyint NOT NULL,
  `tumblr_ppd` tinyint NOT NULL,
  `waze_ppd` tinyint NOT NULL,
  `wechat_ppd` tinyint NOT NULL,
  `facebook_ppd` tinyint NOT NULL,
  `wiki_ppd` tinyint NOT NULL,
  `free_social_ppd` tinyint NOT NULL,
  `pisonet_ppd` tinyint NOT NULL,
  `school_ppd` tinyint NOT NULL,
  `unli_tot` tinyint NOT NULL,
  `email_tot` tinyint NOT NULL,
  `chat_tot` tinyint NOT NULL,
  `photo_tot` tinyint NOT NULL,
  `social_tot` tinyint NOT NULL,
  `speed_tot` tinyint NOT NULL,
  `line_tot` tinyint NOT NULL,
  `snapchat_tot` tinyint NOT NULL,
  `tumblr_tot` tinyint NOT NULL,
  `waze_tot` tinyint NOT NULL,
  `wechat_tot` tinyint NOT NULL,
  `facebook_tot` tinyint NOT NULL,
  `wiki_tot` tinyint NOT NULL,
  `free_social_tot` tinyint NOT NULL,
  `pisonet_tot` tinyint NOT NULL,
  `school_tot` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `powerapp_brand_dailyrep`
--

DROP TABLE IF EXISTS `powerapp_brand_dailyrep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_brand_dailyrep` (
  `tran_dt` date NOT NULL,
  `plan` varchar(20) NOT NULL,
  `hits_pre` int(11) NOT NULL DEFAULT '0',
  `hits_ppd` int(11) NOT NULL DEFAULT '0',
  `hits_tnt` int(11) NOT NULL DEFAULT '0',
  `hits_tot` int(11) NOT NULL DEFAULT '0',
  `uniq_pre` int(11) NOT NULL DEFAULT '0',
  `uniq_ppd` int(11) NOT NULL DEFAULT '0',
  `uniq_tnt` int(11) NOT NULL DEFAULT '0',
  `uniq_tot` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tran_dt`,`plan`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `powerapp_brand_dailyuniq`
--

DROP TABLE IF EXISTS `powerapp_brand_dailyuniq`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_dailyuniq`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_dailyuniq` (
  `tran_dt` tinyint NOT NULL,
  `unli_pre` tinyint NOT NULL,
  `email_pre` tinyint NOT NULL,
  `chat_pre` tinyint NOT NULL,
  `photo_pre` tinyint NOT NULL,
  `social_pre` tinyint NOT NULL,
  `speed_pre` tinyint NOT NULL,
  `line_pre` tinyint NOT NULL,
  `snapchat_pre` tinyint NOT NULL,
  `tumblr_pre` tinyint NOT NULL,
  `waze_pre` tinyint NOT NULL,
  `wechat_pre` tinyint NOT NULL,
  `facebook_pre` tinyint NOT NULL,
  `wiki_pre` tinyint NOT NULL,
  `free_social_pre` tinyint NOT NULL,
  `pisonet_pre` tinyint NOT NULL,
  `school_pre` tinyint NOT NULL,
  `unli_tnt` tinyint NOT NULL,
  `email_tnt` tinyint NOT NULL,
  `chat_tnt` tinyint NOT NULL,
  `photo_tnt` tinyint NOT NULL,
  `social_tnt` tinyint NOT NULL,
  `speed_tnt` tinyint NOT NULL,
  `line_tnt` tinyint NOT NULL,
  `snapchat_tnt` tinyint NOT NULL,
  `tumblr_tnt` tinyint NOT NULL,
  `waze_tnt` tinyint NOT NULL,
  `wechat_tnt` tinyint NOT NULL,
  `facebook_tnt` tinyint NOT NULL,
  `wiki_tnt` tinyint NOT NULL,
  `free_social_tnt` tinyint NOT NULL,
  `pisonet_tnt` tinyint NOT NULL,
  `school_tnt` tinyint NOT NULL,
  `unli_ppd` tinyint NOT NULL,
  `email_ppd` tinyint NOT NULL,
  `chat_ppd` tinyint NOT NULL,
  `photo_ppd` tinyint NOT NULL,
  `social_ppd` tinyint NOT NULL,
  `speed_ppd` tinyint NOT NULL,
  `line_ppd` tinyint NOT NULL,
  `snapchat_ppd` tinyint NOT NULL,
  `tumblr_ppd` tinyint NOT NULL,
  `waze_ppd` tinyint NOT NULL,
  `wechat_ppd` tinyint NOT NULL,
  `facebook_ppd` tinyint NOT NULL,
  `wiki_ppd` tinyint NOT NULL,
  `free_social_ppd` tinyint NOT NULL,
  `pisonet_ppd` tinyint NOT NULL,
  `school_ppd` tinyint NOT NULL,
  `unli_tot` tinyint NOT NULL,
  `email_tot` tinyint NOT NULL,
  `chat_tot` tinyint NOT NULL,
  `photo_tot` tinyint NOT NULL,
  `social_tot` tinyint NOT NULL,
  `speed_tot` tinyint NOT NULL,
  `line_tot` tinyint NOT NULL,
  `snapchat_tot` tinyint NOT NULL,
  `tumblr_tot` tinyint NOT NULL,
  `waze_tot` tinyint NOT NULL,
  `wechat_tot` tinyint NOT NULL,
  `facebook_tot` tinyint NOT NULL,
  `wiki_tot` tinyint NOT NULL,
  `free_social_tot` tinyint NOT NULL,
  `pisonet_tot` tinyint NOT NULL,
  `school_tot` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_dailyuniq_summary`
--

DROP TABLE IF EXISTS `powerapp_brand_dailyuniq_summary`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_dailyuniq_summary`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_dailyuniq_summary` (
  `tran_dt` tinyint NOT NULL,
  `unli_pre` tinyint NOT NULL,
  `email_pre` tinyint NOT NULL,
  `chat_pre` tinyint NOT NULL,
  `photo_pre` tinyint NOT NULL,
  `social_pre` tinyint NOT NULL,
  `speed_pre` tinyint NOT NULL,
  `line_pre` tinyint NOT NULL,
  `snapchat_pre` tinyint NOT NULL,
  `tumblr_pre` tinyint NOT NULL,
  `waze_pre` tinyint NOT NULL,
  `wechat_pre` tinyint NOT NULL,
  `facebook_pre` tinyint NOT NULL,
  `wiki_pre` tinyint NOT NULL,
  `free_social_pre` tinyint NOT NULL,
  `pisonet_pre` tinyint NOT NULL,
  `school_pre` tinyint NOT NULL,
  `unli_tnt` tinyint NOT NULL,
  `email_tnt` tinyint NOT NULL,
  `chat_tnt` tinyint NOT NULL,
  `photo_tnt` tinyint NOT NULL,
  `social_tnt` tinyint NOT NULL,
  `speed_tnt` tinyint NOT NULL,
  `line_tnt` tinyint NOT NULL,
  `snapchat_tnt` tinyint NOT NULL,
  `tumblr_tnt` tinyint NOT NULL,
  `waze_tnt` tinyint NOT NULL,
  `wechat_tnt` tinyint NOT NULL,
  `facebook_tnt` tinyint NOT NULL,
  `wiki_tnt` tinyint NOT NULL,
  `free_social_tnt` tinyint NOT NULL,
  `pisonet_tnt` tinyint NOT NULL,
  `school_tnt` tinyint NOT NULL,
  `unli_ppd` tinyint NOT NULL,
  `email_ppd` tinyint NOT NULL,
  `chat_ppd` tinyint NOT NULL,
  `photo_ppd` tinyint NOT NULL,
  `social_ppd` tinyint NOT NULL,
  `speed_ppd` tinyint NOT NULL,
  `line_ppd` tinyint NOT NULL,
  `snapchat_ppd` tinyint NOT NULL,
  `tumblr_ppd` tinyint NOT NULL,
  `waze_ppd` tinyint NOT NULL,
  `wechat_ppd` tinyint NOT NULL,
  `facebook_ppd` tinyint NOT NULL,
  `wiki_ppd` tinyint NOT NULL,
  `free_social_ppd` tinyint NOT NULL,
  `pisonet_ppd` tinyint NOT NULL,
  `school_ppd` tinyint NOT NULL,
  `unli_tot` tinyint NOT NULL,
  `email_tot` tinyint NOT NULL,
  `chat_tot` tinyint NOT NULL,
  `photo_tot` tinyint NOT NULL,
  `social_tot` tinyint NOT NULL,
  `speed_tot` tinyint NOT NULL,
  `line_tot` tinyint NOT NULL,
  `snapchat_tot` tinyint NOT NULL,
  `tumblr_tot` tinyint NOT NULL,
  `waze_tot` tinyint NOT NULL,
  `wechat_tot` tinyint NOT NULL,
  `facebook_tot` tinyint NOT NULL,
  `wiki_tot` tinyint NOT NULL,
  `free_social_tot` tinyint NOT NULL,
  `pisonet_tot` tinyint NOT NULL,
  `school_tot` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_email_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_email_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_email_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_email_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `powerapp_brand_expiry_dailyrep`
--

DROP TABLE IF EXISTS `powerapp_brand_expiry_dailyrep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_brand_expiry_dailyrep` (
  `tran_dt` date NOT NULL,
  `plan` varchar(20) NOT NULL,
  `plan_exp` varchar(20) NOT NULL,
  `hits_pre` int(11) NOT NULL DEFAULT '0',
  `hits_ppd` int(11) NOT NULL DEFAULT '0',
  `hits_tnt` int(11) NOT NULL DEFAULT '0',
  `hits_tot` int(11) NOT NULL DEFAULT '0',
  `uniq_pre` int(11) NOT NULL DEFAULT '0',
  `uniq_ppd` int(11) NOT NULL DEFAULT '0',
  `uniq_tnt` int(11) NOT NULL DEFAULT '0',
  `uniq_tot` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`tran_dt`,`plan`,`plan_exp`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `powerapp_brand_facebook_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_facebook_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_facebook_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_facebook_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_free_social_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_free_social_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_free_social_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_free_social_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_line_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_line_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_line_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_line_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_photo_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_photo_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_photo_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_photo_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_pisonet_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_pisonet_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_pisonet_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_pisonet_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_school_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_school_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_school_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_school_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_snapchat_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_snapchat_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_snapchat_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_snapchat_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_social_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_social_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_social_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_social_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_tumblr_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_tumblr_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_tumblr_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_tumblr_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_unli_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_unli_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_unli_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_unli_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_waze_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_waze_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_waze_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_waze_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_wechat_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_wechat_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_wechat_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_wechat_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_brand_wiki_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_brand_wiki_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_wiki_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_brand_wiki_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `powerapp_concurrent_log`
--

DROP TABLE IF EXISTS `powerapp_concurrent_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_concurrent_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datein` date NOT NULL,
  `timein` time DEFAULT NULL,
  `num_subs` int(11) NOT NULL,
  PRIMARY KEY (`id`,`datein`),
  UNIQUE KEY `date_time_idx` (`datein`,`timein`),
  KEY `datein_idx` (`datein`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `powerapp_concurrent_subs`
--

DROP TABLE IF EXISTS `powerapp_concurrent_subs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_concurrent_subs` (
  `tran_dt` date NOT NULL,
  `num_subs` int(11) DEFAULT '0',
  PRIMARY KEY (`tran_dt`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `powerapp_dailyrep`
--

DROP TABLE IF EXISTS `powerapp_dailyrep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_dailyrep` (
  `tran_dt` date NOT NULL,
  `unli_hits` int(11) DEFAULT '0',
  `unli_uniq` int(11) DEFAULT '0',
  `email_hits` int(11) DEFAULT '0',
  `email_uniq` int(11) DEFAULT '0',
  `chat_hits` int(11) DEFAULT '0',
  `chat_uniq` int(11) DEFAULT '0',
  `photo_hits` int(11) DEFAULT '0',
  `photo_uniq` int(11) DEFAULT '0',
  `social_hits` int(11) DEFAULT '0',
  `social_uniq` int(11) DEFAULT '0',
  `speed_hits` int(11) DEFAULT '0',
  `speed_uniq` int(11) DEFAULT '0',
  `line_hits` int(11) DEFAULT '0',
  `line_uniq` int(11) DEFAULT '0',
  `snap_hits` int(11) DEFAULT '0',
  `snap_uniq` int(11) DEFAULT '0',
  `tumblr_hits` int(11) DEFAULT '0',
  `tumblr_uniq` int(11) DEFAULT '0',
  `waze_hits` int(11) DEFAULT '0',
  `waze_uniq` int(11) DEFAULT '0',
  `wechat_hits` int(11) DEFAULT '0',
  `wechat_uniq` int(11) DEFAULT '0',
  `wiki_hits` int(11) DEFAULT '0',
  `wiki_uniq` int(11) DEFAULT '0',
  `piso_hits` int(11) DEFAULT '0',
  `piso_uniq` int(11) DEFAULT '0',
  `total_hits` int(11) DEFAULT '0',
  `total_uniq` int(11) DEFAULT '0',
  `num_optout` int(11) DEFAULT '0',
  `concurrent_max_tm` varchar(100) DEFAULT '00:00:00',
  `concurrent_max_subs` int(11) DEFAULT '0',
  `concurrent_avg_subs` decimal(10,2) DEFAULT '0.00',
  `num_uniq_30d` int(11) DEFAULT '0',
  `free_social_hits` int(11) DEFAULT '0',
  `free_social_uniq` int(11) DEFAULT '0',
  `facebook_hits` int(11) DEFAULT '0',
  `facebook_uniq` int(11) DEFAULT '0',
  `school_hits` int(11) DEFAULT '0',
  `school_uniq` int(11) DEFAULT '0',
  `coc_hits` int(11) DEFAULT '0',
  `coc_uniq` int(11) DEFAULT '0',
  `youtube_hits` int(11) DEFAULT '0',
  `youtube_uniq` int(11) DEFAULT '0',
  PRIMARY KEY (`tran_dt`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `powerapp_hourlyrep`
--

DROP TABLE IF EXISTS `powerapp_hourlyrep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_hourlyrep` (
  `tran_dt` date NOT NULL,
  `tran_tm` time NOT NULL,
  `unli_hits_3` int(11) DEFAULT '0',
  `unli_hits_24` int(11) DEFAULT '0',
  `unli_uniq_3` int(11) DEFAULT '0',
  `unli_uniq_24` int(11) DEFAULT '0',
  `email_hits_3` int(11) DEFAULT '0',
  `email_hits_24` int(11) DEFAULT '0',
  `email_uniq_3` int(11) DEFAULT '0',
  `email_uniq_24` int(11) DEFAULT '0',
  `chat_hits_3` int(11) DEFAULT '0',
  `chat_hits_24` int(11) DEFAULT '0',
  `chat_uniq_3` int(11) DEFAULT '0',
  `chat_uniq_24` int(11) DEFAULT '0',
  `photo_hits_3` int(11) DEFAULT '0',
  `photo_hits_24` int(11) DEFAULT '0',
  `photo_uniq_3` int(11) DEFAULT '0',
  `photo_uniq_24` int(11) DEFAULT '0',
  `social_hits_3` int(11) DEFAULT '0',
  `social_hits_24` int(11) DEFAULT '0',
  `social_uniq_3` int(11) DEFAULT '0',
  `social_uniq_24` int(11) DEFAULT '0',
  `speed_hits` int(11) DEFAULT '0',
  `speed_uniq` int(11) DEFAULT '0',
  `line_hits_24` int(11) DEFAULT '0',
  `line_uniq_24` int(11) DEFAULT '0',
  `snap_hits_24` int(11) DEFAULT '0',
  `snap_uniq_24` int(11) DEFAULT '0',
  `tumblr_hits_24` int(11) DEFAULT '0',
  `tumblr_uniq_24` int(11) DEFAULT '0',
  `waze_hits_24` int(11) DEFAULT '0',
  `waze_uniq_24` int(11) DEFAULT '0',
  `wechat_hits_24` int(11) DEFAULT '0',
  `wechat_uniq_24` int(11) DEFAULT '0',
  `wiki_hits_24` int(11) DEFAULT '0',
  `wiki_uniq_24` int(11) DEFAULT '0',
  `piso_hits_15` int(11) DEFAULT '0',
  `piso_uniq_15` int(11) DEFAULT '0',
  `total_hits` int(11) DEFAULT '0',
  `total_uniq` int(11) DEFAULT '0',
  `facebook_hits_24` int(11) DEFAULT '0',
  `facebook_uniq_24` int(11) DEFAULT '0',
  `free_social_hits_24` int(11) DEFAULT '0',
  `free_social_uniq_24` int(11) DEFAULT '0',
  `unli_hits_24_pp` int(11) DEFAULT '0',
  `unli_uniq_24_pp` int(11) DEFAULT '0',
  `school_hits_24` int(11) DEFAULT '0',
  `school_uniq_24` int(11) DEFAULT '0',
  `coc_hits_24` int(11) DEFAULT '0',
  `coc_uniq_24` int(11) DEFAULT '0',
  `line_hits_24_pp` int(11) DEFAULT '0',
  `line_uniq_24_pp` int(11) DEFAULT '0',
  `wechat_hits_24_pp` int(11) DEFAULT '0',
  `wechat_uniq_24_pp` int(11) DEFAULT '0',
  `photo_hits_24_pp` int(11) DEFAULT '0',
  `photo_uniq_24_pp` int(11) DEFAULT '0',
  `social_hits_24_pp` int(11) DEFAULT '0',
  `social_uniq_24_pp` int(11) DEFAULT '0',
  `youtube_hits_30` int(11) DEFAULT '0',
  `youtube_uniq_30` int(11) DEFAULT '0',
  PRIMARY KEY (`tran_dt`,`tran_tm`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `powerapp_line_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_line_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_line_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_line_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

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
  `request_id` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`,`datein`),
  KEY `datein_idx` (`datein`)
) ENGINE=MyISAM AUTO_INCREMENT=254047 DEFAULT CHARSET=latin1;
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
  `brand` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`,`datein`),
  UNIQUE KEY `phone` (`phone`,`datein`),
  KEY `datein_idx` (`datein`)
) ENGINE=MyISAM AUTO_INCREMENT=17862 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `powerapp_optout_users`
--

DROP TABLE IF EXISTS `powerapp_optout_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_optout_users` (
  `phone` varchar(12) NOT NULL,
  `datein` datetime DEFAULT NULL,
  `brand` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`phone`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `powerapp_snapchat_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_snapchat_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_snapchat_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_snapchat_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_tumblr_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_tumblr_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_tumblr_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_tumblr_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `powerapp_validity_dailyrep`
--

DROP TABLE IF EXISTS `powerapp_validity_dailyrep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `powerapp_validity_dailyrep` (
  `tran_dt` date NOT NULL,
  `unli_hits_3` int(11) DEFAULT '0',
  `unli_hits_24` int(11) DEFAULT '0',
  `unli_uniq_3` int(11) DEFAULT '0',
  `unli_uniq_24` int(11) DEFAULT '0',
  `email_hits_3` int(11) DEFAULT '0',
  `email_hits_24` int(11) DEFAULT '0',
  `email_uniq_3` int(11) DEFAULT '0',
  `email_uniq_24` int(11) DEFAULT '0',
  `chat_hits_3` int(11) DEFAULT '0',
  `chat_hits_24` int(11) DEFAULT '0',
  `chat_uniq_3` int(11) DEFAULT '0',
  `chat_uniq_24` int(11) DEFAULT '0',
  `photo_hits_3` int(11) DEFAULT '0',
  `photo_hits_24` int(11) DEFAULT '0',
  `photo_uniq_3` int(11) DEFAULT '0',
  `photo_uniq_24` int(11) DEFAULT '0',
  `social_hits_3` int(11) DEFAULT '0',
  `social_hits_24` int(11) DEFAULT '0',
  `social_uniq_3` int(11) DEFAULT '0',
  `social_uniq_24` int(11) DEFAULT '0',
  `speed_hits` int(11) DEFAULT '0',
  `speed_uniq` int(11) DEFAULT '0',
  `line_hits_24` int(11) DEFAULT '0',
  `line_uniq_24` int(11) DEFAULT '0',
  `snap_hits_24` int(11) DEFAULT '0',
  `snap_uniq_24` int(11) DEFAULT '0',
  `tumblr_hits_24` int(11) DEFAULT '0',
  `tumblr_uniq_24` int(11) DEFAULT '0',
  `waze_hits_24` int(11) DEFAULT '0',
  `waze_uniq_24` int(11) DEFAULT '0',
  `wechat_hits_24` int(11) DEFAULT '0',
  `wechat_uniq_24` int(11) DEFAULT '0',
  `wiki_hits_24` int(11) DEFAULT '0',
  `wiki_uniq_24` int(11) DEFAULT '0',
  `piso_hits_15` int(11) DEFAULT '0',
  `piso_uniq_15` int(11) DEFAULT '0',
  `total_hits` int(11) DEFAULT '0',
  `total_uniq` int(11) DEFAULT '0',
  `facebook_hits_24` int(11) DEFAULT '0',
  `facebook_uniq_24` int(11) DEFAULT '0',
  `free_social_hits_24` int(11) DEFAULT '0',
  `free_social_uniq_24` int(11) DEFAULT '0',
  `unli_hits_24_pp` int(11) DEFAULT '0',
  `unli_uniq_24_pp` int(11) DEFAULT '0',
  `school_hits_24` int(11) DEFAULT '0',
  `school_uniq_24` int(11) DEFAULT '0',
  `coc_hits_24` int(11) DEFAULT '0',
  `coc_uniq_24` int(11) DEFAULT '0',
  `line_hits_24_pp` int(11) DEFAULT '0',
  `line_uniq_24_pp` int(11) DEFAULT '0',
  `wechat_hits_24_pp` int(11) DEFAULT '0',
  `wechat_uniq_24_pp` int(11) DEFAULT '0',
  `photo_hits_24_pp` int(11) DEFAULT '0',
  `photo_uniq_24_pp` int(11) DEFAULT '0',
  `social_hits_24_pp` int(11) DEFAULT '0',
  `social_uniq_24_pp` int(11) DEFAULT '0',
  `youtube_hits_30` int(11) DEFAULT '0',
  `youtube_uniq_30` int(11) DEFAULT '0',
  PRIMARY KEY (`tran_dt`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `powerapp_waze_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_waze_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_waze_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_waze_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_wechat_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_wechat_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_wechat_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_wechat_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `powerapp_wiki_dailyhits`
--

DROP TABLE IF EXISTS `powerapp_wiki_dailyhits`;
/*!50001 DROP VIEW IF EXISTS `powerapp_wiki_dailyhits`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `powerapp_wiki_dailyhits` (
  `tran_dt` tinyint NOT NULL,
  `plan_3_pre` tinyint NOT NULL,
  `plan_24_pre` tinyint NOT NULL,
  `plan_tot_pre` tinyint NOT NULL,
  `plan_3_tnt` tinyint NOT NULL,
  `plan_24_tnt` tinyint NOT NULL,
  `plan_tot_tnt` tinyint NOT NULL,
  `plan_3_ppd` tinyint NOT NULL,
  `plan_24_ppd` tinyint NOT NULL,
  `plan_tot_ppd` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ureg_error_log`
--

DROP TABLE IF EXISTS `ureg_error_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ureg_error_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `datein` datetime NOT NULL,
  `phone` varchar(12) NOT NULL,
  `brand` varchar(16) DEFAULT NULL,
  `promo_id` varchar(16) DEFAULT NULL,
  `error_text` varchar(128) DEFAULT NULL,
  `error_code` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id`,`datein`),
  KEY `datein_idx` (`datein`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'powerapp_sun'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_generate_pwrapp_sun_brand_stats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generate_pwrapp_sun_brand_stats`(p_date date)
begin
   delete from powerapp_brand_dailyrep where tran_dt = p_date;
   delete from powerapp_brand_expiry_dailyrep where tran_dt = p_date;
   select count(1) into @brandIsNull from powerapp_optout_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand is null;
   if @brandIsNull > 0 then
      call sp_optout_add_brand(p_date);
   end if;

   insert into powerapp_brand_dailyrep
   select tran_dt, plan, sum(hits_pre), sum(hits_ppd), sum(hits_tnt), sum(hits_tot), sum(uniq_pre), sum(uniq_ppd), sum(uniq_tnt), sum(uniq_tot) from (
   select left(datein, 10) tran_dt, plan, count(1) hits_pre, 0 hits_ppd, 0 hits_tnt, 0 hits_tot, count(distinct phone) uniq_pre, 0 uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and free='false' and brand='PREPAID' group by tran_dt, plan union
   select left(datein, 10) tran_dt, plan, 0 hits_pre, count(1) hits_ppd, 0 hits_tnt, 0 hits_tot, 0 uniq_pre, count(distinct phone) uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and free='false' and brand='POSTPAID' group by tran_dt, plan union
   select left(datein, 10) tran_dt, plan, 0 hits_pre, 0 hits_ppd, 0 hits_tnt, count(1) hits_tot, 0 uniq_pre, 0 uniq_ppd, 0 uniq_tnt, count(distinct phone) uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and free='false' group by tran_dt, plan
   ) temp_table group by tran_dt, plan;


   insert into powerapp_brand_expiry_dailyrep
   select tran_dt, plan, plan_exp, sum(hits_pre), sum(hits_ppd), sum(hits_tnt), sum(hits_tot), sum(uniq_pre), sum(uniq_ppd), sum(uniq_tnt), sum(uniq_tot) from (
   select left(datein, 10) tran_dt, plan, IF(validity<86400, '3H', '24H') plan_exp, count(1) hits_pre, 0 hits_ppd, 0 hits_tnt, 0 hits_tot, count(distinct phone) uniq_pre, 0 uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and free='false' and brand='PREPAID' group by tran_dt, plan, plan_exp union
   select left(datein, 10) tran_dt, plan, IF(validity<86400, '3H', '24H') plan_exp, 0 hits_pre, count(1) hits_ppd, 0 hits_tnt, 0 hits_tot, 0 uniq_pre, count(distinct phone) uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and free='false' and brand='POSTPAID' group by tran_dt, plan, plan_exp union
   select left(datein, 10) tran_dt, plan, IF(validity<86400, '3H', '24H') plan_exp, 0 hits_pre, 0 hits_ppd, 0 hits_tnt, count(1) hits_tot, 0 uniq_pre, 0 uniq_ppd, 0 uniq_tnt, count(distinct phone) uniq_tot from powerapp_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and free='false' group by tran_dt, plan, plan_exp
   ) temp_table group by tran_dt, plan, plan_exp;

   insert into powerapp_brand_dailyrep
   select tran_dt, 'OPTOUT', sum(hits_pre), sum(hits_ppd), sum(hits_tnt), sum(hits_tot), sum(uniq_pre), sum(uniq_ppd), sum(uniq_tnt), sum(uniq_tot) from (
   select left(datein, 10) tran_dt, count(1) hits_pre, 0 hits_ppd, 0 hits_tnt, 0 hits_tot, 0 uniq_pre, 0 uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_optout_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='PREPAID' group by tran_dt union
   select left(datein, 10) tran_dt, 0 hits_pre, count(1) hits_ppd, 0 hits_tnt, 0 hits_tot, 0 uniq_pre, 0 uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_optout_log where datein >= p_date and datein < date_add(p_date, interval 1 day) and brand='POSTPAID' group by tran_dt union
   select left(datein, 10) tran_dt, 0 hits_pre, 0 hits_ppd, 0 hits_tnt, count(1) hits_tot, 0 uniq_pre, 0 uniq_ppd, 0 uniq_tnt, 0 uniq_tot from powerapp_optout_log where datein >= p_date and datein < date_add(p_date, interval 1 day) group by tran_dt
   ) temp_table group by tran_dt;

   insert ignore powerapp_brand_dailyrep
   select p_date, plan, 0, 0, 0, 0, 0, 0, 0, 0 from powerapp_brand_expiry_dailyrep group by plan;

   insert ignore powerapp_brand_expiry_dailyrep
   select p_date, plan, plan_exp, 0, 0, 0, 0, 0, 0, 0, 0 from powerapp_brand_expiry_dailyrep group by plan, plan_exp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_generate_pwrapp_sun_stats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generate_pwrapp_sun_stats`(p_trandate date)
begin
    if p_trandate is null then
       SET @tran_dt = date_sub(curdate(), interval 1 day);
       SET @tran_nw = curdate();
    else
       SET @tran_dt = p_trandate;
       SET @tran_nw = date_add(p_trandate, interval 1 day);
    end if;
    delete from powerapp_dailyrep where tran_dt = @tran_dt;
    delete from powerapp_validity_dailyrep where tran_dt = @tran_dt;
    delete from powerapp_hourlyrep where tran_dt = @tran_dt;

    select count(1), count(distinct phone) into @unli_hits,        @unli_uniq        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI';
    select count(1), count(distinct phone) into @email_hits,       @email_uniq       from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL';
    select count(1), count(distinct phone) into @chat_hits,        @chat_uniq        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CHAT';
    select count(1), count(distinct phone) into @photo_hits,       @photo_uniq       from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO';
    select count(1), count(distinct phone) into @free_social_hits, @free_social_uniq from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='FREE_SOCIAL';
    select count(1), count(distinct phone) into @social_hits,      @social_uniq      from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL';
    select count(1), count(distinct phone) into @facebook_hits,    @facebook_uniq    from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='FACEBOOK';
    select count(1), count(distinct phone) into @speed_hits,       @speed_uniq       from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SPEEDBOOST';
    select count(1), count(distinct phone) into @line_hits,        @line_uniq        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='LINE';
    select count(1), count(distinct phone) into @snap_hits,        @snap_uniq        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SNAPCHAT';
    select count(1), count(distinct phone) into @tumblr_hits,      @tumblr_uniq      from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='TUMBLR';
    select count(1), count(distinct phone) into @waze_hits,        @waze_uniq        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WAZE';
    select count(1), count(distinct phone) into @wechat_hits,      @wechat_uniq      from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT';
    select count(1), count(distinct phone) into @wiki_hits,        @wiki_uniq        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WIKIPEDIA';
    select count(1), count(distinct phone) into @piso_hits,        @piso_uniq        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PISONET';
    select count(1), count(distinct phone) into @school_hits,      @school_uniq      from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='BACKTOSCHOOL';
    select count(1), count(distinct phone) into @coc_hits,         @coc_uniq         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CLASHOFCLANS';
    select count(1), count(distinct phone) into @youtube_hits,     @youtube_uniq     from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='YOUTUBE';
    select count(1), count(distinct phone) into @total_hits,       @total_uniq       from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false';

    insert ignore into powerapp_dailyrep (
            tran_dt, total_hits, total_uniq, piso_hits, piso_uniq, school_hits, school_uniq, coc_hits, coc_uniq, youtube_hits, youtube_uniq,
            unli_hits, email_hits, social_hits, photo_hits, chat_hits, speed_hits, line_hits, snap_hits, tumblr_hits, waze_hits, wechat_hits, wiki_hits, free_social_hits, facebook_hits,
            unli_uniq, email_uniq, social_uniq, photo_uniq, chat_uniq, speed_uniq, line_uniq, snap_uniq, tumblr_uniq, waze_uniq, wechat_uniq, wiki_uniq, free_social_uniq, facebook_uniq )
    values (@tran_dt, @total_hits, @total_uniq, @piso_hits, @piso_uniq, @school_hits, @school_uniq, @coc_hits, @coc_uniq, @youtube_hits, @youtube_uniq,
            @unli_hits, @email_hits, @social_hits, @photo_hits, @chat_hits, @speed_hits, @line_hits, @snap_hits, @tumblr_hits, @waze_hits, @wechat_hits, @wiki_hits, @free_social_hits, @facebook_hits,
            @unli_uniq, @email_uniq, @social_uniq, @photo_uniq, @chat_uniq, @speed_uniq, @line_uniq, @snap_uniq, @tumblr_uniq, @waze_uniq, @wechat_uniq, @wiki_uniq, @free_social_uniq, @facebook_uniq);

    select max(timein)
    into   @vTimeIn
    from   powerapp_concurrent_log
    where  datein = @tran_dt;

    if (@vTimeIn = '23:59:00') then

       select group_concat(left(timein,5) SEPARATOR ','), num_subs
       into   @vTimeIn, @vNumSubs
       from   powerapp_concurrent_log
       where  datein = @tran_dt
       and    num_subs = (select max(num_subs)
                          from   powerapp_concurrent_log
                          where  datein = @tran_dt
                         );

       select avg(num_subs)
       into   @vAvgSubs
       from   powerapp_concurrent_log
       where  datein = @tran_dt;

       select count(1)
       into   @vNumOptout
       from   powerapp_optout_log
       where  datein >= @tran_dt
       and    datein < @tran_nw;
    else
       SET @vTimeIn  = '00:00';
       SET @vNumSubs = 0;
       SET @vAvgSubs = 0;
       SET @vNumOptout = 0;
    end if;

    if @tran_dt = last_day(@tran_dt) then
       select count(distinct phone)
       into  @NumUniq30d
       from powerapp_log
       where left(datein,7) = left(@tran_dt, 7);
    else
       select count(distinct phone)
       into  @NumUniq30d
       from powerapp_log
       where datein >= date_sub(@tran_dt, interval 30 day)
       and datein < @tran_nw;
    end if;

    update powerapp_dailyrep
    set    num_optout= IFNULL(@vNumOptout,0),
           concurrent_max_tm= IFNULL(@vTimeIn,'00:00'),
           concurrent_max_subs=IFNULL(@vNumSubs,0),
           concurrent_avg_subs=IFNULL(@vAvgSubs,0),
           num_uniq_30d=IFNULL(@NumUniq30d,0)
    where  tran_dt = @tran_dt;

    select count(1), count(distinct phone) into @unli_hits_3,         @unli_uniq_3          from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and validity<86400;
    select count(1), count(distinct phone) into @unli_hits_24,        @unli_uniq_24         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and brand = 'POSTPAID' and validity >=86400;
    select count(1), count(distinct phone) into @unli_hits_24_pp,     @unli_uniq_24_pp      from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='UNLI' and brand = 'PREPAID'  and validity >=86400;
    select count(1), count(distinct phone) into @email_hits_3,        @email_uniq_3         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL' and validity<86400;
    select count(1), count(distinct phone) into @email_hits_24,       @email_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='EMAIL' and validity >=86400;
    select count(1), count(distinct phone) into @chat_hits_3,         @chat_uniq_3          from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CHAT' and validity<86400;
    select count(1), count(distinct phone) into @chat_hits_24,        @chat_uniq_24         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CHAT' and validity >=86400;
    select count(1), count(distinct phone) into @photo_hits_3,        @photo_uniq_3         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity<86400;
    select count(1), count(distinct phone) into @photo_hits_24,       @photo_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity >=86400 and brand = 'POSTPAID';
    select count(1), count(distinct phone) into @photo_hits_24_pp,    @photo_uniq_24_pp     from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PHOTO' and validity >=86400 and brand = 'PREPAID'; 
    select count(1), count(distinct phone) into @social_hits_3,       @social_uniq_3        from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity <86400;
    select count(1), count(distinct phone) into @social_hits_24,      @social_uniq_24       from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity >=86400 and brand = 'POSTPAID';
    select count(1), count(distinct phone) into @social_hits_24_pp,   @social_uniq_24_pp    from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SOCIAL' and validity >=86400 and brand = 'PREPAID'; 
    select count(1), count(distinct phone) into @speed_hits,          @speed_uniq           from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SPEEDBOOST';
    select count(1), count(distinct phone) into @line_hits_24,        @line_uniq_24         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='LINE' and brand = 'POSTPAID';
    select count(1), count(distinct phone) into @line_hits_24_pp,     @line_uniq_24_pp      from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='LINE' and brand = 'PREPAID'; 
    select count(1), count(distinct phone) into @snap_hits_24,        @snap_uniq_24         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='SNAPCHAT';
    select count(1), count(distinct phone) into @tumblr_hits_24,      @tumblr_uniq_24       from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='TUMBLR';
    select count(1), count(distinct phone) into @waze_hits_24,        @waze_uniq_24         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WAZE';
    select count(1), count(distinct phone) into @wechat_hits_24,      @wechat_uniq_24       from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT' and brand = 'POSTPAID';
    select count(1), count(distinct phone) into @wechat_hits_24_pp,   @wechat_uniq_24_pp    from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WECHAT' and brand = 'PREPAID'; 
    select count(1), count(distinct phone) into @wiki_hits_24,        @wiki_uniq_24         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='WIKIPEDIA';
    select count(1), count(distinct phone) into @facebook_hits_24,    @facebook_uniq_24     from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='FACEBOOK';
    select count(1), count(distinct phone) into @free_social_hits_24, @free_social_uniq_24  from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='FREE_SOCIAL';
    select count(1), count(distinct phone) into @piso_hits_15,        @piso_uniq_15         from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='PISONET' and validity <= 900;
    select count(1), count(distinct phone) into @school_hits_24,      @school_uniq_24       from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='BACKTOSCHOOL';
    select count(1), count(distinct phone) into @coc_hits_24,         @coc_uniq_24          from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='CLASHOFCLANS';
    select count(1), count(distinct phone) into @youtube_hits_30,     @youtube_uniq_30      from powerapp_log where datein > @tran_dt and datein < @tran_nw and free='false' and plan='YOUTUBE';

    insert ignore into powerapp_validity_dailyrep
           (tran_dt,              total_hits,      total_uniq,
            unli_hits_3,          unli_uniq_3,
            unli_hits_24,         unli_uniq_24,
            unli_hits_24_pp,      unli_uniq_24_pp,
            email_hits_3,         email_hits_24,   email_uniq_3,   email_uniq_24,
            chat_hits_3,          chat_hits_24,    chat_uniq_3,    chat_uniq_24,
            photo_hits_3,         photo_uniq_3,
            photo_hits_24,        photo_uniq_24,
            photo_hits_24_pp,     photo_uniq_24_pp,
            social_hits_3,        social_uniq_3,
            social_hits_24,       social_uniq_24,
            social_hits_24_pp,    social_uniq_24_pp,
            speed_hits,           speed_uniq,
            line_hits_24,         line_uniq_24,
            line_hits_24_pp,      line_uniq_24_pp,
            snap_hits_24,         snap_uniq_24,
            tumblr_hits_24,       tumblr_uniq_24,
            waze_hits_24,         waze_uniq_24,
            wechat_hits_24,       wechat_uniq_24,
            wechat_hits_24_pp,    wechat_uniq_24_pp,
            wiki_hits_24,         wiki_uniq_24,
            facebook_hits_24,     facebook_uniq_24,
            free_social_hits_24,  free_social_uniq_24,
            piso_hits_15,         piso_uniq_15,
            school_hits_24,       school_uniq_24,
            coc_hits_24,          coc_uniq_24,
            youtube_hits_30,      youtube_uniq_30)
    values (@tran_dt,             @total_hits,     @total_uniq,
            @unli_hits_3,         @unli_uniq_3,
            @unli_hits_24,        @unli_uniq_24,
            @unli_hits_24_pp,     @unli_uniq_24_pp,
            @email_hits_3,        @email_hits_24,  @email_uniq_3,  @email_uniq_24,
            @chat_hits_3,         @chat_hits_24,   @chat_uniq_3,   @chat_uniq_24,
            @photo_hits_3,        @photo_uniq_3,
            @photo_hits_24,       @photo_uniq_24,
            @photo_hits_24_pp,    @photo_uniq_24_pp,
            @social_hits_3,       @social_uniq_3,
            @social_hits_24,      @social_uniq_24,
            @social_hits_24_pp,   @social_uniq_24_pp,
            @speed_hits,          @speed_uniq,
            @line_hits_24,        @line_uniq_24,
            @line_hits_24_pp,     @line_uniq_24_pp,
            @snap_hits_24,        @snap_uniq_24,
            @tumblr_hits_24,      @tumblr_uniq_24,
            @waze_hits_24,        @waze_uniq_24,
            @wechat_hits_24,      @wechat_uniq_24,
            @wechat_hits_24_pp,   @wechat_uniq_24_pp,
            @wiki_hits_24,        @wiki_uniq_24,
            @facebook_hits_24,    @facebook_uniq_24,
            @free_social_hits_24, @free_social_uniq_24,
            @piso_hits_15,        @piso_uniq_15,
            @school_hits_24,      @school_uniq_24,
            @coc_hits_24,         @coc_uniq_24,
            @youtube_hits_30,     @youtube_uniq_30);

   set @vCtr = 0;
   WHILE (@vCtr <= 23) DO

      select concat(lpad(@vCtr, 2, '0'), ':00:00') into @tran_tm;
      select 0, 0 into @unli_hits_3,         @unli_uniq_3;
      select 0, 0 into @unli_hits_24,        @unli_uniq_24;
      select 0, 0 into @unli_hits_24_pp,     @unli_uniq_24_pp;
      select 0, 0 into @email_hits_3,        @email_uniq_3;
      select 0, 0 into @email_hits_24,       @email_uniq_24;
      select 0, 0 into @chat_hits_3,         @chat_uniq_3;
      select 0, 0 into @chat_hits_24,        @chat_uniq_24;
      select 0, 0 into @photo_hits_3,        @photo_uniq_3;
      select 0, 0 into @photo_hits_24,       @photo_uniq_24;
      select 0, 0 into @photo_hits_24_pp,    @photo_uniq_24_pp;
      select 0, 0 into @social_hits_3,       @social_uniq_3;
      select 0, 0 into @social_hits_24,      @social_uniq_24;
      select 0, 0 into @social_hits_24_pp,   @social_uniq_24_pp;
      select 0, 0 into @speed_hits,          @speed_uniq;
      select 0, 0 into @line_hits_24,        @line_uniq_24;
      select 0, 0 into @line_hits_24_pp,     @line_uniq_24_pp;
      select 0, 0 into @snap_hits_24,        @snap_uniq_24;
      select 0, 0 into @tumblr_hits_24,      @tumblr_uniq_24;
      select 0, 0 into @waze_hits_24,        @waze_uniq_24;
      select 0, 0 into @wechat_hits_24,      @wechat_uniq_24;
      select 0, 0 into @wechat_hits_24_pp,   @wechat_uniq_24_pp;
      select 0, 0 into @wiki_hits_24,        @wiki_uniq_24;
      select 0, 0 into @facebook_hits_24,    @facebook_uniq_24;
      select 0, 0 into @free_social_hits_24, @free_social_uniq_24;
      select 0, 0 into @piso_hits_15,        @piso_uniq_15;
      select 0, 0 into @school_hits_24,      @school_uniq_24;
      select 0, 0 into @coc_hits_24,         @coc_uniq_24;
      select 0, 0 into @youtube_hits_30,     @youtube_uniq_30;


      select count(1), count(distinct phone) into @unli_hits_3,         @unli_uniq_3         from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and validity<86400;
      select count(1), count(distinct phone) into @unli_hits_24,        @unli_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and brand = 'POSTPAID' and validity >=86400;
      select count(1), count(distinct phone) into @unli_hits_24_pp,     @unli_uniq_24_pp     from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='UNLI' and brand = 'PREPAID'  and validity >=86400;
      select count(1), count(distinct phone) into @email_hits_3,        @email_uniq_3        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity<86400;
      select count(1), count(distinct phone) into @email_hits_24,       @email_uniq_24       from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='EMAIL' and validity >=86400;
      select count(1), count(distinct phone) into @chat_hits_3,         @chat_uniq_3         from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity<86400;
      select count(1), count(distinct phone) into @chat_hits_24,        @chat_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CHAT' and validity >=86400;
      select count(1), count(distinct phone) into @photo_hits_3,        @photo_uniq_3        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity < 86400;
      select count(1), count(distinct phone) into @photo_hits_24,       @photo_uniq_24       from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity >=86400 and brand = 'POSTPAID';
      select count(1), count(distinct phone) into @photo_hits_24_pp,    @photo_uniq_24_pp    from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PHOTO' and validity >=86400 and brand = 'PREPAID'; 
      select count(1), count(distinct phone) into @social_hits_3,       @social_uniq_3       from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity < 86400;
      select count(1), count(distinct phone) into @social_hits_24,      @social_uniq_24      from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity >=86400 and brand = 'POSTPAID';
      select count(1), count(distinct phone) into @social_hits_24_pp,   @social_uniq_24_pp   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SOCIAL' and validity >=86400 and brand = 'PREPAID'; 
      select count(1), count(distinct phone) into @piso_hits_15,        @piso_uniq_15        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='PISONET' and validity <= 900;
      select count(1), count(distinct phone) into @speed_hits,          @speed_uniq          from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SPEEDBOOST';
      select count(1), count(distinct phone) into @line_hits_24,        @line_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='LINE' and brand = 'POSTPAID';
      select count(1), count(distinct phone) into @line_hits_24_pp,     @line_uniq_24_pp     from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='LINE' and brand = 'PREPAID'; 
      select count(1), count(distinct phone) into @snap_hits_24,        @snap_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='SNAPCHAT';
      select count(1), count(distinct phone) into @tumblr_hits_24,      @tumblr_uniq_24      from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='TUMBLR';
      select count(1), count(distinct phone) into @waze_hits_24,        @waze_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WAZE';
      select count(1), count(distinct phone) into @wechat_hits_24,      @wechat_uniq_24      from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WECHAT' and brand = 'POSTPAID';
      select count(1), count(distinct phone) into @wechat_hits_24_pp,   @wechat_uniq_24_pp   from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WECHAT' and brand = 'PREPAID'; 
      select count(1), count(distinct phone) into @wiki_hits_24,        @wiki_uniq_24        from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='WIKIPEDIA';
      select count(1), count(distinct phone) into @facebook_hits_24,    @facebook_uniq_24    from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='FACEBOOK';
      select count(1), count(distinct phone) into @free_social_hits_24, @free_social_uniq_24 from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='FREE_SOCIAL';
      select count(1), count(distinct phone) into @school_hits_24,      @school_uniq_24      from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='BACKTOSCHOOL';
      select count(1), count(distinct phone) into @coc_hits_24,         @coc_uniq_24         from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='CLASHOFCLANS';
      select count(1), count(distinct phone) into @youtube_hits_30,     @youtube_uniq_30     from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false' and plan='YOUTUBE';
      select count(1), count(distinct phone) into @total_hits,          @total_uniq          from powerapp_log where datein > @tran_dt and datein < @tran_nw and substring(datein, 12, 2) = lpad(@vCtr, 2, '0') and free='false';
      SET @vCtr = @vCtr + 1;

      insert ignore into powerapp_hourlyrep
             (tran_dt,              tran_tm,         total_hits,     total_uniq,
              unli_hits_3,          unli_uniq_3,
              unli_hits_24,         unli_uniq_24,
              unli_hits_24_pp,      unli_uniq_24_pp,
              email_hits_3,         email_hits_24,   email_uniq_3,   email_uniq_24,
              chat_hits_3,          chat_hits_24,    chat_uniq_3,    chat_uniq_24,
              photo_hits_3,         photo_uniq_3,
              photo_hits_24,        photo_uniq_24,
              photo_hits_24_pp,     photo_uniq_24_pp,
              social_hits_3,        social_uniq_3,
              social_hits_24,       social_uniq_24,
              social_hits_24_pp,    social_uniq_24_pp,
              speed_hits,           speed_uniq,
              line_hits_24,         line_uniq_24,
              line_hits_24_pp,      line_uniq_24_pp,
              snap_hits_24,         snap_uniq_24,
              tumblr_hits_24,       tumblr_uniq_24,
              waze_hits_24,         waze_uniq_24,
              wechat_hits_24,       wechat_uniq_24,
              wechat_hits_24_pp,    wechat_uniq_24_pp,
              wiki_hits_24,         wiki_uniq_24,
              facebook_hits_24,     facebook_uniq_24,
              free_social_hits_24,  free_social_uniq_24,
              piso_hits_15,         piso_uniq_15,
              school_hits_24,       school_uniq_24,
              coc_hits_24,          coc_uniq_24,
              youtube_hits_30,      youtube_uniq_30)
      values (@tran_dt,             @tran_tm,        @total_hits,    @total_uniq,
              @unli_hits_3,         @unli_uniq_3,
              @unli_hits_24,        @unli_uniq_24,
              @unli_hits_24_pp,     @unli_uniq_24_pp,
              @email_hits_3,        @email_hits_24,  @email_uniq_3,  @email_uniq_24,
              @chat_hits_3,         @chat_hits_24,   @chat_uniq_3,   @chat_uniq_24,
              @photo_hits_3,        @photo_uniq_3,
              @photo_hits_24,       @photo_uniq_24,
              @photo_hits_24_pp,    @photo_uniq_24_pp,
              @social_hits_3,       @social_uniq_3,
              @social_hits_24,      @social_uniq_24,
              @social_hits_24_pp,   @social_uniq_24_pp,
              @speed_hits,          @speed_uniq,
              @line_hits_24,        @line_uniq_24,
              @line_hits_24_pp,     @line_uniq_24_pp,
              @snap_hits_24,        @snap_uniq_24,
              @tumblr_hits_24,      @tumblr_uniq_24,
              @waze_hits_24,        @waze_uniq_24,
              @wechat_hits_24,      @wechat_uniq_24,
              @wechat_hits_24_pp,   @wechat_uniq_24_pp,
              @wiki_hits_24,        @wiki_uniq_24,
              @facebook_hits_24,    @facebook_uniq_24,
              @free_social_hits_24, @free_social_uniq_24,
              @piso_hits_15,        @piso_uniq_15,
              @school_hits_24,      @school_uniq_24,
              @coc_hits_24,         @coc_uniq_24,
              @youtube_hits_30,     @youtube_uniq_30);
   END WHILE;
   call sp_generate_pwrapp_sun_brand_stats (@tran_dt);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `powerapp_brand_boost_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_boost_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_boost_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_boost_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'SPEEDBOOST') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'SPEEDBOOST') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'SPEEDBOOST') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_chat_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_chat_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_chat_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_chat_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'CHAT') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'CHAT') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'CHAT') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_daily_hits_optout`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_daily_hits_optout`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_daily_hits_optout`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_daily_hits_optout` AS select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,sum(`powerapp_brand_dailyrep`.`hits_pre`) AS `hits_pre`,sum(`powerapp_brand_dailyrep`.`hits_tnt`) AS `hits_tnt`,sum(`powerapp_brand_dailyrep`.`hits_ppd`) AS `hits_ppd`,sum(`powerapp_brand_dailyrep`.`hits_tot`) AS `hits_tot`,0 AS `optout_pre`,0 AS `optout_tnt`,0 AS `optout_ppd`,0 AS `optout_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` <> 'OPTOUT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `hits_pre`,0 AS `hits_tnt`,0 AS `hits_ppd`,0 AS `hits_tot`,`powerapp_brand_dailyrep`.`hits_pre` AS `optout_pre`,`powerapp_brand_dailyrep`.`hits_tnt` AS `optout_tnt`,`powerapp_brand_dailyrep`.`hits_ppd` AS `optout_ppd`,`powerapp_brand_dailyrep`.`hits_tot` AS `optout_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'OPTOUT') group by `powerapp_brand_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_daily_hits_optout_summary`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_daily_hits_optout_summary`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_daily_hits_optout_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_daily_hits_optout_summary` AS select `powerapp_brand_daily_hits_optout`.`tran_dt` AS `tran_dt`,sum(`powerapp_brand_daily_hits_optout`.`hits_pre`) AS `hits_pre`,sum(`powerapp_brand_daily_hits_optout`.`hits_tnt`) AS `hits_tnt`,sum(`powerapp_brand_daily_hits_optout`.`hits_ppd`) AS `hits_ppd`,sum(`powerapp_brand_daily_hits_optout`.`hits_tot`) AS `hits_tot`,sum(`powerapp_brand_daily_hits_optout`.`optout_pre`) AS `optout_pre`,sum(`powerapp_brand_daily_hits_optout`.`optout_tnt`) AS `optout_tnt`,sum(`powerapp_brand_daily_hits_optout`.`optout_ppd`) AS `optout_ppd`,sum(`powerapp_brand_daily_hits_optout`.`optout_tot`) AS `optout_tot` from `powerapp_brand_daily_hits_optout` group by `powerapp_brand_daily_hits_optout`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_dailyhits` AS select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_dailyrep`.`hits_pre` AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'UNLI') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'EMAIL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'CHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PHOTO') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SPEEDBOOST') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'LINE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SNAPCHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'TUMBLR') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WAZE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WECHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FACEBOOK') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WIKIPEDIA') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FREE_SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PISONET') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'BACKTOSCHOOL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,`powerapp_brand_dailyrep`.`hits_pre` AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'UNLI') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,`powerapp_brand_dailyrep`.`hits_tnt` AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'EMAIL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,`powerapp_brand_dailyrep`.`hits_tnt` AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'CHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,`powerapp_brand_dailyrep`.`hits_tnt` AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PHOTO') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,`powerapp_brand_dailyrep`.`hits_tnt` AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,`powerapp_brand_dailyrep`.`hits_tnt` AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SPEEDBOOST') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,`powerapp_brand_dailyrep`.`hits_tnt` AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'LINE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,`powerapp_brand_dailyrep`.`hits_tnt` AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SNAPCHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,`powerapp_brand_dailyrep`.`hits_tnt` AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'TUMBLR') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,`powerapp_brand_dailyrep`.`hits_tnt` AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WAZE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,`powerapp_brand_dailyrep`.`hits_tnt` AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WECHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,`powerapp_brand_dailyrep`.`hits_tnt` AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FACEBOOK') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,`powerapp_brand_dailyrep`.`hits_tnt` AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WIKIPEDIA') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,`powerapp_brand_dailyrep`.`hits_tnt` AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FREE_SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,`powerapp_brand_dailyrep`.`hits_tnt` AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PISONET') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,`powerapp_brand_dailyrep`.`hits_tnt` AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'BACKTOSCHOOL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,`powerapp_brand_dailyrep`.`hits_ppd` AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'UNLI') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,`powerapp_brand_dailyrep`.`hits_ppd` AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'EMAIL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,`powerapp_brand_dailyrep`.`hits_ppd` AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'CHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,`powerapp_brand_dailyrep`.`hits_ppd` AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PHOTO') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,`powerapp_brand_dailyrep`.`hits_ppd` AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,`powerapp_brand_dailyrep`.`hits_ppd` AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SPEEDBOOST') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,`powerapp_brand_dailyrep`.`hits_ppd` AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'LINE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,`powerapp_brand_dailyrep`.`hits_ppd` AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SNAPCHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,`powerapp_brand_dailyrep`.`hits_ppd` AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'TUMBLR') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,`powerapp_brand_dailyrep`.`hits_ppd` AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WAZE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,`powerapp_brand_dailyrep`.`hits_ppd` AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WECHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,`powerapp_brand_dailyrep`.`hits_ppd` AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FACEBOOK') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,`powerapp_brand_dailyrep`.`hits_ppd` AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WIKIPEDIA') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,`powerapp_brand_dailyrep`.`hits_ppd` AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FREE_SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,`powerapp_brand_dailyrep`.`hits_ppd` AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PISONET') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,`powerapp_brand_dailyrep`.`hits_ppd` AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'BACKTOSCHOOL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,`powerapp_brand_dailyrep`.`hits_tot` AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'UNLI') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,`powerapp_brand_dailyrep`.`hits_tot` AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'EMAIL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,`powerapp_brand_dailyrep`.`hits_tot` AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'CHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,`powerapp_brand_dailyrep`.`hits_tot` AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PHOTO') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,`powerapp_brand_dailyrep`.`hits_tot` AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,`powerapp_brand_dailyrep`.`hits_tot` AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SPEEDBOOST') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,`powerapp_brand_dailyrep`.`hits_tot` AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'LINE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,`powerapp_brand_dailyrep`.`hits_tot` AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SNAPCHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,`powerapp_brand_dailyrep`.`hits_tot` AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'TUMBLR') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,`powerapp_brand_dailyrep`.`hits_tot` AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WAZE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,`powerapp_brand_dailyrep`.`hits_tot` AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WECHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,`powerapp_brand_dailyrep`.`hits_tot` AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FACEBOOK') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,`powerapp_brand_dailyrep`.`hits_tot` AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WIKIPEDIA') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,`powerapp_brand_dailyrep`.`hits_tot` AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FREE_SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,`powerapp_brand_dailyrep`.`hits_tot` AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PISONET') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,`powerapp_brand_dailyrep`.`hits_tot` AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'BACKTOSCHOOL') group by `powerapp_brand_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_dailyhits_summary`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_dailyhits_summary`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_dailyhits_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_dailyhits_summary` AS select `powerapp_brand_dailyhits`.`tran_dt` AS `tran_dt`,sum(`powerapp_brand_dailyhits`.`unli_pre`) AS `unli_pre`,sum(`powerapp_brand_dailyhits`.`email_pre`) AS `email_pre`,sum(`powerapp_brand_dailyhits`.`chat_pre`) AS `chat_pre`,sum(`powerapp_brand_dailyhits`.`photo_pre`) AS `photo_pre`,sum(`powerapp_brand_dailyhits`.`social_pre`) AS `social_pre`,sum(`powerapp_brand_dailyhits`.`speed_pre`) AS `speed_pre`,sum(`powerapp_brand_dailyhits`.`line_pre`) AS `line_pre`,sum(`powerapp_brand_dailyhits`.`snapchat_pre`) AS `snapchat_pre`,sum(`powerapp_brand_dailyhits`.`tumblr_pre`) AS `tumblr_pre`,sum(`powerapp_brand_dailyhits`.`waze_pre`) AS `waze_pre`,sum(`powerapp_brand_dailyhits`.`wechat_pre`) AS `wechat_pre`,sum(`powerapp_brand_dailyhits`.`facebook_pre`) AS `facebook_pre`,sum(`powerapp_brand_dailyhits`.`wiki_pre`) AS `wiki_pre`,sum(`powerapp_brand_dailyhits`.`free_social_pre`) AS `free_social_pre`,sum(`powerapp_brand_dailyhits`.`pisonet_pre`) AS `pisonet_pre`,sum(`powerapp_brand_dailyhits`.`school_pre`) AS `school_pre`,sum(`powerapp_brand_dailyhits`.`unli_tnt`) AS `unli_tnt`,sum(`powerapp_brand_dailyhits`.`email_tnt`) AS `email_tnt`,sum(`powerapp_brand_dailyhits`.`chat_tnt`) AS `chat_tnt`,sum(`powerapp_brand_dailyhits`.`photo_tnt`) AS `photo_tnt`,sum(`powerapp_brand_dailyhits`.`social_tnt`) AS `social_tnt`,sum(`powerapp_brand_dailyhits`.`speed_tnt`) AS `speed_tnt`,sum(`powerapp_brand_dailyhits`.`line_tnt`) AS `line_tnt`,sum(`powerapp_brand_dailyhits`.`snapchat_tnt`) AS `snapchat_tnt`,sum(`powerapp_brand_dailyhits`.`tumblr_tnt`) AS `tumblr_tnt`,sum(`powerapp_brand_dailyhits`.`waze_tnt`) AS `waze_tnt`,sum(`powerapp_brand_dailyhits`.`wechat_tnt`) AS `wechat_tnt`,sum(`powerapp_brand_dailyhits`.`facebook_tnt`) AS `facebook_tnt`,sum(`powerapp_brand_dailyhits`.`wiki_tnt`) AS `wiki_tnt`,sum(`powerapp_brand_dailyhits`.`free_social_tnt`) AS `free_social_tnt`,sum(`powerapp_brand_dailyhits`.`pisonet_tnt`) AS `pisonet_tnt`,sum(`powerapp_brand_dailyhits`.`school_tnt`) AS `school_tnt`,sum(`powerapp_brand_dailyhits`.`unli_ppd`) AS `unli_ppd`,sum(`powerapp_brand_dailyhits`.`email_ppd`) AS `email_ppd`,sum(`powerapp_brand_dailyhits`.`chat_ppd`) AS `chat_ppd`,sum(`powerapp_brand_dailyhits`.`photo_ppd`) AS `photo_ppd`,sum(`powerapp_brand_dailyhits`.`social_ppd`) AS `social_ppd`,sum(`powerapp_brand_dailyhits`.`speed_ppd`) AS `speed_ppd`,sum(`powerapp_brand_dailyhits`.`line_ppd`) AS `line_ppd`,sum(`powerapp_brand_dailyhits`.`snapchat_ppd`) AS `snapchat_ppd`,sum(`powerapp_brand_dailyhits`.`tumblr_ppd`) AS `tumblr_ppd`,sum(`powerapp_brand_dailyhits`.`waze_ppd`) AS `waze_ppd`,sum(`powerapp_brand_dailyhits`.`wechat_ppd`) AS `wechat_ppd`,sum(`powerapp_brand_dailyhits`.`facebook_ppd`) AS `facebook_ppd`,sum(`powerapp_brand_dailyhits`.`wiki_ppd`) AS `wiki_ppd`,sum(`powerapp_brand_dailyhits`.`free_social_ppd`) AS `free_social_ppd`,sum(`powerapp_brand_dailyhits`.`pisonet_ppd`) AS `pisonet_ppd`,sum(`powerapp_brand_dailyhits`.`school_ppd`) AS `school_ppd`,sum(`powerapp_brand_dailyhits`.`unli_tot`) AS `unli_tot`,sum(`powerapp_brand_dailyhits`.`email_tot`) AS `email_tot`,sum(`powerapp_brand_dailyhits`.`chat_tot`) AS `chat_tot`,sum(`powerapp_brand_dailyhits`.`photo_tot`) AS `photo_tot`,sum(`powerapp_brand_dailyhits`.`social_tot`) AS `social_tot`,sum(`powerapp_brand_dailyhits`.`speed_tot`) AS `speed_tot`,sum(`powerapp_brand_dailyhits`.`line_tot`) AS `line_tot`,sum(`powerapp_brand_dailyhits`.`snapchat_tot`) AS `snapchat_tot`,sum(`powerapp_brand_dailyhits`.`tumblr_tot`) AS `tumblr_tot`,sum(`powerapp_brand_dailyhits`.`waze_tot`) AS `waze_tot`,sum(`powerapp_brand_dailyhits`.`wechat_tot`) AS `wechat_tot`,sum(`powerapp_brand_dailyhits`.`facebook_tot`) AS `facebook_tot`,sum(`powerapp_brand_dailyhits`.`wiki_tot`) AS `wiki_tot`,sum(`powerapp_brand_dailyhits`.`free_social_tot`) AS `free_social_tot`,sum(`powerapp_brand_dailyhits`.`pisonet_tot`) AS `pisonet_tot`,sum(`powerapp_brand_dailyhits`.`school_tot`) AS `school_tot` from `powerapp_brand_dailyhits` group by `powerapp_brand_dailyhits`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_dailyuniq`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_dailyuniq`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_dailyuniq`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_dailyuniq` AS select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_dailyrep`.`uniq_pre` AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'UNLI') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'EMAIL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'CHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PHOTO') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SPEEDBOOST') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'LINE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SNAPCHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'TUMBLR') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WAZE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WECHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FACEBOOK') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WIKIPEDIA') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FREE_SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PISONET') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'BACKTOSCHOOL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,`powerapp_brand_dailyrep`.`uniq_pre` AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'UNLI') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,`powerapp_brand_dailyrep`.`uniq_tnt` AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'EMAIL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,`powerapp_brand_dailyrep`.`uniq_tnt` AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'CHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,`powerapp_brand_dailyrep`.`uniq_tnt` AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PHOTO') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,`powerapp_brand_dailyrep`.`uniq_tnt` AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,`powerapp_brand_dailyrep`.`uniq_tnt` AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SPEEDBOOST') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,`powerapp_brand_dailyrep`.`uniq_tnt` AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'LINE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,`powerapp_brand_dailyrep`.`uniq_tnt` AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SNAPCHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,`powerapp_brand_dailyrep`.`uniq_tnt` AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'TUMBLR') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,`powerapp_brand_dailyrep`.`uniq_tnt` AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WAZE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,`powerapp_brand_dailyrep`.`uniq_tnt` AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WECHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,`powerapp_brand_dailyrep`.`uniq_tnt` AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FACEBOOK') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,`powerapp_brand_dailyrep`.`uniq_tnt` AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WIKIPEDIA') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,`powerapp_brand_dailyrep`.`uniq_tnt` AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FREE_SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,`powerapp_brand_dailyrep`.`uniq_tnt` AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PISONET') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,`powerapp_brand_dailyrep`.`uniq_tnt` AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'BACKTOSCHOOL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'UNLI') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'EMAIL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'CHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PHOTO') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SPEEDBOOST') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'LINE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SNAPCHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'TUMBLR') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WAZE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WECHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FACEBOOK') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WIKIPEDIA') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FREE_SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PISONET') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,`powerapp_brand_dailyrep`.`uniq_ppd` AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'BACKTOSCHOOL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,`powerapp_brand_dailyrep`.`uniq_tot` AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'UNLI') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,`powerapp_brand_dailyrep`.`uniq_tot` AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'EMAIL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,`powerapp_brand_dailyrep`.`uniq_tot` AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'CHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,`powerapp_brand_dailyrep`.`uniq_tot` AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PHOTO') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,`powerapp_brand_dailyrep`.`uniq_tot` AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,`powerapp_brand_dailyrep`.`uniq_tot` AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SPEEDBOOST') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,`powerapp_brand_dailyrep`.`uniq_tot` AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'LINE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,`powerapp_brand_dailyrep`.`uniq_tot` AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'SNAPCHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,`powerapp_brand_dailyrep`.`uniq_tot` AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'TUMBLR') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,`powerapp_brand_dailyrep`.`uniq_tot` AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WAZE') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,`powerapp_brand_dailyrep`.`uniq_tot` AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WECHAT') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,`powerapp_brand_dailyrep`.`uniq_tot` AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FACEBOOK') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,`powerapp_brand_dailyrep`.`uniq_tot` AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'WIKIPEDIA') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,`powerapp_brand_dailyrep`.`uniq_tot` AS `free_social_tot`,0 AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'FREE_SOCIAL') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,`powerapp_brand_dailyrep`.`uniq_tot` AS `pisonet_tot`,0 AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'PISONET') group by `powerapp_brand_dailyrep`.`tran_dt` union select `powerapp_brand_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `unli_pre`,0 AS `email_pre`,0 AS `chat_pre`,0 AS `photo_pre`,0 AS `social_pre`,0 AS `speed_pre`,0 AS `line_pre`,0 AS `snapchat_pre`,0 AS `tumblr_pre`,0 AS `waze_pre`,0 AS `wechat_pre`,0 AS `facebook_pre`,0 AS `wiki_pre`,0 AS `free_social_pre`,0 AS `pisonet_pre`,0 AS `school_pre`,0 AS `unli_tnt`,0 AS `email_tnt`,0 AS `chat_tnt`,0 AS `photo_tnt`,0 AS `social_tnt`,0 AS `speed_tnt`,0 AS `line_tnt`,0 AS `snapchat_tnt`,0 AS `tumblr_tnt`,0 AS `waze_tnt`,0 AS `wechat_tnt`,0 AS `facebook_tnt`,0 AS `wiki_tnt`,0 AS `free_social_tnt`,0 AS `pisonet_tnt`,0 AS `school_tnt`,0 AS `unli_ppd`,0 AS `email_ppd`,0 AS `chat_ppd`,0 AS `photo_ppd`,0 AS `social_ppd`,0 AS `speed_ppd`,0 AS `line_ppd`,0 AS `snapchat_ppd`,0 AS `tumblr_ppd`,0 AS `waze_ppd`,0 AS `wechat_ppd`,0 AS `facebook_ppd`,0 AS `wiki_ppd`,0 AS `free_social_ppd`,0 AS `pisonet_ppd`,0 AS `school_ppd`,0 AS `unli_tot`,0 AS `email_tot`,0 AS `chat_tot`,0 AS `photo_tot`,0 AS `social_tot`,0 AS `speed_tot`,0 AS `line_tot`,0 AS `snapchat_tot`,0 AS `tumblr_tot`,0 AS `waze_tot`,0 AS `wechat_tot`,0 AS `facebook_tot`,0 AS `wiki_tot`,0 AS `free_social_tot`,0 AS `pisonet_tot`,`powerapp_brand_dailyrep`.`uniq_tot` AS `school_tot` from `powerapp_brand_dailyrep` where (`powerapp_brand_dailyrep`.`plan` = 'BACKTOSCHOOL') group by `powerapp_brand_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_dailyuniq_summary`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_dailyuniq_summary`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_dailyuniq_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_dailyuniq_summary` AS select `powerapp_brand_dailyuniq`.`tran_dt` AS `tran_dt`,sum(`powerapp_brand_dailyuniq`.`unli_pre`) AS `unli_pre`,sum(`powerapp_brand_dailyuniq`.`email_pre`) AS `email_pre`,sum(`powerapp_brand_dailyuniq`.`chat_pre`) AS `chat_pre`,sum(`powerapp_brand_dailyuniq`.`photo_pre`) AS `photo_pre`,sum(`powerapp_brand_dailyuniq`.`social_pre`) AS `social_pre`,sum(`powerapp_brand_dailyuniq`.`speed_pre`) AS `speed_pre`,sum(`powerapp_brand_dailyuniq`.`line_pre`) AS `line_pre`,sum(`powerapp_brand_dailyuniq`.`snapchat_pre`) AS `snapchat_pre`,sum(`powerapp_brand_dailyuniq`.`tumblr_pre`) AS `tumblr_pre`,sum(`powerapp_brand_dailyuniq`.`waze_pre`) AS `waze_pre`,sum(`powerapp_brand_dailyuniq`.`wechat_pre`) AS `wechat_pre`,sum(`powerapp_brand_dailyuniq`.`facebook_pre`) AS `facebook_pre`,sum(`powerapp_brand_dailyuniq`.`wiki_pre`) AS `wiki_pre`,sum(`powerapp_brand_dailyuniq`.`free_social_pre`) AS `free_social_pre`,sum(`powerapp_brand_dailyuniq`.`pisonet_pre`) AS `pisonet_pre`,sum(`powerapp_brand_dailyuniq`.`school_pre`) AS `school_pre`,sum(`powerapp_brand_dailyuniq`.`unli_tnt`) AS `unli_tnt`,sum(`powerapp_brand_dailyuniq`.`email_tnt`) AS `email_tnt`,sum(`powerapp_brand_dailyuniq`.`chat_tnt`) AS `chat_tnt`,sum(`powerapp_brand_dailyuniq`.`photo_tnt`) AS `photo_tnt`,sum(`powerapp_brand_dailyuniq`.`social_tnt`) AS `social_tnt`,sum(`powerapp_brand_dailyuniq`.`speed_tnt`) AS `speed_tnt`,sum(`powerapp_brand_dailyuniq`.`line_tnt`) AS `line_tnt`,sum(`powerapp_brand_dailyuniq`.`snapchat_tnt`) AS `snapchat_tnt`,sum(`powerapp_brand_dailyuniq`.`tumblr_tnt`) AS `tumblr_tnt`,sum(`powerapp_brand_dailyuniq`.`waze_tnt`) AS `waze_tnt`,sum(`powerapp_brand_dailyuniq`.`wechat_tnt`) AS `wechat_tnt`,sum(`powerapp_brand_dailyuniq`.`facebook_tnt`) AS `facebook_tnt`,sum(`powerapp_brand_dailyuniq`.`wiki_tnt`) AS `wiki_tnt`,sum(`powerapp_brand_dailyuniq`.`free_social_tnt`) AS `free_social_tnt`,sum(`powerapp_brand_dailyuniq`.`pisonet_tnt`) AS `pisonet_tnt`,sum(`powerapp_brand_dailyuniq`.`school_tnt`) AS `school_tnt`,sum(`powerapp_brand_dailyuniq`.`unli_ppd`) AS `unli_ppd`,sum(`powerapp_brand_dailyuniq`.`email_ppd`) AS `email_ppd`,sum(`powerapp_brand_dailyuniq`.`chat_ppd`) AS `chat_ppd`,sum(`powerapp_brand_dailyuniq`.`photo_ppd`) AS `photo_ppd`,sum(`powerapp_brand_dailyuniq`.`social_ppd`) AS `social_ppd`,sum(`powerapp_brand_dailyuniq`.`speed_ppd`) AS `speed_ppd`,sum(`powerapp_brand_dailyuniq`.`line_ppd`) AS `line_ppd`,sum(`powerapp_brand_dailyuniq`.`snapchat_ppd`) AS `snapchat_ppd`,sum(`powerapp_brand_dailyuniq`.`tumblr_ppd`) AS `tumblr_ppd`,sum(`powerapp_brand_dailyuniq`.`waze_ppd`) AS `waze_ppd`,sum(`powerapp_brand_dailyuniq`.`wechat_ppd`) AS `wechat_ppd`,sum(`powerapp_brand_dailyuniq`.`facebook_ppd`) AS `facebook_ppd`,sum(`powerapp_brand_dailyuniq`.`wiki_ppd`) AS `wiki_ppd`,sum(`powerapp_brand_dailyuniq`.`free_social_ppd`) AS `free_social_ppd`,sum(`powerapp_brand_dailyuniq`.`pisonet_ppd`) AS `pisonet_ppd`,sum(`powerapp_brand_dailyuniq`.`school_ppd`) AS `school_ppd`,sum(`powerapp_brand_dailyuniq`.`unli_tot`) AS `unli_tot`,sum(`powerapp_brand_dailyuniq`.`email_tot`) AS `email_tot`,sum(`powerapp_brand_dailyuniq`.`chat_tot`) AS `chat_tot`,sum(`powerapp_brand_dailyuniq`.`photo_tot`) AS `photo_tot`,sum(`powerapp_brand_dailyuniq`.`social_tot`) AS `social_tot`,sum(`powerapp_brand_dailyuniq`.`speed_tot`) AS `speed_tot`,sum(`powerapp_brand_dailyuniq`.`line_tot`) AS `line_tot`,sum(`powerapp_brand_dailyuniq`.`snapchat_tot`) AS `snapchat_tot`,sum(`powerapp_brand_dailyuniq`.`tumblr_tot`) AS `tumblr_tot`,sum(`powerapp_brand_dailyuniq`.`waze_tot`) AS `waze_tot`,sum(`powerapp_brand_dailyuniq`.`wechat_tot`) AS `wechat_tot`,sum(`powerapp_brand_dailyuniq`.`facebook_tot`) AS `facebook_tot`,sum(`powerapp_brand_dailyuniq`.`wiki_tot`) AS `wiki_tot`,sum(`powerapp_brand_dailyuniq`.`free_social_tot`) AS `free_social_tot`,sum(`powerapp_brand_dailyuniq`.`pisonet_tot`) AS `pisonet_tot`,sum(`powerapp_brand_dailyuniq`.`school_tot`) AS `school_tot` from `powerapp_brand_dailyuniq` group by `powerapp_brand_dailyuniq`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_email_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_email_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_email_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_email_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'EMAIL') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'EMAIL') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'EMAIL') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_facebook_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_facebook_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_facebook_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_facebook_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'FACEBOOK') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'FACEBOOK') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'FACEBOOK') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_free_social_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_free_social_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_free_social_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_free_social_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'FREE_SOCIAL') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'FREE_SOCIAL') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'FREE_SOCIAL') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_line_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_line_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_line_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_line_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'LINE') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'LINE') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'LINE') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_photo_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_photo_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_photo_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_photo_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'PHOTO') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'PHOTO') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'PHOTO') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_pisonet_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_pisonet_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_pisonet_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_pisonet_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'PISONET') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'PISONET') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'PISONET') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_school_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_school_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_school_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_school_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'BACKTOSCHOOL') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'BACKTOSCHOOL') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'BACKTOSCHOOL') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_snapchat_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_snapchat_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_snapchat_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_snapchat_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'SNAPCHAT') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'SNAPCHAT') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'SNAPCHAT') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_social_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_social_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_social_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_social_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'SOCIAL') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'SOCIAL') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'SOCIAL') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_tumblr_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_tumblr_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_tumblr_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_tumblr_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'TUMBLR') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'TUMBLR') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'TUMBLR') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_unli_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_unli_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_unli_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_unli_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'UNLI') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'UNLI') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'UNLI') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_waze_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_waze_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_waze_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_waze_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'WAZE') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'WAZE') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'WAZE') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_wechat_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_wechat_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_wechat_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_wechat_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'WECHAT') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'WECHAT') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'WECHAT') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_brand_wiki_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_brand_wiki_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_brand_wiki_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_brand_wiki_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'WIKIPEDIA') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'WIKIPEDIA') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'WIKIPEDIA') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_line_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_line_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_line_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_line_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'LINE') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'LINE') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'LINE') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_snapchat_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_snapchat_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_snapchat_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_snapchat_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'SNAPCHAT') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'SNAPCHAT') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'SNAPCHAT') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_tumblr_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_tumblr_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_tumblr_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_tumblr_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'TUMBLR') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'TUMBLR') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'TUMBLR') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_waze_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_waze_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_waze_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_waze_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'WAZE') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'WAZE') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'WAZE') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_wechat_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_wechat_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_wechat_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_wechat_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'WECHAT') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'WECHAT') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'WECHAT') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `powerapp_wiki_dailyhits`
--

/*!50001 DROP TABLE IF EXISTS `powerapp_wiki_dailyhits`*/;
/*!50001 DROP VIEW IF EXISTS `powerapp_wiki_dailyhits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `powerapp_wiki_dailyhits` AS select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_3_pre`,0 AS `plan_24_pre`,0 AS `plan_tot_pre`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_3_tnt`,0 AS `plan_24_tnt`,0 AS `plan_tot_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_3_ppd`,0 AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'WIKIPEDIA') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '3H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,`powerapp_brand_expiry_dailyrep`.`hits_pre` AS `plan_24_pre`,0 AS `plan_tot_pre`,0 AS `plan_3_tnt`,`powerapp_brand_expiry_dailyrep`.`hits_tnt` AS `plan_24_tnt`,0 AS `plan_tot_tnt`,0 AS `plan_3_ppd`,`powerapp_brand_expiry_dailyrep`.`hits_ppd` AS `plan_24_ppd`,0 AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where ((`powerapp_brand_expiry_dailyrep`.`plan` = 'WIKIPEDIA') and (`powerapp_brand_expiry_dailyrep`.`plan_exp` = '24H')) group by `powerapp_brand_expiry_dailyrep`.`tran_dt` union select `powerapp_brand_expiry_dailyrep`.`tran_dt` AS `tran_dt`,0 AS `plan_3_pre`,0 AS `plan_24_pre`,sum(`powerapp_brand_expiry_dailyrep`.`hits_pre`) AS `plan_tot_pre`,0 AS `plan_3_tnt`,0 AS `plan_24_tnt`,sum(`powerapp_brand_expiry_dailyrep`.`hits_tnt`) AS `plan_tot_tnt`,0 AS `plan_3_ppd`,0 AS `plan_24_ppd`,sum(`powerapp_brand_expiry_dailyrep`.`hits_ppd`) AS `plan_tot_ppd` from `powerapp_brand_expiry_dailyrep` where (`powerapp_brand_expiry_dailyrep`.`plan` = 'WIKIPEDIA') group by `powerapp_brand_expiry_dailyrep`.`tran_dt` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-09-10 15:00:15
