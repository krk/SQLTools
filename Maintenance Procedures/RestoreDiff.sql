use  Adm

if object_id('dbo.RestoreDiff') is null exec ('create procedure dbo.RestoreDiff as begin return end')
go
alter procedure dbo.RestoreDiff
	@Path varchar(8000),
	@Database varchar(8000),
	@FileNum int = 1
as begin
	
	restore database @Database
	from disk = @Path
	with file = @FileNum,
			norecovery,
			checksum

end
go
