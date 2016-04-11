#!/bin/bash

#########################################################################
#
# Cheney Hsu 201308018 v0.4
# 磁盘对比 信息脚本
#########################################################################



#引用变量文件,内部存在很多变量,定义变量集中化
source /usr/report/Variable.sh
#函数文件(详细内容参考函数内部)
source /usr/report/MVMODULE.sh 


echo "==========================磁盘部分====================================" 
#输出标题部分
{
read line1
}<"${diskdiff}"1


#新老数据对比输出老数据
#数字1的为新数据.

A=`grep -vxFf "${diskdiff}"1 $diskdiff`

if [ $? = 0 ]
then
	echo "OLD DATA"
	echo ${line1}
	echo "`grep -vxFf "${diskdiff}"1 $diskdiff`"
fi

echo ''

#新老数据对比,输出新数据

B=`grep -vxFf ${diskdiff} "${diskdiff}"1`
if [ $? = 0 ]
then
	echo "NEW DATA"
	echo ${line1}
	echo "`grep -vxFf ${diskdiff} "${diskdiff}"1`"
fi


for I in `cat /tmp/report/usr/report/diffinode1 | awk '{print $5}' | grep % | grep  -v I | awk -F '%' '{print $1}'`
	do
		if [ ${I} -gt 80 ]
		then
		echo "==========================Inodes greater 80%==============================="
		echo  "`cat /tmp/report/usr/report/diffinode1 | grep "${I}\%"`"
		fi 
done

#变量A为本地局部变量,只在此次for循环中使用,可以视作临时变量.
for A in `cat "${diskdiff}"1 | awk '{print $5}' | awk -F '%' '{print $1}'|grep -v '[已用|Use]'`
do
	 if [ ${A} -gt 79 ]
	  then
			echo "=======================空间超过80％============================" 
			echo "`cat "${diskdiff}"1 | grep "${A}\%"`" 
		else
			:
	fi		
done


#echo "==========================磁盘空间增长大于1％的============================"

#N变量为临时变量,只做此次对比使用,理解为1%增长,如果需要可以调节该变量
N=1
#grep -vxFf /tmp/2.txt /tmp/1.txt | awk '{print $5}' | awk -F '%' '{print $1}'  #0 100
#grep -vxFf /tmp/1.txt /tmp/2.txt | awk '{print $5}' | awk -F '%' '{print $1}'   #25 100

#X变量为临时变量,C变量为临时变量,只做此次对比和for语句使用.
for  X in `grep -vxFf ${diskdiff} "${diskdiff}"1 | awk '{print $5}' | awk -F '%' '{print $1}'|grep -v "/"` 
do
		grep -vxFf "${diskdiff}"1 ${diskdiff} | awk '{print $5}' | awk -F '%' '{print $1}'| grep -v "/" |while read linet
		do
			let C=${X}-${N}
			if [ ${C} -ge ${linet} ]
				then
				echo "`grep -vxFf $diskdiff  "${diskdiff}"1 | grep "${X}\%"`" >>/tmp/report/usr/report/diskdiff2
				fi
			done  
done
if [ -f /tmp/report/usr/report/diskdiff2 ]
	then
	echo "==========================磁盘空间增长大于1％的============================"
	cat /tmp/report/usr/report/diskdiff2 | uniq
fi
rm -rf /tmp/report/usr/report/diskdiff2


exit 0
