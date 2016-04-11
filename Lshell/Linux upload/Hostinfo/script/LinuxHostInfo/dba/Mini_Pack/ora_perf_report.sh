export ORACLE_SID=$ORACLE_SID
while [ -f monit ]
do
sqlplus -S dbsnmp/dbsnmp @ora_perf_report.sql
done


