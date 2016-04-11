#!/bin/bash
# 许成林
# 2015-01
# Version 1.0
# setup index
##############################################################

source /sbin/setenv.sh

readme
index1

case  `cat /tmp/setup/index` in
        1)
          /sbin/baseset.sh
		;;
        2)
          /sbin/appset.sh
		;;
        3)
          python /sbin/checkfix.pyc
		;;
        4)
           exit;;
        *)
           echo "请选择以上选项!"
esac