#!/bin/bash
#Linux 
#2012-09-0-01 加主备机判断的部署
chmod -R 755  /home/sysadmin/HostInfoCollection
chown -R root:sys /home/sysadmin/HostInfoCollection
chown root:sys /home/sysadmin/collect_download.sh
LC_ALL=zh_CN
LANG=zh_CN


HOSTINFO()
{
#检查crontab中有没有配置管理的计划任务
crontab -u root -l |grep -q "/home/sysadmin/HostInfoCollection/Upload.sh"
if [ $? -ne 0 ]
  then
      crontab -u root -l > /home/sysadmin/HostInfoCollection/tmp/crontab.bak
      cp /home/sysadmin/HostInfoCollection/tmp/crontab.bak /home/sysadmin/HostInfoCollection/tmp/crontab.new
      echo "`date "+%M"` 06 * * * /home/sysadmin/HostInfoCollection/Upload.sh > /dev/null 2>&1" >> /home/sysadmin/HostInfoCollection/tmp/crontab.new
      crontab -u root /home/sysadmin/HostInfoCollection/tmp/crontab.new
	  #检查有没有设置成功
      crontab -u root -l |grep -q "/home/sysadmin/HostInfoCollection/Upload.sh"
      if [ $? -eq 0 ]
        then
          echo "02 crontab 设置完成"
        else
          echo "02 crontab 没有设置"
      fi
  else
      crondate=`crontab -u root -l |grep  "/home/sysadmin/HostInfoCollection/Upload.sh" |awk '{print $2}'`
	  if [ $crondate -eq "06" ]
	  then
	      echo "02 crontab 设置正确"
	  else 
          crontab -u root -l > /home/sysadmin/HostInfoCollection/tmp/crontab.bak
          cat /home/sysadmin/HostInfoCollection/tmp/crontab.bak  |grep -v "/home/sysadmin/HostInfoCollection/Upload.sh"  >/home/sysadmin/HostInfoCollection/tmp/crontab.new
          echo "`date "+%M"` 06 * * * /home/sysadmin/HostInfoCollection/Upload.sh > /dev/null 2>&1" >> /home/sysadmin/HostInfoCollection/tmp/crontab.new
          crontab -u root /home/sysadmin/HostInfoCollection/tmp/crontab.new
	  fi	  
fi



#检查profile设置
cat /etc/profile >/tmp/profile_bak.sh
cat /etc/profile |grep -q "/home/sysadmin/HostInfoCollection/conf/sysconf"
if [ $? -ne 0 ]
  then
    echo "echo" >>/etc/profile
    echo "echo" >>/etc/profile
    echo "cat /home/sysadmin/HostInfoCollection/conf/sysconf" >>/etc/profile
fi
cat /etc/profile |grep -q "/home/sysadmin/HostInfoCollection/conf/sysconf"
if [ $? -eq 0 ]
   then
    echo "03 /etc/profile 设置完成"
   else
    echo "03 /etc/profile  没有设置"
fi

# 判断有没有sysconf  没有就配置。有就打开查看，正确就不配置，不正确就配置。


if [ -f /home/sysadmin/HostInfoCollection/conf/sysconf  >/dev/null 2>&1 ]
  then
    cat /home/sysadmin/HostInfoCollection/conf/sysconf
echo "现在设置是否正确？"
echo "yes/no"
read nuvalue

case ${nuvalue} in
     no|n)
	 	
#set server info
#cp /home/sysadmin/HostInfoCollection/conf/sysconf  /home/sysadmin/HostInfoCollection/conf/sysconf.bak
 

echo "Please input Appname"
read AAAA

echo "Please input SysAdmin_A"
read BBBB

echo "Please Input SysAdmin_B"
read CCCC

echo "Please Input AppAdmin"
read DDDD

sed "s/AAAA/$AAAA/;s/BBBB/$BBBB/;s/CCCC/$CCCC/;s/DDDD/$DDDD/"  /home/sysadmin/HostInfoCollection/conf/sysconf.bak >/home/sysadmin/HostInfoCollection/conf/sysconf
chmod 777 /home/sysadmin/HostInfoCollection/conf/sysconf
echo
echo "Script deployed "
echo 
;;
 yes|y)
  echo "EXIT Configuration files";;
 *)
  echo "EXIT Configuration files" ;;
esac
    else
echo "Please input Appname"
read AAAA

echo "Please input SysAdmin_A"
read BBBB

echo "Please Input SysAdmin_B"
read CCCC

echo "Please Input AppAdmin"
read DDDD

sed "s/AAAA/$AAAA/;s/BBBB/$BBBB/;s/CCCC/$CCCC/;s/DDDD/$DDDD/"  /home/sysadmin/HostInfoCollection/conf/sysconf.bak >/home/sysadmin/HostInfoCollection/conf/sysconf
chmod 777 /home/sysadmin/HostInfoCollection/conf/sysconf
echo
echo "Script deployed "
echo 
fi

sh Init_systype.sh   #配置系统类型 2012-11-15
sh SetwlcInfo.sh    #配置weblogic信息

/home/sysadmin/HostInfoCollection/Upload.sh
}

HOSTINFO
