#!/bin/bash

# 许成林
# 2015-01
# Version 1.0
# For DB2 9.7/Mysql 5.6/Oracle 11g
# For WAS 7.0/Tomcat 8.x/Apache 2.x
##############################################################

source /sbin/setenv.sh

cd /tmp/setup/
#Java /usr/local/java
cp -rf java /usr/local/
echo "export JAVA_HOME=/usr/local/java" >> /etc/profile
#JSVC /opt/jsvc
cp -rf jsvc /opt
echo "export JSVC_HOME=/opt/jsvc" >> /etc/profile
#Snappy /opt/snappy
cp -rf snappy /opt/

#export PATH of /etc/profile
echo "export CLASSPATH=.:$JAVA_HOME/lib:$CLASSPATH" >> /etc/profile
echo "export PATH=$JAVA_HOME/bin:$PATH" >> /etc/profile