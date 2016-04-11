#!/bin/sh

umask 000

TMPDIR="/home/sysadmin/tuxedo_check/tmp"
DATADIR="/home/sysadmin/tuxedo_check/data"

TMUNLOADCF_FILE="tmunloadcf.txt"
TMUNLOADCF_TMP_FILE="tmunloadcf.tmp"
MAX_LENGTH=15
SERVER_LIST=""
TUX_PROCESSES="BBL DMADM GWADM GWTDOMAIN WSL JSL JREPSVR LMS"
HOST_NAME="`/usr/bin/hostname`"

if [ $# -lt 2 ]; then
   echo "Usage: $0 <Current_User> <Data_File_Timestamp>"
   exit
fi

CUR_USER=$1
FILE_SUFFIX="log"
FILE_TIMESTAMP=$2

get_bbiinfo(){
tmadmin > ${TMPDIR}/tux_monitor.${CUR_USER}.bbiinfo 2>/dev/null <<!
bbi
!
}

get_bbpinfo(){
tmadmin > ${TMPDIR}/tux_monitor.${CUR_USER}.bbpinfo 2>/dev/null <<!
bbp
!
}

get_bbsinfo(){
tmadmin > ${TMPDIR}/tux_monitor.${CUR_USER}.bbsinfo 2>/dev/null <<!
bbs
!
}

get_psrinfo(){
tmadmin > ${TMPDIR}/tux_monitor.${CUR_USER}.psrinfo 2>/dev/null <<!
verbose on
psr
!
}

get_pcltinfo(){
tmadmin > ${TMPDIR}/tux_monitor.${CUR_USER}.pcltinfo 2>/dev/null <<!
pclt
!
}

generate_basedata(){
	tmunloadcf > ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE}	
	get_bbiinfo
	get_bbpinfo
	get_bbsinfo
	get_psrinfo
	get_pcltinfo
}


#------------------------------------

print_capacity_using(){

	MAXACCESSERS=`grep -w MAXACCESSERS ${TMPDIR}/tux_monitor.${CUR_USER}.bbpinfo | awk '{ printf $2"\n" }'`
	MAXSERVERS=`grep -w MAXSERVERS ${TMPDIR}/tux_monitor.${CUR_USER}.bbpinfo | awk '{ printf $2"\n" }'`
	MAXSERVICES=`grep -w MAXSERVICES ${TMPDIR}/tux_monitor.${CUR_USER}.bbpinfo | awk '{ printf $2"\n" }'`

	bbinum=`grep -w "ADMINISTRATIVE PROCESSES" ${TMPDIR}/tux_monitor.${CUR_USER}.bbiinfo | wc -l`


	if [ $bbinum -eq 1 ]; then
        	midnum=`cat ${TMPDIR}/tux_monitor.${CUR_USER}.bbiinfo|grep -n "ADMINISTRATIVE PROCESSES"|awk -F":" '{print $1}'`
        	kidnum=`cat ${TMPDIR}/tux_monitor.${CUR_USER}.bbiinfo|grep -n "ACCESSERS:"|awk -F":" '{print $1}'`
		bnum=`expr $kidnum + 2`
		enum=`expr $midnum - 2`
		accnum=`sed -n "${bnum},${enum}p" ${TMPDIR}/tux_monitor.${CUR_USER}.bbiinfo|awk '{print $1}'|sed 's/[[:space:]]//g'| \
		awk '{if($1>max)max=$1}END{print max}'`
		enum=`cat ${TMPDIR}/tux_monitor.${CUR_USER}.bbiinfo|wc -l`
		midnum=`expr $midnum + 2`
		enum=`expr $enum - 2`
		knum=2
		adnum=$((enum-midnum+1))
		adnum=`expr $adnum / $knum`
		accnum=`expr $accnum + $adnum`
		
		if [ $accnum -gt $MAXACCESSERS ]; then
			accnum=$MAXACCESSERS
		fi
	used=`echo $accnum|awk -v a=$accnum -v b=$MAXACCESSERS '{printf "%.2f\n",(a/b)}'`
	free=`echo $accnum|awk -v a=1 -v b=$used '{printf "%.2f%\n",(a-b)*100}'`
	
	name="MAXACCESSERS"
	echo $accnum | \
	awk -v a=$MAXACCESSERS -v b=$used -v c=$free -v d=$accnum -v e=$name -v f=${HOST_NAME} -v g=${CUR_USER} -v h=${DOMAINID} -v i=${DATATIME} \
	'{printf "%s\t%s\t%s\t%s\t%s\t%s\t%.2f\t%.2f\t%s\n", f,g,h,e,a,d,b*100,c,i}' >> ${DATADIR}/${HOST_NAME}_${FILE_TIMESTAMP}_capacity.${FILE_SUFFIX}

	name="MAXSERVERS"
	accnum=`cat ${TMPDIR}/tux_monitor.${CUR_USER}.bbsinfo|grep servers|awk -F":" '{print $2}'|sed 's/[[:space:]]//g'`
	used=`echo $accnum|awk -v a=$accnum -v b=$MAXSERVERS '{printf "%.2f\n",(a/b)}'`
	free=`echo $accnum|awk -v a=1 -v b=$used '{printf "%.2f%\n",(a-b)*100}'`
	echo $accnum | \
	awk -v a=$MAXSERVERS -v b=$used -v c=$free -v d=$accnum -v e=$name  -v f=${HOST_NAME} -v g=${CUR_USER} -v h=${DOMAINID} -v i=${DATATIME} \
	'{printf "%s\t%s\t%s\t%s\t%s\t%s\t%.2f\t%.2f\t%s\n", f,g,h,e,a,d,b*100,c,i}' >> ${DATADIR}/${HOST_NAME}_${FILE_TIMESTAMP}_capacity.${FILE_SUFFIX}
	
	name="MAXSERVICES"
	accnum=`cat ${TMPDIR}/tux_monitor.${CUR_USER}.bbsinfo|grep services|awk -F":" '{print $2}'|sed 's/[[:space:]]//g'`
	used=`echo $accnum|awk -v a=$accnum -v b=$MAXSERVICES '{printf "%.2f\n",(a/b)}'`
	free=`echo $accnum|awk -v a=1 -v b=$used '{printf "%.2f%\n",(a-b)*100}'`
	echo $accnum | \
	awk -v a=$MAXSERVICES -v b=$used -v c=$free -v d=$accnum -v e=$name -v f=${HOST_NAME} -v g=${CUR_USER} -v h=${DOMAINID} -v i=${DATATIME} \
	'{printf "%s\t%s\t%s\t%s\t%s\t%s\t%.2f\t%.2f\t%s\n", f,g,h,e,a,d,b*100,c,i}' >> ${DATADIR}/${HOST_NAME}_${FILE_TIMESTAMP}_capacity.${FILE_SUFFIX}
	
	else
        	echo "CHECK TMADMIN COMMAND,CAN'T BECOME ADMINISTRATOR!"
	fi

}

print_msgqueue_using(){
	ipcs -qa|grep ${CUR_USER} | awk '($10>0) {print $0}'>${TMPDIR}/tux_monitor.${CUR_USER}.ipcsinfo
	cat ${TMPDIR}/tux_monitor.${CUR_USER}.ipcsinfo|awk '{print $2}'|sed 's/[[:space:]]//g'>${TMPDIR}/tux_monitor.${CUR_USER}.qidinfo


	for i in `cat ${TMPDIR}/tux_monitor.${CUR_USER}.qidinfo`
	do
    		qnum=`cat ${TMPDIR}/tux_monitor.${CUR_USER}.psrinfo|grep Qaddr|grep $i|wc -l`
    		if [ $qnum -ne 0 ]; then
		bnum=`cat ${TMPDIR}/tux_monitor.${CUR_USER}.psrinfo|grep -n $i|head -1|awk -F":" '{print $1}'`
            	bnum=`expr $bnum + 2`
            	server=`cat ${TMPDIR}/tux_monitor.${CUR_USER}.psrinfo|sed -n "$bnum,${bnum}p"|awk -F ":" '{print $2}'|sed 's/[[:space:]]//g'| \
	    	sed 's/\/*[a-z]*[A-Z]*[0-9]*_*\///g'`
		grep $i ${TMPDIR}/tux_monitor.${CUR_USER}.ipcsinfo | \
		awk -v a=${server} -v b=${HOST_NAME} -v c=${DOMAINID} -v d=${DATATIME} \
		'{printf b"\t"c"\t"$2"\t"$5"\t"$9"\t"$10"\t"$11"\t"a"\t"d"\n"}' >> ${DATADIR}/${HOST_NAME}_${FILE_TIMESTAMP}_msgqueue.${FILE_SUFFIX}
		fi 
	done
}

#------------------------------------

format_psrinfo(){
	if [ -f ${TMPDIR}/tux_monitor.${CUR_USER}.psrinfo ]; then
		grep -E "Server Type"\|"Prog Name"\|"Current Status" ${TMPDIR}/tux_monitor.${CUR_USER}.psrinfo | \
		sed '$!N;$!N;s/\n//g' > ${TMPDIR}/tux_monitor.${CUR_USER}.psrinfo.format
	else
		echo "${TMPDIR}/tux_monitor.${CUR_USER}.psrinfo doesn't exist."
	fi
}


get_serverlist(){
	if [ -f ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE} ]; then
            sed -n '/*SERVERS/,/*MODULES/p' ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE} > ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_TMP_FILE}
	    grep -E "SRVGRP"\|"MAX=" ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_TMP_FILE} | \
	    sed '$!N;$!N;s/\n//g' > ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_TMP_FILE}.format
	    
	    SERVER_LIST=`grep -w "SRVGRP" ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_TMP_FILE} | sed 's/"//g' | awk '{print $1}' | \
			 sed 's/[[:space:]]//g' | sort | uniq`
	else 
	    echo "${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE} doesn't exist."
	fi
}


get_servername_maxlength(){
	for i in ${SERVER_LIST}
	do
		REL_LENGTH=`expr length $i`
		if [ ${REL_LENGTH} -gt ${MAX_LENGTH} ]; then
			MAX_LENGTH=${REL_LENGTH}
		fi
	done
}



print_psrinfo_data(){

	format_psrinfo
	get_serverlist
	

	if [ -f ${TMPDIR}/tux_monitor.${CUR_USER}.psrinfo.format -a -f ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_TMP_FILE}.format ]; then 
	    for SERVER_INFO in ${SERVER_LIST}
	    do
		EXCLUDE_TUX_PROCESS="false"
		EXCLUDE_ERROR_PROCESS="true"
		SERVER_NAME=`echo ${SERVER_INFO} | cut -d ':' -f 1`
		
		echo "${TUX_PROCESSES}" | grep -wq "${SERVER_NAME}" && EXCLUDE_TUX_PROCESS="true"
		grep -wq "${SERVER_NAME}" ${TMPDIR}/tux_monitor.${CUR_USER}.psrinfo.format && EXCLUDE_ERROR_PROCESS="false"
		
		if [ ${EXCLUDE_TUX_PROCESS} = "false" -a  ${EXCLUDE_ERROR_PROCESS} = "false" ]; then
		MAX_COUNT=`grep -w "${SERVER_NAME}" ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_TMP_FILE}.format | \
		             awk '{ printf $8"\n"}' | sed 's/MAX\=//g' | awk '{sum+=$1} END {print sum}'`
		CURRENT_COUNT=`grep -w "${SERVER_NAME}" ${TMPDIR}/tux_monitor.${CUR_USER}.psrinfo.format | wc -l | sed 's/[[:space:]]//g'` 
		BUSY_COUNT=`grep -w "${SERVER_NAME}" ${TMPDIR}/tux_monitor.${CUR_USER}.psrinfo.format | \
			      grep -v IDLE | wc -l | sed 's/[[:space:]]//g'`

		echo "${HOST_NAME}\t${CUR_USER}\t${DOMAINID}\t${SERVER_NAME}\t${MAX_COUNT}\t${CURRENT_COUNT}\t${BUSY_COUNT}\t${DATATIME}" >> \
		${DATADIR}/${HOST_NAME}_${FILE_TIMESTAMP}_psrinfo.${FILE_SUFFIX}
		fi
		done
	else
		echo "${TMPDIR}/tux_monitor.${CUR_USER}.psrinfo.format or ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_TMP_FILE}.format doesn't exist."
	fi
}

format_listener_info(){
	if [ -f ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_TMP_FILE}  ]; then
		grep -E "SRVGRP"\|"CLOPT" ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_TMP_FILE} | \
		sed '$!N;s/\n//g' > ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE}.clopt.format
	else
		echo "${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_TMP_FILE}  doesn't exist."
	fi
}

print_rchandle_data(){
	format_listener_info
	if [ -f ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE}.clopt.format -a ${TMPDIR}/tux_monitor.${CUR_USER}.pcltinfo ]; then
		
	   WSL_EXIST="false"
	   JSL_EXIST="false"
	   grep -wq WSL ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE}.clopt.format && WSL_EXIST="true"
	   grep -wq JSL ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE}.clopt.format && JSL_EXIST="true"
		
	   if [ ${WSL_EXIST} = "true" ]; then
		WSH_MIN=`grep WSL ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE}.clopt.format | sed 's/"//g' | awk -F '-m' '{print $2}' |\
			 awk '{ printf $1"\n"}' | sed 's/[[:space:]]//g'`
		WSH_MAX=`grep WSL ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE}.clopt.format | sed 's/"//g' | awk -F '-M' '{print $2}' |\
			 awk '{ printf $1"\n"}' | sed 's/[[:space:]]//g'`
		WSH_MP=`grep WSL ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE}.clopt.format | sed 's/"//g' | awk -F '-x' '{print $2}' |\
			awk '{ printf $1"\n"}' | sed 's/[[:space:]]//g'`
		if [ -z "${WSH_MP}" ]; then
			WSH_MP=10
		fi

		WSC_TOTAL=`expr ${WSH_MAX} \* ${WSH_MP}`
		WSH_CURR=`grep WSH ${TMPDIR}/tux_monitor.${CUR_USER}.pcltinfo | wc -l | sed 's/[[:space:]]//g'`
		WSC_BUSY_CURR=`grep -w "BUSY/W" ${TMPDIR}/tux_monitor.${CUR_USER}.pcltinfo|grep -v tmadmin|grep -v webuser|wc -l|sed 's/[[:space:]]//g'`
		

		awk -v n="WSH" -v a=${WSH_MIN} -v b=${WSH_CURR} -v c=${WSH_MAX} -v d=${WSC_BUSY_CURR} -v e=${WSC_TOTAL} -v f=${HOST_NAME} \
		-v g=${CUR_USER} -v h=${DOMAINID} -v i=${DATATIME} \
		'BEGIN { printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%.2f\t%s\n", f, g, h, n, a, b, c, d, (d/e)*100, i }' >> \
		${DATADIR}/${HOST_NAME}_${FILE_TIMESTAMP}_rchandle.${FILE_SUFFIX}
	   fi
		
	   if [ ${JSL_EXIST} = "true" ]; then
		JSH_MIN=`grep JSL ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE}.clopt.format | sed 's/"//g' | awk -F '-m' '{print $2}' |\
			 awk '{ printf $1"\n"}' | sed 's/[[:space:]]//g'`
		JSH_MAX=`grep JSL ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE}.clopt.format | sed 's/"//g' | awk -F '-M' '{print $2}' |\
			 awk '{ printf $1"\n"}' | sed 's/[[:space:]]//g'` 
		JSH_MP=`grep JSL ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE}.clopt.format | sed 's/"//g' | awk -F '-x' '{print $2}' |\
			awk '{ printf $1"\n"}' | sed 's/[[:space:]]//g'`
		if [ -z "${JSH_MP}" ]; then     
			JSH_MP=10
		fi
		
		JC_TOTAL=`expr ${JSH_MAX} \* ${JSH_MP}`
		JSH_CURR=`grep JSH ${TMPDIR}/tux_monitor.${CUR_USER}.pcltinfo | wc -l | sed 's/[[:space:]]//g'`
		JC_BUSY_CURR=`grep -w "BUSY/W" ${TMPDIR}/tux_monitor.${CUR_USER}.pcltinfo|grep -v tmadmin|grep webuser|wc -l|sed 's/[[:space:]]//g'`

		awk -v n="JSH" -v a=${JSH_MIN} -v b=${JSH_CURR} -v c=${JSH_MAX} -v d=${JC_BUSY_CURR} -v e=${JC_TOTAL} -v f=${HOST_NAME} \
		-v g=${CUR_USER} -v h=${DOMAINID} -v i=${DATATIME} \
		'BEGIN { printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%.2f\t%s\n", f, g, h, n, a, b, c, d, (d/e)*100, i }' >> \
		${DATADIR}/${HOST_NAME}_${FILE_TIMESTAMP}_rchandle.${FILE_SUFFIX}
	   fi

	else
		echo "${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE}.clopt.format or ${TMPDIR}/tux_monitor.${CUR_USER}.pcltinfo doesn't exist."
	fi
}

print_all(){
	generate_basedata
	DOMAINID=`grep DOMAINID ${TMPDIR}/tux_monitor.${CUR_USER}.${TMUNLOADCF_FILE} | cut -d '"' -f 2`
	DATATIME=$(date +%Y.%m.%d_%H:%M:%S)

	echo "${HOST_NAME}\t${CUR_USER}\t${DOMAINID}\t${DATATIME}" >> ${DATADIR}/${HOST_NAME}_${FILE_TIMESTAMP}_base.${FILE_SUFFIX} 

	print_capacity_using
	print_psrinfo_data
	print_msgqueue_using
	print_rchandle_data
}

m=1
while [ ${m} -le 2 ]; do
	print_all
	let m+=1
	if [ ${m} -eq 2 ]; then
	    sleep 150
	fi 
done
