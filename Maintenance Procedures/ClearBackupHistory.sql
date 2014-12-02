declare @dateFrom datetime = convert(datetime, convert(int, getdate() - 90))
exec msdb.dbo.sp_delete_backuphistory @oldest_date = @dateFrom	