#!/bin/bash
#中国光银行服务器信息收集(开发测试主机)
#配置管理收集上传程序
#开发:lhl
#最后修改:2012-10-22

PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin:/opt/gnome/sbin:/root/bin:/usr/local/bin:/usr/bin:/usr/X11R6/bin:/bin:/usr/games:/opt/gnome/bin:/opt/kde3/bin:/usr/lib/mit/bin:/usr/lib/mit/sbin:/home/sysadmin/HostInfoCollection

export PATH
export LANG=C
export LC_ALL=C

if [ -f /home/sysadmin/HostInfoCollection/conf/hostname.conf ];then
  HHNAME=`cat /home/sysadmin/HostInfoCollection/conf/hostname.conf`
else
  HHNAME=`hostname`
fi

export HHNAME


#ftp 上传
RAVEDIRECTORY="/home/sysadmin/HostInfoCollection/file"
UPDIRECTORY="/hostinfo/hostinfo/data"    #2011-02-16 变为10.1.18.151目录
UPUSER="hostinfo"                       #2011-02-16 变
UPPASSWD="hostinfo"                     #2011-02-16 变
UPIP="10.200.8.87"                      #2011-02-16 变
CHECKDATE=`date "+%Y-%m-%d"`
UPLOG=/home/sysadmin/HostInfoCollection/file/${CHECKDATE}_Upload.log

sh /home/sysadmin/HostInfoCollection/bin/update.sh >>/home/sysadmin/HostInfoCollection/file/${CHECKDATE}_update.log 2>&1
sh /home/sysadmin/HostInfoCollection/bin/tempup.sh >>/home/sysadmin/HostInfoCollection/file/${CHECKDATE}_update.log  2>&1  &



find /home/sysadmin/HostInfoCollection/file -mtime +30 -type f  -exec rm -f {} \;
#rm /home/sysadmin/HostInfoCollection/bak/*   |tee -a $UPLOG

date +'1  Collection begin %Y-%m-%d %H:%M:%S'|tee -a $UPLOG
cd /home/sysadmin/HostInfoCollection/bin
./HostInfoCollect.sh >$RAVEDIRECTORY/${HHNAME}_${CHECKDATE}.txt 2>&1

if [ $? -ne 0 ]
  then
    echo "   InfoCollect:fail"
  else
    echo "   InfoCollect:successful"
fi

date +'2  Tar begin %Y-%m-%d %H:%M:%S'|tee -a $UPLOG
cd /home/sysadmin/HostInfoCollection

date +'3  Ftp begin %Y-%m-%d %H:%M:%S'|tee -a $UPLOG
cd ${RAVEDIRECTORY}

find /home/sysadmin/HostInfoCollection/file -type f -size 0 -exec rm -f {} \; 
ls |grep ".txt"|grep -v ${CHECKDATE} |while read i;
do 
  mv ${i} ${HHNAME}_${CHECKDATE}_${i}
done

tar cf ${HHNAME}_${CHECKDATE}.tar *${CHECKDATE}*.txt *.tar |tee -a $UPLOG && /usr/bin/gzip -f  ${HHNAME}_${CHECKDATE}.tar  |tee -a $UPLOG  && rm -f *${CHECKDATE}*.txt *.tar |tee -a $UPLOG

ftp  -v -n $UPIP <<EOF |tee -a $UPLOG
user  $UPUSER $UPPASSWD
cd $UPDIRECTORY
mput ${HHNAME}_${CHECKDATE}.tar.gz
bye |tee -a $UPLOG
EOF
date +'   Ftp finished %Y-%m-%d %H:%M:%S'|tee -a $UPLOG
if [ -f ${HHNAME}_${CHECKDATE}.tar.gz ]; then
        echo "                                               "|tee -a $UPLOG
        echo " ######     #    #    #     #     ####   #    #"|tee -a $UPLOG
        echo " #          #    ##   #     #    #       #    #"|tee -a $UPLOG
        echo " #####      #    # #  #     #     ####   ######"|tee -a $UPLOG
        echo " #          #    #  # #     #         #  #    #"|tee -a $UPLOG
        echo " #          #    #   ##     #    #    #  #    #"|tee -a $UPLOG
        echo " #          #    #    #     #     ####   #    #"|tee -a $UPLOG
        echo "                                               "|tee -a $UPLOG
        exit 0
fi
exit;


