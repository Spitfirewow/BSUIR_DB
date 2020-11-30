--TaskA
IF OBJECT_ID('Production.GetSumPriceOfProduct', 'FN') IS NOT NULL
	DROP FUNCTION Production.GetSumPriceOfProduct;
GO

CREATE FUNCTION Production.GetSumPriceOfProduct(@id int)
RETURNS money
AS
BEGIN
	DECLARE @result money
	SELECT @result = Sum(Product.ListPrice)
	FROM Production.Product
	WHERE Product.ProductModelID = @id
	RETURN @result
END;
GO

--test
SELECT *
FROM Production.Product
WHERE Product.ProductModelID = 22

SELECT Production.GetSumPriceOfProduct(22) AS 'TOTAL'
GO

--TaskB
IF OBJECT_ID('Sales.GetLastOrdersByCustomer', 'TF') IS NOT NULL
	DROP FUNCTION Sales.GetLastOrdersByCustomer;
GO

CREATE FUNCTION Sales.GetLastOrdersByCustomer(@id int)
RETURNS TABLE AS RETURN (
	SELECT TOP(2) *
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = @id
	ORDER BY OrderDate DESC
);
GO

--TaskC
SELECT * FROM Sales.Customer 
CROSS APPLY Sales.GetLastOrdersByCustomer(CustomerID);
GO

SELECT * FROM Sales.Customer 
OUTER APPLY Sales.GetLastOrdersByCustomer(CustomerID);
GO

--TaskD
IF OBJECT_ID('Sales.GetLastOrdersByCustomer', 'IF') IS NOT NULL
	DROP FUNCTION Sales.GetLastOrdersByCustomer;
GO

CREATE FUNCTION Sales.GetLastOrdersByCustomer(@id int)
RETURNS @result TABLE(
	SalesOrderID int NOT NULL,
	RevisionNumber tinyint NOT NULL,
	OrderDate datetime NOT NULL,
	DueDate datetime NOT NULL,
	ShipDate datetime NULL,
	Status tinyint NOT NULL,
	OnlineOrderFlag dbo.Flag NOT NULL,
	SalesOrderNumber nvarchar(23),
	PurchaseOrderNumber dbo.OrderNumber NULL,
	AccountNumber dbo.AccountNumber NULL,
	CustomerID int NOT NULL,
	SalesPersonID int NULL,
	TerritoryID int NULL,
	BillToAddressID int NOT NULL,
	ShipToAddressID int NOT NULL,
	ShipMethodID int NOT NULL,
	CreditCardID int NULL,
	CreditCardApprovalCode varchar(15) NULL,
	CurrencyRateID int NULL,
	SubTotal money NOT NULL ,
	TaxAmt money NOT NULL,
	Freight money NOT NULL,
	TotalDue int NOT NULL,
	Comment nvarchar(128) NULL,
	rowguid UNIQUEIDENTIFIER rowguidcol NOT NULL,
	ModifiedDate datetime NOT NULL
) AS BEGIN
	INSERT INTO @result
	SELECT TOP(2) *
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = @id
	ORDER BY OrderDate DESC
	RETURN
END;
GO

--test
SELECT * FROM Sales.Customer 
CROSS APPLY Sales.GetLastOrdersByCustomer(CustomerID);
GO

SELECT * FROM Sales.Customer 
OUTER APPLY Sales.GetLastOrdersByCustomer(CustomerID);
GO