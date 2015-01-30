DECLARE @BackupDirectory NVARCHAR(100)   
EXEC master..xp_instance_regread @rootkey = 'HKEY_LOCAL_MACHINE',  
    @key = 'Software\Microsoft\MSSQLServer\MSSQLServer',  
    @value_name = 'BackupDirectory', @BackupDirectory = @BackupDirectory OUTPUT ;  

SELECT @BackupDirectory AS [SQL Server default backup Value]