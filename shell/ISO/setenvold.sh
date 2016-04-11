#!/bin/bash
# 许成林
# 2015-01
# Version 1.0
# For Setup System Env.
##############################################################
clear
echo '
#########################################################################################
		For linux Setup Env (RHEL 6.4)
*    如果有任何问题，请联系我.
*    Cheney Hsu (KK)
*    Version 0.10
*    Mobile:	+86 18611846133
*    Mail:  xuchenglin@hrbb.com.cn
#########################################################################################
'
echo '
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	
		请选择以下项（数字）:
'	
echo -e	"\033[;31m	1-> 环境设置 (For WAS DB2.....) \033[0m"
echo ' '
echo -e	"\033[;31m	2-> 系统设置 \033[0m"
echo ' '
echo -e	"\033[;31m	3-> 上线检查 \033[0m"
echo ' '
echo -e	"\033[;31m	4-> 创建swap分区 \033[0m"
echo ' '
echo -e	"\033[;31m	5-> 退出 \033[0m"
echo '
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
'
echo -e	"\033[;31m请输入您的选择： \033[0m"
read choose
case "$choose" in
        1)
        clear
          /sbin/setenvmod.sh;;
        2)
        clear
          /sbin/setupsystem.sh;;
        3)
        clear
           /sbin/checkfix.py;;
        4)
        clear
           /sbin/createswap.sh;;
        5)
           exit;;
        *)
           echo "请选择以上选项!"
esac
