USE [Lab_Reference_Data]
GO

/****** Object:  Table [staging].[Criminalistics]    Script Date: 7/30/2020 9:02:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [staging].[Criminalistics](
	[Specimen_ID] [varchar](20) NULL,
	[Organism_ID] [varchar](20) NULL,
	[CRIM_Num] [varchar](20) NOT NULL,
	[Collection_Num] [varchar](20) NULL,
	[Other_Nums] [varchar](20) NULL,
	[Previous_Collection] [varchar](50) NULL,
	[Collector] [varchar](50) NULL,
	[Source_Type] [varchar](50) NULL,
	[Wild_Cultivated] [varchar](20) NULL,
	[Specimen_Description] [varchar](100) NULL,
	[Heartwood_Sapwood] [varchar](20) NULL,
	[Notes] [varchar](max) NULL,
	[Color] [varchar](20) NULL,
	[NFWFL_Analyzed] [varchar](20) NULL,
	[Catalogued_By] [varchar](50) NULL,
	[Sample_Location] [varchar](max) NULL,
	[Locality] [varchar](max) NULL,
	[Continent] [varchar](200) NULL,
	[Country] [varchar](200) NULL,
	[State] [varchar](200) NULL,
	[Lat_Long] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

