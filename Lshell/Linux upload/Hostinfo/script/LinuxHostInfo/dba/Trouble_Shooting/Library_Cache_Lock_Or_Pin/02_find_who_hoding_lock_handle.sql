/** 2. find the session who is holding the lock_handle **/
select k.kgllkhdl lock_handle,k.kgllkreq req,kgllkmod lmod,kgllkses saddr from x$kgllk k
where kgllkmod>0
  and k.kgllkhdl='&lock_handle';

