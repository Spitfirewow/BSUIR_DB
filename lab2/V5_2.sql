--TaskA

USE AdventureWorks2012;
GO

CREATE TABLE dbo.Employee (
	  BusinessEntityID        INT			NOT NULL
	, NationalIDNumber        nvarchar(15)	NOT NULL
	, LoginID				  nvarchar(256)	NOT NULL
	, JobTitle				  nvarchar(50)  NOT NULL
	, BirthDate				  date			NOT NULL
	, MaritalStatus			  nchar(1)		NOT NULL
	, Gender				  nchar(1)		NOT NULL
	, HireDate				  date			NOT NULL
	, VacationHours			  smallint		NOT NULL
	, SickLeaveHours		  smallint		NOT NULL
	, ModifiedDate			  datetime		NOT NULL
	);	

--TaskB

ALTER TABLE dbo.Employee
ADD UNIQUE (NationalIDNumber);

--TaskC

GO  

CREATE FUNCTION dbo.MoreThanZero(@value smallint)  
RETURNS bit  
AS   
BEGIN  
	IF(@value > 0)
		RETURN 1;
	RETURN 0;
END;  
GO

ALTER TABLE dbo.Employee
	ADD CONSTRAINT VacationHoursCheck
		CHECK (dbo.MoreThanZero(VacationHours) = 1);

--TaskD

ALTER TABLE dbo.Employee
	ADD CONSTRAINT df_VacationHours
		DEFAULT 144 FOR VacationHours;

--TaskE

INSERT INTO dbo.Employee (
	  BusinessEntityID
	, NationalIDNumber
	, LoginID
	, JobTitle
	, BirthDate
	, MaritalStatus
	, Gender
	, HireDate
	, SickLeaveHours
	, ModifiedDate
	)
	SELECT
		  BusinessEntityID
		, NationalIDNumber
		, LoginID
		, JobTitle
		, BirthDate
		, MaritalStatus
		, Gender
		, HireDate
		, SickLeaveHours
		, ModifiedDate
	FROM 
		AdventureWorks2012.HumanResources.Employee
		WHERE
			JobTitle = 'Buyer'

--TaskF

ALTER TABLE dbo.Employee
	ALTER COLUMN ModifiedDate date NULL;