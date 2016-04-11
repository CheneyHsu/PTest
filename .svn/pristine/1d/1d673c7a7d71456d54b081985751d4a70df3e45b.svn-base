#!/bin/sh
#Tuxedo info
cd /smdb/hostinfo/data
for i in `ls *_tuxedoinfo.txt`
do
  PZNAME=`echo $i |awk -F"_" '{print $1"|"$2"|"$3}'` 
  grep "Tuxedo, Version" $i |awk '{print "'${PZNAME}'""|" $(NF-4),$(NF-3),$(NF-2),$NF}' >>/smdb/hostinfo/datatmp/tuxedo.log 
done
