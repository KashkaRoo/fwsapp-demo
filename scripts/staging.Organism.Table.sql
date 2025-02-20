USE [fwsdb_nfwfl_dev]
GO
/****** Object:  Table [staging].[Organism]    Script Date: 5/26/2020 1:38:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	[Previous_Designation] [varchar](200) NULL
) ON [PRIMARY]
GO
