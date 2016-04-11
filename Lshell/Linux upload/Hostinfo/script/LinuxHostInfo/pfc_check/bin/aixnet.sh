#!/usr/bin/ksh
#�鿴������������ AIX
# eth   inbyte/s  outbyte/s totalbyte/s inpacket/s outpacket/s SpeedMb/s    Used%
#version cebv1.1 2012-05-15
#�ű������ lsdev,lscfg,entstat��ϵͳ����


#������bond�����ж�
#date 2011-12-08
#date 2011-12-30 �������ǰ������ʱ���������⡣
#date 2011-12-31 ��ȥ�˳���������ʹ�õ�cpuʱ�䣬�����׼ȷ��

#1.�жϲ�������
if [ $# -ne 2 ];then
   echo Useage : $0 interval count
   echo Example: $0  2 10
   echo "�鿴����������������Ϣ"
   exit
fi
interval=$1
count=$2


#2. �жϿ��õ����������ʰ���bond����
cat /dev/null >../tmp/ethspeed.txt   #��մ��������Ϣ���ļ�
deveth=$(lsdev -Cc if | grep Available |grep -v lo0 |awk '{print $1}')    # dev �е�������Ϣ
for eth in $deveth
do 
      # #��������������
	  NETSPEED=$(entstat -d ${eth} |awk '/Speed Running/ {print $4}'|head -1)
 # NETSPEED=$(echo $(ethtool ${eth} |grep -ie Speed -ie detected) |awk '{if ($NF~/yes/) print $2}')  
     if [ $NETSPEED ];then
     echo $eth"  "$NETSPEED >>../tmp/ethspeed.txt
     fi

done   


#1.�ռ�����
#2.ʱ����
#3.ƽ��ʹ��
#123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
     echo "            eth   inbyte/s  outbyte/s totalbyte/s inpacket/s outpacket/s SpeedMb/s    Used%"

#�ռ�����
 
r=0
while [ "$r" -lt "$count" ]
do
#  cat ../tmp/ethspeed.txt  |while  read i
 while  read i
 do
    eth=$(echo ${i} |awk '{print $1}')
    eval \ ${eth}inbyte1=$(entstat ${eth} |awk '/^Bytes:/ {print $4}')     #�����ֽ�
    eval \ ${eth}outbyte1=$(entstat ${eth} |awk '/^Bytes:/ {print $2}')   #�����ֽ�
    eval \ ${eth}inpacket1=$(entstat ${eth} |awk '/^Packets:/ {print $4}')    #�������ݰ�
    eval \ ${eth}outpacket1=$(entstat ${eth} |awk '/^Packets:/ {print $2}')   #�������ݰ�

 done <../tmp/ethspeed.txt
 
#netcount=`cat <../tmp/ethspeed.txt |wc -l`
#countdate=`echo $interval-$netcount*0.075|bc`
sleep $interval
#sleep $countdate
cydate=$(date '+%T')
 while  read i
  do
    eth=$(echo ${i} |awk '{print $1}')
    eval \ ${eth}speed=$(echo ${i} |awk '{print $2}')
    eval \ ${eth}inbyte2=$(entstat ${eth} |awk '/^Bytes:/ {print $4}')     #�����ֽ�
    eval \ ${eth}outbyte2=$(entstat ${eth} |awk '/^Bytes:/ {print $2}')   #�����ֽ�
    eval \ ${eth}inpacket2=$(entstat ${eth} |awk '/^Packets:/ {print $4}')   #�������ݰ�
    eval \ ${eth}outpacket2=$(entstat ${eth} |awk '/^Packets:/ {print $2}')    #�������ݰ�   
 
   
    eval \ ${eth}inbyte=$((${eth}inbyte2-${eth}inbyte1))                             # ��һ��ʱ���� �����ֽ�
    eval \ ${eth}outbyte=$((${eth}outbyte2-${eth}outbyte1))                            # ��һ��ʱ���� �����ֽ�
    eval \ ${eth}inpacket=$((${eth}inpacket2-${eth}inpacket1))                          # ��һ��ʱ���� �������ݰ�
    eval \ ${eth}outpacket=$((${eth}outpacket2-${eth}outpacket1))                          # ��һ��ʱ���� �������ݰ�

    eval \ ${eth}inbyte=$((${eth}inbyte/$interval))                              #ƽ��ÿ��   �����ֽ�
    eval \ ${eth}outbyte=$((${eth}outbyte/$interval))                            #ƽ��ÿ��   �����ֽ�
    eval \ ${eth}inpacket=$((${eth}inpacket/$interval))                          #ƽ��ÿ��   �������ݰ�
    eval \ ${eth}outpacket=$((${eth}outpacket/$interval))                        #ƽ��ÿ��   �������ݰ�
	
	eval \ ${eth}totalbyte=$((${eth}inbyte+${eth}outbyte))       #�����������
	
#   eval \ ${eth}total=$((($inbyte+$outbyte)*8/1024/1024*100/1000))
    eval \ ${eth}total=$(((${eth}inbyte+${eth}outbyte)*8/1024/1024*100/1000))     #  ����ʹ�ðٷֱ�
#eval \ ${eth}inbye=$(($(($eth$inbye))+$inbyte))                          
#  inbye=$(($inbye+$inbyte))                          
#  outbyte=$(($outbyte+$outbyte))                            
#  inpacket=$(($inpacket+$inpacket))                          
#  outpacket=$(($outpacke+$outpacket))                        
#printf "%-10s%5s%10s%10s%10s%10s%10s\n" "$(date '+%T')" $eth  $inbyte $outbyte $inpacket $outpacket $speed $total
#eval printf "%-10s%5s%11s%11s%11s%11s%10s%10s\n" "$(date '+%T')" ${eth}eth  ${eth}inbyte ${eth}outbyte ${eth}inpacket ${eth}outpacket ${eth}speed ${eth}total
    eval \ echo  $cydate  ${eth}  $((${eth}inbyte)) $((${eth}outbyte)) $((${eth}totalbyte))  $((${eth}inpacket))  $((${eth}outpacket)) $((${eth}speed)) $((${eth}total)) | awk '{printf("%-10s%5s%11s%11s%11s%11s%11s%10s%10s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9)}' 
#   echo "$(date '+%T')  $eth   $inbyte   $outbyte   $inpacket   $outpacket  $speed  $total" 
#�˴�ʹ����let
    eval let ${eth}tintbyte=\$${eth}tintbyte+\$${eth}inbyte               # �����ֽ�����֮��               
    eval let ${eth}toutbyte=\$${eth}toutbyte+\$${eth}outbyte               # �����ֽ�����֮��               
    eval let ${eth}tinpacket=\$${eth}tinpacket+\$${eth}inpacket           # �������ݰ�֮��	
    eval let ${eth}toutpacket=\$${eth}toutpacket+\$${eth}outpacket         # �������ݰ�֮��               
    eval let ${eth}tused=\$${eth}tused+\$${eth}total                       # ����ʹ�ðٷֱ�֮��
    eval let ${eth}ttotalbyte=\$${eth}ttotalbyte+\$${eth}totalbyte                       # �շ�����֮��
   done  <../tmp/ethspeed.txt
   
    r=$(($r+1))	
	echo " "

 done 

   
     while  read h
     do
       eth=$(echo ${h} |awk '{print $1}')            
       netspeed=$(echo ${h} |awk '{print $2}') 	
   #  eval echo "Average:  ${eth}      $((${eth}inbyte))  $((${eth}outbyte))  $((${eth}inpacket))  $((${eth}outpacket))"
 eval echo "Average:  ${eth}  $((${eth}tintbyte/$r))    $((${eth}toutbyte/$r)) $((${eth}ttotalbyte/$r))  $((${eth}tinpacket/$r))  $((${eth}toutpacket/$r)) $netspeed $((${eth}tused/$r))" | awk '{printf("%-10s%5s%11s%11s%11s%11s%11s%10s%10s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9)}' 
# eval echo "Average:  ${eth}     $(($((${eth}tinbyte))/$r)) $(($((${eth}toutbyte))/$r)) $(($((${eth}ttotalbyte))/$r))  $(($((${eth}tinpacket))/$r))  $(($((${eth}toutpacket))/$r)) $netspeed $((${eth}tused/$r))" | awk '{printf("%-10s%5s%11s%11s%11s%11s%11s%10s%10s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9)}' 
     done <../tmp/ethspeed.txt  
