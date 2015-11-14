USE [Churn]

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'ChurnTable'))
BEGIN
CREATE TABLE [dbo].[ChurnTable](
	[X_dataobs_] [int] NULL,
	[State] [nvarchar](10) NULL,
	[Account_Length] [int] NULL,
	[Area_Code] [nvarchar](10) NULL,
	[Phone] [nvarchar](25) NULL,
	[Int_l_Plan] [nvarchar](10) NULL,
	[VMail_Plan] [nvarchar](10) NULL,
	[VMail_Message] [int] NULL,
	[Day_Mins] [float] NULL,
	[Day_Calls] [int] NULL,
	[Day_Charge] [float] NULL,
	[Eve_Mins] [float] NULL,
	[Eve_Calls] [int] NULL,
	[Eve_Charge] [float] NULL,
	[Night_Mins] [float] NULL,
	[Night_Calls] [int] NULL,
	[Night_Charge] [float] NULL,
	[Intl_Mins] [float] NULL,
	[Intl_Calls] [int] NULL,
	[Intl_Charge] [float] NULL,
	[CustServ_Calls] [int] NULL,
	[Churn_] [nvarchar](10) NULL
);
END

IF (NOT EXISTS (SELECT * FROM SYS.INDEXES 
                 WHERE NAME = 'IX_Churn'))
BEGIN
CREATE CLUSTERED INDEX [IX_Churn]
    ON [dbo].[ChurnTable]([State] ASC);
END

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = 'ChurnScores'))
BEGIN
CREATE TABLE [dbo].[ChurnScores](
	[X_dataobs_] [int] NULL,
	[State] [nvarchar](5) NULL,
	[Account_Length] [int] NULL,
	[Area_Code] [nvarchar](5) NULL,
	[Phone] [nvarchar](20) NULL,
	[Int_l_Plan] [nvarchar](5) NULL,
	[VMail_Plan] [nvarchar](5) NULL,
	[VMail_Message] [int] NULL,
	[Day_Mins] [float] NULL,
	[Day_Calls] [int] NULL,
	[Day_Charge] [float] NULL,
	[Eve_Mins] [float] NULL,
	[Eve_Calls] [int] NULL,
	[Eve_Charge] [float] NULL,
	[Night_Mins] [float] NULL,
	[Night_Calls] [int] NULL,
	[Night_Charge] [float] NULL,
	[Intl_Mins] [float] NULL,
	[Intl_Calls] [int] NULL,
	[Intl_Charge] [float] NULL,
	[CustServ_Calls] [float] NULL,
	[Churn_] [nvarchar](10) NULL,
	[ScoredLabels] [nvarchar](10) NULL,
	[ScoredProbabilities] [float] NULL
);
END

IF (NOT EXISTS (SELECT * FROM SYS.INDEXES 
                 WHERE NAME = 'IX_ChurnScores'))
BEGIN
CREATE CLUSTERED INDEX [IX_ChurnScores]
    ON [dbo].[ChurnScores]([State] ASC);
END

