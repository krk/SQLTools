declare @dbname sysname = db_name()
exec Adm.dbo.sp_BlitzIndex 
	@databasename = @dbname, 
	@mode = 0, 
	@schemaname = 'dbo', 
	@tablename = 'Lot'