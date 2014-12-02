use  Adm

if object_id('dbo.RestoreWithRecovery') is null exec ('create procedure dbo.RestoreWithRecovery as begin return end')
go
alter procedure dbo.RestoreWithRecovery
	@Database varchar(8000)
	
as begin
	restore database @Database with recovery
end
go