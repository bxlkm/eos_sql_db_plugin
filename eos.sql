-- MySQL dump 10.13  Distrib 8.0.11, for macos10.13 (x86_64)
--
-- Host: localhost    Database: test
-- ------------------------------------------------------
-- Server version	8.0.11

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8mb4 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `accounts` (
  `name` varchar(12) COLLATE utf8mb4_general_ci NOT NULL,
  `abi` json DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `accounts_keys`
--

DROP TABLE IF EXISTS `accounts_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `accounts_keys` (
  `account` varchar(12) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `public_key` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `permission` varchar(12) COLLATE utf8mb4_general_ci DEFAULT NULL,
  KEY `account` (`account`),
  CONSTRAINT `accounts_keys_ibfk_1` FOREIGN KEY (`account`) REFERENCES `accounts` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `actions`
--

DROP TABLE IF EXISTS `actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(12) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `transaction_id` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `seq` smallint(6) DEFAULT NULL,
  `parent` int(11) DEFAULT NULL,
  `name` varchar(12) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `data` json DEFAULT NULL,
  `eosto` varchar(12) GENERATED ALWAYS AS (`data` ->> '$.to'),
  `eosfrom` varchar(12) GENERATED ALWAYS AS (`data` ->> '$.from'),
  `receiver` varchar(12) GENERATED ALWAYS AS (`data` ->> '$.receiver'),
  `payer` varchar(12) GENERATED ALWAYS AS (`data` ->> '$.payer'),
  PRIMARY KEY (`id`),
  KEY `idx_actions_account` (`account`),
  KEY `idx_actions_tx_id` (`transaction_id`),
  KEY `idx_actions_created` (`created_at`),
  KEY `idx_actions_eosto` (`eosto`),
  KEY `idx_actions_eosfrom` (`eosfrom`),
  KEY `idx_actions_receiver` (`receiver`),
  KEY `idx_actions_payer` (`payer`),
  CONSTRAINT `actions_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `actions_ibfk_2` FOREIGN KEY (`account`) REFERENCES `accounts` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=363 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `actions_accounts`
--

DROP TABLE IF EXISTS `actions_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `actions_accounts` (
  `actor` varchar(12) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `permission` varchar(12) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `action_id` int(11) NOT NULL,
  KEY `idx_actions_actor` (`actor`),
  KEY `idx_actions_action_id` (`action_id`),
  CONSTRAINT `actions_accounts_ibfk_1` FOREIGN KEY (`action_id`) REFERENCES `actions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `actions_accounts_ibfk_2` FOREIGN KEY (`actor`) REFERENCES `accounts` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `blocks`
--

DROP TABLE IF EXISTS `blocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `blocks` (
  `id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
  `block_number` int(11) NOT NULL AUTO_INCREMENT,
  `prev_block_id` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `irreversible` tinyint(1) DEFAULT '0',
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `transaction_merkle_root` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `action_merkle_root` varchar(64) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `producer` varchar(12) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `version` int(11) NOT NULL DEFAULT '0',
  `new_producers` json DEFAULT NULL,
  `num_transactions` int(11) DEFAULT '0',
  `confirmed` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `block_number` (`block_number`),
  KEY `idx_blocks_producer` (`producer`),
  KEY `idx_blocks_number` (`block_number`),
  CONSTRAINT `blocks_ibfk_1` FOREIGN KEY (`producer`) REFERENCES `accounts` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=231110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stakes`
--

DROP TABLE IF EXISTS `stakes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `stakes` (
  `account` varchar(13) COLLATE utf8mb4_general_ci NOT NULL,
  `cpu` double(14,4) DEFAULT NULL,
  `net` double(14,4) DEFAULT NULL,
  PRIMARY KEY (`account`),
  CONSTRAINT `stakes_ibfk_1` FOREIGN KEY (`account`) REFERENCES `accounts` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tokens`
--

DROP TABLE IF EXISTS `tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `tokens` (
  `account` varchar(13) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `symbol` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `amount` double(64,4) DEFAULT NULL,
  KEY `idx_tokens_account` (`account`),
  CONSTRAINT `tokens_ibfk_1` FOREIGN KEY (`account`) REFERENCES `accounts` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `transactions` (
  `id` varchar(64) COLLATE utf8mb4_general_ci NOT NULL,
  `block_id` int(11) NOT NULL,
  `ref_block_num` int(11) NOT NULL,
  `ref_block_prefix` int(11) DEFAULT NULL,
  `expiration` datetime DEFAULT CURRENT_TIMESTAMP,
  `pending` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `num_actions` int(11) DEFAULT '0',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `transactions_block_id` (`block_id`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`block_id`) REFERENCES `blocks` (`block_number`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `votes`
--

DROP TABLE IF EXISTS `votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `votes` (
  `account` varchar(13) COLLATE utf8mb4_general_ci NOT NULL,
  `votes` json DEFAULT NULL,
  PRIMARY KEY (`account`),
  UNIQUE KEY `account` (`account`),
  CONSTRAINT `votes_ibfk_1` FOREIGN KEY (`account`) REFERENCES `accounts` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-07-05 18:13:06
