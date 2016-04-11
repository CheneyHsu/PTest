#!/bin/sh
emcfile=minsyn.txt
while read a;
do
   echo $a |grep -q "MirrorView Name"
   if [ $? -eq 0 ];then
      MVNAME=`echo "$a" |sed 's/:  /:/g'|awk -F":" '{print $2}'`
      continue
   else
      echo $a |grep -q "Has Secondary Images"
      if [ $? -eq 0 ];then
          HSI=`echo "$a" |sed 's/:  /:/g'|awk -F":" '{print $2}'`
          continue 
      else
	  echo $a |grep -q "Image UID"
	  if [ $? -eq 0 ];then
	      IUID=`echo "$a" |sed 's/:  /:/g'|awk -F"UID:" '{print $2}'`
	      continue
          else
	      echo $a |grep -q "Image State" 
	      if [ $? -eq 0 ];then
		  IST=`echo "$a" |sed 's/:  /:/g'|awk -F":" '{print $2}'`
		  continue
              else
		  echo $a |grep -q "Synchronizing Progress"
		  if [ $? -eq 0 ];then
		  SynPro=`echo "$a" |sed 's/:  /:/g'|awk -F":" '{print $2}'`
		  echo "${MVNAME}|${HSI}|${IUID}|${IST}|${SynPro}"
		  MVNAME=""
		  HSI=""
		  IUID=""
		  IST=""
		  SynPro=""
		  fi
	      fi 	  
          fi   
       fi	     
   fi
done < ${emcfile}

