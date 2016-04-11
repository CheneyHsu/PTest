set serverout on size 1000000 format wrap
set pagesize 0
set linesize 120

declare
sleep_time       constant  NUMBER(3)  :=  5;
display_time     constant  CHAR(3)    := 'N';
display_ratio    constant  CHAR(1)    := 'N';
display_tmodel   constant  CHAR(1)    := 'N';

cursor c1 /* collect stat and wait */ 
is
select swid,name,value,timems,timeouts,sysdate
from 
(select 'STAT'swid,name,value,0 timems,0 timeouts from v$sysstat
 union all
 select 'WAIT'swid ,event,total_waits,TIME_WAITED*10,TOTAL_TIMEOUTS from v$system_event
 )
where name in 
(
/** stat **/
'logons cumulative'          ,
'user commits'               ,
'user rollbacks'             ,
'redo blocks written'        ,
'parse count (hard)'         ,
'parse count (total)'        ,
'sorts (memory)'             ,
'sorts (disk)'               ,
'execute count'              ,
'physical reads'             ,
'session logical reads'      ,
'physical writes'            ,
'parse time cpu'             ,
'parse time elapsed'         ,
/** wait **/
'log file sync'              ,
'log file parallel write'    ,
'control file parallel write',
'db file parallel write'     ,
'db file scattered read'     ,
'read by other session'      ,
'buffer busy waits'          ,
'db file sequential read'
)
order by 1,2;

tmstmt varchar2(400) :='select ''TIME'' swid,stat_name,value,0 timems,0 timeouts,sysdate from v$sys_time_model order by stat_name';

type stat_wait is record ( swid CHAR(4),
                           name varchar2(64),
                           count number,
                           time_waited_ms number,
                           totaltimeouts number,
                           snaptime date
                          );
type stat_wait_tab is table of stat_wait index by pls_integer;
pre_tab stat_wait_tab;
nex_tab stat_wait_tab;
pre_tm_tab stat_wait_tab;                          
nex_tm_tab stat_wait_tab;

type interval_wait is record ( 
                            name varchar2(64),
                            count number(18),
                            count_per_sec number(10),
                            time_waited_ms number,
                            avg_waited_ms number(12,2),
                            totaltimeouts number,
                            timeouts_per_sec number(10),
                            interval_sec number);
type interval_wait_tab is table of interval_wait index by varchar2(64);
result_tab_wait interval_wait_tab;

type interval_stat is record ( 
                            name varchar2(64),
                            count number(13,2),
                            count_per_sec number(13,2),
                            interval_sec number);
type interval_stat_tab is table of interval_stat index by pls_integer;
result_tab_stat interval_stat_tab;
result_tab_time interval_stat_tab;


type num_tab is table of number index by varchar2(64);
ratio_tab num_tab;
ratio  number(7,2) :=0;

p number(4) :=1;
s number(4) :=1;
w number(4) :=1;
t number(4) :=1;


db_ver_p      number(9);      -- database primary version
db_plat_p     varchar2(60);   -- database planform
db_cpu_count  number(4);      -- database cpu count
inst_name_p   varchar2(20);
host_name_p   varchar2(20);

begin

/***********************************  COLLECT BASIC INFO: Version,CPU count and Platform   *********************************/ 

select to_number(replace(version,'.')),instance_name,host_name into db_ver_p,inst_name_p,host_name_p from v$instance;

select platform_name into db_plat_p from v$database;

select value into db_cpu_count from v$parameter where name='cpu_count';



/************************************************  BEGIN SNAP AND END SNAP   **********************************************/ 

	open c1;
	fetch c1 BULK COLLECT into pre_tab;
	close c1;
  
  if display_tmodel='Y' and db_ver_p>=100000 then
    execute immediate tmstmt bulk collect into pre_tm_tab;
  end if;
             
	dbms_lock.sleep(sleep_time);

	open c1;
	fetch c1 BULK COLLECT into nex_tab;
	close c1;

  if display_tmodel='Y' and db_ver_p>=100000 then
    execute immediate tmstmt bulk collect into nex_tm_tab;
  end if;

/***** DEBUG SNAP 
for i in pre_tab.first .. pre_tab.last loop
dbms_output.put_line('DEBUG PRE '||pre_tab(i).name||','||to_char(pre_tab(i).snaptime,'yyyymmdd hh24:mi;ss'));
end loop;

for i in nex_tab.first .. nex_tab.last loop
dbms_output.put_line('DEBUG NEX '||nex_tab(i).name||','||to_char(nex_tab(i).snaptime,'yyyymmdd hh24:mi;ss'));
end loop;

DEBUG SNAP ****/

/****************************  CALCULATE STAT / WAIT INTEVAL VALUE BETWEEN BEGIN SNAP AND END SNAP   **********************************/ 
p:=nex_tab.first;

for i in nex_tab.first .. nex_tab.last loop
  
 if nex_tab(i).name=pre_tab(p).name and nex_tab(i).swid=pre_tab(p).swid then
  
  if nex_tab(i).swid='STAT' then
     result_tab_stat(s).name:=nex_tab(i).name;
     result_tab_stat(s).count:=nex_tab(i).count-pre_tab(p).count;
     result_tab_stat(s).interval_sec:=round((nex_tab(i).snaptime-pre_tab(p).snaptime)*86400);
     result_tab_stat(s).count_per_sec:=round( result_tab_stat(s).count/result_tab_stat(s).interval_sec );

     s:=s+1;
     
  elsif nex_tab(i).swid='WAIT' then
     result_tab_wait(w).name:=nex_tab(i).name;
     result_tab_wait(w).count:=nex_tab(i).count-pre_tab(p).count;
     result_tab_wait(w).time_waited_ms:=nex_tab(i).time_waited_ms-pre_tab(p).time_waited_ms;
     result_tab_wait(w).totaltimeouts:=nex_tab(i).totaltimeouts-pre_tab(p).totaltimeouts;
     result_tab_wait(w).interval_sec:=round((nex_tab(i).snaptime-pre_tab(p).snaptime)*86400);
     result_tab_wait(w).count_per_sec:=round( result_tab_wait(w).count / result_tab_wait(w).interval_sec );
     result_tab_wait(w).timeouts_per_sec:=round( result_tab_wait(w).totaltimeouts / result_tab_wait(w).interval_sec );

     if result_tab_wait(w).count > 0 then 
       result_tab_wait(w).avg_waited_ms:=round( result_tab_wait(w).time_waited_ms / result_tab_wait(w).count );
     else 
       result_tab_wait(w).avg_waited_ms:=0;
     end if;  

     w:=w+1;

  end if;    -- end of result calculating

 p:=p+1;
 
 else

  if nex_tab(i).swid='STAT' then
     result_tab_stat(s).name:=nex_tab(i).name;
     result_tab_stat(s).count:=nex_tab(i).count-0;
     result_tab_stat(s).interval_sec:=round((nex_tab(1).snaptime-pre_tab(1).snaptime)*86400);
     result_tab_stat(s).count_per_sec:=round( result_tab_stat(s).count/result_tab_stat(s).interval_sec );

     s:=s+1;
     
  elsif nex_tab(i).swid='WAIT' then
     result_tab_wait(w).name:=nex_tab(i).name;
     result_tab_wait(w).count:=nex_tab(i).count-0;
     result_tab_wait(w).time_waited_ms:=nex_tab(i).time_waited_ms-0;
     result_tab_wait(w).totaltimeouts:=nex_tab(i).totaltimeouts-0;
     result_tab_wait(w).interval_sec:=round((nex_tab(i).snaptime-pre_tab(p).snaptime)*86400);
     result_tab_wait(w).count_per_sec:=round( result_tab_wait(w).count / result_tab_wait(w).interval_sec );
     result_tab_wait(w).timeouts_per_sec:=round( result_tab_wait(w).totaltimeouts / result_tab_wait(w).interval_sec );

     if result_tab_wait(w).count > 0 then 
       result_tab_wait(w).avg_waited_ms:=round( result_tab_wait(w).time_waited_ms / result_tab_wait(w).count );
     else 
       result_tab_wait(w).avg_waited_ms:=0;
     end if;  

     w:=w+1;

  end if;  
 end if;   -- end of result calculating
 
end loop;

/****************************  CALCULATE TIME MODEL INTEVAL VALUE BETWEEN BEGIN SNAP AND END SNAP   **********************************/ 

if display_tmodel='Y' and db_ver_p>=100000 then

  p:=nex_tm_tab.first;
  for i in nex_tm_tab.first .. nex_tm_tab.last loop

   if nex_tm_tab(i).name=pre_tm_tab(p).name and nex_tm_tab(i).swid=pre_tm_tab(p).swid then 

    if nex_tm_tab(i).swid='TIME' then
     result_tab_time(t).name:=nex_tm_tab(i).name;
     result_tab_time(t).count:=round((nex_tm_tab(i).count-pre_tm_tab(p).count)/1000000,3);  -- DB TIME, CPU TIME in seconds
     result_tab_time(t).interval_sec:=round((nex_tm_tab(i).snaptime-pre_tm_tab(p).snaptime)*86400);
     result_tab_time(t).count_per_sec:=round( result_tab_time(t).count / result_tab_time(t).interval_sec );
     t:=t+1;
    end if;    -- end of result calculating
    p:=p+1;
   else
    if nex_tm_tab(i).swid='TIME' then
     result_tab_time(t).name:=nex_tm_tab(i).name;
     result_tab_time(t).count:=round((nex_tm_tab(i).count- 0 )/1000000,3);  -- DB TIME, CPU TIME in seconds
     result_tab_time(t).interval_sec:=round((nex_tm_tab(i).snaptime-pre_tm_tab(p).snaptime)*86400);
     result_tab_time(t).count_per_sec:=round( result_tab_time(t).count / result_tab_time(t).interval_sec );
     t:=t+1;
    end if ;   -- end of result calculating
   end if;  
  end loop;

end if;

/*********************************  DISPLAY BANNER   **************************************/ 

if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line(lpad('~',38,'~'));
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line('|Instance Name | '||rpad(inst_name_p,19)||' |');
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line('|    Host Name | '||rpad(host_name_p,19)||' |');
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line('|     Platform | '||rpad(db_plat_p,19)||' |');
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line('|      Version | '||rpad(db_ver_p,19)||' |');
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line('|   Snap Begin | '||to_char(pre_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')||' |');
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line('|          End | '||to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')||' |');
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line(lpad('~',38,'~'));


/****************************  CALCULATE STAT HITRATIO   **********************************/ 

if display_ratio='Y' then

for j in result_tab_stat.first .. result_tab_stat.last loop
   ratio_tab(result_tab_stat(j).name):=result_tab_stat(j).count;
end loop;

if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line('  Efficiency - Target 100% '); 
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line(lpad('~',45,'~'));

-- buffer hit
begin

  ratio:= round(100* (1- ( ratio_tab('physical reads')/ ratio_tab('session logical reads') ) ) , 2);
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
  dbms_output.put('|');
  dbms_output.put(lpad('Buffer Hit(%)',30));
  dbms_output.put(' | ');
  dbms_output.put(rpad(to_char( ratio,'9999.99'),10 ) );
  dbms_output.put('|');
  dbms_output.new_line;
exception when others then
  null;
end;

-- im meory sort
begin
  ratio:= round(100* ratio_tab('sorts (memory)')/ ( ratio_tab('sorts (memory)') +  ratio_tab('sorts (disk)') ) , 2);
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
  dbms_output.put('|');
  dbms_output.put(lpad('In-memory Sort(%)',30));
  dbms_output.put(' | ');
  dbms_output.put(rpad(to_char( ratio,'9999.99'),10 ) );
  dbms_output.put('|');
  dbms_output.new_line;
exception when others then
  null;
end;

-- soft parse
begin
  ratio:= round(100* (1- ( ratio_tab('parse count (hard)')/ ratio_tab('parse count (total)') ) ), 2);
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
  dbms_output.put('|');
  dbms_output.put(lpad('Soft Parse(%)',30));
  dbms_output.put(' | ');
  dbms_output.put(rpad(to_char( ratio,'9999.99'),10 ) );
  dbms_output.put('|');
  dbms_output.new_line;
exception when others then
  null;
end;

-- Txn Commit
begin
  ratio:= round(100* ratio_tab('user commits')/ ( ratio_tab('user commits') +  ratio_tab('user rollbacks') ) , 2);
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
  dbms_output.put('|');
  dbms_output.put(lpad('Transaction Success(%)',30));
  dbms_output.put(' | ');
  dbms_output.put(rpad(to_char( ratio,'9999.99'),10 ) );
  dbms_output.put('|');
  dbms_output.new_line;
exception when others then
  null;
end;

-- Execute to Parse
begin
  ratio:= round(100* (1- ( ratio_tab('execute count')/ ratio_tab('parse count (total)') ) ) , 2);
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
  dbms_output.put('|');
  dbms_output.put(lpad('Execute to Parse(%)',30));
  dbms_output.put(' | ');
  dbms_output.put(rpad(to_char( ratio,'9999.99'),10 ) );
  dbms_output.put('|');
  dbms_output.new_line;
exception when others then
  null;
end;

-- Parse CPU to Elapsed
begin
  ratio:= round(100* ratio_tab('parse time cpu')/ ratio_tab('parse time elapsed')  , 2);
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
  dbms_output.put('|');
  dbms_output.put(lpad('Parse CPU to Elapsed(%)',30));
  dbms_output.put(' | ');
  dbms_output.put(rpad(to_char( ratio,'9999.99'),10 ) );
  dbms_output.put('|');
  dbms_output.new_line;
exception when others then
  null;
end;

if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line(lpad('~',45,'~'));
end if;

/*****************************************************  DISPLAY STAT  **********************************************************/ 

if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line('  Instance Load Details'); 

if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line(lpad('~',60,'~'));

if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
  dbms_output.put('|');
  dbms_output.put(lpad('Statistic Name',40,' '));
  dbms_output.put(' |');
  dbms_output.put(lpad('Value (/s)',15 ) );
  dbms_output.put(' |');
  dbms_output.new_line;
  
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
  dbms_output.put('|');
  dbms_output.put(lpad('-',40,'-'));
  dbms_output.put('-|');
  dbms_output.put(lpad('-',15,'-'));
  dbms_output.put('-|');
  dbms_output.new_line;


for i in result_tab_stat.first .. result_tab_stat.last loop

if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
  dbms_output.put('|');
  dbms_output.put(lpad(substr(result_tab_stat(i).name,1,40),40));
  dbms_output.put(' |');
  dbms_output.put(lpad(to_char(result_tab_stat(i).count_per_sec,'999,999,999.99'),15 ) );
  dbms_output.put(' |');
  dbms_output.new_line;
end loop;

if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line(lpad('~',60,'~'));


/*****************************************************  DISPLAY WAIT  **********************************************************/ 
if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line('  Wait Events '); 

if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line(lpad('~',74,'~'));

if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
  dbms_output.put('|');
  dbms_output.put(lpad('Wait Event Name',40));
  dbms_output.put(' |');
  dbms_output.put(lpad('Wait(ms)',8 ) );
  dbms_output.put(' |');
  dbms_output.put(lpad('Waits/S',9 ) );
  dbms_output.put(' |');
  dbms_output.put(lpad('TmOuts/S',8 ) );
  dbms_output.put(' |');
  dbms_output.new_line;

if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
  dbms_output.put('|');
  dbms_output.put(rpad('-',40,'-'));
  dbms_output.put(' |');
  dbms_output.put(lpad('-',8,'-' ) );
  dbms_output.put('-|');
  dbms_output.put(lpad('-',9,'-' ) );
  dbms_output.put('-|');
  dbms_output.put(lpad('-',8,'-' ) );
  dbms_output.put('-|');
  dbms_output.new_line;

for i in result_tab_wait.first .. result_tab_wait.last loop



if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
  dbms_output.put('|');
  dbms_output.put(lpad(substr(result_tab_wait(i).name,1,40),40));
  dbms_output.put(' |');
  dbms_output.put(rpad(to_char(result_tab_wait(i).avg_waited_ms,'9,999.99'),8 ) );
  dbms_output.put(' |');
  dbms_output.put(rpad(to_char(result_tab_wait(i).count_per_sec,'99,999.99'),9 ) );
  dbms_output.put(' |');
  dbms_output.put(rpad(to_char(result_tab_wait(i).timeouts_per_sec,'99,999.99'),8 ) );
  dbms_output.put(' |');
  dbms_output.new_line;
end loop;

if display_time='Y' then dbms_output.put(to_char(nex_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line(lpad('~',74,'~'));

/**************************************************  DISPLAY TIME MODEL  *******************************************************/ 
if display_tmodel='Y' and db_ver_p>=100000 then

if display_time='Y' then dbms_output.put(to_char(nex_tm_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line('  Instance Time Model'); 

if display_time='Y' then dbms_output.put(to_char(nex_tm_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line(lpad('~',60,'~'));

if display_time='Y' then dbms_output.put(to_char(nex_tm_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
  dbms_output.put('|');
  dbms_output.put(lpad('Statistic Name',40,' '));
  dbms_output.put(' |');
  dbms_output.put(lpad('Time (Sec.)',15 ) );
  dbms_output.put(' |');
  dbms_output.new_line;
  
if display_time='Y' then dbms_output.put(to_char(nex_tm_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
  dbms_output.put('|');
  dbms_output.put(lpad('-',40,'-'));
  dbms_output.put('-|');
  dbms_output.put(lpad('-',15,'-'));
  dbms_output.put('-|');
  dbms_output.new_line;


for i in result_tab_time.first .. result_tab_time.last loop

if display_time='Y' then dbms_output.put(to_char(nex_tm_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
  dbms_output.put('|');
  dbms_output.put(lpad(substr(result_tab_time(i).name,1,40),40));
  dbms_output.put(' |');
  dbms_output.put(lpad(to_char(result_tab_time(i).count_per_sec,'999,999,999.99'),15 ) );
  dbms_output.put(' |');
  dbms_output.new_line;
end loop;

if display_time='Y' then dbms_output.put(to_char(nex_tm_tab(1).snaptime,'yyyy-mm-dd hh24:mi:ss')); end if;
dbms_output.put_line(lpad('~',60,'~'));

end if; -- end of time model


end;
/
exit


