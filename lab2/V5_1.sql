--Task1

USE AdventureWorks2012
GO

SELECT DISTINCT
	Employee.BusinessEntityID,
	JobTitle,
	Name,
	StartTime,
	EndTime
FROM
	AdventureWorks2012.HumanResources.Employee
	INNER JOIN AdventureWorks2012.HumanResources.EmployeeDepartmentHistory
	ON Employee.BusinessEntityID = EmployeeDepartmentHistory.BusinessEntityID
	INNER JOIN AdventureWorks2012.HumanResources.Shift
	ON EmployeeDepartmentHistory.ShiftID = Shift.ShiftID

--Task2

SELECT
	GroupName,
	COUNT(EmployeeDepartmentHistory.BusinessEntityID) as EmpCount
FROM
	AdventureWorks2012.HumanResources.Department
	INNER JOIN AdventureWorks2012.HumanResources.EmployeeDepartmentHistory
	ON EmployeeDepartmentHistory.DepartmentID = Department.DepartmentID
	WHERE
		EmployeeDepartmentHistory.EndDate is NULL
GROUP BY
	GroupName;

--Task3

SELECT
	Name,
	EmployeeDepartmentHistory.BusinessEntityID,
	Rate,
	MAX(Rate) OVER(PARTITION BY Department.DepartmentID) as MaxInDepartment,
	DENSE_RANK()
	OVER(PARTITION BY Name ORDER BY Rate ASC) AS RateGroup
FROM
	AdventureWorks2012.HumanResources.Department
	INNER JOIN AdventureWorks2012.HumanResources.EmployeeDepartmentHistory
	ON EmployeeDepartmentHistory.DepartmentID = Department.DepartmentID
	INNER JOIN AdventureWorks2012.HumanResources.EmployeePayHistory
	ON EmployeePayHistory.BusinessEntityID = EmployeeDepartmentHistory.BusinessEntityID
GROUP BY
	Name, EmployeeDepartmentHistory.BusinessEntityID, Rate, Department.DepartmentID
ORDER BY
	Name, Rate