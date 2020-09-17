DELETE FROM Organism
DBCC CHECKIDENT ('Lab_Reference_Data.dbo.Organism',RESEED, 0)