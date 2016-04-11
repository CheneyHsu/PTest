#!/bin/bash
#查看网卡流量工具 Suse Linux


#包括bond网卡的流量，网卡发送接收字节，发送接收数据包，网卡速率，网卡使用百分比。
#版权：cebbank
#Version cebv1.1 2012-05-24



#2012-07-19加 解决以前通过ifconfig 中查到备用网卡时，速率为空的问题
#bond 有重复的报错问题解决20120524
#加入了bond网卡判断
#date 2011-12-08
#date 2011-12-30 解决了以前多网卡时间算错的问题。
#date 2011-12-31 减去了程序自身所使用的cpu时间，计算更准确。


#1.判断参数个数
if [ $# -ne 2 ];then
   echo Useage : $0 interval count
   echo Example: $0  2 10
   echo "查看所有网卡的流量信息"
   exit
fi
interval=$1
count=$2

export PATH=$PATH:/usr/sbin:/sbin:
#2. 判断可用的网卡和速率包括bond网卡
cat /dev/null >../tmp/ethspeed.txt   #清空存放网卡信息的文件
deveth=$(cat /proc/net/dev |awk -F: '{if($1~/eth|bond/) print $1}'|awk '{print $NF}')    # dev 中的网卡信息
for eth in $deveth
do 
   echo $eth |grep -q bond
   if [ $? = 0 ]
   then 
      # bond网卡的速率

     ifconfig |grep -wq ${eth}
	 if [ $? -eq 0 ]
	 then	 
     #NETSPEED=$(ethtool $(ifconfig |grep $(ifconfig |grep "${eth} " |awk '{print $NF}')|awk 'END {print $1}')|awk '/Speed/ {print $NF}')
	 NETSPEED=`ethtool $(cat /proc/net/bonding/$eth |grep "Currently Active"|awk '{print $NF}')|awk '/Speed/ {print $NF}'`    #2012-07-19加 解决以前通过ifconfig 中查到备用网卡时，速率为空的问题
     echo $eth"  "$NETSPEED >>../tmp/ethspeed.txt
	 fi 
   else 
      # #可用网卡的速率
     NETSPEED=$(echo $(ethtool ${eth} |grep -ie Speed -ie detected) |awk '{if ($NF~/yes/) print $2}')  
	 echo ${NETSPEED}  |grep -q [0-9][0-9]
     if [ $? -eq 0 ];then
     echo $eth"  "$NETSPEED >>../tmp/ethspeed.txt
     fi
   fi
done   


#1.收集次数
#2.时间间隔
#3.平均使用
#123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
     echo "            eth   inbyte/s  outbyte/s totalbyte/s inpacket/s outpacket/s SpeedMb/s    Used%"

#收集次数
 
r=0
while [ "$r" -lt "$count" ]
do
#  cat ../tmp/ethspeed.txt  |while  read i
 while  read i
 do
    eth=$(echo ${i} |awk '{print $1}')
    #speed=$(echo ${i} |awk '{print $2}'|grep -o '[0-9]*') 
    eval \ ${eth}inbyte1=$(cat /proc/net/dev |tr ':' ' '|grep -w $eth |awk '{print $2}')     #接收字节
    eval \ ${eth}outbyte1=$(cat /proc/net/dev |tr ':' ' '|grep -w $eth |awk '{print $10}')   #发送字节
    eval \ ${eth}inpacket1=$(cat /proc/net/dev |tr ':' ' '|grep -w $eth |awk '{print $3}')    #接收数据包
    eval \ ${eth}outpacket1=$(cat /proc/net/dev |tr ':' ' '|grep -w $eth |awk '{print $11}')   #发送数据包

 done <../tmp/ethspeed.txt
 
netcount=`cat <../tmp/ethspeed.txt |wc -l`
countdate=`echo $interval-$netcount*0.075|bc`
#sleep $interval
sleep $countdate
cydate=$(date '+%T')
 while  read i
  do
    eth=$(echo ${i} |awk '{print $1}')
    eval \ ${eth}speed=$(echo ${i} |awk '{print $2}'|grep -o '[0-9]*')
    eval \ ${eth}inbyte2=$(cat /proc/net/dev |tr ':' ' '|grep -w $eth |awk '{print $2}')     #接收字节
    eval \ ${eth}outbyte2=$(cat /proc/net/dev |tr ':' ' '|grep -w $eth |awk '{print $10}')   #发送字节
    eval \ ${eth}inpacket2=$(cat /proc/net/dev |tr ':' ' '|grep -w $eth |awk '{print $3}')    #接收数据包
    eval \ ${eth}outpacket2=$(cat /proc/net/dev |tr ':' ' '|grep -w $eth |awk '{print $11}')   #发送数据包   
 
   
    eval \ ${eth}inbyte=$((${eth}inbyte2-${eth}inbyte1))                             # 这一段时间内 接收字节
    eval \ ${eth}outbyte=$((${eth}outbyte2-${eth}outbyte1))                            # 这一段时间内 发送字节
    eval \ ${eth}inpacket=$((${eth}inpacket2-${eth}inpacket1))                          # 这一段时间内 接收数据包
    eval \ ${eth}outpacket=$((${eth}outpacket2-${eth}outpacket1))                          # 这一段时间内 发送数据包

    eval \ ${eth}inbyte=$((${eth}inbyte/$interval))                              #平均每秒   接收字节
    eval \ ${eth}outbyte=$((${eth}outbyte/$interval))                            #平均每秒   发送字节
    eval \ ${eth}inpacket=$((${eth}inpacket/$interval))                          #平均每秒   接收数据包
    eval \ ${eth}outpacket=$((${eth}outpacket/$interval))                        #平均每秒   发送数据包
	
	eval \ ${eth}totalbyte=$((${eth}inbyte+${eth}outbyte))       #输入输出流量
	
#   eval \ ${eth}total=$((($inbyte+$outbyte)*8/1024/1024*100/1000))
    eval \ ${eth}total=$(((${eth}inbyte+${eth}outbyte)*8/1024/1024*100/1000))     #  网卡使用百分比
#eval \ ${eth}inbye=$(($(($eth$inbye))+$inbyte))                          
#  inbye=$(($inbye+$inbyte))                          
#  outbyte=$(($outbyte+$outbyte))                            
#  inpacket=$(($inpacket+$inpacket))                          
#  outpacket=$(($outpacke+$outpacket))                        
#printf "%-10s%5s%10s%10s%10s%10s%10s\n" "$(date '+%T')" $eth  $inbyte $outbyte $inpacket $outpacket $speed $total
#eval printf "%-10s%5s%11s%11s%11s%11s%10s%10s\n" "$(date '+%T')" ${eth}eth  ${eth}inbyte ${eth}outbyte ${eth}inpacket ${eth}outpacket ${eth}speed ${eth}total
eval \ echo  $cydate  ${eth}  $((${eth}inbyte)) $((${eth}outbyte)) $((${eth}totalbyte))  $((${eth}inpacket))  $((${eth}outpacket)) $((${eth}speed)) $((${eth}total)) | awk '{printf("%-10s%5s%11s%11s%11s%11s%11s%10s%10s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9)}' 
#   echo "$(date '+%T')  $eth   $inbyte   $outbyte   $inpacket   $outpacket  $speed  $total" 
    eval \ ${eth}tinbyte=$((${eth}tinbyte+${eth}inbyte))                  # 接收字节数据之和                  
    eval \ ${eth}toutbyte=$((${eth}toutbyte+${eth}outbyte))               # 发送字节数据之和               
    eval \ ${eth}tinpacket=$((${eth}tinpacket+${eth}inpacket))            # 接收数据包之和	
    eval \ ${eth}toutpacket=$((${eth}toutpacket+${eth}outpacket))         # 发送数据包之和               
    eval \ ${eth}tused=$((${eth}tused+${eth}total))                       # 网卡使用百分比之和
    eval \ ${eth}ttotalbyte=$((${eth}ttotalbyte+${eth}totalbyte))                       # 收发数据之和
   done  <../tmp/ethspeed.txt
   
    r=$(($r+1))	
	echo " "

 done 

   
     while  read h
     do
       eth=$(echo ${h} |awk '{print $1}')            
       netspeed=$(echo ${h} |awk '{print $2}'|grep -o '[0-9]*') 	
   #  eval echo "Average:  ${eth}      $((${eth}inbyte))  $((${eth}outbyte))  $((${eth}inpacket))  $((${eth}outpacket))"
 eval echo "Average:  ${eth}     $(($((${eth}tinbyte))/$r)) $(($((${eth}toutbyte))/$r)) $(($((${eth}ttotalbyte))/$r))  $(($((${eth}tinpacket))/$r))  $(($((${eth}toutpacket))/$r)) $netspeed $((${eth}tused/$r))" | awk '{printf("%-10s%5s%11s%11s%11s%11s%11s%10s%10s\n",$1,$2,$3,$4,$5,$6,$7,$8,$9)}' 
     done <../tmp/ethspeed.txt  
