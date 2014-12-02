SELECT TOP 50
 SUBSTRING(eqt.TEXT,(
	 eqs.statement_start_offset/2) +1
,((CASE eqs.statement_end_offset
  WHEN -1 THEN DATALENGTH(eqt.TEXT)
  ELSE  eqs.statement_end_offset
  END - eqs.statement_start_offset)/2)+1)
,eqs.execution_count
,eqs.total_logical_reads
,eqs.last_logical_reads
,eqs.total_logical_writes
,eqs.last_logical_writes
,eqs.total_worker_time
,eqs.last_worker_time
,eqs.total_elapsed_time/1000000		AS Total_elapsed_time_Secs
,eqs.last_elapsed_time/1000000		AS Last_elapsed_time_Secs
,eqs.last_execution_time
,eqp.query_plan
FROM        sys.dm_exec_query_stats eqs
CROSS APPLY sys.dm_exec_sql_text(eqs.sql_handle) eqt
CROSS APPLY sys.dm_exec_query_plan(eqs.plan_handle) eqp
ORDER BY eqs.total_worker_time DESC