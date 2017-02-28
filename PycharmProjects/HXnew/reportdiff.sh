#!/bin/bash
. /etc/profile
killall genreport.py
killall reportdiff.py
killall ftpup.py
killall ftpdown.py
/usr/bin/find /tmp -type f -name "$HXSERVERID.*.html" -mtime +1 -exec rm -rf {} \;
python /usr/report/reportdiff.py
