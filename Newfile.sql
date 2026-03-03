-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: rtx_toolkit
-- ------------------------------------------------------
-- Server version       8.0.45-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;                /*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;           /*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activation_requests`
--

DROP TABLE IF EXISTS `activation_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activation_requests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `requested_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `processed_at` datetime DEFAULT NULL,
  `processed_by` bigint DEFAULT NULL,
  `notification_message_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_activation_user` (`user_id`),
  CONSTRAINT `fk_activation_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activation_requests`
--

LOCK TABLES `activation_requests` WRITE;
/*!40000 ALTER TABLE `activation_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `activation_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_superadmin` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `last_login` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Admin panel user model for Tortoise ORM.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_users`
--

LOCK TABLES `admin_users` WRITE;
/*!40000 ALTER TABLE `admin_users` DISABLE KEYS */;
INSERT INTO `admin_users` VALUES (1,'admin','$2b$12$Y0E8faA92X8jTZOIfJ354uDWx42RpoKJo212VYDbNmt9kbZuP11ny',1,1,'2026-02-16 05:16:36.655093',NULL);
/*!40000 ALTER TABLE `admin_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aerich`
--

DROP TABLE IF EXISTS `aerich`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aerich` (
  `id` int NOT NULL AUTO_INCREMENT,
  `version` varchar(255) NOT NULL,
  `app` varchar(100) NOT NULL,
  `content` json NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aerich`
--

LOCK TABLES `aerich` WRITE;
/*!40000 ALTER TABLE `aerich` DISABLE KEYS */;
/*!40000 ALTER TABLE `aerich` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bot_settings`
--

DROP TABLE IF EXISTS `bot_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bot_settings` (
  `setting_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `setting_value` text COLLATE utf8mb4_unicode_ci,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` bigint DEFAULT NULL,
  PRIMARY KEY (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bot_settings`
--

LOCK TABLES `bot_settings` WRITE;
/*!40000 ALTER TABLE `bot_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `bot_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `broadcasts`
--

DROP TABLE IF EXISTS `broadcasts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `broadcasts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `message` longtext NOT NULL,
  `sent_by` int DEFAULT NULL,
  `sent_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `recipients_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Broadcast message model for Tortoise ORM.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `broadcasts`
--

LOCK TABLES `broadcasts` WRITE;
/*!40000 ALTER TABLE `broadcasts` DISABLE KEYS */;
/*!40000 ALTER TABLE `broadcasts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_transactions`
--

DROP TABLE IF EXISTS `payment_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `plan_id` int NOT NULL,
  `amount_usd` decimal(10,2) NOT NULL,
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USD',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `payment_method` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'cryptomus',
  `cryptomus_order_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cryptomus_payment_url` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` datetime DEFAULT NULL,
  `binance_order_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_txn_user` (`user_id`),
  KEY `fk_txn_plan` (`plan_id`),
  CONSTRAINT `fk_txn_plan` FOREIGN KEY (`plan_id`) REFERENCES `vip_plans` (`id`),
  CONSTRAINT `fk_txn_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_transactions`
--

LOCK TABLES `payment_transactions` WRITE;
/*!40000 ALTER TABLE `payment_transactions` DISABLE KEYS */;
INSERT INTO `payment_transactions` VALUES (1,7064927643,1,20.00,'USD','pending','cryptomus','vip_7064927643_1_1768494965',NULL,'2026-01-15 17:36:05',NULL,NULL),(2,8230802588,1,20.00,'USD','pending','cryptomus','vip_8230802588_1_1768496277',NULL,'2026-01-15 17:57:58',NULL,NULL),(3,6812561065,1,20.00,'USD','pending','cryptomus','vip_6812561065_1_1768496490',NULL,'2026-01-15 18:01:31',NULL,NULL),(4,6812561065,1,20.00,'USD','pending','cryptomus','vip_6812561065_1_1768497543',NULL,'2026-01-15 18:19:04',NULL,NULL),(5,6812561065,1,20.00,'USD','pending','cryptomus','vip_6812561065_1_1768497554',NULL,'2026-01-15 18:19:15',NULL,NULL),(6,6812561065,1,20.00,'USD','pending','cryptomus','vip_6812561065_1_1768497613',NULL,'2026-01-15 18:20:14',NULL,NULL),(7,6812561065,1,20.00,'USD','pending','cryptomus','vip_6812561065_1_1768497785',NULL,'2026-01-15 18:23:06',NULL,NULL),(8,6611340594,1,20.00,'USD','pending','cryptomus','vip_6611340594_1_1768545655',NULL,'2026-01-16 07:40:55',NULL,NULL),(9,6611340594,1,20.00,'USD','pending','cryptomus','vip_6611340594_1_1768545709',NULL,'2026-01-16 07:41:49',NULL,NULL),(10,6611340594,1,20.00,'USD','pending','cryptomus','vip_6611340594_1_1768545761',NULL,'2026-01-16 07:42:42',NULL,NULL),(11,5320937571,1,20.00,'USD','pending','cryptomus','vip_5320937571_1_1768546853',NULL,'2026-01-16 08:00:53',NULL,NULL),(12,5320937571,1,20.00,'USD','pending','cryptomus','vip_5320937571_1_1768546945',NULL,'2026-01-16 08:02:25',NULL,NULL),(13,6528424959,1,20.00,'USD','pending','cryptomus','vip_6528424959_1_1768551962',NULL,'2026-01-16 09:26:03',NULL,NULL),(14,6528424959,1,20.00,'USD','pending','cryptomus','vip_6528424959_1_1768552247',NULL,'2026-01-16 09:30:48',NULL,NULL),(15,7075102928,1,20.00,'USD','pending','cryptomus','vip_7075102928_1_1768590639',NULL,'2026-01-16 20:10:40',NULL,NULL),(16,6989800182,2,55.00,'USD','pending','cryptomus','vip_6989800182_2_1768638563',NULL,'2026-01-17 09:29:24',NULL,NULL),(17,5817719715,1,20.00,'USD','pending','cryptomus','vip_5817719715_1_1768670534',NULL,'2026-01-17 18:22:15',NULL,NULL),(18,6014302016,1,20.00,'USD','pending','cryptomus','vip_6014302016_1_1768672248',NULL,'2026-01-17 18:50:48',NULL,NULL),(19,6014302016,1,20.00,'USD','pending','cryptomus','vip_6014302016_1_1768672363',NULL,'2026-01-17 18:52:44',NULL,NULL),(20,8298192242,1,20.00,'USD','pending','cryptomus','vip_8298192242_1_1768759634',NULL,'2026-01-18 19:07:15',NULL,NULL),(21,7433138762,1,20.00,'USD','pending','cryptomus','vip_7433138762_1_1769018594',NULL,'2026-01-21 19:03:15',NULL,NULL),(22,8140681214,1,20.00,'USD','pending','cryptomus','vip_8140681214_1_1769451726',NULL,'2026-01-26 19:22:07',NULL,NULL),(23,8140681214,1,20.00,'USD','pending','cryptomus','vip_8140681214_1_1769451856',NULL,'2026-01-26 19:24:16',NULL,NULL),(24,8140681214,1,20.00,'USD','pending','cryptomus','vip_8140681214_1_1769452023',NULL,'2026-01-26 19:27:04',NULL,NULL),(25,8140681214,1,20.00,'USD','pending','cryptomus','vip_8140681214_1_1769452104',NULL,'2026-01-26 19:28:25',NULL,NULL),(26,8140681214,1,20.00,'USD','pending','cryptomus','vip_8140681214_1_1769460554',NULL,'2026-01-26 21:49:14',NULL,NULL),(27,6099500455,1,20.00,'USD','pending','cryptomus','vip_6099500455_1_1769882509',NULL,'2026-01-31 19:01:49',NULL,NULL),(28,8140681214,1,20.00,'USD','pending','cryptomus','vip_8140681214_1_1771222984',NULL,'2026-02-16 06:23:05',NULL,NULL),(29,8140681214,1,20.00,'USD','pending','cryptomus','vip_8140681214_1_1771223177',NULL,'2026-02-16 06:26:18',NULL,NULL),(30,7283429202,1,20.00,'USD','pending','cryptomus','vip_7283429202_1_1771224648',NULL,'2026-02-16 06:50:48',NULL,NULL),(31,6812561065,1,20.00,'USD','pending','cryptomus','vip_6812561065_1_1771238374',NULL,'2026-02-16 10:39:34',NULL,NULL),(32,6812561065,1,20.00,'USD','pending','cryptomus','vip_6812561065_1_1771251749',NULL,'2026-02-16 14:22:29',NULL,NULL),(33,8298192242,1,20.00,'USD','pending','cryptomus','vip_8298192242_1_1771684090',NULL,'2026-02-21 14:28:11',NULL,NULL),(34,8404630419,1,20.00,'USD','pending','cryptomus','vip_8404630419_1_1771885213',NULL,'2026-02-23 22:20:13',NULL,NULL),(35,6613112749,1,20.00,'USD','pending','cryptomus','vip_6613112749_1_1772084420',NULL,'2026-02-26 05:40:21',NULL,NULL);
/*!40000 ALTER TABLE `payment_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_bots`
--

DROP TABLE IF EXISTS `user_bots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_bots` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `bot_username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_user_bots_user` (`user_id`),
  CONSTRAINT `fk_user_bots_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_bots`
--

LOCK TABLES `user_bots` WRITE;
/*!40000 ALTER TABLE `user_bots` DISABLE KEYS */;
INSERT INTO `user_bots` VALUES (1,8230802588,'zoomreceiverbot','2026-01-15 17:42:07'),(2,6528424959,'3525236234','2026-01-16 17:50:01'),(3,7178789818,'Lonami','2026-02-01 07:35:00');
/*!40000 ALTER TABLE `user_bots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_channels`
--

DROP TABLE IF EXISTS `user_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_channels` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `channel_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `channel_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_uchan_user` (`user_id`),
  CONSTRAINT `fk_uchan_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_channels`
--

LOCK TABLES `user_channels` WRITE;
/*!40000 ALTER TABLE `user_channels` DISABLE KEYS */;
INSERT INTO `user_channels` VALUES (1,7557962281,'RAYAN','-1002647763210','2026-01-15 16:27:02','2026-01-15 16:27:02'),(2,8230802588,'Zoom1','-1003484813666','2026-01-15 16:53:00','2026-01-15 16:53:00'),(4,7799618516,'At Claim','-1003125262045','2026-01-15 17:07:31','2026-01-15 17:07:31'),(6,6812561065,'Rob1','-1002966741020','2026-01-16 03:20:22','2026-01-16 03:20:22'),(7,6014302016,'Infoclime','-1002318346229','2026-01-17 18:02:05','2026-01-17 18:02:05'),(8,7799618516,'Beta claim','-1002294428485','2026-01-20 17:15:40','2026-01-20 17:15:40'),(11,8140681214,'Claim Session TH 5','-1003239784874','2026-01-27 06:55:01','2026-01-27 06:55:01'),(12,7799618516,'Fly Claim','-1003211823645','2026-01-28 18:14:28','2026-01-28 18:14:28'),(13,5320937571,'First call','-1003676839588','2026-01-31 18:00:43','2026-01-31 18:00:43'),(14,7320647154,'claim','-1003320349928','2026-02-08 16:22:28','2026-02-08 16:22:28'),(16,8140681214,'0XTG Claim','-1003777801413','2026-02-16 15:05:41','2026-02-16 15:05:41'),(19,8140681214,'TH Claim','-1003784391173','2026-02-27 17:49:18','2026-02-27 17:49:18'),(20,1160642485,'RtxRobot1','-1002928302775','2026-03-03 11:30:22','2026-03-03 11:30:22');
/*!40000 ALTER TABLE `user_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_settings`
--

DROP TABLE IF EXISTS `user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_settings` (
  `user_id` bigint NOT NULL,
  `language_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en',
  `notifications_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `timezone` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'UTC',
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_user_settings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_settings`
--

LOCK TABLES `user_settings` WRITE;
/*!40000 ALTER TABLE `user_settings` DISABLE KEYS */;
INSERT INTO `user_settings` VALUES (196030695,'en',1,'UTC'),(445970290,'en',1,'UTC'),(1130829832,'en',1,'UTC'),(1160642485,'en',1,'UTC'),(1232168026,'en',1,'UTC'),(1307466331,'en',1,'UTC'),(1533727931,'en',1,'UTC'),(1979269681,'en',1,'UTC'),(2127213509,'en',1,'UTC'),(5090382040,'en',1,'UTC'),(5296907629,'en',1,'UTC'),(5320113209,'en',1,'UTC'),(5320937571,'en',1,'UTC'),(5325921873,'en',1,'UTC'),(5411501260,'en',1,'UTC'),(5432375205,'en',1,'UTC'),(5549360759,'en',1,'UTC'),(5663408994,'en',1,'UTC'),(5742872324,'en',1,'UTC'),(5817719715,'en',1,'UTC'),(5869701210,'en',1,'UTC'),(5887673898,'en',1,'UTC'),(5952348239,'en',1,'UTC'),(5973152544,'en',1,'UTC'),(5990186537,'en',1,'UTC'),(5990939079,'en',1,'UTC'),(5992322708,'en',1,'UTC'),(6014302016,'en',1,'UTC'),(6020785877,'en',1,'UTC'),(6071367060,'en',1,'UTC'),(6087546564,'en',1,'UTC'),(6099500455,'en',1,'UTC'),(6146454872,'en',1,'UTC'),(6160086558,'en',1,'UTC'),(6185438093,'en',1,'UTC'),(6216472354,'en',1,'UTC'),(6239464151,'en',1,'UTC'),(6268514494,'en',1,'UTC'),(6303632275,'en',1,'UTC'),(6323960445,'en',1,'UTC'),(6371333934,'en',1,'UTC'),(6377991248,'en',1,'UTC'),(6438950197,'en',1,'UTC'),(6447613525,'en',1,'UTC'),(6501952547,'en',1,'UTC'),(6510364276,'en',1,'UTC'),(6528424959,'en',1,'UTC'),(6557571212,'en',1,'UTC'),(6611340594,'en',1,'UTC'),(6613112749,'en',1,'UTC'),(6668478801,'en',1,'UTC'),(6702482966,'en',1,'UTC'),(6778195828,'en',1,'UTC'),(6812561065,'en',1,'UTC'),(6812901916,'en',1,'UTC'),(6844126402,'en',1,'UTC'),(6846367234,'en',1,'UTC'),(6854871116,'en',1,'UTC'),(6898007869,'en',1,'UTC'),(6908523976,'en',1,'UTC'),(6917073978,'en',1,'UTC'),(6931386172,'en',1,'UTC'),(6973343707,'en',1,'UTC'),(6989800182,'en',1,'UTC'),(6990029587,'en',1,'UTC'),(7044650981,'en',1,'UTC'),(7064927643,'en',1,'UTC'),(7075102928,'en',1,'UTC'),(7118136436,'en',1,'UTC'),(7171124653,'en',1,'UTC'),(7178789818,'en',1,'UTC'),(7188031604,'en',1,'UTC'),(7221681075,'en',1,'UTC'),(7278356910,'en',1,'UTC'),(7283429202,'en',1,'UTC'),(7319898345,'en',1,'UTC'),(7320647154,'en',1,'UTC'),(7355093885,'en',1,'UTC'),(7433138762,'en',1,'UTC'),(7434236398,'en',1,'UTC'),(7482167295,'en',1,'UTC'),(7489304905,'en',1,'UTC'),(7495468732,'en',1,'UTC'),(7505333004,'en',1,'UTC'),(7522996838,'en',1,'UTC'),(7529097385,'en',1,'UTC'),(7557962281,'en',1,'UTC'),(7570012385,'en',1,'UTC'),(7575920014,'en',1,'UTC'),(7580191280,'en',1,'UTC'),(7611971908,'en',1,'UTC'),(7624955121,'en',1,'UTC'),(7706681370,'en',1,'UTC'),(7799618516,'en',1,'UTC'),(7809329320,'en',1,'UTC'),(7884448729,'en',1,'UTC'),(7885477161,'en',1,'UTC'),(7885727380,'en',1,'UTC'),(7887512937,'en',1,'UTC'),(7891658307,'en',1,'UTC'),(7925979982,'en',1,'UTC'),(7945080401,'en',1,'UTC'),(7955392895,'en',1,'UTC'),(8001861526,'en',1,'UTC'),(8026768820,'en',1,'UTC'),(8056531791,'en',1,'UTC'),(8062583609,'en',1,'UTC'),(8088511882,'en',1,'UTC'),(8130627256,'en',1,'UTC'),(8140681214,'en',1,'UTC'),(8145933846,'en',1,'UTC'),(8147801886,'en',1,'UTC'),(8154162603,'en',1,'UTC'),(8170536188,'en',1,'UTC'),(8185760751,'en',1,'UTC'),(8199806539,'en',1,'UTC'),(8230802588,'en',1,'UTC'),(8286094675,'en',1,'UTC'),(8294605080,'en',1,'UTC'),(8298192242,'en',1,'UTC'),(8306909521,'en',1,'UTC'),(8404630419,'en',1,'UTC'),(8418788092,'en',1,'UTC'),(8458215944,'en',1,'UTC'),(8504293112,'en',1,'UTC'),(8505787296,'en',1,'UTC'),(8526459275,'en',1,'UTC'),(8534377062,'en',1,'UTC'),(8552289940,'en',1,'UTC'),(8564727311,'en',1,'UTC'),(8568533959,'en',1,'UTC'),(8588862082,'en',1,'UTC'),(8592489588,'en',1,'UTC');
/*!40000 ALTER TABLE `user_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_wd_channels`
--

DROP TABLE IF EXISTS `user_wd_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_wd_channels` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `channel_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `channel_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_uwdchan_user` (`user_id`),
  CONSTRAINT `fk_uwdchan_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_wd_channels`
--

LOCK TABLES `user_wd_channels` WRITE;
/*!40000 ALTER TABLE `user_wd_channels` DISABLE KEYS */;
INSERT INTO `user_wd_channels` VALUES (1,7557962281,'RAYAN','-1002631242300','2026-01-15 16:27:19','2026-01-15 16:27:19'),(2,8230802588,'Zoom1','-1003410727900','2026-01-15 16:53:38','2026-01-15 16:53:38'),(4,7799618516,'At Wd','-1003051753538','2026-01-15 17:09:48','2026-01-15 17:09:48'),(5,7799618516,'Beta Wd','-1002561327335','2026-01-15 17:11:12','2026-01-15 17:11:12'),(7,6014302016,'Withdraw','-1002333894569','2026-01-17 18:02:55','2026-01-17 18:02:55'),(11,8140681214,'TH 5 Withdraw','-1003436184261','2026-01-27 06:53:07','2026-01-27 06:53:07'),(12,7799618516,'Fly withdraw','-1002687730750','2026-01-28 18:13:39','2026-01-28 18:13:39'),(13,5320937571,'Withdrawal','-1003492094104','2026-01-31 18:02:52','2026-01-31 18:02:52'),(14,7320647154,'wdr','-1003189506085','2026-02-08 16:23:36','2026-02-08 16:23:36'),(15,6812561065,'WD1','-1003888501251','2026-02-11 06:28:10','2026-02-11 06:28:10'),(16,1160642485,'RtxRobot1','-1002990254850','2026-03-03 11:30:48','2026-03-03 11:30:48'),(17,1160642485,'RTX1','-1002990254850','2026-03-03 11:31:35','2026-03-03 11:31:35');
/*!40000 ALTER TABLE `user_wd_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` bigint NOT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_banned` tinyint(1) NOT NULL DEFAULT '0',
  `is_vip` tinyint(1) NOT NULL DEFAULT '0',
  `vip_expires_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_seen` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (196030695,'BAYJID_C71','𝙈𝘿','𝘽𝘼𝙔𝙅𝙄𝘿 拜德',1,0,0,NULL,'2026-02-02 18:35:51','2026-02-02 18:35:51','2026-02-02 18:35:51'),(445970290,'TG_80088','TG飞行会话',NULL,1,0,0,NULL,'2026-01-30 08:28:23','2026-01-30 08:28:23','2026-01-30 08:28:23'),(1130829832,'el_mad18','El',NULL,1,0,0,NULL,'2026-02-21 21:48:12','2026-02-21 21:49:00','2026-02-21 21:49:00'),(1160642485,'SSB67','𝗥𝗔𝗝 (拉杰)','𝗧𝗚/𝗪𝗦',1,0,1,'2026-03-30 17:45:51','2026-03-02 17:45:29','2026-03-03 16:11:11','2026-03-03 16:11:11'),(1232168026,NULL,'TAHA 🧃',NULL,1,0,0,NULL,'2026-02-27 18:57:00','2026-02-27 18:57:00','2026-02-27 18:57:00'),(1307466331,'nothingtg697','𝙽𝚘𝚝𝚑𝚒𝚗𝚐','⁶⁹⁷',1,0,0,NULL,'2026-01-18 03:39:52','2026-01-18 03:39:52','2026-01-18 03:39:52'),(1533727931,'creator_amerok_baloch','𝒂𝒎𝒆𝒓_𝒏𝒕𝒛',NULL,1,0,0,NULL,'2026-02-23 09:57:37','2026-02-24 13:46:23','2026-02-24 13:46:23'),(1979269681,NULL,'James','Mitchell',1,0,0,NULL,'2026-02-11 06:14:20','2026-02-11 06:14:20','2026-02-11 06:14:20'),(2127213509,'dahei8899','大黑（海贸机房WS/TG）上压公群5000U',NULL,1,0,0,NULL,'2026-02-04 09:10:01','2026-02-04 09:10:01','2026-02-04 09:10:01'),(5090382040,'hridoymini','赫里多伊— ͟͞͞ 𝘔𝘐𝘕𝘐',NULL,1,0,0,NULL,'2026-01-19 20:48:47','2026-01-19 20:48:47','2026-01-19 20:48:47'),(5296907629,'Antonii_jerry','Antonii','Jerry',1,0,0,NULL,'2026-02-03 17:23:18','2026-02-03 17:23:18','2026-02-03 17:23:18'),(5320113209,NULL,'弘','冷卉',1,0,0,NULL,'2026-02-27 21:34:42','2026-02-27 21:34:42','2026-02-27 21:34:42'),(5320937571,'Lamim_Boss','Lamim','WS/TG 批发移动房间',1,0,1,'2026-03-25 11:33:38','2026-01-16 07:00:41','2026-03-03 14:12:20','2026-03-03 14:12:20'),(5325921873,'Mr_trusted_buyer','购买TG账户',NULL,1,0,0,NULL,'2026-02-03 02:31:06','2026-02-17 07:11:18','2026-02-17 07:11:18'),(5411501260,NULL,'xu','Nick',1,0,0,NULL,'2026-02-03 01:51:12','2026-02-03 01:51:12','2026-02-03 01:51:12'),(5432375205,'Akshayisone','⛏ CROSS PLAY',NULL,1,0,0,NULL,'2026-01-27 04:56:05','2026-01-27 04:56:05','2026-01-27 04:56:05'),(5549360759,'jfuhdwog','413','z',1,0,0,NULL,'2026-02-20 20:47:11','2026-02-20 20:47:11','2026-02-20 20:47:11'),(5663408994,'uopli_pv','𝗘𝗹𝘆𝗮𝘀',NULL,1,0,0,NULL,'2026-02-27 14:13:25','2026-02-27 14:13:34','2026-02-27 14:13:34'),(5742872324,'bossteambd','𝐌𝐇𝐑 𝐑𝐎𝐁𝐄𝐋',NULL,1,0,0,NULL,'2026-02-27 18:17:39','2026-02-27 18:17:42','2026-02-27 18:17:42'),(5817719715,'Sanowar_hasan','𝗠𝗱 𝗦𝗮𝗻𝗼𝘄𝗮𝗿',NULL,1,0,1,'2026-02-16 18:25:06','2026-01-15 16:49:32','2026-01-15 16:49:32','2026-01-15 16:49:32'),(5869701210,NULL,'Rdx','Munna (TG/WS)',1,0,0,NULL,'2026-01-15 17:32:14','2026-02-21 18:21:31','2026-02-21 18:21:31'),(5887673898,'Antor_1','Antor',NULL,1,0,0,NULL,'2026-01-16 02:39:10','2026-02-28 13:37:21','2026-02-28 13:37:21'),(5952348239,'ACCJ88','ɴᴀꜰɪᴢ||买合',NULL,1,0,0,NULL,'2026-02-18 02:07:30','2026-02-18 02:08:33','2026-02-18 02:08:33'),(5973152544,'Aashiq01670','Aash',NULL,1,0,0,NULL,'2026-02-23 19:37:29','2026-02-23 19:37:33','2026-02-23 19:37:33'),(5990186537,'npnahidX','ɳαɦเ∂ ραɾѵεʝ','',1,0,0,NULL,'2026-02-23 19:53:49','2026-02-23 19:54:07','2026-02-23 19:54:07'),(5990939079,'RNrakibulBuyer','✼ ҉ 𝐑𝐍: 𝐑𝐚𝐤𝐢𝐛𝐮𝐥','{TG}',1,0,0,NULL,'2026-01-16 19:11:52','2026-01-16 19:11:52','2026-01-16 19:11:52'),(5992322708,'mastwahdyar','ꪑꪖ𝘴𝓽᭙ꪖꫝᦔγꪖ𝘳',NULL,1,0,0,NULL,'2026-01-31 16:45:05','2026-01-31 16:45:05','2026-01-31 16:45:05'),(6014302016,'mrpik345','Mr. Pik',NULL,1,0,1,'2026-02-16 18:56:06','2026-01-17 03:48:04','2026-02-19 06:20:32','2026-02-19 06:20:32'),(6020785877,'tcXY3','𝗙𝗮𝗿𝗵𝗮𝗻','𝗖𝗵𝗼𝘄𝗱𝗵𝘂𝗿𝘆',1,0,0,NULL,'2026-01-15 16:46:25','2026-01-15 16:46:25','2026-01-15 16:46:25'),(6071367060,'Siza4','زعيم',NULL,1,0,0,NULL,'2026-01-22 19:06:12','2026-01-22 19:06:12','2026-01-22 19:06:12'),(6087546564,'Lamim_ahmed87','ADMIN LAMIM',NULL,1,0,0,NULL,'2026-02-21 18:59:42','2026-02-24 05:26:53','2026-02-24 05:26:53'),(6099500455,'Hi_Payment_leader','Hi Payment Leader',NULL,1,0,0,NULL,'2026-01-15 16:45:00','2026-02-16 05:48:01','2026-02-16 05:48:01'),(6146454872,'Antor_5','Antor',NULL,1,0,0,NULL,'2026-01-19 07:31:34','2026-01-19 07:31:34','2026-01-19 07:31:34'),(6160086558,'Alaminvai143','Alamin','Prodhan',1,0,0,NULL,'2026-01-21 15:58:35','2026-01-21 15:58:35','2026-01-21 15:58:35'),(6185438093,'Bossbd2','محمد ران',NULL,1,0,0,NULL,'2026-01-17 08:32:12','2026-01-17 08:32:12','2026-01-17 08:32:12'),(6216472354,'Jakaria_SR','Shagor','Khan',1,0,0,NULL,'2026-01-18 19:18:54','2026-02-27 18:18:59','2026-02-27 18:18:59'),(6239464151,'MadRosholy','ʀᴏsʜᴀ',NULL,1,0,0,NULL,'2026-02-20 05:31:09','2026-02-20 05:31:09','2026-02-20 05:31:09'),(6268514494,NULL,'Talha','Chawdhury',1,0,0,NULL,'2026-02-08 17:16:39','2026-02-08 17:16:39','2026-02-08 17:16:39'),(6303632275,NULL,'A\'song','Ritchil',1,0,0,NULL,'2026-02-12 12:07:01','2026-02-12 12:07:01','2026-02-12 12:07:01'),(6323960445,'Cindreo00','Rana',NULL,1,0,0,NULL,'2026-02-18 15:07:04','2026-02-18 15:42:14','2026-02-18 15:42:14'),(6371333934,'bkriderzkingshovon','Delphie🧚🎸','Smith-Gordon',1,0,0,NULL,'2026-02-18 14:45:05','2026-02-23 20:59:57','2026-02-23 20:59:57'),(6377991248,'RDX_SUPPORT','RDX SUPPORT 〽️',NULL,1,0,0,NULL,'2026-02-02 18:51:50','2026-02-28 03:59:24','2026-02-28 03:59:24'),(6438950197,'Silence_m_a','Silence',NULL,1,0,0,NULL,'2026-02-25 13:04:21','2026-02-25 13:05:46','2026-02-25 13:05:46'),(6447613525,'TMGROUPOWNER','TM','ADMIN 团队管理员',1,0,0,NULL,'2026-01-21 17:12:07','2026-01-21 17:12:07','2026-01-21 17:12:07'),(6501952547,'SXTSHANTO','SHANTO | TG/WS','會話賣家',1,0,0,NULL,'2026-01-24 20:14:25','2026-01-24 20:14:25','2026-01-24 20:14:25'),(6510364276,'Himu_FB','HIMU 希穆',NULL,1,0,0,NULL,'2026-02-23 14:53:30','2026-02-23 14:53:30','2026-02-23 14:53:30'),(6528424959,'hosain271','MD Hosain TG/WS',NULL,1,0,1,'2026-02-15 14:22:16','2026-01-15 16:44:23','2026-02-25 14:53:13','2026-02-25 14:53:13'),(6557571212,'SAKIB_AP','𝖲𝖠𝖪𝖨𝖡','开发',1,0,0,NULL,'2026-02-27 16:57:10','2026-02-27 16:57:11','2026-02-27 16:57:11'),(6611340594,'N_A_I_M4k','𝙉𝙖𝙞𝙢','𝘾𝙝𝙤𝙬𝙙𝙝𝙪𝙧𝙮 纳伊姆',1,0,1,'2026-03-01 07:54:55','2026-01-16 06:38:21','2026-03-01 09:17:48','2026-03-01 09:17:48'),(6613112749,'swadTG','SWAD WS/TG',NULL,1,0,0,NULL,'2026-02-19 13:27:44','2026-02-26 05:43:28','2026-02-26 05:43:28'),(6668478801,'Jarif_i','MD Ismail','Ismail',1,0,0,NULL,'2026-02-08 04:33:38','2026-02-08 04:33:38','2026-02-08 04:33:38'),(6702482966,'MrHyper0','➳ᴹᴿ᭄༆Hʸᵖᵉʳ᭄',NULL,1,0,0,NULL,'2026-01-16 07:04:48','2026-02-27 18:20:51','2026-02-27 18:20:51'),(6778195828,NULL,'IT\'Z','SHERI 🚩🤍',1,0,0,NULL,'2026-02-19 09:27:40','2026-02-19 09:28:46','2026-02-19 09:28:46'),(6812561065,NULL,'MD','ŚÙMON',1,0,1,'2026-03-18 14:55:06','2026-01-15 16:45:18','2026-03-02 11:19:57','2026-03-02 11:19:57'),(6812901916,'MD_ABDULLAH_X','MD ABDULLAH',NULL,1,0,0,NULL,'2026-01-27 15:08:29','2026-01-27 15:08:29','2026-01-27 15:08:29'),(6844126402,'Fatemadaughter','Abbas Moiz','Bhai',1,0,0,NULL,'2026-02-24 03:37:47','2026-02-24 03:38:41','2026-02-24 03:38:41'),(6846367234,'Usman123346','Usman','Sajid',1,0,0,NULL,'2026-01-26 15:52:10','2026-01-26 15:52:10','2026-01-26 15:52:10'),(6854871116,'Rupa_021','Rupa',NULL,1,0,0,NULL,'2026-02-07 12:48:14','2026-02-07 12:48:14','2026-02-07 12:48:14'),(6898007869,'Masumrana_123','Masum','Rana',1,0,0,NULL,'2026-02-03 19:09:21','2026-02-17 19:39:59','2026-02-17 19:39:59'),(6908523976,'Kingking101','Mr.King𒆜The.Emperor𒆜',NULL,1,0,0,NULL,'2026-01-17 17:53:16','2026-01-17 17:53:16','2026-01-17 17:53:16'),(6917073978,'RaselTG','RL','ADMIN (𝐓𝐆買家)',1,0,0,NULL,'2026-02-23 07:22:18','2026-02-23 07:22:21','2026-02-23 07:22:21'),(6931386172,'Mr_WokiToki','ᴡᴏᴋɪ','ᴛᴏᴋɪ (TG卖家)',1,0,0,NULL,'2026-01-16 18:16:19','2026-02-25 12:22:56','2026-02-25 12:22:56'),(6973343707,'itsmehedi0','𝕄𝕖𝕙𝕖𝕕𝕚 ℍ𝕒𝕤𝕒𝕟',NULL,1,0,0,NULL,'2026-02-18 13:32:21','2026-02-18 18:21:31','2026-02-18 18:21:31'),(6989800182,'TM_owner_backup','TM','OWNER',1,0,0,NULL,'2026-01-17 08:29:15','2026-01-17 08:29:15','2026-01-17 08:29:15'),(6990029587,'flpp_g','天下-TG直登-协议',NULL,1,0,1,'2026-02-16 11:53:50','2026-01-17 10:11:43','2026-01-17 10:11:43','2026-01-17 10:11:43'),(7044650981,NULL,'THE BLACK HAT HACKER',NULL,1,0,0,NULL,'2026-02-23 10:01:30','2026-02-23 10:01:46','2026-02-23 10:01:46'),(7064927643,'zhen_rtx','Zhen RTX',NULL,1,0,0,NULL,'2026-01-15 16:35:55','2026-03-02 07:46:01','2026-03-02 07:46:01'),(7075102928,'Maruf_2K04','𝐌𝐝. 𝙈𝘼𝙍𝙐𝙁','𝙷𝚊𝚜𝚊𝚗 (高质量)',1,0,0,NULL,'2026-01-16 19:07:55','2026-01-16 19:07:55','2026-01-16 19:07:55'),(7118136436,'King_reciver_support','SUPPORT ⚙️',NULL,1,0,0,NULL,'2026-02-07 12:50:22','2026-02-07 12:50:22','2026-02-07 12:50:22'),(7171124653,NULL,'FLYING OWNER',NULL,1,0,0,NULL,'2026-02-07 06:30:35','2026-02-21 18:01:22','2026-02-21 18:01:22'),(7178789818,'Gsusbshk','Asif',NULL,1,0,0,NULL,'2026-02-01 07:34:15','2026-03-02 17:45:29','2026-03-02 17:45:29'),(7188031604,'micro_bot_owner','Micro','Bot Owner',1,0,0,NULL,'2026-01-22 20:36:34','2026-01-22 20:36:34','2026-01-22 20:36:34'),(7221681075,'MMV000001','youngEm',NULL,1,0,0,NULL,'2026-02-20 20:50:46','2026-02-20 20:52:26','2026-02-20 20:52:26'),(7278356910,'Sabuj_Mia0','Sabuj',NULL,1,0,0,NULL,'2026-02-08 04:46:09','2026-02-26 19:47:17','2026-02-26 19:47:17'),(7283429202,'STI_ON','STI','團隊負責人',1,0,0,NULL,'2026-01-23 15:20:58','2026-02-16 06:51:37','2026-02-16 06:51:37'),(7319898345,'djxksn90','Shoriful','Habib',1,0,0,NULL,'2026-02-19 15:18:33','2026-02-19 17:34:08','2026-02-19 17:34:08'),(7320647154,'PayReceiver_Admin','Pay Receiver ONWER',NULL,1,0,1,'2026-03-02 16:25:03','2026-01-26 19:23:11','2026-02-20 12:38:25','2026-02-20 12:38:25'),(7355093885,'mdshanto7899o','Sh Shanto',NULL,1,0,0,NULL,'2026-02-23 19:39:20','2026-02-23 19:39:44','2026-02-23 19:39:44'),(7433138762,'SUMON21K','𝐒𝐔𝐌𝐎𝐍 𝐂𝐌','苏曼',1,0,0,NULL,'2026-01-21 17:54:04','2026-01-21 17:54:04','2026-01-21 17:54:04'),(7434236398,'amir_alirew','Shadow',NULL,1,0,0,NULL,'2026-02-25 23:14:07','2026-02-25 23:14:07','2026-02-25 23:14:07'),(7482167295,'UB_PAYMENT_LEADER','UB SUPPORT',NULL,1,0,0,NULL,'2026-01-27 17:53:50','2026-01-27 17:53:50','2026-01-27 17:53:50'),(7489304905,NULL,'☠️Douu','Sai ☠️',1,0,0,NULL,'2026-02-08 17:15:29','2026-02-08 17:15:29','2026-02-08 17:15:29'),(7495468732,'farhan07415','Farhan 🐾',NULL,1,0,0,NULL,'2026-02-26 05:45:43','2026-02-26 05:48:06','2026-02-26 05:48:06'),(7505333004,'Shakoor273','Abdul','Shakoor',1,0,0,NULL,'2026-02-02 19:04:35','2026-02-02 19:04:35','2026-02-02 19:04:35'),(7522996838,'Love_King1','安西克',NULL,1,0,0,NULL,'2026-02-26 15:33:07','2026-02-26 21:19:18','2026-02-26 21:19:18'),(7529097385,'RakibTgSell','MD Rakib TG  所有者','🫧',1,0,0,NULL,'2026-01-17 08:24:20','2026-02-20 09:34:41','2026-02-20 09:34:41'),(7557962281,'wearertx','RABBI RTX',NULL,1,0,0,NULL,'2026-01-15 16:23:54','2026-03-03 09:31:38','2026-03-03 09:31:38'),(7570012385,'Ali_xaxx','𝙰𝚕𝚒',NULL,1,0,0,NULL,'2026-02-19 08:45:42','2026-02-19 08:45:42','2026-02-19 08:45:42'),(7575920014,'SECURE_SUPPORT1','SECURE SUPPORT',NULL,1,0,0,NULL,'2026-02-01 09:52:42','2026-02-01 09:52:42','2026-02-01 09:52:42'),(7580191280,'Siyam1233211','MD','Siyam',1,0,0,NULL,'2026-02-07 12:43:34','2026-02-07 12:43:34','2026-02-07 12:43:34'),(7611971908,NULL,'Swapnil','Basak Turjo',1,0,0,NULL,'2026-02-16 19:50:08','2026-02-18 09:47:07','2026-02-18 09:47:07'),(7624955121,'Janice_OL0','Janice',NULL,1,0,0,NULL,'2026-02-03 17:25:43','2026-02-28 17:44:23','2026-02-28 17:44:23'),(7706681370,'Mahir_098','Mahir',NULL,1,0,0,NULL,'2026-02-10 19:09:44','2026-02-10 19:09:44','2026-02-10 19:09:44'),(7799618516,'Atowner2','Md','Alamin Hossain',1,0,1,'2026-03-18 09:50:27','2026-01-15 16:51:04','2026-03-03 18:31:50','2026-03-03 18:31:50'),(7809329320,NULL,'Hassan','Md',1,0,0,NULL,'2026-01-16 06:42:52','2026-01-16 06:42:52','2026-01-16 06:42:52'),(7884448729,'tg_24supp','Вихан♦️Раджон','·拉瓊',1,0,0,NULL,'2026-01-16 17:15:19','2026-03-03 18:39:56','2026-03-03 18:39:56'),(7885477161,NULL,'Shahadat','Abdullah',1,0,0,NULL,'2026-02-12 11:13:03','2026-02-12 11:13:03','2026-02-12 11:13:03'),(7885727380,NULL,'𝐖𝐨𝐤𝐢 𝐓𝐨𝐤𝐢','𝐛𝐨𝐭 𝐈\'𝐝 ✈️',1,0,0,NULL,'2026-01-16 18:16:32','2026-01-16 18:16:32','2026-01-16 18:16:32'),(7887512937,'HunterCrashPro','Hunter',NULL,1,0,0,NULL,'2026-03-03 09:47:37','2026-03-03 09:48:10','2026-03-03 09:48:10'),(7891658307,NULL,'Mahar','Sajjad1122',1,0,0,NULL,'2026-02-19 11:11:26','2026-02-19 11:11:56','2026-02-19 11:11:56'),(7925979982,'Mdhridoy_123','Md','Hridoy',1,0,0,NULL,'2026-01-15 16:44:15','2026-02-28 20:15:10','2026-02-28 20:15:10'),(7945080401,'HD_JOY_K','Hd JoY','🏦',1,0,0,NULL,'2026-02-24 16:06:45','2026-02-24 16:07:02','2026-02-24 16:07:02'),(7955392895,NULL,'K',NULL,1,0,0,NULL,'2026-02-03 17:39:12','2026-02-26 19:35:53','2026-02-26 19:35:53'),(8001861526,NULL,'MR','Tuha',1,0,0,NULL,'2026-01-15 16:50:56','2026-01-15 16:50:56','2026-01-15 16:50:56'),(8026768820,'burning59','burning','burning heart🏍️',1,0,0,NULL,'2026-01-15 16:48:53','2026-01-15 16:48:53','2026-01-15 16:48:53'),(8056531791,NULL,'dark','soul',1,0,0,NULL,'2026-02-25 07:44:30','2026-02-25 07:44:59','2026-02-25 07:44:59'),(8062583609,'Badboysxy9','Bad🙃','Boy',1,0,0,NULL,'2026-02-25 12:23:21','2026-02-27 12:28:38','2026-02-27 12:28:38'),(8088511882,'itz_rajon','維漢♦️拉瓊','Вихан♦️Раджон',1,0,0,NULL,'2026-01-18 21:13:33','2026-02-25 01:15:54','2026-02-25 01:15:54'),(8130627256,'ypeeer','Shakib',NULL,1,0,0,NULL,'2026-02-18 15:37:14','2026-02-18 15:37:24','2026-02-18 15:37:24'),(8140681214,'THTD88','𝐓𝐇','电报 卖方',1,0,1,'2026-03-18 09:34:56','2026-01-15 16:58:07','2026-03-03 19:41:50','2026-03-03 19:41:50'),(8145933846,NULL,'Tabeer','Memon',1,0,0,NULL,'2026-01-27 15:31:55','2026-01-27 15:31:55','2026-01-27 15:31:55'),(8147801886,'SAIDSBD','𝙎𝘼𝙄𝘿 𝘼𝙃𝙈𝙀𝘿 𝙎𝘽𝘿™',NULL,1,0,0,NULL,'2026-01-16 04:06:11','2026-01-16 04:06:11','2026-01-16 04:06:11'),(8154162603,NULL,'Murad','Hasan',1,0,0,NULL,'2026-02-09 18:41:26','2026-02-22 08:55:37','2026-02-22 08:55:37'),(8170536188,'Avuma20','Sai','Op',1,0,0,NULL,'2026-02-22 09:37:26','2026-02-22 09:37:42','2026-02-22 09:37:42'),(8185760751,'Mdshahani','Md','Shahan',1,0,0,NULL,'2026-02-23 19:38:48','2026-02-23 19:38:48','2026-02-23 19:38:48'),(8199806539,'h4nzla','H4nzla','Khan🌚',1,0,0,NULL,'2026-02-10 05:42:40','2026-02-10 05:42:40','2026-02-10 05:42:40'),(8230802588,'pro_shuvo','SHUVO | ZOOM',NULL,1,0,1,'2026-02-14 18:07:52','2026-01-15 16:44:06','2026-01-15 16:44:06','2026-01-15 16:44:06'),(8286094675,'larryscott_nine','Larry Scott',NULL,1,0,0,NULL,'2026-01-15 16:52:34','2026-01-15 16:52:34','2026-01-15 16:52:34'),(8294605080,NULL,'Tasnim',NULL,1,0,0,NULL,'2026-02-12 06:30:18','2026-02-18 15:37:14','2026-02-18 15:37:14'),(8298192242,'SSL67','𝐒𝐀𝐈𝐅𝐔𝐋 (𝐓𝐆/𝐖𝐒)','赛富',1,0,1,'2026-03-23 14:31:45','2026-01-18 08:50:46','2026-03-01 12:19:49','2026-03-01 12:19:49'),(8306909521,NULL,'Tech','King',1,0,0,NULL,'2026-02-12 04:04:23','2026-02-12 04:04:23','2026-02-12 04:04:23'),(8404630419,'Jahid77877','Muntachir','Xahid',1,0,0,NULL,'2026-02-23 19:38:50','2026-02-23 22:20:13','2026-02-23 22:20:13'),(8418788092,NULL,'Md','Fahim',1,0,0,NULL,'2026-01-24 18:21:09','2026-01-24 18:21:09','2026-01-24 18:21:09'),(8458215944,NULL,'Ruhul',NULL,1,0,0,NULL,'2026-02-17 08:06:57','2026-02-17 08:10:52','2026-02-17 08:10:52'),(8504293112,'TyIer01','Abolfazl',NULL,1,0,0,NULL,'2026-02-19 06:21:20','2026-02-19 06:26:10','2026-02-19 06:26:10'),(8505787296,'beixin88','会 话购买者',NULL,1,0,0,NULL,'2026-01-30 03:16:36','2026-01-30 03:16:36','2026-01-30 03:16:36'),(8526459275,'Ulquioerra','𝑲𝑬𝑵𝒁𝑶',NULL,1,0,0,NULL,'2026-02-02 18:37:14','2026-02-02 18:37:14','2026-02-02 18:37:14'),(8534377062,NULL,'MR','Aisha',1,0,0,NULL,'2026-01-21 07:21:13','2026-01-21 07:21:13','2026-01-21 07:21:13'),(8552289940,NULL,'🐚',NULL,1,0,0,NULL,'2026-02-27 19:16:10','2026-02-27 19:16:28','2026-02-27 19:16:28'),(8564727311,NULL,'Nazmul',NULL,1,0,0,NULL,'2026-01-19 05:12:41','2026-01-19 05:12:41','2026-01-19 05:12:41'),(8568533959,'rasel_123412','rasel',NULL,1,0,0,NULL,'2026-01-31 08:01:40','2026-01-31 08:01:40','2026-01-31 08:01:40'),(8588862082,'GodzillaGpOwner','𝗚𝗼𝗱𝘇𝗶𝗹𝗹𝗮',NULL,1,0,0,NULL,'2026-02-19 09:53:44','2026-02-24 19:58:34','2026-02-24 19:58:34'),(8592489588,NULL,'SR','Hassan',1,0,0,NULL,'2026-01-17 16:36:06','2026-01-17 16:36:06','2026-01-17 16:36:06');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vip_plans`
--

DROP TABLE IF EXISTS `vip_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vip_plans` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `duration_days` int NOT NULL,
  `price_usd` decimal(10,2) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vip_plans`
--

LOCK TABLES `vip_plans` WRITE;
/*!40000 ALTER TABLE `vip_plans` DISABLE KEYS */;
INSERT INTO `vip_plans` VALUES (1,'Monthly VIP',30,20.00,'Updated 1 month VIP',1,'2026-01-15 16:23:40'),(2,'3 Month VIP',30,55.00,'Updated 3 month VIP',1,'2026-01-15 16:23:40');
/*!40000 ALTER TABLE `vip_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vip_subscriptions`
--

DROP TABLE IF EXISTS `vip_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vip_subscriptions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `plan_id` int NOT NULL,
  `transaction_id` int NOT NULL,
  `started_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_sub_user` (`user_id`),
  KEY `fk_sub_plan` (`plan_id`),
  KEY `fk_sub_txn` (`transaction_id`),
  CONSTRAINT `fk_sub_plan` FOREIGN KEY (`plan_id`) REFERENCES `vip_plans` (`id`),
  CONSTRAINT `fk_sub_txn` FOREIGN KEY (`transaction_id`) REFERENCES `payment_transactions` (`id`),
  CONSTRAINT `fk_sub_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vip_subscriptions`
--

LOCK TABLES `vip_subscriptions` WRITE;
/*!40000 ALTER TABLE `vip_subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `vip_subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'rtx_toolkit'
--

--
-- Dumping routines for database 'rtx_toolkit'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-03 19:48:35