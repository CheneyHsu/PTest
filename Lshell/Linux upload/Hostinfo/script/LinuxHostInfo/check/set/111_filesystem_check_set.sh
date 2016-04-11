#!/usr/bin/ksh

###############################
#  filesystem_usage.conf SETTING
###############################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
CHECKDATE=`date "+%Y-%m-%d"`


FS_USAGE_CONF=${CONF_PATH}/filesystem_check.conf
if [ -f ${FS_USAGE_CONF} ]
   then 
     df|grep % |awk '/\// {print $NF}' |grep /  | while read i;
       do
         grep -q "${i}=" ${FS_USAGE_CONF}
         if [ $? -ne 0 ]
           then
             echo ${i}"=80" >>${FS_USAGE_CONF}
             echo "superaddition ${i}=80 "
         fi
        done
     else
        df|grep % |awk '/\// {print $NF}' | while read i;
       do
         echo ${i}"=80" >>${FS_USAGE_CONF}
       done 
fi
  if [ -f ${FS_USAGE_CONF} ] 
     then
       echo "111 filesystem_check.conf :"
       echo "......................................OK" | awk '{printf "%60s\n",$1}'
     else
       echo "111 filesystem_check.conf :"
       echo "...................................False" | awk '{printf "%60s\n",$1}'
    fi
echo "----------------------------------------------------------"
