-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 09, 2025 at 04:26 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `healthsync`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `admin_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`admin_id`, `username`, `password`, `email`, `full_name`, `phone`, `created_at`, `status`) VALUES
(4, 'mayur142', 'jZae727K08KaOmKSgOaGzww/XVqGr/PKEgIMkjrcbJI=', 'mayur.chavda138534@marwadiuniversity.ac.in', 'mayur chavda mm', '9904598373', '2025-11-07 05:42:31', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `appointment_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `reason` text NOT NULL,
  `status` enum('pending','approved','completed','cancelled','rejected') DEFAULT 'approved',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`appointment_id`, `patient_id`, `doctor_id`, `appointment_date`, `appointment_time`, `reason`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(14, 9, 8, '2025-11-09', '10:00:00', 'high sugar', 'completed', NULL, '2025-11-09 11:14:33', '2025-11-09 11:15:53'),
(15, 11, 8, '2025-11-10', '10:30:00', 'pain', 'completed', NULL, '2025-11-09 11:56:57', '2025-11-09 11:57:34');

-- --------------------------------------------------------

--
-- Stand-in structure for view `appointment_details`
-- (See below for the actual view)
--
CREATE TABLE `appointment_details` (
`appointment_id` int(11)
,`appointment_date` date
,`appointment_time` time
,`reason` text
,`status` enum('pending','approved','completed','cancelled','rejected')
,`notes` text
,`patient_name` varchar(101)
,`patient_phone` varchar(15)
,`patient_email` varchar(100)
,`doctor_name` varchar(101)
,`specialization` varchar(100)
,`doctor_phone` varchar(15)
);

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `doctor_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `specialization` varchar(100) NOT NULL,
  `qualification` varchar(200) NOT NULL,
  `experience` int(11) NOT NULL,
  `address` text DEFAULT NULL,
  `date_joined` date DEFAULT curdate(),
  `status` enum('active','inactive') DEFAULT 'active',
  `profile_image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`doctor_id`, `first_name`, `last_name`, `email`, `password`, `phone`, `specialization`, `qualification`, `experience`, `address`, `date_joined`, `status`, `profile_image`) VALUES
(8, 'prit mm', 'pansuriya ch', 'mayurchavda12122006@gmail.com', 'jZae727K08KaOmKSgOaGzww/XVqGr/PKEgIMkjrcbJI=', '9904598373', 'Orthopedics', 'MBBS', 12, '', '2025-11-07', 'active', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `patient_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `date_of_birth` date NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `blood_group` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
  `address` text DEFAULT NULL,
  `emergency_contact` varchar(15) DEFAULT NULL,
  `medical_history` text DEFAULT NULL,
  `registration_date` date DEFAULT curdate(),
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`patient_id`, `first_name`, `last_name`, `email`, `password`, `phone`, `date_of_birth`, `gender`, `blood_group`, `address`, `emergency_contact`, `medical_history`, `registration_date`, `status`) VALUES
(2, 'Sneha', 'Gupta', 'sneha.gupta@email.com', 'jGl25bVBBBW96Qi9Te4V37Fnqchz/Eu4qB9vKrRIqRg=', '+91-9876543222', '1985-08-22', 'Female', 'A+', '202 Green Park, Delhi, Delhi', '+91-9876543223', 'Hypertension', '2025-11-06', 'active'),
(3, 'Rohit', 'Sharma', 'rohit.sharma@email.com', 'jGl25bVBBBW96Qi9Te4V37Fnqchz/Eu4qB9vKrRIqRg=', '+91-9876543224', '1992-12-10', 'Male', 'O+', '303 Tech City, Bangalore, Karnataka', '+91-9876543225', 'Diabetes Type 2', '2025-11-06', 'active'),
(5, 'Kiran', 'Kumar', 'kiran.kumar@email.com', 'jGl25bVBBBW96Qi9Te4V37Fnqchz/Eu4qB9vKrRIqRg=', '+91-9876543228', '1995-07-25', 'Male', 'A-', '505 IT Hub, Hyderabad, Telangana', '+91-9876543229', 'No major medical history', '2025-11-06', 'active'),
(6, 'Pooja', 'Agarwal', 'pooja.agarwal@email.com', 'jGl25bVBBBW96Qi9Te4V37Fnqchz/Eu4qB9vKrRIqRg=', '+91-9876543230', '1993-11-08', 'Female', 'O-', '606 University Area, Pune, Maharashtra', '+91-9876543231', 'Migraine', '2025-11-06', 'active'),
(7, 'Deepak', 'Jain', 'deepak.jain@email.com', 'jGl25bVBBBW96Qi9Te4V37Fnqchz/Eu4qB9vKrRIqRg=', '+91-9876543232', '1987-09-14', 'Male', 'A+', '707 Business District, Gurgaon, Haryana', '+91-9876543233', 'High Cholesterol', '2025-11-06', 'active'),
(8, 'Meera', 'Nair', 'meera.nair@email.com', 'jGl25bVBBBW96Qi9Te4V37Fnqchz/Eu4qB9vKrRIqRg=', '+91-9876543234', '1991-01-30', 'Female', 'AB-', '808 Backwaters View, Kochi, Kerala', '+91-9876543235', 'Thyroid', '2025-11-06', 'active'),
(9, 'Mayur', 'chavda', 'mayurchavda12122006@gmail.com', 'lsrjXOipsCRBeL8o5JZsLOG4OFcjqWprg4hYzdbKCh4=', '9904598373', '2006-12-12', 'Male', 'O+', '25 mtr plot, 54/1, morbi road - jakatnaka , rajkot -360003', '990991392122', '', '2025-11-06', 'active'),
(10, 'yzx', 'jjjj', 'cowof89765@artvara.com', 'jZae727K08KaOmKSgOaGzww/XVqGr/PKEgIMkjrcbJI=', '999232131221', '2006-12-12', 'Male', 'A+', '', '', NULL, '2025-11-07', 'active'),
(11, 'Jatin', 'chavda', 'mayur.chavda138534@marwadiuniversity.ac.in', 'jZae727K08KaOmKSgOaGzww/XVqGr/PKEgIMkjrcbJI=', '9930129301', '2006-12-12', 'Female', 'A+', 'rajkot', '', '', '2025-11-09', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `prescriptions`
--

CREATE TABLE `prescriptions` (
  `prescription_id` int(11) NOT NULL,
  `appointment_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `diagnosis` text NOT NULL,
  `medications` text NOT NULL,
  `instructions` text NOT NULL,
  `notes` text DEFAULT NULL,
  `prescription_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `prescriptions`
--

INSERT INTO `prescriptions` (`prescription_id`, `appointment_id`, `patient_id`, `doctor_id`, `diagnosis`, `medications`, `instructions`, `notes`, `prescription_date`, `created_at`) VALUES
(8, 14, 9, 8, 'sdsa', 'assdsa', 'asda', '', '2025-11-09', '2025-11-09 11:15:53'),
(9, 15, 11, 8, 'pain', 'any', 'kadk', '', '2025-11-09', '2025-11-09 11:57:34');

-- --------------------------------------------------------

--
-- Stand-in structure for view `prescription_details`
-- (See below for the actual view)
--
CREATE TABLE `prescription_details` (
`prescription_id` int(11)
,`prescription_date` date
,`diagnosis` text
,`medications` text
,`instructions` text
,`notes` text
,`patient_name` varchar(101)
,`patient_phone` varchar(15)
,`doctor_name` varchar(101)
,`specialization` varchar(100)
);

-- --------------------------------------------------------

--
-- Structure for view `appointment_details`
--
DROP TABLE IF EXISTS `appointment_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `appointment_details`  AS SELECT `a`.`appointment_id` AS `appointment_id`, `a`.`appointment_date` AS `appointment_date`, `a`.`appointment_time` AS `appointment_time`, `a`.`reason` AS `reason`, `a`.`status` AS `status`, `a`.`notes` AS `notes`, concat(`p`.`first_name`,' ',`p`.`last_name`) AS `patient_name`, `p`.`phone` AS `patient_phone`, `p`.`email` AS `patient_email`, concat(`d`.`first_name`,' ',`d`.`last_name`) AS `doctor_name`, `d`.`specialization` AS `specialization`, `d`.`phone` AS `doctor_phone` FROM ((`appointments` `a` join `patients` `p` on(`a`.`patient_id` = `p`.`patient_id`)) join `doctors` `d` on(`a`.`doctor_id` = `d`.`doctor_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `prescription_details`
--
DROP TABLE IF EXISTS `prescription_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `prescription_details`  AS SELECT `pr`.`prescription_id` AS `prescription_id`, `pr`.`prescription_date` AS `prescription_date`, `pr`.`diagnosis` AS `diagnosis`, `pr`.`medications` AS `medications`, `pr`.`instructions` AS `instructions`, `pr`.`notes` AS `notes`, concat(`p`.`first_name`,' ',`p`.`last_name`) AS `patient_name`, `p`.`phone` AS `patient_phone`, concat(`d`.`first_name`,' ',`d`.`last_name`) AS `doctor_name`, `d`.`specialization` AS `specialization` FROM ((`prescriptions` `pr` join `patients` `p` on(`pr`.`patient_id` = `p`.`patient_id`)) join `doctors` `d` on(`pr`.`doctor_id` = `d`.`doctor_id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`admin_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`appointment_id`),
  ADD KEY `idx_appointments_date` (`appointment_date`),
  ADD KEY `idx_appointments_doctor` (`doctor_id`),
  ADD KEY `idx_appointments_patient` (`patient_id`),
  ADD KEY `idx_appointments_status` (`status`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`doctor_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_doctors_specialization` (`specialization`),
  ADD KEY `idx_doctors_status` (`status`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`patient_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_patients_status` (`status`);

--
-- Indexes for table `prescriptions`
--
ALTER TABLE `prescriptions`
  ADD PRIMARY KEY (`prescription_id`),
  ADD KEY `appointment_id` (`appointment_id`),
  ADD KEY `idx_prescriptions_date` (`prescription_date`),
  ADD KEY `idx_prescriptions_patient` (`patient_id`),
  ADD KEY `idx_prescriptions_doctor` (`doctor_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `appointment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `doctor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `patient_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `prescriptions`
--
ALTER TABLE `prescriptions`
  MODIFY `prescription_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE CASCADE;

--
-- Constraints for table `prescriptions`
--
ALTER TABLE `prescriptions`
  ADD CONSTRAINT `prescriptions_ibfk_1` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `prescriptions_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `prescriptions_ibfk_3` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
