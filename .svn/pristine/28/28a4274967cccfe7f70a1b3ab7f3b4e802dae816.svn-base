#!/bin/bash
DT=`date +%y/%m/%d_%H:%M:%S`
CONF=/home/user/command
HTML=/tmp/1.html

H1() {
cat << EOF > $HTML
<HTML>
<HEAD><TITLE>linux系统巡检: $DT</TITLE></HEAD>
<BODY>
<a name=TOP>
<H1 align=center>linux系统巡检</H1><PRE>
<a name=top></a>
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
<meta name='author' content='NONE'>
<BODY BGCOLOR=#ffffff>
<font size=3><p align=right>linux系统巡检开始时间: $DT&nbsp;&nbsp; </p></font><br>
<hr size=2 width=100% color=#ff0000>
EOF
}
dir() {
cat << EOF >> $HTML 
<table border=0 cellspacing=10 cellpadding=0>
<tr><td width=150 valign=top><p><a href=#XXXXX>XXXXX</a></p>
</td></tr></tr></table>
<hr size=2 width=100% color=#ff0000>
EOF
}
file() {
PARAMETER1=`echo "$line" | grep -v "^##" >> /dev/null && echo "$line" | awk -F'AAAAAAAA' '{print $1}'`
PARAMETER2=`echo "$line" | grep -v "^##" >> /dev/null && echo "$line" | awk -F'AAAAAAAA' '{print $2}'`
PARAMETER3=`echo "$line" | grep -v "^##" >> /dev/null && echo "$line" | awk -F'AAAAAAAA' '{print $3}'`
PARAMETER4=`echo "$line" | grep -v "^##" >> /dev/null && echo "$line" | awk -F'AAAAAAAA' '{print $4}'`
PARAMETER5=`echo "$line" | grep -v "^##" >> /dev/null && echo "$line" | awk -F'AAAAAAAA' '{print $5}'`
PARAMETER6=`echo "$line" | grep -v "^##" >> /dev/null && echo "$line" | awk -F'AAAAAAAA' '{print $6}'`
#echo  $PARAMETER1 $PARAMETER2 $PARAMETER3 $PARAMETER4 $PARAMETER5 $PARAMETER6
if [ ! -s $PARAMETER1 ];then
S=$S+1
if [ `echo $S|grep -o ".$"` -eq 0 ];then
sed -i -e 's/XXXXX/'"$PARAMETER1"'/g' -e '/'"$PARAMETER1"'/a\<tr><td width=150 valign=top><p><a href=#XXXXX>XXXXX</a></p>' $HTML
else 
sed -i -e 's/XXXXX/'"$PARAMETER1"'/g' -e '/'"$PARAMETER1"'/a\<td width=150 valign=top><p><a href=#XXXXX>XXXXX</a></p>' $HTML
fi
PARAMETER2=`eval $PARAMETER2`;PARAMETER3=`eval $PARAMETER3`;PARAMETER4=`eval $PARAMETER4`;PARAMETER5=`eval $PARAMETER5`;PARAMETER6=`eval $PARAMETER6`
#DATA=`echo -e $PARAMETER2"\t"$PARAMETER3"\t"$PARAMETER4"\t"$PARAMETER5"\t"$PARAMETER6"\t"`
cat << EOF >> $HTML
<H2><b>$PARAMETER1<a name=$PARAMETER1></b></H2>
<font size=4><i><p>
$PARAMETER2
$PARAMETER3
$PARAMETER4
$PARAMETER5
$PARAMETER6
</i></font><br></p><a href=#top>home</a>
<hr size=2 width=100% color=#ff0000>
EOF
fi
}
end() {
cat << EOF >> $HTML
<hr size=2 width=100% color=#ff0000>
</BODY>
</HTML>
EOF
DT=`date +%y/%m/%d_%H:%M:%S`
sed -i -e '/linux系统巡检开始时间/a\<font size=3><p align=right>linux系统巡检结束时间: '"$DT"'&nbsp;&nbsp; </p></font><br>' $HTML
}


declare -i S=0
H1
dir
while read line;do
file
done < $CONF
end
#echo $S

