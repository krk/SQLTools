select	--'drop index ' + i.name + ' on ' + t.name + char(13) + 'go'
		case when i.is_unique = 1 then null else  'alter index ' + i.name + ' on ' + t.name + ' disable ' end as DropCmd, 
		DBName = db_name(database_id),
		TableName = t.name,
		i.is_disabled,
		i.is_unique,
		i.is_unique_constraint,
		p.rows,
		i.type_desc,
		IndexName = i.name,
		i.index_id,
		i.Object_id,
		KeyColumns + isnull( '  (included ' + IncludedColumns + ')', '' ) as KeyColumns,
		u.user_seeks,
		u.user_scans,
		u.user_lookups,
		u.user_updates,
		u.last_user_seek,
		u.last_user_scan,
		u.last_user_lookup,
		u.last_user_update
		--(u.user_seeks + u.user_scans +  u.user_lookups) * 1. / u.user_updates  
from sys.dm_db_index_usage_stats u with(nolock)
		join sys.tables t with(nolock) on t.object_id = u.object_id
		left join sys.indexes i with(nolock) on i.object_id = u.object_id and i.index_id = u.index_id and i.type_desc != 'heap'
		left join sys.partitions p with(nolock) on p.object_id = t.object_id and p.index_id = i.index_id 

		outer apply ( select stuff( ( select ', ' + c.name + case ic.is_descending_key
                                                               when 1 then '(-)'
                                                               else ''
                                                             end
                                        from sys.index_columns ic with(nolock)
                                          join sys.columns c with(nolock) on  c.object_id = i.object_id
                                                             and c.column_id = ic.column_id
                                        where i.index_id = ic.index_id
                                          and i.object_id = ic.object_id
                                          and ic.is_included_column = 0
                                        order by ic.key_ordinal
                                        for xml path('')
                                    ), 1, 2, '' ) as KeyColumns ) c
        outer apply ( select stuff( ( select ', ' + c.name
                                        from sys.index_columns ic with(nolock)
                                          join sys.columns c  with(nolock) on c.object_id = i.object_id
                                                                and c.column_id = ic.column_id
                                        where i.index_id = ic.index_id
                                          and i.object_id = ic.object_id
                                          and ic.is_included_column = 1
                                        for xml path('')
                                    ), 1, 2, '' ) as IncludedColumns ) ic

where database_id = db_id()
	and i.is_unique = 0
	and i.is_unique_constraint = 0
	--and t.name = 'tb_CT_Link_S'
	and u.user_scans = 0
	and u.user_seeks = 0
	and u.user_lookups = 0
	and i.is_disabled = 0
	--and p.rows > 100
	and i.type_desc = 'NONCLUSTERED'
	--and u.user_seeks > u.user_updates
	--and u.user_seeks + u.user_scans +  u.user_lookups < u.user_updates
	--and  u.user_updates > 0
	--and u.last_user_seek < getdate() - 30
--order by u.user_seeks desc
--order by u.user_updates desc
--order by KeyColumns
order by p.rows 
--order by (u.user_seeks + u.user_scans +  u.user_lookups) * 1. / u.user_updates  desc
--order by TableName, IndexName

