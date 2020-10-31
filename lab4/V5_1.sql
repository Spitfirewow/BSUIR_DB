IF OBJECT_ID('Sales.CreditCardHst', 'U') IS NOT NULL
	DROP TABLE Sales.CreditCardHst;
GO

--TaskA
CREATE TABLE Sales.CreditCardHst (
	ID int IDENTITY(1, 1) PRIMARY KEY,
	Action char(3) NOT NULL,
	ModifiedDate datetime NOT NULL,
	SourceID int NOT NULL,
	UserName varchar(30) NOT NULL
);
GO

IF OBJECT_ID('Sales.CreditCartTrigger', 'TR') IS NOT NULL
	DROP TRIGGER Sales.CreditCartTrigger;
GO

--TaskB
CREATE TRIGGER Sales.CreditCartTrigger
ON Sales.CreditCard
AFTER INSERT, UPDATE, DELETE AS
	INSERT INTO Sales.CreditCardHst (
	Action, 
	SourceID,
	ModifiedDate,  
	UserName)
	SELECT
		CASE 
			WHEN deleted.CreditCardID IS NULL  THEN 'INS'
			WHEN inserted.CreditCardID IS NULL THEN 'DEL'
			ELSE 'UPD'
		END,
		CASE 
			WHEN deleted.CreditCardID IS NULL THEN inserted.CreditCardID
			ELSE deleted.CreditCardID
		END,
	GetDate(),
	User_Name()
	FROM deleted FULL OUTER JOIN inserted
	ON deleted.CreditCardID = inserted.CreditCardID;
GO

IF OBJECT_ID('Sales.CreditCardView1', 'V') IS NOT NULL
	DROP VIEW Sales.CreditCardView1;
GO

--TaskC
CREATE VIEW Sales.CreditCardView1 AS 
SELECT * FROM Sales.CreditCard;
GO

--TaskD
INSERT INTO Sales.CreditCardView1 (
	CardNumber, 
	CardType, 
	ExpMonth, 
	ExpYear, 
	ModifiedDate)
VALUES (
	'111111', 
	'TEST1', 
	1, 
	2019, 
	GetDate()
);

UPDATE Sales.CreditCardView1
SET CardType = 'TEST2' 
WHERE CardNumber = '111111';

DELETE Sales.CreditCardView1
WHERE CardNumber = '111111';

--test
SELECT * FROM Sales.CreditCardHst;