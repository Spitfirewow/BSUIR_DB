--TaskA
DECLARE @xml XML;

SET @xml = (
	SELECT
		LocationID AS '@ID',
		Name AS '@Name',
		CostRate AS '@Cost'
	FROM Production.Location
	FOR XML PATH ('Location'), ROOT ('Locations')
)

SELECT @xml;

--TaskB

CREATE TABLE #Location(
	LocationID INT NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	CostRate SMALLMONEY NOT NULL
)

INSERT INTO #Location(
	LocationID,
	Name,
	CostRate
)
SELECT 
	LocationID = node.value('@ID', 'int'),
	Name = node.value('@Name', 'nvarchar(100)'),
	CostRate = node.value('@Cost', 'smallmoney')
FROM @xml.nodes('//Location') AS XML(node);
GO

SELECT * FROM #Location;