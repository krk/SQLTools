select *
from sys.dm_os_latch_stats
where waiting_requests_count > 0
order by wait_time_ms desc


select *
from sys.dm_os_spinlock_stats
where collisions > 0
--order by collisions desc
--order by spins_per_collision desc
--order by sleep_time desc
order by backoffs desc
--order by spins desc


	
SELECT * FROM sys.dm_exec_query_optimizer_info;

SELECT session_id, 
    SUM(internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
	SUM(internal_objects_alloc_page_count) * 8. / 1024 / 1024 AS task_internal_objects_alloc_page_MB,
    SUM(internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count 
FROM sys.dm_db_task_space_usage 
where session_id > 50
GROUP BY session_id
order by session_id
