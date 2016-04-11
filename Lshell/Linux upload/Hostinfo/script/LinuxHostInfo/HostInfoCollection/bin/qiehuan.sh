#!/bin/sh
#保存qeihuan脚本目录
#aix,hp-unix,linux 通用脚本
#2013-08-18


CHECKDATE=`date "+%Y-%m-%d"`
if [ $HHNAME ]
then
    echo
else
    HHNAME=`hostname`
fi


cd /home/sysadmin
if [ -d qiehuan ]
then
   tar cf  /home/sysadmin/HostInfoCollection/file/${HHNAME}_${CHECKDATE}_qiehuan.tar   qiehuan
fi


