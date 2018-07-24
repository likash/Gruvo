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
	[Login] [varchar](80) NOT NULL,
	[RegDate] [date] NOT NULL,
	[DateOfBirth] [date] NULL,
	[About] [varchar](500) NULL,
 	CONSTRAINT [PK_users_UserId] PRIMARY KEY CLUSTERED([UserId]),
	CONSTRAINT [UQ_users_Email] UNIQUE ([Email]),
	CONSTRAINT [UQ_users_Login] UNIQUE ([Login])
	);

CREATE TABLE [posts](
	[PostId] [bigint] NOT NULL IDENTITY(1, 1),
	[UserId] [bigint] NOT NULL,
	[Message] [varchar](256) NOT NULL,
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
 	CONSTRAINT [PK_subscriptions_SubscriberId_SubscribedId] PRIMARY KEY CLUSTERED([SubscriberId],[SubscribedId]),
	CONSTRAINT [FK_subscriptions_SubscriberId] FOREIGN KEY ([SubscriberId]) REFERENCES [users]([UserId]),
	CONSTRAINT [FK_subscriptions_SubscribedId] FOREIGN KEY ([SubscribedId]) REFERENCES [users]([UserId]),
	CONSTRAINT [CHK_subscriptions_DifferId] CHECK (SubscriberId <> SubscribedId)
	);
GO

CREATE TRIGGER UsersDELETE
ON [users]
AFTER DELETE
AS
BEGIN
	DELETE FROM [subscriptions]
	WHERE (SubscriberId = (SELECT UserId FROM deleted) OR 
		   SubscribedId = (SELECT UserId FROM deleted)
		   )
END
GO

CREATE TRIGGER UsersUPDATE
ON [users]
AFTER UPDATE
AS 
BEGIN
IF UPDATE(UserId)
	UPDATE subscriptions
	SET SubscriberId = (SELECT UserId FROM inserted)
	WHERE SubscriberId = (SELECT UserId FROM deleted)

	UPDATE subscriptions
	SET SubscribedId = (SELECT UserId FROM inserted)
	WHERE SubscribedId = (SELECT UserId FROM deleted)
END 
GO