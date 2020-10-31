IF OBJECT_ID('Sales.CreditCardView2', 'V') IS NOT NULL
	DROP VIEW Sales.CreditCardView2;
GO

--TaskA
CREATE VIEW Sales.CreditCardView2(
	CreditCardID,
	CardType,
	CardNumber,
	ExpMonth,
	ExpYear,
	ModifiedDate,
	BusinessEntityID,
	PersonModifiedDate) 
WITH ENCRYPTION, SCHEMABINDING
AS SELECT
	A.CreditCardID,
	A.CardType,
	A.CardNumber,
	A.ExpMonth,
	A.ExpYear,	
	A.ModifiedDate,
	B.BusinessEntityID,
	B.ModifiedDate
FROM Sales.CreditCard AS A 
INNER JOIN Sales.PersonCreditCard AS B
ON A.CreditCardID = B.CreditCardID;
GO

CREATE UNIQUE CLUSTERED INDEX AK_CreditCardView2_CreditCardID 
ON Sales.CreditCardView2 (CreditCardID);
GO

--TaskB
IF OBJECT_ID('Sales.TriggerInsteadInsert', 'TR') IS NOT NULL
	DROP TRIGGER Sales.TriggerInsteadInsert;
GO

CREATE TRIGGER Sales.TriggerInsteadInsert ON Sales.CreditCardView2
INSTEAD OF INSERT AS
BEGIN
	INSERT INTO Sales.CreditCard (CardNumber, CardType, ExpMonth, ExpYear, ModifiedDate)
	SELECT CardNumber, CardType, ExpMonth, ExpYear, ModifiedDate
	FROM inserted

	INSERT INTO Sales.PersonCreditCard (CreditCardID, BusinessEntityID, ModifiedDate)
	SELECT c.CreditCardID, BusinessEntityID, PersonModifiedDate
	FROM inserted i 
	INNER JOIN Sales.CreditCard c 
	ON i.CardNumber = c.CardNumber
END;
GO

IF OBJECT_ID('Sales.TriggerInsteadUpdate', 'TR') IS NOT NULL
	DROP TRIGGER Sales.TriggerInsteadUpdate;
GO

CREATE TRIGGER Sales.TriggerInsteadUpdate ON Sales.CreditCardView2
INSTEAD OF UPDATE AS
BEGIN
	UPDATE Sales.CreditCard SET
		CardNumber = inserted.CardNumber,
		CardType = inserted.CardType,
		ExpMonth = inserted.ExpMonth,
		ExpYear = inserted.ExpYear,
		ModifiedDate = inserted.ModifiedDate
	FROM inserted
	WHERE inserted.CreditCardID = Sales.CreditCard.CreditCardID
END;
GO

IF OBJECT_ID('Sales.TriggerInsteadDelete', 'TR') IS NOT NULL
	DROP TRIGGER Sales.TriggerInsteadDelete;
GO

CREATE TRIGGER Sales.TriggerInsteadDelete ON Sales.CreditCardView2
INSTEAD OF DELETE AS
BEGIN
	DELETE FROM Sales.PersonCreditCard 
	FROM Sales.PersonCreditCard p
	INNER JOIN deleted d
	ON p.BusinessEntityID = d.BusinessEntityID

	DELETE FROM Sales.CreditCard 
	FROM Sales.CreditCard c 
	INNER JOIN deleted d
	ON c.CreditCardID = d.CreditCardID
	LEFT JOIN Sales.PersonCreditCard p
	ON d.BusinessEntityID = p.BusinessEntityID
	WHERE p.CreditCardID IS NULL
END;
GO

--TaskC
INSERT INTO Sales.CreditCardView2 (
	CardNumber,
	CardType,
	ExpMonth,
	ExpYear,
	BusinessEntityID,
	ModifiedDate,
	PersonModifiedDate
) VALUES (
	'11111', 
	'TYPE1', 
	1, 
	2020, 
	1, 
	GetDate(), 
	GetDate()
);

--test
SELECT * FROM Sales.CreditCard AS A 
INNER JOIN Sales.PersonCreditCard AS B
ON A.CreditCardID = B.CreditCardID;
GO

UPDATE Sales.CreditCardView2 SET
	CardNumber = '22222',
	CardType = 'TYPE2',
	ExpMonth = 2,
	ExpYear = 2021,
	ModifiedDate = GetDate(),
	PersonModifiedDate = GetDate()
WHERE CardNumber = '11111';

--test
SELECT * FROM Sales.CreditCard AS A 
INNER JOIN Sales.PersonCreditCard AS B
ON A.CreditCardID = B.CreditCardID;
GO

DELETE FROM Sales.CreditCardView2 WHERE CardNumber = '22222';
GO

--test
SELECT * FROM Sales.PersonCreditCard;
SELECT * FROM Sales.CreditCard;
GO