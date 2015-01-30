--Disable
ALTER TABLE dbo.Table1 NOCHECK  CONSTRAINT FK_Table1_Customer__OwnerId

--Enable (Yep, CHECK CHECK)
ALTER TABLE dbo.Table1 WITH CHECK CHECK CONSTRAINT FK_Table1_Customer__OwnerId

