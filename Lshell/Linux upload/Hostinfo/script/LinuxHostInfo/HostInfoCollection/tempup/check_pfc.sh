#!/bin/sh
#开发测试机上的日常检查和性能采集 加入 crontab
cd /home/sysadmin/pfc_check/bin
sh setup.sh

cd /home/sysadmin/check/setup
sh setup.sh <<EOF
all
EOF
}

