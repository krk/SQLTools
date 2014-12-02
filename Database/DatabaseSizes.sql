select	F.database_id,
		d.name as DBName,
		F.Name as FileName,
		F.physical_name,
		F.type_desc,
		convert(decimal(12,2), round(F.size * 8. / 1024 / 1024 , 2)) as [FileSize (Gb)],
		d.recovery_model_desc,
		f.growth * 8. / 1024 as FileGrowthMB,
		f.max_size * 8. / 1024 MaxSizeMB,
		f.is_percent_growth,
		d.log_reuse_wait_desc,
		'use ' + d.name+ '; dbcc shrinkfile(' + F.Name + ', TRUNCATEONLY)'
from sys.master_files f
	join sys.databases d on d.database_id = f.database_id
where f.database_id = 7--not in (1,3,4)	
order by d.name, f.type_desc desc
-- order by f.name



select	case when grouping(db_name(f.database_id)) = 0 then db_name(f.database_id) else 'z >> Total' end  as dbName,
		case when db_name(f.database_id) = 'tempdb' then 'tempdb' else 'user_data' end as DBType,
		case when grouping(f.type_desc) = 0 then f.type_desc else 'z >> Total' end as FileType,
		convert(decimal(12,2), round(sum(F.size) * 8. / 1024 / 1024, 2)) as [F	ileSize (Gb)]
from sys.master_files f
	join sys.databases d on d.database_id = f.database_id 
where f.database_id > 4-- not in (1,3,4)
	and db_name(f.database_id)  not like '%OLAP%'
	and db_name(f.database_id)  not like 'ReportServer%'
	-- and d.recovery_model_desc = 'SIMPLE'
group by db_name(f.database_id),
		f.type_desc
with rollup
having (grouping (db_name(f.database_id)) = 0 
	or (
			grouping (db_name(f.database_id)) =1 and 
			grouping (f.type_desc) = 1
		))
	and case when grouping(f.type_desc) = 0 then f.type_desc else 'z >> Total' end = 'z >> Total'
order by 1, 2


select	case when grouping(f.type_desc) = 0 then f.type_desc else 'z >> Total' end,
		convert(decimal(12,2), round(sum(F.size) * 8. / 1024 / 1024, 2)) as [FileSize (Gb)]
from sys.master_files f
where f.database_id > 4
	and db_name(f.database_id) not like '%OLAP%'
group by f.type_desc 
--with rollup
order by 1,2


select	database_id,
		@@servername,
		Name,
		d.recovery_model_desc,
		d.is_auto_shrink_on,
		d.is_auto_create_stats_on,
		d.is_auto_update_stats_on,
		d.is_auto_update_stats_async_on
		
from sys.databases d
where database_id > 4
	and Name not like 'ReportServer%'
	and Name not like 'Adm'
	and d.state_desc != 'OFFLINE'
	and recovery_model_desc = 'FULL'
	and d.is_auto_update_stats_async_on = 1
order by name





