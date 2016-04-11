#!/bin/bash
# 许成林
# 2015-01
# Version 1.0
# setup index
##############################################################

clear

function readme(){
dialog    --title   INDEX   --msgbox '
     For linux Setup Env (RHEL 6.4)

*    如果有任何问题，请联系我.

*    Cheney Hsu (KK)

*    Version 0.10

*    Mobile:+86 18611846133

*    Mail:  xuchenglin@hrbb.com.cn
'  20 40
}

function index1(){
rm -rf /tmp/setup/index
exec 3>&1
VALUES=$(dialog --title "INDEX" --menu "请选择" 12 35 5 \
1 "基础环境设置" 2 "Hadoop环境设置"  3 "上线检查" 4 "退出" 2>&1 1>&3)
exec 3>&-
echo $VALUES > /tmp/setup/index
}


function index(){
rm -rf /tmp/setup/index
exec 3>&1
VALUES=$(dialog --title "INDEX" --menu "请选择" 12 35 4 \
1 "基础环境设置" 2 "Hadoop环境设置"  3 "上线检查" 4 "退出" 2>&1 1>&3)
exec 3>&-
echo $VALUES > /tmp/setup/index
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
}
