USE [fwsdb_nfwfl_dev]
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_Scientific_Name]    Script Date: 5/26/2020 1:33:58 AM ******/
DROP PROCEDURE [dbo].[SP_Update_Scientific_Name]
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_Scientific_Name]    Script Date: 5/26/2020 1:34:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexandra Cannon
-- Created date: 5/10/2020
-- Description:	Update scientific name (update Organism table)
-- =============================================
CREATE PROCEDURE [dbo].[SP_Update_Scientific_Name] 
	-- Add the parameters for the stored procedure here
	@l_org_id INT = -1,
	@json VARCHAR(MAX) = ''
AS
BEGIN
	-- @TODO: Error handling: @l_org_id INT = -1 or @json = '' then error

	-- Create temp table to hold part of json that is specimen-specific
	DECLARE @temp AS TABLE (
		[Class] [varchar](50),
		[Subclass] [varchar](50),
		[Order] [varchar](50),
		[Suborder] [varchar](50),
		[Family] [varchar](50) ,
		[Subfamily] [varchar](50) ,
		[Genus] [varchar](50) ,
		[Subgenus] [varchar](50) ,
		[Species] [varchar](50) ,
		[Subspecies] [varchar](50) ,
		[Variety] [varchar](50) ,
		[Common_Name] [varchar](50) ,
		[Previous_Designation] [varchar](200) 
	);

	-- put json into temp
	INSERT INTO @temp
	SELECT *
	FROM OPENJSON(@json)
	WITH (
		[Class] [varchar](50),
		[Subclass] [varchar](50),
		[Order] [varchar](50),
		[Suborder] [varchar](50),
		[Family] [varchar](50) ,
		[Subfamily] [varchar](50) ,
		[Genus] [varchar](50) ,
		[Subgenus] [varchar](50) ,
		[Species] [varchar](50) ,
		[Subspecies] [varchar](50) ,
		[Variety] [varchar](50) ,
		[Common_Name] [varchar](50) ,
		[Previous_Designation] [varchar](200) 
	)

	TRUNCATE TABLE staging.Herpetology_Specimen;
		
	-- Put temp (now has update Organism ID) into staging.Herpetology_Specimen
	INSERT INTO staging.Organism (
			[Class] ,
			[Subclass],
			[Order] ,
			[Suborder],
			[Family],
			[Subfamily],
			[Genus] ,
			[Subgenus],
			[Species] ,
			[Subspecies],
			[Variety],
			[Common_Name],
			[Previous_Designation]
	)
	SELECT	[Class] ,
			[Subclass],
			[Order] ,
			[Suborder],
			[Family],
			[Subfamily],
			[Genus] ,
			[Subgenus],
			[Species] ,
			[Subspecies],
			[Variety],
			[Common_Name],
			[Previous_Designation]
	FROM @temp


    -- Insert statements for procedure here
	SELECT * FROM dbo.Organism WHERE Organism_ID = @l_org_id;
END
GO
