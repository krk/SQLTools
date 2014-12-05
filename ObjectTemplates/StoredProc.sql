set ansi_nulls on
set quoted_identifier on
go

if object_id('dbo.') is null exec ('create procedure dbo. as begin return end')
go
alter procedure dbo.
as begin
	set nocount on


end
go

