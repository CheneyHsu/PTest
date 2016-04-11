#!/bin/sh
#�й���������������ܲɼ�����
#��д��Ա��lhl
echo "version v2.4 2014-06-15"
#����Oracle-dba ���

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
#oracle_dba �����

if [ -d /home/sysadmin/check/orasql ]
then
    ./oracle_dba.sh &
fi



BIN_PATH=../bin
TMP_PATH=../tmp
FILE_PATH=../file
SAR_DBAK=../tmp/${CHECKDATE}_SARD-BAK.log   # ���������������ݵ��ļ�

#2014-06-15 ���м��tuxedo���ܲɼ�
test -f /home/sysadmin/tuxedo_check/bin/collector.sh && /home/sysadmin/tuxedo_check/bin/collector.sh >>/home/sysadmin/pfc_check/file/pfccheck_out.txt &


#�ռ������������ݱ����ڱ���tmpĿ¼
SARDBAK()
{
  echo `date +"%Y-%m-%d %H:%M"` >>${SAR_DBAK}
  cat  ../tmp/tmp-disk-all.txt >>${SAR_DBAK}
 } 


#�ռ�aix����������Ϣ
aixnet()
{ 
 # mondate=`date +"%Y-%m-%d %H:%M"`
  sh ./aixnet.sh  2 30 |grep Average >../tmp/tmp-net.txt
  cat ../tmp/tmp-net.txt |sort -nk 5 |tail -1 |awk '{print "'"${mondate}"' "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9}' >>../tmp/net-info.txt
 } 

#�ռ�suse Linux����������Ϣ
linuxnet()
{
  # mondate=`date +"%Y-%m-%d %H:%M"`
  sh ./linuxnet.sh  2 30 |grep Average >../tmp/tmp-net.txt
  cat ../tmp/tmp-net.txt |sort -nk 5 |tail -1 |awk '{print "'"${mondate}"' "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9}' >>../tmp/net-info.txt
 }


UPDIRECTORY="/smdb/pfccheck/log"           #2011-02-18 ��� ftp 
LOGFILE=/home/sysadmin/pfc_check/file
UPUSER="smdb"                              #2011-02-18 ��� ftp 
UPPASSWD="smdbput"                         #2011-02-18 ��� ftp 
UPIP="10.200.8.87"                           #2011-02-18 ��� ftp 

day=`date +%R`
mondate=`date +"%Y-%m-%d %H:%M"`

case ${HOSTTYPE} in

AIX)

#�ռ��ļ�ϵͳ��Ϣ2012-07-20
df -k |grep / |grep -v "/proc" |awk '{gsub (/%/,"",$4);print "'"${mondate}"'|" $1"|"$2"||"$3"|"$4"|" $NF}'>> ${TMP_PATH}/filesys-info.txt

#�ռ�����������Ϣ
aixnet >/dev/null 2>&1 &

#cpu��Դʹ����Ϣ 
sar -u 2 30 >${TMP_PATH}/tmp-cpu.txt 
#mondate=`date +"%Y-%m-%d %H:%M"`
usrRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $2 }' `
sysRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $3 }' `
wioRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $4 }' `
idlRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $5 }' `
CPUusedRate=`expr 100 - ${idlRate} `
echo "${mondate} ${usrRate} ${sysRate} ${wioRate} ${idlRate} ${CPUusedRate} " >> ${TMP_PATH}/cpu-info.txt
        
#io��Դʹ����Ϣ
sar -d 2 30 >${TMP_PATH}/tmp-disk-all.txt 

SARDBAK  #�ռ������������ݱ����ı���tmpĿ¼
sed -n '/Average/,$p' ${TMP_PATH}/tmp-disk-all.txt |grep  "hdiskpower" >${TMP_PATH}/tmpdisk.txt
sed -n '/Average/,$p' ${TMP_PATH}/tmp-disk-all.txt |grep  "hdisk[0,1]" >>${TMP_PATH}/tmpdisk.txt 
sed 's/Average/       /' ${TMP_PATH}/tmpdisk.txt |sort -nk 2 >${TMP_PATH}/tmp-disk.txt
#mondate=`date +"%Y-%m-%d %H:%M"`
rwRate=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $2 }' `
avque=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $3 }' `    #2011-11-24��
rwCount=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $4 }' `
rwBlock=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $5 }' `
avWait=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $6 }' `
avServ=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $7 }' `
#2012-07-19 ���ռ��洢��io�������Ͷ�д
eval "cat ${TMP_PATH}/tmp-disk.txt|grep hdiskpower|awk 'BEGIN{k=0;j=0}{k=k+\$4;j=j+\$5}END{print k,j}' |read m n "
CCrwCount=$m
CCrwBlock=$n

echo "${mondate} ${rwRate} ${rwCount} ${rwBlock} ${avWait} ${avServ} ${avque} ${CCrwCount} ${CCrwBlock}" >> ${TMP_PATH}/disk-info.txt


#�ڴ���Դʹ����Ϣ����������ʹ�����
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

#�ռ��ļ�ϵͳ��Ϣ2012-07-20   �޸�ʱ��2014-02-10
bdf|awk '/\/dev\// {print "'"${mondate}"'|"$1 "|"}' >${TMP_PATH}/tmp-filesysdev.txt
bdf|grep % |awk '/\//{gsub (/%/,"",$(NF-1));print $(NF-4)"|"$(NF-3)"|"$(NF-2)"|"$(NF-1)"|"$NF}'>${TMP_PATH}/tmp-filesys.txt
paste -d "" ${TMP_PATH}/tmp-filesysdev.txt  ${TMP_PATH}/tmp-filesys.txt >>${TMP_PATH}/filesys-info.txt

#bdf  |awk 'NR>1{if (NF>=6) {gsub(/%/,"",$(NF-1));print "'"${mondate}"'|"$1"|"$2"|"$3"|"$4"|"$5"|"$6}}' >>${TMP_PATH}/filesys-info.txt

#����������أ���������Ƚϴ��һ������ 2012-05-15 ��
./hpnet.sh

#cpu��Դʹ����Ϣ 
sar -u 2 30 >${TMP_PATH}/tmp-cpu.txt 
#mondate=`date +"%Y-%m-%d %H:%M"`
usrRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $2 }' `
sysRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $3 }' `
wioRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $4 }' `
idlRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $5 }' `
tstRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $5+$4 }' `
CPUusedRate=`expr 100 - ${idlRate} `
echo "${mondate} ${usrRate} ${sysRate} ${wioRate} ${idlRate} ${CPUusedRate} " >> ${TMP_PATH}/cpu-info.txt
        
#io��Դʹ����Ϣ
sar -d 2 30 >${TMP_PATH}/tmp-disk-all.txt 
SARDBAK  #�ռ������������ݱ����ı���tmpĿ¼

cat ${TMP_PATH}/tmp-disk-all.txt |grep Average |sort -nk 3 > ${TMP_PATH}/tmp-disk.txt
#mondate=`date +"%Y-%m-%d %H:%M"`

rwRate=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $3 }' `
avque=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $4 }' `   #2011-11-24��
rwCount=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $5 }' `
rwBlock=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $6 }' `
avWait=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $7 }' `
avServ=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $8 }' `

##2012-07-19 ���ռ��洢��io�������Ͷ�д
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
           
#�ڴ���Դʹ����Ϣ 2012-10-01 �滻
#MEM=`/opt/ignite/bin/print_manifest 2>&1 | grep "Main Memory" |awk '{print $(NF-1)}'`
#20121207 �޸� ����swapinfo -mt ���ڴ����ݲ�ѯ�������
if [ `model|cut -c 1-2` = ia ]                                         #�ж���ia����PA
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
#swapinfo -at >${TMP_PATH}/tmp-swap.txt         #20121207�޸�
#usedSwap=`tail -1 ${TMP_PATH}/tmp-swap.txt |awk '{ print $5 }' `   #20121207�޸� 
usedSwap=`swapinfo -mt |tail -1 |awk '{print $5}'|sed 's/%//g'`     #20121207�޸� 
echo "${mondate} ${usedMem} ${usedMem1}  ${usedSwap} " >> ${TMP_PATH}/mem-info.txt;;

Linux)
#ps -ef |grep "pfc_check.sh" |grep "sh -c" |grep -v grep  >>runsh.log
a=`ps -ef |grep "pfc_check.sh" |grep "sh -c" |grep -v grep |wc -l`
if [ $a -gt 1 ]
then
   echo "running"
   exit;
fi

#�ļ�ϵͳ��Ϣ 2012-07-20
#df -k |grep -v "^udev"|awk '/\/dev\// {print "'"${mondate}"'|"$1 "|"}' >${TMP_PATH}/tmp-filesysdev.txt
#df -k |grep -v "^udev" | grep % |awk '/\//{gsub (/%/,"",$(NF-1));print $(NF-4)"|"$(NF-3)"|"$(NF-2)"|"$(NF-1)"|"$NF}' >${TMP_PATH}/tmp-filesys.txt
#paste  ${TMP_PATH}/tmp-filesysdev.txt  ${TMP_PATH}/tmp-filesys.txt >>${TMP_PATH}/filesys-info.txt
df -Pk |grep -v ^Filesystem |awk '{gsub (/%/,"",$(NF-1));print "'"${mondate}|"'"$1"|"$2"|"$3"|"$4"|"$5"|"$6}'>>${TMP_PATH}/filesys-info.txt

#�ռ�����������Ϣ
linuxnet >/dev/null 2>&1 &

#cpu��Դʹ����Ϣ
sar -u 2 30 >${TMP_PATH}/tmp-cpu.txt
#mondate=`date +"%Y-%m-%d %H:%M"`
usrRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $3 }' `
sysRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $5 }' `
wioRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $6 }' `
idlRate=`tail -1 ${TMP_PATH}/tmp-cpu.txt |awk '{ print $NF }' `   #2011-08-12 ��ΪNF ����ϰ汾�鲻��CPUʹ�ðٷֱȵ�����
CPUusedRate=`expr 100 - ${idlRate%.*}`
echo "${mondate} ${usrRate} ${sysRate} ${wioRate} ${idlRate} ${CPUusedRate} " >> ${TMP_PATH}/cpu-info.txt

sar -d 2 30 >${TMP_PATH}/tmp-disk-all.txt
SARDBAK  #�ռ������������ݱ����ı���tmpĿ¼
cat ${TMP_PATH}/tmp-disk-all.txt |grep Average |sort -nk 10 > ${TMP_PATH}/tmp-disk.txt
#mondate=`date +"%Y-%m-%d %H:%M"`
rwRate=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $10 }' `
rwCount=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $3 }' `
rwBlock=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $4+$5 }' `
avque=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $7 }' `   #2011-11-24��
avWait=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $8 }' `
avServ=`tail -1 ${TMP_PATH}/tmp-disk.txt |awk '{ print $9 }' `

#2012-07-25 ���EMC�洢��io�������Ͷ�д��
CCrwCount=`cat ${TMP_PATH}/tmp-disk.txt|grep "dev120-" |awk 'BEGIN{k=0;}{k=k+$3}END{print k}'`
CCrwBlock=`cat ${TMP_PATH}/tmp-disk.txt|grep "dev120-" |awk 'BEGIN{k=0;}{k=k+($4+$5)}END{print k}'`
echo "${mondate} ${rwRate} ${rwCount:-"0"} ${rwBlock:-"0"} ${avWait:-"0"} ${avServ:-"0"} ${avque:-"0"} $CCrwCount $CCrwBlock" >> ${TMP_PATH}/disk-info.txt
#echo "${mondate} ${rwRate} ${rwCount:-null} ${rwBlock:-null} ${avWait:-null} ${avServ:-null} ${avque:-null}" >> ${TMP_PATH}/disk-info.txt


#�ڴ���Դʹ����Ϣ
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


#ÿ��7:00�鵵һ��
#2012-05-15��һ��net-info.txt�鵵 
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
				
find /home/sysadmin/pfc_check/file -mtime +31 -type f -name "*.txt" -exec rm -f {} \;     #ɾ��һ��ǰ���ص���������
find /home/sysadmin/pfc_check/tmp -mtime +0 -type f -name "*SARD-BAK.log" -exec rm -f {} \;   #ɾ��һ����ǰ���ݵĴ�����������

#ftp�ϴ��ļ���106.20������
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

#����ϴ��ϴ�����������û�ɹ����ٴ��ϴ�
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




