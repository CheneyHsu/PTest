#!/bin/sh
#Suse Linux  lvm信息收集工具
#20120929
# 
CHECKDATE=`date "+%Y-%m-%d"`
if [ $HHNAME ]
then
    echo >/dev/null
else
    HHNAME=`hostname`
fi

BIN_PATH=../bin
TMP_PATH=../tmp
FILE_PATH=../file
LVMVG=${FILE_PATH}/${HHNAME}_${CHECKDATE}_lvm_vg.txt
LVMLV=${FILE_PATH}/${HHNAME}_${CHECKDATE}_lvm_lv.txt
LVMPV=${FILE_PATH}/${HHNAME}_${CHECKDATE}_lvm_pv.txt


cat /dev/null >../tmp/lvname.txt
cat /dev/null >../tmp/pvname.txt
vgdisplay 2>&1 |awk '/VG Name/  {print $NF}'| while read i;
do
  vgdisplay -v ${i} 2>&1 |awk ' /LV Name/ {print $NF}'  >>../tmp/lvname.txt
  vgdisplay -v ${i} 2>&1 |awk ' /PV Name/ {print $NF}' >>../tmp/pvname.txt
vgdisplay ${i} >../tmp/vgdisplay.txt 
vgdisplay=../tmp/vgdisplay.txt
VGName=`cat ${vgdisplay} |awk '/VG Name/ {print $NF}'`
MaxLV=`cat ${vgdisplay} |awk '/MAX LV/ {print $NF}'`
CurLV=`cat ${vgdisplay} |awk '/Cur LV/ {print $NF}'`
MaxPV=`cat ${vgdisplay} |awk '/Max PV/ {print $NF}'`
CurPV=`cat ${vgdisplay} |awk '/Cur PV/ {print $NF}'`
PESize=`cat ${vgdisplay} |awk '/PE Size/ {print $(NF-1)}'`
TotalPE=`cat ${vgdisplay} |awk '/Total PE/ {print $NF}'`
AllocPE=`cat ${vgdisplay} |awk '/Alloc PE/ {print $(NF-3)}'`
FreePE=`cat ${vgdisplay} |awk '/Free PE/ {print $(NF-3)}'`
VGVersion=`cat ${vgdisplay} |awk '/Format/ {print $NF}'`
MAxSize=`cat ${vgdisplay} |awk '/VG Max Size/ {print $NF}'`
VGSize=`cat ${vgdisplay} |awk '/VG Size/ {print $(NF-1)}'`
VGID=`cat ${vgdisplay} |awk '/VG UUID/ {print $NF}'`

#echo "27 VG;$VGName|$VGSize|$VGVersion|$PESize|$MaxLV|$CurLV|$MaxPV|$CurPV|$MAxSize|$TotalPE|$AllocPE|$FreePE"

echo "${HHNAME}|${CHECKDATE}|$VGName|$VGSize|$VGVersion|$PESize|$MaxLV|$CurLV|$MaxPV|$CurPV|$MAxSize|$TotalPE|$AllocPE|$FreePE|$VGID" >>${LVMVG}

done
cat ../tmp/lvname.txt |while read i
do
   lvdisplay ${i} >../tmp/lvinfo.txt
   vgdisplay=../tmp/lvinfo.txt
LVName=`cat ${vgdisplay} |awk '/LV Name/ {print $NF}'`
VGName=`cat ${vgdisplay} |awk '/VG Name/ {print $NF}'`
Status=`cat ${vgdisplay} |awk '/LV Status/ {print $NF}'`
LVSize=`cat ${vgdisplay} |awk '/LV Size/ {print $(NF-1)}'`
CurLE=`cat ${vgdisplay} |awk '/Current LE/ {print $NF}'`
AllPE=""
Stripes=""
StrSize=""
Badblock=`cat ${vgdisplay} |awk '/Block device/ {print $NF}'`
Allocation=`cat ${vgdisplay} |awk '/Allocation/ {print $NF}'`
IOTim=""

#echo "27 LV;$VGName|$LVName|$Status|$LVSize|$CurLE|$AllPE|$Stripes|$StrSize|$Badblock|$Allocation|$IOTim"    
echo "${HHNAME}|${CHECKDATE}|$VGName|$LVName|$Status|$LVSize|$CurLE|$AllPE|$Stripes|$StrSize|$Badblock|$Allocation|$IOTim"    >>${LVMLV}

done

cat ../tmp/pvname.txt |while read i
do
  pvdisplay ${i} >../tmp/pvinfo.txt
vgdisplay=../tmp/pvinfo.txt
PVName=`cat ${vgdisplay} |awk '/PV Name/ {print $NF}'`
VGName=`cat ${vgdisplay} |awk '/VG Name/ {print $NF}'`
CurLV=""
PESize=`cat ${vgdisplay} |awk '/PE Size/ {print $NF / 1024 }'`
TotalPE=`cat ${vgdisplay} |awk '/Total PE/ {print $NF}'`
FreePE=`cat ${vgdisplay} |awk '/Free PE/ {print $NF}'`
PVID=`cat ${vgdisplay} |awk '/PV UUID/ {print $NF}'`
IOTim=""
Autoswitch=""
ProPol=""
#echo "27 PV;$VGName|$PVName|$CurLV|$PESize|$TotalPE|$FreePE|$IOTim|$Autoswitch|$ProPol"
echo "${HHNAME}|${CHECKDATE}|VGName|$PVName|$CurLV|$PESize|$TotalPE|$FreePE|$IOTim|$Autoswitch|$ProPol|$PVID" >>${LVMPV}

done

