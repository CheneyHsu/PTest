#!/bin/sh

##########################
#  Check Oracle Listener
##########################
BIN_PATH=../bin
SAMPLE_PATH=/home/sysadmin/check/sample
TMP_PATH=../tmp
CONF_PATH=../conf

ORACLE_LSNRCTL_CONF=${CONF_PATH}/oracle_lsnrctl_check.conf
ORACLE_LSNRCTL_SAMPLE=${SAMPLE_PATH}/oracle_lsnrctl_status.sample

cat ${ORACLE_LSNRCTL_CONF} | while read i;
do
  parameter_name=`echo ${i} | awk -F"=" '{print $1}'`
  parameter_value=`echo ${i} | awk '{print substr($0, index($0, "=")+1)}'`
  if [ ${parameter_name} = "USER" ]
    then
      LSNRCTL_USER=${parameter_value}
    else
      if [ ${parameter_name} = "LISTENER" ]
        then
          su - ${LSNRCTL_USER} <<! >/dev/null 2>&1
           lsnrctl status ${parameter_value} | grep -v "^LSNRCTL" | grep -v "^Start Date" | grep -v "^Uptime" >/tmp/${LSNRCTL_USER}.${parameter_value}.sample
!

#          su - $LSNRCTL_USER -c "lsnrctl status ${parameter_value} | grep -v \"^LSNRCTL\" | grep -v \"^Start Date\" | grep -v \"^Uptime\"" > ${ORACLE_LSNRCTL_SAMPLE}.${LSNRCTL_USER}.${parameter_value}
          if [ $? -ne 0 ]
            then
              echo "182 Oracle lsnrctl "$LSNRCTL_USER ${parameter_value}" Initialization :"
              echo "...................................False" | awk '{printf "%60s\n",$1}'
              echo
            else
              echo "182 Oracle lsnrctl "$LSNRCTL_USER ${parameter_value}" Initialization :"
              echo "......................................OK" | awk '{printf "%60s\n",$1}'
          fi
      fi
  fi
done

echo "----------------------------------------------------------"
echo

exit 
