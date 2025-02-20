USE [fwsdb_nfwfl_dev]
GO
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPaneCount' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_Xylarium_Organism_All'
GO
EXEC sys.sp_dropextendedproperty @name=N'MS_DiagramPane1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_Xylarium_Organism_All'
GO
/****** Object:  View [dbo].[VW_Xylarium_Organism_All]    Script Date: 5/26/2020 1:33:58 AM ******/
DROP VIEW [dbo].[VW_Xylarium_Organism_All]
GO
/****** Object:  View [dbo].[VW_Xylarium_Organism_All]    Script Date: 5/26/2020 1:33:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_Xylarium_Organism_All]
AS
SELECT        dbo.Locality_of_Origin.Locality_ID, dbo.Locality_of_Origin.Locality_Desc, dbo.Organism.Organism_ID, dbo.Organism.Class, dbo.Organism.Subclass, dbo.Organism.[Order], dbo.Organism.Suborder, dbo.Organism.Family, 
                         dbo.Organism.Subfamily, dbo.Organism.Genus, dbo.Organism.Subgenus, dbo.Organism.Previous_Designation, dbo.Organism.Common_Name, dbo.Organism.Variety, dbo.Organism.Subspecies, dbo.Organism.Species, 
                         dbo.Physical_Storage_Location.Location_Desc, dbo.Physical_Storage_Location.Location_ID, dbo.Xylarium_Specimen.Specimen_ID, dbo.Xylarium_Specimen.NFWFL_Num, dbo.Xylarium_Specimen.Collection_Num, 
                         dbo.Xylarium_Specimen.Other_Nums, dbo.Xylarium_Specimen.Previous_Designation AS Expr1, dbo.Xylarium_Specimen.Eminent_Org, dbo.Xylarium_Specimen.Collector, dbo.Xylarium_Specimen.Source_Type, 
                         dbo.Xylarium_Specimen.Wild_Check, dbo.Xylarium_Specimen.Specimen_Description, dbo.Xylarium_Specimen.Heartwood_or_Sapwood, dbo.Xylarium_Specimen.Notes, dbo.Xylarium_Specimen.Color, 
                         dbo.Xylarium_Specimen.NFWFL_Analyzed, dbo.Xylarium_Specimen.Catalogued_By, dbo.Xylarium_Specimen.Identified_By
FROM            dbo.Locality_of_Origin INNER JOIN
                         dbo.Xylarium_Specimen ON dbo.Locality_of_Origin.Locality_ID = dbo.Xylarium_Specimen.Locality_ID INNER JOIN
                         dbo.Organism ON dbo.Xylarium_Specimen.Organism_ID = dbo.Organism.Organism_ID INNER JOIN
                         dbo.Physical_Storage_Location ON dbo.Xylarium_Specimen.Location_ID = dbo.Physical_Storage_Location.Location_ID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[52] 4[26] 2[18] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Locality_of_Origin (dbo)"
            Begin Extent = 
               Top = 12
               Left = 76
               Bottom = 385
               Right = 351
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Xylarium_Specimen (dbo)"
            Begin Extent = 
               Top = 12
               Left = 1198
               Bottom = 491
               Right = 1571
            End
            DisplayFlags = 280
            TopColumn = 13
         End
         Begin Table = "Organism (dbo)"
            Begin Extent = 
               Top = 12
               Left = 427
               Bottom = 432
               Right = 771
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Physical_Storage_Location (dbo)"
            Begin Extent = 
               Top = 12
               Left = 847
               Bottom = 332
               Right = 1122
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_Xylarium_Organism_All'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_Xylarium_Organism_All'
GO
