USE [fwsdb_nfwfl_dev]
GO
/****** Object:  Table [dbo].[Physical_Storage_Location]    Script Date: 5/26/2020 1:38:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Physical_Storage_Location](
	[Location_ID] [int] IDENTITY(1,1) NOT NULL,
	[Location_Desc] [varchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Location_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Physical_Storage_Location] ON 

INSERT [dbo].[Physical_Storage_Location] ([Location_ID], [Location_Desc]) VALUES (-1, N'Unknown')
INSERT [dbo].[Physical_Storage_Location] ([Location_ID], [Location_Desc]) VALUES (1, N'Sliver Cabinet 1//Drawer 1//Row 1')
SET IDENTITY_INSERT [dbo].[Physical_Storage_Location] OFF
