USE [fwsdb_nfwfl_dev]
GO
/****** Object:  Table [staging].[Herpetology_Specimen]    Script Date: 5/26/2020 1:38:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[Herpetology_Specimen](
	[Specimen_ID] [varchar](20) NULL,
	[Organism_ID] [varchar](20) NULL,
	[Specimen_Sex] [varchar](20) NULL,
	[Specimen_Age] [varchar](50) NULL,
	[NFWFL_Num] [varchar](20) NULL,
	[REP_Num] [varchar](20) NULL,
	[Deaccessioned_To] [varchar](100) NULL,
	[Deaccessioned_Reason] [varchar](100) NULL,
	[Material] [varchar](100) NULL,
	[Prep_By] [varchar](100) NULL,
	[Location_ID] [varchar](20) NULL,
	[Specimen_Owner] [varchar](50) NULL,
	[Accession_Num] [varchar](20) NULL,
	[Locality_ID] [varchar](20) NULL,
	[ESA] [varchar](50) NULL,
	[CITES] [varchar](50) NULL,
	[Document_Reference] [varchar](300) NULL
) ON [PRIMARY]
GO
INSERT [staging].[Herpetology_Specimen] ([Specimen_ID], [Organism_ID], [Specimen_Sex], [Specimen_Age], [NFWFL_Num], [REP_Num], [Deaccessioned_To], [Deaccessioned_Reason], [Material], [Prep_By], [Location_ID], [Specimen_Owner], [Accession_Num], [Locality_ID], [ESA], [CITES], [Document_Reference]) VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Teeeest', NULL, NULL, NULL, NULL)
