--who use database
select *
from sys.sysprocesses
where db_name(dbid) = 'dbname'