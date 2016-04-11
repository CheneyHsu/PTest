#!/bin/bash
killall genreport.py
killall reportdiff.py
killall ftpup.py
killall ftpdown.py
export LANG=c
python /usr/report/genreport.py
