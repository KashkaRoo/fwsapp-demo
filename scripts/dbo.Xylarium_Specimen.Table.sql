USE [fwsdb_nfwfl_dev]
GO
/****** Object:  Table [dbo].[Xylarium_Specimen]    Script Date: 5/26/2020 1:38:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Xylarium_Specimen](
	[Specimen_ID] [int] IDENTITY(1,1) NOT NULL,
	[Organism_ID] [int] NOT NULL,
	[NFWFL_Num] [varchar](20) NULL,
	[Collection_Num] [varchar](20) NULL,
	[Other_Nums] [varchar](20) NULL,
	[Previous_Designation] [varchar](50) NULL,
	[Eminent_Org] [varchar](50) NULL,
	[Collector] [varchar](50) NULL,
	[Source_Type] [varchar](50) NULL,
	[Location_ID] [int] NOT NULL,
	[Locality_ID] [int] NOT NULL,
	[Wild_Check] [bit] NOT NULL,
	[Specimen_Description] [varchar](100) NULL,
	[Heartwood_or_Sapwood] [varchar](20) NULL,
	[Notes] [varchar](max) NULL,
	[Color] [varchar](20) NULL,
	[NFWFL_Analyzed] [bit] NULL,
	[Catalogued_By] [varchar](50) NULL,
	[Identified_By] [varchar](50) NULL,
	[CREATED_TS] [datetime] NOT NULL,
	[CREATED_BY] [varchar](50) NOT NULL,
	[MODIFIED_TS] [datetime] NULL,
	[MODIFIED_BY] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Specimen_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Xylarium_Specimen] ON 

INSERT [dbo].[Xylarium_Specimen] ([Specimen_ID], [Organism_ID], [NFWFL_Num], [Collection_Num], [Other_Nums], [Previous_Designation], [Eminent_Org], [Collector], [Source_Type], [Location_ID], [Locality_ID], [Wild_Check], [Specimen_Description], [Heartwood_or_Sapwood], [Notes], [Color], [NFWFL_Analyzed], [Catalogued_By], [Identified_By], [CREATED_TS], [CREATED_BY], [MODIFIED_TS], [MODIFIED_BY]) VALUES (1, 277, N'D164962', N'MADw10537', NULL, NULL, NULL, N'unknown', N'Research Institute', 1, -1, 0, N'Sliver', NULL, N'-:Voucher: MER  VEN', NULL, 1, N'J French', NULL, CAST(N'2020-03-08T20:25:19.530' AS DateTime), N'fwsdb_fws_app', NULL, NULL)
INSERT [dbo].[Xylarium_Specimen] ([Specimen_ID], [Organism_ID], [NFWFL_Num], [Collection_Num], [Other_Nums], [Previous_Designation], [Eminent_Org], [Collector], [Source_Type], [Location_ID], [Locality_ID], [Wild_Check], [Specimen_Description], [Heartwood_or_Sapwood], [Notes], [Color], [NFWFL_Analyzed], [Catalogued_By], [Identified_By], [CREATED_TS], [CREATED_BY], [MODIFIED_TS], [MODIFIED_BY]) VALUES (2, 277, N'D164963', N'MADw1399', NULL, NULL, NULL, N'? 4', N'Research Institute', 1, -1, 0, N'Sliver', NULL, N'-:Voucher: F', NULL, 1, N'J French', NULL, CAST(N'2020-03-08T20:25:29.983' AS DateTime), N'fwsdb_fws_app', NULL, NULL)
INSERT [dbo].[Xylarium_Specimen] ([Specimen_ID], [Organism_ID], [NFWFL_Num], [Collection_Num], [Other_Nums], [Previous_Designation], [Eminent_Org], [Collector], [Source_Type], [Location_ID], [Locality_ID], [Wild_Check], [Specimen_Description], [Heartwood_or_Sapwood], [Notes], [Color], [NFWFL_Analyzed], [Catalogued_By], [Identified_By], [CREATED_TS], [CREATED_BY], [MODIFIED_TS], [MODIFIED_BY]) VALUES (3, 277, N'D164964', N'MADw1400', NULL, NULL, NULL, N'? 3', N'Research Institute', 1, -1, 0, N'Sliver', NULL, N'-:Voucher: F  NY  US', NULL, 1, N'J French', NULL, CAST(N'2020-03-08T20:25:29.983' AS DateTime), N'fwsdb_fws_app', NULL, NULL)
INSERT [dbo].[Xylarium_Specimen] ([Specimen_ID], [Organism_ID], [NFWFL_Num], [Collection_Num], [Other_Nums], [Previous_Designation], [Eminent_Org], [Collector], [Source_Type], [Location_ID], [Locality_ID], [Wild_Check], [Specimen_Description], [Heartwood_or_Sapwood], [Notes], [Color], [NFWFL_Analyzed], [Catalogued_By], [Identified_By], [CREATED_TS], [CREATED_BY], [MODIFIED_TS], [MODIFIED_BY]) VALUES (4, 277, N'D164965', N'MADw1401', NULL, NULL, NULL, N'? 2', N'Research Institute', 1, -1, 0, N'Sliver', NULL, N'-:Voucher: F', NULL, 1, N'J French', NULL, CAST(N'2020-03-08T20:25:29.983' AS DateTime), N'fwsdb_fws_app', NULL, NULL)
INSERT [dbo].[Xylarium_Specimen] ([Specimen_ID], [Organism_ID], [NFWFL_Num], [Collection_Num], [Other_Nums], [Previous_Designation], [Eminent_Org], [Collector], [Source_Type], [Location_ID], [Locality_ID], [Wild_Check], [Specimen_Description], [Heartwood_or_Sapwood], [Notes], [Color], [NFWFL_Analyzed], [Catalogued_By], [Identified_By], [CREATED_TS], [CREATED_BY], [MODIFIED_TS], [MODIFIED_BY]) VALUES (5, 277, N'D164966', N'MADw2444', NULL, NULL, NULL, NULL, N'Research Institute', 1, -1, 0, N'Sliver', NULL, N'-:Voucher: BR', NULL, 1, N'J French', NULL, CAST(N'2020-03-08T20:25:29.983' AS DateTime), N'fwsdb_fws_app', NULL, NULL)
INSERT [dbo].[Xylarium_Specimen] ([Specimen_ID], [Organism_ID], [NFWFL_Num], [Collection_Num], [Other_Nums], [Previous_Designation], [Eminent_Org], [Collector], [Source_Type], [Location_ID], [Locality_ID], [Wild_Check], [Specimen_Description], [Heartwood_or_Sapwood], [Notes], [Color], [NFWFL_Analyzed], [Catalogued_By], [Identified_By], [CREATED_TS], [CREATED_BY], [MODIFIED_TS], [MODIFIED_BY]) VALUES (6, 277, N'D164967', N'MADw39460', NULL, NULL, NULL, N'Mayer W.', N'Research Institute', 1, -1, 0, N'Sliver', NULL, N'-:Voucher: BR  LUA  LISC  MAD', NULL, 1, N'J French', NULL, CAST(N'2020-03-08T20:25:29.983' AS DateTime), N'fwsdb_fws_app', NULL, NULL)
INSERT [dbo].[Xylarium_Specimen] ([Specimen_ID], [Organism_ID], [NFWFL_Num], [Collection_Num], [Other_Nums], [Previous_Designation], [Eminent_Org], [Collector], [Source_Type], [Location_ID], [Locality_ID], [Wild_Check], [Specimen_Description], [Heartwood_or_Sapwood], [Notes], [Color], [NFWFL_Analyzed], [Catalogued_By], [Identified_By], [CREATED_TS], [CREATED_BY], [MODIFIED_TS], [MODIFIED_BY]) VALUES (7, 277, N'D164968', N'MADw7989', NULL, NULL, NULL, NULL, N'Research Institute', 1, -1, 0, N'Sliver', NULL, N'-:Voucher: BR  LUA  LISC  MAD', NULL, 1, N'J French', NULL, CAST(N'2020-03-08T20:25:29.983' AS DateTime), N'fwsdb_fws_app', NULL, NULL)
INSERT [dbo].[Xylarium_Specimen] ([Specimen_ID], [Organism_ID], [NFWFL_Num], [Collection_Num], [Other_Nums], [Previous_Designation], [Eminent_Org], [Collector], [Source_Type], [Location_ID], [Locality_ID], [Wild_Check], [Specimen_Description], [Heartwood_or_Sapwood], [Notes], [Color], [NFWFL_Analyzed], [Catalogued_By], [Identified_By], [CREATED_TS], [CREATED_BY], [MODIFIED_TS], [MODIFIED_BY]) VALUES (8, 277, N'D164969', N'MADw8014', NULL, NULL, NULL, NULL, N'Research Institute', 1, -1, 0, N'Sliver', NULL, N'-:Voucher: NONE', NULL, 1, N'J French', NULL, CAST(N'2020-03-08T20:25:29.983' AS DateTime), N'fwsdb_fws_app', NULL, NULL)
INSERT [dbo].[Xylarium_Specimen] ([Specimen_ID], [Organism_ID], [NFWFL_Num], [Collection_Num], [Other_Nums], [Previous_Designation], [Eminent_Org], [Collector], [Source_Type], [Location_ID], [Locality_ID], [Wild_Check], [Specimen_Description], [Heartwood_or_Sapwood], [Notes], [Color], [NFWFL_Analyzed], [Catalogued_By], [Identified_By], [CREATED_TS], [CREATED_BY], [MODIFIED_TS], [MODIFIED_BY]) VALUES (9, 277, N'D164970', N'MADw8068', NULL, NULL, NULL, NULL, N'Research Institute', 1, -1, 0, N'Sliver', NULL, N'-:Voucher: NY', NULL, 1, N'J French', NULL, CAST(N'2020-03-08T20:25:29.983' AS DateTime), N'fwsdb_fws_app', NULL, NULL)
INSERT [dbo].[Xylarium_Specimen] ([Specimen_ID], [Organism_ID], [NFWFL_Num], [Collection_Num], [Other_Nums], [Previous_Designation], [Eminent_Org], [Collector], [Source_Type], [Location_ID], [Locality_ID], [Wild_Check], [Specimen_Description], [Heartwood_or_Sapwood], [Notes], [Color], [NFWFL_Analyzed], [Catalogued_By], [Identified_By], [CREATED_TS], [CREATED_BY], [MODIFIED_TS], [MODIFIED_BY]) VALUES (10, 277, N'D164971', N'MADw8078', NULL, NULL, NULL, NULL, N'Research Institute', 1, -1, 0, N'Sliver', NULL, N'-:Voucher: NY', NULL, 1, N'J French', NULL, CAST(N'2020-03-08T20:25:29.983' AS DateTime), N'fwsdb_fws_app', NULL, NULL)
SET IDENTITY_INSERT [dbo].[Xylarium_Specimen] OFF
ALTER TABLE [dbo].[Xylarium_Specimen] ADD  DEFAULT ((0)) FOR [Wild_Check]
GO
ALTER TABLE [dbo].[Xylarium_Specimen] ADD  DEFAULT ((0)) FOR [NFWFL_Analyzed]
GO
ALTER TABLE [dbo].[Xylarium_Specimen] ADD  CONSTRAINT [DF_Xyl_Spec_Record_Added_TS]  DEFAULT (sysdatetime()) FOR [CREATED_TS]
GO
ALTER TABLE [dbo].[Xylarium_Specimen] ADD  CONSTRAINT [DF_Xyl_Spec_Record_Added_By]  DEFAULT (user_name()) FOR [CREATED_BY]
GO
ALTER TABLE [dbo].[Xylarium_Specimen]  WITH CHECK ADD FOREIGN KEY([Locality_ID])
REFERENCES [dbo].[Locality_of_Origin] ([Locality_ID])
GO
ALTER TABLE [dbo].[Xylarium_Specimen]  WITH CHECK ADD FOREIGN KEY([Location_ID])
REFERENCES [dbo].[Physical_Storage_Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Xylarium_Specimen]  WITH CHECK ADD FOREIGN KEY([Organism_ID])
REFERENCES [dbo].[Organism] ([Organism_ID])
GO
