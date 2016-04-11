#!/bin/sh

##########################
#   SRDF CONFT SETTING
##########################
BIN_PATH=../bin
SAMPLE_PATH=../sample
TMP_PATH=../tmp
CONF_PATH=../conf

SRDF_CONF=${CONF_PATH}/srdf_check.conf
/usr/symcli/bin/symdg list|awk '/RDF/ {print $1}'>${SRDF_CONF}
if [ -n ${SRDF_CONF} ]
  then
    echo "221 srdf_check.conf :"
    echo "...................................OK" | awk '{printf "%60s\n",$1}'
    echo
cat ${SRDF_CONF} | while read i;
  do
    if [ -f ${CONF_PATH}/${i}_group.conf ]
      then
        echo "221 ${i}_group.conf : already exists"
      else
        cat /dev/null >${CONF_PATH}/${i}_group.conf
        echo "221 ${i}_group.conf :"
        echo "...................................OK" | awk '{printf "%60s\n",$1}'
     fi
  done

else
    echo "221 srdf_check.conf :"
    echo "....................................False" | awk '{printf "%60s\n",$1}'
fi
echo "----------------------------------------------------------"
echo

