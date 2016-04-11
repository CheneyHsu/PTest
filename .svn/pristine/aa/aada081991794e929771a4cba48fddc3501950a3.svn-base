#!/usr/bin/ksh
if [ -d /home/sysadmin ]
  then
    echo "/home/sysadmin OK"
  else
  mkdir -p /home/sysadmin
fi
cd /home/sysadmin
ftp  -v -n 10.200.8.87 <<EOF
user  hostinfo hostinfo
cd /hostinfo/hostinfo/script
get HPHostInfo.tar
bye
EOF
tar xf HPHostInfo.tar;
sh /home/sysadmin/HostInfoCollection/bin/Init.sh;

exit;

