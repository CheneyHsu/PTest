#!/bin/bash
# 许成林
# 2015-01
# Version 1.0
# base setup env
##############################################################
source /sbin/setenv.sh


clear

#tput cup 5 15

function cswap()
{
cat /etc/fstab  | grep swap
if [ $? = 0 ];then
    dialog    --title   "创建swap分区"   --msgbox  "检测到swap分区存在，无需创建!" 8  35
    sleep 2s
else
    Ssize=`free -m  | grep Mem | awk '{print $2}'`
    if [ "$Ssize" -le "4096" ];then
        c=`echo $(expr $Ssize + $Ssize)`
        lvcreate -n lv_swap -L +${c}M /dev/vg_system
        echo "/dev/vg_system/lv_swap    swap   swap  defaults   0 0" >> /etc/fstab
    elif [ "$Ssize" -gt "4096" ] && [ "$Ssize" -le "16384" ];then
        lvcreate -n lv_swap -L +${Ssize}M /dev/vg_system
        echo "/dev/vg_system/lv_swap    swap   swap  defaults   0 0" >> /etc/fstab
    elif [ "$Ssize" -gt "16384" ] && [ "$Ssize" -le "32768" ];then
        lvcreate -n lv_swap -L +16G /dev/vg_system
        echo "/dev/vg_system/lv_swap    swap   swap  defaults   0 0" >> /etc/fstab
    elif [ "$Ssize" -gt "32768" ] ;then
        lvcreate -n lv_swap -L +32G /dev/vg_system
        echo "/dev/vg_system/lv_swap    swap   swap  defaults   0 0" >> /etc/fstab
    fi
    mkswap /dev/vg_system/lv_swap
    swapon -a
fi
}

function netset()
{
dialog    --title   "网络模式"   --yesno  "确定不使用bonding模式么?"  8  32
if [ $? = 0 ];then
    rm -rf /tmp/setup/*
    for i in {0..7};do ethtool eth$i | grep 'Link detected: yes'; if [ $? = 0 ];then echo eth$i >> /tmp/setup/net1 ; else echo error >> /tmp/setup/net1 ;fi ; done
    exec 3>&1
    VALUES=$(dialog --backtitle "网络配置" --menu "可使用的网卡" 20 50 10 eth0 `sed -n 1p /tmp/setup/net1`  eth1 `sed -n 2p /tmp/setup/net1`  eth2 `sed -n 3p /tmp/setup/net1`  eth3 `sed -n 4p /tmp/setup/net1`  eth4 `sed -n 5p /tmp/setup/net1`  eth5 `sed -n 6p /tmp/setup/net1`  eth6 `sed -n 7p /tmp/setup/net1`   eth7 `sed -n 8p /tmp/setup/net1` 2>&1 1>&3)
    exec 3>&-
    echo $VALUES > /tmp/setup/values
    for i in {0..7} ;do grep $i /tmp/setup/values ; if [ $? = 0 ];then echo eth$i >> /tmp/setup/values2 ; fi; done
    # open fd
    exec 3>&1

    # Store data to $VALUES variable
    VALUES=$(dialog --title "网卡配置" \
          --form "网卡配置" \
    15 50 0 \
        "IP:" 1 1 ""         1 10 25 0 \
        "NetMask:"    2 1 ""        2 10 25 0 \
        "GateWay:"    3 1 ""       3 10 25 0 \
        "DNS:"     4 1 ""         4 10 25 0 \
    2>&1 1>&3)

    # close fd
    exec 3>&-
    echo $VALUES > /tmp/setup/values3
    #ethx setup
    for i in `cat /tmp/setup/values2`;do
        sed -i 's/BOOTPROTO="dhcp"/BOOTPROTO="static"/g' /etc/sysconfig/network-scripts/ifcfg-$i
        sed -i 's/IPV6INIT="yes"/IPV6INIT="no"/g' /etc/sysconfig/network-scripts/ifcfg-$i
        sed -i 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/g' /etc/sysconfig/network-scripts/ifcfg-$i
        grep 'ONBOOT="yes"' /etc/sysconfig/network-scripts/ifcfg-$i
        if [ $? = 0 ];then
        :
        else
        sed -i 's/ONBOOT="no"/ONBOOT="yes"/g' /etc/sysconfig/network-scripts/ifcfg-$i
        fi
         echo "NETMASK=`awk '{print $2}'  /tmp/setup/values3`" >> /etc/sysconfig/network-scripts/ifcfg-$i
        echo "GATEWAY=`awk '{print $3}'  /tmp/setup/values3`" >> /etc/sysconfig/network-scripts/ifcfg-$i
        echo "IPADDR=`awk '{print $1}'  /tmp/setup/values3`" >> /etc/sysconfig/network-scripts/ifcfg-$i
        a=`awk '{print $4}'  /tmp/setup/values3`
        if [ "$a" = '' ];then : ; else echo " nameserver $a " > /etc/resolv.conf; fi
    done
    /etc/init.d/network restart

else
    rm -rf /tmp/setup/*
    for i in {0..7};do ethtool eth$i | grep 'Link detected: yes'; if [ $? = 0 ];then echo eth$i >> /tmp/setup/net1 ; else echo error >> /tmp/setup/net1 ;fi ; done
    exec 3>&1
    VALUES=$(dialog --backtitle "网络配置" --checklist "可用于bonding的网卡" 20 50 10 eth0 `sed -n 1p /tmp/setup/net1` 1 eth1 `sed -n 2p /tmp/setup/net1` 2  eth2 `sed -n 3p /tmp/setup/net1` 3 eth3 `sed -n 4p /tmp/setup/net1` 4 eth4 `sed -n 5p /tmp/setup/net1` 5 eth5 `sed -n 6p /tmp/setup/net1` 6 eth6 `sed -n 7p /tmp/setup/net1` 7  eth7 `sed -n 8p /tmp/setup/net1` 8 2>&1 1>&3)
    exec 3>&-
    echo $VALUES > /tmp/setup/values
    for i in {0..7} ;do grep $i /tmp/setup/values ; if [ $? = 0 ];then echo eth$i >> /tmp/setup/values2 ; fi; done
    # open fd
    exec 3>&1

    # Store data to $VALUES variable
    VALUES=$(dialog --title "bonding配置" \
          --form "bonding" \
    15 50 0 \
        "IP:" 1 1 ""         1 10 25 0 \
        "NetMask:"    2 1 ""        2 10 25 0 \
        "GateWay:"    3 1 ""       3 10 25 0 \
        "DNS:"     4 1 ""         4 10 25 0 \
    2>&1 1>&3)

    # close fd
    exec 3>&-
    echo $VALUES > /tmp/setup/values3

    #bonding setup
    echo "alias bond0 bonding" > /etc/modprobe.d/bond0.conf
    echo "options bond0 miimon=100 mode=1" >>/etc/modprobe.d/bond0
    echo "DEVICE=bond0" > /etc/sysconfig/network-scripts/ifcfg-bond0
    echo "USERCTL=no" >> /etc/sysconfig/network-scripts/ifcfg-bond0
    echo "BOOTPROTO=none" >> /etc/sysconfig/network-scripts/ifcfg-bond0
    echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-bond0
    echo "NETMASK=`awk '{print $2}'  /tmp/setup/values3`" >> /etc/sysconfig/network-scripts/ifcfg-bond0
    echo "GATEWAY=`awk '{print $3}'  /tmp/setup/values3`" >> /etc/sysconfig/network-scripts/ifcfg-bond0
    echo "IPADDR=`awk '{print $1}'  /tmp/setup/values3`" >> /etc/sysconfig/network-scripts/ifcfg-bond0
    a=`awk '{print $4}'  /tmp/setup/values3`
    if [ "$a" = '' ];then : ; else echo " nameserver $a " > /etc/resolv.conf; fi

    #ethx setup
    for i in `cat /tmp/setup/values2`;do
        sed -i 's/BOOTPROTO="dhcp"/BOOTPROTO="none"/g' /etc/sysconfig/network-scripts/ifcfg-$i
        sed -i 's/BOOTPROTO=dhcp/BOOTPROTO="none"/g' /etc/sysconfig/network-scripts/ifcfg-$i
        sed -i 's/IPV6INIT="yes"/IPV6INIT="no"/g' /etc/sysconfig/network-scripts/ifcfg-$i
        sed -i 's/NM_CONTROLLED="yes"/NM_CONTROLLED="no"/g' /etc/sysconfig/network-scripts/ifcfg-$i
        grep 'ONBOOT="yes"' /etc/sysconfig/network-scripts/ifcfg-$i
        if [ $? = 0 ];then
        :
        else
        sed -i 's/ONBOOT="no"/ONBOOT="yes"/g' /etc/sysconfig/network-scripts/ifcfg-$i
        fi
        echo "MASTER=bond0" >> /etc/sysconfig/network-scripts/ifcfg-$i
        echo "SLAVE=yes" >> /etc/sysconfig/network-scripts/ifcfg-$i
    done
    /etc/init.d/network restart
fi
}

function nameandip()
{
/etc/init.d/NetWorkManager stop
chkconfig NetWorkManager off
#主机名对应IP添加到hosts文件
dialog --title "计算机名" --inputbox "请输入计算机名称" 10 30  2> /tmp/setup/name
sed -i "s/HOSTNAME=localhost.localdomain/HOSTNAME="`cat /tmp/setup/name`"/g"  /etc/sysconfig/network
hostname `cat /tmp/setup/name`
dialog --title "hosts对应关系" --inputbox "请输入IP地址" 10 30  2> /tmp/setup/name
echo "`cat /tmp/setup/name`   $(hostname)" >> /etc/hosts
useradd  hrb
echo hrb | passwd --stdin hrb
}



mkdir /tmp/setup
function YN()
{
dialog --title "yes/no" --no-shadow --yesno "是否继续执行" 10 30
result=$?
if [ $result -eq 1 ]; then
  exit 255;
elif [ $result -eq 255 ]; then
  exit 255;
else
cswap
netset
nameandip
dialog  --title "完成"  --msgbox "配置已经完成,稍后请重计算." 5 50
index
fi
}
YN