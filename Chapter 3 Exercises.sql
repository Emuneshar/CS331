---------------------------------------------------------------------
-- Microsoft SQL Server T-SQL Fundamentals
-- Chapter 03 - Joins
-- Solutions
-- © Itzik Ben-Gan 
---------------------------------------------------------------------
USE Northwinds2020TSQLV6;

SELECT E.EmployeeId, E.EmployeeFirstName, E.EmployeeLastName, N.n
FROM HumanResources.Employee AS E
  CROSS JOIN dbo.Nums AS N 
WHERE N.n <= 5
ORDER BY n, EmployeeId;


SELECT E.EmployeeId,
  DATEADD(day, D.n - 1, CAST('20160612' AS DATE)) AS dt
FROM HumanResources.Employee AS E
  CROSS JOIN Nums AS D
WHERE D.n <= DATEDIFF(day, '20160612', '20160616') + 1
ORDER BY EmployeeId, dt;



SELECT C.CustomerId, C.CustomerCompanyName, O.orderid, O.orderdate
FROM Sales.Customer AS C
  INNER JOIN [Sales].[Order] AS O
    ON C.CustomerId = O.CustomerId;


SELECT C.CustomerId, C.CustomerCompanyName, O.orderid, O.orderdate
FROM Sales.Customer AS C
  INNER JOIN [Sales].[Order] AS O
    ON C.CustomerId = O.CustomerId;

SELECT C.CustomerId, C.CustomerCompanyName, O.orderid, O.orderdate
FROM Sales.Customer AS C
  INNER JOIN [Sales].[Order] AS O
    ON C.CustomerId = O.CustomerId;

-- 3

SELECT C.CustomerId, COUNT(DISTINCT O.orderid) AS numorders, SUM(OD.Quantity) AS totalQuantity
FROM Sales.Customer AS C
  INNER JOIN [Sales].[Order] AS O
    ON O.CustomerId = C.CustomerId
  INNER JOIN Sales.OrderDetail AS OD
    ON OD.orderid = O.orderid
WHERE C.CustomerCountry = N'USA'
GROUP BY C.CustomerId;

-- 4

SELECT C.CustomerId, C.CustomerCompanyName, O.orderid, O.orderdate
FROM Sales.Customer AS C
  LEFT OUTER JOIN [Sales].[Order] AS O
    ON O.CustomerId = C.CustomerId;

-- 5
SELECT C.CustomerId, C.CustomerCompanyName
FROM Sales.Customer AS C
  LEFT OUTER JOIN [Sales].[Order] AS O
    ON O.CustomerId = C.CustomerId
WHERE O.orderid IS NULL;

-- 6
SELECT C.CustomerId, C.CustomerCompanyName, O.orderid, O.orderdate
FROM Sales.Customer AS C
  INNER JOIN [Sales].[Order] AS O
    ON O.CustomerId = C.CustomerId
WHERE O.orderdate = '20160212';

-- 7 

SELECT C.CustomerId, C.CustomerCompanyName, O.orderid, O.orderdate
FROM Sales.Customer AS C
  LEFT OUTER JOIN [Sales].[Order] AS O
    ON O.CustomerId = C.CustomerId
    AND O.orderdate = '20160212';

-- 8 
SELECT C.CustomerId, C.CustomerCompanyName, O.orderid, O.orderdate
FROM Sales.Customer AS C
  LEFT OUTER JOIN [Sales].[Order] AS O
    ON O.CustomerId = C.CustomerId
WHERE O.orderdate = '20160212'
   OR O.orderid IS NULL;


SELECT DISTINCT C.CustomerId, C.CustomerCompanyName, 
  CASE WHEN O.orderid IS NOT NULL THEN 'Yes' ELSE 'No' END AS HasOrderOn20160212
FROM Sales.Customer AS C
  LEFT OUTER JOIN [Sales].[Order] AS O
    ON O.CustomerId = C.CustomerId
    AND O.orderdate = '20160212';