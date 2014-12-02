use  Adm

if object_id('dbo.DBCCCheckDB') is null exec ('create procedure dbo.DBCCCheckDB as begin return end')
go
alter procedure dbo.DBCCCheckDB
	@Database varchar(8000)
	
as begin
	dbcc traceon (	2562, -- single batch for DBCC
					2549  -- builds an internal list of pages to read per unique disk drive across all database files
				);

	DBCC CHECKDB(@Database ) 
		WITH	NO_INFOMSGS, 
				EXTENDED_LOGICAL_CHECKS, 
				DATA_PURITY, 
				ALL_ERRORMSGS;
end
go