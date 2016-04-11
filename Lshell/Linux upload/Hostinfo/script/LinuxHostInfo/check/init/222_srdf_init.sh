#!/bin/bash

##########################
#  Initialize SRDF
##########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

SRDF_CONF=${CONF_PATH}/srdf_check.conf
t=`cat ${SRDF_CONF} |grep -v "^#" |wc -l`
if [ ${t} -gt 0 ]
then
cat ${SRDF_CONF} |grep -v "^#" | while read i;
do
 a=`cat ${CONF_PATH}/${i}_group.conf |grep -v "^#" |wc -l`
     if [ ${a} -gt 0 ]
     then
       cat ${CONF_PATH}/${i}_group.conf |grep -v "^#" |while read ii;
       do
         /usr/symcli/bin/symrdf -g ${i} -rdfg ${ii} query > ${SAMPLE_PATH}/srdf_${i}_${ii}.sample
         b=$?
         if [ $b -ne 0 ]
         then
           echo 222 ${i} group ${ii}" Initialization :"
           echo "...................................False" | awk '{printf "%60s\n",$1}'
          else
            echo 222 ${i} group ${ii}" Initialization :"
            echo "......................................OK" | awk '{printf "%60s\n",$1}'
          fi
        done 
      else
        /usr/symcli/bin/symrdf -g ${i} query > ${SAMPLE_PATH}/srdf_${i}.sample
        b=$?
        if [ $b -ne 0 ]
        then
          echo 222 ${i}" SRDF Initialization :"
          echo "...................................False" | awk '{printf "%60s\n",$1}'
        else
          echo 222 ${i}" SRDF Initialization :"
          echo "......................................OK" | awk '{printf "%60s\n",$1}'
        fi
      fi
done
else
  echo "22 SRDF Initialization :"
  echo "...................................NOT_DG" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
echo
