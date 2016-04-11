#!/bin/bash
killall genreport.py
killall reportdiff.py
killall ftpup.py
killall ftpdown.py
python /usr/report/ftpdown.py
