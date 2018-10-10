AWS Re-Invent 2018 Interest List to CSV
=======================================

**rationale**
When you mark a lot of sessions as "interested in" trying to do any sort of analysis of them, prior to AWS opening session registration, is next to impossible. This script breaks down your interested events into discrete fields that you can load into a data source of your choice for further analysis.

This script will parse your AWS re:Invent 2018 "Interests" list and provide a CSV file with the following fields:

* `session_code`
* `session_title`
* `repeat` (ordinal value of repeat occurrence; for initial instance of a repeated session value will be "0")
* `abstract`
* `type` (e.g,. Chalk Talk, Workshop, Session, etc.)
* `speakers` (comma-delimited list)
* `start_time`
* `end_time`
* `venue` (Aria, MGM Grand, etc.)
* `room`


**how to use**
* requires Python 3
* `git clone` this repository
* run `pip install -r requirements.txt`
* to run, cd to repo directory and `python ./reinvent-schedule-csv.py <username> <password> > aws-interests.csv` (where `<username>` and `<password>` are your AWS re:Invent credentials that you use to access the event catalog and mark sessions as "interested")
* you can import the resulting CSV to an Excel spreadsheet, load it into a SQL database, or whatever you desire

**bonus materials**

While you can use the resulting CSV file with any tool of your choice, I loaded it into a MySQL database. Included are some MySQL scripts that can help with loading the data and querying it:

* `fn_get_distance.sql` creates a function (`FN_GET_DISTANCE`) and loads GPS coordinates of the re:Invent session venues into a table that can be used in your queries to see distances between a particular session venue and all the other venues.
* `load_csv.sql` creates a table (`reinvent_interests`) and loads the CSV file (produced by `reinvent-schedule-csv.py`) into the table.
* `queries.sql` provides some sample SQL queries
