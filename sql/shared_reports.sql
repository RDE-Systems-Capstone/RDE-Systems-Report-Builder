USE [MEDICALDATA]
GO
/****** Object:  Table [dbo].[shared_reports]    Script Date: 11/17/2018 2:25:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[shared_reports](
	[report_id] [int] NOT NULL,
	[shared_with] [nvarchar](255) NOT NULL,
	[share_id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_shared_reports] PRIMARY KEY CLUSTERED 
(
	[share_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[shared_reports]  WITH CHECK ADD  CONSTRAINT [FK_shared_reports_saved_reports] FOREIGN KEY([report_id])
REFERENCES [dbo].[saved_reports] ([id])
GO
ALTER TABLE [dbo].[shared_reports] CHECK CONSTRAINT [FK_shared_reports_saved_reports]
GO
