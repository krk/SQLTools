create database Adm
on Primary (
	Name = 'Adm',
	FileName = 'D:\SQLData\Adm.mdf',
	Size = 100mb,
	MaxSize = unlimited,
	FileGrowth = 512mb
)
Log on (
	Name = 'Adm_log',
	FileName = 'L:\SQLLog\Adm_log.ldf',
	Size = 100mb,
	MaxSize = unlimited,
	FileGrowth = 512mb
)

