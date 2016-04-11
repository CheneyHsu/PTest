set pagesize 0;
set line 600;
select username,'|',user_id,'|',account_status,'|',lock_date,'|',expiry_date,'|',default_tablespace,'|',temporary_tablespace,'|',created,'|',profile,'|',initial_rsrc_consumer_group from dba_users;
