--
-- Look for a particular session and get all repeat occurrences
-- (Note you have to add all the repeat occurrence to your interests list)
--

select session_code, session_title, `repeat`, start_time, end_time, venue from reinvent_interests where session_code = 'WPS301' order by start_time, end_time, `repeat`;

--
-- get a list of all interested sessions, sorted by start_time and end_time, with distances (in miles) to other venues
--

select s.session_code as code, s.session_title as title, s.`repeat` as occurrence, s.start_time as start_time, s.end_time as end_time, s.venue as venue,
round((select fn_get_distance((select latitude from reinvent_venues where venue = s.venue),(select longitude from reinvent_venues where venue = s.venue),(select latitude from reinvent_venues where venue = 'Aria West'),(select longitude from reinvent_venues where venue = 'Aria West'))),2) as dist_aria_west,
round((select fn_get_distance((select latitude from reinvent_venues where venue = s.venue),(select longitude from reinvent_venues where venue = s.venue),(select latitude from reinvent_venues where venue = 'Aria East'),(select longitude from reinvent_venues where venue = 'Aria East'))),2) as dist_aria_east,
round((select fn_get_distance((select latitude from reinvent_venues where venue = s.venue),(select longitude from reinvent_venues where venue = s.venue),(select latitude from reinvent_venues where venue = 'Mirage'),(select longitude from reinvent_venues where venue = 'Mirage'))),2) as dist_mirage,
round((select fn_get_distance((select latitude from reinvent_venues where venue = s.venue),(select longitude from reinvent_venues where venue = s.venue),(select latitude from reinvent_venues where venue = 'Venetian'),(select longitude from reinvent_venues where venue = 'Venetian'))),2) as dist_venetian,
round((select fn_get_distance((select latitude from reinvent_venues where venue = s.venue),(select longitude from reinvent_venues where venue = s.venue),(select latitude from reinvent_venues where venue = 'Bellagio'),(select longitude from reinvent_venues where venue = 'Bellagio'))),2) as dist_bellagio,
round((select fn_get_distance((select latitude from reinvent_venues where venue = s.venue),(select longitude from reinvent_venues where venue = s.venue),(select latitude from reinvent_venues where venue = 'MGM'),(select longitude from reinvent_venues where venue = 'MGM'))),2) as dist_mgm
from reinvent_interests s order by start_time, end_time;

--
-- get all interested sessions between 1PM - 3PM on 11/26/2018
--

select session_code, session_title, `repeat`, start_time, end_time, venue, attend from reinvent_interests where start_time >= "2018-11-26 13:00:00" and end_time <= "2018-11-26 15:00:00";
