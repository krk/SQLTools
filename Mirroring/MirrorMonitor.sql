/*
 * DB Mirroring : followup
 *
*/
/* show mirrored databases and their mirror-state */
Select db_name(database_id) as dbName
, * 
from sys.database_mirroring
Where mirroring_guid is not null  -- show only mirrored databases

order by dbName;


/* the "simple" proc */
exec msdb..sp_dbmmonitorresults 'DMKoudwals'

SELECT  principal_server_name
      , mirror_server_name
      , database_name
      , safety_level_desc
FROM    sys.database_mirroring_witnesses

/*
 * to be run at the WITNESS
*/

Select * 
from sys.database_mirroring_witnesses
order by database_name, principal_server_name;


/*
 * Make mirror the principal
*/

-- Alter database [TheDb] set partner failover;

/*
 * Make mirror the principal with potential dataloss (if unsynced !)
*/
-- Alter database [TheDb] set partner FORCE_SERVICE_ALLOW_DATA_LOSS;
-- db will be in state (Principal, Suspended) !!
-- You need to reactivate mirroring !! using: ALTER DATABASE [TheDb] SET PARTNER RESUME;



/*
 * Suspendig / resuming
 */
-- at the CURRENT Principal server 
-- ALTER DATABASE [TheDb] SET PARTNER SUSPEND;

-- ALTER DATABASE [TheDb] SET PARTNER RESUME;


/*
 * Ending DbMirroring
 */
-- at the CURRENT Principal server 
-- ALTER DATABASE [TheDb] SET PARTNER OFF;


-- at the CURRENT Mirror server the db stays in "recovering" mode.
-- If you want to activate it, you can:

-- Restore database [TheDb] with recovery:


/*
 * follow up queues 
*/

-- SELECT @namespace = N'\\.\root\Microsoft\SqlServer\ServerEvents\' + cast(serverproperty('instanceName') as sysname);

/* endpoint overview */

select e.*
	, t.*
FROM   sys.database_mirroring_endpoints e 
INNER JOIN sys.tcp_endpoints t
	ON     e.endpoint_id = t.endpoint_id 
order by e.name;


/* DBM connections */
select *
from sys.dm_db_mirroring_connections 

select *
from sys.event_notifications


select *
from sys.dm_os_wait_stats 
where wait_type like '%MIRROR%'
order by wait_type

-- did someone configure tresholds
SELECT [database_id]
	  , db_name(database_id) as DbName
      ,[retention_period]
      ,[time_behind]
      ,[enable_time_behind]
      ,[send_queue]
      ,[enable_send_queue]
      ,[redo_queue]
      ,[enable_redo_queue]
      ,[average_delay]
      ,[enable_average_delay]
  FROM [msdb].[dbo].[dbm_monitor_alerts]
  order by [database_id]
  
SELECT  top 1000 
		[database_id], db_name(database_id) as DbName
      ,[role]
      ,[status]
      ,[witness_status]
      ,[log_flush_rate]
      ,[send_queue_size]
      ,[send_rate]
      ,[redo_queue_size]
      ,[redo_rate]
      ,[transaction_delay]
      ,[transactions_per_sec]
      ,[time]
      ,[end_of_log_lsn]
      ,[failover_lsn]
      ,[local_time]
  FROM [msdb].[dbo].[dbm_monitor_data]
  order by [database_id], [local_time] desc
  
/*
kan ook opgevraagd worden via http://msdn.microsoft.com/en-us/library/ms366320%28SQL.90%29.aspx
exec msdb.dbo.sp_dbmmonitorresults 
	  'DMKoudwals' 
      , 9  -- rows_to_return
      , 0 --update_status 

database_name
    Specifies the database for which to return mirroring status.

rows_to_return
    Specifies the quantity of rows returned:
    0 = Last row
    1 = Rows last two hours
    2 = Rows last four hours
    3 = Rows last eight hours
    4 = Rows last day
    5 = Rows last two days
    6 = Last 100 rows
    7 = Last 500 rows
    8 = Last 1,000 rows
    9 = Last 1,000,000 rows

update_status
    Specifies that before returning results the procedure:
    0 = Does not update the status for the database. The results are computed using just the last two rows, the age of which depends on when the status table was refreshed.
    1 = Updates the status for the database by calling sp_dbmmonitorupdate before computing the results. However, if the status table has been updated within the previous 15 seconds, or the user is not a member of the sysadmin fixed server role, sp_dbmmonitorresults runs without updating the status.

*/



  

select  *
from    sys.dm_os_performance_counters
Where object_name = 'SQLServer:Database Mirroring'
-- and instance_name = 'DMKoudwals'
order by case when instance_name like '[_]%' then 999 else 0 end , instance_name, counter_name ;

  
/*
select *
from sys.messages
where text like '%mirror%'
  and language_id = 1033
order by message_id
*/

/* Monitor db state changes using WMI alerts */

--USE [msdb]
--GO
---EXEC msdb.dbo.sp_add_operator @name=N'DBA', 
--		@enabled=1, 
--		@pager_days=0, 
--		@email_address=N'Wachtdienst.DBA@arcelormittal.com'
--GO
/*
Below is a list of the different state changes that can be monitored. 
Additional information can be found here Database Mirroring State Change Event Class.

0 = Null Notification 
1 = Synchronized Principal with Witness 
2 = Synchronized Principal without Witness 
3 = Synchronized Mirror with Witness 
4 = Synchronized Mirror without Witness 
5 = Connection with Principal Lost 
6 = Connection with Mirror Lost 
7 = Manual Failover 
8 = Automatic Failover 
9 = Mirroring Suspended 
10 = No Quorum 
11 = Synchronizing Mirror 
12 = Principal Running Exposed

*/
---EXEC msdb.dbo.sp_add_alert @name=N'DB_Mirroring_Check_WMI', 
--		@enabled=1, 
--		@delay_between_responses=0, 
--		@include_event_description_in=1, 
--		@notification_message=N'DB_Mirroring_Check_WMI alert !', 
--		@wmi_namespace=N'\\.\root\Microsoft\SqlServer\ServerEvents\SQL2005DE', 
--		@wmi_query=N'SELECT * FROM DATABASE_MIRRORING_STATE_CHANGE WHERE State = 7 OR State = 8 OR Stare = 10 '
--GO
---EXEC msdb.dbo.sp_add_notification @alert_name=N'DB_Mirroring_Check_WMI', @operator_name=N'DBA', @notification_method = 1
--GO

/* you may want to link this alert to a job to perform additional check / failover preparation / ... */


/*


If there are potential issues with network load or some other reason that may be causing 
a delay in communicating with all three servers one solution is to change 
the PARTNER TIMEOUT.  
By  default this value is set to 10 seconds, so if a "ping" is not received 
in this 10 second period a failover may occur.

To make this change to a longer value, such as 20 seconds, 
the following command would be issued on the Principal server for the database 
that is mirrored.



ALTER DATABASE dbName SET PARTNER TIMEOUT 20 



Be careful on the value that use for this option.  
If this value is set to high and a failure really does occur, the automatic failover
 will take longer based on the value you set.

In addition, the lowest this value can be set to is 5 seconds based 
on information found in SQL Server Books Online.

*/



-- http://msdn.microsoft.com/en-us/library/ms403828%28SQL.90%29.aspx
-- Returns the current update period. (in minutes)
EXEC msdb.dbo.sp_dbmmonitorhelpmonitoring;


/* TOOLS for dbmirroring


-- FREQUENCY of monitoring http://msdn.microsoft.com/en-us/library/ms365375%28SQL.90%29.aspx
Alter monitoring frequency period the range of 1 to 120 that specifies a new update period in minutes. 
	
The following example changes the update period to 5 minutes.
-- EXEC sp_dbmmonitorchangemonitoring 1, 5 ;


-- DROP monitoring http://msdn.microsoft.com/en-us/library/ms365810%28SQL.90%29.aspx
The following example drops database mirroring monitoring on all of the mirrored databases on the server instance.
-- EXEC sp_dbmmonitordropmonitoring ;

-- CREATE monitor job http://msdn.microsoft.com/en-us/library/ms403582%28SQL.90%29.aspx
Creates a database mirroring monitor job that periodically updates the mirroring status for every mirrored database on the server instance.

-- exec msdb.dbo.sp_dbmmonitoraddmonitoring [ update_period ] -- in minutes, default = 1



-- update monitor data http://msdn.microsoft.com/en-us/library/ms403827%28SQL.90%29.aspx

Updates the database mirroring monitor status table by inserting a new table row for each mirrored database, 
and truncates rows older than the current retention period. 
The default retention period is 7 days (168 hours). 
When updating the table, sp_dbmmonitorupdate evaluates the performance metrics.

-- exec msdb.dbo.sp_dbmmonitorupdate [ database_name ]



-- Monitoring Mirroring Status http://msdn.microsoft.com/en-us/library/ms365781%28SQL.90%29.aspx


*/


/*

To cleanup monitor data manually you can use this ... (snipped from sp_dbmmonitorupdate)

declare @oldest_date datetime
declare @database_id int

Select @database_id = db_id('DMKoudwals') 
	, @oldest_date = dateadd(dd, -7, dateadd(dd, datediff(dd,0,getutcdate()),0)) 

Select db_name(@database_id) as DbName
	, @oldest_date as oldest_date
		
select  *
from    msdb.dbo.dbm_monitor_data
where   time < @oldest_date
        and database_id = @database_id

--		delete from msdb.dbo.dbm_monitor_data where time < @oldest_date and database_id = @database_id

*/