---------------------------------------------------------------------
-- Microsoft SQL Server T-SQL Fundamentals
-- Chapter 03 - Joins
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

---------------------------------------------------------------------
-- CROSS Joins
---------------------------------------------------------------------

USE Northwinds2020TSQLV6;

-- SQL-92
-- returns all customes from sales.customer and which employee they are related to in descending order
SELECT C.CustomerId, E.EmployeeId
FROM Sales.Customer as C
Cross Join HumanResources.Employee AS E;


-- SQL-89
-- returns all customes from sales.customer and which employee they are related to in descending order
Select C.CustomerId, E.EmployeeId
From Sales.Customer as C, HumanResources.Employee as E;

-- Self Cross-Join
-- returns cross join with itself, listing the cartesian product of HumanResources.Employee, 9*9=81 and there are 81 outputs
SELECT
  E1.EmployeeId, E1.EmployeeFirstName, E1.EmployeeLastName,
  E2.EmployeeId, E2.EmployeeFirstName, E2.EmployeeLastName
FROM HumanResources.Employee AS E1 
  CROSS JOIN HumanResources.Employee AS E2;
GO

-- All numbers from 1 - 1000

-- Auxiliary table of digits
USE Northwinds2020TSQLV6;
-- drops and then creates dbo.digits and puts in values 0-9
DROP TABLE IF EXISTS dbo.Digits;

CREATE TABLE dbo.Digits(digit INT NOT NULL PRIMARY KEY);

INSERT INTO dbo.Digits(digit)
  VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

SELECT digit FROM dbo.Digits;
GO

-- All numbers from 1 - 1000
-- returns all numbers from 0 to 1000 using dbo table and crossjoins to out put the cartesian product of dbo 3 times, multiplying to get the correct output
SELECT D3.digit * 100 + D2.digit * 10 + D1.digit + 1 AS n
FROM         dbo.Digits AS D1
  CROSS JOIN dbo.Digits AS D2
  CROSS JOIN dbo.Digits AS D3
ORDER BY n;

---------------------------------------------------------------------
-- INNER Joins
---------------------------------------------------------------------

USE Northwinds2020TSQLV6;

-- SQL-92
-- uses innerjoin to return any matches between eomployees names, id, and orders they've helped with
SELECT E.EmployeeId, E.EmployeeFirstName, E.EmployeeLastName, O.orderid
FROM HumanResources.Employee AS E
  INNER JOIN [Sales].[Order] AS O
    ON E.EmployeeId = O.EmployeeId;

-- SQL-89
-- returns any matches between eomployees names, id, and orders they've helped with

SELECT E.EmployeeId, E.EmployeeFirstName, E.EmployeeLastName, O.orderid
FROM HumanResources.Employee AS E, [Sales].[Order] AS O
WHERE E.EmployeeId = O.EmployeeId;
GO

-- Inner Join Safety
/*
SELECT E.EmployeeId, E.EmployeeFirstName, E.EmployeeLastName, O.orderid
FROM HumanResources.Employee AS E
  INNER JOIN [Sales].[Order] AS O;
GO
*/
-- returns every sale employees have made
SELECT E.EmployeeId, E.EmployeeFirstName, E.EmployeeLastName, O.orderid
FROM HumanResources.Employee AS E, [Sales].[Order] AS O;
GO

---------------------------------------------------------------------
-- More Join Examples
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Composite Joins
---------------------------------------------------------------------

-- Audit table for updates against OrderDetails
USE Northwinds2020TSQLV6;
-- drops sales.orderdetailaudit and creates sales.orderdetailaudit
DROP TABLE IF EXISTS Sales.OrderDetailAudit;

CREATE TABLE Sales.OrderDetailAudit
(
  lsn        INT NOT NULL IDENTITY,
  orderid    INT NOT NULL,
  productid  INT NOT NULL,
  dt         DATETIME NOT NULL,
  loginname  sysname NOT NULL,
  columnname sysname NOT NULL,
  oldval     SQL_VARIANT,
  newval     SQL_VARIANT,
  CONSTRAINT PK_OrderDetailsAudit PRIMARY KEY(lsn),
  CONSTRAINT FK_OrderDetailsAudit_OrderDetails
    FOREIGN KEY(orderid, productid)
    REFERENCES Sales.OrderDetail(orderid, productid)
);
-- uses inner join to return orderID, productID, quantity, dt,loginname, oldval and newval. All empty 
SELECT OD.orderid, OD.productid, OD.Quantity,
  ODA.dt, ODA.loginname, ODA.oldval, ODA.newval
FROM Sales.OrderDetail AS OD
  INNER JOIN Sales.OrderDetailAudit AS ODA
    ON OD.orderid = ODA.orderid
    AND OD.productid = ODA.productid
WHERE ODA.columnname = N'Quantity';

---------------------------------------------------------------------
-- Non-Equi Joins
---------------------------------------------------------------------

-- Unique pairs of employees
-- uses inner join (what is related between the 2 tables) to return distinct pairs of employees, good for team formation? 
SELECT
  E1.EmployeeId, E1.EmployeeFirstName, E1.EmployeeLastName,
  E2.EmployeeId, E2.EmployeeFirstName, E2.EmployeeLastName
FROM HumanResources.Employee AS E1
  INNER JOIN HumanResources.Employee AS E2
    ON E1.EmployeeId < E2.EmployeeId;

---------------------------------------------------------------------
-- Multi-Join Queries
---------------------------------------------------------------------
-- uses inner join twice, once on sales.order and sales.customer, and then also on sales.orderdetail to return customer id, 
--customer company name, orderid, product id, and quantity to show who ordered what, for which company, their orderId and how much they ordered, their quantity
SELECT
  C.CustomerId, C.CustomerCompanyName, O.orderid,
  OD.productid, OD.Quantity
FROM Sales.Customer AS C
  INNER JOIN [Sales].[Order] AS O
    ON C.CustomerId = O.CustomerId
  INNER JOIN Sales.OrderDetail AS OD
    ON O.orderid = OD.orderid;

---------------------------------------------------------------------
-- Fundamentals of Outer Joins 
---------------------------------------------------------------------

-- Customers and their orders, including customers with no orders
-- returns customerId, customer company name, and orderID for sales.customer and the intersection between sales.customer and sales.order
SELECT C.CustomerId, C.CustomerCompanyName, O.orderid
FROM Sales.Customer AS C
  LEFT OUTER JOIN [Sales].[Order] AS O
    ON C.CustomerId = O.CustomerId;

-- Customers with no orders
-- returns customer id and customer company from the sales.customer and the intersection of sales.order where order ID is null, meaning no customer ID 
SELECT C.CustomerId, C.CustomerCompanyName
FROM Sales.Customer AS C
  LEFT OUTER JOIN [Sales].[Order] AS O
    ON C.CustomerId = O.CustomerId
WHERE O.orderid IS NULL;

---------------------------------------------------------------------
-- Beyond the Fundamentals of Outer Joins
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Including Missing Values
---------------------------------------------------------------------
-- returns order dates in the range of 2014 to 2016
SELECT DATEADD(day, n-1, CAST('20140101' AS DATE)) AS orderdate
FROM dbo.Nums
WHERE n <= DATEDIFF(day, '20140101', '20161231') + 1
ORDER BY orderdate;

-- uses left outter join to return the orderdate, orderid, customerid, and employee id, for orders that are in dbo.nums and the intersection of dbo nums and sales.order
SELECT DATEADD(day, Nums.n - 1, CAST('20140101' AS DATE)) AS orderdate,
  O.orderid, O.CustomerId, O.EmployeeId
FROM dbo.Nums
  LEFT OUTER JOIN [Sales].[Order] AS O
    ON DATEADD(day, Nums.n - 1, CAST('20140101' AS DATE)) = O.orderdate
WHERE Nums.n <= DATEDIFF(day, '20140101', '20161231') + 1
ORDER BY orderdate;

---------------------------------------------------------------------
-- Filtering Attributes from Non-Preserved Side of Outer Join
---------------------------------------------------------------------
-- uses left outter join to return orders and orderdates along with orderid from sales.customer and the intersection of sales.order who's order date is 2016 
-- or greater
SELECT C.CustomerId, C.CustomerCompanyName, O.orderid, O.orderdate
FROM Sales.Customer AS C
  LEFT OUTER JOIN [Sales].[Order] AS O
    ON C.CustomerId = O.CustomerId
WHERE O.orderdate >= '20160101';

---------------------------------------------------------------------
-- Using Outer Joins in a Multi-Join Query
---------------------------------------------------------------------
-- uses left outter join between sales.customer and intersection of sales.order and then uses inner join on 
-- that with sales.orderdetail to return customer id, order id, product id, and quantity 
SELECT C.CustomerId, O.orderid, OD.productid, OD.Quantity
FROM Sales.Customer AS C
  LEFT OUTER JOIN [Sales].[Order] AS O
    ON C.CustomerId = O.CustomerId
  INNER JOIN Sales.OrderDetail AS OD
    ON O.orderid = OD.orderid;

-- Option 1: use outer join all along
-- uses a left outter join between sales.customer and the intersection of sales.order and then uses another left 
-- outter join on the result of that with salees.orderdetail to display customerid orderid productid and quantity for those orders 
-- in the intersections
SELECT C.CustomerId, O.orderid, OD.productid, OD.Quantity
FROM Sales.Customer AS C
  LEFT OUTER JOIN [Sales].[Order] AS O
    ON C.CustomerId = O.CustomerId
  LEFT OUTER JOIN Sales.OrderDetail AS OD
    ON O.orderid = OD.orderid;

-- Option 2: change join order
-- shows that join ordering can be distinct 
SELECT C.CustomerId, O.orderid, OD.productid, OD.Quantity
FROM [Sales].[Order] AS O
  INNER JOIN Sales.OrderDetail AS OD
    ON O.orderid = OD.orderid
  RIGHT OUTER JOIN Sales.Customer AS C
     ON O.CustomerId = C.CustomerId;

-- Option 3: use parentheses
SELECT C.CustomerId, O.orderid, OD.productid, OD.Quantity
FROM Sales.Customer AS C
  LEFT OUTER JOIN
      ([Sales].[Order] AS O
         INNER JOIN Sales.OrderDetail AS OD
           ON O.orderid = OD.orderid)
    ON C.CustomerId = O.CustomerId;

---------------------------------------------------------------------
-- Using the COUNT Aggregate with Outer Joins
---------------------------------------------------------------------
-- uses left outter join between sales.customer and the intersection of sales.order to return customer id and numorders, grouped by cuztomerid in descending order
SELECT C.CustomerId, COUNT(*) AS numorders
FROM Sales.Customer AS C
  LEFT OUTER JOIN [Sales].[Order] AS O
    ON C.CustomerId = O.CustomerId
GROUP BY C.CustomerId;

-- uses left outter join between sales.customer and sales.order, grouped by customer id to display customer id and numberorders
SELECT C.CustomerId, COUNT(O.orderid) AS numorders
FROM Sales.Customer AS C
  LEFT OUTER JOIN [Sales].[Order] AS O
    ON C.CustomerId = O.CustomerId
GROUP BY C.CustomerId;