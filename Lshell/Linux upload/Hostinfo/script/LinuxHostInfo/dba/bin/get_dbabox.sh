#!/usr/bin/ksh
# set -x
####### Defined variable ###############
FTPSRV="10.1.7.28"
USER="dbatool"
PASS="dbatoolceb"
HDIR="/home/sysadmin"

####### Function get_dbabox ############
get_dbabox()
{
case `uname` in
AIX|HP-UX|Linux)
    if [ -d $HDIR ]
      then
        echo "$HDIR is OK"
      else
        mkdir -p $HDIR
    fi

    cd $HDIR

    ftp  -v -n $FTPSRV <<EOF
    user $USER $PASS
    lcd /home/sysadmin
    cd  /smdb/dbatools
    get dba.tar
    bye
EOF
    tar -xvf $HDIR/dba.tar
    chmod -R 777 $HDIR/dba
;;
*)  echo
        echo "Uneupported Operation System for this Script... EXITING"
        echo
        exit
esac
}

function ping_host
{
IP=$1
case `uname` in
Linux)
        /bin/ping -c 1 -W 1 $IP
;;
HP-UX)
        /usr/sbin/ping $IP -n 1 
;;
AIX)
        /usr/sbin/ping -c 1 -w 1 $IP
;;
*)      echo
        echo "Uneupported Operation System for this Script... EXITING"
        exit
esac
}

######## Main() ####################
ping_host ${FTPSRV}
ST=$?
if [ $ST = "0" ];then
    if [ -f $HDIR/dba.tar ];then
        rm $HDIR/dba.tar
    fi
    get_dbabox
else
        exit
fi