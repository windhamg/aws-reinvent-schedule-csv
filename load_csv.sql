--
-- Create table for re:Invent interested sessions
--

DROP TABLE IF EXISTS `reinvent_interests`;
CREATE TABLE `reinvent_interests` (
  `session_code` varchar(100) NOT NULL,
  `session_title` varchar(2048) DEFAULT NULL,
  `repeat` varchar(100) NOT NULL,
  `abstract` varchar(2048) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `speakers` varchar(1000) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `venue` varchar(100) DEFAULT NULL,
  `room` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`session_code`,`repeat`)
);

--
-- load data from CSV file into table
--

LOAD DATA INFILE 'aws-interests.csv'
INTO TABLE `reinvent_interests`
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
