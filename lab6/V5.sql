IF OBJECT_ID('Purchasing.CountOfOrdersByShipMethod', 'P') IS NOT NULL
	DROP PROCEDURE Purchasing.CountOfOrdersByShipMethod;
GO

--Shipping methods
SELECT Name FROM Purchasing.ShipMethod
GO

--Task
CREATE PROCEDURE Purchasing.CountOfOrdersByShipMethod(@Methods NVARCHAR(200)) AS
	DECLARE @Query AS NVARCHAR(400);
	SET @Query = 
	'SELECT *
	FROM (
		SELECT EmployeeID, PurchaseOrderID, Name 
		FROM Purchasing.PurchaseOrderHeader 
		INNER JOIN Purchasing.ShipMethod
		ON Purchasing.PurchaseOrderHeader.ShipMethodID = Purchasing.ShipMethod.ShipMethodID
	) AS tab
	PIVOT (COUNT(PurchaseOrderID) FOR tab.Name IN(' + @Methods + ')) AS pvt'
    EXECUTE sp_executesql @Query
GO

EXECUTE Purchasing.CountOfOrdersByShipMethod '[CARGO TRANSPORT 5],[OVERNIGHT J-FAST],[OVERSEAS - DELUXE]';
GO