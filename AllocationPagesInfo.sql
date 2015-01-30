SELECT DB_NAME(database_id) as dbname, *
FROM sys.dm_os_buffer_descriptors
WHERE database_id = 2 --AND file_id = 1 AND 
	and page_id < 20
	and page_type in ('PFS_PAGE', 'GAM_PAGE', 'SGAM_PAGE')
order by database_id, file_id, page_id

select *
from sys.dm_os_memory_allocations




