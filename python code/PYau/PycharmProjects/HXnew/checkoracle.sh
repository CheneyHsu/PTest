# Update @ 20100403 Adding Detailed Output
# V1.7 20120209
#
ORA_INSTANCE_NUM=`ps -ef|grep -v grep|grep ora_ckpt|cut -c10-28|wc -l`
export LANG=c
if [ $ORA_INSTANCE_NUM -gt 0 ]
then
for i in `ps -ef|grep -v grep|grep ora_ckpt|awk -F '_' '{print $3}'`
do
	export ORACLE_SID=$i
	sqlplus -s "/as sysdba" <<EOF
	spool /tmp/cluster.lst;
        set feedback off;
        set head off;
        select value from v\$parameter where name='background_dump_dest';
        spool off;
	exit;
EOF

	BDUMP=`cat /tmp/cluster.lst | sed -n '$p' | sed 's/ *$//'`
	echo "<H2><b>${ORACLE_SID}&nbsp;OS数据库用户线程<a name=\"${ORACLE_SID}OS数据库用户线程\"></b></H2>"
	echo "<p><font size=4><i>"
	ps -ef | grep 'ora' | grep -v grep | grep -v checkoracle
	echo "</i></font></p><br><a href=\"#top\">返回页首</a>"
	echo "<hr size=2 width=100% color=\"#ff0000\">"

	echo "<H2><b>${ORACLE_SID}&nbsp;数据库alert日志<a name=\"${ORACLE_SID}数据库alert日志\"></b></H2>"
	echo "<p><font size=4><i>"
	tail -n 500 ${BDUMP}/alert_${ORACLE_SID}.log
	echo "</i></font></p><br><a href=\"#top\">返回页首</a>"
	echo "<hr size=2 width=100% color=\"#ff0000\">"  

	echo "<H2><b>${ORACLE_SID}&nbsp;alert日志错误输出<a name=\"${ORACLE_SID}alert日志错误输出\"></b></H2>"
	echo "<p><font size=4><i>"
	tail -n 500 ${BDUMP}/alert_${ORACLE_SID}.log | grep -i ORA-
	tail -n 500 ${BDUMP}/alert_${ORACLE_SID}.log | grep -i err
        tail -n 500 ${BDUMP}/alert_${ORACLE_SID}.log | grep -i fail
	echo "</i></font></p><br><a href=\"#top\">返回页首</a>"
	echo "<hr size=2 width=100% color=\"#ff0000\">"  

	echo "<H2><b>${ORACLE_SID}&nbsp;数据库监听状态<a name=\"${ORACLE_SID}数据库监听状态\"></a></b></H2>"
	echo "<font size=4><xmp>";
	for i in `ps -ef | grep tnslsnr | grep -v grep | awk -F' ' '{print $10}'`
	do
		lsnrctl status $i;
	done
	echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	echo "<hr size=2 width=100% color=\"#ff0000\">";

	sqlplus -s "/as sysdba" <<EOF
	set linesize 200;
	set pagesize 60;
	set feedback off;
	set escape \;

	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库状态<a name=\"\${ORACLE_SID}数据库状态\"></b></H2>";
	host echo "<font size=4><xmp>";
	column status format a10;
       column database_status format a15;
	column version format a10;
       column log_mode  format a15;
       column open_mode format a15;
	column name format a15
	column instance_name format a15;
	column startup_time for a20;
	select a.instance_name, a.status,b.name , a.database_status ,a.version ,b.created ,b.log_mode ,b.open_mode ,a.startup_time  from gv\$instance a,
        (select inst_id, name, created, log_mode,open_mode from gv\$database) b 
        where a.inst_id=b.inst_id;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";
	
	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库是否RAC<a name=\"\${ORACLE_SID}数据库是否RAC\"></b></H2>";
	host echo "<font size=4><xmp>";
       col  name for a30
       col  value for a30
	select name ,value  from v\$parameter where name in ('cluster_database_instances','cluster_database');
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";

	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库归档模式<a name=\"\${ORACLE_SID}数据库归档模式\"></b></H2>";
	host echo "<font size=4><xmp>";
	archive log list;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";



	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库字符集<a name=\"\${ORACLE_SID}数据库字符集\"></b></H2>";
	host echo "<font size=4><xmp>";
column value$   format a40
select name ,value$  from props$ where name in('NLS_CHARACTERSET','NLS_NCHAR_CHARACTERSET');
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";


	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库参数<a name=\"\${ORACLE_SID}数据库参数\"></b></H2>";
	host echo "<font size=4>";
	set head off;
	select 'db_block_size = ' || value from v\$parameter where name = 'db_block_size';
	select 'db_file_multiblock_read_count = ' || value from v\$parameter where name = 'db_file_multiblock_read_count';
	select 'open_cursors = ' || value from v\$parameter where name = 'open_cursors';
	select 'processes = ' || value from v\$parameter where name = 'processes';
	select 'timed_statistics = ' || value from v\$parameter where name = 'timed_statistics';
	select 'optimizer_mode = ' || value from v\$parameter where name = 'optimizer_mode';
	select 'remote_login_passwordfile = ' || value  from v\$parameter where name = 'remote_login_passwordfile';
	select 'undo_management = ' || value  from v\$parameter where name = 'undo_management';
	select 'undo_retention = ' || value from v\$parameter where name = 'undo_retention';
	select 'undo_tablespace = ' || value  from v\$parameter where name = 'undo_tablespace';
	select 'user_dump_dest = ' || value  from v\$parameter where name = 'user_dump_dest';
	select 'core_dump_dest = ' || value  from v\$parameter where name = 'core_dump_dest';
	select 'background_dump_dest = ' || value from v\$parameter where name = 'background_dump_dest';
	set head on;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";


	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库用户信息<a name=\"\${ORACLE_SID}数据库用户信息\"></b></H2>";
	host echo "<font size=4><xmp>";
	column username format a15
       column account_st format a15
       column defalut_tbs format a20
       column temporary_tbs format a15
select username,account_status account_st,default_tablespace defalut_tbs,temporary_tablespace temporary_tbs,created from dba_users 
where account_status='OPEN' order by created;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";


	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库用户权限信息<a name=\"\${ORACLE_SID}数据库用户权限信息\"></b></H2>";
	host echo "<font size=4><xmp>";
column granted_role for a40
column privilege for a40
select distinct b.username,c.granted_role,a.privilege  from 
dba_sys_privs a,dba_users b,dba_role_privs c,role_sys_privs d
where a.grantee(+)=b.username
and b.username=c.grantee(+)
and b.account_status = 'OPEN' and b.username not in 
('SYS','SYSTEM','ODM','OE','ODM_MTR','SCOTT','MDSYS','ORDSYS','CTXSYS','RMAN','WKSYS','WMS YS',
'QS','QS_CBADM','QS_CS','QS_ES','QS_OS','QS_WS','XDB','PM','PERFSTAT','OUTLN','OLAPSYS','SYSMAN','DBSNMP','MGMT_VIEW');
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";


	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库SGA信息<a name=\"\${ORACLE_SID}数据库SGA信息\"></b></H2>";
	host echo "<font size=4><xmp>";	
col sga for 999999 heading 'SGA(MB)'
col share_size for 999999 heading 'SHARDE_SIZE(MB)'
col cache_size for 999999 heading 'CACHE_SIZE(MB)'
col cache_use for a10
col java for 999999 heading 'JAVA(MB)'
col large for 999999 heading 'LARGE(MB)'
col log for 999999 heading 'LOG(KB)'
col free_cache for a10
col free_share for a10

select round(sga,0) sga,
round(cache_size,0) cache_size,
round(coun/cache_size*100,0)||'%' cache_use,
round(shared_size,0) share_size,
round(freemb/shared_size*100,0)||'%' free_share,
round(java_size,0) java,round(large_pool_size,0) large,round(log,0) log
from 
(select value/1024/1024 sga from v\$parameter where name='sga_max_size'),
(select s.CURRENT_SIZE/1024/1024 shared_size from v\$sga_dynamic_components s where s.COMPONENT='shared pool'),
(select s.CURRENT_SIZE/1024/1024 cache_size from v\$sga_dynamic_components s where s.COMPONENT like '%DEFAULT buffer cache%' or s.COMPONENT='buffer cache'),
(select value/1024/1024 java_size from v\$parameter where name='java_pool_size'),
(select value/1024/1024 large_pool_size from v\$parameter where name='large_pool_size'),
(select value/1024 log from v\$parameter where name='log_buffer'),
(select bytes/1024/1024 freemb from v\$sgastat s where s.pool='shared pool' and s.name='free memory'),
(select sum(count(*))*8/1024 coun from v\$bh where status<>'free' group by status );

	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";


	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库PGA信息<a name=\"\${ORACLE_SID}数据库PGA信息\"></b></H2>";
	host echo "<font size=4><xmp>";	

col total for 999999 heading 'TOTAL(MB)'
col inusetotal for 999999 heading 'INUSETOTAL(MB)'
col allocated for 9999999 heading 'ALLCATEDTOTAL(MB)'
col mem for 9999999999999
col disk for 999999999999
col ratio for a10
select round(total,0) total,round(inuse,0) inusetotal,round(allocated,0) allocatedtotal,
mem,disk
from
(select value/1024/1024 total from v\$pgastat where name like 'aggregate PGA t%'),
(select value/1024/1024 inuse from v\$pgastat where name like 'total PGA i%'),
(select value/1024/1024 allocated from v\$pgastat where name like 'total PGA a%'),
(
select mem.value mem,disk.value disk
from v\$sysstat mem,v\$sysstat disk
where mem.name='sorts (memory)'
and disk.name='sorts (disk)');
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";


	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库使用情况<a name=\"\${ORACLE_SID}数据库使用情况\"></b></H2>";
	host echo "<font size=4><xmp>";

col total for 999999 heading 'TOTAL(GB)'
col used  for 999999 heading 'USED(GB)'
col free  for 999999 heading 'FREE(GB)'

select 
round(sum(totalmb/1024),1) total,
round(sum(totalmb/1024-nvl(freemb/1024,0)),1) used,
round(sum(freemb/1024),1) free
from 
(select sum(bytes)/1024/1024   freemb,  tablespace_name from dba_free_space group by tablespace_name)  a,
(select  sum(bytes)/1024/1024  totalmb,  tablespace_name from  dba_data_files group by tablespace_name)   b
where a.tablespace_name (+) = b.tablespace_name;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";



host echo "<H2><b>\${ORACLE_SID}\&nbsp;ASM磁盘使用情况<a name=\"\${ORACLE_SID}ASM磁盘使用情况\"></b></H2>";
	host echo "<font size=4><xmp>";

col path for a40

select name,path,os_mb,total_mb,free_mb,mode_status from v\$asm_disk order by name;

	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";

host echo "<H2><b>\${ORACLE_SID}\&nbsp;哪些用户在系统表空间存放数据[应为空]<a name=\"\${ORACLE_SID}哪些用户在系统表空间存放数据\"></b></H2>";
	host echo "<font size=4><xmp>";

select distinct(owner) from dba_tables
where tablespace_name='SYSTEM' and
owner!='SYS' and owner!='SYSTEM'
and owner!='ORDDATA'
and owner!='OUTLN'
and owner!='XDB'
union
select distinct(owner) from dba_indexes
where tablespace_name='SYSTEM' and owner!='SYS' and owner!='SYSTEM' 
and owner!='ORDDATA'
and owner!='OUTLN'
and owner!='XDB';

	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";

	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库表空间<a name=\"\${ORACLE_SID}数据库表空间\"></b></H2>";
	host echo "<font size=4><xmp>";
col totalmb for 999999999 heading 'TOTAL(MB)'
col freemb for 9999999999 heading 'FREE(MB)'
col usedl for 99999 heading 'USE(%)'
col tsname for a40
col segment_space_management for a10
col block_size for 99999
col status for a10

select nvl(b.tablespace_name,nvl(a.tablespace_name,'UNKNOWN')) tsname,c.segment_space_management,c.block_size,c.status,
round(totalmb,0) totalmb ,
round(totalmb-nvl(freemb,0)) usedmb, 
round(nvl(freemb,0),0)   freemb, 
round(((totalmb-nvl(freemb,0))/totalmb)*100,0) usedl
from
(select sum(bytes)/1024/1024   freemb,  tablespace_name from dba_free_space group by tablespace_name)  a,
(select  sum(bytes)/1024/1024  totalmb,  tablespace_name from  dba_data_files group by tablespace_name)   b,
(select segment_space_management,block_size,status,tablespace_name,CONTENTS from dba_tablespaces) c
where a.tablespace_name (+) = b.tablespace_name and c.tablespace_name=b.tablespace_name
order by usedl desc;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";
	

	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据文件信息<a name=\"\${ORACLE_SID}数据文件信息\"></a></b></H2>";
	host echo "<font size=4><xmp>";

col totalmb for 99999999 heading 'TOTAL(MB)'
col freemb for 999999999 heading 'FREE(MB)'
col usedl for 99999 heading 'USE(%)'
col tname for a40
col fname for a60
col auto for a3
col fid for 999
select tname, file_name fname,totalmb,nvl(freemb,0) freemb,
round((1-nvl(freemb,0)/totalmb)*100,0) usedl,
autoextensible auto,status
from 
(select round((bytes/1024/1024),0) totalmb,file_id,tablespace_name tname,file_id fid,file_name,autoextensible,status from dba_data_files) a,
(select round(sum(bytes/1024/1024),0) freemb,file_id from dba_free_space group by file_id) b
where a.file_id=b.file_id(+) order by tname desc;
        host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	 host echo "<hr size=2 width=100% color=\"#ff0000\">";
	
	
	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据文件异常状态<a name=\"\${ORACLE_SID}数据文件异常状态\"></a></b></H2>";
	host echo "<font size=4><xmp>";
	column name for a60
	select name,status from v\$datafile where status not in('SYSTEM','ONLINE','AVAILABLE')
	union all
	select file_name,status from dba_data_files where status not in('AVAILABLE');	
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";
       

	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库临时文件信息<a name=\"\${ORACLE_SID}数据库临时文件信息\"></b></H2>";
	host echo "<font size=4><xmp>"
col name for a50
col tablespace_name for a40	
select te.file#,te.BYTES/1024/1024 sizemb,te.status,tablespace_name,name,dtf.autoextensible 
from v\$tempfile te
join dba_temp_files dtf on dtf.file_id=te.FILE# 
order by file#;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";



	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库临时文件信息使用情况<a name=\"\${ORACLE_SID}数据库临时文件信息使用情况\"></b></H2>";
	host echo "<font size=4><xmp>"
select a.tablespace_name,b.totalMB,round(a.usedmb/b.totalmb,2)*100||'%' temp_use from 
(select tablespace_name,sum(bytes_used)/1024/1024 usedMB from v\$temp_space_header group by tablespace_name ) a,
(select  tablespace_name,sum(bytes)/1024/1024 totalMB from dba_temp_files group by tablespace_name ) b
where a.tablespace_name=b.tablespace_name;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";
	

	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库日志信息<a name=\"\${ORACLE_SID}数据库日志信息\"></b></H2>";
	host echo "<font size=4><xmp>";
col member for a50
select distinct l.THREAD#,l.GROUP#,bytes/1024/1024 log_size,l.STATUS,lf.TYPE,lf.MEMBER 
from gv\$log l,gv\$logfile lf
where l.GROUP#=lf.GROUP#
order by 1,2 ;
        host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";



	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库日志切换频率<a name=\"\${ORACLE_SID}数据库日志切换频率\"></b></H2>";
	host echo "<font size=4><xmp>";
	select to_char(first_time,'yyyy-mm-dd hh24') time ,count(*) 
	from v\$log_history 
	where trunc(first_time) = trunc(sysdate-1)
	group by to_char(first_time,'yyyy-mm-dd hh24')
	order by 1;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";
	



	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库UNDO生成信息<a name=\"\${ORACLE_SID}数据库UNDO生成信息\"></b></H2>";
	host echo "<font size=4><xmp>";

select to_char(begin_time,'yyyy-mm-dd hh24') btime,
sum(undoblks) uns from v\$undostat
where trunc(begin_time)=trunc(sysdate-1)
group by 
to_char(begin_time,'yyyy-mm-dd hh24')
order by to_char(begin_time,'yyyy-mm-dd hh24');

	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";



	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库控制文件<a name=\"\${ORACLE_SID}数据库控制文件\"></b></H2>";
	host echo "<font size=4><xmp>"
	column name format a70 heading 'Control File';
	select name from v\$controlfile;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";
	column name clear;



	host echo "<H2><b>\${ORACLE_SID}\&nbsp;数据库各缓冲区命中率<a name=\"\${ORACLE_SID}数据库各缓冲区命中率\"></a></b></H2>";
	host echo "<font size=4><xmp>";
col chitrati for a20
col rhitrate for a20
col lhitratio for a20
select a.chitrati ,b.rhitrate ,c.lhitratio  from 
(
  select round((1 - sum(decode(name,'physical reads',value,0)) / 
	(sum(decode(name,'db block gets',value,0)) + sum(decode(name,'consistent gets',value,0))) ),4) *100 || '%' chitrati from v\$sysstat
) a,
(
  select round((1 - (sum(GetMisses) / (sum(Gets) + sum(GetMisses))))*100 ,2) || '%' rhitrate
	from v\$RowCache where Gets+GetMisses<>0    
) b,
(
  	select round((sum(pinhits) / sum(pins)) * 100 ,2) || '%' lhitratio 
	from v\$librarycache where (pinhits>0 and pins>0)
  )c;
       
       host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";
	

	host echo "<H2><b>\${ORACLE_SID}\&nbsp;缓冲区建议<a name=\"\${ORACLE_SID}缓冲区建议\"></a></b></H2>"
	host echo "<font size=4><xmp>";
	select block_size,size_for_estimate,size_factor,estd_physical_reads from v\$db_cache_advice;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";
	
	host echo "<H2><b>\${ORACLE_SID}\&nbsp;共享池建议<a name=\"\${ORACLE_SID}共享池建议\"></a></b></H2>";
	host echo "<font size=4><xmp>";
	select s.SHARED_POOL_SIZE_FOR_ESTIMATE share_size,s.SHARED_POOL_SIZE_FACTOR size_factor,s.ESTD_LC_TIME_SAVED save_time,
	       s.ESTD_LC_MEMORY_OBJECT_HITS find_hits from v\$shared_pool_advice s;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";
	
	host echo "<H2><b>\${ORACLE_SID}\&nbsp;PGA建议<a name=\"\${ORACLE_SID}PGA建议\"></a></b></H2>";
	host echo "<font size=4><xmp>";
	select round(p.pga_target_for_estimate/1024/1024,0) pga_size,p.PGA_TARGET_FACTOR,p.ESTD_OVERALLOC_COUNT from v\$pga_target_advice p;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";



	host echo "<H2><b>\${ORACLE_SID}\&nbsp;行迁移/行连接情况<a name=\"\${ORACLE_SID}行迁移/行连接情况\"></a></b></H2>";
	host echo "<font size=4><xmp>";
select owner,table_name,tablespace_name,chain_cnt from dba_tables  dt where dt.chain_cnt>0 order by chain_cnt;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";


host echo "<H2><b>\${ORACLE_SID}\&nbsp;全表扫描情况<a name=\"\${ORACLE_SID}全表扫描情况\"></a></b></H2>";
	host echo "<font size=4><xmp>";

COLUMN large_table_scans   FORMAT 999,999,999,999,999  HEADING 'Large Table Scans'   ENTMAP off
COLUMN small_table_scans   FORMAT 999,999,999,999,999  HEADING 'Small Table Scans'   ENTMAP off
COLUMN pct_large_scans                                 HEADING 'Pct. Large Scans'    ENTMAP off

SELECT
    a.value large_table_scans
  , b.value small_table_scans
  , ROUND(100*a.value/DECODE((a.value+b.value),0,1,(a.value+b.value)),2)  pct_large_scans
FROM
    v\$sysstat  a
  , v\$sysstat  b
WHERE
      a.name = 'table scans (long tables)'
  AND b.name = 'table scans (short tables)';


host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";



       host echo "<H2><b>\${ORACLE_SID}\&nbsp;当前等待超过1分钟的事件<a name=\"\${ORACLE_SID}当前等待超过1分钟的事件\"></a></b></H2>";
	host echo "<font size=4><xmp>";

col sid for 9999
col event for a50
col seconds_in_wait for 99999
select sid,event,seconds_in_wait from v\$session_wait where 
event not like 'rdbms%' 
and event not like 'pmon%'
and event not like 'SQL*Net%'
and event not like 'smon%'
and event not like 'Streams AQ%'
and event not like 'jobq%'
and event not like '%Idle%'
and seconds_in_wait >60
and state='WAITING'
and wait_time=0;

       host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";


	host echo "<H2><b>\${ORACLE_SID}\&nbsp;TOP5等待事件<a name=\"\${ORACLE_SID}TOP5等待事件\"></a></b></H2>";
	host echo "<font size=4><xmp>";
col event for a50
col suml for a10
select event ,total_waits,suml
from
(select event,total_waits,round(total_waits/sumt*100,0)||'%' suml
from
(select event,total_waits from v\$system_event ),
(select sum(total_waits) sumt from v\$system_event)
order by total_waits desc)
where rownum<6
and event not like 'rdbms%' 
and event not like 'pmon%'
and event not like 'SQL*Net%'
and event not like 'smon%';
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";


	host echo "<H2><b>\${ORACLE_SID}\&nbsp;磁盘中多次执行排序的次数<a name=\"\${ORACLE_SID}磁盘中多次执行排序的次数\"></a></b></H2>";
	host echo "<font size=4><xmp>";
select count(*) from v\$sql_workarea where MULTIPASSES_EXECUTIONS>0;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";

	host echo "<H2><b>\${ORACLE_SID}\&nbsp;需要重建的索引<a name=\"\${ORACLE_SID}需要重建的索引\"></a></b></H2>";
	host echo "<font size=4><xmp>";
select di.owner,di.index_name,di.table_name from dba_indexes di where di.blevel>3;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";


	host echo "<H2><b>\${ORACLE_SID}\&nbsp;无效的数据库对象<a name=\"\${ORACLE_SID}无效的数据库对象\"></a></b></H2>";
	host echo "<font size=4><xmp>";
col object_name for a30
col owner for a30
select owner,object_name,object_type from dba_objects where status<>'VALID' and owner not in ('SYS','SYSTEM','ODM','OE','ODM_MTR','SCOTT','MDSYS','ORDSYS','CTXSYS','RMAN','WKSYS','WMS YS',
'QS','QS_CBADM','QS_CS','QS_ES','QS_OS','QS_WS','XDB','PM','PERFSTAT','OUTLN','OLAPSYS');
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";



	host echo "<H2><b>\${ORACLE_SID}\&nbsp;未启用的约束<a name=\"\${ORACLE_SID}未启用的约束\"></a></b></H2>";
	host echo "<font size=4><xmp>";
col object_name for a30
col owner for a30
select owner,object_name,object_type from dba_objects where status<>'VALID' and owner not in ('SYS','SYSTEM','ODM','OE','ODM_MTR','SCOTT','MDSYS','ORDSYS','CTXSYS','RMAN','WKSYS','WMS YS',
'QS','QS_CBADM','QS_CS','QS_ES','QS_OS','QS_WS','XDB','PM','PERFSTAT','OUTLN','OLAPSYS');
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";



	host echo "<H2><b>\${ORACLE_SID}\&nbsp;无效的trigger<a name=\"\${ORACLE_SID}无效的trigger\"></a></b></H2>";
	host echo "<font size=4><xmp>";
col TRIGGER_NAME for a30
col owner for a30
select owner, TRIGGER_NAME,TRIGGER_TYPE  from dba_triggers where status<>'ENABLED' and owner not in ('SYS','SYSTEM','ODM','OE','ODM_MTR','SCOTT','MDSYS','ORDSYS','CTXSYS','RMAN','WKSYS','WMS YS',
'QS','QS_CBADM','QS_CS','QS_ES','QS_OS','QS_WS','XDB','PM','PERFSTAT','OUTLN','OLAPSYS');
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";


	host echo "<H2><b>\${ORACLE_SID}\&nbsp;表分析情况<a name=\"\${ORACLE_SID}表分析情况\"></a></b></H2>";
	host echo "<font size=4><xmp>";
col owner for a30
select owner,count(*),
to_char(last_analyzed,'yyyy-mm-dd') dat
from dba_tables where owner not in 
('SYS','SYSTEM','ODM','OE','ODM_MTR','SCOTT','MDSYS','ORDSYS','CTXSYS','RMAN','WKSYS','WMSYS',
'QS','QS_CBADM','QS_CS','QS_ES','QS_OS','QS_WS','XDB','PM','PERFSTAT','OUTLN','OLAPSYS') 
group by to_char(last_analyzed,'yyyy-mm-dd'),owner
order by to_char(last_analyzed,'yyyy-mm-dd');
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";

	host echo "<H2><b>\${ORACLE_SID}\&nbsp;表按大小排序TOP15<a name=\"\${ORACLE_SID}表按大小排序TOP15\"></a></b></H2>";
	host echo "<font size=4><xmp>";
col owner for a30
col segment_name for a30
col tablespace_name for a30
select * from
(
select segment_name,bytes/1024/1024 mb,tablespace_name,owner from dba_segments where segment_type='TABLE' and owner not in ('SYS','SYSTEM') order by mb desc)
where rownum<16;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";

	host echo "<H2><b>\${ORACLE_SID}\&nbsp;表按大小排序TOP10的索引建立情况<a name=\"\${ORACLE_SID}表按大小排序TOP10的索引建立情况\"></a></b></H2>";
	host echo "<font size=4><xmp>";
col table_name for a30
col column_name for a30
col column_postion for 99
col index_name for a30
select table_owner,table_name,index_name,column_name, column_position from dba_ind_columns where table_name in
(select segment_name from
(
select segment_name,bytes/1024/1024 mb from dba_segments where segment_type='TABLE' and owner not in ('SYS','SYSTEM') order by mb desc)
where rownum<11
)
order by table_owner,table_name,index_name, column_position;

	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";

	host echo "<H2><b>\${ORACLE_SID}\&nbsp;sql语句运行时间超过6秒所记录的表<a name=\"\${ORACLE_SID}sql语句运行时间超过6秒所记录的表\"></a></b></H2>";
	host echo "<font size=4><xmp>";
select distinct target from v\$session_longops;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";


	host echo "<H2><b>\${ORACLE_SID}\&nbsp;RMAN配置信息<a name=\"\${ORACLE_SID}RMAN配置信息\"></a></b></H2>"
	host echo "<font size=4><xmp>";
	COLUMN name     FORMAT a48   HEADING 'Name';
	COLUMN value    FORMAT a55   HEADING 'Value';
	select name,value from v\$rman_configuration;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";
	
	host echo "<H2><b>\${ORACLE_SID}\&nbsp;RMAN备份集信息<a name=\"\${ORACLE_SID}RMAN备份集信息\"></a></b></H2>"
	host echo "<font size=4><xmp>";
	COLUMN bs_key                 FORMAT 9999999999                HEADING 'BS|Key'
	COLUMN backup_type            FORMAT a13                    HEADING 'Backup|Type'
	COLUMN device_type            FORMAT a10                     HEADING 'Device|Type'
	COLUMN controlfile_included   FORMAT a11                    HEADING 'Controlfile|Included?'
	COLUMN spfile_included        FORMAT a9                     HEADING 'SPFILE|Included?'
	COLUMN incremental_level      FORMAT 99999999                HEADING 'Inc.|Level'
	COLUMN pieces                 FORMAT 9,99999                  HEADING '# of|Pieces'
	COLUMN start_time             FORMAT a17                    HEADING 'Start|Time'
	COLUMN completion_time        FORMAT a17                    HEADING 'End|Time'
	COLUMN elapsed_seconds        FORMAT 999,9999                HEADING 'Elapsed|Seconds'
	COLUMN tag                    FORMAT a19                    HEADING 'Tag'
	COLUMN block_size             FORMAT 999,999                  HEADING 'Block|Size'
	SELECT bs.recid                                              bs_key
	  , DECODE(backup_type
	           , 'L', 'Archived Logs'
	           , 'D', 'Datafile Full'
	           , 'I', 'Incremental')                          backup_type
	  , device_type                                           device_type
	  , DECODE(   bs.controlfile_included
	            , 'NO', null
	            , bs.controlfile_included)                    controlfile_included
	  , sp.spfile_included                                    spfile_included
	  , bs.pieces                                             pieces
	  , TO_CHAR(bs.start_time, 'mm/dd/yy HH24:MI:SS')         start_time
	  , TO_CHAR(bs.completion_time, 'mm/dd/yy HH24:MI:SS')    completion_time
	  , bs.elapsed_seconds                                    elapsed_seconds
	  , bp.tag                                                tag
	  , bs.block_size                                         block_size
	FROM v\$backup_set                           bs
	  , (select distinct
	         set_stamp
	       , set_count
	       , tag
	       , device_type
	     from v\$backup_piece
	     where status in ('A', 'X'))           bp
	 ,  (select distinct
	         set_stamp
	       , set_count
	       , 'YES'     spfile_included
	     from v\$backup_spfile)                 sp
	WHERE bs.set_stamp = bp.set_stamp
	  AND bs.set_count = bp.set_count
	  AND bs.set_stamp = sp.set_stamp (+)
	  AND bs.set_count = sp.set_count (+)
	ORDER BY bs.recid;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";
	
	host echo "<H2><b>\${ORACLE_SID}\&nbsp;RMAN控制文件备份信息<a name=\"\${ORACLE_SID}RMAN控制文件备份信息\"></a></b></H2>"
	host echo "<font size=4><xmp>";
	COLUMN bs_key                 FORMAT 9999999999     HEADING 'BS|Key'
	COLUMN piece#                 FORMAT 99999999    HEADING 'Piece|#'
	COLUMN copy#                  FORMAT 999999     HEADING 'Copy|#'
	COLUMN bp_key                 FORMAT 999999999     HEADING 'BP|Key'
	COLUMN controlfile_included   FORMAT a11      HEADING 'Controlfile|Included?'
	COLUMN completion_time        FORMAT a20      HEADING 'Completion|Time'
	COLUMN status                 FORMAT a9       HEADING 'Status'
	COLUMN handle                 FORMAT a65      HEADING 'Handle'
	SELECT bs.recid                                            bs_key
	  , bp.piece#                                              piece#
	  , bp.copy#                                               copy#
	  , bp.recid                                               bp_key
	  , DECODE(   bs.controlfile_included
	            , 'NO', '-'
	            , bs.controlfile_included)                     controlfile_included
	  , TO_CHAR(bs.completion_time, 'DD-MON-YYYY HH24:MI:SS')  completion_time
	  , DECODE(   status
	            , 'A', 'Available'
	            , 'D', 'Deleted'
	            , 'X', 'Expired')                              status
	  , handle                                                 handle
	FROM v\$backup_set    bs , v\$backup_piece  bp
	WHERE bs.set_stamp = bp.set_stamp
	  AND bs.set_count = bp.set_count
	  AND bp.status IN ('A', 'X')
	  AND bs.controlfile_included != 'NO'
	ORDER BY bs.recid, piece#;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";
	
	host echo "<H2><b>\${ORACLE_SID}\&nbsp;RMAN spfile备份信息<a name=\"\${ORACLE_SID}RMAN spfile备份信息\"></a></b></H2>"
	host echo "<font size=4><xmp>";
	COLUMN bs_key                 FORMAT 999999999     HEADING 'BS|Key'
	COLUMN piece#                 FORMAT 999999999    HEADING 'Piece|#'
	COLUMN copy#                  FORMAT 999999     HEADING 'Copy|#'
	COLUMN bp_key                 FORMAT 999999999     HEADING 'BP|Key'
	COLUMN spfile_included        FORMAT a11      HEADING 'SPFILE|Included?'
	COLUMN completion_time        FORMAT a20      HEADING 'Completion|Time'
	COLUMN status                 FORMAT a9       HEADING 'Status'
	COLUMN handle                 FORMAT a65      HEADING 'Handle'
	SELECT bs.recid                                               bs_key
	  , bp.piece#                                              piece#
	  , bp.copy#                                               copy#
	  , bp.recid                                               bp_key
	  , sp.spfile_included                                     spfile_included
	  , TO_CHAR(bs.completion_time, 'DD-MON-YYYY HH24:MI:SS')  completion_time
	  , DECODE(   status
	            , 'A', 'Available'
	            , 'D', 'Deleted'
	            , 'X', 'Expired')                              status
	  , handle                                                 handle
	FROM v\$backup_set                                           bs
	  , v\$backup_piece                                         bp
	  ,  (select distinct
	          set_stamp
	        , set_count
	        , 'YES'     spfile_included
	      from v\$backup_spfile)                                sp
	WHERE bs.set_stamp = bp.set_stamp
	  AND bs.set_count = bp.set_count
	  AND bp.status IN ('A', 'X')
	  AND bs.set_stamp = sp.set_stamp
	  AND bs.set_count = sp.set_count
	ORDER BY bs.recid, piece#;
	host echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	host echo "<hr size=2 width=100% color=\"#ff0000\">";

	exit;
EOF

	echo "<H2><b>${ORACLE_SID}&nbsp;数据库alert日志文件<a name=\"${ORACLE_SID}数据库alert日志文件\"></a></b></H2>"
	echo "<font size=4><xmp>";
	ls -l ${BDUMP}/alert_${ORACLE_SID}.log;
	echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	echo "<hr size=2 width=100% color=\"#ff0000\">";

	echo "<H2><b>${ORACLE_SID}&nbsp;数据库监听日志文件<a name=\"${ORACLE_SID}数据库监听日志文件\"></a></b></H2>"
	echo "<font size=4><xmp>";
	ls -l ${ORACLE_HOME}/network/log/listener.log;
	echo "</xmp></font><br><a href=\"#top\">返回页首</a>";
	echo "<hr size=2 width=100% color=\"#ff0000\">";

done
fi

