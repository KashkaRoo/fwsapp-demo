USE [fwsdb_nfwfl_dev]
GO
/****** Object:  Table [fwsdb_fws_app].[Test_Table]    Script Date: 5/26/2020 1:38:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [fwsdb_fws_app].[Test_Table](
	[Test_Column_1] [nchar](10) NULL,
	[Test_Column_2] [varchar](50) NULL,
	[Test_Columns_3] [ntext] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
