--TaskA
ALTER TABLE dbo.Employee
ADD SumTotal money, 
SumTaxAmt money, 
WithoutTax AS (SumTotal - SumTaxAmt);
GO

--test
SELECT * FROM dbo.Employee;
GO

--TaskB
CREATE TABLE #Employee(
	BusinessEntityID int not null PRIMARY KEY,
	NationalIDNumber nvarchar(15) not null,
	LoginID nvarchar(256) not null,
	JobTitle nvarchar(50) not null,
	BirthDate date not null,
	MaritalStatus nchar(1) not null,
	Gender nchar(1) not null,
	HireDate date not null,
	VacationHours smallint not null,
	SickLeaveHours smallint not null,
	ModifiedDate datetime,
	SumTotal money,
	SumTaxAmt money
);
GO

--TaskC
INSERT #Employee SELECT  
	BusinessEntityID, 
	NationalIDNumber, 
	LoginID,
	JobTitle,
	BirthDate,
	MaritalStatus,
	Gender,
	HireDate,
	VacationHours,
	SickLeaveHours,
	ModifiedDate,
	SumTotal,
	SumTaxAmt
FROM dbo.Employee;
GO

WITH Sum_CTE (BusinessEntityID, SumDue, SumTax)  
AS (  
    SELECT BusinessEntityID, SUM(TotalDue), SUM(TaxAmt)  
    FROM dbo.Employee
	INNER JOIN Purchasing.PurchaseOrderHeader 
	ON BusinessEntityID = EmployeeID 
	GROUP BY BusinessEntityID
) 

UPDATE #Employee 
SET SumTotal = SumDue,
	SumTaxAmt = SumTax 
FROM Sum_CTE
WHERE #Employee.BusinessEntityID = Sum_CTE.BusinessEntityID 
AND SumDue > 5000000;
GO

--test
SELECT * FROM #Employee;
GO

--TaskD
DELETE FROM dbo.Employee 
WHERE MaritalStatus = 'S';

--test
SELECT * FROM dbo.Employee;
GO

--TaskE
MERGE INTO dbo.Employee
USING #Employee
ON dbo.Employee.BusinessEntityID = #Employee.BusinessEntityID
WHEN MATCHED THEN 
UPDATE SET 
	SumTotal = #Employee.SumTotal,
	SumTaxAmt = #Employee.SumTaxAmt
WHEN NOT MATCHED BY TARGET THEN	
INSERT VALUES(
	#Employee.BusinessEntityID,
	#Employee.NationalIDNumber,
	#Employee.LoginID,
	#Employee.JobTitle,
	#Employee.BirthDate,
	#Employee.MaritalStatus,
	#Employee.Gender,
	#Employee.HireDate,
	#Employee.VacationHours,
	#Employee.SickLeaveHours,
	#Employee.ModifiedDate,
	#Employee.SumTotal,
	#Employee.SumTaxAmt)
WHEN NOT MATCHED BY SOURCE THEN 
DELETE;
GO

--test
SELECT * FROM dbo.Employee;
GO

DROP TABLE #Employee;
GO