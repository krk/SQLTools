SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
go

create function dbo.fn_tbl_IDListToTable(
	@List varchar(8000),
	@Spliter char(1) =','
) returns @T table(ID int) 
as begin

	set @list = replace (@list, ' ', '')

	declare @ID varchar(8000),
			@pos int

	while len(@list) > 0 begin

		set @pos = charindex(@Spliter, @list)

		if charindex(@Spliter, @list) < 1
			set @ID = @list
		else
			set @ID = left(@list, case when @pos < 1 then 0 else @pos - 1 end)

		if isnumeric(@ID) = 1 insert @T (ID) values (@ID)

		if charindex(@Spliter, @list) < 1
			set @list = ''
		else 
			set @list = right(@list,len(@list) - case when @pos = -1 then 0 else @pos end)
	
	end

	return 
end

