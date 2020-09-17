/** Create user and schemas */

/** Per Brad, user should be pre-created on NFWFL side, but this query is for testing. 
	Please note the API will need to be updated to include the correct log in information in the following files:
		api/routes/xyRoute.js
		api/routes/herpRoute.js
		api/routes/organismRoute.js
	At the top of each file, the dbConfig variable needs to be updated with the user, password, server, and database name.
*/
--GO
--CREATE USER [lab_collection_user] FOR LOGIN [lab_collection_user] WITH DEFAULT_SCHEMA=[dbo]

CREATE SCHEMA [dbo]
	AUTHORIZATION lab_collection_user
GO

CREATE SCHEMA [fwsdb_fws_app]
	AUTHORIZATION lab_collection_user
GO

CREATE SCHEMA [staging]
	AUTHORIZATION lab_collection_user
GO

