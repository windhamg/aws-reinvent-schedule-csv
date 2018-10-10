--
-- Create function to return distance (in miles) between two lat/long pairs
--

DROP FUNCTION IF EXISTS `FN_GET_DISTANCE`
CREATE FUNCTION `FN_GET_DISTANCE`(lat1 DOUBLE, lng1 DOUBLE, lat2 DOUBLE, lng2 DOUBLE) RETURNS double
BEGIN
    DECLARE radlat1 DOUBLE;
    DECLARE radlat2 DOUBLE;
    DECLARE theta DOUBLE;
    DECLARE radtheta DOUBLE;
    DECLARE dist DOUBLE;
    SET radlat1 = PI() * lat1 / 180;
    SET radlat2 = PI() * lat2 / 180;
    SET theta = lng1 - lng2;
    SET radtheta = PI() * theta / 180;
    SET dist = sin(radlat1) * sin(radlat2) + cos(radlat1) * cos(radlat2) * cos(radtheta);
    SET dist = acos(dist);
    SET dist = dist * 180 / PI();
    SET dist = dist * 60 * 1.1515;
RETURN dist;
END

--
-- Create table for re:Invent venues
--

DROP TABLE IF EXISTS `reinvent_venues`
CREATE TABLE `reinvent_venues` (
  `venue` varchar(100) NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL
);

--
-- Load venue data into table
--

INSERT INTO `reinvent_venues` (venue,latitude,longitude) VALUES
('Aria East',36.1073,115.1766)
,('Aria West',36.1073,115.1766)
,('Venetian',36.1212,115.1697)
,('Mirage',36.1212,115.1741)
,('Bellagio',36.1126,115.1767)
,('MGM',36.1026,115.1703)
;
