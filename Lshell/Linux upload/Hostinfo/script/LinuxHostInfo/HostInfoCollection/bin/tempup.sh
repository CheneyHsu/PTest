#!/bin/sh
#当tempup 中有.sh时执行这个脚本。然后tar 并删除原文件

CHECKDATE=`date "+%Y-%m-%d"`
export LANG=C
TMP_PATH=../tmp
TEMPUP=/home/sysadmin/HostInfoCollection/tempup
UPDATELOG=/home/sysadmin/HostInfoCollection/file/${CHECKDATE}_update.log

cd /home/sysadmin/HostInfoCollection/tempup

for i in `ls /home/sysadmin/HostInfoCollection/tempup/*.sh`
do 

  echo "Begin Runing  $i" >>$UPDATELOG  
  echo `date` >>$UPDATELOG 
  sh $i >>$UPDATELOG   2>&1 
  echo "End "`date`  >>$UPDATELOG  
  if [ -f /home/sysadmin/HostInfoCollection/tempup/tempup.tar ];then
    echo "tar 脚本归档"   >>$UPDATELOG 
    tar rvf tempup.tar ${i} >>$UPDATELOG 2>&1 && rm ${i}  >>$UPDATELOG  2>&1
  else
    echo "tar 脚本归档"   >>$UPDATELOG 
    tar cvf tempup.tar ${i}  >>$UPDATELOG 2>&1 && rm ${i}  >>$UPDATELOG  2>&1
  fi 
done

