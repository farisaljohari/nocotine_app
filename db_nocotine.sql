-- phpMyAdmin SQL Dump
-- version 4.9.7
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 24, 2022 at 10:47 PM
-- Server version: 8.0.29
-- PHP Version: 7.4.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ofitjoco_nocotine`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_notification`
--

CREATE TABLE `admin_notification` (
  `notification_id` int NOT NULL,
  `post_id` int NOT NULL,
  `comment_id` int NOT NULL,
  `body` text NOT NULL,
  `type` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `book_id` int NOT NULL,
  `book_name` text NOT NULL,
  `pdf_name_file` text NOT NULL,
  `book_poster` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`book_id`, `book_name`, `pdf_name_file`, `book_poster`) VALUES
(7, 'Harry Potter', 'HarryPotter.pdf', 'harry-potter.jfif'),
(8, 'Twilight', 'Twilight_ The Complete Illustrated Movie Companion (Twilight Saga) ( PDFDrive ).pdf', 'Twilight.jpg'),
(9, 'How to Stop..', 'Dale_Carnegie_How_To_Stop_Worrying_And_Start_Living.pdf', 'HowToStop.jpg'),
(10, 'The Power Of..', 'The Power of Now_ A Guide to Spiritual Enlightenment ( PDFDrive ).pdf', 'ThePower.jpg'),
(11, 'Genius Food', 'Give and Take_ WHY HELPING OTHERS DRIVES OUR SUCCESS ( PDFDrive ).pdf', 'GeniusFood.jpg'),
(12, 'Give and Take', 'Give and Take_ WHY HELPING OTHERS DRIVES OUR SUCCESS ( PDFDrive ).pdf', 'giveandtake.jpg'),
(13, 'The Shadow of..', 'The Shadow of the Wind ( PDFDrive ).pdf', 'theShadow.jpg'),
(14, 'The DaVinci..', 'The DaVinci Code ( PDFDrive ).pdf', 'DaVinci.jpg'),
(21, 'book22', 'pd^cruaa]fjkjtmqZo`^.pdf', 'image_picker1624347317596253268.png');

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `comment_id` int NOT NULL,
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  `comment_text` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`comment_id`, `post_id`, `user_id`, `comment_text`) VALUES
(72, 70, 55, 'fffff'),
(73, 75, 55, 'fffffff'),
(74, 75, 55, 'dddddd'),
(75, 75, 55, 'rrrrrrr'),
(76, 75, 55, 'rrrdddd'),
(77, 75, 55, 'ssssssss'),
(78, 75, 55, 'fffffff'),
(79, 75, 55, 'dddddddddddddddddddddd'),
(80, 75, 55, 'The default value of the maxLengthEnforcement parameter is inferred from the TargetPlatform of the application, to conform to the platform’s conventions:'),
(81, 74, 55, 'hello'),
(82, 94, 55, 'test'),
(83, 99, 55, 'test'),
(84, 99, 47, 'test2'),
(86, 100, 55, 'test2'),
(87, 100, 55, 'test2'),
(88, 100, 55, 'ttttttttt'),
(89, 99, 55, 'test3'),
(91, 97, 47, 'test4'),
(94, 99, 47, 'tttt'),
(154, 104, 55, 'tttt');

-- --------------------------------------------------------

--
-- Table structure for table `comments_report`
--

CREATE TABLE `comments_report` (
  `post_id` int NOT NULL,
  `comment_id` int NOT NULL,
  `user_report_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `comments_report`
--

INSERT INTO `comments_report` (`post_id`, `comment_id`, `user_report_id`) VALUES
(201, 120, 55),
(201, 120, 72),
(206, 123, 47),
(206, 123, 72);

-- --------------------------------------------------------

--
-- Table structure for table `competition`
--

CREATE TABLE `competition` (
  `competition_id` int NOT NULL,
  `sender_id` int NOT NULL,
  `receiver_id` int NOT NULL,
  `sender_counter` int NOT NULL,
  `receiver_counter` int NOT NULL,
  `duration` int NOT NULL,
  `end_time` text NOT NULL,
  `receiver_accept` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `competition_result`
--

CREATE TABLE `competition_result` (
  `competition_id` int NOT NULL,
  `winner_user_id` int NOT NULL,
  `loser_user_id` int NOT NULL,
  `date` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `competition_result`
--

INSERT INTO `competition_result` (`competition_id`, `winner_user_id`, `loser_user_id`, `date`) VALUES
(132, 47, 55, '12-12-2020'),
(150, 58, 47, '15-4-2022');

-- --------------------------------------------------------

--
-- Table structure for table `contacts_website`
--

CREATE TABLE `contacts_website` (
  `id` int NOT NULL,
  `name` varchar(200) NOT NULL,
  `email` varchar(255) NOT NULL,
  `message` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `contacts_website`
--

INSERT INTO `contacts_website` (`id`, `name`, `email`, `message`) VALUES
(2, 'faris aljohari', 'farisaljohari@gmail.com', 'dadad'),
(7, 'Henryidefe', 'RookTessa9292@o2.pl', 'Let the Robot bring you money while you rest. https://idefe.bode-roesch.de/idefe '),
(8, 'Duncan Smith', '5rdhp2fe29yb@beconfidential.com', 'Dear Sir/Madam \r\n \r\nYou can only achieve financial freedom when you create multiple streams of income. \r\n \r\nI have an investment portfolio that will benefit both of us and I hope it will be appealing to you. \r\n \r\nIf interested contact me for more information via my E-mail: duncansmith2801@gmail.com \r\n \r\nI look forward to your quick reply. \r\n \r\nRegards \r\nDuncan Smith'),
(9, 'Henryidefe', 'sir.stephan@forum.dk', 'Trust your dollar to the Robot and see how it grows to $100. https://idefe.bode-roesch.de/idefe '),
(10, 'Henryidefe', 'darre@forum.dk', 'Need money? Get it here easily? https://idefe.bode-roesch.de/idefe '),
(11, 'Henryidefe', 'dahlpedersen@forum.dk', 'Need money? Earn it without leaving your home. https://idefe.bode-roesch.de/idefe '),
(12, 'Henryidefe', 'jesper0071@forum.dk', 'Find out about the easiest way of money earning. https://idefe.bode-roesch.de/idefe '),
(13, 'Henryidefe', 'hankanin@forum.dk', 'Start your online work using the financial Robot. https://idefe.bode-roesch.de/idefe '),
(14, 'Henryidefe', 'eydna@forum.dk', 'Need money? Get it here easily? https://idefe.bode-roesch.de/idefe '),
(15, 'Henryidefe', 'trau15@forum.dk', 'Making money in the net is easier now. https://idefe.bode-roesch.de/idefe '),
(16, 'Henryidefe', 'teplomir59@mailme.dk', 'Launch the best investment instrument to start making money today. https://idefe.bode-roesch.de/idefe '),
(17, 'Henryidefe', 'art1deni@mailme.dk', 'Start making thousands of dollars every week. https://idefe.bode-roesch.de/idefe '),
(18, 'Henryidefe', 'masterdragon40@mail-online.dk', 'Launch the best investment instrument to start making money today. https://idefe.bode-roesch.de/idefe ');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `feedback_id` int NOT NULL,
  `user_id` int NOT NULL,
  `rate` double NOT NULL,
  `feedback_comment` text NOT NULL,
  `date` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`feedback_id`, `user_id`, `rate`, `feedback_comment`, `date`) VALUES
(8, 47, 3.5, 'test12  test test testtesttesttesttest test test test', '18/5/2022'),
(9, 47, 2, 'test12', '18/5/2022'),
(10, 47, 3.5, '', '18/5/2022'),
(11, 47, 3.5, '', '18/5/2022'),
(12, 47, 3.5, '', '18/5/2022'),
(13, 47, 3, '', '18/5/2022'),
(14, 47, 4.5, '', '18/5/2022'),
(15, 47, 3, 'tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt', '18/5/2022'),
(16, 47, 3, 'ok', '19/5/2022'),
(17, 47, 3.5, 'test', '2/6/2022'),
(18, 55, 2.5, '', '6/6/2022'),
(19, 47, 3, 'test test', '6/6/2022'),
(21, 47, 2.5, '', '8/6/2022');

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

CREATE TABLE `likes` (
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  `visable_like` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `likes`
--

INSERT INTO `likes` (`post_id`, `user_id`, `visable_like`) VALUES
(100, 47, 'true'),
(232, 47, 'true');

-- --------------------------------------------------------

--
-- Table structure for table `notification`
--

CREATE TABLE `notification` (
  `notification_id` int NOT NULL,
  `user_id_sender` int NOT NULL,
  `user_id_reciever` int NOT NULL,
  `post_id` int NOT NULL,
  `body` text NOT NULL,
  `icon` text NOT NULL,
  `date` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `notification`
--

INSERT INTO `notification` (`notification_id`, `user_id_sender`, `user_id_reciever`, `post_id`, `body`, `icon`, `date`) VALUES
(12, 55, 47, 100, 'commented on your post', 'mode_comment', '13/4/2022'),
(36, 55, 47, 100, 'commented on your post', 'mode_comment', '16/4/2022'),
(41, 47, 55, 97, 'liked your post', 'favorite', '17/4/2022'),
(42, 47, 55, 97, 'commented on your post', 'mode_comment', '17/4/2022'),
(44, 55, 47, 100, 'commented on your post', 'mode_comment', '17/4/2022'),
(48, 47, 55, 99, 'commented on your post', 'mode_comment', '17/4/2022'),
(180, 47, 55, 99, 'liked your post', 'favorite', '18/4/2022'),
(183, 58, 55, 99, 'liked your post', 'favorite', '18/4/2022'),
(184, 58, 55, 99, 'commented on your post', 'mode_comment', '18/4/2022'),
(185, 58, 55, 103, 'liked your post', 'favorite', '18/4/2022'),
(299, 47, 55, 0, 'you\'ve won the competition', 'com_won', '6/5/2022'),
(301, 55, 47, 0, 'you\'ve won the competition', 'com_won', '6/5/2022'),
(303, 55, 47, 0, 'you\'ve won the competition', 'com_won', '6/5/2022'),
(304, 47, 55, 0, 'you\'ve lost the competition', 'com_lost', '6/5/2022'),
(309, 47, 55, 0, 'you\'ve won the competition', 'com_won', '6/5/2022'),
(311, 55, 47, 0, 'you\'ve won the competition', 'com_won', '6/5/2022'),
(312, 47, 55, 0, 'you\'ve lost the competition', 'com_lost', '6/5/2022'),
(314, 47, 55, 0, 'you\'ve both smoked the same amount of cigarettes', 'com_draw', '6/5/2022'),
(316, 47, 55, 0, 'you\'ve won the competition', 'com_won', '6/5/2022'),
(317, 55, 47, 0, 'you\'ve lost the competition', 'com_lost', '6/5/2022'),
(319, 55, 47, 0, 'you\'ve won the competition', 'com_won', '6/5/2022'),
(320, 47, 55, 0, 'you\'ve lost the competition', 'com_lost', '6/5/2022'),
(322, 55, 47, 0, 'you\'ve both smoked the same amount of cigarettes', 'com_draw', '6/5/2022'),
(323, 47, 55, 0, 'you\'ve both smoked the same amount of cigarettes', 'com_draw', '6/5/2022'),
(327, 55, 47, 0, 'your competition has started', 'com_accept', '6/5/2022'),
(328, 55, 55, 0, 'your competition has started', 'com_accept', '6/5/2022'),
(340, 55, 55, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(341, 55, 47, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(348, 55, 55, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(349, 55, 47, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(352, 47, 55, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(353, 47, 47, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(354, 55, 47, 0, 'you\'ve won the competition', 'com_won', '7/5/2022'),
(355, 47, 55, 0, 'you\'ve lost the competition', 'com_lost', '7/5/2022'),
(357, 47, 47, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(359, 55, 47, 0, 'you\'ve lost the competition', 'com_lost', '7/5/2022'),
(360, 47, 55, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(362, 47, 47, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(363, 47, 55, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(366, 47, 47, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(367, 47, 55, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(370, 47, 55, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(371, 47, 47, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(372, 47, 55, 0, 'has left the competition', 'com_lost', '7/5/2022'),
(380, 55, 47, 0, 'has rejected your competition', 'com_reject', '7/5/2022'),
(385, 47, 55, 0, 'has rejected your competition', 'com_reject', '7/5/2022'),
(387, 55, 47, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(388, 55, 55, 0, 'your competition has started', 'com_accept', '7/5/2022'),
(389, 55, 47, 0, 'has left the Competition', 'com_lost', '7/5/2022'),
(392, 55, 47, 0, 'has rejected your competition', 'com_reject', '7/5/2022'),
(394, 55, 47, 0, 'your competition has started', 'com_accept', '8/5/2022'),
(395, 55, 55, 0, 'your competition has started', 'com_accept', '8/5/2022'),
(396, 55, 47, 0, 'you\'ve won the competition', 'com_won', '8/5/2022'),
(398, 55, 47, 0, 'your competition has started', 'com_accept', '8/5/2022'),
(399, 55, 55, 0, 'your competition has started', 'com_accept', '8/5/2022'),
(400, 55, 47, 0, 'has left the competition', 'com_lost', '8/5/2022'),
(669, 47, 55, 0, 'your competition has started', 'com_accept', '9/5/2022'),
(670, 47, 47, 0, 'your competition has started', 'com_accept', '9/5/2022'),
(671, 47, 55, 0, 'has left the competition', 'com_lost', '9/5/2022'),
(674, 47, 55, 104, 'commented on your post', 'mode_comment', '19/5/2022'),
(681, 59, 47, 137, 'your post has been deleted', 'delete_post', '23/5/2022'),
(682, 59, 47, 135, 'your post has been deleted', 'delete_post', '23/5/2022'),
(683, 59, 47, 100, 'your comment has been deleted', 'delete_comment', '23/5/2022'),
(684, 59, 47, 100, 'your comment has been deleted', 'delete_comment', '23/5/2022'),
(685, 59, 47, 100, 'your comment has been deleted', 'delete_comment', '23/5/2022'),
(687, 59, 55, 100, 'your comment has been deleted', 'delete_comment', '23/5/2022'),
(688, 55, 47, 0, 'has rejected your competition', 'com_reject', '26/5/2022'),
(689, 59, 55, 119, 'your post has been deleted', 'delete_post', '26/5/2022'),
(690, 59, 55, 118, 'your post has been deleted', 'delete_post', '26/5/2022'),
(714, 58, 58, 0, 'your competition has started', 'com_accept', '29/5/2022'),
(715, 58, 47, 0, 'your competition has started', 'com_accept', '29/5/2022'),
(717, 55, 55, 0, 'your competition has started', 'com_accept', '29/5/2022'),
(718, 55, 47, 0, 'your competition has started', 'com_accept', '29/5/2022'),
(719, 55, 47, 0, 'has left the Competition', 'com_lost', '29/5/2022'),
(721, 55, 55, 0, 'your competition has started', 'com_accept', '29/5/2022'),
(722, 55, 47, 0, 'your competition has started', 'com_accept', '29/5/2022'),
(723, 47, 55, 0, 'has left the Competition', 'com_lost', '29/5/2022'),
(729, 55, 47, 0, 'has left the Competition', 'com_lost', '1/6/2022'),
(743, 55, 47, 0, 'has rejected your competition', 'com_reject', '2/6/2022'),
(745, 55, 47, 0, 'has rejected your competition', 'com_reject', '2/6/2022'),
(765, 55, 47, 0, 'has rejected your competition', 'com_reject', '3/6/2022'),
(766, 59, 55, 224, 'Your Post Has Been Deleted', 'delete_post', '4/6/2022'),
(767, 59, 55, 216, 'Your Post Has Been Deleted', 'delete_post', '4/6/2022'),
(768, 59, 47, 212, 'Your Post Has Been Deleted', 'delete_post', '4/6/2022'),
(771, 47, 47, 0, 'your competition has started', 'com_accept', '6/6/2022'),
(772, 47, 55, 0, 'your competition has started', 'com_accept', '6/6/2022'),
(773, 47, 55, 0, 'has left the Competition', 'com_lost', '6/6/2022'),
(777, 47, 47, 0, 'your competition has started', 'com_accept', '7/6/2022'),
(778, 47, 55, 0, 'your competition has started', 'com_accept', '7/6/2022'),
(779, 47, 55, 0, 'has left the Competition', 'com_lost', '7/6/2022'),
(781, 47, 47, 0, 'your competition has started', 'com_accept', '7/6/2022'),
(787, 47, 47, 0, 'your competition has started', 'com_accept', '7/6/2022'),
(790, 55, 47, 0, 'your competition has started', 'com_accept', '8/6/2022'),
(791, 55, 55, 0, 'your competition has started', 'com_accept', '8/6/2022'),
(792, 59, 55, 218, 'Your Post Has Been Deleted', 'delete_post', '8/6/2022'),
(793, 59, 55, 231, 'Your Post Has Been Deleted', 'delete_post', '8/6/2022'),
(794, 59, 55, 230, 'Your Post Has Been Deleted', 'delete_post', '8/6/2022'),
(795, 59, 47, 210, 'Your Post Has Been Deleted', 'delete_post', '8/6/2022'),
(796, 59, 55, 207, 'Your Post Has Been Deleted', 'delete_post', '8/6/2022'),
(797, 59, 47, 209, 'Your Post Has Been Deleted', 'delete_post', '8/6/2022'),
(798, 59, 55, 106, 'Your Post Has Been Deleted', 'delete_post', '8/6/2022'),
(799, 55, 47, 0, 'has left the Competition', 'com_lost', '8/6/2022'),
(801, 47, 55, 0, 'has rejected your competition', 'com_lost', '8/6/2022'),
(804, 55, 55, 0, 'your competition has started', 'com_accept', '8/6/2022'),
(805, 55, 47, 0, 'your competition has started', 'com_accept', '8/6/2022'),
(806, 55, 47, 0, 'has left the Competition', 'com_lost', '9/6/2022'),
(808, 55, 55, 0, 'your competition has started', 'com_accept', '9/6/2022'),
(809, 55, 47, 0, 'your competition has started', 'com_accept', '9/6/2022'),
(810, 47, 55, 0, 'has left the Competition', 'com_lost', '9/6/2022');

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  `post_text` longtext NOT NULL,
  `feeling` varchar(30) NOT NULL,
  `image_post` text NOT NULL,
  `total_comments` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`post_id`, `user_id`, `post_text`, `feeling`, `image_post`, `total_comments`) VALUES
(66, 55, '', 'Happy 😄', '', '0'),
(67, 55, '', '', '', '0'),
(68, 55, '', '', '', '0'),
(69, 55, '', 'Happy 😄', '', '0'),
(70, 55, '', '', '', '0'),
(76, 55, '', '', '', '0'),
(77, 55, '', '', '', '0'),
(78, 55, '', '', '', '0'),
(79, 55, '', '', '', '0'),
(80, 55, '', '', '', '0'),
(81, 55, '', '', '', '0'),
(82, 55, '', '', 'image_picker6753801828602370126.jpg', '0'),
(83, 55, '', '', 'image_picker4597478484457152964.png', '0'),
(84, 55, '', 'Happy 😄', 'image_picker8231222334268591210.png', '0'),
(85, 55, '', '', '', '0'),
(86, 55, '', 'Tired 😪', '', '0'),
(87, 55, '', 'Happy 😄', '', '0'),
(88, 55, '', '', 'image_picker2340563756134049624.png', '0'),
(89, 55, '', '', 'image_picker1111001790837033109.png', '0'),
(90, 55, '', 'Happy 😄', '', '0'),
(91, 55, '', 'Tired 😪', '', '0'),
(92, 55, '', '', '', '0'),
(94, 55, '', '', 'image_picker5196278279560993725.png', '0'),
(97, 55, '', '', '', '0'),
(99, 55, 'tt', '', '78fe7a1a-3f51-40a7-a95b-b15392ff50054056261085944170851.jpg', '4'),
(100, 47, '', 'Happy 😄', '', '3'),
(101, 58, '', 'Happy 😄', '058f1d9b-f37a-4e31-a311-7659b9be2c475481332773793573437.jpg', '0'),
(102, 58, '', '', '47502897-0a42-48b5-ab27-0de82badfc234108638158738579361.jpg', '0'),
(103, 55, '', '', '4a8dafda-353a-474e-b94b-4d45771863de3773983003397197391.jpg', '0'),
(104, 55, '', '', '', '1'),
(105, 55, '', '', 'b9bfe10e-dc84-46a1-92a7-34d0e43a64148906713214620542641.jpg', '0'),
(107, 55, '', '', 'cc861840-4e18-4fb9-b7ad-597afd2a82799198008196122833183.jpg', '0'),
(108, 55, '', '', 'ca316762-eea1-45a3-9358-fd65b49683e52517184067075719102.jpg', '0'),
(109, 55, '', '', '2345ac20-54e6-48f3-831c-6a1dded75a812350396081769715827.jpg', '0'),
(111, 55, '', '', '5cf7b9b1-2c6b-4060-ad1a-8fead25cffcd3377394129803579053.jpg', '0'),
(112, 58, '', '', '9d7b8576-0f81-47b8-b9de-d6d076569bd94581180434180106504.jpg', '0'),
(114, 58, '', '', 'cde1f298-a010-4015-b5bd-d066f9b1a8134647547113730163706.jpg', '0'),
(140, 47, 'tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttffffffffffffffffffffffffffffffff', '', '68f6fce0-253b-403c-b8e3-83d0ae8b3cf54351905397959984183.jpg', '0'),
(243, 55, 'test', '', 'dc96c425-189c-4dc3-8ad8-f15d4a841e714216823255863114450.jpg', '0'),
(250, 55, 'Helllooo', 'Happy 😄', 'image_picker8477557884150847081.png', '0');

-- --------------------------------------------------------

--
-- Table structure for table `posts_report`
--

CREATE TABLE `posts_report` (
  `user_report_id` int NOT NULL,
  `post_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `smoking_counter`
--

CREATE TABLE `smoking_counter` (
  `counter_id` int NOT NULL,
  `user_id` int NOT NULL,
  `number_of_cigarette` int NOT NULL,
  `cost_of_cigarette` double NOT NULL,
  `save_health` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `smoking_counter`
--

INSERT INTO `smoking_counter` (`counter_id`, `user_id`, `number_of_cigarette`, `cost_of_cigarette`, `save_health`) VALUES
(9, 47, 1, 0.02, 0.008),
(15, 55, 8, 0.27999999999999997, 0.062),
(17, 58, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(150) NOT NULL,
  `verified` int NOT NULL,
  `verification_code` varchar(20) NOT NULL,
  `type` varchar(100) NOT NULL,
  `password` text NOT NULL,
  `gender` varchar(20) NOT NULL,
  `Age` varchar(50) NOT NULL,
  `bio` text NOT NULL,
  `image` longtext NOT NULL,
  `Token` longtext NOT NULL,
  `count_notification` int NOT NULL,
  `visable_sheet` int NOT NULL,
  `number_of_packets` double NOT NULL,
  `price_of_packets` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `verified`, `verification_code`, `type`, `password`, `gender`, `Age`, `bio`, `image`, `Token`, `count_notification`, `visable_sheet`, `number_of_packets`, `price_of_packets`) VALUES
(47, 'Dana', 'turki', 'danaturki2000@gmail.com', 1, '', 'user', '5b9172946e68e1539062eb731bf40752', 'Female', '6', 'test', 'image_picker417687092417685524.jpg', 'fW9KdpQbRi61Hg_HF_Oe0j:APA91bG-blStjHkTI-w7-gbjBro4UVhRNxbIpFj_1Px5QfJ8UUyrywf4g8DWc1DGUAwbWz_EIO3O1PXH07xqb3ZL4j7ZrjMRpOHQbKsdndv_demhq_XWOWsz6XDQW7gZ_VT75Daw9Aeh', 0, 1, 1.5, 0.4),
(55, 'Faris', 'Mohammad', 'farisaljohari@gmail.com', 1, '', 'user', 'ff499ab84fc4f246e2de3a9049f4e160', 'Male', '22', 'Bio', 'image_picker8684673288008715387.jpg', 'fIetqetGSGWMMdaFy3CtY4:APA91bEIwK3ApIxud3VFMrMNZBQAXSlFiKGrjbJlxLjlSKoW3tw-qutP5StJ_jVk5W_RgcI50aH_7SBYw-DSFcZReDylKL7LpxWI-wRnJ2fsi-FboETNug0F7piF_aZtRT5bBtYHtfzM', 0, 1, 2.5, 0.7),
(58, 'Laheeb', 'Alabbadi', 'Lahheb@gmail.com', 1, '', 'user', '202cb962ac59075b964b07152d234b70', 'Female', '10', '', 'user.png', 'dGAbJSIWTRSJumeo4KPoJG:APA91bHu53EWEOheDLi-70Fxq56ucRoj3KzFuLVj59Ucy5lm6d9TDEoskdwQ8c8xvYZF91I3Xfgd-iQBZpGTOeSFp9KO7igWDlXTZcqqSuVv3dpfwA40iyQr_QZGtsg8fZmLuZ6nqoqN', 1, 1, 1.5, 0.4),
(59, 'Admin', 'Admin', 'nocotine@nocotine.app', 1, '', 'admin', '751cb3f4aa17c36186f4856c8982bf27', '', '', '', '', 'fIetqetGSGWMMdaFy3CtY4:APA91bEIwK3ApIxud3VFMrMNZBQAXSlFiKGrjbJlxLjlSKoW3tw-qutP5StJ_jVk5W_RgcI50aH_7SBYw-DSFcZReDylKL7LpxWI-wRnJ2fsi-FboETNug0F7piF_aZtRT5bBtYHtfzM', 0, 0, 0, 0),
(88, 'faris', 'ahmad', 'r.alsayyed@ju.edu.jo', 0, 'OKJ7hoPUZL', 'user', 'ff499ab84fc4f246e2de3a9049f4e160', 'Male', '15', '', 'user.png', '', 0, 0, 0, 0),
(89, 'Faris', 'Ahmad', 'dimah_1999@yahoo.com', 0, 'YybezMi4EG', 'user', 'ff499ab84fc4f246e2de3a9049f4e160', 'Male', '3', '', 'user.png', '', 0, 0, 0, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_notification`
--
ALTER TABLE `admin_notification`
  ADD PRIMARY KEY (`notification_id`),
  ADD UNIQUE KEY `unique_index` (`post_id`,`comment_id`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`book_id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`comment_id`);

--
-- Indexes for table `comments_report`
--
ALTER TABLE `comments_report`
  ADD UNIQUE KEY `unique_index` (`post_id`,`comment_id`,`user_report_id`);

--
-- Indexes for table `competition`
--
ALTER TABLE `competition`
  ADD PRIMARY KEY (`competition_id`),
  ADD UNIQUE KEY `sender_id` (`sender_id`),
  ADD UNIQUE KEY `receiver_id` (`receiver_id`);

--
-- Indexes for table `competition_result`
--
ALTER TABLE `competition_result`
  ADD PRIMARY KEY (`competition_id`);

--
-- Indexes for table `contacts_website`
--
ALTER TABLE `contacts_website`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`feedback_id`);

--
-- Indexes for table `likes`
--
ALTER TABLE `likes`
  ADD UNIQUE KEY `unique_index` (`post_id`,`user_id`);

--
-- Indexes for table `notification`
--
ALTER TABLE `notification`
  ADD PRIMARY KEY (`notification_id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`post_id`);

--
-- Indexes for table `posts_report`
--
ALTER TABLE `posts_report`
  ADD UNIQUE KEY `unique_index` (`user_report_id`,`post_id`);

--
-- Indexes for table `smoking_counter`
--
ALTER TABLE `smoking_counter`
  ADD PRIMARY KEY (`counter_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`,`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_notification`
--
ALTER TABLE `admin_notification`
  MODIFY `notification_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `book_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `comment_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=171;

--
-- AUTO_INCREMENT for table `competition`
--
ALTER TABLE `competition`
  MODIFY `competition_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=180;

--
-- AUTO_INCREMENT for table `contacts_website`
--
ALTER TABLE `contacts_website`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `notification`
--
ALTER TABLE `notification`
  MODIFY `notification_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=811;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `post_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=251;

--
-- AUTO_INCREMENT for table `smoking_counter`
--
ALTER TABLE `smoking_counter`
  MODIFY `counter_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
