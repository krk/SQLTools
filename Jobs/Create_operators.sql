
EXEC msdb.dbo.sp_add_operator @name=N'MSXBackupOperator', 
		@enabled=1, 
		@weekday_pager_start_time=0, 
		@weekday_pager_end_time=0, 
		@saturday_pager_start_time=0, 
		@saturday_pager_end_time=0, 
		@sunday_pager_start_time=0, 
		@sunday_pager_end_time=0, 
		@pager_days=0, 
		@email_address=N'sql-backup-job@domain.tld', 
		@category_name=N'[Uncategorized]'

EXEC msdb.dbo.sp_add_operator @name=N'SQLJobOperator', 
		@enabled=1, 
		@weekday_pager_start_time=0, 
		@weekday_pager_end_time=0, 
		@saturday_pager_start_time=0, 
		@saturday_pager_end_time=0, 
		@sunday_pager_start_time=0, 
		@sunday_pager_end_time=0, 
		@pager_days=0, 
		@email_address=N'sql-job@domain.tld', 
		@category_name=N'[Uncategorized]'

EXEC msdb.dbo.sp_add_operator @name=N'ReplicationAlertOperator', 
		@enabled=1, 
		@weekday_pager_start_time=0, 
		@weekday_pager_end_time=0, 
		@saturday_pager_start_time=0, 
		@saturday_pager_end_time=0, 
		@sunday_pager_start_time=0, 
		@sunday_pager_end_time=0, 
		@pager_days=0, 
		@email_address=N'sql-replication-alert@domain.tld', 
		@category_name=N'[Uncategorized]'


EXEC msdb.dbo.sp_add_operator @name=N'SQLAlertOperator', 
		@enabled=1, 
		@weekday_pager_start_time=0, 
		@weekday_pager_end_time=0, 
		@saturday_pager_start_time=0, 
		@saturday_pager_end_time=0, 
		@sunday_pager_start_time=0, 
		@sunday_pager_end_time=0, 
		@pager_days=0, 
		@email_address=N'sql-alert@domain.tld', 
		@category_name=N'[Uncategorized]'

EXEC msdb.dbo.sp_add_operator @name=N'DBJobOperator', 
		@enabled=1, 
		@weekday_pager_start_time=0, 
		@weekday_pager_end_time=0, 
		@saturday_pager_start_time=0, 
		@saturday_pager_end_time=0, 
		@sunday_pager_start_time=0, 
		@sunday_pager_end_time=0, 
		@pager_days=0, 
		@email_address=N'sql-DB-job@domain.tld', 
		@category_name=N'[Uncategorized]'



