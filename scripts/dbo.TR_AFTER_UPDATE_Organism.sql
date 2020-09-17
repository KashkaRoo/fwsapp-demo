CREATE TRIGGER dbo.TR_AFTER_UPDATE_Organism  
ON dbo.Organism  
AFTER UPDATE   
AS   
	INSERT INTO dbo.Organism_History (
		Previous_Class ,
		Previous_Subclass ,
		Previous_Order ,
		Previous_Suborder ,
		Previous_Family ,
		Previous_Subfamily ,
		Previous_Genus ,
		Previous_Subgenus ,
		Previous_Species ,
		Previous_Subspecies ,
		Previous_Variety ,
		Previous_Common_Name ,
		Previous_Previous_Designation ,
		New_Class ,
		New_Subclass ,
		New_Order ,
		New_Suborder ,
		New_Family ,
		New_Subfamily ,
		New_Genus ,
		New_Subgenus ,
		New_Species ,
		New_Subspecies ,
		New_Variety ,
		New_Common_Name ,
		New_Previous_Designation
	)
	SELECT
		deleted.Class,
		deleted.Subclass,
		deleted.[Order],
		deleted.Suborder,
		deleted.Family,
		deleted.Subfamily,
		deleted.Genus,
		deleted.Subgenus,
		deleted.Species,
		deleted.Subspecies,
		deleted.Variety,
		deleted.Common_Name,
		deleted.Previous_Designation,
		inserted.Class,
		inserted.Subclass,
		inserted.[Order],
		inserted.Suborder,
		inserted.Family,
		inserted.Subfamily,
		inserted.Genus,
		inserted.Subgenus,
		inserted.Species,
		inserted.Subspecies,
		inserted.Variety,
		inserted.Common_Name,
		inserted.Previous_Designation
	FROM deleted, inserted

GO  