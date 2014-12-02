use  Adm

if object_id('dbo.RestoryVerifyOnly') is null exec ('create procedure dbo.RestoryVerifyOnly as begin return end')
go
alter procedure dbo.RestoryVerifyOnly
	@FileName varchar(8000),
	@FileNum int = 1
as begin
	restore verifyonly 
	from disk = @FileName
	with file = @FileNum,
			checksum
end
go