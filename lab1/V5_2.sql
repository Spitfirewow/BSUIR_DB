--Task1

USE AdventureWorks2012
GO

SELECT 
	  Name
	, GroupName
FROM
	AdventureWorks2012.HumanResources.Department
WHERE
	GroupName = 'Research and Development'
ORDER BY
	Name
	ASC;

--Task2

SELECT TOP 1
	SickLeaveHours as MinSickLeaveHours
FROM
	AdventureWorks2012.HumanResources.Employee
ORDER BY
	SickLeaveHours
	ASC;

--Task3

SELECT DISTINCT
	JobTitle,
	left(JobTitle,charindex(' ',concat(JobTitle, ' '))) as FirstWord
FROM
	AdventureWorks2012.HumanResources.Employee
ORDER BY
	JobTitle
	ASC;