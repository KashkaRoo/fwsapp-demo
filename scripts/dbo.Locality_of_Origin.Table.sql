USE [fwsdb_nfwfl_dev]
GO
/****** Object:  Table [dbo].[Locality_of_Origin]    Script Date: 5/26/2020 1:38:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Locality_of_Origin](
	[Locality_ID] [int] IDENTITY(1,1) NOT NULL,
	[Locality_Desc] [varchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Locality_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Locality_of_Origin] ON 

INSERT [dbo].[Locality_of_Origin] ([Locality_ID], [Locality_Desc]) VALUES (-1, N'Unknown')
SET IDENTITY_INSERT [dbo].[Locality_of_Origin] OFF
