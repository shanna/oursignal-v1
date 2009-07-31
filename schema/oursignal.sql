-- MySQL dump 10.11
--
-- Host: localhost    Database: oursignal
-- ------------------------------------------------------
-- Server version	5.0.51a-24+lenny1

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
-- Table structure for table `feed_links`
--

DROP TABLE IF EXISTS `feed_links`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `feed_links` (
  `link_id` varchar(40) NOT NULL,
  `feed_id` varchar(40) NOT NULL,
  PRIMARY KEY  (`link_id`,`feed_id`),
  KEY `feed_links_feed_fk` (`feed_id`),
  CONSTRAINT `feed_links_feed_fk` FOREIGN KEY (`feed_id`) REFERENCES `feeds` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `feed_links_link_fk` FOREIGN KEY (`link_id`) REFERENCES `links` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `feeds`
--

DROP TABLE IF EXISTS `feeds`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `feeds` (
  `id` varchar(40) NOT NULL,
  `title` varchar(255) default NULL,
  `url` varchar(255) NOT NULL,
  `etag` varchar(255) default NULL,
  `last_modified` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `links`
--

DROP TABLE IF EXISTS `links`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `links` (
  `id` varchar(40) NOT NULL,
  `url` varchar(255) NOT NULL,
  `title` varchar(255) default NULL,
  `score` float default NULL,
  `score_at` datetime default NULL,
  `velocity` float default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `scores`
--

DROP TABLE IF EXISTS `scores`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `scores` (
  `id` varchar(40) NOT NULL,
  `source` varchar(50) NOT NULL,
  `url` varchar(255) NOT NULL,
  `score` float default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `user_feeds`
--

DROP TABLE IF EXISTS `user_feeds`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `user_feeds` (
  `user_id` int(11) NOT NULL,
  `feed_id` varchar(40) NOT NULL,
  `score` float default '0',
  PRIMARY KEY  (`user_id`,`feed_id`),
  KEY `user_feeds_feed_fk` (`feed_id`),
  CONSTRAINT `user_feeds_feed_fk` FOREIGN KEY (`feed_id`) REFERENCES `feeds` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `user_feeds_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `fullname` varchar(50) default NULL,
  `username` varchar(50) default NULL,
  `password` varchar(50) default NULL,
  `email` varchar(50) default NULL,
  `openid` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-07-31  0:53:13
