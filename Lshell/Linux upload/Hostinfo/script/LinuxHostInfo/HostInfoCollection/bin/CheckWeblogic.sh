#!/bin/sh
#2013-08-19 tmp中复制一份数据
cd  /home/sysadmin/HostInfoCollection/bin

logfile=../file/checkweblogic.txt

Get_PID () {

case `uname -s` in
AIX)
     PID_LIST=`ps -ef|grep java|grep -v grep|grep Dweblogic.Name|awk '{print $2}'`
;;
HP-UX)
     PID_LIST=`ps -efx|grep java|grep -v grep|grep Dweblogic.Name|awk '{print $2}'`
;;
Linux|linux)
     PID_LIST=`ps -ef|grep java|grep -v grep|grep Dweblogic.Name|awk '{print $2}'`
;;
*)
     echo "The script is not support `uname -s`"
;;
esac
}

Get_User () {

case `uname -s` in

AIX)
     USER=`ps -ef|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|awk '{print $1}'`
;;
HP-UX)
     USER=`ps -efx|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|awk '{print $1}'`
;;
Linux|linux)
     USER=`ps -ef|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|awk '{print $1}'`
;;
*)
     echo "The script is not support `uname -s`"
;;
esac
}

Get_Server () {

case `uname -s` in
AIX)
     Sname=`ps -ef|grep -w ${PID}|grep Dweblogic.Name|grep -v grep|tr " " "\n"|awk 'gsub(/^-Dweblogic.Name=/,""){print $1}'|head -1`
;;
HP-UX)
     Sname=`ps -efx|grep -w ${PID}|grep Dweblogic.Name|grep -v grep|tr " " "\n"|awk 'gsub(/^-Dweblogic.Name=/,""){print $1}'|head -1`
;;
Linux|linux)
     Sname=`ps -ef|grep -w ${PID}|grep Dweblogic.Name|grep -v grep|tr " " "\n"|awk 'gsub(/^-Dweblogic.Name=/,""){print $1}'|head -1`
;;
*)
     echo "The script is not support `uname -s`"
;;
esac
}

Get_Jvm_Size () {

case `uname -s` in
AIX)
    LARGE_XMS=`ps -ef|grep -w ${PID}|grep Dweblogic.Name|grep -v grep|tr " " "\n"|grep Xms|tail -1|sed 's/-Xms//g'`
    LARGE_XMX=`ps -ef|grep -w ${PID}|grep Dweblogic.Name|grep -v grep|tr " " "\n"|grep Xmx|tail -1|sed 's/-Xmx//g'`
;;
HP-UX)
    LARGE_XMS=`ps -efx|grep -w ${PID}|grep Dweblogic.Name|grep -v grep|tr " " "\n"|grep Xms|tail -1|sed 's/-Xms//g'`
    LARGE_XMX=`ps -efx|grep -w ${PID}|grep Dweblogic.Name|grep -v grep|tr " " "\n"|grep Xmx|tail -1|sed 's/-Xmx//g'`
;;
Linux|linux)
    LARGE_XMS=`ps -ef|grep -w ${PID}|grep Dweblogic.Name|grep -v grep|tr " " "\n"|grep Xms|tail -1|sed 's/-Xms//g'`
    LARGE_XMX=`ps -ef|grep -w ${PID}|grep Dweblogic.Name|grep -v grep|tr " " "\n"|grep Xmx|tail -1|sed 's/-Xmx//g'`
;;     
*)
     echo "The script is not support `uname -s`"
;;
esac
}

Get_Thread_Pool () {

case `uname -s` in
AIX)
    Min_Pool=`ps -ef|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|tr " " "\n"|grep Dweblogic.threadpool.MinPoolSize|awk -F '=' '{print $2}'`
    if [ -z "${Min_Pool}" ]
        then
            Min_Pool=0
        else
            Min_Pool=${Min_Pool}
    fi
    Max_Pool=`ps -ef|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|tr " " "\n"|grep Dweblogic.threadpool.MaxPoolSize|awk -F '=' '{print $2}'`
    if [ -z "${Max_Pool}" ]
        then
            Max_Pool=0
        else
            Max_Pool=${Max_Pool}
    fi     
;;
HP-UX)
    Min_Pool=`ps -efx|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|tr " " "\n"|grep Dweblogic.threadpool.MinPoolSize|awk -F '=' '{print $2}'`
    if [ -z "${Min_Pool}" ]
        then
            Min_Pool=0
        else
            Min_Pool=${Min_Pool}
    fi
    Max_Pool=`ps -efx|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|tr " " "\n"|grep Dweblogic.threadpool.MaxPoolSize|awk -F '=' '{print $2}'`
    if [ -z "${Max_Pool}" ]
        then
            Max_Pool=0
        else
            Max_Pool=${Max_Pool}
    fi    
;;
Linux|linux)
    Min_Pool=`ps -ef|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|tr " " "\n"|grep Dweblogic.threadpool.MinPoolSize|awk -F '=' '{print $2}'`
    if [ -z "${Min_Pool}" ]
        then
            Min_Pool=0
        else
            Min_Pool=${Min_Pool}
    fi
    Max_Pool=`ps -ef|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|tr " " "\n"|grep Dweblogic.threadpool.MaxPoolSize|awk -F '=' '{print $2}'`
    if [ -z "${Max_Pool}" ]
        then
            Max_Pool=0
        else
            Max_Pool=${Max_Pool}
    fi    
;;
*)
     echo "The script is not support `uname -s`"
;;
esac

}

Get_GC_File () {
case `uname -s` in
AIX)
     GC_File=`ps -ef|grep -w ${PID}|grep java|grep -v grep|grep Dweblogic.Name|tr " " "\n"|grep Xverbosegclog|awk -F ':' '{print $2}'`
     if [ -z "${GC_File}" ]
         then
             GC_File=0
         else
             GC_File=${GC_File}
     fi     
;;
HP-UX)
     GC_File=`ps -efx|grep -w ${PID}|grep java|grep -v grep|grep Dweblogic.Name|tr " " "\n"|grep verbosegc|awk -F '=' '{print $2}'`
     if [ -z "${GC_File}" ]
         then
             GC_File=0
         else
             GC_File=${GC_File}
     fi
;;
Linux|linux)
     GC_File=`ps -ef|grep -w ${PID}|grep java|grep -v grep|grep Dweblogic.Name|tr " " "\n"|grep Xloggc|awk -F ':' '{print $2}'`
     if [ -z "${GC_File}" ]
         then
             GC_File=0
         else
             GC_File=${GC_File}
     fi
;;
*)
     echo "The script is not support `uname -s`"
;;
esac
}

Get_HEAP_ARGS () {

case `uname -s` in
AIX)
     HDO_ARGS=0
     HDP_PATH=0
;;
HP-UX)
     HEAP_ARGS=`ps -efx|grep java|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|tr " " "\n"|awk '/HeapDump*/'|grep -v HeapDumpPath|sed 's/-XX://g'|tr "\n" " "|awk '{print $0}'|sed 's/.$//g'`
     if [ -z "${HEAP_ARGS}" ]
         then
             HDO_ARGS=0
         else
             HDO_ARGS=${HEAP_ARGS}
     fi      
     HDP_PATH=`ps -efx|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|tr " " "\n"|grep -w HeapDumpPath|awk -F "=" '{print $2}'`
     if [ -z "${HDP_PATH}" ]
         then
             HDP_PATH=0
         else
             HDP_PATH=${HDP_PATH}
     fi
;;
Linux|linux)
     HEAP_ARGS=`ps -ef|grep java|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|tr " " "\n"|awk '/HeapDump*/'|grep -v HeapDumpPath|sed 's/-XX://g'|tr "\n" " "|awk '{print $0}'|sed 's/.$//g'`
     if [ -z "${HEAP_ARGS}" ]
         then
             HDO_ARGS=0
         else
             HDO_ARGS=${HEAP_ARGS}
     fi      
     HDP_PATH=`ps -ef|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|tr " " "\n"|grep -w HeapDumpPath|awk -F "=" '{print $2}'`
     if [ -z "${HDP_PATH}" ]
         then
             HDP_PATH=0
         else
             HDP_PATH=${HDP_PATH}
     fi
;;
*)
     echo "The script is not support `uname -s`"
;;
esac

}

Get_NewSize () {

case `uname -s` in
AIX)
    NEWSIZE_AGRS=0
    MAX_NEWSIZE_AGRS=0
;;
HP-UX)
    NEWSIZE_AGRS=`ps -efx|grep java|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|tr " " "\n"|grep -w NewSize|awk -F "=" '{print $2}'`
    if [ -z "${NEWSIZE_AGRS}" ]
        then
            NEWSIZE_AGRS=0
        else
            NEWSIZE_AGRS=${NEWSIZE_AGRS}
    fi
    MAX_NEWSIZE_AGRS=`ps -efx|grep java|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|tr " " "\n"|grep -w MaxNewSize|awk -F "=" '{print $2}'`
    if [ -z "${MAX_NEWSIZE_AGRS}" ]
        then
            MAX_NEWSIZE_AGRS=0
        else
            MAX_NEWSIZE_AGRS=${MAX_NEWSIZE_AGRS}
    fi
;;
Linux|linux)
    NEWSIZE_AGRS=`ps -ef|grep java|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|tr " " "\n"|grep -w NewSize|awk -F "=" '{print $2}'`
    if [ -z "${NEWSIZE_AGRS}" ]
        then
            NEWSIZE_AGRS=0
        else
            NEWSIZE_AGRS=${NEWSIZE_AGRS}
    fi
    MAX_NEWSIZE_AGRS=`ps -ef|grep java|grep -w ${PID}|grep -v grep|grep Dweblogic.Name|tr " " "\n"|grep -w MaxNewSize|awk -F "=" '{print $2}'` 
    if [ -z "${MAX_NEWSIZE_AGRS}" ]
        then
            MAX_NEWSIZE_AGRS=0
        else
            MAX_NEWSIZE_AGRS=${MAX_NEWSIZE_AGRS}
    fi    
;;
*)
     echo "The script is not support `uname -s`"
;;
esac

}

Get_PermSize () {

case `uname -s` in
AIX)
    PERMSIZE=`ps -ef|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|grep -w PermSize|awk -F '=' '{print $2}'`
    if [ -z "${PERMSIZE}" ]
        then
            PERMSIZE=0
        else
            PERMSIZE=${PERMSIZE}
    fi    
    MAX_PERMSIZE=`ps -ef|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|grep -w MaxPermSize|awk -F '=' '{print $2}'`
    if [ -z "${MAX_PERMSIZE}" ]
        then
            MAX_PERMSIZE=0
        else
            MAX_PERMSIZE=${MAX_PERMSIZE}
    fi      
;;
HP-UX)
    PERMSIZE=`ps -efx|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|grep -w PermSize|awk -F '=' '{print $2}'`
    if [ -z "${PERMSIZE}" ]
        then
            PERMSIZE=0
        else
            PERMSIZE=${PERMSIZE}
    fi 
    MAX_PERMSIZE=`ps -efx|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|grep -w MaxPermSize|awk -F '=' '{print $2}'`
    if [ -z "${MAX_PERMSIZE}" ]
        then
            MAX_PERMSIZE=0
        else
            MAX_PERMSIZE=${MAX_PERMSIZE}
    fi     
;;
Linux|linux)
    PERMSIZE=`ps -ef|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|grep -w PermSize|awk -F '=' '{print $2}'`
    if [ -z "${PERMSIZE}" ]
        then
            PERMSIZE=0
        else
            PERMSIZE=${PERMSIZE}
    fi 
    MAX_PERMSIZE=`ps -ef|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|grep -w MaxPermSize|awk -F '=' '{print $2}'`
    if [ -z "${MAX_PERMSIZE}" ]
        then
            MAX_PERMSIZE=0
        else
            MAX_PERMSIZE=${MAX_PERMSIZE}
    fi 
;;
*)
     echo "The script is not support `uname -s`"
;;
esac

}

Get_StackSize () {

case `uname -s` in
AIX)
    XSSIZE=0
;;
HP-UX)
    XSSIZE=`ps -efx|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|grep Xss|sed 's/-Xss//g'`
    if [ -z "${XSSIZE}" ]
        then
            XSSIZE=0
        else
            XSSIZE=${XSSIZE}
    fi     
;;
Linux|linux)
    XSSIZE=`ps -ef|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|grep Xss|sed 's/-Xss//g'`
    if [ -z "${XSSIZE}" ]
        then
            XSSIZE=0
        else
            XSSIZE=${XSSIZE}
    fi     
;;
*)
     echo "The script is not support `uname -s`"
;;
esac

}

Get_Ratio () {

case `uname -s` in
AIX)
    NewRatio=0
    SurvivorRatio=0
;;
HP-UX)
    NewRatio=`ps -efx|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|grep -w NewRatio|sed 's/\(.*\)\(.\)$/\2/'`
    if [ -z "${NewRatio}" ]
        then
            NewRatio=0
        else
            NewRatio=${NewRatio}
    fi    
    SurvivorRatio=`ps -efx|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|grep -w SurvivorRatio|sed 's/\(.*\)\(.\)$/\2/'`
    if [ -z "${SurvivorRatio}" ]
        then
            SurvivorRatio=0
        else
            SurvivorRatio=${SurvivorRatio}
    fi  
;;
Linux|linux)
    NewRatio=`ps -ef|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|grep -w NewRatio|sed 's/\(.*\)\(.\)$/\2/'`
    if [ -z "${NewRatio}" ]
        then
            NewRatio=0
        else
            NewRatio{NewRatio}
    fi
    SurvivorRatio=`ps -ef|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|grep -w NewRatio|sed 's/\(.*\)\(.\)$/\2/'`
    if [ -z "${SurvivorRatio}" ]
        then
            SurvivorRatio=0
        else
            SurvivorRatio=${SurvivorRatio}
    fi
;;
*)
     echo "The script is not support `uname -s`"
;;
esac

}

Get_GC_POLICY () {

case `uname -s` in
AIX)
    GC_POLICY=0
    GC_POLICY=0
;;
HP-UX)
    GC_POLICY=`ps -efx|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|awk '/Use..*GC/'|sed 's/-XX://g'|sed '$!N;$!N;$!N;s/\n/ /g'`
    if [ -z "${GC_POLICY}" ]
        then
            GC_POLICY=0
        else
            GC_POLICY=${GC_POLICY}
    fi    
;;
Linux|linux)
    GC_POLICY=`ps -ef|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|awk '/Use..*GC/'|sed 's/-XX://g'|sed '$!N;$!N;$!N;s/\n/ /g'`
    if [ -z "${GC_POLICY}" ]
        then
            GC_POLICY=0
        else
            GC_POLICY=${GC_POLICY}
    fi    
;;
*)
     echo "The script is not support `uname -s`"
;;
esac

}

Get_Print_GC () {

case `uname -s` in
AIX)
    Print_GC=0
    Print_GC=0
;;
HP-UX)
    Print_GC=`ps -efx|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|awk '/PrintGC.*/'|sed 's/-XX://g'|sed '$!N;$!N;s/\n/ /g'`
    if [ -z "${Print_GC}" ]
        then
            Print_GC=0
        else
            Print_GC=${Print_GC}
    fi 
;;
Linux|linux)
    Print_GC=`ps -ef|grep java|grep -w ${PID}|grep Dweblogic.Name|tr " " "\n"|awk '/PrintGC.*/'|sed 's/-XX://g'|sed '$!N;$!N;s/\n/ /g'`
    if [ -z "${Print_GC}" ]
        then
            Print_GC=0
        else
            Print_GC=${Print_GC}
    fi 
;;
*)
     echo "The script is not support `uname -s`"
;;
esac

}

Get_Version () {

case `uname -s` in
AIX)
    Java_Path=`ps -ef|grep ${PID}|grep -v grep|tr " " "\n"|grep "/bin/java"`
    JAVA_VERSION_INFO=`${Java_Path} -version 2>&1`
    JAVA_VERSION=`echo ${JAVA_VERSION_INFO}|tr " " "\n"|sed -n '3p'|sed 's/"//g'`
    JAVA_USE_64BIT=`echo ${JAVA_VERSION_INFO}|tr " " "\n"|grep -w "ppc-64"`
    if [ -z "${JAVA_USE_64BIT}" ]
        then
            JAVA_USE_64BIT=32
        else
            JAVA_USE_64BIT=64
    fi
;;
HP-UX)
    Java_Path=`ps -ex|grep -w ${PID}|grep -v grep|grep -w Dweblogic.Name|head -1|awk '{print $4}'`
    JAVA_VERSION_INFO=`${Java_Path} -version 2>&1`
    JAVA_VERSION=`echo ${JAVA_VERSION_INFO}|tr " " "\n"|sed -n '3p'|sed 's/"//g'`
    JAVA_USE_64BIT=`echo ${JAVA_VERSION_INFO}|tr " " "\n"|grep -w "64-Bit"`
    if [ -z "${JAVA_USE_64BIT}" ]
        then
            JAVA_USE_64BIT=32
        else
            JAVA_USE_64BIT=64
    fi
;;
Linux|linux)
    Java_Path=`ps -ef|grep ${PID}|grep -v grep|tr " " "\n"|grep "/bin/java"`
    JAVA_VERSION_INFO=`${Java_Path} -version 2>&1`
    JAVA_VERSION=`echo ${JAVA_VERSION_INFO}|tr " " "\n"|sed -n '3p'|sed 's/"//g'`
    JAVA_USE_64BIT=`echo ${JAVA_VERSION_INFO}|tr " " "\n"|grep -w "64-Bit"`
    if [ -z "${JAVA_USE_64BIT}" ]
        then
            JAVA_USE_64BIT=32
        else
            JAVA_USE_64BIT=64
    fi
;;
*)
    echo "The script is not support `uname -s`"
;;
esac

}

Get_OS_Type ()

{
   OS_TPYE=`uname -s` 
}



Loop_Action () {
Get_OS_Type
Get_PID
for PID in ${PID_LIST}
    do  
        Get_User
        Get_Server
        Get_Jvm_Size
        Get_Thread_Pool
        Get_GC_File
        Get_HEAP_ARGS
        Get_NewSize
        Get_PermSize
        Get_StackSize
        Get_Ratio
        Get_GC_POLICY
        Get_Print_GC
        Get_Version
        #echo "${OS_TPYE}|${JAVA_VERSION}|${JAVA_USE_64BIT}|${USER}|${PID}|${Sname}|${LARGE_XMS}|${LARGE_XMX}|${Min_Pool}|${Max_Pool}|${GC_File}|${HDO_ARGS}|${HDP_PATH}|${NEWSIZE_AGRS}|${MAX_NEWSIZE_AGRS}|${PERMSIZE}|${MAX_PERMSIZE}|${XSSIZE}|${NewRatio}|${SurvivorRatio}|${GC_POLICY}|${Print_GC}"
        echo "${USER}|${PID}|${Sname}|${LARGE_XMS}|${LARGE_XMX}|${Min_Pool}|${Max_Pool}|${GC_File}|${HDO_ARGS}|${HDP_PATH}|${OS_TPYE}|${JAVA_VERSION}|${JAVA_USE_64BIT}|${NEWSIZE_AGRS}|${MAX_NEWSIZE_AGRS}|${PERMSIZE}|${MAX_PERMSIZE}|${XSSIZE}|${NewRatio}|${SurvivorRatio}|${GC_POLICY}|${Print_GC}"
    done
}
#**********************Main*******************
Loop_Action >${logfile}   2>&1   
#Loop_Action

# 判断tmp中有没有checkweblogic.txt
if [ -f  /home/sysadmin/HostInfoCollection/tmp/checkweblogic.txt ]
then
   rm /home/sysadmin/HostInfoCollection/tmp/checkweblogic.txt
fi

if [ -f  /home/sysadmin/HostInfoCollection/file/checkweblogic.txt ]
then
cp /home/sysadmin/HostInfoCollection/file/checkweblogic.txt  /home/sysadmin/HostInfoCollection/tmp/checkweblogic.txt  
fi