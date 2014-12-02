use  Adm

if object_id('dbo.RestoreFull') is null exec ('create procedure dbo.RestoreFull as begin return end')
go
alter procedure dbo.RestoreFull
	@Path varchar(8000),
	@Database varchar(8000),
	@mdfPath varchar(8000),
	@mdfName varchar(8000),
	@ldfPath varchar(8000),
	@ldfName varchar(8000),
	@FileNum int = 1
as begin
	
	restore database @Database
	from disk = @Path
	with file = @FileNum,
			move @mdfName to @mdfPath,
			move @ldfName to @ldfPath,
			norecovery,
			checksum

end
go