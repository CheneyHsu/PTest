#!/bin/bash
TMP_PATH=../tmp
CONF_PATH=../conf
ps -ef |grep -q "[W]ebLogic.sh"
if [ $? -ne 0 ]
  then
    echo "AAA_20 Weblogic;Not Runing"
  else
   a=`cat ${CONF_PATH}/appconf |grep -v "^#" |awk -F"=" '/weblogic/ {print $2}'|wc -l`
  if [ $a -eq 0 ]
   then
     echo "AAA_20 Weblogic;Not Setting"
   else
      cat ${CONF_PATH}/appconf |grep -v "^#"|awk -F"=" '/weblogic/ {print $2}'|while read i;
        do
          WEBVERSION=`cat ${i}|awk -F"=" '/Domain /{print $2}'|awk '{print $1}'`
          AAAA="${AAAA} ${WEBVERSION}"
        cat ${i} |awk '/<Server ListenAddress/{print "20 weblogic;" $3,$4,$5}'
        cat ${i} |awk '/<Server ExpectedToRun/{print "20 weblogic;" $3,$4,$5}'
        cat ${i} |sed -n '/<Server Cluster/p'|awk '{print "20 weblogic;" $NF}'>${TMP_PATH}/weblogic_a.log
        cat ${i} |sed -n '/<Server Cluster/{n;p;}' >${TMP_PATH}/weblogic_b.log
        paste ${TMP_PATH}/weblogic_a.log ${TMP_PATH}/weblogic_b.log 
        done
          echo "AAA_20 Weblogic;${AAAA}"
   fi
fi
