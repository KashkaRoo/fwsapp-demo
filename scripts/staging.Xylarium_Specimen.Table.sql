USE [fwsdb_nfwfl_dev]
GO
/****** Object:  Table [staging].[Xylarium_Specimen]    Script Date: 5/26/2020 1:38:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	[Location_ID] [varchar](20) NULL,
	[Locality_ID] [varchar](20) NULL,
	[Wild_Check] [varchar](20) NULL,
	[Specimen_Description] [varchar](100) NULL,
	[Heartwood_or_Sapwood] [varchar](20) NULL,
	[Notes] [varchar](max) NULL,
	[Color] [varchar](20) NULL,
	[NFWFL_Analyzed] [varchar](20) NULL,
	[Catalogued_By] [varchar](50) NULL,
	[Identified_By] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
