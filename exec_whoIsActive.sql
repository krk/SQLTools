select top 100 *
from sys.dm_exec_query_memory_grants mg
	outer apply sys.dm_exec_query_plan(mg.plan_handle) p	
	outer apply sys.dm_exec_sql_text(mg.sql_handle) t 
where session_id != @@SPID	
order by requested_memory_kb desc

select --'kill ' + convert(varchar(10), session_id),
		*,
		case when charindex(':', resource_description) > 0 then  db_name(left(resource_description, charindex(':', resource_description) - 1)) else null end as DatabaseName
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
	'SP_SERVER_DIAGNOSTICS_SLEEP', 'CXPACKET')
--	and wait_type = 'RESOURCE_SEMAPHORE_QUERY_COMPILE'
and session_id > 50		 

exec adm.dbo.sp_WhoIsActive 
--@help = 1	
	--@filter  = '63',
	--@filter_type  = 'session',
	@get_full_inner_text = 0,
	@get_outer_command = 1,
	@show_own_spid = 1,
	@show_system_spids = 0,
	@show_sleeping_spids = 0,		
	@get_plans = 2,
	@get_locks = 1,
	@get_transaction_info = 1,	
	@get_task_info = 2,
	@find_block_leaders = 1,
	@get_additional_info = 1,
	@delta_interval = 0
