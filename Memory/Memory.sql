select * from sys.dm_os_performance_counters
where object_name like '%Buffer Node%' 

select type, name, sum(pages_kb)/1024 as multi_pages_mb
--select type, name, sum((pages_kb*1024)/8192) as stolen_pages
from sys.dm_os_memory_clerks
where pages_kb > 0
group by type, name
order by multi_pages_mb desc

--Memory buffer size
select-- top 10
		pages_kb / 1024. as SizeMB, 
		type,
		name,
		memory_node_id,
		virtual_memory_reserved_kb,
		virtual_memory_committed_kb,
		awe_allocated_kb,
		shared_memory_reserved_kb,
		shared_memory_committed_kb
from sys.dm_os_memory_clerks
where pages_kb > 0
	and pages_kb / 1024. > 500
	--and name = 'TokenAndPermUserStore'
	--and (type like '%clr%' or name like '%clr%')
order by pages_kb desc

select *
from sys.dm_exec_query_resource_semaphores

--Cache entry count
select -- top 10
		--pages_kb / 1024. as SizeMB,
		--pages_in_use_kb / 1024. as SizeInUseMB,
		c.single_pages_kb + c.multi_pages_kb / 1024. as SizeMB,
		c.single_pages_in_use_kb + c.multi_pages_in_use_kb / 1024. as SizeInUseMB,
		name,
		type,
		entries_count,
		entries_in_use_count
from sys.dm_os_memory_cache_counters c
where entries_count  > 0
--order by pages_kb desc
order by c.single_pages_kb + c.multi_pages_kb / 1024. desc

--Cache entry count 2012
select -- top 10
		pages_kb / 1024. as SizeMB,
		pages_in_use_kb / 1024. as SizeInUseMB,
		name,
		type,
		entries_count,
		entries_in_use_count
from sys.dm_os_memory_cache_counters c
where entries_count  > 0
order by pages_kb desc

--DBCC FREESYSTEMCACHE ('TokenAndPermUserStore')
--DBCC FREESYSTEMCACHE ('ClrProcCache')
--DBCC FREESYSTEMCACHE ('Temporary Tables & Table Variables')
--DBCC FREESYSTEMCACHE ('DB')
--DBCC FREESYSTEMCACHE ('Object Plans')



select count(*)
from sys.dm_os_sublatches


--NUMA nodes memory
select	memory_node_id,
		locked_page_allocations_kb / 1024. /1024 as locked_page_allocations_gb,
		pages_kb / 1024. /1024 as pages_gb,
		foreign_committed_kb / 1024. /1024 as foreign_committed_gb 
from sys.dm_os_memory_nodes


select top 30 
	pages_in_bytes / 1024. / 1024 / 1024,
	*
from sys.dm_os_memory_objects
--where memory_object_address = 0x00000018DECDA780
order by pages_in_bytes desc

select type,
		count(memory_object_address)
from sys.dm_os_memory_objects
group by type
order by 2 desc

select memory_node_id, 
		count(memory_object_address)
from sys.dm_os_memory_objects
group by memory_node_id
order by 2 desc


select *
from sys.dm_os_memory_pools

select *
from sys.dm_os_schedulers
where status != 'VISIBLE OFFLINE'

select *
from sys.syscacheobjects 
where usecounts > 1
	and 
	dbid = db_id()
order by usecounts desc

select count(*), sum(sqlbytes) / 1024. / 1024
from sys.syscacheobjects 
where usecounts = 1
	and 
	dbid = db_id()

select	scheduler_id,
		cpu_id,
		is_idle,
		current_tasks_count,
		current_workers_count,
		runnable_tasks_count,
		active_workers_count,
		work_queue_count,
		pending_disk_io_count
from sys.dm_os_schedulers
where status = 'VISIBLE ONLINE'
order by runnable_tasks_count desc

select top 100 *
from sys.syscacheobjects
order by usecounts desc