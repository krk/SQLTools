exec adm.dbo.CreateBackup 
	@Type = 'FULL',
	@db_list = 'db1|db2',	
	@PathToShare = 'X:\Backup\temp'
