exec adm.dbo.DatabaseIntegrityCheck
	@Databases = 'ALL_DATABASES',
	@CheckCommands = 'CHECKDB',
	@ExtendedLogicalChecks = 'Y',
	@LogToTable = 'Y',
	@Execute = 'Y'