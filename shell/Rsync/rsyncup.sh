#!/bin/bash 
function PD (){
if [ $? = 0 ];
then
        :
else
        exit
fi
}
a=`date +%Y%m%d`
cp /root/list/list2 /root/list/list2.$a
ls /PAEAIMAGE/FTPROOT/201312?? | grep 'PAEA'|awk -F '/' '{print $4}' | cut -c1-8  > /root/list1
diff /root/list1 /root/list/list2 | grep  '<' | awk '{print $2}' > /root/list3
line1=`head -n 1 /root/list3`
line2=`head -n 2 /root/list3| tail -n 1`
line3=`head -n 3 /root/list3| tail -n 1`
line4=`head -n 4 /root/list3| tail -n 1`
line5=`head -n 5 /root/list3| tail -n 1`
a=`du -m /PAEAIMAGE/FTPROOT/$line1 | tail -n 1 | awk  '{print $1}'`
b=`du -m /PAEAIMAGE/FTPROOT/$line2 | tail -n 1 | awk  '{print $1}'`
c=`du -m /PAEAIMAGE/FTPROOT/$line3 | tail -n 1 | awk  '{print $1}'`
d=`du -m /PAEAIMAGE/FTPROOT/$line4 | tail -n 1 | awk  '{print $1}'`
e=`du -m /PAEAIMAGE/FTPROOT/$line5 | tail -n 1 | awk  '{print $1}'`
z=`echo $(expr $a + $b)`
y=`echo $(expr $z + $c)`
x=`echo $(expr $y + $d)`
w=`echo $(expr $x + $e)`
if [ "$a" -gt '65000' ];then 
	echo $line1 >> /root/list/list2
	echo $line1 >> /root/list/listdiff/listdiff
	rsync -vrtopgP --progress  --checksum --log-file=/root/rsync.log --timeout=600 /PAEAIMAGE/FTPROOT/$line1  root@GFS1.HRB::gfs/
elif [ "$z" -gt '65000' ];then
	echo $line1 >> /root/list/list2
	echo $line1 >> /root/list/listdiff/listdiff
        rsync -vrtopgP --progress  --checksum --log-file=/root/rsync.log --timeout=600 /PAEAIMAGE/FTPROOT/$line1  root@GFS1.HRB::gfs/
elif [ "$y" -gt '65000' ];then
	echo $line1 >> /root/list/list2
	echo $line2 >> /root/list/list2
	echo $line1 >> /root/list/listdiff/listdiff
	echo $line2 >> /root/list/listdiff/listdiff
        rsync -vrtopgP --progress --checksum --log-file=/root/rsync.log --timeout=600  /PAEAIMAGE/FTPROOT/$line1  root@GFS1.HRB::gfs/
        PD
	sleep 60
	rsync -vrtopgP --progress --checksum --log-file=/root/rsync.log --timeout=600 /PAEAIMAGE/FTPROOT/$line2  root@GFS1.HRB::gfs/
elif [ "$x" -gt '65000' ];then
	echo $line1 >> /root/list/list2
	echo $line1 >> /root/list/listdiff/listdiff
	echo $line2 >> /root/list/listdiff/listdiff
	echo $line3 >> /root/list/listdiff/listdiff
	echo $line2 >> /root/list/list2
	echo $line3 >> /root/list/list2
	rsync -vrtopgP --progress --checksum --log-file=/root/rsync.log --timeout=600 /PAEAIMAGE/FTPROOT/$line1  root@GFS1.HRB::gfs/
        PD
	sleep 60
	rsync -vrtopgP --progress --checksum --log-file=/root/rsync.log --timeout=600 /PAEAIMAGE/FTPROOT/$line2  root@GFS1.HRB::gfs/
        PD
	sleep 60
	rsync -vrtopgP --progress --checksum /PAEAIMAGE/FTPROOT/$line3  root@GFS1.HRB::gfs/
elif [ "$w" -gt '65000' ];then
	echo $line1 >> /root/list/list2
	echo $line2 >> /root/list/list2
	echo $line3 >> /root/list/list2
	echo $line4 >> /root/list/list2
	echo $line1 >> /root/list/listdiff/listdiff
	echo $line2 >> /root/list/listdiff/listdiff
	echo $line3 >> /root/list/listdiff/listdiff
	echo $line4 >> /root/list/listdiff/listdiff
    rsync -vrtopgP --progress --checksum --log-file=/root/rsync.log --timeout=600 /PAEAIMAGE/FTPROOT/$line1  root@GFS1.HRB::gfs/
        PD
	sleep 60
	rsync -vrtopgP --progress --checksum --log-file=/root/rsync.log --timeout=600 /PAEAIMAGE/FTPROOT/$line2  root@GFS1.HRB::gfs/
        PD
	sleep 60
	rsync -vrtopgP --progress --checksum --log-file=/root/rsync.log --timeout=600 /PAEAIMAGE/FTPROOT/$line3  root@GFS1.HRB::gfs/
        PD
	sleep 60
	rsync -vrtopgP --progress --checksum --log-file=/root/rsync.log --timeout=600 /PAEAIMAGE/FTPROOT/$line4  root@GFS1.HRB::gfs/
else 		
	echo $line1 >> /root/list/list2
	echo $line2 >> /root/list/list2
	echo $line3 >> /root/list/list2
	echo $line4 >> /root/list/list2
	echo $line5 >> /root/list/list2
	echo $line1 >> /root/list/listdiff/listdiff
	echo $line2 >> /root/list/listdiff/listdiff
	echo $line3 >> /root/list/listdiff/listdiff
	echo $line4 >> /root/list/listdiff/listdiff
	echo $line5 >> /root/list/listdiff/listdiff
	rsync -vrtopgP --progress --checksum --log-file=/root/rsync.log --timeout=600 /PAEAIMAGE/FTPROOT/$line1  root@GFS1.HRB::gfs/
        PD
	sleep 60
	rsync -vrtopgP --progress --checksum --log-file=/root/rsync.log --timeout=600 /PAEAIMAGE/FTPROOT/$line2  root@GFS1.HRB::gfs/
        PD
	sleep 60
	rsync -vrtopgP --progress --checksum --log-file=/root/rsync.log --timeout=600 /PAEAIMAGE/FTPROOT/$line3  root@GFS1.HRB::gfs/
        PD
	sleep 60
	rsync -vrtopgP --progress --checksum --log-file=/root/rsync.log --timeout=600 /PAEAIMAGE/FTPROOT/$line4  root@GFS1.HRB::gfs/
        PD
	sleep 60
	rsync -vrtopgP --progress --checksum --log-file=/root/rsync.log --timeout=600 /PAEAIMAGE/FTPROOT/$line5  root@GFS1.HRB::gfs/
fi

bash /root/md5.sh
