

##############################################
# used to Collection weblogic information
# writed by dlh
# 2012/11/15
#---------------------------------------------
# writed by dlh
# 2012/12/05
##############################################

#! /bin/bash
weblgVn9='Dwls.home='
weblgVn10='Dweblogic.home='

ostype=`uname -s`

if [ $ostype = HP-UX ]
then
    
   web9=`ps -efx|grep $weblgVn9 |grep -v grep |wc -l`
   if [ $web9 -ge 1 ];then
      webpath=`ps -efx|grep $weblgVn9 |awk -F $weblgVn9 '{print $2}' |awk -F"/server" '{print $1}' |grep -Ev "^$|grep|print"|uniq|head -1`
   else    
      webpath=`ps -efx|grep $weblgVn10 |awk -F$weblgVn10 '{print $2}' |awk -F"/server" '{print $1}' |grep -Ev "^$|grep|print"|uniq|head -1`
   fi

else [ $ostype = Linux -o $ostype = AIX ]

   web9=`ps -ef|grep $weblgVn9 |grep -v grep |wc -l`

   if [ $web9 -ge 1 ];then

      webpath=`ps -ef|grep $weblgVn9 |awk -F $weblgVn9 '{print $2}' |awk -F"/server" '{print $1}' |grep -Ev "^$|grep|print"|uniq|head -1`

   else

      webpath=`ps -ef|grep $weblgVn10 |awk -F $weblgVn10 '{print $2}' |awk -F"/server" '{print $1}' |grep -Ev "^$|grep|print"|uniq|head -1`

   fi

fi

if [ $? -eq 0 ]; then
       exec 3<&0  0<../conf/wlc.conf
       while read user passwd url
       do
         sh $webpath/common/bin/wlst.sh weblogicinfo.py $user $passwd  $url
       done
       0<&3
fi 