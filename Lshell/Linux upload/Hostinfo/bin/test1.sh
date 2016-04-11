#!/bin/sh

#处理hp 的npar ,vpar,vm信息
#AIX 的Lpar信息
#hpvmstatus.txt  parstatus.txt vparstatus.txt lparstat.txt

cd /smdb/hostinfo/data

if [ ! -n "$CHECKDATEA" ]
then
    CHECKDATE=2014-01-15
else
    echo "NOT NULL"
fi




echo $CHECKDATE


 
