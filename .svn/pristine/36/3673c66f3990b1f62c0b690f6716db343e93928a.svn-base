#!/bin/bash


diff /root/list/listdiff/listdiff /root/list/listdiff/listdiff2  | grep '<' | awk '{print $2}' > /root/list/listdiff/listdiff3

cp /root/list/listdiff/listdiff /root/list/listdiff/listdiff2

for i in `cat /root/list/listdiff/listdiff3` ;do

cd /PAEAIMAGE/FTPROOT/$i
pwd 
echo "$i is dir"


find ./ -type f -print | xargs md5sum > /root/md5shhc/$i.md5
scp -r /root/md5shhc/$i.md5 192.168.0.1:/root/md5shhc/

done

