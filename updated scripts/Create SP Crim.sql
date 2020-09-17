USE [Lab_Reference_Data]
GO

/****** Object:  StoredProcedure [dbo].[SP_Crim_Update_or_Add]    Script Date: 7/30/2020 9:03:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







-- =============================================
-- Author:		Heather Rosa
-- Created date: 7/24/2020
-- Description:	Criminalistics dataset: Update record if exists, else add new record
--				Includes logic for Organism record search vs. insert new
-- =============================================
CREATE PROCEDURE [dbo].[SP_Crim_Update_or_Add] 
	-- Add the parameters for the stored procedure here
	@json varchar(MAX) = ''
AS
BEGIN
	 --@TODO: Error handling: json == '' then error
	--declare @json varchar(max);

	-- Create temp table to hold part of json that is specimen-specific
	DECLARE @temp AS TABLE (
		[Specimen_ID] [varchar](20) ,
		[Organism_ID] [varchar](20),
		[CRIM_Num] [varchar](20) ,
		[Collection_Num] [varchar](20) ,
		[Other_Nums] [varchar](20) ,
		[Previous_Collection] [varchar](50) ,
		[Collector] [varchar](50) ,
		[Source_Type] [varchar](50) ,
		[Wild_Cultivated] [varchar](20) ,
		[Specimen_Description] [varchar](100) ,
		[Heartwood_Sapwood] [varchar](20) ,
		[Notes] [varchar](max) ,
		[Color] [varchar](20) ,
		[NFWFL_Analyzed] [bit] ,
		[Catalogued_By] [varchar](50) ,
		[Sample_Location] [varchar](max) ,
		[Locality] [varchar](max) ,
		[Continent] [varchar](200) ,
		[Country] [varchar](200) ,
		[State] [varchar](200) ,
		[Lat_Long] [varchar](max) ,
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
	WITH ([Specimen_ID] [varchar](20) ,
		[Organism_ID] [varchar](20),
		[CRIM_Num] [varchar](20) ,
		[Collection_Num] [varchar](20) ,
		[Other_Nums] [varchar](20) ,
		[Previous_Collection] [varchar](50) ,
		[Collector] [varchar](50) ,
		[Source_Type] [varchar](50) ,
		[Wild_Cultivated] [varchar](20) ,
		[Specimen_Description] [varchar](100) ,
		[Heartwood_Sapwood] [varchar](20) ,
		[Notes] [varchar](max) ,
		[Color] [varchar](20) ,
		[NFWFL_Analyzed] [bit] ,
		[Catalogued_By] [varchar](50) ,
		[Sample_Location] [varchar](max) ,
		[Locality] [varchar](max) ,
		[Continent] [varchar](200) ,
		[Country] [varchar](200) ,
		[State] [varchar](200) ,
		[Lat_Long] [varchar](max) ,
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

	-- FOR EACH record in temp
		-- GET EITHER: an existing matching Organism record OR insert a new one
		-- OVERWRITE temp.Organism_ID with above 
	BEGIN TRAN FIND_AND_UPDATE_ORG_ID
		-- lock the dbo tables
		-- workaround to allow "select max(id)" without worrying about concurrency
		-- @TODO: improve this method
		select top 1 *
		from dbo.Criminalistics
		with (tablock, holdlock);

		select top 1 *
		from dbo.Organism
		with (tablock, holdlock);

		
		TRUNCATE TABLE staging.Organism;
		TRUNCATE TABLE staging.Criminalistics;

		-- declare local variables for cursor
		-- declare local variables for cursor
		DECLARE @orgid		[varchar](20),
				@class		[varchar](50),
				@subclass	[varchar](50),
				@order		[varchar](50),
				@suborder	[varchar](50),
				@family		[varchar](50) ,
				@subfamily	[varchar](50) ,
				@binom		[varchar](max),
				@subgenus	[varchar](50) ,
				@subspecies [varchar](50) ,
				@variety	[varchar](50) ,
				@common		[varchar](50) ,
				@prev		[varchar](200),
				@specid		[varchar](max),
				@crim		[varchar](20),
				@colnum     [varchar](200),
				@otnum      [varchar](200),
				@prevcol	[varchar](max),
				@collect	[varchar](200),
				@src		[varchar](50),
				@wld		[varchar](20),
				@specdesc	[varchar](100),
				@heartsap	[varchar](20),
				@notes		[varchar](max),
				@color		[varchar](20),
				@NFana		[bit],
				@cat		[varchar](50),
				@samloc		[varchar](max),
				@loca		[varchar](max),
				@cont		[varchar](200),
				@country	[varchar](200),
				@st			[varchar](200),
				@lat		[varchar](max);
		-- declare a small table to select Org_ID into
		DECLARE @temp_TABLE_org_id TABLE(Organism_ID VARCHAR(20) NULL);
		INSERT INTO @temp_TABLE_org_id(Organism_ID) VALUES (NULL);

		-- declare a cursor to iterate over temp table - necessary for bulk add or accidental parallelism (?)
		DECLARE cr_update_org_id CURSOR FOR
			SELECT Organism_ID, Class, Subclass, [Order], Suborder, Family, Subfamily, Binomial_Nomenclature, Subgenus, Subspecies, Variety, Common_Name, Previous_Designation, Specimen_ID,
							CRIM_Num,
							Collection_Num,
							Other_Nums,
							Previous_Collection,
							Collector,
							Source_Type,
							Wild_Cultivated,
							Specimen_Description,
							Heartwood_Sapwood,
							Notes,
							Color,
							NFWFL_Analyzed,
							Catalogued_By,
							Sample_Location,
							Locality,
							Continent,
							Country,
							[State],
							Lat_Long
			FROM @temp;
		
		OPEN cr_update_org_id;

			-- get first record from temp
			-- need to grab Specimen_ID so we know which record to update in @temp
			-- @TODO: if two people edit same specimen, so both edits end up in staging, how would this be affected?
			FETCH NEXT FROM cr_update_org_id
			INTO @orgid, @class, @subclass, @order, @suborder, @family, @subfamily, @binom, @subgenus, @subspecies, @variety, @common, @prev, 
				@specid, @crim, @colnum, @otnum, @prevcol, @collect, @src, @wld, @specdesc, @heartsap, @notes, @color, @NFana, @cat, @samloc, @loca, @cont, @country, @st, @lat;

			-- while fetch is successful
			WHILE @@FETCH_STATUS = 0
				BEGIN
					INSERT INTO dbo.cursor_log (
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

					--select * from @temp;

					-- Now that we have the connected Organism_ID in @temp, can start working with the Specimen record
					BEGIN TRAN SPECIMEN_TO_STAGING	--maybe don't need to lock Herp_Spec until here?
		
						-- Put temp (now has update Organism ID) into staging.Herpetology_Specimen
						INSERT INTO staging.Criminalistics (
							[Specimen_ID] ,
							[Organism_ID] ,
							[CRIM_Num]  ,
							[Collection_Num] ,
							[Other_Nums] ,
							[Previous_Collection]  ,
							[Collector]  ,
							[Source_Type]  ,
							[Wild_Cultivated]  ,
							[Specimen_Description] ,
							[Heartwood_Sapwood] ,
							[Notes] ,
							[Color] ,
							[NFWFL_Analyzed] ,
							[Catalogued_By] ,
							[Sample_Location] ,
							[Locality] ,
							[Continent] ,
							[Country] ,
							[State] ,
							[Lat_Long]
						)
						VALUES (@specid, (SELECT MAX(Organism_ID) FROM @temp_TABLE_org_id), 
						@crim, @colnum, @otnum, @prevcol, @collect, @src, @wld, @specdesc, @heartsap, @notes, @color, @NFana, @cat, @samloc, @loca, @cont, @country, @st, @lat);

					COMMIT TRAN SPECIMEN_TO_STAGING;

					-- clear out temp table variable so there is never more than one record
					DELETE FROM @temp_TABLE_org_id;
					INSERT INTO @temp_TABLE_org_id(Organism_ID) VALUES (NULL);

					-- get next record from cursor
					-- if fails, FETCH_STATUS != 0 and while loop will exit
					FETCH NEXT FROM cr_update_org_id
					INTO @orgid, @class, @subclass, @order, @suborder, @family, @subfamily, @binom, @subgenus, @subspecies, @variety, @common, @prev, @specid, @crim, @colnum, @otnum, @prevcol, @collect, @src, @wld, @specdesc, @heartsap, @notes, @color, @NFana, @cat, @samloc, @loca, @cont, @country, @st, @lat;
				END

		CLOSE cr_update_org_id

	-- merge staging records into dbo w/ data type corrections
	-- conversion failure will return to app via api

		BEGIN TRAN CRIM_SPECIMEN_TO_FINAL

			 -- if Specimen_ID exists, update table
			 -- basically, if we edited existing record update and if we inserted a new one add
			MERGE dbo.Criminalistics AS XS 
				USING staging.Criminalistics AS T 
				ON CAST(T.Specimen_ID AS INT) = XS.Specimen_ID
			WHEN MATCHED THEN 
				UPDATE SET  XS.[Organism_ID]  = T.[Organism_ID] ,
							XS.[CRIM_Num]   = T.[CRIM_Num]  ,
							XS.[Collection_Num]   = T.[Collection_Num]  ,
							XS.[Other_Nums]   = T.[Other_Nums]  ,
							XS.[Previous_Collection]   = T.[Previous_Collection]  ,
							XS.[Collector]   = T.[Collector]  ,
							XS.[Source_Type]   = T.[Source_Type]  ,
							XS.[Wild_Cultivated]   = T.[Wild_Cultivated]  ,
							XS.[Specimen_Description]  = T.[Specimen_Description] ,
							XS.[Heartwood_Sapwood]   = T.[Heartwood_Sapwood]  ,
							XS.[Notes]  = T.[Notes] ,
							XS.[Color]   = T.[Color]  ,
							XS.[NFWFL_Analyzed]  = T.[NFWFL_Analyzed] ,
							XS.[Catalogued_By]   = T.[Catalogued_By]  ,
							XS.[Sample_Location]  = T.[Sample_Location] ,
							XS.[Locality]  = T.[Locality],
							XS.[Continent]  = T.[Continent],
							XS.[Country]  = T.[Country],
							XS.[State]  = T.[State],
							XS.[Lat_Long]  = T.[Lat_Long],
							XS.MODIFIED_TS				= GETDATE(),
							XS.MODIFIED_BY				= CURRENT_USER
			WHEN NOT MATCHED THEN	-- else, we are inserting a new record
				INSERT (
					[Organism_ID] ,
					[CRIM_Num]  ,
					[Collection_Num] ,
					[Other_Nums] ,
					[Previous_Collection]  ,
					[Collector]  ,
					[Source_Type]  ,
					[Wild_Cultivated]  ,
					[Specimen_Description] ,
					[Heartwood_Sapwood] ,
					[Notes] ,
					[Color] ,
					[NFWFL_Analyzed] ,
					[Catalogued_By] ,
					[Sample_Location] ,
					[Locality] ,
					[Continent] ,
					[Country] ,
					[State] ,
					[Lat_Long],
					[CREATED_TS]			,
					[CREATED_BY]
					)
				VALUES (
					T.[Organism_ID] ,
					T.[CRIM_Num]  ,
					T.[Collection_Num] ,
					T.[Other_Nums] ,
					T.[Previous_Collection]  ,
					T.[Collector]  ,
					T.[Source_Type]  ,
					T.[Wild_Cultivated]  ,
					T.[Specimen_Description] ,
					T.[Heartwood_Sapwood] ,
					T.[Notes] ,
					T.[Color] ,
					T.[NFWFL_Analyzed] ,
					T.[Catalogued_By] ,
					T.[Sample_Location] ,
					T.[Locality] ,
					T.[Continent] ,
					T.[Country] ,
					T.[State] ,
					T.[Lat_Long],
					GETDATE()				,
					CURRENT_USER			
				);
	
		COMMIT TRAN CRIM_SPECIMEN_TO_FINAL;

	COMMIT TRAN FIND_AND_UPDATE_ORG_ID;	--locks on dbo.Criminalistics and dbo.Organism are released

	--@TODO: update what is returned to API
	select * from staging.Criminalistics;

END
GO

