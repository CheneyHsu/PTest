#!/bin/sh

##################################################
#  检查DG 的状态对比、srdf同步级别,CG的状态对比
##################################################
#开发人员:lhl 
#2014-01-26 最后修改
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf
ERRORLOG_PATH=../log/errorlog
CHECKDATE=`date "+%Y-%m-%d"`

SRDF_CONF=${CONF_PATH}/srdf_check.conf
#CG_CONF=${CONF_PATH}/cg_check.conf

# 开始循环dg
t=`cat ${SRDF_CONF} |grep -v "^#" |wc -l`
if [ ${t} -gt 0 ]
then
cat ${SRDF_CONF} |grep -v "^#" | while read i;
do
   cat /dev/null >${ERRORLOG_PATH}/${CHECKDATE}_dg_${i}.log 2>&1  #
   cat /dev/null >${TMP_PATH}/SRDFsymqos.log                 #清空symsos日志
  #symqos检查
  /usr/symcli/bin/symqos -g ${i} query >${TMP_PATH}/symqosstatus.log 2>&1 
  if [ $? -eq 0 ];then    
     SymLevel=`/usr/symcli/bin/symqos -g ${i} query |tee -a ${TMP_PATH}/SRDFsymqos.log |awk 'BEGIN{k=0;} /\+/ {k=k+$(NF-3)} END{print k}'`
	 if [ ${SymLevel} -eq 0 ];then  
       echo 22 qos_${i} " SRDF SymLevel :"
       echo "......................................OK" | awk '{printf "%60s\n",$1}'
	 else
	   echo 22 qos_${i} " SRDF SymLevel :"  #检查结果失败
       echo "...................................False" | awk '{printf "%60s\n",$1}' 
	   echo "##symqos -g DGNAME query 查看数据同步策略等级" >${ERRORLOG_PATH}/${CHECKDATE}_qos_${i}.log
	   cat ${TMP_PATH}/SRDFsymqos.log >>${ERRORLOG_PATH}/${CHECKDATE}_qos_${i}.log
	 fi
  else ##  命令执行失败
     echo 22 qos_${i} " SRDF SymLevel :"
     echo "...................................False" | awk '{printf "%60s\n",$1}' 
	 echo "##symqos -g DGNAME query 查看数据同步策略等级" >${ERRORLOG_PATH}/${CHECKDATE}_qos_${i}.log 
	 cat ${TMP_PATH}/symqosstatus.log >>${ERRORLOG_PATH}/${CHECKDATE}_qos_${i}.log
  fi

  #srdf检查
  a=`cat ${CONF_PATH}/${i}_group.conf |grep -v "^#" |wc -l`  #查看rdfg号
     if [ ${a} -gt 0 ]  #有配置rdfg组号
     then
       cat ${CONF_PATH}/${i}_group.conf |grep -v "^#" |while read ii;
       do
         /usr/symcli/bin/symrdf -g ${i} -rdfg ${ii} query > ${TMP_PATH}/srdf_${i}_${ii}.tmp 2>&1   #20140424
		 if [ $? -eq 0 ];then
           diff ${TMP_PATH}/srdf_${i}_${ii}.tmp ${SAMPLE_PATH}/srdf_${i}_${ii}.sample > ${ERRORLOG_PATH}/${CHECKDATE}_dg_${i}_${ii}.log  2>&1
           b=$?
           if [ $b -ne 0 ]
           then
		       ##查看DG状态与历史对比异常
               echo 22 dg_${i}_${ii}" SRDF Status :"
               echo "...................................False" | awk '{printf "%60s\n",$1}'
            #   diff ${TMP_PATH}/srdf_${i}_${ii}.tmp ${SAMPLE_PATH}/srdf_${i}_${ii}.sample > ${ERRORLOG_PATH}/${CHECKDATE}_dg_${i}_${ii}.log
             #  echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_dg_${i}_${ii}.log"
            else
               echo 22 dg_${i}_${ii}" SRDF Status :"
               echo "......................................OK" | awk '{printf "%60s\n",$1}'
            fi
		  else
               echo 22 dg_${i}_${ii}" SRDF CMD :"
               echo "...................................False" | awk '{printf "%60s\n",$1}'
             #  echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_dg_${i}_${ii}.log"
			   cp  ${TMP_PATH}/srdf_${i}_${ii}.tmp  ${ERRORLOG_PATH}/${CHECKDATE}_dg_${i}_${ii}.log
          fi			   
       done
      else   #  未配rdfg组号
        SRDF_SAMPLE=${SAMPLE_PATH}/srdf_${i}.sample
        /usr/symcli/bin/symrdf -g ${i} query > ${TMP_PATH}/srdf_${i}.tmp 2>&1
		if [ $? -eq 0 ];then
          diff ${TMP_PATH}/srdf_${i}.tmp ${SRDF_SAMPLE} > ${ERRORLOG_PATH}/${CHECKDATE}_dg_${i}.log  2>&1
          b=$?
          if [ $b -ne 0 ]
          then
		    ##查看DG状态与历史对比异常
            echo 22 dg_${i}" SRDF Status :"
            echo "...................................False" | awk '{printf "%60s\n",$1}' 	  
          #  echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_dg_${i}.log"
           else
		   ##查看DG状态与历史对比正常
               echo 22 dg_${i}" SRDF Status :"
               echo "......................................OK" | awk '{printf "%60s\n",$1}'
           fi
		 else
           echo 22 dg_${i}" SRDF CMD :"
           echo "...................................False" | awk '{printf "%60s\n",$1}' 
           cp ${TMP_PATH}/srdf_${i}.tmp ${SRDF_SAMPLE}  ${ERRORLOG_PATH}/${CHECKDATE}_dg_${i}.log		   
        fi  		     
      fi
	   #清除srdf 同步策略级别备份
	  
done
else
  echo "22 SRDF Status :"
  echo "...................................NOT_DG" | awk '{printf "%60s\n",$1}'
fi




#2012-03-09 加CG检查

#t=`cat ${CG_CONF} |grep -v "^#" |wc -l`
#if [ ${t} -gt 0 ]
#then
#cat ${CG_CONF} |grep -v "^#" | while read i;
#do
#         CG_SAMPLE=${SAMPLE_PATH}/cg_${i}.sample
#        /usr/symcli/bin/symstar -cg ${i} query > ${TMP_PATH}/cg_${i}.tmp
#        diff ${TMP_PATH}/cg_${i}.tmp ${CG_SAMPLE} > /dev/null 2>&1
#        b=$?
#        if [ $b -ne 0 ]
#        then
#          echo 22 cg_${i}" CG Status :"
#          echo "...................................False" | awk '{printf "%60s\n",$1}'
#          diff ${TMP_PATH}/cg_${i}.tmp ${CG_SAMPLE} > ${ERRORLOG_PATH}/${CHECKDATE}_cg_${i}.log
#          echo "logfile=`pwd|sed 's/check\/bin/check\/log/'`/errorlog/${CHECKDATE}_cg_${i}.log"
#         else
#          echo 22 cg_${i}" CG Status :"
#          echo "......................................OK" | awk '{printf "%60s\n",$1}'
#         fi
#done
##else
##  echo "22 CG Status :"
##  echo "...................................NOT_CG" | awk '{printf "%60s\n",$1}'
#fi

echo "----------------------------------------------------------"
