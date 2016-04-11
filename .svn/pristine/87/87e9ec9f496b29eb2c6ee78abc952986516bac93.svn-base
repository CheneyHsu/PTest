#! /usr/bash
ostype=`uname -s`
confile=../conf/wlc.conf

if [ ${ostype} = "AIX" ]
then
    export LC_ALL=zh_CN
    export LANG=zh_CN
fi

if [ ${ostype} = "HP-UX" ]
then
    export LC_ALL=zh_CN.hp15CN
    export LC_ALL=zh_CN.hp15CN
fi

if [ ${ostype} = "Linux" ]
then
    export LC_ALL=zh_CN
    export LANG=zh_CN
fi

AddUSERInfo()
{
while :
do
     echo "------Example:admin"
     echo ""
     if [ $ostype = "HP-UX" -o $ostype = "AIX" ]; then
     	echo "------Enter Console User >\c"
     else
     	echo -n "------Enter Console User >"
     fi
     read user
     case $user in
*)
     if [ -z "$user" ];then
        echo ""
        echo "      @@@ Input invalid !"
        echo ""
        continue
     else
        return user
     fi
     esac
done

}

AddPasswdInfo()
{

while :
do
     echo "------Example:admin"
     echo ""
     if [ $ostype = "HP-UX" -o $ostype = "AIX" ]; then
     	echo "------Enter Console Passwd >\c"
     else
     	echo -n "------Enter Console Passwd >"
     fi
     read passwd
     case $passwd in
*)
     if [ -z "$passwd" ];then
        echo ""
        echo "      @@@ Input invalid !"
        echo ""
        continue
     else 
        return passwd
     fi
     esac

done

}

AddInfo()
{

aa=0

while :

do

if [ $aa -eq 0 ];then

while :
do
     echo "------Example:admin"
     echo ""
     if [ $ostype = "HP-UX" -o $ostype = "AIX" ]; then
     	echo "------Enter Console User >\c"
     else
     	echo -n "------Enter Console User >"
     fi
     read user
     case $user in
*)
     if [ -z "$user" ];then
        echo ""
        echo "      @@@ Input invalid !"
        echo ""
        continue
     else
        break
     fi
     esac
done


while :
do
     echo "------Example:admin"
     echo ""
     if [ $ostype = "HP-UX" -o $ostype = "AIX" ]; then
     	echo "------Enter Console Passwd >\c"
     else
     	echo -n "------Enter Console Passwd >"
     fi
     read passwd
     case $passwd in
*)
     if [ -z "$passwd" ];then
        echo ""
        echo "      @@@ Input invalid !"
        echo ""
        continue
     else
        break
     fi
     esac

done


while :
do
     echo "------Example:10.1.7.28:17102"
     echo ""
     if [ $ostype = "HP-UX" -o $ostype = "AIX" ]; then
     	echo "------Enter IP:Port [XX.XX.XX.XX:XX] >\c"
     else
     	echo -n "------Enter IP:Port [XX.XX.XX.XX:XX] >"
     fi
     read url
     case $url in
*)
     if [ -z "$url" ];then
        echo ""
        echo "      @@@ Input invalid !"
        echo ""
        continue
     fi
     esac

     echo ""
     if [ $ostype = "HP-UX" -o $ostype = "AIX" ]; then
        echo "------Confirm Inform [ $user $passwd $url ] [Y or N] >\c"
     else
        echo -n "------Confirm Inform [ $user $passwd $url ] [Y or N] >"
     fi
     read tag
     case $tag in
Y|y)
     echo "$user $passwd t3://$url" >>$confile 
     echo ""
     echo "      @@@ WebLogic Server Information Write File Successful!"
     echo ""
     aa=1
     break
     ;;
N|n)
     echo ""
     echo "      @@@ You Cancel Information,please retry !"
     echo ""
     break
     ;;
*)
     echo ""
     echo "      @@@ Input invalid !"
     echo ""
     ;;
     esac
done

else
   break
fi

done

}

DelInfo()
{
while :
do
cline=`cat $confile|wc -l |xargs`
echo ""
if [ $ostype = "HP-UX" -o $ostype = "AIX" ]; then
   echo "------Enter Line Number >\c"
else
   echo -n "------Enter Line Number >"
fi
read cnum
case $cnum in
[1-9]*)   
      if [ $cnum -gt $cline ];then
        echo ""
        echo "      @@@ Input invalid !"
        continue
      else
        sed "$cnum"d  ../conf/wlc.conf > ../conf/tmp.conf
        cat ../conf/tmp.conf > ../conf/wlc.conf
        rm -rf ../conf/tmp.conf
        echo ""
        echo "      @@@ The $linu Line Delete Successful !"
        echo ""
        break
      fi
      ;;
*)
      echo ""
      echo "      @@@ Please Input number !"
      continue 
      ;;
esac
done
}

printconfile()
{
echo ""
mm=0
if [ -f $confile ] && [ `cat $confile|wc -l` -gt 0 ];then
   exec 3<&0 0<$confile
   while read i j l
   do
      mm=$(( $mm + 1))
      echo "      <$mm>  $i $j $l"
   done
   exec 0<&3
else
   if [ $ostype = "HP-UX" -o $ostype = "AIX" ]; then
      echo "------Add Configure Enter [A] or [exit]>\c"
   else 
      echo -n "------Add Configure Enter [A] or [exit]>"
   fi
read option
case $option in
A|a)
    echo ""
    AddInfo
    return 99
    ;;
*)
    exit
    ;;
esac
fi
}

clear

while :
do
echo ""
echo ""
echo "=|===========================================================|="
echo "=|               Weblogic Console信息配置                    |="
echo "=|    配置weblogic 的user passwd                             |="
echo "=|    配置weblogic 的console地址和端口                       |="
echo "=|    如无weblogic请直接输入exit退出                         |="
echo "=|===========================================================|="
echo ""

echo "       ------------Current Config following------------"    
printconfile
if [ $? -eq 99  ];then
     continue
fi
echo ""
if [ $ostype = "HP-UX" -o $ostype = "AIX" ]; then
     echo "------Reconf Enter [R],Delete Enter [D],Add Enter [A] or [exit] >\c"
else
     echo -n "------Reconf Enter [R],Delete Enter [D],Add Enter [A] or [exit] >"

fi
read option
case $option in
R|r)
     echo ""
     >../conf/wlc.conf
     AddInfo
     ;;
D|d)
     echo ""
     printconfile 
     DelInfo
     ;; 
A|a)
     echo ""
     AddInfo
     ;;
*)
     exit
     ;;

esac
done
exit
