/** Create tables and constraints */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/** Organism table and constraints*/
CREATE TABLE [dbo].[Organism](
	[Organism_ID] [int] IDENTITY(1,1) NOT NULL,
	[Class] [varchar](50) NULL,
	[Subclass] [varchar](50) NULL,
	[Order] [varchar](50) NULL,
	[Suborder] [varchar](50) NULL,
	[Family] [varchar](50) NULL,
	[Subfamily] [varchar](50) NULL,
	[Binomial_Nomenclature] [varchar](max) NULL,
	[Subgenus] [varchar](50) NULL,
	[Subspecies] [varchar](50) NULL,
	[Variety] [varchar](50) NULL,
	[Common_Name] [varchar](max) NULL,
	[Previous_Designation] [varchar](200) NULL,
	[CREATED_TS] [datetime] NULL DEFAULT GETDATE(),
	[CREATED_BY] [varchar](50) NULL DEFAULT USER_NAME(),
	[MODIFIED_TS] [datetime] NULL,
	[MODIFIED_BY] [varchar](50) NULL,
	CONSTRAINT [PK_Organism] PRIMARY KEY CLUSTERED 
	([Organism_ID] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/** Herpetology Specimen table and constraints */
CREATE TABLE [dbo].[Herpetology_Specimen](
	[Specimen_ID] [int] IDENTITY(1,1) NOT NULL,
	[Organism_ID] [int] NOT NULL,
	[Specimen_Sex] [char](1) NULL,
	[Specimen_Age] [varchar](50) NULL,
	[NFWFL_Num] [varchar](20) NULL,
	[REP_Num] [varchar](20) NULL,
	[Deaccessioned_To] [varchar](100) NULL,
	[Deaccessioned_Reason] [varchar](100) NULL,
	[Material] [varchar](100) NULL,
	[Prep_By] [varchar](100) NULL,
	[Specimen_Owner] [varchar](50) NULL,
	[Accession_Num] [varchar](20) NULL,
	[ESA] [varchar](50) NULL,
	[CITES] [varchar](50) NULL,
	[Document_Reference] [varchar](300) NULL,
	[CREATED_TS] [smalldatetime] NOT NULL DEFAULT GETDATE(),
	[CREATED_BY] [varchar](50) NOT NULL DEFAULT USER_NAME(),
	[MODIFIED_TS] [smalldatetime] NULL,
	[MODIFIED_BY] [varchar](50) NULL,
	[Location_Desc] [varchar](max) NULL,
	[Locality_Desc] [varchar](max) NULL
	CONSTRAINT [PK_Herpetology_Specimen] PRIMARY KEY CLUSTERED 
(
	[Specimen_ID] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[Herpetology_Specimen]  WITH CHECK ADD  CONSTRAINT [FK_Herpetology_Organism] FOREIGN KEY([Organism_ID])
REFERENCES [dbo].[Organism] ([Organism_ID])
GO

/** Xylarium Specimen table and constraints */
CREATE TABLE [dbo].[Xylarium_Specimen](
	[Specimen_ID] [int] IDENTITY(1,1) NOT NULL,
	[Organism_ID] [int] NOT NULL,
	[NFWFL_Num] [varchar](20) NULL,
	[Collection_Num] [varchar](200) NULL,
	[Other_Nums] [varchar](200) NULL,
	[Previous_Designation] [varchar](max) NULL,
	[Eminent_Org] [varchar](max) NULL,
	[Collector] [varchar](200) NULL,
	[Source_Type] [varchar](50) NULL,
	[Wild_Check] [bit] NOT NULL,
	[Specimen_Description] [varchar](100) NULL,
	[Heartwood_or_Sapwood] [varchar](20) NULL,
	[Notes] [varchar](max) NULL,
	[Color] [varchar](20) NULL,
	[NFWFL_Analyzed] [bit] NULL,
	[Catalogued_By] [varchar](50) NULL,
	[Identified_By] [varchar](50) NULL,
	[CREATED_TS] [datetime] NOT NULL DEFAULT GETDATE(),
	[CREATED_BY] [varchar](50) NOT NULL DEFAULT USER_NAME(),
	[MODIFIED_TS] [datetime] NULL,
	[MODIFIED_BY] [varchar](50) NULL,
	[Location_Desc] [varchar](max) NULL,
	[Locality_Desc] [varchar](max) NULL,
 CONSTRAINT [PK_Xylarium_Specimen] PRIMARY KEY CLUSTERED 
(
	[Specimen_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Xylarium_Specimen] ADD  CONSTRAINT [DF_Xylarium_Wild_Check]  DEFAULT ((0)) FOR [Wild_Check]
GO

ALTER TABLE [dbo].[Xylarium_Specimen] ADD  CONSTRAINT [DF_Xylarium_NFWFL_Analyzed]  DEFAULT ((0)) FOR [NFWFL_Analyzed]
GO

ALTER TABLE [dbo].[Xylarium_Specimen]  WITH CHECK ADD  CONSTRAINT [FK_Xylarium_Organism] FOREIGN KEY([Organism_ID])
REFERENCES [dbo].[Organism] ([Organism_ID])
GO

/** Tables for logging in stored procedure table */
CREATE TABLE [fwsdb_fws_app].[herp_temp_log](
	[Organism_ID] [varchar](20) NULL,
	[Specimen_ID] [varchar](20) NULL,
	[Specimen_Sex] [varchar](20) NULL,
	[Specimen_Age] [varchar](50) NULL,
	[NFWFL_Num] [varchar](20) NULL,
	[REP_Num] [varchar](20) NULL,
	[Deaccessioned_To] [varchar](100) NULL,
	[Deaccessioned_Reason] [varchar](100) NULL,
	[Material] [varchar](100) NULL,
	[Prep_By] [varchar](100) NULL,
	[Location_Desc] [varchar](20) NULL,
	[Specimen_Owner] [varchar](50) NULL,
	[Accession_Num] [varchar](20) NULL,
	[Locality_Desc] [varchar](20) NULL,
	[ESA] [varchar](50) NULL,
	[CITES] [varchar](50) NULL,
	[Document_Reference] [varchar](300) NULL,
	[Class] [varchar](50) NULL,
	[Subclass] [varchar](50) NULL,
	[Order] [varchar](50) NULL,
	[Suborder] [varchar](50) NULL,
	[Family] [varchar](50) NULL,
	[Subfamily] [varchar](50) NULL,
	[Genus] [varchar](50) NULL,
	[Subgenus] [varchar](50) NULL,
	[Species] [varchar](50) NULL,
	[Subspecies] [varchar](50) NULL,
	[Variety] [varchar](50) NULL,
	[Common_Name] [varchar](50) NULL,
	[Previous_Designation] [varchar](200) NULL,
	[TS] [datetime] NULL DEFAULT GETDATE()
) ON [PRIMARY]
GO

CREATE TABLE [fwsdb_fws_app].[cursor_log](
	[class] [varchar](50) NULL,
	[subclass] [varchar](50) NULL,
	[order] [varchar](50) NULL,
	[suborder] [varchar](50) NULL,
	[family] [varchar](50) NULL,
	[subfamily] [varchar](50) NULL,
	[genus] [varchar](50) NULL,
	[subgenus] [varchar](50) NULL,
	[species] [varchar](50) NULL,
	[subspecies] [varchar](50) NULL,
	[variety] [varchar](50) NULL,
	[common] [varchar](50) NULL,
	[prev] [varchar](200) NULL,
	[TS] [datetime] NULL DEFAULT GETDATE(),
	[orgid] [varchar](20) NULL
) ON [PRIMARY]
GO

/** Organism staging table and constraints */
CREATE TABLE [staging].[Organism](
	[Organism_ID] [int] NULL,
	[Class] [varchar](50) NULL,
	[Subclass] [varchar](50) NULL,
	[Order] [varchar](50) NULL,
	[Suborder] [varchar](50) NULL,
	[Family] [varchar](50) NULL,
	[Subfamily] [varchar](50) NULL,
	[Genus] [varchar](50) NULL,
	[Subgenus] [varchar](50) NULL,
	[Species] [varchar](50) NULL,
	[Subspecies] [varchar](50) NULL,
	[Variety] [varchar](50) NULL,
	[Common_Name] [varchar](50) NULL,
	[Previous_Designation] [varchar](200) NULL,
	[Binomial_Nomenclature] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/** Herpetology Specimen staging table and constraints */
CREATE TABLE [staging].[Herpetology_Specimen](
	[Specimen_ID] [varchar](20) NULL,
	[Organism_ID] [varchar](20) NULL,
	[Specimen_Sex] [char](1) NULL,
	[Specimen_Age] [varchar](50) NULL,
	[NFWFL_Num] [varchar](20) NULL,
	[REP_Num] [varchar](20) NULL,
	[Deaccessioned_To] [varchar](100) NULL,
	[Deaccessioned_Reason] [varchar](100) NULL,
	[Material] [varchar](100) NULL,
	[Prep_By] [varchar](100) NULL,
	[Specimen_Owner] [varchar](50) NULL,
	[Accession_Num] [varchar](20) NULL,
	[ESA] [varchar](50) NULL,
	[CITES] [varchar](50) NULL,
	[Document_Reference] [varchar](300) NULL,
	[Location_Desc] [varchar](max) NULL,
	[Locality_Desc] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/** Xylarium Specimen staging table and constraints */
CREATE TABLE [staging].[Xylarium_Specimen](
	[Specimen_ID] [varchar](20) NULL,
	[Organism_ID] [varchar](20) NULL,
	[NFWFL_Num] [varchar](20) NULL,
	[Collection_Num] [varchar](20) NULL,
	[Other_Nums] [varchar](20) NULL,
	[Previous_Designation] [varchar](50) NULL,
	[Eminent_Org] [varchar](50) NULL,
	[Collector] [varchar](50) NULL,
	[Source_Type] [varchar](50) NULL,
	[Wild_Check] [varchar](20) NULL,
	[Specimen_Description] [varchar](100) NULL,
	[Heartwood_or_Sapwood] [varchar](20) NULL,
	[Notes] [varchar](max) NULL,
	[Color] [varchar](20) NULL,
	[NFWFL_Analyzed] [varchar](20) NULL,
	[Catalogued_By] [varchar](50) NULL,
	[Identified_By] [varchar](50) NULL,
	[Location_Desc] [varchar](max) NULL,
	[Locality_Desc] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/** Organism History table and constraints */
CREATE TABLE [dbo].[Organism_History](
	[Previous_Class] [varchar](50) NULL,
	[Previous_Subclass] [varchar](50) NULL,
	[Previous_Order] [varchar](50) NULL,
	[Previous_Suborder] [varchar](50) NULL,
	[Previous_Family] [varchar](50) NULL,
	[Previous_Subfamily] [varchar](50) NULL,
	[Previous_Binom] [varchar](max) NULL,
	[Previous_Subgenus] [varchar](50) NULL,
	[Previous_Subspecies] [varchar](50) NULL,
	[Previous_Variety] [varchar](50) NULL,
	[Previous_Common_Name] [varchar](50) NULL,
	[Previous_Previous_Designation] [varchar](200) NULL,
	[New_Class] [varchar](50) NULL,
	[New_Subclass] [varchar](50) NULL,
	[New_Order] [varchar](50) NULL,
	[New_Suborder] [varchar](50) NULL,
	[New_Family] [varchar](50) NULL,
	[New_Subfamily] [varchar](50) NULL,
	[New_Binomial] [varchar](max) NULL,
	[New_Subgenus] [varchar](50) NULL,
	[New_Subspecies] [varchar](50) NULL,
	[New_Variety] [varchar](50) NULL,
	[New_Common_Name] [varchar](50) NULL,
	[New_Previous_Designation] [varchar](200) NULL,
	[CREATED_TS] [datetime] NULL DEFAULT GETDATE(),
	[CREATED_BY] [varchar](50) NULL DEFAULT USER_NAME(),
	[MODIFIED_TS] [datetime] NULL,
	[MODIFIED_BY] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


