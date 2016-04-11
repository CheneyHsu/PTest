#!/bin/bash

##########################
#  Check OVO
##########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`


OVO_TEMPLATE_TMP=${TMP_PATH}/ovo.template.tmp
OVO_TEMPLATE_SAMPLE=${SAMPLE_PATH}/ovo.template.sample
LOGFILE=ovo_status.log
ps -ef |grep -q [o]vcd
if [ $? -eq 0 ]
  then
    OVO_STATUS=`/opt/OV/bin/ovc -status |awk '{print $NF}'|grep Running|wc -l`
    if [ $OVO_STATUS -lt 9 ]
      then
        echo "15_1 OVO Status :"
        echo "...................................False" | awk '{printf "%60s\n",$1}'
#        echo "Please run \"/opt/OV/bin/ovc -status\" check."
        /opt/OV/bin/ovc -status  >${ERRORLOG_PATH}/${CHECKDATE}_${LOGFILE} 2>&1
        echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_${LOGFILE}"
      else
        echo "15_1 OVO Status :"
        echo "......................................OK" | awk '{printf "%60s\n",$1}'
    fi
    /opt/OV/bin/opctemplate -l >${OVO_TEMPLATE_TMP}
    diff ${OVO_TEMPLATE_TMP} ${OVO_TEMPLATE_SAMPLE} >/dev/null 2>&1
    a=$?
    if [ $a -ne 0 ]
      then
        echo "15_2 OVO TEMPLATE Status :"
        echo "...................................False" | awk '{printf "%60s\n",$1}'
        diff ${OVO_TEMPLATE_TMP} ${OVO_TEMPLATE_SAMPLE} >${ERRORLOG_PATH}/${CHECKDATE}_ovo_template.log
        echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_ovo_template.log"
        echo
#        /opt/OV/bin/opctemplate -l 
      else
        echo "15_2 OVO TEMPLATE Status :"
        echo "......................................OK" | awk '{printf "%60s\n",$1}'
    fi
#  else
#    echo "15_1 OVO Status: "
#    echo "......................................Not.Check" | awk '{printf "%60s\n",$1}'
fi

echo "----------------------------------------------------------"
