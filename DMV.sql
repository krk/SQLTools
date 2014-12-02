--DBCC SQLPERF("sys.dm_os_wait_stats",CLEAR);
--DBCC SQLPERF("sys.dm_os_latch_stats",CLEAR);
--DBCC SQLPERF("sys.dm_os_spinlock_stats",CLEAR);

--DBCC SQLPERF(LOGSPACE);
select *
from sys.dm_os_sys_info

select *
from sys.dm_os_schedulers
where scheduler_id < 1048576
	and status = 'VISIBLE ONLINE'
order by scheduler_id, cpu_id


select *
from sys.dm_os_latch_stats
where waiting_requests_count > 0
order by wait_time_ms desc

select * 
from sys.dm_os_wait_stats
where wait_type NOT IN (
	'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE', 'SLEEP_TASK','SLEEP_SYSTEMTASK', 
	'SQLTRACE_BUFFER_FLUSH', 'WAITFOR', 'LOGMGR_QUEUE',  'CHECKPOINT_QUEUE', 'REQUEST_FOR_DEADLOCK_SEARCH', 
	'XE_TIMER_EVENT', 'BROKER_TO_FLUSH', 'BROKER_TASK_STOP', 'CLR_MANUAL_EVENT', 'CLR_AUTO_EVENT', 
	'DISPATCHER_QUEUE_SEMAPHORE', 'FT_IFTS_SCHEDULER_IDLE_WAIT', 'XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN', 
	'BROKER_EVENTHANDLER', 'TRACEWRITE', 'FT_IFTSHC_MUTEX', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
	'BROKER_RECEIVE_WAITFOR', 'ONDEMAND_TASK_QUEUE', 'DBMIRROR_EVENTS_QUEUE',
	'DBMIRRORING_CMD', 'BROKER_TRANSMITTER', 'SQLTRACE_WAIT_ENTRIES',
	'SLEEP_BPOOL_FLUSH', 'SQLTRACE_LOCK', 'DIRTY_PAGE_POLL', 'HADR_FILESTREAM_IOMGR_IOCOMPLETION',
	'SP_SERVER_DIAGNOSTICS_SLEEP')
	and wait_time_ms > 0	

order by waiting_tasks_count desc
--order by wait_time_ms desc
--order by signal_wait_time_ms desc


SELECT wt.session_id, wt.wait_type 
, er.last_wait_type AS last_wait_type 
, wt.wait_duration_ms 
, wt.blocking_session_id, wt.blocking_exec_context_id, resource_description ,
es.*
FROM sys.dm_os_waiting_tasks wt 
JOIN sys.dm_exec_sessions es ON wt.session_id = es.session_id 
JOIN sys.dm_exec_requests er ON wt.session_id = er.session_id 
WHERE es.is_user_process = 1 
AND wt.wait_type <> 'SLEEP_TASK' 
ORDER BY wt.wait_duration_ms desc



select *
from sys.dm_os_waiting_tasks
where wait_type NOT IN (
	'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE', 'SLEEP_TASK','SLEEP_SYSTEMTASK', 
	'SQLTRACE_BUFFER_FLUSH', 'WAITFOR', 'LOGMGR_QUEUE',  'CHECKPOINT_QUEUE', 'REQUEST_FOR_DEADLOCK_SEARCH', 
	'XE_TIMER_EVENT', 'BROKER_TO_FLUSH', 'BROKER_TASK_STOP', 'CLR_MANUAL_EVENT', 'CLR_AUTO_EVENT', 
	'DISPATCHER_QUEUE_SEMAPHORE', 'FT_IFTS_SCHEDULER_IDLE_WAIT', 'XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN', 
	'BROKER_EVENTHANDLER', 'TRACEWRITE', 'FT_IFTSHC_MUTEX', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
	'BROKER_RECEIVE_WAITFOR', 'ONDEMAND_TASK_QUEUE', 'DBMIRROR_EVENTS_QUEUE',
	'DBMIRRORING_CMD', 'BROKER_TRANSMITTER', 'SQLTRACE_WAIT_ENTRIES',
	'SLEEP_BPOOL_FLUSH', 'SQLTRACE_LOCK', 'DIRTY_PAGE_POLL', 'HADR_FILESTREAM_IOMGR_IOCOMPLETION',
	'SP_SERVER_DIAGNOSTICS_SLEEP')
--	and wait_type = 'RESOURCE_SEMAPHORE_QUERY_COMPILE'
and session_id > 50

select *
from sys.dm_os_spinlock_stats
where collisions > 0
--order by collisions desc
--order by spins_per_collision desc
--order by sleep_time desc
order by backoffs desc
--order by spins desc

--order by name

select top 1000 *
from sys.dm_os_workers



select * 
from sys.dm_os_performance_counters
where counter_name  like '%IO%' 
	and instance_name = 'tempdb'
select	usecounts, 
		o.name, 
		o.type, 
		t.* -- Count(p.bucketid)
from sys.dm_exec_cached_plans p
	CROSS APPLY sys.dm_exec_sql_text(plan_handle) t
	join sys.objects o on o.object_id = t.objectid 
where usecounts = 1 
	and dbid = db_id()
--order by usecounts--datalength(t.text) 

select distinct t.*, h.*
from sys.dm_exec_cached_plans p
	CROSS APPLY sys.dm_exec_sql_text(plan_handle) t
	cross apply sys.dm_exec_text_query_plan(plan_handle, default, default) h
where usecounts = 1 
	and t.dbid = db_id()

order by t.objectid
	
SELECT * FROM sys.dm_exec_query_optimizer_info;

SELECT distinct TOP 100 total_worker_time/execution_count,  /*creation_time, last_worker_time, total_worker_time,
    total_worker_time/execution_count AS [Avg Time], last_execution_time,
    execution_count, 
    qs.sql_handle,*/
    SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
    ((CASE statement_end_offset 
        WHEN -1 THEN DATALENGTH(st.text)
        ELSE qs.statement_end_offset END 
            - qs.statement_start_offset)/2) + 1) as statement_text
FROM sys.dm_exec_query_stats as qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as st
	
ORDER BY total_worker_time/execution_count DESC;
GO


SELECT session_id ,status ,blocking_session_id
    ,wait_type ,wait_time ,wait_resource 
    ,transaction_id 
FROM sys.dm_exec_requests 
WHERE status = N'suspended';
SELECT *  FROM sys.dm_tran_locks  where resource_database_id = db_id()

SELECT TOP 5 total_worker_time/execution_count AS [Avg CPU Time],
Plan_handle, query_plan 
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_text_query_plan(qs.plan_handle, 0, -1)
ORDER BY total_worker_time/execution_count DESC;
GO

select	sum(case when is_modified = 1 then 1 else 0 end) as dirty,
		sum(case when is_modified = 0 then 1 else 0 end) as clean
		
from sys.dm_os_buffer_descriptors
where database_id = db_id()


select superlatch_address, count(sublatch_address)
from sys.dm_os_sublatches
group by superlatch_address
order by 1



SELECT session_id, 
    SUM(internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
	SUM(internal_objects_alloc_page_count) * 8. / 1024 / 1024 AS task_internal_objects_alloc_page_MB,
    SUM(internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count 
FROM sys.dm_db_task_space_usage 
--where session_id = 55
GROUP BY session_id
