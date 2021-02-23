---------------------------------------------------------------------
-- Microsoft SQL Server T-SQL Fundamentals
-- Chapter 02 - Single-Table Queries
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Elements of the SELECT Statement
---------------------------------------------------------------------

-- Listing 2-1: Sample Query
USE Northwinds2020TSQLV6;
-- Returns sales orders where the customer ID is 71, grouped by Employee ID and orderdate, having count greater than 1 and ordered by employee ID and orderyear
SELECT EmployeeId, YEAR(OrderDate) AS orderyear, COUNT(*) AS numorders
FROM [Sales].[Order]
WHERE CustomerId = 71
GROUP BY EmployeeId, YEAR(OrderDate)
HAVING COUNT(*) > 1
ORDER BY EmployeeId, orderyear;

---------------------------------------------------------------------
-- The FROM Clause
---------------------------------------------------------------------
-- Returns sales orders form the sales order table
SELECT OrderId, CustomerId, EmployeeId, OrderDate, freight
FROM [Sales].[Order];

---------------------------------------------------------------------
-- The WHERE Clause
---------------------------------------------------------------------
-- Sales Orders with customer id of 71, sorted by OrderID and EmployeeID
SELECT OrderId, EmployeeId, OrderDate, freight
FROM [Sales].[Order]
WHERE CustomerId = 71;

---------------------------------------------------------------------
-- The GROUP BY Clause
---------------------------------------------------------------------
-- Returns orders with a customer ID of 71, sorted and grouped by Employee ID
SELECT EmployeeId, YEAR(OrderDate) AS orderyear
FROM [Sales].[Order]
WHERE CustomerId = 71
GROUP BY EmployeeId, YEAR(OrderDate);


-- Returns orders grouped by EmployeeID and order year
SELECT
  EmployeeId,
  YEAR(OrderDate) AS orderyear,
  SUM(freight) AS totalfreight,
  COUNT(*) AS numorders
FROM [Sales].[Order]
WHERE CustomerId = 71
GROUP BY EmployeeId, YEAR(OrderDate);

/*
SELECT EmployeeId, YEAR(OrderDate) AS orderyear, freight
FROM [Sales].[Order]
WHERE CustomerId = 71
GROUP BY EmployeeId, YEAR(OrderDate);
*/

-- Returns sales orders grouped by employyeID and year ordered
SELECT 
  EmployeeId, 
  YEAR(OrderDate) AS orderyear, 
  COUNT(DISTINCT CustomerId) AS numcusts
FROM [Sales].[Order]
GROUP BY EmployeeId, YEAR(OrderDate);

---------------------------------------------------------------------
-- The HAVING Clause
---------------------------------------------------------------------

-- Returns sales orders with customer ID of 71, having count greater than 1 
SELECT EmployeeId, YEAR(OrderDate) AS orderyear
FROM [Sales].[Order]
WHERE CustomerId = 71
GROUP BY EmployeeId, YEAR(OrderDate)
HAVING COUNT(*) > 1;

---------------------------------------------------------------------
-- The SELECT Clause
---------------------------------------------------------------------
-- Returns Order ID from sales.order table 
SELECT OrderId OrderDate
FROM [Sales].[Order];

-- Returns sales orders grouped and sorted by employeeId and orderyear
SELECT EmployeeId, YEAR(OrderDate) AS orderyear, COUNT(*) AS numorders
FROM [Sales].[Order]
WHERE CustomerId = 71
GROUP BY EmployeeId, YEAR(OrderDate)
HAVING COUNT(*) > 1;

/*
SELECT OrderId, YEAR(OrderDate) AS orderyear
FROM [Sales].[Order]
WHERE orderyear > 2015;
*/

-- Returns sales orders who's Orderdate's are greater than 2015
SELECT OrderId, YEAR(OrderDate) AS orderyear
FROM [Sales].[Order]
WHERE YEAR(OrderDate) > 2015;

/*
SELECT EmployeeId, YEAR(OrderDate) AS orderyear, COUNT(*) AS numorders
FROM [Sales].[Order]
WHERE CustomerId = 71
GROUP BY EmployeeId, YEAR(OrderDate)
HAVING numorders > 1;
*/

-- Returns sales orders where customer ID = 71, grouped by employeeID and orderdate, having a count greater than 1
SELECT EmployeeId, YEAR(OrderDate) AS orderyear, COUNT(*) AS numorders
FROM [Sales].[Order]
WHERE CustomerId = 71
GROUP BY EmployeeId, YEAR(OrderDate)
HAVING COUNT(*) > 1;

-- Listing 2-2: Query Returning Duplicate Rows
-- Returns sales orders sorted descending order by orderyear, and employeeID
SELECT EmployeeId, YEAR(OrderDate) AS orderyear
FROM [Sales].[Order]
WHERE CustomerId = 71;

-- Listing 2-3: Query With a DISTINCT Clause
-- Returns order Year sorted by distinct employeeID 
SELECT DISTINCT EmployeeId, YEAR(OrderDate) AS orderyear
FROM [Sales].[Order]
WHERE CustomerId = 71;

-- Returns all shippers
SELECT *
FROM Sales.Shipper;

/*
SELECT OrderId,
  YEAR(OrderDate) AS orderyear,
  orderyear + 1 AS nextyear
FROM [Sales].[Order];
*/

-- Return sales orders sorted by orderID and order year
SELECT OrderId,
  YEAR(OrderDate) AS orderyear,
  YEAR(OrderDate) + 1 AS nextyear
FROM [Sales].[Order];

---------------------------------------------------------------------
-- The ORDER BY Clause
---------------------------------------------------------------------

-- Listing 2-4: Query Demonstrating the ORDER BY Clause
-- returns sales orders sorted by EmployeeId, orderyear, having a count over 1 
SELECT EmployeeId, YEAR(OrderDate) AS orderyear, COUNT(*) AS numorders
FROM [Sales].[Order]
WHERE CustomerId = 71
GROUP BY EmployeeId, YEAR(OrderDate)
HAVING COUNT(*) > 1
ORDER BY EmployeeId, orderyear;

-- returns list of employees from human resources, ordered by hiredate
SELECT EmployeeId, EmployeeFirstName, EmployeeLastName, EmployeeCountry
FROM HumanResources.Employee
ORDER BY hiredate;

/*
SELECT DISTINCT EmployeeCountry
FROM HumanResources.Employee
ORDER BY EmployeeId;
*/

---------------------------------------------------------------------
-- The TOP and OFFSET-FETCH Filters
---------------------------------------------------------------------

---------------------------------------------------------------------
-- The TOP Filter
---------------------------------------------------------------------

-- Listing 2-5: Query Demonstrating the TOP Option
-- returns the top 5 sales orders sorted by descending order date
SELECT TOP (5) OrderId, OrderDate, CustomerId, EmployeeId
FROM [Sales].[Order]
ORDER BY OrderDate DESC;

-- returns the top 1% of sales sorted by descending order date
SELECT TOP (1) PERCENT OrderId, OrderDate, CustomerId, EmployeeId
FROM [Sales].[Order]
ORDER BY OrderDate DESC;

-- Listing 2-6: Query Demonstrating TOP with Unique ORDER BY List
-- returns the top 5 sales orders sorted by descending order date AND orderId
SELECT TOP (5) OrderId, OrderDate, CustomerId, EmployeeId
FROM [Sales].[Order]
ORDER BY OrderDate DESC, OrderId DESC;

-- returns the top 5 with ties, so 2 unique results with ties
SELECT TOP (5) WITH TIES OrderId, OrderDate, CustomerId, EmployeeId
FROM [Sales].[Order]
ORDER BY OrderDate DESC;

---------------------------------------------------------------------
-- The OFFSET-FETCH Filter
---------------------------------------------------------------------

-- OFFSET-FETCH
-- returns sales orders ordered by order date and order ID, using offset fetch to show 25 rows, good for pagination 
SELECT OrderId, OrderDate, CustomerId, EmployeeId
FROM [Sales].[Order]
ORDER BY OrderDate, OrderId
OFFSET 50 ROWS FETCH NEXT 25 ROWS ONLY;

---------------------------------------------------------------------
-- A Quick Look at Window Functions
---------------------------------------------------------------------
-- returns total discounted amount ordered by customer ID and discount amount 
SELECT OrderId, CustomerId, TotalDiscountedAmount,
  ROW_NUMBER() OVER(PARTITION BY CustomerId
                    ORDER BY TotalDiscountedAmount) AS rownum
FROM Sales.uvw_OrderTotalQuantityAndTotalDiscountedAmount
ORDER BY CustomerId, TotalDiscountedAmount;

---------------------------------------------------------------------
-- Predicates and Operators
---------------------------------------------------------------------

-- Predicates: IN, BETWEEN, LIKE
-- IN lets you specify multiple values in a where clause, so this returns orders from sales order that have an order ID of 10248, 10249, 10250
SELECT OrderId, EmployeeId, OrderDate
FROM [Sales].[Order]
WHERE OrderId IN(10248, 10249, 10250);

-- Between lets you return a range of values in a where clause, this case lets you return sales orders with an Order id in the range of 10300 to 10310
SELECT OrderId, EmployeeId, OrderDate
FROM [Sales].[Order]
WHERE OrderId BETWEEN 10300 AND 10310;

-- Like operator lets you find patterns in columns, so this case lets you find employees who's last name start with the letter D
SELECT EmployeeId, EmployeeFirstName, EmployeeLastName
FROM HumanResources.Employee
WHERE EmployeeLastName LIKE N'D%';

-- Comparison operators: =, >, <, >=, <=, <>, !=, !>, !< 
-- This uses greater than and equals operators to let you return order from sales orders who's order date is greater than 20160101
SELECT OrderId, EmployeeId, OrderDate
FROM [Sales].[Order]
WHERE OrderDate >= '20160101';

-- Logical operators: AND, OR, NOT
-- This uses the and operator to let you return orders from sales orders who's order date is greater than 20160101 and who have an employee ID number of either 1, 3, 5
SELECT OrderId, EmployeeId, OrderDate
FROM [Sales].[Order]
WHERE OrderDate >= '20160101'
  AND EmployeeId IN(1, 3, 5);

-- Arithmetic operators: +, -, *, /, %
-- returns sales orders whose discount percentage is less than 1, 
SELECT OrderId, productid, Quantity, unitprice, DiscountPercentage,
  Quantity * unitprice * (1 - DiscountPercentage) AS TotalDiscountedAmount
FROM [Sales].[OrderDetail];

-- Operator Precedence

-- AND precedes OR
-- returns sales orders who has an employee id of 1, 3, 5 or customer id of 85, and employee id of 2,4,6, but shows that and takes precedence. 
SELECT OrderId, CustomerId, EmployeeId, OrderDate
FROM [Sales].[Order]
WHERE
        CustomerId = 1
    AND EmployeeId IN(1, 3, 5)
    OR  CustomerId = 85
    AND EmployeeId IN(2, 4, 6);

-- EquiTotalDiscountedAmountent to
-- returns sales orders where customer ID is 1 and employee ID is 1,3,5 or customer ID is 85 and employee id is 2, 4, 6 
SELECT OrderId, CustomerId, EmployeeId, OrderDate
FROM [Sales].[Order]
WHERE
      ( CustomerId = 1
        AND EmployeeId IN(1, 3, 5) )
    OR
      ( CustomerId = 85
        AND EmployeeId IN(2, 4, 6) );

-- *, / precedes +, -
-- shows operator precedence, multiplication precedes addition 
SELECT 10 + 2 * 3   -- 16

--shows that parenthesis changes operator precendence 
SELECT (10 + 2) * 3 -- 36

---------------------------------------------------------------------
-- CASE Expression
---------------------------------------------------------------------

-- Simple
-- returns products from production table, using the when then statement, when first condition is met, then use category, 
SELECT productid, productname, categoryid,
  CASE categoryid
    WHEN 1 THEN 'Beverages'
    WHEN 2 THEN 'Condiments'
    WHEN 3 THEN 'Confections'
    WHEN 4 THEN 'Dairy Products'
    WHEN 5 THEN 'Grains/Cereals'
    WHEN 6 THEN 'Meat/Poultry'
    WHEN 7 THEN 'Produce'
    WHEN 8 THEN 'Seafood'
    ELSE 'Unknown Category'
  END AS categoryname
FROM Production.Product;

-- Searched
-- return total discounted amount and total discounted amount category using when statements to categorize less than 1000, between 1000 and 3000, and more than 3000 
SELECT OrderId, CustomerId, TotalDiscountedAmount,
  CASE 
    WHEN TotalDiscountedAmount < 1000.00                   THEN 'Less than 1000'
    WHEN TotalDiscountedAmount BETWEEN 1000.00 AND 3000.00 THEN 'Between 1000 and 3000'
    WHEN TotalDiscountedAmount > 3000.00                   THEN 'More than 3000'
    ELSE 'Unknown'
  END AS TotalDiscountedAmountuecategory
FROM [Sales].[uvw_OrderTotalQuantityAndTotalDiscountedAmount];

---------------------------------------------------------------------
-- NULLs
---------------------------------------------------------------------
-- uses where to return customers in the wa region, in descending customer ID order
SELECT CustomerId, CustomerCountry, CustomerRegion, CustomerCity
FROM Sales.Customer
WHERE CustomerRegion = N'WA';

-- uses where to return customers, ordered by customer ID who's region is not WA
SELECT CustomerId, CustomerCountry, CustomerRegion, CustomerCity
FROM Sales.Customer
WHERE CustomerRegion <> N'WA';

-- uses where to return cusomers who's region equals null, in this case, there are none
SELECT CustomerId, CustomerCountry, CustomerRegion, CustomerCity
FROM Sales.Customer
WHERE CustomerRegion = NULL;

-- returns customer from sales customers, who's region IS null, sorted in descending customer ID order
SELECT CustomerId, CustomerCountry, CustomerRegion, CustomerCity
FROM Sales.Customer
WHERE CustomerRegion IS NULL;

-- returns sales customers who's region is not WA or IS null
SELECT CustomerId, CustomerCountry, CustomerRegion, CustomerCity
FROM Sales.Customer
WHERE CustomerRegion <> N'WA'
   OR CustomerRegion IS NULL;

---------------------------------------------------------------------
-- All-At-Once Operations
---------------------------------------------------------------------

/*
SELECT 
  OrderId, 
  YEAR(OrderDate) AS orderyear, 
  orderyear + 1 AS nextyear
FROM [Sales].[Order];
*/

/*
SELECT col1, col2
FROM dbo.T1
WHERE col1 <> 0 AND col2/col1 > 2;
*/

/*
SELECT col1, col2
FROM dbo.T1
WHERE
  CASE
    WHEN col1 = 0 THEN 'no' -- or 'yes' if row should be returned
    WHEN col2/col1 > 2 THEN 'yes'
    ELSE 'no'
  END = 'yes';
*/

/*
SELECT col1, col2
FROM dbo.T1
WHERE (col1 > 0 AND col2 > 2*col1) OR (col1 < 0 AND col2 < 2*col1); 
*/

---------------------------------------------------------------------
-- Working with Character Data
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Collation
---------------------------------------------------------------------
-- returns 
SELECT name, description
FROM sys.fn_helpcollations();

-- returns employees who's last name is davis from table human resources table
SELECT EmployeeId, EmployeeFirstName, EmployeeLastName
FROM HumanResources.Employee
WHERE EmployeeLastName = N'davis';

-- returns nothing
SELECT EmployeeId, EmployeeFirstName, EmployeeLastName
FROM HumanResources.Employee
WHERE EmployeeLastName COLLATE Latin1_General_CS_AS = N'davis';

---------------------------------------------------------------------
-- Operators and Functions
---------------------------------------------------------------------

-- Concatenation
-- concatenates first name and last name form human resources table to display as full name
SELECT EmployeeId, EmployeeFirstName + N' ' + EmployeeLastName AS fullname
FROM HumanResources.Employee;

-- Listing 2-7: Query Demonstrating String Concatenation
-- returns list of customer from sales customers table, concatanating their country, region and city to create their location 
SELECT CustomerId, CustomerCountry, CustomerRegion, CustomerCity,
  CustomerCountry + N',' + CustomerRegion + N',' + CustomerCity AS location
FROM Sales.Customer;

-- convert NULL to empty string
-- returns lsit of customer, concatanating their country, even if their region is null, and their city to create their location 
SELECT CustomerId, CustomerCountry, CustomerRegion, CustomerCity,
  CustomerCountry + COALESCE( N',' + CustomerRegion, N'') + N',' + CustomerCity AS location
FROM Sales.Customer;

-- using the CONCAT function
-- uses concat function to concatinate customers country, region and city to output their location
SELECT CustomerId, CustomerCountry, CustomerRegion, CustomerCity,
  CONCAT(CustomerCountry, N',' + CustomerRegion, N',' + CustomerCity) AS location
FROM Sales.Customer;

-- Functions
-- finds substring
SELECT SUBSTRING('abcde', 1, 3); -- 'abc'

-- returns specified number of characters, in this case, 3, starting from the right
SELECT RIGHT('abcde', 3); -- 'cde'

-- return the length of a string
SELECT LEN(N'abcde'); -- 5

-- returns the number of bytes used to represent an expression
SELECT DATALENGTH(N'abcde'); -- 10

--searches for a sub string in a string and returns the position 
SELECT CHARINDEX(' ','Itzik Ben-Gan'); -- 6

-- returns the position of a pattern in a string
SELECT PATINDEX('%[0-9]%', 'abcd123efgh'); -- 5

-- replaces all occurnces of a substring in a string with a new substring
SELECT REPLACE('1-a 2-b', '-', ':'); -- '1:a 2:b'

-- returns the length of employees lastname, subtracting the length of their first name, where letter e is replaced
SELECT EmployeeId, EmployeeLastName,
  LEN(EmployeeLastName) - LEN(REPLACE(EmployeeLastName, 'e', '')) AS numoccur
FROM HumanResources.Employee;

-- replicates a string a given number of times
SELECT REPLICATE('abc', 3); -- 'abcabcabc'

-- changes supplier ID to create a varcahr of length 10
SELECT supplierid,
  RIGHT(REPLICATE('0', 9) + CAST(supplierid AS VARCHAR(10)),
        10) AS strsupplierid
FROM Production.Supplier;

--deletes part of a string and replaces it with part of another string, based on provided positions 
SELECT STUFF('xyz', 2, 1, 'abc'); -- 'xabcz'

-- changes a string to all upper case
SELECT UPPER('Itzik Ben-Gan'); -- 'ITZIK BEN-GAN'

-- changes a string to all lower case
SELECT LOWER('Itzik Ben-Gan'); -- 'itzik ben-gan'

-- rtrim removes trailing spaces from the right, ltrim removes traling spaces from the left
SELECT RTRIM(LTRIM('   abc   ')); -- 'abc'

-- format formats the specififed inputs together. In this case, it merges 1759 and 0000000000 to create 0000001759
SELECT FORMAT(1759, '0000000000'); -- '0000001759'

-- COMPRESS
-- compress function compresses text data into a smaller form, binary or hex
SELECT COMPRESS(N'This is my cv. Imagine it was much longer.');

/*
INSERT INTO dbo.EmployeeCVs( EmployeeId, cv )
  TotalDiscountedAmountUES( @EmployeeId, COMPRESS(@cv) );
*/

-- DECOMPRESS
--returns the maximum decompressed size of text
SELECT DECOMPRESS(COMPRESS(N'This is my cv. Imagine it was much longer.'));

-- demonstrates identity propety. Compress and decompress cancel out.
SELECT
  CAST(
    DECOMPRESS(COMPRESS(N'This is my cv. Imagine it was much longer.'))
      AS NVARCHAR(MAX));

/*
SELECT EmployeeId, CAST(DECOMPRESS(cv) AS NVARCHAR(MAX)) AS cv
FROM dbo.EmployeeCVs;
*/

-- STRING_SPLIT
--splits string when a given parameter is found in the string
SELECT CAST(value AS INT) AS myTotalDiscountedAmountue
FROM STRING_SPLIT('10248,10249,10250', ',') AS S;

/*
myTotalDiscountedAmountue
-----------
10248
10249
10250
*/

---------------------------------------------------------------------
-- LIKE Predicate
---------------------------------------------------------------------

-- Last name starts with D
SELECT EmployeeId, EmployeeLastName
FROM HumanResources.Employee
WHERE EmployeeLastName LIKE N'D%';

-- Second character in last name is e
SELECT EmployeeId, EmployeeLastName
FROM HumanResources.Employee
WHERE EmployeeLastName LIKE N'_e%';

-- First character in last name is A, B or C
SELECT EmployeeId, EmployeeLastName
FROM HumanResources.Employee
WHERE EmployeeLastName LIKE N'[ABC]%';

-- First character in last name is A through E
SELECT EmployeeId, EmployeeLastName
FROM HumanResources.Employee
WHERE EmployeeLastName LIKE N'[A-E]%';

-- First character in last name is not A through E
SELECT EmployeeId, EmployeeLastName
FROM HumanResources.Employee
WHERE EmployeeLastName LIKE N'[^A-E]%';

---------------------------------------------------------------------
-- Working with Date and Time Data
---------------------------------------------------------------------

-- Literals
-- returns sales orders who's order date matches the given key
SELECT OrderId, CustomerId, EmployeeId, OrderDate
FROM [Sales].[Order]
WHERE OrderDate = '20160212';

-- returns sales order based on given key and displays the date as an actual date by casting it as a date
SELECT OrderId, CustomerId, EmployeeId, OrderDate
FROM [Sales].[Order]
WHERE OrderDate = CAST('20160212' AS DATE);

-- Language dependent
-- displays date in the british format
SET LANGUAGE British;
SELECT CAST('02/12/2016' AS DATE);

--displays date as US format
SET LANGUAGE us_english;
SELECT CAST('02/12/2016' AS DATE);

-- Language neutral
-- dsiplays dare in british format
SET LANGUAGE British;
SELECT CAST('20160212' AS DATE);

-- displays date in US format
SET LANGUAGE us_english;
SELECT CAST('20160212' AS DATE);

-- displays date as year, month, day
SELECT CONVERT(DATE, '02/12/2016', 101);

--displays dat as year, day, month
SELECT CONVERT(DATE, '02/12/2016', 103);

--changes date format from month, day, year US format
SELECT PARSE('02/12/2016' AS DATE USING 'en-US');

--changes date format from month, day, year British format
SELECT PARSE('02/12/2016' AS DATE USING 'en-GB');

-- Working with Date and Time Separately

-- Create [Sales].[Order2] with OrderDate as DATETIME by copying data from [Sales].[Order]
DROP TABLE IF EXISTS [Sales].[Order2];

-- replicate sales.order to create sales. order2, casting order date as date time
SELECT OrderId, CustomerId, EmployeeId, CAST(OrderDate AS DATETIME) AS OrderDate
INTO [Sales].[Order2]
FROM [Sales].[Order];

-- Query [Sales].[Order2]
--shows that sales.order2 is an actual table that can be queried. Returns entries that match a given key
SELECT OrderId, CustomerId, EmployeeId, OrderDate
FROM [Sales].[Order2]
WHERE OrderDate = '20160212';

-- alters sales.order2, converts order date to new format
ALTER TABLE [Sales].[Order2]
  ADD CONSTRAINT CHK_Orders2_OrderDate
  CHECK( CONVERT(CHAR(12), OrderDate, 114) = '00:00:00:000' );

-- returns from sales order2, entries whos order date is 2016-02-12
SELECT OrderId, CustomerId, EmployeeId, OrderDate
FROM [Sales].[Order2]
WHERE OrderDate >= '20160212'
  AND OrderDate < '20160213';

-- casts given parameter as datetime format
SELECT CAST('12:30:15.123' AS DATETIME);

-- Cleanup
--drops table if it exists, gets rid of table 
DROP TABLE IF EXISTS [Sales].[Order2];

--returns all orders in 2015
SELECT OrderId, CustomerId, EmployeeId, OrderDate
FROM [Sales].[Order]
WHERE YEAR(OrderDate) = 2015;

-- returns order dates in given range
SELECT OrderId, CustomerId, EmployeeId, OrderDate
FROM [Sales].[Order]
WHERE OrderDate >= '20150101' AND OrderDate < '20160101';

-- returns entries where order date and order year match the given values
SELECT OrderId, CustomerId, EmployeeId, OrderDate
FROM [Sales].[Order]
WHERE YEAR(OrderDate) = 2016 AND MONTH(OrderDate) = 2;

--returns orders for the month of february 
SELECT OrderId, CustomerId, EmployeeId, OrderDate
FROM [Sales].[Order]
WHERE OrderDate >= '20160201' AND OrderDate < '20160301';

-- Functions

-- Current Date and Time
-- returns current date, current time stamp, utc fate, system date time, system utc date time, and system date time difference
SELECT
  GETDATE()           AS [GETDATE],
  CURRENT_TIMESTAMP   AS [CURRENT_TIMESTAMP],
  GETUTCDATE()        AS [GETUTCDATE],
  SYSDATETIME()       AS [SYSDATETIME],
  SYSUTCDATETIME()    AS [SYSUTCDATETIME],
  SYSDATETIMEOFFSET() AS [SYSDATETIMEOFFSET];

-- returns current date and time
SELECT
  CAST(SYSDATETIME() AS DATE) AS [current_date],
  CAST(SYSDATETIME() AS TIME) AS [current_time];

-- The CAST, CONVERT and PARSE Functions and their TRY_ Counterparts
-- casts given string as a date
SELECT CAST('20160212' AS DATE);
-- casts systemdate as a date
SELECT CAST(SYSDATETIME() AS DATE);
-- casts system date as a time
SELECT CAST(SYSDATETIME() AS TIME);

--converts current time stamp to yearm month and day format (112)
SELECT CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112);
--converts current time stamp to full format
SELECT CONVERT(DATETIME, CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112), 112);

-- converts time stamp
SELECT CONVERT(CHAR(12), CURRENT_TIMESTAMP, 114);
-- converts time stamp to 114 format and then back again
SELECT CONVERT(DATETIME, CONVERT(CHAR(12), CURRENT_TIMESTAMP, 114), 114);

--displays time stampp in US format
SELECT PARSE('02/12/2016' AS DATETIME USING 'en-US');
--displays time stamp in Great britian format
SELECT PARSE('02/12/2016' AS DATETIME USING 'en-GB');

-- SWITCHOFFSET
-- uses systime and then shifts it to reflect new time zone based off of given parameters, in this case it is a +5 hour shift
SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '-05:00');
-- uses systime and then shifts it to reflect new time zone based off of given parameters, in this case it is a 0 hour shift
SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '+00:00');

-- TODATETIMEOFFSET
/*
UPDATE dbo.T1
  SET dto = TODATETIMEOFFSET(dt, theoffset);
*/

-- AT TIME ZONE

SELECT name, current_utc_offset, is_currently_dst
FROM sys.time_zone_info;

-- Converting non-datetimeoffset TotalDiscountedAmountues
-- behavior similar to TODATETIMEOFFSET
SELECT
  CAST('20160212 12:00:00.0000000' AS DATETIME2)
    AT TIME ZONE 'Pacific Standard Time' AS TotalDiscountedAmount1,
  CAST('20160812 12:00:00.0000000' AS DATETIME2)
    AT TIME ZONE 'Pacific Standard Time' AS TotalDiscountedAmount2;

-- Converting datetimeoffset TotalDiscountedAmountues
-- behavior similar to SWITCHOFFSET
SELECT
  CAST('20160212 12:00:00.0000000 -05:00' AS DATETIMEOFFSET)
    AT TIME ZONE 'Pacific Standard Time' AS TotalDiscountedAmount1,
  CAST('20160812 12:00:00.0000000 -04:00' AS DATETIMEOFFSET)
    AT TIME ZONE 'Pacific Standard Time' AS TotalDiscountedAmount2;

-- DATEADD
-- adds interval to date and returns, in this case, adds 1 to year  
SELECT DATEADD(year, 1, '20160212');

-- DATEDIFF
-- Subtracts the second date from the first date to find the difference between the 2 dates
SELECT DATEDIFF(day, '20150212', '20160212');
-- returns the difference in the given paramters as a signed big int 
SELECT DATEDIFF_BIG(millisecond, '00010101', '20160212');

-- adds an interval to the specified time and then returns after using datediff to subtract given days from systemtime.
SELECT
  DATEADD(
    day, 
    DATEDIFF(day, '19000101', SYSDATETIME()), '19000101');

-- adds an interval to the specified time and then returns after using datediff to subtract given months from systemtime. 
SELECT
  DATEADD(
    month, 
    DATEDIFF(month, '19000101', SYSDATETIME()), '19000101');

-- adds an interval to the specified time and then returns after using datediff to subtract given years from systemtime. 
SELECT
  DATEADD(
    year, 
    DATEDIFF(year, '18991231', SYSDATETIME()), '18991231');

-- DATEPART
-- returns the month of the given date - february
SELECT DATEPART(month, '20160212');

-- DAY, MONTH, YEAR
-- seperates the day, month and year from the given string 
SELECT
  DAY('20160212') AS theday,
  MONTH('20160212') AS themonth,
  YEAR('20160212') AS theyear;

-- DATENAME
-- returns the specified part of the given date, in this case its the month 
SELECT DATENAME(month, '20160212');
-- returns the specified part of the given date, in this case its the year
SELECT DATENAME(year, '20160212');

-- ISDATE
-- ISDATE checks if this is a valid date, in this case it is valid
SELECT ISDATE('20160212');
-- ISDATE checks if this is a valid date, in this case it is not valid
SELECT ISDATE('20160230');

-- fromparts
SELECT
--returns dates from given parts
  DATEFROMPARTS(2016, 02, 12),
--returns datetime2 from given parts
  DATETIME2FROMPARTS(2016, 02, 12, 13, 30, 5, 1, 7),
--returns date time from parts
  DATETIMEFROMPARTS(2016, 02, 12, 13, 30, 5, 997),
--returns datetime offset form parts
  DATETIMEOFFSETFROMPARTS(2016, 02, 12, 13, 30, 5, 1, -8, 0, 7),
--returns a date that is combined with a time of day, no fractional seconds  
  SMALLDATETIMEFROMPARTS(2016, 02, 12, 13, 30),
--returns time from parts  
  TIMEFROMPARTS(13, 30, 5, 1, 7);

-- EOMONTH
-- returns the last day of the given month 
SELECT EOMONTH(SYSDATETIME());

-- orders placed on last day of month
SELECT OrderId, OrderDate, CustomerId, EmployeeId
FROM [Sales].[Order]
WHERE OrderDate = EOMONTH(OrderDate);

---------------------------------------------------------------------
-- Querying Metadata
---------------------------------------------------------------------

-- Catalog Views
USE Northwinds2020TSQLV6;
-- returns schema name with schema ID
SELECT SCHEMA_NAME(schema_id) AS table_schema_name, name AS table_name
FROM sys.tables;

--returns the unqualified type name of sales order
SELECT 
  name AS column_name,
  TYPE_NAME(system_type_id) AS column_type,
  max_length,
  collation_name,
  is_nullable
FROM sys.columns
WHERE object_id = OBJECT_ID(N'[Sales].[Order]');

-- Information Schema Views
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = N'BASE TABLE';

-- returns information schema for sales.orders
SELECT 
  COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, 
  COLLATION_NAME, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = N'Sales'
  AND TABLE_NAME = N'Orders';

-- System Stored Procedures and Functions
--returns a list of objects than can be queried 
EXEC sys.sp_tables;

--returns list of objects that can be queried any table containing the term "sales.order"
EXEC sys.sp_help
  @objname = N'[Sales].[Order]';

--returns nothing
EXEC sys.sp_columns
  @table_name = N'Orders',
  @table_owner = N'Sales';
--returns a list of all constraint types, their user-defined or system-supplied name, the columns on which they have been defined, and the expression that defines the constraint
EXEC sys.sp_helpconstraint
  @objname = N'[Sales].[Order]';
--returns property information about server
SELECT 
  SERVERPROPERTY('ProductLevel');

SELECT
  DATABASEPROPERTYEX(N'Northwinds2020TSQLV6', 'Collation');

SELECT 
  OBJECTPROPERTY(OBJECT_ID(N'[Sales].[Order]'), 'TableHasPrimaryKey');

SELECT
  COLUMNPROPERTY(OBJECT_ID(N'[Sales].[Order]'), N'shipEmployeeCountry', 'AllowsNull');