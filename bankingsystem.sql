-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 26, 2020 at 11:49 AM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bankingsystem`
--

-- --------------------------------------------------------

--
-- Table structure for table `bankaccount`
--

CREATE TABLE `bankaccount` (
  `BankAccountID` int(10) UNSIGNED NOT NULL,
  `BACreationDate` datetime NOT NULL DEFAULT current_timestamp(),
  `BACurrentBalance` double DEFAULT 1000,
  `CustomerID` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bankaccount`
--

INSERT INTO `bankaccount` (`BankAccountID`, `BACreationDate`, `BACurrentBalance`, `CustomerID`) VALUES
(2, '2020-11-18 13:23:22', 50021, 17),
(3, '2020-11-27 14:30:00', 100000, 22),
(4, '2020-11-29 23:24:56', 1007, 100),
(131098, '2020-11-29 22:24:05', 19972, 12);

-- --------------------------------------------------------

--
-- Table structure for table `banktransaction`
--

CREATE TABLE `banktransaction` (
  `BankTransactionID` int(11) NOT NULL,
  `BTCreationDate` datetime NOT NULL DEFAULT current_timestamp(),
  `BTAmount` double DEFAULT NULL,
  `BTToAccount` int(10) UNSIGNED NOT NULL,
  `BTFromAccount` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `banktransaction`
--

INSERT INTO `banktransaction` (`BankTransactionID`, `BTCreationDate`, `BTAmount`, `BTToAccount`, `BTFromAccount`) VALUES
(1, '2020-12-20 00:14:39', 0, 2, 131098),
(2, '2020-12-20 13:44:05', 5, 2, 131098),
(3, '2020-12-20 13:44:42', 5, 2, 131098),
(4, '2020-12-20 14:00:42', 11, 4, 131098),
(5, '2020-12-20 14:07:01', 1, 2, 131098),
(6, '2020-12-20 14:15:02', 2, 4, 131098),
(7, '2020-12-20 14:15:12', 2, 4, 131098),
(8, '2020-12-20 14:17:27', 2, 4, 131098),
(10, '2020-12-26 11:57:17', 10, 131098, 4);

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `CustomerID` int(10) UNSIGNED NOT NULL,
  `CustomerPassword` varchar(30) NOT NULL,
  `CustomerName` varchar(60) DEFAULT NULL,
  `CustomerAddress` varchar(60) DEFAULT NULL,
  `CustomerMobile` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`CustomerID`, `CustomerPassword`, `CustomerName`, `CustomerAddress`, `CustomerMobile`) VALUES
(12, '0000', 'Mohamed', 'Dokki', '1234'),
(17, '0000', 'Ahmed', 'Giza', '50505'),
(22, '0000', 'Omar', 'Tahrir', '430943'),
(100, '100100', 'Fastest Man Alive', 'Haram st', '36384628');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bankaccount`
--
ALTER TABLE `bankaccount`
  ADD PRIMARY KEY (`BankAccountID`),
  ADD KEY `FK_CustBA` (`CustomerID`);

--
-- Indexes for table `banktransaction`
--
ALTER TABLE `banktransaction`
  ADD PRIMARY KEY (`BankTransactionID`),
  ADD KEY `FK_BTBA1` (`BTFromAccount`),
  ADD KEY `FK_BTBA2` (`BTToAccount`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`CustomerID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bankaccount`
--
ALTER TABLE `bankaccount`
  MODIFY `BankAccountID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=131100;

--
-- AUTO_INCREMENT for table `banktransaction`
--
ALTER TABLE `banktransaction`
  MODIFY `BankTransactionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bankaccount`
--
ALTER TABLE `bankaccount`
  ADD CONSTRAINT `FK_CustBA` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`);

--
-- Constraints for table `banktransaction`
--
ALTER TABLE `banktransaction`
  ADD CONSTRAINT `FK_BTBA1` FOREIGN KEY (`BTFromAccount`) REFERENCES `bankaccount` (`BankAccountID`),
  ADD CONSTRAINT `FK_BTBA2` FOREIGN KEY (`BTToAccount`) REFERENCES `bankaccount` (`BankAccountID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
