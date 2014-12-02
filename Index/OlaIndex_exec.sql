
exec adm.dbo.IndexOptimize
	@Databases = 'USER_DATABASES',
	@FragmentationLow = NULL,
	@FragmentationMedium = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE', --INDEX_REORGANIZE,
	@FragmentationHigh = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
	@FragmentationLevel1 = 10,
	@FragmentationLevel2 = 20,
	@PadIndex = 'Y',
	@FillFactor = 95,
	@SortInTempdb = 'Y',
	@LogToTable  = 'Y',
	@LockTimeout = 15,
	@Delay = 3,
	@Execute = 'Y'




exec adm.dbo.IndexOptimize
		@Databases = 'USER_DATABASES',
		@FragmentationLow = NULL,
		@FragmentationMedium = NULL,
		@FragmentationHigh = NULL,
		@UpdateStatistics = 'ALL',
		@OnlyModifiedStatistics = 'Y'



