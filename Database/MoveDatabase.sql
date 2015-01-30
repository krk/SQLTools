alter database DB
modify file (
	Name = 'DB_Data',
	filename = 'X:\DB\DB.mdf'
)

alter database DB
modify file (
	Name = 'DB_log',
	filename = 'X:\DB\DB_log.ldf'
)

alter database DB set offline with rollback immediate
--Move files to other location
alter database DB set online