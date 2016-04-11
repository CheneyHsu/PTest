#!/bin/sh

#
# Copyright (c) 2013 CEB. All rights reserved.
#
# Checking Cluster and Global cluster configure
#
# Version :  V2.0 
#
# Writer  :  gengjianqiu
#
# Create Date: 2013-08-30
#
# OS HP-UX 11.23\11.31 AIX 5.3\6.x Suse Linux
#
###--------------------------------------######
#
# Modify Date: 2013-09-16 by version 1.2
#   1、add application offlineoutime check.
#   2、Modify critical check.
#        Read conf file :vcs_critical_res.conf
#                        vcs_nonecritical_res.conf
#   3、Modify MountPoint check warning.
# 
##
##--------------------------------------#######
#
#   Modify Date:2013-10-28 by version 2.0
#   1. Check DiskGroup critical.
#   2. Modify Linster checking.


##################################
# Set variables
##################################
PATH=$PATH:/opt/VRTSvcs/bin
export PATH

# set vcs modify command file.
VCS_COMM_FILE=`pwd`"/vcs_command.file"

# set critical types variables
CriticalTypes="NIC LVMVolumeGroup LVMVG Proxy DiskGroup"
NoneCriticalTypes="Oracle Application"

# set critical conf file path
CriticalPATH=/home/sysadmin/check

#Initialization critical variables
DefaultCriticalCheck=0
IsCriticalRes=0
IsNoneCriticalRes=0

# set Script dir variables
SCRIPT_PATH="/etc/VRTSvcs"
APP_SCRIPT_PATH=$SCRIPT_PATH"/cebscripts"

# set MountPoint in Platform filesystem table file.
FILETABLE="mount"

# set err code variables
ecode=0
wcode=0
##################################
# Check vcs command file exist.
if [ ! -f $VCS_COMM_FILE ]
 then 
   touch $VCS_COMM_FILE 
fi


# Checking Cluster State.
if [ `haclus -state | grep RUNNING | wc -l ` -eq 0 ]
then
   echo Please start your cluster when running this script.
   exit 99
fi

#
ClusterName=`haclus -value ClusterName -localclus`
echo
echo "  " Verification Report of VCS Configuration of cluster ClusterName
echo 
echo "      Check Date: "`date +'%Y-%m-%d %H:%M:%S'`
echo
echo Cluster name: $ClusterName
echo
echo Checking Configuration of cluster $ClusterName .

###################################################
#  Checking ClusterService service group
#
#   1.Checking ClusterService AutoStart .
#   2.Checking ClusterService AutoStartList .
#   3.Checking hasys list eq AutoStartList.
#   4.Checking Single node resource 
#       a.checking res wac
#   5.Checking A multi node resource.
#       a.checking res csgnic
#       b.checking res csgip
#          --check csgip address eq clusteraddress.
#       c.checking res wac
###################################################
#Add service group ClusterService
Add_grp_ClusterService()
{
Priority=0
SystemList=""
AutoStartList=""
for nid in `hasys -list -localclus`
do
 SystemList=$SystemList$nid" "$Priority" "
 Priority=`expr $Priority + 1`
 AutoStartList=$AutoStartList$nid" "
done
#echo $SystemList
echo
echo ----------Add Group ClusterService-------------------- 
echo "hagrp -add  ClusterService "
echo "hagrp -modify ClusterService SystemList $SystemList "
echo "hagrp -modify ClusterService AutoStartList $AutoStartList "
echo "hagrp -modify ClusterService Parallel 0 "
echo ---------End Add Group ClusterService-------------------- 
echo
}

#Add res wac 
Add_res_wac()
{
echo
echo ------------Add res wac in ClusterService--------------------- 
echo "hares -add  wac  Application ClusterService "
echo "hares -modify wac Critical 1 "
echo "hares -modify wac User root"
echo "hares -modify wac UseSUDash 0"
echo "hares -modify wac StartProgram /opt/VRTSvcs/bin/wacstart "
echo "hares -modify wac StopProgram /opt/VRTSvcs/bin/wacstop"
echo "hares -modify wac PidFiles -delete -keys "
echo "hares -modify wac MonitorProcesses /opt/VRTSvcs/bin/wac"
echo "hares -modify wac Enabled 1 "
echo ------------End Add res wac in ClusterService--------------------- 
echo
}

#Add res csgip
Add_res_csgip(){
echo
echo ------------Add res csgip in ClusterService--------------------
echo "hares -add  csgip  IP  ClusterService"
echo "hares -modify csgip Critical 1"
echo "hares -modify csgip PrefixLen  1000"
echo "hares -modify csgip Device  网卡名称"
echo "hares -modify csgip Address IP地址(10.x.x.x)"
echo "hares -modify csgip NetMask 子网掩码(255.255.255.0) "
echo "hares -modify csgip Enabled 1"
echo ------------End Add res csgip in ClusterService--------------------
echo
}
	
#Add res csgnic
Add_res_csgnic(){
echo
echo ------------Add res csgnic in ClusterService------------------
echo "hares -add  csgnic  NIC  ClusterService"
echo "hares -modify csgnic Critical 1"
echo "hares -modify csgnic PingOptimize 0 "
echo "hares -modify csgnic Mii  1 "
echo "hares -modify csgnic Device NIC网卡名称"
echo "hares -modify csgnic NetworkHosts -delete -keys"
echo "hares -modify csgnic Enabled 1"
echo ------------End Add res csgnic in ClusterService------------------
echo
}

#Add lowpri
Add_lowpri(){
echo
echo --------------Add lowpri-----------------------------
echo "VCS添加lowpri心跳变更步骤："
echo "No.1 请先冻结相关系统资源，并检查资源状态是否正常；"
echo "No.2 检查vcs心跳是否正常，执行lltstat -vvn；检查gab是否正常，执行gabconfig -a"
echo "No.3 上述检查均正常后，可进行添加lowpri心跳变更"
echo
echo "1.在两节点上停止vcs进程，hastop -local -force"
echo "2.在两节点上停止gab,执行 gabconfig -u"
echo "3.在两节点上停止llt,执行 lltconfig -U"
echo "4.在两节点上备份llttab，执行 cp /etc/llttab /etc/llttab.bak"
echo "5.分别编辑/etc/llttab文件，例如："
echo "  vi /etc/llttab"
echo "  set-node RX8603P7_vcs"
echo "  set-cluster 1039"
echo "  link lan2 /dev/lan:2 - ether - -"
echo "  link lan4 /dev/lan:4 - ether - -"
echo "  添加生产网卡，Hp unix通常为lan900,Linux通常为bond0,AIX通常为en12"
echo
echo "  vi /etc/llttab"
echo "  set-node RX8603P7_vcs"
echo "  set-cluster 1039"
echo "  link lan2 /dev/lan:2 - ether - -"
echo "  link lan4 /dev/lan:4 - ether - -"
echo "  link-lowpri lan900 /dev/lan:900 - ether - -"
echo "6.在两节点上完成编辑/etc/llttab后，在两节点上分别执行:lltconfig -c"
echo "7.执行完lltconfig -c后，通过lltstat -vvn检查"
echo "8.检查没有问题后，在两节点上分别执行:gabconfig -c -n2"
echo "9.在两节点上启动vcs进程,分别执行：hastart"
echo "10.检查资源运行情况，如果没有问题，请解冻资源"
echo -------------End Add lowpri-------------------------- 
echo
}
#########################################################################
if [ `hagrp -list -localclus | grep ClusterService | wc -l ` -eq 0 ]
 then 
    echo --ERROR, ClusterService service group Not configured!
    Add_grp_ClusterService >> $VCS_COMM_FILE 
    Add_res_wac >> $VCS_COMM_FILE
    echo "sleep 5" >> $VCS_COMM_FILE
    echo "hagrp -online ClusterService -any" >> $VCS_COMM_FILE
    ecode=`expr $ecode + 1`
 else
   # Checking ClusterService AutoStart value.
   if [ `hagrp -value ClusterService AutoStart -localclus` -eq 0 ]
   then 
     echo --ERROR, Please set ClusterService service group autostart ! - AutoStart: 0  
     echo "hagrp -modify ClusterService AutoStart 1" >> $VCS_COMM_FILE
     ecode=`expr $ecode + 1`
   fi

   #-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
   # Checking ClusterService AutoStartList value.
   if [ `hagrp -value ClusterService AutoStartList -localclus | grep -v ^$ | wc -l` -eq 0 ]
    then 
      echo --ERROR, Please add some system to ClusterService service group autostartlist! - AutoStartList: Empty! 
      echo hagrp -modify ClusterService AutoStartList `hasys -list -localclus | awk '{{printf"%s ",$0}}'` >> $VCS_COMM_FILE
      ecode=`expr $ecode + 1`
   else 
   # Checking hasys list eq AutoStartList.
     SYSNODES=`hasys -list -localclus |grep -v ^$`
     if [ "x$SYSNODES" = x ]
      then
        echo --WARNING, hasys list Empty!
        wcode=`expr $wcode + 1`
      else 
       for sys in $SYSNODES
        do
         if [ `hagrp -value ClusterService AutoStartList -localclus | grep $sys | wc -l` -eq 0 ]
          then
            echo --ERROR, hasys list node $sys is not in AutoStartList. 
            echo hagrp -modify ClusterService AutoStartList -add $sys >> $VCS_COMM_FILE
            ecode=`expr $ecode + 1`
         fi 
        done
     fi
   fi

   #-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
   # Checking Single node resource. 
     if [ `hasys -list -localclus |wc -l` -eq 1 ]
       then
         if [ `hares -display -group ClusterService  |awk '{ print $1}' |grep -v "#" |uniq |grep wac |wc -l` -eq 0 ]
          then
            echo --ERROR, Single node, wac res not in ClusterService!
            Add_res_wac >> $VCS_COMM_FILE
            ecode=`expr $ecode + 1`
         fi            
     fi 

   #-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
   # Checking A multi node resource.
     if [ `hasys -list -localclus|wc -l` -eq 2 ]
       then
        #check csgnic res
        if [ `hares -display -group ClusterService  |awk '{ print $1}' |grep -v "#" |uniq |grep csgnic |wc -l` -eq 0 ]
          then
            echo --ERROR, A multi node, csgnic res not in ClusterService!
            Add_res_csgnic >> $VCS_COMM_FILE
            ecode=`expr $ecode + 1`
        fi 

        #check csgip res
        if [ `hares -display -group ClusterService  |awk '{ print $1}' |grep -v "#" |uniq |grep csgip |wc -l` -eq 0 ]
          then
            echo --ERROR, A multi node, csgip res not in ClusterService!
            Add_res_csgip >> $VCS_COMM_FILE
            echo "hares -link csgip csgnic" >> $VCS_COMM_FILE
            ecode=`expr $ecode + 1`
        fi 

        #check wac res
        if [ `hares -display -group ClusterService  |awk '{ print $1}' |grep -v "#" |uniq |grep wac |wc -l` -eq 0 ]
          then
            echo --ERROR,A multi node, wac res not in ClusterService!
            Add_res_wac >> $VCS_COMM_FILE
            echo "hares -link wac csgip" >> $VCS_COMM_FILE
            echo "sleep 5" >>  $VCS_COMM_FILE
            echo hares -online wac -sys `hagrp -state ClusterService |grep ONLINE |awk ' { print $3}'` >> $VCS_COMM_FILE
            ecode=`expr $ecode + 1`
        fi 
     fi
   #-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
   # Check /etc/llttab including link-lowpri
     if [ `hasys -list |awk -F : '{ print $2 }' |wc -l` -eq 4 ] 
       then
        if [ -f /etc/llttab ]
          then
           if [ `cat /etc/llttab |grep link-lowpri | wc -l ` -eq 0 ] 
             then
              echo --ERROR, link-lowpri not in /etc/llttab file!
              Add_lowpri >> $VCS_COMM_FILE
              ecode=`expr $ecode + 1`
           fi 
        fi 
     fi
     
   #-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
   # Check csgip address eq clusteraddress.
    if [ `hasys -list | awk -F: '{ print $2 }' |wc -l ` -eq 4 ]
     then
       if [ `haclus -value ClusterAddress|grep -v ^$ | wc -l` -eq 0 ]
         then
           echo --WANING, GCO ClusterAddress Empty.
           wcode=`expr $wcode + 1`
         else
         if [ "`hares -value csgip Address |grep -v ^$`" != "`haclus -value ClusterAddress|grep -v ^$`" ]
           then
             echo --ERROR, Res cgsip Attr Address value != ClusterAddress value! 
             ecode=`expr $ecode + 1`
         fi
      fi
    fi
fi 
echo Complete checking Configuration of cluster $ClusterName
echo

###########################################################
# Check the all Service group (except ClusterService)
#   1.checking service group AutoStart\AutoStartList attr.
###########################################################
echo
echo Checking service group AutoStart and AutoStartList attibute:
ServiceGroupListNum=`hagrp -list -localclus | grep -v ClusterService | awk '{ print $1}' | uniq |wc -l| grep -v ^$ `
if [ $ServiceGroupListNum -eq 0 ]
 then
   echo --WARNING, service resource group Not configured!
   wcode=`expr $wcode + 1`
else 
 ServiceGroupList=`hagrp -list -localclus | grep -v ClusterService | awk '{ print $1}' | uniq | grep -v ^$ `
 for grp in $ServiceGroupList
 do 
   # checking AutoStart: 0
       if [ `hagrp -value $grp AutoStart -localclus` -eq 1 ]
       then 
        echo --ERROR, Please DO NOT set this service group autostart! ServiceGroup $grp - AutoStart: 1 
        echo "hagrp -modify $grp AutoStart 0" >> $VCS_COMM_FILE
        ecode=`expr $ecode + 1`
       fi
       if [ `hagrp -value $grp AutoStartList -localclus | grep -v ^$ | wc -l ` -gt 0 ]
       then
        echo --ERROR, Please empty this service group autostartlist! ServiceGroup $grp - AutoStartList: not empty! 
        echo "hagrp -modify $grp AutoStartList -delete -keys" >> $VCS_COMM_FILE 
        ecode=`expr $ecode + 1`
       fi
 done
fi
echo Checking service group AutoStart and AutoStartList attibute completed.

#####################################################################
#   Checking critical resources
#    1.criticalTypes: NIC IP LVMVolumeGroup LVMVG Oracle Netlsnr Proxy
#####################################################################
echo
echo Checking resources critical attribute:

if [ -f $CriticalPATH/vcs_critical_res.conf ]
  then
  if [ `cat $CriticalPATH/vcs_critical_res.conf | grep -v "#" |wc -l ` -ge 1 ]  
   then 
      DefaultCriticalCheck=1 
      IsCriticalRes=1
  fi  
fi

if [ -f $CriticalPATH/vcs_nonecritical_res.conf ]
  then
  if [ `cat $CriticalPATH/vcs_nonecritical_res.conf | grep -v "#" |wc -l ` -ge 1 ]  
   then 
      DefaultCriticalCheck=1 
      IsNoneCriticalRes=1
  fi  
fi

ResourceList=`hares -list -localclus |grep -v wac | awk '{ print $1}' | uniq | grep -v ^$ `
#echo ----------------------DefaultCriticalCheck:$DefaultCriticalCheck--------------------
if [ $DefaultCriticalCheck -eq 0 ]
 then
 for rs in $ResourceList
 do
   IsCritical=`hares -value $rs Critical`
   rstyp=`hares -value $rs Type`
   if [ `echo $CriticalTypes | grep $rstyp | wc -l ` -eq 1 ]
    then 
     if [ $IsCritical -ne 1 ]
       then
        echo --ERROR, should be Critical. $rs : Type=$rstyp, Critical=$IsCritical. 
        echo "hares -modify $rs Critical 1" >> $VCS_COMM_FILE
        ecode=`expr $ecode + 1`
     fi
   elif [ `echo $NoneCriticalTypes | grep $rstyp | wc -l ` -eq 1 ]
    then 
        if [ $IsCritical -ne 0 ]
        then 
          echo --ERROR, should NOT be Critical. $rs : Type=$rstyp, Critical=$IsCritical. 
          echo "hares -modify $rs Critical 0" >> $VCS_COMM_FILE  
          ecode=`expr $ecode + 1`
        fi
    #else
    #  echo --WARNING, could not comfirm Critical. $rs : Type=$rstyp, Critical=$IsCritical.   
    #  wcode=`expr $wcode + 1`
   fi
 done 
else 
 if [ $IsCriticalRes -eq 1 ]
  then
   for IsRs in `cat $CriticalPATH/vcs_critical_res.conf | grep -v "#" |grep -v ^$` 
    do
     if [ `hares -list -localclus |grep $IsRs | awk '{ print $1}' | uniq | wc -l` -eq 1 ] 
      then
       if [ `hares -value $IsRs Critical` -ne 1 ] 
        then
          echo -- ERROR, should be Critical. $IsRs : Type=`hares -value $IsRs Type` . 
          echo "hares -modify $IsRs Critical 1" >> $VCS_COMM_FILE 
          ecode=`expr $ecode + 1`
        fi
     else
       echo --WARNING, $IsRs could not comfirm Critical.
       wcode=`expr $wcode + 1`
     fi
    done
 fi 
 if [ $IsNoneCriticalRes -eq 1 ]
  then
   for IsNoneRs in `cat $CriticalPATH/vcs_nonecritical_res.conf | grep -v "#" |grep -v ^$`
    do
     if [ `hares -list -localclus |grep $IsNoneRs | awk '{ print $1}' | uniq | wc -l` -eq 1 ] 
      then
       if [ `hares -value $IsNoneRs Critical` -ne 0 ]
        then
         echo --ERROR: should NOT be Critical. $IsNoneRs : Type=`hares -value $IsNoneRs Type`. 
         echo "hares -modify $IsNoneRs Critical 0" >> $VCS_COMM_FILE  
         ecode=`expr $ecode + 1`
       fi
     else
       echo --WARNING, $IsNoneRs could not comfirm Critical.
       wcode=`expr $wcode + 1`
     fi
    done
 fi 
fi
echo Complete checking resources critical attribute.
echo

#################################
#   Checking NIC setting
#################################
echo
echo Checking NIC resource setting:
NICRS=`hares -list Type=NIC -localclus |awk '{ print $1}' | uniq | grep -v ^$ `
if [ "x$NICRS" = x ]
then
  echo --NOTE, there is no NIC resource.
else
#---AIX not check.
if [ `uname` != AIX ]
 then
 for rs in $NICRS
 do
   # PingOptimize = 0
   if [ `hares -value $rs PingOptimize` -ne 0 ]
   then
      echo --ERROR, Please set $rs : PingOptimize to 0.
      echo "hares -modify $rs PingOptimize 0" >>$VCS_COMM_FILE
      ecode=`expr $ecode + 1`
   fi
 done
fi

 if [ ` hatype -value NIC ToleranceLimit` -ne 1 ]
 then 
   echo --ERROR, Please set NIC : ToleranceLimit to 1.
   echo "hatype -modify NIC ToleranceLimit  1 " >> $VCS_COMM_FILE
   ecode=`expr $ecode + 1`
 fi
fi
echo Complete Checking NIC resource setting.
echo

#############################
#  Checking IP setting
#############################
echo
echo Checking IP resource setting:
IPRS=`hares -list Type=IP -localclus |awk '{ print $1}' | uniq | grep -v ^$ `
if [ "x$IPRS" = x ]
then
  echo --NOTE, there is no IP resource.
else
  for rs in $IPRS
  do
  # IP netmask ="255.255.255.0"
    if [ "`hares -value $rs NetMask`" != "255.255.255.0" ]
      then
        echo --ERROR, Please set $rs : NetMask to "255.255.255.0" . NetMask=`hares -value $rs NetMask`.
        echo "hares -modify $rs NetMask  255.255.255.0 " >> $VCS_COMM_FILE
        ecode=`expr $ecode + 1`
    fi
  done
fi
echo Complete Checking IP resource setting.
echo

##############################################
# Checking LVMVG(AIX) resource configuration
#    1.checking OnlineRetryLimit=2
#    2.checking OnlineWaitLimit=1
#    3.checking SyncODM=0
##############################################
if [ `uname` = AIX ]
then
echo
echo Checking LVMVG resource setting
LVMVGRS=`hares -list Type=LVMVG -localclus |awk '{ print $1}' | uniq | grep -v ^$ `
if [ "x$LVMVGRS" = x ]
then
  echo --NOTE, there is no LVMVG resource.
else
  for rs in $LVMVGRS
  do
    # SyncODM= 0
     if [ `hares -value $rs SyncODM ` -ne 0 ]
       then
          echo --ERROR, Please set $rs : SyncODM to 0.
          echo "hares -modify $rs SyncODM 0" >> $VCS_COMM_FILE 
          ecode=`expr $ecode + 1`
     fi
  done

  # LVMVG type OnlineRetryLimit=2
  if [ `hatype -value LVMVG OnlineRetryLimit` -ne 2 ]
  then
     echo --ERROR, Please set LVMVG : OnlineRetryLimit to 2.
     echo "hatype -modify LVMVG OnlineRetryLimit  2" >> $VCS_COMM_FILE
     ecode=`expr $ecode + 1`
  fi

  # LVMVG type OnlineWaitLimit=1
  if [ `hatype -value LVMVG OnlineWaitLimit` -ne 1 ]
  then
     echo --ERROR, Please set LVMVG : OnlineWaitLimit to 1.
     echo "hatype -modify LVMVG OnlineWaitLimit  1" >> $VCS_COMM_FILE
     ecode=`expr $ecode + 1`
  fi
fi
echo Complete Checking LVMVG resource setting.
echo
fi

#################################################
# Checking  Mount resource configuration
#   1.checking OnlineRetryLimit=1.
#   2.checking MountPoint in :
#        Solaris: /etc/vfstab
#        HP-UX  : /etc/fstab
#        AIX    : /etc/filesystems
#        Linux  : /etc/fstab
#   3.checking VxFSMountLock default false.
################################################
echo
echo Checking Mount resource setting:
MOUNTRS=`hares -list Type=Mount -localclus |awk '{ print $1}' | uniq`
if [ "x$MOUNTRS" = x ]
then
  echo --NOTE, there is no Mount resource.
else
 PLATFORM=`uname`
 if [ $PLATFORM = AIX ]
  then 
     FILETABLE="/etc/filesystems"
 elif [ $PLATFORM = HP-UX ]
  then
     FILETABLE="/etc/fstab"
 elif [ $PLATFORM = Solaris ]
  then
     FILETABLE="/etc/vfstab"
 elif [ $PLATFORM = Linux ]
  then
     FILETABLE="/etc/fstab"
 else
    FILETABLE="mount"
 fi

for rs in $MOUNTRS
do
  # MountPoint in FILETABLE.
  if [ x`hares -value $rs FSType ` = xvxfs ]
    then
     if [ $FILETABLE != mount ]
       then 
        MountPoint=`hares -value $rs MountPoint` 
        if [ `cat $FILETABLE | grep $MountPoint | wc -l` -eq 0 ]
          then
           if [ `mount |grep $MountPoint | wc -l` -eq 0 ]
             then
              echo --WARNING, $rs : MountPoint=$MountPoint not in $FILETABLE and not find MountPoint!
              wcode=`expr $wcode + 1`
           fi
        fi
       else 
        echo --NOTE, Checking Platform not in AIX,HP-UX,Linux,Solars.  
     fi
   # VxFSMountLock = false ,not check vcs5.0 
   if [ `hastart -version |grep "Engine Version" |awk '{ print $3 }' |grep -v ^$` != 5.0 ]
    then
     if [ `hares -value $rs VxFSMountLock` -ne 0 ]
      then
       echo --ERROR, Please set $rs : VxFSMountLock to 0 or false. 
       echo "hares -modify $rs VxFSMountLock 0" >> $VCS_COMM_FILE
       ecode=`expr $ecode + 1`
     fi
   fi
  fi
done
  # Mount type OnlineRetryLimit = 1
  if [ `hatype -value Mount OnlineRetryLimit` -ne 1 ]
  then
     echo --ERROR, Please set Mount : OnlineRetryLimit to 1.
     echo "hatype -modify Mount OnlineRetryLimit  1" >> $VCS_COMM_FILE
     ecode=`expr $ecode + 1`
  fi
fi
echo Complete Checking Mount resource setting.
echo

##################################
# Checking Oracle Netlsnr setting
#   1.checking oracle listener
##################################
echo
echo Checking Oracle Netlsnr resource setting:
NetlsnrRS=`hares -list Type=Netlsnr -localclus |awk '{ print $1}' | uniq | grep -v ^$`
if [ "x$NetlsnrRS" = x ]
then
  echo --NOTE, there is no Oracle Netlsnr resource.
else
for rs in $NetlsnrRS
do
  # Listener value = listener.ora 
  ORACLE_HOME=`hares -value $rs Home`
  Listener=`hares -value $rs Listener`
  if [ x$Listener = x ]
    then
      Listener="LISTENER";
  fi

  if [ x$ORACLE_HOME = x ]
    then
      echo --ERROR, $rs : Home value Empty!
      ecode=`expr $ecode + 1`
  else 
    if [ -f $ORACLE_HOME/network/admin/listener.ora ]
     then 
       x_Listener=$(echo $Listener | tr [a-z] [A-Z])

       LIS_NAME=`cat $ORACLE_HOME/network/admin/listener.ora |grep -i $Listener |awk '{ print $1}'`
       ListenerN=0 
       for lname in $LIS_NAME
       do 
         x_lname=$(echo $lname | tr [a-z] [A-Z])
         if [ $x_lname = $x_Listener ]
           then
            ListenerN=`expr $ListenerN + 1`
         fi 
       done
       if [ $ListenerN -eq 0  ]
       then
          echo --ERROR, $rs : Listener=$Listener not in listener.ora file!
          ecode=`expr $ecode + 1`
        fi
      else 
        echo --WARNING, no $ORACLE_HOME/network/admin/listener.ora file. 
        wcode=`expr $wcode + 1`
      fi
  fi
done
fi
echo Complete Checking Oracle Netlsnr resource setting.
echo

######################################################
# Checking Application resource setting.
#   1.checking app res User is root.
#   2.checking app type OnlineTimeout=3600
#   3.checking app scripts directory and permissions
######################################################
echo
echo Checking Application resource setting:
APPRS=`hares -list Type=Application -localclus | grep -v wac |awk '{ print $1}' | uniq | grep -v ^$`
if [ "x$APPRS" = x ]
then
  echo --NOTE, there is no Application resource.
else
for rs in $APPRS
do
  # User = root
  if [ `hares -value $rs User` != root ]
    then
      echo --WANNING, Please set $rs : User to root. User=`hares -value $rs User`. 
      wcode=`expr $wcode + 1`
  fi
  # StartProgram script directory.
  if [ `hares -value $rs StartProgram |grep $APP_SCRIPT_PATH |wc -l` -eq 0 ]
    then
     echo --ERROR,Please set $rs : StartProgram script directory $APP_SCRIPT_PATH/. 
     ecode=`expr $ecode + 1`
  fi

  # StopProgram script directory.
  if [ `hares -value $rs StopProgram |grep $APP_SCRIPT_PATH |wc -l` -eq 0 ]
    then
     echo --ERROR,Please set $rs : StopProgram script directory $APP_SCRIPT_PATH/. 
     ecode=`expr $ecode + 1`
  fi

  # MonitorProgram script directory.
  if [ `hares -value $rs MonitorProgram |grep $APP_SCRIPT_PATH |wc -l` -eq 0 ]
    then
     echo --ERROR,Please set $rs : MonitorProgram script directory $APP_SCRIPT_PATH/. 
     ecode=`expr $ecode + 1`
  fi
done
  # Application type OnlineTimeout=3600 
  if [ `hatype -value Application OnlineTimeout` -ne 3600 ]
  then
     echo --ERROR, Please set Application : OnlineTimeout to 3600.
     echo "hatype -modify Application OnlineTimeout  3600" >> $VCS_COMM_FILE
     ecode=`expr $ecode + 1`
  fi

  # Application type OfflineTimeout=3600 
  if [ `hatype -value Application OfflineTimeout` -ne 3600 ]
  then
     echo --ERROR, Please set Application : OfflineTimeout to 3600.
     echo "hatype -modify Application OfflineTimeout  3600" >> $VCS_COMM_FILE
     ecode=`expr $ecode + 1`
  fi
  
  
  # checking script directory permissions.
  if [ -d $APP_SCRIPT_PATH ]
    then
      if [ `ls -lt $SCRIPT_PATH |grep cebscripts |awk '{ if ( $NF == "cebscripts" ) { print $1 }}' |grep -v ^$` != drwxr-xr-x ]
        then
          echo --WANNING,$APP_SCRIPT_PATH directory permissions not 755.
          wcode=`expr $wcode + 1`
      fi
      if [ `ls -lt $SCRIPT_PATH |grep cebscripts |awk '{ if ( $NF == "cebscripts" ) { print $3 }}' |grep -v ^$` != root ]
        then
          echo --WANNING,$APP_SCRIPT_PATH directory owner not root.
          wcode=`expr $wcode + 1`
      fi
    else
      echo --NOTE,Please create app script dir: $APP_SCRIPT_PATH.
  fi
fi
echo Complete Checking Application resource setting.
echo

###########################################
# Checking SRDF resource configuration
#   1.checking AutoTakeover = 1.
#   2.checking Swaproles = 0.
#   3.checking SRDF aget script failback.
###########################################
echo 
echo Checking SRDF resource setting:
SRDFRS=`hares -list Type=SRDF -localclus |awk '{ print $1}' | uniq | grep -v ^$ `
if [ "x$SRDFRS" = x ]
then
  echo --NOTE, there is no SRDF resource.
else
 for rs in $SRDFRS
 do
  # AutoTakeover = 1
  if [ `hares -value $rs AutoTakeover` -ne 1 ]
  then
     echo --ERROR, Please set $rs : AutoTakeover to 1.
     echo "hares -modify $rs AutoTakeover 1" >> $VCS_COMM_FILE
     ecode=`expr $ecode + 1`
  fi
  # SwapRoles = 0
  if [ `hares -value $rs SwapRoles` -ne 0 ]
  then
     echo -- ERROR, Please set $rs : SwapRoles to 0.
     echo "hares -modify $rs SwapRoles 0" >> $VCS_COMM_FILE
     ecode=`expr $ecode + 1`
  fi
 done
 # checking SRDF agent: Online exluding failback.
 if [ `grep "res->failback" /opt/VRTSvcs/bin/SRDF/online |grep -c "#"` -eq 0  ]
 then
   echo --ERROR, Please disable this function. SRDF Agent online scripts: failback enable.  
   ecode=`expr $ecode + 1`
 fi
fi
echo Complete Checking SRDF resource setting.
echo

###############################################################
# Checking SRDFStar resource configuration
#   1. checking TripTakeover = 0 .
#   2. checking ForceOnline = 1.
#   3. checking HaltOnOffline = 0 .
#   4. checking SRDFStar agent online script.
#      Request by CEB, online SRDFstar when switch, halt first.
################################################################
echo 
echo Checking SRDFStar resource setting:
SRDFStarRS=`hares -list Type=SRDFStar -localclus |awk '{ print $1}' | uniq | grep -v ^$ `
if [ "x$SRDFStarRS" = x ]
then
  echo --NOTE, there is no SRDFStar resource.
else
for rs in $SRDFStarRS
do
  # TripTakeover  = 0
  if [ `hares -value $rs TripTakeover` -ne 0 ]
  then
     echo --ERROR, Please set $rs : TripTakeover to 0.
     echo "hares -modify $rs TripTakeover 0" >> $VCS_COMM_FILE
     ecode=`expr $ecode + 1`
  fi

  # ForceOnline = 1
  if [ `hares -value $rs ForceOnline` -ne 1 ]
  then
     echo --ERROR, Please set $rs : ForceOnline to 1.
     echo "hares -modify $rs ForceOnline 1" >> $VCS_COMM_FILE
     ecode=`expr $ecode + 1`
  fi

  # HaltOnOffline = 0
  if [ `hares -value $rs HaltOnOffline` -ne 0 ]
  then
     echo --ERROR, Please set $rs : HaltOnOffline to 0.
     echo "hares -modify $rs HaltOnOffline 0" >> $VCS_COMM_FILE
     ecode=`expr $ecode + 1`
  fi
done

# Checking SRDFStar agent: Online.
if [ `grep "firstSite" /opt/VRTSvcs/bin/SRDFStar/online | wc -l` -eq 0  ]
then
   echo -- ERROR, Not joined when switch, halt first. SRDFStar Agent online scripts.
   ecode=`expr $ecode + 1`
fi
fi
echo Complete Checking SRDFStar resource setting.
echo

#########################################################
# Checking hauser list contain user 150 or 151 .
#   1.root_AT_bl680_DASH_150_AT_unixpwd
#   2.root_AT_bl680_DASH_151_AT_unixpwd 
########################################################
echo 
echo Checking hauser list setting:
HAUSERN1=`hauser -list |grep root_AT_bl680_DASH_150_AT_unixpwd |wc -l`
HAUSERN2=`hauser -list |grep root_AT_bl680_DASH_151_AT_unixpwd |wc -l`

HAUSERNUM=`expr $HAUSERN1 + $HAUSERN2`

if [ $HAUSERNUM -eq 0 ]
then
  echo --ERROR, This cluster is not added to the CMC, Please contact VCS Administrator.
  ecode=`expr $ecode + 1`
fi
echo Complete Checking hauser list setting.
echo

#######################################################
# Checking No Critical resource Override Attribute setting 
#   1.No Critical resource.
#   2.Override Attribute FaultPropagation
#######################################################
echo 
echo Checking No Critical resource Override Attribute setting:
if [ `hastart -version |grep "Engine Version" |awk '{ print $3 }' |grep -v ^$` != 5.0 ]
  then
  ResourceList=`hares -list -localclus |grep -v wac | awk '{ print $1}' | uniq | grep -v ^$ `
  for rs in $ResourceList 
  do
    if [ `hares -value $rs Critical` -eq 0 ]
      then 
      if [ `hares -display -localclus $rs |grep FaultPropagation |wc -l` -eq 0 ]
        then 
        echo --WARNNING, $rs need to be added Override Attribute FaultPropagation.
        echo "hares -override $rs FaultPropagation " >> $VCS_COMM_FILE.WARN
        echo "hares -modify $rs FaultPropagation 0" >> $VCS_COMM_FILE.WARN
        wcode=`expr $wcode + 1`
        else 
         if [ `hares -value $rs FaultPropagation` -eq 1 ]
           then
            echo --ERROR, Plase set $rs : FaultPropagation to 0.
            echo "hares -modify $rs FaultPropagation 0" >> $VCS_COMM_FILE
            ecode=`expr $ecode + 1`
         fi 
      fi
    fi
  done
  else 
    echo --WARNNING,VCS version 5.0 ,No Override Attribute . Please contact the administrator to upgrade!
    wcode=`expr $wcode + 1`
fi
echo Complete Checking No Critical resource Override Attribute setting.
echo

echo ======================================================================================
echo VCS configuration verification report check ERROR number: $ecode
if [ `cat $VCS_COMM_FILE |wc -l` -ne 0 ]
  then
    echo
    echo "haconf -makerw"
    cat $VCS_COMM_FILE 
    echo "haconf -dump -makero"
    echo
fi
rm -f $VCS_COMM_FILE
echo
echo VCS configuration verification report check WANNING number: $wcode 
if [ -f $VCS_COMM_FILE.WARN ]
 then 
   echo
   echo "haconf -makerw" 
   cat $VCS_COMM_FILE.WARN
   echo "haconf -dump -makero"
   echo
   rm -f $VCS_COMM_FILE.WARN
fi
echo ======================================================================================
exit $ecode
