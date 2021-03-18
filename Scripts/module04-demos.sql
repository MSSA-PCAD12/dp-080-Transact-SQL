-- This script contains demo code for Module 5 of the Transact-SQL course



-- Basic scalar functions

-- Dates
SELECT  AddressID, AddressLine1,
        YEAR(ModifiedDate) AS ModifiedYear,
        DATENAME(mm,ModifiedDate) AS ModifiedMonth,
        DAY(ModifiedDate) AS ModifiedDay,
        DATENAME(dw, ModifiedDate) AS ModifiedWeekDay,
        DATEDIFF(yy,ModifiedDate, GETDATE()) AS TimeSinceModification
FROM SalesLT.Address
ORDER BY ModifiedDate


-- Math
SELECT TaxAmt,
       ROUND(TaxAmt, 0) AS Rounded,
       FLOOR(TaxAmt) AS Floor,
       CEILING(TaxAmt) AS Ceiling,
       SQUARE(TaxAmt) AS Squared,
       SQRT(TaxAmt) AS Root,
       LOG(TaxAmt) AS Log,
       TaxAmt * RAND() AS Randomized
FROM SalesLT.SalesOrderHeader


-- Text
SELECT  CompanyName,
        UPPER(CompanyName) AS UpperCase,
        LOWER(CompanyName) AS LowerCase,
        LEN(CompanyName) AS Length,
        REVERSE(CompanyName) AS Reversed,
        CHARINDEX(' ', CompanyName) AS FirstSpace,
        LEFT(CompanyName, CHARINDEX(' ', CompanyName)) AS FirstWord,
        SUBSTRING(CompanyName, CHARINDEX(' ', CompanyName) + 1, LEN(CompanyName)) AS RestOfName
FROM SalesLT.Customer;




-- Logical

-- IIF
SELECT AddressType, -- Evaluation       if True    if False    
       IIF(AddressType = 'Main Office', 'Billing', 'Mailing') AS AddressDescription
FROM SalesLT.CustomerAddress;


-- CHOOSE

-- Prepare by updating status to a value between 1 and 5
UPDATE SalesLT.SalesOrderHeader
SET Status = SalesOrderID % 5 + 1

-- Now use CHOOSE to map the status code to a value in a list
SELECT SalesOrderID, Status,
       CHOOSE(Status, 'Ordered', 'Confirmed', 'Shipped', 'Delivered', 'Completed') AS OrderStatus
FROM SalesLT.SalesOrderHeader;




-- RANKING Functions

-- Ranking
SELECT TOP(100) ProductID, Name, ListPrice,
	RANK() OVER(ORDER BY ListPrice DESC) AS RankByPrice
FROM SalesLT.Product AS p
ORDER BY RankByPrice;

-- Partitioning
SELECT c.Name AS Category, p.Name AS Product, ListPrice,
	RANK() OVER(PARTITION BY c.Name ORDER BY ListPrice DESC) AS RankByPrice
FROM SalesLT.Product AS p
JOIN SalesLT.ProductCategory AS c
ON p.ProductCategoryID = c.ProductcategoryID
ORDER BY Category, RankByPrice;




-- Aggregate functions and GROUP BY

-- Aggergate functions
SELECT COUNT(*) AS ProductCount,
       MIN(ListPrice) AS MinPrice,
       MAX(ListPrice) AS MaxPrice,
       AVG(ListPrice) AS AvgPrice
FROM SalesLT.Product


-- Group by
SELECT c.Name AS Category,
       COUNT(*) AS ProductCount,
       MIN(p.ListPrice) AS MinPrice,
       MAX(p.ListPrice) AS MaxPrice,
       AVG(p.ListPrice) AS AvgPrice
FROM SalesLT.ProductCategory AS c
JOIN SalesLT.Product AS p
    ON p.ProductCategoryID = c.ProductCategoryID
GROUP BY c.Name -- (can't use alias because GROUP BY happens before SELECT)
ORDER BY Category; -- (can use alias because ORDER BY happens after SELECT)

-- Filter aggregated groups
-- How NOT to do it!
SELECT c.Name AS Category,
       COUNT(*) AS ProductCount,
       MIN(p.ListPrice) AS MinPrice,
       MAX(p.ListPrice) AS MaxPrice,
       AVG(p.ListPrice) AS AvgPrice
FROM SalesLT.ProductCategory AS c
JOIN SalesLT.Product AS p
    ON p.ProductCategoryID = c.ProductCategoryID
WHERE COUNT(*) > 1 -- Attempt to filter on grouped aggregate = error!
GROUP BY c.Name
ORDER BY Category;

-- How to do it
SELECT c.Name AS Category,
       COUNT(*) AS ProductCount,
       MIN(p.ListPrice) AS MinPrice,
       MAX(p.ListPrice) AS MaxPrice,
       AVG(p.ListPrice) AS AvgPrice
FROM SalesLT.ProductCategory AS c
JOIN SalesLT.Product AS p
    ON p.ProductCategoryID = c.ProductCategoryID
GROUP BY c.Name
HAVING COUNT(*) > 1 -- Use HAVING to filter after grouping
ORDER BY Category;

