#!/bin/sh

#����hp ��npar ,vpar,vm��Ϣ
#AIX ��Lpar��Ϣ
#hpvmstatus.txt  parstatus.txt vparstatus.txt lparstat.txt

cd /smdb/hostinfo/data

if [ ! -n "$CHECKDATEA" ]
then
    CHECKDATE=2014-01-15
else
    echo "NOT NULL"
fi




echo $CHECKDATE


 
