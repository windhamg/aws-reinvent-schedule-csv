# import libraries
import requests
import re
import json
import io
import csv
import sys
from pprint import pprint
from bs4 import BeautifulSoup
from bs4.element import Comment
from datetime import datetime

def remove_html_markup(s):
    tag = False
    quote = False
    out = ""

    for c in s:
            if c == '<' and not quote:
                tag = True
            elif c == '>' and not quote:
                tag = False
            elif (c == '"' or c == "'") and tag:
                quote = not quote
            elif not tag:
                out = out + c

    # remove any stray /* */ sequences
    out = out.replace("/*", "")
    out = out.replace("*/", "")

    return out

# establish session with reinvent portal
s = requests.Session()
s.get('https://www.portal.reinvent.awsevents.com/connect/publicDashboard.ww')
s.post('https://www.portal.reinvent.awsevents.com/connect/processLogin.do', data = {'username':sys.argv[1], 'password':sys.argv[2]})
r = s.get('https://www.portal.reinvent.awsevents.com/connect/interests.ww')

# parse the html using beautiful soup and store in variable `soup`
soup = BeautifulSoup(r.text, 'html.parser')

# get schedule details input block
schedule_input = """
callCount=1
windowName=
c0-scriptName=ConnectAjax
c0-methodName=getSchedulingJSON
c0-id=0
c0-param0=string:{0}
c0-param1=boolean:false
batchId=1
instanceId=0
page=%2Fconnect%2Finterests.ww
scriptSessionId=bogus
"""

# get sessions
session_tbl = soup.find('div', id='sessionsTab').find_all('div', attrs={'class': 'sessionRow'})
session_items = []
cur_date = ''
date_idx = 0
for session in session_tbl:
    # get session details
    session_id = session['id'].split('_')[1]
    name_parts = session.find('a').find_all('span')
    session_code, session_title = [i.get_text().strip() for i in name_parts]
    session_code = re.sub(' -$', '', session_code)
    match = re.match(".*\-R(\d+)?$", session_code)
    repeat = '-'
    if match is not None:
        if match.lastindex is None:
            repeat = '0'
        else:
            repeat = match.group(1)
    abstract = remove_html_markup(session.find('span', attrs={'class': 'abstract'}).get_text()).strip().replace('\n',' ')
    session_type = session.find('small', attrs={'class': 'type'}).get_text().strip()
    speakers = session.find('small', attrs={'class': 'speakers'}).get_text()
    speakers = [i.strip() for i in re.split('\s{2,}', speakers)]
    speakers = ','.join(speakers).strip(',')

    # get session schedule
    r = s.post('https://www.portal.reinvent.awsevents.com/connect/dwr/call/plaincall/ConnectAjax.getSchedulingJSON.dwr', headers={'Content-Type': 'text/plain'}, data=schedule_input.format(session_id))
    part1 = r.text.partition('[{')[2]
    part2 = part1.partition('}]')[0]
    sch = json.loads("{%s}" % part2.replace('\\',''))
    start = datetime.strptime("%s 2018" % sch['startTime'], '%A, %b %d, %I:%M %p %Y')
    end_parts = sch['endTime'].split(':')
    end_hour = int(end_parts[0])
    if end_parts[1].endswith(" PM") and end_hour < 12:
        end_hour = end_hour + 12
    end_mins = int(end_parts[1].split(' ')[0])
    end = datetime(start.year, start.month, start.day, end_hour, end_mins)
    start_time = start.strftime("%Y-%m-%d %H:%M:%S")
    end_time = end.strftime("%Y-%m-%d %H:%M:%S")
    venue, room = [i.strip() for i in sch['room'].strip().split(',', 1)]

    # add session to list
    session_items.append({
        'session_code': session_code,
        'session_title': session_title,
        'repeat': repeat,
        'abstract': abstract,
        'type': session_type,
        'speakers': speakers,
        'start_time': start_time,
        'end_time': end_time,
        'venue': venue,
        'room': room
    })

# write sessions to CSV
csvout = io.StringIO()
fieldnames = ['session_code', 'session_title', 'repeat', 'abstract', 'type', 'speakers', 'start_time', 'end_time', 'venue', 'room']
writer = csv.DictWriter(csvout, fieldnames=fieldnames)
writer.writeheader()
writer.writerows(session_items)
print(csvout.getvalue().strip())
