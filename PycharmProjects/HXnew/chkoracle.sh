#!/bin/bash
. /etc/profile
file="$HXSERVERID.`date +%Y%m%d%H`.html"
chmod o+w /tmp/report/$file
su - oracle -c "bash /usr/report/checkoracle.sh >> /tmp/report/$file"

