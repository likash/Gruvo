USE master;
GO
IF DB_ID('Gruvo') is not null
	BEGIN
		ALTER DATABASE Gruvo SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE Gruvo;
		CREATE DATABASE [Gruvo];
	END
ELSE
	BEGIN
		CREATE DATABASE [Gruvo];
	END

GO
USE [Gruvo]

CREATE TABLE [users](
	[UserId] [bigint] NOT NULL IDENTITY(1, 1),
	[Email] [varchar](60) NOT NULL,
	[Password] [varchar](256) NOT NULL,
	[Login] [nvarchar](80) NOT NULL,
	[RegDate] [date] NOT NULL,
	[DateOfBirth] [date] NULL,
	[About] [nvarchar](500) NULL,
 	CONSTRAINT [PK_users_UserId] PRIMARY KEY CLUSTERED([UserId]),
	CONSTRAINT [UQ_users_Email] UNIQUE ([Email]),
	CONSTRAINT [UQ_users_Login] UNIQUE ([Login])
	);

CREATE TABLE [posts](
	[PostId] [bigint] NOT NULL IDENTITY(1, 1),
	[UserId] [bigint] NOT NULL,
	[Message] [nvarchar](256) NOT NULL,
	[PostDate] [datetimeoffset] NOT NULL,
	CONSTRAINT [PK_posts_PostId] PRIMARY KEY CLUSTERED([PostId]),
	CONSTRAINT [FK_posts_UserId] FOREIGN KEY (UserId) REFERENCES [users]([UserId])
	ON UPDATE CASCADE
	ON DELETE CASCADE
	);

CREATE TABLE [subscriptions](
	[SubscriberId] [bigint] NOT NULL,
	[SubscribedId] [bigint] NOT NULL,
	[SubDate] [date] NOT NULL,
 	CONSTRAINT [PK_subscriptions] PRIMARY KEY CLUSTERED([SubscriberId], [SubscribedId]),
	CONSTRAINT [FK_subscriptions_SubscriberId] FOREIGN KEY ([SubscriberId]) REFERENCES [users]([UserId])
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	CONSTRAINT [FK_subscriptions_SubscribedId] FOREIGN KEY ([SubscribedId]) REFERENCES [users]([UserId])
	);
GO