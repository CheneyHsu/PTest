rm -rf /usr/report/oraclecomment
for i in `ps -ef|grep -v grep|grep ora_ckpt|awk -F '_' '{print $3}'`
do
        export ORACLE_SID=$i
        while read line;do
         echo "$ORACLE_SID$line" >> /usr/report/oraclecomment
        done < /usr/report/oraclecomment2
done
