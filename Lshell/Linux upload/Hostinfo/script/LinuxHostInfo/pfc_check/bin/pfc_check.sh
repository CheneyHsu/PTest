#!/bin/sh
#中国光大银行主机性能采集工具
#编写人员：lhl
echo "version v2.4 2014-06-15"
#增加Oracle-dba 检查

#cpu:  %usr    %sys    %wio   %idle %used
#io:    %busy   r+w/s  blks/s  avwait  avserv  avque  emc_rws  emc_blks_s
#mem:   Free  USED% swap_used%

if [ -f /home/sysadmin/HostInfoCollection/conf/hostname.conf ];then
  HHNAME=`cat /home/sysadmin/HostInfoCollection/conf/hostname.conf`
else
  HHNAME=`hostname`
fi

LANG=C
HOSTTYPE=`uname -s`
CHECKDATE=`date "+%Y-%m-%d"`
export CHECKDATE
cd /home/sysadmin/pfc_check/bin
#oracle_dba 检查项

if [ -d /home/sysadmin/check/orasql ]
then
    ./oracle_dba.sh &
fi



BIN_PATH=../bin
TMP_PATH=../tmp
FILE_PATH=../file
SAR_DBAK=../tmp/${CHECKDATE}_SARD-BAK.log   # 保留磁盘性能数据的文件

#2014-06-15 加中间件tuxedo性能采集
test -f /home/sysadmin/tuxedo_check/bin/collector.sh && /home/sysadmin/tuxedo_check/bin/collector.sh >>/home/sysadmin/pfc_check/file/pfccheck_out.txt &


#收集磁盘性能数据保留在本机tmp目录
SARDBAK()
{
  echo `date +"%Y-%m-%d %H:%M"` >>${SAR_DBAK}
  cat  ../tmp/tmp-disk-all.txt >>${SAR_DBAK}
 } 


#收集aix网卡流量信息
aixnet()
{ 
 # mondate=`date +"%Y-%m-%d %H:%M"`
  sh ./aixnet.sh  2 30 |grep Average >../tmp/tmp-net.txt
  cat ../tmp/tmp-net.txt |sort -nk 5 |tail -1 |awk '{print "'"${mondate}"' "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9}' >>../tmp/net-info.txt
 } 

#收集suse Linux网卡流量信息
linuxnet()
{
  # mondate=`date +"%Y-%m-%d %H:%M"`
  sh ./linuxnet.sh  2 30 |grep Average >../tmp/tmp-net.txt
  cat ../tmp/tmp-net.txt |sort -nk 5 |tail -1 |awk '{print "'"${mondate}"' "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9}' >>../tmp/net-info.txt
 }


UPDIRECTORY="/smdb/pfccheck/log"           #2011-02-18 变更 ftp 
LOGFILE=/home/sysadmin/pfc_check/file
UPUSER="smdb"                              #2011-02-18 变更 ftp 
UPPASSWD="smdbput"                         #2011-02-18 变更 ftp 
UPIP="10.200.8.87"                           #2011-02-18 变更 ftp 

day=`date +%R`
mondate=`date +"%Y-%m-%d %H:%M"`

case ${HOSTTYPE} in

AIX)

#收集文件系统信息2012-07-20
df -k |grep / |grep -v "/proc" |awk '{gsub (/%/,"",$4);print "'"${mondate}"'|" $1"|"$2"||"$3"|"$4"|" $NF}'>> ${TMP_PATH}/filesys-info.txt

#收集网络流量信息
aixnet >/dev/null 2>&1 &

#cpu资源使用信息 
sar -u 2 30 >${TMP_PATH}/tmp-cpu.txt 
#mondate=`date +"%Y-%m-%d %H:%M"`
usrRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $2 }' `
sysRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $3 }' `
wioRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $4 }' `
idlRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $5 }' `
CPUusedRate=`expr 100 - ${idlRate} `
echo "${mondate} ${usrRate} ${sysRate} ${wioRate} ${idlRate} ${CPUusedRate} " >> ${TMP_PATH}/cpu-info.txt
        
#io资源使用信息
sar -d 2 30 >${TMP_PATH}/tmp-disk-all.txt 

SARDBAK  #收集磁盘性能数据保留的本机tmp目录
sed -n '/Average/,$p' ${TMP_PATH}/tmp-disk-all.txt |grep  "hdiskpower" >${TMP_PATH}/tmpdisk.txt
sed -n '/Average/,$p' ${TMP_PATH}/tmp-disk-all.txt |grep  "hdisk[0,1]" >>${TMP_PATH}/tmpdisk.txt 
sed 's/Average/       /' ${TMP_PATH}/tmpdisk.txt |sort -nk 2 >${TMP_PATH}/tmp-disk.txt
#mondate=`date +"%Y-%m-%d %H:%M"`
rwRate=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $2 }' `
avque=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $3 }' `    #2011-11-24加
rwCount=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $4 }' `
rwBlock=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $5 }' `
avWait=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $6 }' `
avServ=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $7 }' `
#2012-07-19 加收集存储的io访问量和读写
eval "cat ${TMP_PATH}/tmp-disk.txt|grep hdiskpower|awk 'BEGIN{k=0;j=0}{k=k+\$4;j=j+\$5}END{print k,j}' |read m n "
CCrwCount=$m
CCrwBlock=$n

echo "${mondate} ${rwRate} ${rwCount} ${rwBlock} ${avWait} ${avServ} ${avque} ${CCrwCount} ${CCrwBlock}" >> ${TMP_PATH}/disk-info.txt


#内存资源使用信息包括交换区使用情况
svmon -G >${TMP_PATH}/tmp-mem.txt
#mondate=`date +"%Y-%m-%d %H:%M"`
usedMem=`cat ${TMP_PATH}/tmp-mem.txt |awk 'NR==2 {print $4 * 4 / 1024 }' ` 
usedMem1=`cat ${TMP_PATH}/tmp-mem.txt | awk 'NR==2 {print $6 * 100 / $2}' `
usedSwap=`lsps -s |grep -v Total |awk '{ print $2 }'|awk -F"%" '{print $1}' `
echo "${mondate} ${usedMem} ${usedMem1} ${usedSwap}" >> ${TMP_PATH}/mem-info.txt;;


HP-UX)

#ps -ef |grep "pfc_check.sh" |grep "sh -c" |grep -v grep  >>runsh.log
a=`ps -ef |grep "pfc_check.sh" |grep "sh -c" |grep -v grep |wc -l`
if [ $a -gt 1 ]
then
   echo "running"
   exit;
fi

#收集文件系统信息2012-07-20   修改时间2014-02-10
bdf|awk '/\/dev\// {print "'"${mondate}"'|"$1 "|"}' >${TMP_PATH}/tmp-filesysdev.txt
bdf|grep % |awk '/\//{gsub (/%/,"",$(NF-1));print $(NF-4)"|"$(NF-3)"|"$(NF-2)"|"$(NF-1)"|"$NF}'>${TMP_PATH}/tmp-filesys.txt
paste -d "" ${TMP_PATH}/tmp-filesysdev.txt  ${TMP_PATH}/tmp-filesys.txt >>${TMP_PATH}/filesys-info.txt

#bdf  |awk 'NR>1{if (NF>=6) {gsub(/%/,"",$(NF-1));print "'"${mondate}"'|"$1"|"$2"|"$3"|"$4"|"$5"|"$6}}' >>${TMP_PATH}/filesys-info.txt

#网络流量监控，监控流量比较大的一个网卡 2012-05-15 加
./hpnet.sh

#cpu资源使用信息 
sar -u 2 30 >${TMP_PATH}/tmp-cpu.txt 
#mondate=`date +"%Y-%m-%d %H:%M"`
usrRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $2 }' `
sysRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $3 }' `
wioRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $4 }' `
idlRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $5 }' `
tstRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $5+$4 }' `
CPUusedRate=`expr 100 - ${idlRate} `
echo "${mondate} ${usrRate} ${sysRate} ${wioRate} ${idlRate} ${CPUusedRate} " >> ${TMP_PATH}/cpu-info.txt
        
#io资源使用信息
sar -d 2 30 >${TMP_PATH}/tmp-disk-all.txt 
SARDBAK  #收集磁盘性能数据保留的本机tmp目录

cat ${TMP_PATH}/tmp-disk-all.txt |grep Average |sort -nk 3 > ${TMP_PATH}/tmp-disk.txt
#mondate=`date +"%Y-%m-%d %H:%M"`

rwRate=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $3 }' `
avque=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $4 }' `   #2011-11-24加
rwCount=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $5 }' `
rwBlock=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $6 }' `
avWait=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $7 }' `
avServ=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $8 }' `

##2012-07-19 加收集存储的io访问量和读写
grep_v_info=" "
vgdisplay -v vg00|grep "PV Name"|awk '{print $3}'|sed "s/\/dev\/dsk\///g" > ${TMP_PATH}/vg_path.txt
for vg_path in `cat ${TMP_PATH}/vg_path.txt `
do
   a=$((${#vg_path} -1 ))
   an=`echo ${vg_path} |cut -c $a`
   if [ $an = s ]
   then
   vg_path=${vg_path%s*}
   fi
  grep_v_info=${grep_v_info}"|grep -v "${vg_path}
done
eval "cat ${TMP_PATH}/tmp-disk.txt|grep -v disk $grep_v_info|awk 'BEGIN{k=0;j=0}{k=k+\$5;j=j+\$6}END{print k,j}' |read m n "
CCrwCount=$m
CCrwBlock=`expr $n / 2`

#echo "${mondate} ${rwRate} ${rwCount} ${rwBlock} ${avWait} ${avServ} ${avque}" >>  ${TMP_PATH}/disk-info.txt
echo "${mondate} ${rwRate} ${rwCount} ${rwBlock} ${avWait} ${avServ} ${avque} ${CCrwCount} ${CCrwBlock}" >>  ${TMP_PATH}/disk-info.txt
           
#内存资源使用信息 2012-10-01 替换
#MEM=`/opt/ignite/bin/print_manifest 2>&1 | grep "Main Memory" |awk '{print $(NF-1)}'`
#20121207 修改 由于swapinfo -mt 中内存数据查询的有误差
if [ `model|cut -c 1-2` = ia ]                                         #判断是ia还是PA
then
	if [ `uname -r` = "B.11.31" ]
	then
	    MEM=`/usr/contrib/bin/machinfo|awk ' /^Memory/ {print $2}'`
    else
	    MEM=`/usr/contrib/bin/machinfo|awk ' /^Memory/ {print $3}'`
    fi	 
else	
      MEM=`swapinfo -mt |awk '/^memory/ {print $2}'`
fi	  


vmstat 1 1 >${TMP_PATH}/tmp-mem.txt
#mondate=`date +"%Y-%m-%d %H:%M"`
usedMem=`tail -1 ${TMP_PATH}/tmp-mem.txt |awk '{ print $5 }' `
usedMem=`expr $usedMem \* 4 / 1024 `
usedMem1=`expr 100 - $usedMem \* 100 / $MEM `
#swapinfo -at >${TMP_PATH}/tmp-swap.txt         #20121207修改
#usedSwap=`tail -1 ${TMP_PATH}/tmp-swap.txt |awk '{ print $5 }' `   #20121207修改 
usedSwap=`swapinfo -mt |tail -1 |awk '{print $5}'|sed 's/%//g'`     #20121207修改 
echo "${mondate} ${usedMem} ${usedMem1}  ${usedSwap} " >> ${TMP_PATH}/mem-info.txt;;

Linux)
#ps -ef |grep "pfc_check.sh" |grep "sh -c" |grep -v grep  >>runsh.log
a=`ps -ef |grep "pfc_check.sh" |grep "sh -c" |grep -v grep |wc -l`
if [ $a -gt 1 ]
then
   echo "running"
   exit;
fi

#文件系统信息 2012-07-20
#df -k |grep -v "^udev"|awk '/\/dev\// {print "'"${mondate}"'|"$1 "|"}' >${TMP_PATH}/tmp-filesysdev.txt
#df -k |grep -v "^udev" | grep % |awk '/\//{gsub (/%/,"",$(NF-1));print $(NF-4)"|"$(NF-3)"|"$(NF-2)"|"$(NF-1)"|"$NF}' >${TMP_PATH}/tmp-filesys.txt
#paste  ${TMP_PATH}/tmp-filesysdev.txt  ${TMP_PATH}/tmp-filesys.txt >>${TMP_PATH}/filesys-info.txt
df -Pk |grep -v ^Filesystem |awk '{gsub (/%/,"",$(NF-1));print "'"${mondate}|"'"$1"|"$2"|"$3"|"$4"|"$5"|"$6}'>>${TMP_PATH}/filesys-info.txt

#收集网络流量信息
linuxnet >/dev/null 2>&1 &

#cpu资源使用信息
sar -u 2 30 >${TMP_PATH}/tmp-cpu.txt
#mondate=`date +"%Y-%m-%d %H:%M"`
usrRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $3 }' `
sysRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $5 }' `
wioRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $6 }' `
idlRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $NF }' `   #2011-08-12 改为NF 解决老版本查不出CPU使用百分比的问题
CPUusedRate=`expr 100 - ${idlRate%.*}`
echo "${mondate} ${usrRate} ${sysRate} ${wioRate} ${idlRate} ${CPUusedRate} " >> ${TMP_PATH}/cpu-info.txt

sar -d 2 30 >${TMP_PATH}/tmp-disk-all.txt
SARDBAK  #收集磁盘性能数据保留的本机tmp目录
cat ${TMP_PATH}/tmp-disk-all.txt |grep Average |sort -nk 10 > ${TMP_PATH}/tmp-disk.txt
#mondate=`date +"%Y-%m-%d %H:%M"`
rwRate=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $10 }' `
rwCount=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $3 }' `
rwBlock=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $4+$5 }' `
avque=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $7 }' `   #2011-11-24加
avWait=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $8 }' `
avServ=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $9 }' `

#2012-07-25 添加EMC存储的io访问量和读写。
CCrwCount=`cat ${TMP_PATH}/tmp-disk.txt|grep "dev120-" |awk 'BEGIN{k=0;}{k=k+$3}END{print k}'`
CCrwBlock=`cat ${TMP_PATH}/tmp-disk.txt|grep "dev120-" |awk 'BEGIN{k=0;}{k=k+($4+$5)}END{print k}'`
echo "${mondate} ${rwRate} ${rwCount:-"0"} ${rwBlock:-"0"} ${avWait:-"0"} ${avServ:-"0"} ${avque:-"0"} $CCrwCount $CCrwBlock" >> ${TMP_PATH}/disk-info.txt
#echo "${mondate} ${rwRate} ${rwCount:-null} ${rwBlock:-null} ${avWait:-null} ${avServ:-null} ${avque:-null}" >> ${TMP_PATH}/disk-info.txt


#内存资源使用信息
free -m >${TMP_PATH}/tmp-mem.txt
#mondate=`date +"%Y-%m-%d %H:%M"`
freeMem=`awk 'NR==2 {print $4 + $6 + $7}' ${TMP_PATH}/tmp-mem.txt`
usedMem1=`awk 'NR==2 {print $3 - $6 - $7}' ${TMP_PATH}/tmp-mem.txt`
totalMem=`awk 'NR==2 {print $2}' ${TMP_PATH}/tmp-mem.txt`
usedMem=`expr $usedMem1 \* 100 / $totalMem `
swapused=`awk 'NR==4 {print $3 }' ${TMP_PATH}/tmp-mem.txt`
swaptotal=`awk 'NR==4 {print $2 }' ${TMP_PATH}/tmp-mem.txt`
usedSwap=`expr $swapused \* 100 / $swaptotal `
echo "${mondate} ${freeMem} ${usedMem} ${usedSwap} " >> ${TMP_PATH}/mem-info.txt;;

*)
echo "Input error";;
esac


#每天7:00归档一次
#2012-05-15加一个net-info.txt归档 
if [ ${day} = "07:00" ]; then
        cp ${TMP_PATH}/cpu-info.txt  ../file/${HHNAME}_${CHECKDATE}_cpu-info.txt
        >${TMP_PATH}/cpu-info.txt
        cp ${TMP_PATH}/disk-info.txt ../file/${HHNAME}_${CHECKDATE}_disk-info.txt
        >${TMP_PATH}/disk-info.txt
        cp ${TMP_PATH}/mem-info.txt ../file/${HHNAME}_${CHECKDATE}_mem-info.txt
        >${TMP_PATH}/mem-info.txt
		cp ${TMP_PATH}/net-info.txt ../file/${HHNAME}_${CHECKDATE}_net-info.txt
        >${TMP_PATH}/net-info.txt
		cp ${TMP_PATH}/filesys-info.txt ../file/${HHNAME}_${CHECKDATE}_filesys-info.txt
        >${TMP_PATH}/filesys-info.txt
				
find /home/sysadmin/pfc_check/file -mtime +31 -type f -name "*.txt" -exec rm -f {} \;     #删除一月前本地的性能数据
find /home/sysadmin/pfc_check/tmp -mtime +0 -type f -name "*SARD-BAK.log" -exec rm -f {} \;   #删除一周天前备份的磁盘性能数据

#ftp上传文件到106.20服务器
##cd ${LOGFILE}
##date >${LOGFILE}/ftp.log
##ftp -v -n $UPIP <<EOF  |tee -a ${LOGFILE}/ftp.log
##user  $UPUSER $UPPASSWD
##prompt off
##cd $UPDIRECTORY
##mput ${HHNAME}_${CHECKDATE}*.txt
##bye |tee -a ${LOGFILE}/ftp.log
##EOF

lognumber=$(ls /home/sysadmin/tuxedo_check/data/*.log |wc -l)
if [ $lognumber -eq 0 ];then
cd ${LOGFILE}
date >${LOGFILE}/ftp.log
ftp -v -n $UPIP <<EOF  |tee -a ${LOGFILE}/ftp.log
user  $UPUSER $UPPASSWD
prompt off
cd $UPDIRECTORY
mput ${HHNAME}_${CHECKDATE}*.txt
bye |tee -a ${LOGFILE}/ftp.log
EOF

else

cd ${LOGFILE}
date >${LOGFILE}/ftp.log
ftp -v -n $UPIP <<EOF  |tee -a ${LOGFILE}/ftp.log
user  $UPUSER $UPPASSWD
prompt off
cd $UPDIRECTORY
mput ${HHNAME}_${CHECKDATE}*.txt

lcd /home/sysadmin/tuxedo_check/data/
mput *.log
bye |tee -a ${LOGFILE}/ftp.log
EOF
rm -f /home/sysadmin/tuxedo_check/data/*.log
fi

fi

#检查上次上传结果，如果有没成功的再次上传
if [ ${day} = "07:20" ]; then
a=`grep "Transfer complete" ${LOGFILE}/ftp.log |wc -l`
if [ $a -lt 2 ];then
cd ${LOGFILE}
date >${LOGFILE}/ftp.log
ftp -v -n $UPIP <<EOF  |tee -a ${LOGFILE}/ftp.log
user  $UPUSER $UPPASSWD
prompt off
cd $UPDIRECTORY
mput ${HHNAME}_${CHECKDATE}*.txt
bye |tee -a ${LOGFILE}/ftp.log
EOF
fi
fi




