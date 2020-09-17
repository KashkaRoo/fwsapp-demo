USE [Lab_Reference_Data]
GO

/****** Object:  Table [dbo].[Criminalistics]    Script Date: 7/30/2020 9:02:12 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Criminalistics](
	[Specimen_ID] [int] IDENTITY(1,1) NOT NULL,
	[Organism_ID] [int] NOT NULL,
	[CRIM_Num] [varchar](20) NOT NULL,
	[Collection_Num] [varchar](200) NULL,
	[Other_Nums] [varchar](200) NULL,
	[Previous_Collection] [varchar](max) NULL,
	[Collector] [varchar](200) NULL,
	[Source_Type] [varchar](50) NULL,
	[Wild_Cultivated] [varchar](20) NULL,
	[Specimen_Description] [varchar](100) NULL,
	[Heartwood_Sapwood] [varchar](20) NULL,
	[Notes] [varchar](max) NULL,
	[Color] [varchar](20) NULL,
	[NFWFL_Analyzed] [bit] NULL,
	[Catalogued_By] [varchar](50) NULL,
	[CREATED_TS] [datetime] NOT NULL,
	[CREATED_BY] [varchar](50) NOT NULL,
	[MODIFIED_TS] [datetime] NULL,
	[MODIFIED_BY] [varchar](50) NULL,
	[Sample_Location] [varchar](max) NULL,
	[Locality] [varchar](max) NULL,
	[Continent] [varchar](200) NULL,
	[Country] [varchar](200) NULL,
	[State] [varchar](200) NULL,
	[Lat_Long] [varchar](max) NULL,
 CONSTRAINT [PK__Criminalistics__36923FF49CD4E3E2] PRIMARY KEY CLUSTERED 
(
	[Specimen_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Criminalistics] ADD  CONSTRAINT [DF_Crim_Spec_Record_Added_TS]  DEFAULT (sysdatetime()) FOR [CREATED_TS]
GO

ALTER TABLE [dbo].[Criminalistics] ADD  CONSTRAINT [DF_Crim_Spec_Record_Added_By]  DEFAULT (user_name()) FOR [CREATED_BY]
GO

ALTER TABLE [dbo].[Criminalistics]  WITH CHECK ADD  CONSTRAINT [FK__Criminalistics___Organ__3493CFA7] FOREIGN KEY([Organism_ID])
REFERENCES [dbo].[Organism] ([Organism_ID])
GO

ALTER TABLE [dbo].[Criminalistics] CHECK CONSTRAINT [FK__Criminalistics___Organ__3493CFA7]
GO

ALTER TABLE [dbo].[Criminalistics]  WITH CHECK ADD  CONSTRAINT [FK__Criminalistics___Organ__395884C4] FOREIGN KEY([Organism_ID])
REFERENCES [dbo].[Organism] ([Organism_ID])
GO

ALTER TABLE [dbo].[Criminalistics] CHECK CONSTRAINT [FK__Criminalistics___Organ__395884C4]
GO

