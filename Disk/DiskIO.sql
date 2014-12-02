
SELECT   SUBSTRING(saf.physical_name, 1, 1)		AS Drive
		, SUM(vfs.num_of_bytes_read/1024/1024/1024)		AS Read_GB
		, SUM(vfs.num_of_bytes_written/1024/1024/1024)		AS Write_GB
FROM	 sys.master_files				AS saf
JOIN	 sys.dm_io_virtual_file_stats(NULL,NULL)	AS vfs
ON	 vfs.database_id = saf.database_id 
AND	 vfs.file_id = saf.file_id
AND	 saf.database_id NOT IN (1,3,4)
AND	 saf.type < 2
GROUP BY SUBSTRING(saf.physical_name, 1, 1)
ORDER BY 1
GO



select *
from  sys.dm_io_virtual_file_stats(NULL,NULL)