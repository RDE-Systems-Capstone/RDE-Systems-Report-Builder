USE [MEDICALDATA]
GO
/****** Object:  Table [dbo].[saved_reports]    Script Date: 11/13/2018 1:03:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[saved_reports](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[query_string] [nvarchar](4000) NOT NULL,
	[report_type_string] [nvarchar](1000) NOT NULL,
	[username] [nvarchar](255) NOT NULL,
	[description] [nvarchar](4000) NULL,
 CONSTRAINT [PK_saved_reports] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[saved_reports] ON 

INSERT [dbo].[saved_reports] ([id], [name], [query_string], [report_type_string], [username], [description]) VALUES (1, N'Sample report 1', N'[{"type":"age","format":"between","min":20,"max":50},{"type":"and"},{"type":"gender","values":["M"]},{"type":"filter_string","string":"Age BETWEEN 20, 50 AND Gender: Male "}]', N'{"type":"bar","group_by":["GENDER","RACE"]}', N'christopher', NULL)
SET IDENTITY_INSERT [dbo].[saved_reports] OFF
