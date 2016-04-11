set serverout on
declare
  type v_h_r is record(part_position number,part_name varchar2(50),high_value varchar2(4000));
  type v_h_t is table of v_h_r;
  v_h v_h_t;
  lpid number :=2;
  hvalue_char varchar2(8);
  pre_hvalue_char varchar2(8);
  hvalue_date date;
  pre_hvalue_date date;
  p_interval number :=30;
  exp_date date :=add_months(sysdate,6);
  lead_num_d number :=62;
  lead_num_w number :=105;
  lead_num_m number :=6;
  lead_num_q number :=12;
  lead_num_y number :=24;
  cursor c_pt is 
  select owner,table_name from dba_part_tables 
  where 
  partitioning_type='RANGE'
  and owner not in 
  ('SYS','SYSTEM','PERFSTAT','DBSNMP','OUTLN',
  'DRSYS','WKSYS','WMSYS','ORDSYS','MDSYS','CTXSYS','XDB','OE',
  'SH','QS','QS_ES','SQLTXPLAIN','SYSMAN','QS_WS','QS_OS','QS_CBADM','QS_CS',
  'AURORA$JIS$UTILITY$','OSE$HTTP$ADMIN')
  ;
  cursor c_spt is 
  select owner,table_name from dba_part_tables 
  where 
  subpartitioning_type='RANGE'
  and owner not in 
  ('SYS','SYSTEM','PERFSTAT','DBSNMP','OUTLN',
  'DRSYS','WKSYS','WMSYS','ORDSYS','MDSYS','CTXSYS','XDB','OE',
  'SH','QS','QS_ES','SQLTXPLAIN','SYSMAN','QS_WS','QS_OS','QS_CBADM','QS_CS',
  'AURORA$JIS$UTILITY$','OSE$HTTP$ADMIN')
  ;
begin

-- checking partitions
for i in c_pt loop

  select partition_position,partition_name,high_value 
    bulk collect into v_h
    from dba_tab_partitions
   where table_name=i.table_name
     and table_owner=i.owner
     and partition_position>=(select max(partition_position)-2 from dba_tab_partitions
                           where table_name=i.table_name
                           and table_owner=i.owner
                           )
   order by partition_position desc;
  
  if v_h.count<3 then
    dbms_output.put_line('Warning: Table '||i.owner||'.'||i.table_name||' with number of total defined partitions :'||v_h.count||'.');
  end if;
  
  if instr(v_h(1).high_value,'MAXVALUE')=0 then
    dbms_output.put_line('Warning: Table '||i.owner||'.'||i.table_name||' MAXVALUE partition is not defined.');
    lpid:=1;
  end if;
  
  if v_h(lpid).high_value like 'TO_DATE%' 
    or v_h(lpid).high_value like 'TO_TIMESTAMP%' 
    or (v_h(lpid).high_value like '''20%' 
        and substr( v_h(lpid).high_value,6,1) in ('0','1','-','|','/') 
        and substr( v_h(lpid).high_value,7,1) in ('0','1','2','3','4','5','6','7','8','9') 
        and substr( v_h(lpid).high_value,8,1) in ('0','1','2','3','4','5','6','7','8','9')
        and substr( v_h(lpid).high_value,9,1) in ('0','1','2','3','4','5','6','7','8','9','-','|','/')
        and substr( v_h(lpid).high_value,10,1) in ('0','1','''')
       )
    or (v_h(lpid).high_value like '20%' 
        and substr( v_h(lpid).high_value,5,1) in ('0','1') 
        and substr( v_h(lpid).high_value,7,1) in ('0','1','2','3') 
        and (substr( v_h(lpid).high_value,9,1) is null 
             or substr( v_h(lpid).high_value,9,1)=','
             )
       ) 
    then
    begin
      hvalue_char:=substr(replace(replace(replace(replace(replace(replace(replace(replace( v_h(lpid).high_value, ' ') , 'TO_DATE') , '(') , '-') ,'/') ,'|') ,'TO_TIMESTAMP'), '''') ,1,8);   
      pre_hvalue_char:=substr(replace(replace(replace(replace(replace(replace(replace(replace( v_h(lpid+1).high_value, ' ') , 'TO_DATE') , '(') , '-') ,'/') ,'|') ,'TO_TIMESTAMP'), '''') ,1,8);   
      
      hvalue_date:=to_date(hvalue_char,'yyyymmdd');
      pre_hvalue_date:=to_date(pre_hvalue_char,'yyyymmdd');
      p_interval:=ceil(hvalue_date-pre_hvalue_date);
      
      if p_interval<=1 then
         exp_date:=trunc(sysdate)+ lead_num_d;
      elsif p_interval>1 and p_interval<=7 then
         exp_date:=trunc(sysdate)+ lead_num_w; 
      elsif p_interval>7 and p_interval<=31 then
         exp_date:=add_months(trunc(sysdate),lead_num_m);
      elsif p_interval>31 and p_interval<=92 then
         exp_date:=add_months(trunc(sysdate),lead_num_q);
      else 
         exp_date:=add_months(trunc(sysdate),lead_num_y);
      end if;    
      
      --dbms_output.put_line('Information: '||i.owner||'.'||i.table_name||' last part: '||hvalue_char||'. Interval Days: '||p_interval);
      
      if hvalue_date<exp_date then 
        dbms_output.put('Warning: Table '||i.owner||'.'||i.table_name||', expect partitions by date "'||to_char(exp_date,'yyyy-mm-dd')||'",');
        dbms_output.put_line(' get last date "'||to_char(hvalue_date,'yyyy-mm-dd')||'", Interval days: '||p_interval);
      end if;
    exception when others then 
      null;
    end;
  end if;

end loop;

-- checking subpartitions
for i in c_spt loop
 for j in (select partition_name from dba_tab_partitions where table_name=i.table_name and table_owner=i.owner) loop
  select subpartition_position,subpartition_name,high_value 
    bulk collect into v_h
    from dba_tab_subpartitions
   where table_name=i.table_name
     and table_owner=i.owner
     and partition_name=j.partition_name
     and subpartition_position>=(select max(subpartition_position)-2 from dba_tab_subpartitions
                           where table_name=i.table_name
                           and table_owner=i.owner
                           and partition_name=j.partition_name
                           )
   order by subpartition_position desc;
  
  if v_h.count<3 then
    dbms_output.put_line('Warning: Table partition'||i.owner||'.'||i.table_name||'('||j.partition_name||') with number of total defined subpartitions :'||v_h.count||'.');
  end if;
  
  if instr(v_h(1).high_value,'MAXVALUE')=0 then
    dbms_output.put_line('Warning: Table partition'||i.owner||'.'||i.table_name||'('||j.partition_name||') MAXVALUE subpartition is not defined.');
    lpid:=1;
  end if;
  
  if v_h(lpid).high_value like 'TO_DATE%' 
    or v_h(lpid).high_value like 'TO_TIMESTAMP%' 
    or (v_h(lpid).high_value like '''20%' 
        and substr( v_h(lpid).high_value,6,1) in ('0','1','-','|','/') 
        and substr( v_h(lpid).high_value,7,1) in ('0','1','2','3','4','5','6','7','8','9') 
        and substr( v_h(lpid).high_value,8,1) in ('0','1','2','3','4','5','6','7','8','9')
        and substr( v_h(lpid).high_value,9,1) in ('0','1','2','3','4','5','6','7','8','9','-','|','/')
        and substr( v_h(lpid).high_value,10,1) in ('0','1','''')
       )
    or (v_h(lpid).high_value like '20%' 
        and substr( v_h(lpid).high_value,5,1) in ('0','1') 
        and substr( v_h(lpid).high_value,7,1) in ('0','1','2','3') 
        and (substr( v_h(lpid).high_value,9,1) is null 
             or substr( v_h(lpid).high_value,9,1)=','
             )
       ) 
    then
    begin
      hvalue_char:=substr(replace(replace(replace(replace(replace(replace(replace(replace( v_h(lpid).high_value, ' ') , 'TO_DATE') , '(') , '-') ,'/') ,'|') ,'TO_TIMESTAMP'), '''') ,1,8);   
      pre_hvalue_char:=substr(replace(replace(replace(replace(replace(replace(replace(replace( v_h(lpid+1).high_value, ' ') , 'TO_DATE') , '(') , '-') ,'/') ,'|') ,'TO_TIMESTAMP'), '''') ,1,8);   
      hvalue_date:=to_date(hvalue_char,'yyyymmdd');
      pre_hvalue_date:=to_date(pre_hvalue_char,'yyyymmdd');
      p_interval:=round(hvalue_date-pre_hvalue_date);
      
      --dbms_output.put_line('Information: '||i.owner||'.'||i.table_name||'('||j.partition_name||') Interval Days: '||p_interval||', last subpart: '||hvalue_char);
      
      if p_interval<=1 then
         exp_date:=trunc(sysdate)+ lead_num_d;
      elsif p_interval>1 and p_interval<=7 then
         exp_date:=trunc(sysdate)+ lead_num_w; 
      elsif p_interval>7 and p_interval<=31 then
         exp_date:=add_months(trunc(sysdate),lead_num_m);
      elsif p_interval>31 and p_interval<=92 then
         exp_date:=add_months(trunc(sysdate),lead_num_q);
      else 
         exp_date:=add_months(trunc(sysdate),lead_num_y);
      end if;    
      
      if hvalue_date<exp_date then 
        dbms_output.put('Warning: Table '||i.owner||'.'||i.table_name||'('||j.partition_name||'), expect partitions by date "'||to_char(exp_date,'yyyy-mm-dd')||'", ');
        dbms_output.put_line(' But last defined partition is for date "'||to_char(hvalue_date,'yyyy-mm-dd')||'". Interval Days: '||p_interval);
      end if;
    exception when others then 
      null;
    end;
  end if;
 end loop;
end loop;
end;
/

