SELECT DTL.resource_type,  
   CASE   
       WHEN DTL.resource_type IN ('DATABASE', 'FILE', 'METADATA') THEN DTL.resource_type  
       WHEN DTL.resource_type = 'OBJECT' THEN OBJECT_NAME(DTL.resource_associated_entity_id)  
       WHEN DTL.resource_type IN ('KEY', 'PAGE', 'RID') THEN   
           (  
           SELECT OBJECT_NAME([object_id])  
           FROM sys.partitions  
           WHERE sys.partitions.hobt_id =   
           DTL.resource_associated_entity_id  
           )  
       ELSE 'Unidentified'  
   END AS requested_object_name, DTL.request_mode, DTL.request_status,    
   DOWT.wait_duration_ms, DOWT.wait_type, DOWT.session_id AS [blocked_session_id],  
   sp_blocked.[loginame] AS [blocked_user], DEST_blocked.[text] AS [blocked_command], 
   DOWT.blocking_session_id, sp_blocking.[loginame] AS [blocking_user],  
   DEST_blocking.[text] AS [blocking_command], DOWT.resource_description    
FROM sys.dm_tran_locks DTL  
   INNER JOIN sys.dm_os_waiting_tasks DOWT   
       ON DTL.lock_owner_address = DOWT.resource_address   
   INNER JOIN sys.sysprocesses sp_blocked  
       ON DOWT.[session_id] = sp_blocked.[spid] 
   INNER JOIN sys.sysprocesses sp_blocking  
       ON DOWT.[blocking_session_id] = sp_blocking.[spid] 
   CROSS APPLY sys.[dm_exec_sql_text](sp_blocked.[sql_handle]) AS DEST_blocked 
   CROSS APPLY sys.[dm_exec_sql_text](sp_blocking.[sql_handle]) AS DEST_blocking 
WHERE DTL.[resource_database_id] = DB_ID()

