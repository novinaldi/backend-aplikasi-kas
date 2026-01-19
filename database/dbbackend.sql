/*
SQLyog Enterprise
MySQL - 11.3.2-MariaDB-log : Database - dbapiserver2025
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `cache` */

DROP TABLE IF EXISTS `cache`;

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `cache` */

/*Table structure for table `cache_locks` */

DROP TABLE IF EXISTS `cache_locks`;

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `cache_locks` */

/*Table structure for table `failed_jobs` */

DROP TABLE IF EXISTS `failed_jobs`;

CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `failed_jobs` */

/*Table structure for table `job_batches` */

DROP TABLE IF EXISTS `job_batches`;

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `job_batches` */

/*Table structure for table `jobs` */

DROP TABLE IF EXISTS `jobs`;

CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `jobs` */

/*Table structure for table `kas` */

DROP TABLE IF EXISTS `kas`;

CREATE TABLE `kas` (
  `notrans` char(50) NOT NULL,
  `tanggal` date NOT NULL,
  `jumlahuang` double NOT NULL DEFAULT 0,
  `keterangan` varchar(255) NOT NULL,
  `jenis` enum('masuk','keluar') NOT NULL,
  `iduser` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`notrans`),
  KEY `iduser` (`iduser`),
  CONSTRAINT `kas_ibfk_1` FOREIGN KEY (`iduser`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `kas` */

insert  into `kas`(`notrans`,`tanggal`,`jumlahuang`,`keterangan`,`jenis`,`iduser`,`created_at`,`updated_at`) values 
('M180120261329','2026-01-18',100000,'SALDO Awal','masuk',5,'2026-01-18 22:23:12','2026-01-18 22:23:12');

/*Table structure for table `kirimuang` */

DROP TABLE IF EXISTS `kirimuang`;

CREATE TABLE `kirimuang` (
  `noref` char(50) NOT NULL COMMENT 'No.Referensi',
  `tglkirim` timestamp NOT NULL DEFAULT current_timestamp(),
  `dari_iduser` bigint(20) unsigned NOT NULL,
  `ke_iduser` bigint(20) unsigned NOT NULL,
  `jumlahuang` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`noref`),
  KEY `dari_iduser` (`dari_iduser`),
  KEY `ke_iduser` (`ke_iduser`),
  CONSTRAINT `kirimuang_ibfk_1` FOREIGN KEY (`dari_iduser`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `kirimuang_ibfk_2` FOREIGN KEY (`ke_iduser`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `kirimuang` */

/*Table structure for table `migrations` */

DROP TABLE IF EXISTS `migrations`;

CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `migrations` */

insert  into `migrations`(`id`,`migration`,`batch`) values 
(1,'0001_01_01_000000_create_users_table',1),
(2,'0001_01_01_000001_create_cache_table',1),
(3,'0001_01_01_000002_create_jobs_table',1),
(4,'2025_11_04_070521_create_personal_access_tokens_table',1),
(5,'2025_11_04_073229_add_ip_and_user_agent_to_users_table',1);

/*Table structure for table `mintauang` */

DROP TABLE IF EXISTS `mintauang`;

CREATE TABLE `mintauang` (
  `noref` char(50) NOT NULL,
  `tglminta` timestamp NULL DEFAULT current_timestamp(),
  `dari_iduser` bigint(20) unsigned DEFAULT NULL,
  `ke_iduser` bigint(20) unsigned DEFAULT NULL,
  `jumlahuang` double DEFAULT NULL,
  `stt` enum('pending','sukses') DEFAULT NULL,
  `tglsukses` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`noref`),
  KEY `dari_iduser` (`dari_iduser`),
  KEY `ke_iduser` (`ke_iduser`),
  CONSTRAINT `mintauang_ibfk_1` FOREIGN KEY (`dari_iduser`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `mintauang_ibfk_2` FOREIGN KEY (`ke_iduser`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `mintauang` */

insert  into `mintauang`(`noref`,`tglminta`,`dari_iduser`,`ke_iduser`,`jumlahuang`,`stt`,`tglsukses`) values 
('MU18012026152349131356','2026-01-18 22:23:49',6,5,20000,'sukses','2026-01-18 15:25:53');

/*Table structure for table `password_reset_tokens` */

DROP TABLE IF EXISTS `password_reset_tokens`;

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `password_reset_tokens` */

/*Table structure for table `personal_access_tokens` */

DROP TABLE IF EXISTS `personal_access_tokens`;

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `personal_access_tokens` */

insert  into `personal_access_tokens`(`id`,`tokenable_type`,`tokenable_id`,`name`,`token`,`abilities`,`last_used_at`,`expires_at`,`created_at`,`updated_at`) values 
(31,'App\\Models\\User',2,'auth_token_novinaldi','ba714864bf49b7a9b0a2d14ebc33b38066ab51167d85b00452a7810e5a0947ab','[\"*\"]','2025-12-16 14:49:40',NULL,'2025-12-09 13:08:36','2025-12-16 14:49:40'),
(36,'App\\Models\\User',3,'auth_token_novinaldi','544e8b584515dffb5b7609ca2986ea167a791b43585bbce39f218d0de6689373','[\"*\"]','2025-12-16 16:43:11',NULL,'2025-12-16 16:42:26','2025-12-16 16:43:11'),
(37,'App\\Models\\User',3,'auth_token_novinaldi','3bbd0f4cde79c91623769dd7f18ca2ba7d6e24b07c7db4badcf70020e59bb749','[\"*\"]','2025-12-16 16:53:50',NULL,'2025-12-16 16:43:02','2025-12-16 16:53:50'),
(38,'App\\Models\\User',3,'auth_token_novinaldi','bb8b55a210be64a97930c1abe6f848fb8c27a8597d7e95c26dd3a732094b6496','[\"*\"]','2025-12-17 04:54:19',NULL,'2025-12-16 17:08:52','2025-12-17 04:54:19'),
(39,'App\\Models\\User',3,'auth_token_novinaldi','b6ecf9dde1dbd0618060edae90086e16e385458e1bf7513b80bc0564368af045','[\"*\"]','2025-12-17 11:10:40',NULL,'2025-12-17 04:49:36','2025-12-17 11:10:40'),
(84,'App\\Models\\User',6,'auth_token_novinaldi','707889f0a9a3065cfe6e34bdec0bc3ff69effa3f25cd4d5df969916ad14d883e','[\"*\"]','2026-01-18 15:26:18',NULL,'2026-01-18 15:26:17','2026-01-18 15:26:18');

/*Table structure for table `saldouser` */

DROP TABLE IF EXISTS `saldouser`;

CREATE TABLE `saldouser` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `iduser` bigint(20) unsigned NOT NULL,
  `jumlahsaldo` double DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `iduser` (`iduser`),
  CONSTRAINT `saldouser_ibfk_1` FOREIGN KEY (`iduser`) REFERENCES `users` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `saldouser` */

insert  into `saldouser`(`id`,`iduser`,`jumlahsaldo`,`created_at`,`updated_at`) values 
(1,5,80000,'2025-12-22 15:46:43','2026-01-18 22:25:53'),
(2,6,20000,'2025-12-22 16:10:55','2026-01-18 22:25:53');

/*Table structure for table `sessions` */

DROP TABLE IF EXISTS `sessions`;

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `sessions` */

insert  into `sessions`(`id`,`user_id`,`ip_address`,`user_agent`,`payload`,`last_activity`) values 
('7gOwf2eAKST9GZ6MQKqQtZC1njS1eTAfdUHLFiD3',NULL,'192.168.100.8','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiMGxpS1h1VUtobllZSFB1SHBHM08xa1BiVFJLODNPS0pma3lOMTNwVSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjU6Imh0dHA6Ly8xOTIuMTY4LjEwMC44OjgwMDAiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1767883122),
('DGsn3JTgfq4f5gcH9zaBftO1s2T1v5THOq2Cyh4m',NULL,'192.168.100.8','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiYzFCMDJUVUpjeGliUFJrS2pPRng1SGRZVkU1QkpaMGExRGd3eXRWaCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjU6Imh0dHA6Ly8xOTIuMTY4LjEwMC44OjgwMDAiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1766675205),
('HK5tCo6O6RxiGZxORO0fsZcn3eo8O2VR6ZuJuzQx',NULL,'192.168.100.5','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoiR1dLZ0kxRFVFRXlRMjRkWmozRVlXWTRoZTQ3Sk13NHJhZ0cwdkQxViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjU6Imh0dHA6Ly8xOTIuMTY4LjEwMC44OjgwMDAiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1767174063),
('nApvc9AM2RcY0rCAMCtQwf3TlEbNXcGtalM1RiTU',NULL,'192.168.137.30','Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36','YTozOntzOjY6Il90b2tlbiI7czo0MDoidVc5MzVucERyemNDcjF0OWNyWnVQWFJyenM1VTBZZjc3NzBEMW5QbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjU6Imh0dHA6Ly8xOTIuMTY4LjEzNy4xOjgwMDAiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1767853495),
('Phs69kjAt2t5NpW7bUsdNh80Bp8ErXw1I1ZoULdA',NULL,'192.168.100.7','okhttp/4.9.2','YTozOntzOjY6Il90b2tlbiI7czo0MDoia2wxYzlBOUNZb1c5ME9pM1AweGZocU8yQTJaTTNUZ3JiOG9ndDhCSCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjU6Imh0dHA6Ly8xOTIuMTY4LjEwMC44OjgwMDAiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1766678789),
('xbmtxCi8zO0m4Wg4OyIKjeHbLeykeIwgJMHlyc9W',NULL,'192.168.100.8','okhttp/4.9.2','YTozOntzOjY6Il90b2tlbiI7czo0MDoiM1RUb3ZCNUUyQjAxVFJKTUoyV0owdTk2MDFRWlJucXNXN0tDMHdwTyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjU6Imh0dHA6Ly8xOTIuMTY4LjEwMC44OjgwMDAiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=',1766662403);

/*Table structure for table `users` */

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(255) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `photo_thumb` varchar(255) DEFAULT NULL,
  `fcmtoken` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*Data for the table `users` */

insert  into `users`(`id`,`name`,`email`,`email_verified_at`,`password`,`remember_token`,`created_at`,`updated_at`,`ip_address`,`user_agent`,`photo`,`photo_thumb`,`fcmtoken`) values 
(5,'Novinaldi','novi@gmail.com',NULL,'$2y$12$cjp9gwUh/wnWgj0cggdJyuPCs3PvUYD6d3HiL1UGmyP4mnHfzGShe',NULL,'2025-12-22 08:46:43','2026-01-17 15:23:55','192.168.100.7','okhttp/4.9.2',NULL,NULL,'cgG6NgtZQfufShGNdt6fXf:APA91bEfrTJWWw1uUTtmRWVr0fGzCEcYFhWzgz5pppOQq1JDeMP0V16MUEqAmgLI8u_Gjlbg7ZdxWXL2kXiw-h5_NFLdhS7Llb1_US3fmH05oeV3pxxxzvY'),
(6,'Ramadhani Fitri','fitri@gmail.com',NULL,'$2y$12$58ZB9LzPWYc4OvVFczOdjuXYKb/Whxq0vIqejRbnOty0ZoIr04RpC',NULL,'2025-12-22 09:10:55','2026-01-17 15:42:37','192.168.100.7','okhttp/4.9.2','/storage/foto_saya/1766675357.jpg','/storage/foto_saya/thumbnail/thumb_1766675357.jpg','cgG6NgtZQfufShGNdt6fXf:APA91bEfrTJWWw1uUTtmRWVr0fGzCEcYFhWzgz5pppOQq1JDeMP0V16MUEqAmgLI8u_Gjlbg7ZdxWXL2kXiw-h5_NFLdhS7Llb1_US3fmH05oeV3pxxxzvY');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
