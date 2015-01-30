exec Adm.dbo.sp_Blitz
    @CheckUserDatabaseObjects  = 0 ,
    @CheckProcedureCache  = 1,
    @OutputType = 'TABLE',
    @OutputProcedureCache  = 0 ,	
    @CheckProcedureCacheFilter =  'READS',		
    @CheckServerInfo  = 0,
    @SkipChecksServer  = NULL ,
    @SkipChecksDatabase  = NULL ,
    @SkipChecksSchema  = NULL ,	
    @SkipChecksTable  = NULL ,
    @IgnorePrioritiesAbove  = NULL ,
    @OutputDatabaseName = NULL ,
    @IgnorePrioritiesBelow  = NULL ,
    @OutputSchemaName  = NULL ,
    @OutputTableName  = NULL 

		