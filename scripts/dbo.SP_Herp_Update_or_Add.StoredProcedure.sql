USE [fwsdb_nfwfl_dev]
GO
/****** Object:  StoredProcedure [dbo].[SP_Herp_Update_or_Add]    Script Date: 5/26/2020 1:33:58 AM ******/
DROP PROCEDURE [dbo].[SP_Herp_Update_or_Add]
GO
/****** Object:  StoredProcedure [dbo].[SP_Herp_Update_or_Add]    Script Date: 5/26/2020 1:34:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexandra Cannon
-- Created date: 4/21/2020
-- Description:	Herpetology dataset: Update record if exists, else add new record
--				Includes logic for Organism record search vs. insert new
--				@TODO: Add similar logic for location
--				@TODO: Add similar logic for locality
-- =============================================
CREATE PROCEDURE [dbo].[SP_Herp_Update_or_Add] 
	-- Add the parameters for the stored procedure here
	@json varchar(MAX) = ''
AS
BEGIN
	 --@TODO: Error handling: json == '' then error

	-- Create temp table to hold part of json that is specimen-specific
	DECLARE @temp AS TABLE (
		[Specimen_ID] [varchar](20) ,
		[Organism_ID] [varchar](20) ,
		[Specimen_Sex] [varchar](20) ,
		[Specimen_Age] [varchar](50) ,
		[NFWFL_Num] [varchar](20) ,
		[REP_Num] [varchar](20) ,
		[Deaccessioned_To] [varchar](100) ,
		[Deaccessioned_Reason] [varchar](100) ,
		[Material] [varchar](100) ,
		[Prep_By] [varchar](100) ,
		[Location_ID] [varchar](20),
		[Specimen_Owner] [varchar](50),
		[Accession_Num] [varchar](20) ,
		[Locality_ID] [varchar](20),
		[ESA] [varchar](50) ,
		[CITES] [varchar](50) ,
		[Document_Reference] [varchar](300),
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
		[Specimen_ID] [varchar](20) ,
		[Organism_ID] [varchar](20) ,
		[Specimen_Sex] [varchar](20) ,
		[Specimen_Age] [varchar](50) ,
		[NFWFL_Num] [varchar](20) ,
		[REP_Num] [varchar](20) ,
		[Deaccessioned_To] [varchar](100) ,
		[Deaccessioned_Reason] [varchar](100) ,
		[Material] [varchar](100) ,
		[Prep_By] [varchar](100) ,
		[Location_ID] [varchar](20),
		[Specimen_Owner] [varchar](50),
		[Accession_Num] [varchar](20) ,
		[Locality_ID] [varchar](20),
		[ESA] [varchar](50) ,
		[CITES] [varchar](50) ,
		[Document_Reference] [varchar](300),
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

	-- FOR EACH record in temp
		-- GET EITHER: an existing matching Organism record OR insert a new one
		-- OVERWRITE temp.Organism_ID with above 
	BEGIN TRAN FIND_AND_UPDATE_ORG_ID
		TRUNCATE TABLE staging.Organism;

		-- declare local variables for cursor
		DECLARE @curr_spec	[varchar](20),
				@class		[varchar](50),
				@subclass	[varchar](50),
				@order		[varchar](50),
				@suborder	[varchar](50),
				@family		[varchar](50) ,
				@subfamily	[varchar](50) ,
				@genus		[varchar](50) ,
				@subgenus	[varchar](50) ,
				@species	[varchar](50) ,
				@subspecies [varchar](50) ,
				@variety	[varchar](50) ,
				@common		[varchar](50) ,
				@prev		[varchar](200);

		-- declare a small table to select Org_ID into
		DECLARE @temp_TABLE_org_id TABLE(Organism_ID VARCHAR(20) NULL);

		DECLARE @l_insert_cnt INT;
		SET @l_insert_cnt = 0;

		-- declare a cursor to iterate over temp table - necessary for bulk add or accidental parallelism (?)
		DECLARE cr_update_org_id CURSOR FOR
			SELECT Specimen_ID, Class, Subclass, [Order], Suborder, Family, Subfamily, Genus, Subgenus, Species, Subspecies, Variety, Common_Name, Previous_Designation 
			FROM @temp;
		
		OPEN cr_update_org_id;

		-- get first record from temp
		-- need to grab Specimen_ID so we know which record to update in @temp
		-- @TODO: if two people edit same specimen, so both edits end up in staging, how would this be affected?
		FETCH NEXT FROM cr_update_org_id
		INTO @curr_spec, @class, @subclass, @order, @suborder, @family, @subfamily, @genus, @subgenus, @species, @subspecies, @variety, @common, @prev;

		-- while fetch is successful
		WHILE @@FETCH_STATUS = 0
			BEGIN
				-- if all record matches one in Organism, use that ID for temp.Organism_ID
				-- otherwise, insert record and use that ID for temp.Organism_ID
				INSERT INTO @temp_TABLE_org_id(Organism_ID)
					SELECT Organism_ID
					FROM dbo.Organism
					WHERE ((Class = @class)	OR (Class IS NULL AND @class IS NULL))	-- fields match or both are NULL
					AND ((Subclass = @subclass)			OR (Subclass IS NULL AND				@subclass IS NULL))
					AND (([Order] = @order)				OR ([Order] IS NULL AND					@order IS NULL))
					AND ((Suborder = @suborder)			OR (Suborder IS NULL AND				@suborder IS NULL))
					AND ((Family = @family)				OR (Family IS NULL AND					@family IS NULL))
					AND ((Subfamily = @subfamily)		OR (Subfamily IS NULL AND				@subfamily IS NULL))
					AND ((Genus = @genus)				OR (Genus IS NULL AND					@genus IS NULL))
					AND ((Subgenus = @subgenus)			OR (Subgenus IS NULL AND				@subgenus IS NULL))
					AND ((Species = @species)			OR (Species IS NULL AND					@species IS NULL))
					AND ((Subspecies = @subspecies)		OR (Subspecies IS NULL AND				@subspecies IS NULL))
					AND ((Variety = @variety)			OR (Variety IS NULL AND					@variety IS NULL))
					AND ((Common_Name = @common)		OR (Common_Name IS NULL AND				@common IS NULL))
					AND ((Previous_Designation = @prev) OR (Previous_Designation IS NULL AND	@prev IS NULL))

					-- IF NO RECORD FOUND from select statement above, insert new Organism record
					IF (SELECT Organism_ID FROM @temp_TABLE_org_id) IS NULL	
						BEGIN
							INSERT INTO dbo.Organism (Class, Subclass, [Order], Suborder, Family, Subfamily, Genus, Subgenus, 
										Species, Subspecies, Variety, Common_Name, Previous_Designation)
										OUTPUT inserted.Organism_ID INTO @temp_TABLE_org_id	-- save the Organism_ID to update temp record later
							VALUES (
								-- (SELECT (MAX(Organism_ID) + 1 + @l_insert_cnt) FROM dbo.Organism),	
								@class, @subclass, @order, @suborder, @family, @subfamily, @genus, @subgenus, @species, @subspecies, @variety, @common, @prev);
							
							INSERT INTO @temp_TABLE_org_id
							SELECT (MAX(Organism_ID)) FROM dbo.Organism; -- @TODO: this won't work if something gets inserted in between this and insertion into dbo
						END
					-- ELSE we already have the necessary Organism_ID in temp_TABLE_org_id

					-- update the record we're currently looking at in temp with the identified Organism_ID (either found or inserted)
					UPDATE @temp 
					SET Organism_ID = (SELECT TOP(1) Organism_ID FROM @temp_TABLE_org_id)	-- @TODO: 'should' work; select stmt above should return 0 or 1 record
					WHERE Specimen_ID = @curr_spec;

				-- account for records in staging when creating new Organism ID
				SET @l_insert_cnt = @l_insert_cnt + 1;

				-- get next record from cursor
				-- if fails, FETCH_STATUS != 0 and while loop will exit
				FETCH NEXT FROM cr_update_org_id
				INTO @curr_spec, @class, @subclass, @order, @suborder, @family, @subfamily, @genus, @subgenus, @species, @subspecies, @variety, @common, @prev
			END

		CLOSE cr_update_org_id

	COMMIT TRAN FIND_AND_UPDATE_ORG_ID;

	-- Now that we have the connected Organism_ID in @temp, can start working with the Specimen record
	BEGIN TRAN SPECIMEN_TO_STAGING
		-- clear staging tables
		-- TRUNCATE TABLE staging.Organism;
		TRUNCATE TABLE staging.Herpetology_Specimen;
		
		-- Put temp (now has update Organism ID) into staging.Herpetology_Specimen
		INSERT INTO staging.Herpetology_Specimen (
			[Specimen_ID]  ,
			[Organism_ID]  ,
			[Specimen_Sex]  ,
			[Specimen_Age]  ,
			[NFWFL_Num]  ,
			[REP_Num]  ,
			[Deaccessioned_To]  ,
			[Deaccessioned_Reason]  ,
			[Material]  ,
			[Prep_By]  ,
			[Location_ID]  ,
			[Specimen_Owner]  ,
			[Accession_Num]  ,
			[Locality_ID]  ,
			[ESA]  ,
			[CITES]  ,
			[Document_Reference]
		)
		SELECT
			[Specimen_ID], 
			[Organism_ID] ,
			[Specimen_Sex],
			[Specimen_Age],
			[NFWFL_Num],
			[REP_Num] ,
			[Deaccessioned_To],
			[Deaccessioned_Reason],
			[Material],
			[Prep_By],
			[Location_ID],
			[Specimen_Owner],
			[Accession_Num],
			[Locality_ID] ,
			[ESA],
			[CITES],
			[Document_Reference]
		FROM @temp

	COMMIT TRAN SPECIMEN_TO_STAGING;

	-- merge staging records into dbo w/ data type corrections
	-- conversion failure will return to api/app
	BEGIN TRAN HERP_SPECIMEN_TO_FINAL;
		 -- if Specimen_ID exists, update table
		 -- else, insert new record
		MERGE dbo.Herpetology_Specimen AS HS 
			USING staging.Herpetology_Specimen AS T 
			ON CAST(T.Specimen_ID AS INT) = HS.Specimen_ID
		WHEN MATCHED THEN 
			UPDATE SET  HS.[Organism_ID]			=  T.[Organism_ID],
						HS.[Specimen_Sex]			=  T.[Specimen_Sex]	,		
						HS.[Specimen_Age]			=  T.[Specimen_Age]	,		
						HS.[NFWFL_Num]				=  T.[NFWFL_Num]	,			
						HS.[REP_Num]				=  T.[REP_Num]		,		
						HS.[Deaccessioned_To]		=  T.[Deaccessioned_To]	,	
						HS.[Deaccessioned_Reason]	=  T.[Deaccessioned_Reason]	,
						HS.[Material]				=  T.[Material]				,
						HS.[Prep_By]				=  T.[Prep_By]				,
						HS.[Location_ID]			=  CAST(T.[Location_ID]	AS INT)		,	-- @TODO if location data changed, this will need to change!!!	
						HS.[Specimen_Owner]			=  T.[Specimen_Owner]		,
						HS.[Accession_Num]			=  T.[Accession_Num]		,	
						HS.[Locality_ID]			=  CAST(T.[Locality_ID]	AS INT)		,	-- @TODO if locality data changed, this will need to change!!!	
						HS.[ESA]					=  T.[ESA]					,
						HS.[CITES]					=  T.[CITES]				,	
						HS.[Document_Reference]		=  T.[Document_Reference],
						HS.MODIFIED_TS				= GETDATE(),
						HS.MODIFIED_BY				= CURRENT_USER
		WHEN NOT MATCHED THEN	-- else, we are inserting a new record
			INSERT (		
				[Specimen_Sex],			
				[Specimen_Age]	,		
				[NFWFL_Num]		,		
				[REP_Num]		,		
				[Deaccessioned_To]	,	
				[Deaccessioned_Reason]	,
				[Material]				,
				[Prep_By]				,
				[Location_ID]			,
				[Specimen_Owner]		,
				[Accession_Num]			,
				[Locality_ID]			,
				[ESA]					,
				[CITES]					,
				[Document_Reference]	,
				[CREATED_TS]			,
				[CREATED_BY]
				)
			VALUES (		
				T.[Specimen_Sex]	,		
				T.[Specimen_Age]	,		
				T.[NFWFL_Num]	,		
				T.[REP_Num]		,		
				T.[Deaccessioned_To]	,	
				T.[Deaccessioned_Reason]	,
				T.[Material]				,
				T.[Prep_By]				,
				T.[Location_ID]			,
				T.[Specimen_Owner]		,
				T.[Accession_Num]		,
				T.[Locality_ID]			,
				T.[ESA]					,
				T.[CITES]				,
				T.[Document_Reference]	,
				GETDATE()				,
				CURRENT_USER			
			);

	COMMIT TRAN HERP_SPECIMEN_TO_FINAL;

	--@TODO: update what is returned to API
	SELECT * FROM staging.Herpetology_Specimen;

END
GO
