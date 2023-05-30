-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 192.168.103.221:3306
-- Generation Time: May 30, 2023 at 02:03 AM
-- Server version: 8.0.33
-- PHP Version: 8.1.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `batteries`
--

-- --------------------------------------------------------

--
-- Table structure for table `data`
--

CREATE TABLE `data` (
  `id` int NOT NULL,
  `session` int NOT NULL,
  `data` json NOT NULL,
  `time` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `data`
--

INSERT INTO `data` (`id`, `session`, `data`, `time`) VALUES
(3, 0, '{\"test\": 0}', '2023-05-30 01:43:48'),
(4, 0, '{\"test\": 0}', '2023-05-30 01:46:50'),
(5, 0, '{\"test\": 0}', '2023-05-30 01:46:56'),
(6, 0, '{\"test\": 0}', '2023-05-30 01:59:42');

-- --------------------------------------------------------

--
-- Table structure for table `serialnumber`
--

CREATE TABLE `serialnumber` (
  `sn` int NOT NULL,
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `k-param` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `serialnumber`
--

INSERT INTO `serialnumber` (`sn`, `name`, `k-param`) VALUES
(12, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `sessionid`
--

CREATE TABLE `sessionid` (
  `session_id` int NOT NULL,
  `time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(32) DEFAULT NULL,
  `sn` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `sessionid`
--

INSERT INTO `sessionid` (`session_id`, `time`, `name`, `sn`) VALUES
(0, '2023-05-30 01:43:00', NULL, 12);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `data`
--
ALTER TABLE `data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `data_to_sessionid` (`session`);

--
-- Indexes for table `serialnumber`
--
ALTER TABLE `serialnumber`
  ADD PRIMARY KEY (`sn`),
  ADD UNIQUE KEY `sn` (`sn`);

--
-- Indexes for table `sessionid`
--
ALTER TABLE `sessionid`
  ADD PRIMARY KEY (`session_id`),
  ADD UNIQUE KEY `session_id` (`session_id`),
  ADD KEY `sessionid_to_sn` (`sn`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `data`
--
ALTER TABLE `data`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `data`
--
ALTER TABLE `data`
  ADD CONSTRAINT `data_to_sessionid` FOREIGN KEY (`session`) REFERENCES `sessionid` (`session_id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Constraints for table `sessionid`
--
ALTER TABLE `sessionid`
  ADD CONSTRAINT `sessionid_to_sn` FOREIGN KEY (`sn`) REFERENCES `serialnumber` (`sn`) ON DELETE RESTRICT ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
