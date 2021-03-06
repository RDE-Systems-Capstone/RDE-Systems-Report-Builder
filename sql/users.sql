USE [MEDICALDATA]
GO
/****** Object:  Table [dbo].[users]    Script Date: 11/17/2018 2:36:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[username] [nvarchar](255) NOT NULL,
	[password] [nvarchar](255) NOT NULL,
	[firstName] [nvarchar](255) NOT NULL,
	[lastname] [nvarchar](255) NOT NULL,
	[role] [nvarchar](50) NULL,
	[salt] [nvarchar](250) NULL,
	[hash] [nvarchar](250) NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK__users__F3DBC5734B2082D9] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[users] ON 

INSERT [dbo].[users] ([username], [password], [firstName], [lastname], [role], [salt], [hash], [id]) VALUES (N'username', N'0CMBPhU0MT+2ifBpmmBD/g==', N'John', N'Doe', N'1', N'ZFchv7xKJZYQTjDttAtZ9sH9Q65qpkQqMwWHptUYv6vdxxdbtGMdaHfXEMYHefza', NULL, 1)
SET IDENTITY_INSERT [dbo].[users] OFF
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_users]    Script Date: 11/17/2018 2:36:01 PM ******/
ALTER TABLE [dbo].[users] ADD  CONSTRAINT [IX_users] UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
