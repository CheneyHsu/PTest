#!/bin/sh
#Linux网卡信息收集
#编写人员:lhl
#修改日期:20121017
#最后修改日期20130511
CHECKDATE=`date "+%Y-%m-%d"`
if [ $HHNAME ]
then
    echo
else
    HHNAME=`hostname`
fi

BIN_PATH=../bin
TMP_PATH=../tmp
FILE_PATH=../file
LOGFILE=${FILE_PATH}/${HHNAME}_${CHECKDATE}_host_ip.txt
ETHNET=${FILE_PATH}/${HHNAME}_${CHECKDATE}_ethnet.txt
cat /dev/null >${LOGFILE}
cat /dev/null >${ETHNET}


echo "AAA_10 Ethernet;"`lspci|grep Ethernet |wc -l`
#ifconfig |sed -n '/bond/,+1'p  | sed -e 'N; s/\n/ /' |awk '/inet addr:/ {printf "10 IP;%s|%s\n",$1,substr($7,6)}' >>${LOGFILE}
#ifconfig |sed -n '/eth/,+1'p  | sed -e 'N; s/\n/ /' |awk '/inet addr:/ {printf "10 IP;%s|%s\n",$1,substr($7,6)}' >>${LOGFILE}
ifconfig |sed -n '/bond/,+1'p  | sed -e 'N; s/\n/ /' |awk '/inet addr:/ {print "'"${HHNAME}|${CHECKDATE}"'|"$1"|"substr($7,6)}' >>${LOGFILE}
ifconfig |sed -n '/eth/,+1'p  | sed -e 'N; s/\n/ /' |awk '/inet addr:/ {print "'"${HHNAME}|${CHECKDATE}"'|"$1"|"substr($7,6)}' >>${LOGFILE}
ifconfig -a |grep eth | while read i;
 do
   LANNU=`echo ${i}|awk '{print $1}'`
   LANDRIVER=`ethtool -i $LANNU |awk '/^driver/ {print $NF}'`
   LANVERSION=`ethtool -i $LANNU |awk '/^version/ {print $NF}'`
   LANPATH=`ethtool -i $LANNU |awk '/^bus-info/ {print $NF}'`
   LANMAC=`echo ${i}|awk '{print $NF}'|sed 's/://g'`
   LANSPEED=`ethtool ${LANNU} |awk '/Speed/ {print $2}'|sed 's/Mb\/s//g'`
   LANSTAT=`ethtool ${LANNU} |awk '/Link detected/ {print $NF}'`    #20130511增加
   if [ -d /proc/net/bonding ]
   then
#      ls /proc/net/bonding/ |while read s;
   for s in `ls /proc/net/bonding/`
        do
           ethv=`grep -w ${LANNU} /proc/net/bonding/$s |wc -l`
           if [ $ethv -eq 0 ]
           then
             BOND=""
             ACTIVE=""
           else
             if  [ $ethv -eq 1 ]
               then
                  BOND=$s
                  ACTIVE=1
				  break
               else
                 BOND=$s
                 ACTIVE=0
				 break
               fi
             fi
          done
     fi

# echo ${i}|awk '{print "10 Ethernet; " $1,$NF,"'$LANSPEED'"}'
    echo ${i}|awk '{print "'"${HHNAME}|${CHECKDATE}"'|'${LANPATH}'|'"$LANMAC"'|'$LANSPEED'|"$1"|""'$BOND'""|""'$ACTIVE'|""'${LANDRIVER}'||'${LANVERSION}'|'${LANSTAT}'"}' >>${ETHNET}
done
#2012-05-03 网卡信息查询
