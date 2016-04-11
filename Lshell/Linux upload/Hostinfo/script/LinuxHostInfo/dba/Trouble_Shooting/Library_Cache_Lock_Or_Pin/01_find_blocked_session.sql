/** 1. find blocked session, and its requested lock handle **/
select k.kgllkhdl lock_handle,k.kgllkreq req,kgllkmod lmod,kgllkses saddr from x$kgllk k
where k.kgllkreq>0 
