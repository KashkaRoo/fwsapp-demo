/** SSMS-generated scripts foe Views and Stored Procedures */


/** Create views */
GO
/****** Object:  View [dbo].[VW_Herpetology_Organism_All]    Script Date: 6/4/2020 1:33:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_Herpetology_Organism_All]
AS
SELECT        dbo.Organism.Binomial_Nomenclature, dbo.Organism.Organism_ID, dbo.Organism.Class, dbo.Organism.Subclass, dbo.Organism.[Order], dbo.Organism.Suborder, dbo.Organism.Family, dbo.Organism.Subfamily, dbo.Organism.Subgenus, 
                         dbo.Organism.Subspecies, dbo.Organism.Variety, dbo.Organism.Common_Name, dbo.Organism.Previous_Designation, dbo.Herpetology_Specimen.Specimen_ID, 
                         dbo.Herpetology_Specimen.Specimen_Sex, dbo.Herpetology_Specimen.Specimen_Age, dbo.Herpetology_Specimen.NFWFL_Num, dbo.Herpetology_Specimen.REP_Num, dbo.Herpetology_Specimen.Deaccessioned_To, 
                         dbo.Herpetology_Specimen.Deaccessioned_Reason, dbo.Herpetology_Specimen.Material, dbo.Herpetology_Specimen.Prep_By, dbo.Herpetology_Specimen.Specimen_Owner, dbo.Herpetology_Specimen.Accession_Num, 
                         dbo.Herpetology_Specimen.ESA, dbo.Herpetology_Specimen.CITES, dbo.Herpetology_Specimen.Document_Reference, dbo.Herpetology_Specimen.Locality_Desc, 
                         dbo.Herpetology_Specimen.Location_Desc
FROM            dbo.Herpetology_Specimen INNER JOIN
                         dbo.Organism ON dbo.Herpetology_Specimen.Organism_ID = dbo.Organism.Organism_ID
GO

/****** Object:  View [dbo].[VW_Xylarium_Organism_All]    Script Date: 6/4/2020 1:33:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[VW_Xylarium_Organism_All]
AS
SELECT					 dbo.Organism.Binomial_Nomenclature, dbo.Xylarium_Specimen.Specimen_ID, dbo.Xylarium_Specimen.NFWFL_Num, dbo.Xylarium_Specimen.Collection_Num, 
                         dbo.Xylarium_Specimen.Other_Nums, dbo.Xylarium_Specimen.Previous_Designation AS 'Specimen Previous Designation', dbo.Xylarium_Specimen.Eminent_Org, dbo.Xylarium_Specimen.Collector, dbo.Xylarium_Specimen.Source_Type, 
                         dbo.Xylarium_Specimen.Wild_Check, dbo.Xylarium_Specimen.Specimen_Description, dbo.Xylarium_Specimen.Heartwood_or_Sapwood, dbo.Xylarium_Specimen.Notes, dbo.Xylarium_Specimen.Color, 
                         dbo.Xylarium_Specimen.NFWFL_Analyzed, dbo.Xylarium_Specimen.Catalogued_By, dbo.Xylarium_Specimen.Identified_By, dbo.Xylarium_Specimen.Locality_Desc, dbo.Xylarium_Specimen.Location_Desc, 
						 dbo.Organism.Organism_ID, dbo.Organism.Class, dbo.Organism.Subclass, dbo.Organism.[Order], dbo.Organism.Suborder, dbo.Organism.Family, 
                         dbo.Organism.Subfamily, dbo.Organism.Subgenus, dbo.Organism.Previous_Designation, dbo.Organism.Common_Name, dbo.Organism.Variety, dbo.Organism.Subspecies
FROM          dbo.Xylarium_Specimen INNER JOIN
                         dbo.Organism ON dbo.Xylarium_Specimen.Organism_ID = dbo.Organism.Organism_ID
GO

/** Create stored procedures */

/****** Object:  StoredProcedure [dbo].[SP_Herp_Update_or_Add]    Script Date: 6/4/2020 1:33:25 AM ******/
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
	@json varchar(MAX) = '',
	@org_changed bit = 1	-- could use this to optimize proc if API passed in whether or not org fields were changed
AS
BEGIN
	 --@TODO: Error handling: json == '' then error

	-- Create temp table to hold part of json that is specimen-specific
	DECLARE @temp AS TABLE (
		[Organism_ID] [varchar](20),
		[Specimen_ID] [varchar](20) ,
		[Specimen_Sex] [varchar](20) ,
		[Specimen_Age] [varchar](50) ,
		[NFWFL_Num] [varchar](20) ,
		[REP_Num] [varchar](20) ,
		[Deaccessioned_To] [varchar](100) ,
		[Deaccessioned_Reason] [varchar](100) ,
		[Material] [varchar](100) ,
		[Prep_By] [varchar](100) ,
		[Location_Desc] [varchar](20),
		[Specimen_Owner] [varchar](50),
		[Accession_Num] [varchar](20) ,
		[Locality_Desc] [varchar](20),
		[ESA] [varchar](50) ,
		[CITES] [varchar](50) ,
		[Document_Reference] [varchar](300),
		[Class] [varchar](50),
		[Subclass] [varchar](50),
		[Order] [varchar](50),
		[Suborder] [varchar](50),
		[Family] [varchar](50) ,
		[Subfamily] [varchar](50) ,
		[Binomial_Nomenclature] [varchar](max) ,
		[Subgenus] [varchar](50) ,
		[Subspecies] [varchar](50) ,
		[Variety] [varchar](50) ,
		[Common_Name] [varchar](50) ,
		[Previous_Designation] [varchar](200) 
	);

	-- put json into temp
	-- temp table holds both Organism and Specimen data for now
	INSERT INTO @temp
	SELECT *
	FROM OPENJSON(@json)
	WITH ([Organism_ID] [varchar](20),
		[Specimen_ID] [varchar](20) ,
		[Specimen_Sex] [varchar](20) ,
		[Specimen_Age] [varchar](50) ,
		[NFWFL_Num] [varchar](20) ,
		[REP_Num] [varchar](20) ,
		[Deaccessioned_To] [varchar](100) ,
		[Deaccessioned_Reason] [varchar](100) ,
		[Material] [varchar](100) ,
		[Prep_By] [varchar](100) ,
		[Location_Desc] [varchar](20),
		[Specimen_Owner] [varchar](50),
		[Accession_Num] [varchar](20) ,
		[Locality_Desc] [varchar](20),
		[ESA] [varchar](50) ,
		[CITES] [varchar](50) ,
		[Document_Reference] [varchar](300),
		[Class] [varchar](50),
		[Subclass] [varchar](50),
		[Order] [varchar](50),
		[Suborder] [varchar](50),
		[Family] [varchar](50) ,
		[Subfamily] [varchar](50) ,
		[Binomial_Nomenclature] [varchar](max) ,
		[Subgenus] [varchar](50) ,
		[Subspecies] [varchar](50) ,
		[Variety] [varchar](50) ,
		[Common_Name] [varchar](50) ,
		[Previous_Designation] [varchar](200) 
		 	);

	INSERT INTO fwsdb_fws_app.herp_temp_log (
		[Organism_ID] ,
		[Specimen_ID] ,
		[Specimen_Sex],
		[Specimen_Age],
		[NFWFL_Num],
		[REP_Num] ,
		[Deaccessioned_To],
		[Deaccessioned_Reason]  ,
		[Material] ,
		[Prep_By] ,
		[Location_Desc] ,
		[Specimen_Owner],
		[Accession_Num]  ,
		[Locality_Desc] ,
		[ESA],
		[CITES]  ,
		[Document_Reference] ,
		[Class] ,
		[Subclass],
		[Order] ,
		[Suborder] ,
		[Family] ,
		[Subfamily]  ,
		[Subgenus] ,
		[Subspecies] ,
		[Variety] ,
		[Common_Name] ,
		[Previous_Designation] )
	SELECT
		[Organism_ID] ,
		[Specimen_ID] ,
		[Specimen_Sex],
		[Specimen_Age],
		[NFWFL_Num],
		[REP_Num] ,
		[Deaccessioned_To],
		[Deaccessioned_Reason]  ,
		[Material] ,
		[Prep_By] ,
		[Location_Desc] ,
		[Specimen_Owner],
		[Accession_Num]  ,
		[Locality_Desc] ,
		[ESA],
		[CITES]  ,
		[Document_Reference] ,
		[Class] ,
		[Subclass],
		[Order] ,
		[Suborder] ,
		[Family] ,
		[Subfamily]  ,
		[Subgenus] ,
		[Subspecies] ,
		[Variety] ,
		[Common_Name] ,
		[Previous_Designation]
	FROM @temp;


	-- FOR EACH record in temp
		-- GET EITHER: an existing matching Organism record OR insert a new one
		-- OVERWRITE temp.Organism_ID with above 
	BEGIN TRAN FIND_AND_UPDATE_ORG_ID
		-- lock the dbo tables
		-- workaround to allow "select max(id)" without worrying about concurrency
		-- @TODO: improve this method
		select top 1 *
		from dbo.Herpetology_Specimen
		with (tablock, holdlock);

		select top 1 *
		from dbo.Organism
		with (tablock, holdlock);

		
		TRUNCATE TABLE staging.Organism;
		TRUNCATE TABLE staging.Herpetology_Specimen;

		-- declare local variables for cursor
		DECLARE @orgid		[varchar] (20),
				@class		[varchar](50),
				@subclass	[varchar](50),
				@order		[varchar](50),
				@suborder	[varchar](50),
				@family		[varchar](50) ,
				@subfamily	[varchar](50) ,
				@binom		[varchar](max) ,
				@subgenus	[varchar](50) ,
				@subspecies [varchar](50) ,
				@variety	[varchar](50) ,
				@common		[varchar](50) ,
				@prev		[varchar](200);

		-- declare a small table to select Org_ID into
		DECLARE @temp_TABLE_org_id TABLE(Organism_ID VARCHAR(20) NULL);
		INSERT INTO @temp_TABLE_org_id(Organism_ID) VALUES (NULL);

		-- declare a cursor to iterate over temp table - necessary for bulk add or accidental parallelism (?)
		DECLARE cr_update_org_id CURSOR FOR
			SELECT Organism_ID, Class, Subclass, [Order], Suborder, Family, Subfamily, Binomial_Nomenclature, Subgenus, Subspecies, Variety, Common_Name, Previous_Designation 
			FROM @temp;
		
		OPEN cr_update_org_id;

			-- get first record from temp
			-- need to grab Specimen_ID so we know which record to update in @temp
			-- @TODO: if two people edit same specimen, so both edits end up in staging, how would this be affected?
			FETCH NEXT FROM cr_update_org_id
			INTO @orgid, @class, @subclass, @order, @suborder, @family, @subfamily, @binom, @subgenus, @subspecies, @variety, @common, @prev;

			-- while fetch is successful
			WHILE @@FETCH_STATUS = 0
				BEGIN
					INSERT INTO fwsdb_fws_app.cursor_log (
							orgid,
							class		,
							subclass	,
							[order]		,
							suborder	,
							family		,
							subfamily	,
							subgenus	,
							subspecies 	,
							variety		,
							common		,
							prev		) 
					VALUES (@orgid, @class, @subclass, @order, @suborder, @family, @subfamily, @subgenus, @subspecies, @variety, @common, @prev);

					DELETE FROM @temp_TABLE_org_id;
						
					INSERT INTO @temp_TABLE_org_id(Organism_ID)
					SELECT Organism_ID
					FROM dbo.Organism
					WHERE ((Class = @class)	OR (Class IS NULL AND @class IS NULL))	-- fields match or both are NULL
					AND ((Subclass = @subclass)			OR (Subclass IS NULL AND				@subclass IS NULL))
					AND (([Order] = @order)				OR ([Order] IS NULL AND					@order IS NULL))
					AND ((Suborder = @suborder)			OR (Suborder IS NULL AND				@suborder IS NULL))
					AND ((Family = @family)				OR (Family IS NULL AND					@family IS NULL))
					AND ((Subfamily = @subfamily)		OR (Subfamily IS NULL AND				@subfamily IS NULL))
					AND ((Binomial_Nomenclature = @binom)				OR (Binomial_Nomenclature IS NULL AND					@binom IS NULL))
					AND ((Subgenus = @subgenus)			OR (Subgenus IS NULL AND				@subgenus IS NULL))
					AND ((Subspecies = @subspecies)		OR (Subspecies IS NULL AND				@subspecies IS NULL))
					AND ((Variety = @variety)			OR (Variety IS NULL AND					@variety IS NULL))
					AND ((Common_Name = @common)		OR (Common_Name IS NULL AND				@common IS NULL))
					AND ((Previous_Designation = @prev) OR (Previous_Designation IS NULL AND	@prev IS NULL))

					-- IF NO RECORD FOUND from select statement above, insert new Organism record
					IF (SELECT Organism_ID FROM @temp_TABLE_org_id) IS NULL	OR (SELECT Organism_ID FROM @temp_TABLE_org_id) = ''
						BEGIN
							--ideally would put into staging then merge (insert statement from stage to dbo ready-but commented out-below)
							INSERT INTO dbo.Organism (Class, Subclass, [Order], Suborder, Family, Subfamily, Binomial_Nomenclature, Subgenus, 
								Subspecies, Variety, Common_Name, Previous_Designation)
										OUTPUT inserted.Organism_ID INTO @temp_TABLE_org_id	-- save the Organism_ID to update temp record later
							VALUES (@class, @subclass, @order, @suborder, @family, @subfamily, @binom, @subgenus, @subspecies, @variety, @common, @prev);
						
							INSERT INTO @temp_TABLE_org_id
							SELECT (MAX(Organism_ID)) FROM dbo.Organism;
						END
					

					-- update the record we're currently looking at in temp with the identified Organism_ID (either found or inserted)
					UPDATE @temp 
					SET Organism_ID = (SELECT MAX(Organism_ID) FROM @temp_TABLE_org_id)	-- @TODO: 'should' work; select stmt above should return 0 or 1 record
					WHERE CURRENT OF cr_update_org_id;

					select * from @temp;

					-- Now that we have the connected Organism_ID in @temp, can start working with the Specimen record
					BEGIN TRAN SPECIMEN_TO_STAGING	--maybe don't need to lock Herp_Spec until here?
		
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
							[Location_Desc]  ,
							[Specimen_Owner]  ,
							[Accession_Num]  ,
							[Locality_Desc]  ,
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
							[Location_Desc],
							[Specimen_Owner],
							[Accession_Num],
							[Locality_Desc] ,
							[ESA],
							[CITES],
							[Document_Reference]
						FROM @temp

					COMMIT TRAN SPECIMEN_TO_STAGING;

					-- clear out temp table variable so there is never more than one record
					DELETE FROM @temp_TABLE_org_id;
					INSERT INTO @temp_TABLE_org_id(Organism_ID) VALUES (NULL);

					-- get next record from cursor
					-- if fails, FETCH_STATUS != 0 and while loop will exit
					FETCH NEXT FROM cr_update_org_id
					INTO @orgid, @class, @subclass, @order, @suborder, @family, @subfamily, @binom, @subgenus, @subspecies, @variety, @common, @prev
				END

		CLOSE cr_update_org_id

	---------
		-- ideally Organism records would be put into staging then inserted into dbo with this transaction
		-- DO NOT DELETE - very usable insertion, but the code above would need modification
	---------
	--BEGIN TRAN ORGANISM_TO_FINAL
	--	-- the only records in staging.Organism are ones that could not be found by the INTERSECT statement, so no need to merge, just insert
	--	INSERT INTO dbo.Organism (
	--				Class,
	--				Subclass,
	--				[Order], 
	--				Suborder,
	--				Family,
	--				Subfamily,
	--				Binomial_Nomenclature,
	--				Subgenus,
	--				Subspecies,		
	--				Variety,
	--				Common_Name,
	--				Previous_Designation,
	--				CREATED_TS,
	--				CREATED_BY
	--				)
	--		SELECT 	Class,
	--				Subclass,
	--				[Order], 
	--				Suborder,
	--				Family,
	--				Subfamily,
	--				Binomial_Nomenclature,
	--				Subgenus,
	--				Subspecies,		
	--				Variety,
	--				Common_Name,
	--				Previous_Designation,
	--				GETDATE(),
	--				CURRENT_USER
	--		FROM staging.Organism
	--
	--COMMIT TRAN ORGANISM_TO_FINAL;

	-- merge staging records into dbo w/ data type corrections
	-- conversion failure will return to app via api

		BEGIN TRAN HERP_SPECIMEN_TO_FINAL

			 -- if Specimen_ID exists, update table
			 -- basically, if we edited existing record update and if we inserted a new one add
			MERGE dbo.Herpetology_Specimen AS HS 
				USING staging.Herpetology_Specimen AS T 
				ON CAST(T.Specimen_ID AS INT) = HS.Specimen_ID
			WHEN MATCHED THEN 
				UPDATE SET  HS.[Organism_ID]			=  CAST(T.[Organism_ID] AS INT),
							HS.[Specimen_Sex]			=  T.[Specimen_Sex]	,		
							HS.[Specimen_Age]			=  T.[Specimen_Age]	,		
							HS.[NFWFL_Num]				=  T.[NFWFL_Num]	,			
							HS.[REP_Num]				=  T.[REP_Num]		,		
							HS.[Deaccessioned_To]		=  T.[Deaccessioned_To]	,	
							HS.[Deaccessioned_Reason]	=  T.[Deaccessioned_Reason]	,
							HS.[Material]				=  T.[Material]				,
							HS.[Prep_By]				=  T.[Prep_By]				,
							HS.[Location_Desc]			=  T.[Location_Desc],
							HS.[Specimen_Owner]			=  T.[Specimen_Owner]		,
							HS.[Accession_Num]			=  T.[Accession_Num]		,	
							HS.[Locality_Desc]			=  T.[Locality_Desc],
							HS.[ESA]					=  T.[ESA]					,
							HS.[CITES]					=  T.[CITES]				,	
							HS.[Document_Reference]		=  T.[Document_Reference],
							HS.MODIFIED_TS				= GETDATE(),
							HS.MODIFIED_BY				= CURRENT_USER
			WHEN NOT MATCHED THEN	-- else, we are inserting a new record
				INSERT (
					[Organism_ID],
					[Specimen_Sex],			
					[Specimen_Age]	,		
					[NFWFL_Num]		,		
					[REP_Num]		,		
					[Deaccessioned_To]	,	
					[Deaccessioned_Reason]	,
					[Material]				,
					[Prep_By]				,
					[Location_Desc]			,
					[Specimen_Owner]		,
					[Accession_Num]			,
					[Locality_Desc]			,
					[ESA]					,
					[CITES]					,
					[Document_Reference]	,
					[CREATED_TS]			,
					[CREATED_BY]
					)
				VALUES (
					T.[Organism_ID],
					T.[Specimen_Sex]	,		
					T.[Specimen_Age]	,		
					T.[NFWFL_Num]	,		
					T.[REP_Num]		,		
					T.[Deaccessioned_To]	,	
					T.[Deaccessioned_Reason]	,
					T.[Material]				,
					T.[Prep_By]				,
					T.[Location_Desc],
					T.[Specimen_Owner]		,
					T.[Accession_Num]		,
					T.[Locality_Desc]			,
					T.[ESA]					,
					T.[CITES]				,
					T.[Document_Reference]	,
					GETDATE()				,
					CURRENT_USER			
				);
	
		COMMIT TRAN HERP_SPECIMEN_TO_FINAL;

	COMMIT TRAN FIND_AND_UPDATE_ORG_ID;	--locks on dbo.Herpetology_Specimen and dbo.Organism are released

	--@TODO: update what is returned to API
	select * from staging.Herpetology_Specimen;

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_Scientific_Name]    Script Date: 6/4/2020 1:33:25 AM ******/
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

	TRUNCATE TABLE staging.Herpetology_Specimen;
		
	UPDATE dbo.Organism 
		SET		dbo.Organism.Class = j.Class,
				dbo.Organism.Subclass = j.Subclass,
				dbo.Organism.[Order] = j.[Order], 
				dbo.Organism.Suborder = j.Suborder,
				dbo.Organism.Family = j.Family,
				dbo.Organism.Subfamily = j.Subfamily,
				dbo.Organism.Binomial_Nomenclature = j.Binomial_Nomenclature,
				dbo.Organism.Subgenus = j.Subgenus,
				dbo.Organism.Subspecies = j.Subspecies,		
				dbo.Organism.Variety = j.Variety,
				dbo.Organism.Common_Name = j.Common_Name,
				dbo.Organism.Previous_Designation = j.Previous_Designation,
				dbo.Organism.MODIFIED_TS = GETDATE(),
				dbo.Organism.MODIFIED_BY = CURRENT_USER
	FROM   dbo.Organism AS o
	JOIN   OPENJSON(@json) 
	WITH ([Organism_ID] INT,
		[Class] [varchar](50),
		[Subclass] [varchar](50),
		[Order] [varchar](50),
		[Suborder] [varchar](50),
		[Family] [varchar](50) ,
		[Subfamily] [varchar](50) ,
		Binomial_Nomenclature [varchar](max),
		[Subgenus] [varchar](50) ,
		[Subspecies] [varchar](50) ,
		[Variety] [varchar](50) ,
		[Common_Name] [varchar](50) ,
		[Previous_Designation] [varchar](200) 
	) j
    ON CAST(j.Organism_ID AS INT) = o.Organism_ID
	WHERE o.Organism_ID = CAST(j.Organism_ID AS INT)

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Xy_Update_or_Add]    Script Date: 6/4/2020 1:33:25 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alexandra Cannon
-- Created date: 5/18/2020
-- Description:	Xylarium dataset: Update record if exists, else add new record
--				Includes logic for Organism record search vs. insert new
--				@TODO: Add similar logic for location
--				@TODO: Add similar logic for locality
-- =============================================
CREATE PROCEDURE [dbo].[SP_Xy_Update_or_Add] 
	-- Add the parameters for the stored procedure here
	@json varchar(MAX) = ''
AS
BEGIN
	 --@TODO: Error handling: json == '' then error

	-- Create temp table to hold part of json that is specimen-specific
	DECLARE @temp AS TABLE (
		[Organism_ID] [varchar](20),
		[Specimen_ID] [varchar](20) ,
		[NFWFL_Num] [varchar](20) ,
		[Collection_Num] [varchar](20) ,
		[Other_Nums] [varchar](20) ,
		[Specimen_Previous_Designation] [varchar](50) ,
		[Eminent_Org] [varchar](50) ,
		[Collector] [varchar](50) ,
		[Source_Type] [varchar](50) ,
		[Wild_Check] [varchar](20) ,
		[Specimen_Description] [varchar](100) ,
		[Heartwood_or_Sapwood] [varchar](20) ,
		[Notes] [varchar](max) ,
		[Color] [varchar](20) ,
		[NFWFL_Analyzed] [bit] ,
		[Catalogued_By] [varchar](50) ,
		[Identified_By] [varchar](50) ,
		[Location_Desc] [varchar](max) ,
		[Locality_Desc] [varchar](max) ,
		[Class] [varchar](50),
		[Subclass] [varchar](50),
		[Order] [varchar](50),
		[Suborder] [varchar](50),
		[Family] [varchar](50) ,
		[Subfamily] [varchar](50) ,
		[Binomial_Nomenclature] [varchar](max),
		[Subgenus] [varchar](50) ,
		[Subspecies] [varchar](50) ,
		[Variety] [varchar](50) ,
		[Common_Name] [varchar](50) ,
		[Previous_Designation] [varchar](200) 
	);

	-- put json into temp
	-- temp table holds both Organism and Specimen data for now
	INSERT INTO @temp
	SELECT *
	FROM OPENJSON(@json)
	WITH ([Organism_ID] [varchar](20),
		[Specimen_ID] [varchar](20) ,
		[NFWFL_Num] [varchar](20) ,
		[Collection_Num] [varchar](20) ,
		[Other_Nums] [varchar](20) ,
		[Specimen_Previous_Designation] [varchar](50) ,
		[Eminent_Org] [varchar](50) ,
		[Collector] [varchar](50) ,
		[Source_Type] [varchar](50) ,
		[Wild_Check] [varchar](20) ,
		[Specimen_Description] [varchar](100) ,
		[Heartwood_or_Sapwood] [varchar](20) ,
		[Notes] [varchar](max) ,
		[Color] [varchar](20) ,
		[NFWFL_Analyzed] [bit] ,
		[Catalogued_By] [varchar](50) ,
		[Identified_By] [varchar](50) ,
		[Location_Desc] [varchar](max) ,
		[Locality_Desc] [varchar](max) ,
		[Class] [varchar](50),
		[Subclass] [varchar](50),
		[Order] [varchar](50),
		[Suborder] [varchar](50),
		[Family] [varchar](50) ,
		[Subfamily] [varchar](50) ,
		[Binomial_Nomenclature] [varchar](max) ,
		[Subgenus] [varchar](50) ,
		[Subspecies] [varchar](50) ,
		[Variety] [varchar](50) ,
		[Common_Name] [varchar](50) ,
		[Previous_Designation] [varchar](200) 
	);

	-- FOR EACH record in temp
		-- GET EITHER: an existing matching Organism record OR insert a new one
		-- OVERWRITE temp.Organism_ID with above 
	BEGIN TRAN FIND_AND_UPDATE_ORG_ID
		-- lock the dbo tables
		-- workaround to allow "select max(id)" without worrying about concurrency
		-- @TODO: improve this method
		select top 1 *
		from dbo.Xylarium_Specimen
		with (tablock, holdlock);

		select top 1 *
		from dbo.Organism
		with (tablock, holdlock);

		
		TRUNCATE TABLE staging.Organism;
		TRUNCATE TABLE staging.Xylarium_Specimen;

		-- declare local variables for cursor
		-- declare local variables for cursor
		DECLARE @orgid		[varchar] (20),
				@class		[varchar](50),
				@subclass	[varchar](50),
				@order		[varchar](50),
				@suborder	[varchar](50),
				@family		[varchar](50) ,
				@subfamily	[varchar](50) ,
				@binom		[varchar](max) ,
				@subgenus	[varchar](50) ,
				@subspecies [varchar](50) ,
				@variety	[varchar](50) ,
				@common		[varchar](50) ,
				@prev		[varchar](200),
				@wc			[bit];

		-- declare a small table to select Org_ID into
		DECLARE @temp_TABLE_org_id TABLE(Organism_ID VARCHAR(20) NULL);
		INSERT INTO @temp_TABLE_org_id(Organism_ID) VALUES (NULL);

		-- declare a cursor to iterate over temp table - necessary for bulk add or accidental parallelism (?)
		DECLARE cr_update_org_id CURSOR FOR
			SELECT Organism_ID, Class, Subclass, [Order], Suborder, Family, Subfamily, Binomial_Nomenclature, Subgenus, Subspecies, Variety, Common_Name, Previous_Designation, Wild_Check 
			FROM @temp;
		
		OPEN cr_update_org_id;

			-- get first record from temp
			-- need to grab Specimen_ID so we know which record to update in @temp
			-- @TODO: if two people edit same specimen, so both edits end up in staging, how would this be affected?
			FETCH NEXT FROM cr_update_org_id
			INTO @orgid, @class, @subclass, @order, @suborder, @family, @subfamily, @binom, @subgenus, @subspecies, @variety, @common, @prev, @wc;

			-- while fetch is successful
			WHILE @@FETCH_STATUS = 0
				BEGIN
					INSERT INTO fwsdb_fws_app.cursor_log (
							orgid,
							class		,
							subclass	,
							[order]		,
							suborder	,
							family		,
							subfamily	,
							subgenus	,
							subspecies 	,
							variety		,
							common		,
							prev		) 
					VALUES (@orgid, @class, @subclass, @order, @suborder, @family, @subfamily, @subgenus, @subspecies, @variety, @common, @prev);

					DELETE FROM @temp_TABLE_org_id;
						
					INSERT INTO @temp_TABLE_org_id(Organism_ID)
					SELECT Organism_ID
					FROM dbo.Organism
					WHERE ((Class = @class)	OR (Class IS NULL AND @class IS NULL))	-- fields match or both are NULL
					AND ((Subclass = @subclass)			OR (Subclass IS NULL AND				@subclass IS NULL))
					AND (([Order] = @order)				OR ([Order] IS NULL AND					@order IS NULL))
					AND ((Suborder = @suborder)			OR (Suborder IS NULL AND				@suborder IS NULL))
					AND ((Family = @family)				OR (Family IS NULL AND					@family IS NULL))
					AND ((Subfamily = @subfamily)		OR (Subfamily IS NULL AND				@subfamily IS NULL))
					AND ((Binomial_Nomenclature = @binom)				OR (Binomial_Nomenclature IS NULL AND					@binom IS NULL))
					AND ((Subgenus = @subgenus)			OR (Subgenus IS NULL AND				@subgenus IS NULL))
					AND ((Subspecies = @subspecies)		OR (Subspecies IS NULL AND				@subspecies IS NULL))
					AND ((Variety = @variety)			OR (Variety IS NULL AND					@variety IS NULL))
					AND ((Common_Name = @common)		OR (Common_Name IS NULL AND				@common IS NULL))
					AND ((Previous_Designation = @prev) OR (Previous_Designation IS NULL AND	@prev IS NULL))

					-- IF NO RECORD FOUND from select statement above, insert new Organism record
					IF (SELECT Organism_ID FROM @temp_TABLE_org_id) IS NULL	OR (SELECT Organism_ID FROM @temp_TABLE_org_id) = ''
						BEGIN
							--ideally would put into staging then merge (insert statement from stage to dbo ready-but commented out-below)
							INSERT INTO dbo.Organism (Class, Subclass, [Order], Suborder, Family, Subfamily, Binomial_Nomenclature, Subgenus, 
								Subspecies, Variety, Common_Name, Previous_Designation)
										OUTPUT inserted.Organism_ID INTO @temp_TABLE_org_id	-- save the Organism_ID to update temp record later
							VALUES (@class, @subclass, @order, @suborder, @family, @subfamily, @binom, @subgenus, @subspecies, @variety, @common, @prev);
						
							INSERT INTO @temp_TABLE_org_id
							SELECT (MAX(Organism_ID)) FROM dbo.Organism;
						END
					

					-- update the record we're currently looking at in temp with the identified Organism_ID (either found or inserted)
					UPDATE @temp 
					SET Organism_ID = (SELECT MAX(Organism_ID) FROM @temp_TABLE_org_id)	-- @TODO: 'should' work; select stmt above should return 0 or 1 record
					WHERE CURRENT OF cr_update_org_id;

					select * from @temp;

					-- Now that we have the connected Organism_ID in @temp, can start working with the Specimen record
					BEGIN TRAN SPECIMEN_TO_STAGING	--maybe don't need to lock Herp_Spec until here?
		
						-- Put temp (now has update Organism ID) into staging.Herpetology_Specimen
						INSERT INTO staging.Xylarium_Specimen (
									[Organism_ID] ,
									[Specimen_ID]  ,
									[NFWFL_Num]  ,
									[Collection_Num]  ,
									[Other_Nums]  ,
									[Previous_Designation]  ,
									[Eminent_Org]  ,
									[Collector]  ,
									[Source_Type]  ,
									[Wild_Check]  ,
									[Specimen_Description] ,
									[Heartwood_or_Sapwood]  ,
									[Notes] ,
									[Color]  ,
									[NFWFL_Analyzed] ,
									[Catalogued_By]  ,
									[Identified_By]  ,
									[Location_Desc] ,
									[Locality_Desc]
						)
						SELECT
							[Organism_ID] ,
									[Specimen_ID]  ,
									[NFWFL_Num]  ,
									[Collection_Num]  ,
									[Other_Nums]  ,
									[Specimen_Previous_Designation]  ,
									[Eminent_Org]  ,
									[Collector]  ,
									[Source_Type]  ,
									[Wild_Check]  ,
									[Specimen_Description] ,
									[Heartwood_or_Sapwood]  ,
									[Notes] ,
									[Color]  ,
									[NFWFL_Analyzed] ,
									[Catalogued_By]  ,
									[Identified_By]  ,
									[Location_Desc] ,
									[Locality_Desc]

						FROM @temp

					COMMIT TRAN SPECIMEN_TO_STAGING;

					-- clear out temp table variable so there is never more than one record
					DELETE FROM @temp_TABLE_org_id;
					INSERT INTO @temp_TABLE_org_id(Organism_ID) VALUES (NULL);

					-- get next record from cursor
					-- if fails, FETCH_STATUS != 0 and while loop will exit
					FETCH NEXT FROM cr_update_org_id
					INTO @orgid, @class, @subclass, @order, @suborder, @family, @subfamily, @binom, @subgenus, @subspecies, @variety, @common, @prev, @wc
				END

		CLOSE cr_update_org_id

	-- merge staging records into dbo w/ data type corrections
	-- conversion failure will return to app via api

		BEGIN TRAN XY_SPECIMEN_TO_FINAL

			 -- if Specimen_ID exists, update table
			 -- basically, if we edited existing record update and if we inserted a new one add
			MERGE dbo.Xylarium_Specimen AS XS 
				USING staging.Xylarium_Specimen AS T 
				ON CAST(T.Specimen_ID AS INT) = XS.Specimen_ID
			WHEN MATCHED THEN 
				UPDATE SET  XS.[Organism_ID]  = T.[Organism_ID] ,
							XS.[NFWFL_Num]   = T.[NFWFL_Num]  ,
							XS.[Collection_Num]   = T.[Collection_Num]  ,
							XS.[Other_Nums]   = T.[Other_Nums]  ,
							XS.[Previous_Designation]   = T.[Previous_Designation]  ,
							XS.[Eminent_Org]   = T.[Eminent_Org]  ,
							XS.[Collector]   = T.[Collector]  ,
							XS.[Source_Type]   = T.[Source_Type]  ,
							XS.[Wild_Check]   = T.[Wild_Check]  ,
							XS.[Specimen_Description]  = T.[Specimen_Description] ,
							XS.[Heartwood_or_Sapwood]   = T.[Heartwood_or_Sapwood]  ,
							XS.[Notes]  = T.[Notes] ,
							XS.[Color]   = T.[Color]  ,
							XS.[NFWFL_Analyzed]  = T.[NFWFL_Analyzed] ,
							XS.[Catalogued_By]   = T.[Catalogued_By]  ,
							XS.[Identified_By]   = T.[Identified_By]  ,
							XS.[Location_Desc]  = T.[Location_Desc] ,
							XS.[Locality_Desc]  = T.[Locality_Desc],
							XS.MODIFIED_TS				= GETDATE(),
							XS.MODIFIED_BY				= CURRENT_USER
			WHEN NOT MATCHED THEN	-- else, we are inserting a new record
				INSERT (
					[Organism_ID] ,
					[NFWFL_Num]  ,
					[Collection_Num],  
					[Other_Nums]  ,
					[Previous_Designation]  ,
					[Eminent_Org]  ,
					[Collector]  ,
					[Source_Type] , 
					[Wild_Check]  ,
					[Specimen_Description] ,
					[Heartwood_or_Sapwood]  ,
					[Notes] ,
					[Color]  ,
					[NFWFL_Analyzed] ,
					[Catalogued_By]  ,
					[Identified_By]  ,
					[Location_Desc] ,
					[Locality_Desc] ,
					[CREATED_TS]			,
					[CREATED_BY]
					)
				VALUES (
					T.[Organism_ID] ,
					T.[NFWFL_Num]  ,
					T.[Collection_Num],  
					T.[Other_Nums]  ,
					T.[Previous_Designation]  ,
					T.[Eminent_Org]  ,
					T.[Collector]  ,
					T.[Source_Type] , 
					T.[Wild_Check]  ,
					T.[Specimen_Description] ,
					T.[Heartwood_or_Sapwood]  ,
					T.[Notes] ,
					T.[Color]  ,
					T.[NFWFL_Analyzed] ,
					T.[Catalogued_By]  ,
					T.[Identified_By]  ,
					T.[Location_Desc] ,
					T.[Locality_Desc] ,
					GETDATE()				,
					CURRENT_USER			
				);
	
		COMMIT TRAN XY_SPECIMEN_TO_FINAL;

	COMMIT TRAN FIND_AND_UPDATE_ORG_ID;	--locks on dbo.Herpetology_Specimen and dbo.Organism are released

	--@TODO: update what is returned to API
	select * from staging.Xylarium_Specimen;

END
GO
