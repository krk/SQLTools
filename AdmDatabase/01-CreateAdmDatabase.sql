create database Adm
on Primary (
	Name = 'Adm',
	FileName = 'F:\Data\Adm.mdf',
	Size = 100mb,
	MaxSize = unlimited,
	FileGrowth = 512mb
)
Log on (
	Name = 'Adm_log',
	FileName = 'E:\Log\Adm_log.ldf',
	Size = 100mb,
	MaxSize = unlimited,
	FileGrowth = 512mb
)
go
alter database adm set recovery simple;
go
