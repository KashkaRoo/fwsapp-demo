USE [Lab_Reference_Data]
GO

/****** Object:  StoredProcedure [dbo].[SP_Related_Organism]    Script Date: 7/30/2020 9:04:47 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Heather Rosa
-- Create date: 7/11/2020
-- Description:	Finding which table has organism ID and returning recordset in JSON of Specimen with that Organism ID
-- =============================================
ALTER PROCEDURE [dbo].[SP_Related_Organism]  
	-- Add the parameters for the stored procedure here
	@org_id [INT]
AS
BEGIN


		SELECT NFWFL_Num, REP_Num, Binomial_Nomenclature
		FROM dbo.Herpetology_Specimen as H
		JOIN dbo.Organism as O on H.Organism_ID = O.Organism_ID
		WHERE H.Organism_ID = @org_id

		SELECT WD_Num, Binomial_Nomenclature, Family
		FROM dbo.Xylarium_Specimen as X
		JOIN dbo.Organism as O on X.Organism_ID = O.Organism_ID
		WHERE X.Organism_ID = @org_id

		SELECT CRIM_Num, Binomial_Nomenclature, Family
		FROM dbo.Criminalistics as C
		JOIN dbo.Organism as O on C.Organism_ID = O.Organism_ID
		WHERE C.Organism_ID = @org_id
END
GO

