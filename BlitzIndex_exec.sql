declare @database varchar(8000) = db_name()

exec Adm.dbo.sp_BlitzIndex 
	@database_name = @database,
	@mode = 0
	--@filter = 3
		
/*
	@database_name NVARCHAR(256) = null,
	@mode tinyint=0, 0=diagnose, 1=Summarize, 2=Index Usage Detail, 3=Missing Index Detail
	@schema_name NVARCHAR(256) = NULL, Requires table_name as well.
	@table_name NVARCHAR(256) = NULL,  Requires schema_name as well.
		--Note:@mode doesn't matter if you're specifying schema_name and @table_name.
	@filter tinyint = 0 0=no filter (default). 1=No low-usage warnings for objects with 0 reads. 2=Only warn for objects >= 500MB 
		--Note:@filter doesn't do anything unless @mode=0
*/

