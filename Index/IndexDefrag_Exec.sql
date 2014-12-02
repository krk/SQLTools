exec adm.dbo.IndexOptimize
@Databases = 'DB',
@FragmentationLow  = NULL,
@FragmentationMedium  = null,--'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',--'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationHigh  = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationLevel1  = 5, --5
@FragmentationLevel2  = 30, --30
@PageCountLevel  = 1000,
@Sortintempdb  = 'Y',
@MaxDOP  = NULL,
@FillFactor  = 95,
@PadIndex  = 'Y',
@LOBCompaction  = 'Y',
@UpdateStatistics  = NULL, 
@OnlyModifiedStatistics  = 'N',
@StatisticsSample  = NULL,
@StatisticsResample  = 'N',
@PartitionLevel  = 'N',
@MSShippedObjects  = 'N',
@Indexes  = NULL,
@TimeLimit  = NULL,
@Delay  = NULL,
@LockTimeout  = NULL,
@LogToTable  = 'Y',
@Execute  = 'N'


