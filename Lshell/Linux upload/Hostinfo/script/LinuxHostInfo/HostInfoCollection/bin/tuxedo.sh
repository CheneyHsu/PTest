#!/bin/sh
#加入
#最后修改20130923

#20130923 加入
#tmunloadcf取运行时tuxedo的ubb配置文件信息
#dmunloadcf取运行时tuxedo的dm配置文件信息


FILE_PATH=../file

a=`ps -ef |grep BBL |grep -v grep|wc -l`
if [ $a -gt 0 ];then
   for aa in   `ps -ef |grep BBL |grep -v grep |awk '{print $1}'`
   do
     su - $aa -c "tmadmin -v;echo TMADMIN;tmunloadcf;echo TMUNLOADCF;dmunloadcf;echo DMUNLOADCF" >${FILE_PATH}/${aa}_tuxedoinfo.txt	 2>&1
   done

fi



