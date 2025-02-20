USE [fwsdb_nfwfl_dev]
GO
/****** Object:  User [fwsdb_fws_app]    Script Date: 5/26/2020 1:33:58 AM ******/
DROP USER [fwsdb_fws_app]
GO
/****** Object:  User [fwsdb_fws_app]    Script Date: 5/26/2020 1:33:58 AM ******/
CREATE USER [fwsdb_fws_app] FOR LOGIN [fwsdb_fws_app] WITH DEFAULT_SCHEMA=[fwsdb_fws_app]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [fwsdb_fws_app]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [fwsdb_fws_app]
GO
ALTER ROLE [db_datareader] ADD MEMBER [fwsdb_fws_app]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [fwsdb_fws_app]
GO
