/* Combine Tables
Rows - SET Operators - Requirements: Same Columns
Columns - JOIN operators - Requirements: Key Columns
*/

USE MyDatabase

-- NO JOIN: Two Results - All Data from Left Table & Right Table
SELECT * FROM customers;
SELECT * FROM orders;

-- INNER JOIN: Returns ONLY matching rows from BOTH tables
-- Get All customers with an order but only who have placed an order
-- Order is not crucial
SELECT * 
FROM customers
INNER JOIN orders
ON customers.id = orders.customer_id

-- LEFT JOIN: Returns ALL rows from LEFT Table and Only Matching Rows from Right Table
-- Get All customers along with their customers; also those without orders
-- Order is Crucial
SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id

-- RIGHT JOIN: Returns ONLY matching rows from LEFT Table and ALL rows from RIGHT TABLE
-- ORDER is Crucial -- Here the RIGHT TABLE IS CRUCIAL
-- Get All customers along with their order and orders without matching customers
SELECT 
	c.id,
	o.order_id,
	o.sales,
	c.first_name
FROM customers AS c
RIGHT JOIN orders AS o
ON o.customer_id = c.id

-- Same Task but with LEFT JOIN
SELECT
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM orders as o
LEFT JOIN customers as c
ON c.id = o.customer_id

-- FULL JOIN: Returns all rows from BOTH Tables
SELECT * FROM orders FULL JOIN customers ON customer_id = id 

/* Advanced JOIN TYPES */

-- LEFT ANTI JOIN: Returns rows from the Left Table that have NO MATCH in the Right Table
-- Get all customers who have not placed an order
SELECT *
FROM customers
LEFT JOIN orders
ON id = customer_id
WHERE customer_id IS NULL

-- RIGHT ANTI JOIN: Returns rows from the Right Table that have no MATCH in the Left Table
-- Get all orders without matching customers
SELECT *
FROM customers
RIGHT JOIN orders
ON id = customer_id
WHERE id IS NULL

-- DELETE FROM customers WHERE id = 6

-- SAME TASK: LEFT JOIN
SELECT *
FROM orders
LEFT JOIN customers
ON customer_id = id
WHERE id IS NULL

-- FULL ANTI JOIN: Returns rows that are NOT common in BOTH tables// UNMATCHING ROWS in Either Table // ONLY UNMATCHING DATA
-- Find customers without orders and orders without customers
SELECT *
FROM customers
FULL JOIN orders
ON id = customer_id
WHERE
	id IS NULL OR customer_id IS NULL

-- Get all customers along with their orders but only customers who have placed an order
SELECT *
FROM customers
FULL JOIN orders
ON id = customer_id
WHERE NOT(id IS NULL OR customer_id IS NULL)

-- WITHOUT FULL JOIN
SELECT *
FROM customers
LEFT JOIN orders
ON id = customer_id
WHERE customer_id IS NOT NULL

/* CROSS JOIN */
-- CARTERSIAN JOIN
-- COMBINES EVERY ROW FROM THE LEFT TABLE  EVERY ROW OF THE RIGHT TABLE
-- Generate all the combinations for customers and orders
SELECT *
FROM customers
CROSS JOIN orders
ORDER BY id DESC


/* Using SalesDB, Retrieve a list of all orders along with related customer, product and employee details
For Each Order, Display:
Order ID
Customer's Name
Product Name
Sales Amount
Product Price
Salesperson's Name
*/

USE SalesDB

SELECT TOP(5) * FROM Sales.Orders
SELECT TOP(5) * FROM Sales.Employees
SELECT TOP(5) * FROM Sales.OrdersArchive
SELECT TOP(5) * FROM Sales.Customers
SELECT TOP(5) * FROM Sales.Products

--
SELECT
	o.OrderID,
	concat(e.FirstName,' ',e.LastName) AS SalesPerson,
	o.Sales,
	concat(c.FirstName,' ',c.LastName) AS CustomerName,
	p.Product AS ProductName,
	p.Price
FROM Sales.Orders AS o
LEFT JOIN Sales.Customers AS c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products AS p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees AS e
ON o.SalesPersonID = e.EmployeeID
	






/* SET OPERATORS
Combines ROWS

RULES:
1. SET Operator can be used almost with all Clauses:
													WHERE \\ HAVING \\ GROUP BY \\ JOIN
2. ORDER BY is allowed only once and at the end of the ENTIRE query.
3. Number of Columns in EACH query MUST be the SAME.
4. Datatypes of each column MUST match.
5. Order of Columns in EACH query MUST be the SAME.
6. Column Names in the result set are determined by the Column Names/Alias in the FIRST query.
7. Correct Column Selection: Even if SQL shows no errors, the results might be inaccurate there Correct Column Selection must be ensured.

*/

USE SalesDB

SELECT
	firstname,
	lastname
FROM Sales.Customers

UNION

SELECT
	firstname,
	lastname
FROM Sales.Employees

-- RULE 7: MAPPING CORRECT COLUMNS
SELECT
	firstname,
	lastname
FROM Sales.Customers

UNION

SELECT
	lastname,
	firstname
FROM Sales.Employees
-- Poor Data Quality
-- The Result is shown with no errors, however due to inaccurate mapping, last name will be shown in the firstname column.

-- UNION
-- Returns all DISTINCT Rows from both the queries 
-- Removes all duplicates from the result
-- Combine the data from employees and customers into One Table
SELECT 
	FirstName,
	LastName
FROM Sales.Customers

UNION

SELECT
	FirstName,
	LastName
FROM Sales.Employees

-- UNION ALL
-- Returns all rows from both the queries
-- Does NOT remove duplicates
-- Better Performance as duplicates are not removed
SELECT 
	FirstName,
	LastName
FROM Sales.Customers

UNION ALL

SELECT
	FirstName,
	LastName
FROM Sales.Employees

-- EXCEPT
-- Returns all DISTINCT rows from the first query that are not found in the second query
-- Order of the queries affect the result set
-- Find the employees that are not the customers
SELECT 
	FirstName,
	LastName
FROM Sales.Employees

EXCEPT

SELECT
	FirstName,
	LastName
FROM Sales.Customers

-- INTERSECT
-- Returns only Rows that are common in both queries
-- Removes Duplicates
-- Find the employees that are also customers
SELECT 
	FirstName,
	LastName
FROM Sales.Employees

INTERSECT

SELECT
	FirstName,
	LastName
FROM Sales.Customers

-- UNION: Use Case
-- Orders are stored in Order and OrdersArchive.
-- Combine all orders into one Table without duplicates

Select 
	'Orders' As SourceTable,
	[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
From Sales.Orders
UNION
Select
'OrdersArchive' As SourceTable,
[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime]
From Sales.OrdersArchive
ORDER BY OrderID ASC
-- NEVER use * when combining tables, Always List needed Columns

-- EXCEPT: Use Case: Data Engineering // Load New Data To the Data Warehouse from Source System
-- 1. DELTA // Difference(Changes) DETECTION between Two Batches of Data
-- 2. Data Completeness Check for Data Migration - Ensure that No Data is Missing 
--	A EXCEPT B -> B EXCEPT A >> If Result Set is EMPTY for both cases, All Data Migrated Completely



-- IMP!! For Data Engineering
/* FUNCTIONS

1. Single Row i.e. LOWER()
2. Multi Row i.e. SUM()

NESTED FUNCTIONS: Function used within a Function
'Maria' > LEFT(2) > 'MA' > LOWER() > 'ma' >> LOWER(LEFT('Maria',2)) == 'ma'

*/

Use SalesDB

-- Single Row Functions (Data Engineers)

-- STRING Functions
-- MANIPULATION

SELECT TOP(2) 
	concat(FirstName,' ',LastName) AS CustomerName, -- concat: Combines multiple strings into one
	UPPER(FirstName) AS FName_CAPS, -- UPPER: UPPERCASE ALL Characters VALUE
	LOWER(LastName) AS LNAME_Lower, -- LOWER: LOWERCASE ALL Characters VALUE
	TRIM() AS NOSPACE, -- TRIM(): Removes Leading & Trailing Spaces
	REPLACE() AS Replace -- REPLACE(): Not only Replaces but can also remove a character
FROM Sales.Customers

-- Show customers First names and Countries in One Column
SELECT 
	concat(FirstName,' ',Country) AS FirstName_Country -- concat: Combines multiple strings into one
FROM Sales.Customers

-- Find all customers that have leading or trailing spaces
USE MyDatabase
Select * FROM customers
WHERE first_name != TRIM(first_name) -- Condition to check Leading & Trailing Spaces

-- Another way is to check Length
SELECT
first_name,
len(first_name) As Length,
len(trim(first_name)) As LEN_TRIM
FROM customers

-- Remove -- dashes from number
SELECT
	'123-456-789' As Number,
	REPLACE('123-456-789','-','') AS REMOVED,
	REPLACE('123-456-789','-','//') AS REPLACED

-- Change File Extensions
SELECT
	'NAME.txt' As file_name,
	Replace('NAME.txt','.txt','.csv') As Correct_ext

-- CALCULATIONS
-- LEN(): Counts how many Characters

-- STRING EXTRACTION
-- LEFT(): Extracts specific number of characters from the START
-- RIGHT(): Extracts specific number of characters from the END
-- SUBSTRING(): Extracts a part of the string from a specified position // SUBSTRING( VALUE, START, LENGTH )

SELECT
 '123456',
 SUBSTRING('123456',2,4) -- 2 is Starting Point then Counts upto 4 characters after that hence 5 is included

 -- Retrieve a list of customers with their first letter removed
SELECT
	first_name AS Name,
	SUBSTRING(first_name,2,LEN(first_name)) AS Output -- Here LEN() Makes the SUBSTRING Dynamic so a static length for cutoff is not given
FROM customers

-- NUMERIC FUNCTIONS

SELECT
3.514,
ROUND(3.514,2) AS round_2, -- Rounds up/down the number
ROUND(3.514,1) AS round_1,
ROUND(3.514,0) AS round_0,
ABS(-3.514) As absolute -- Returns positive value of a number, removing the negative sign

-- DATE & TIME FUNCTIONS

USE SalesDB

SELECT
OrderID,
OrderDate, -- Type: Date
ShipDate, -- Type: Date
CreationTime, -- Type: Datetime // It is a timestamp (DATE + TIME)
'2025-11-03' as HARDCODED,
GETDATE() AS Today -- Gets the current date and time when the query is executed
FROM sales.orders

-- Part Extraction

SELECT
OrderID,
CreationTime,
DAY(CreationTime) AS Day, -- Returns the Day from the Date
MONTH(CreationTime) AS Month,
Year(CreationTime) AS Year
FROM sales.Orders

SELECT
OrderID,
CreationTime,
DATEPART(week,CreationTime) AS week_dp, -- Returns specific part of the date as a Number (in this example, the week of the date in the year)
DATEPART(year,CreationTime) AS year_dp,
DATEPART(hour,CreationTime) AS hour_dp,
DATEPART(quarter,CreationTime) AS quarter_dp,
DATEPART(WEEKDAY,CreationTime) AS weekday_dp
FROM sales.Orders

SELECT
ORDERID,
CreationTime,
DATEPART(weekday,CreationTime) AS weekday_dp,
DATENAME(weekday,CreationTime) AS weekday_dn -- Returns the specific part of the date as STRING (Wednesday,August etc.)
FROM sales.Orders

SELECT
ORDERID,
CREATIONTIME,
DATEPART(month,CreationTime) AS month_dp,
DATENAME(month,CreationTime) AS month_dn,
DATETRUNC(month,CreationTime) AS month_trunc, -- Changes the level of detail in the DATETIME
DATETRUNC(minute,CreationTime) AS minute_trunc -- Details will be preserved until minutes and rest is RESET
FROM sales.Orders

-- USE CASE for TRUNC
-- Numbers of orders in a Month
SELECT
DATETRUNC(month,CreationTIME) AS month_trunc,
Count(*) AS Count
FROM Sales.Orders
GROUP BY DATETRUNC(month,CreationTIME)

-- Number of orders in a year
SELECT
DATETRUNC(year,CREATIONTIME) AS year_trunc,
COUNT(*)
FROM sales.Orders
GROUP BY DATETRUNC(year,CreationTIME)

SELECT
CREATIONTIME,
EOMONTH(CREATIONTIME) AS end_of_month,-- Resets the DAY to the LAST DAY of the MONTH
CAST(DATETRUNC(month,CREATIONTIME) AS DATE) AS start_of_month -- Resets everything after the month so First Day is set
FROM sales.Orders

-- Number of orders in a month(string)
SELECT
DATENAME(month,CREATIONTIME) AS month,
COUNT(*) as number_of_orders
FROM sales.orders
GROUP BY DATENAME(month,CREATIONTIME)

SELECT
MONTH(ORDERDATE) AS Month,
COUNT(*) AS num_of_orders
FROM sales.Orders
GROUP BY MONTH(ORDERDATE)

-- How many orders were placed each year?
SELECT
DATEPART(year,OrderDate) AS year_dp,
Count(*) AS num_of_orders
FROM sales.Orders
GROUP BY DATEPART(year,OrderDate)

SELECT
YEAR(ORDERDATE) AS order_date,
COUNT(*) AS num_of_orders
FROM sales.Orders
GROUP BY Year(Orderdate)

-- Show all orders that were placed in the month of February
SELECT
ORDERID,
ORDERDATE
FROM Sales.Orders
WHERE DATENAME(month,ORDERDATE) = 'February' -- USE DATEPART AS BEST PRACTICE

SELECT
ORDERID,
ORDERDATE
FROM sales.Orders
WHERE MONTH(ORDERDATE) = 2

-- DATE FORMATING & CASTING
-- Format: Changes the appearance of the value
-- Casting: Changes the DATATYPE of the value

SELECT
OrderID,
CreationTime,
FORMAT(CreationTime,'dd') AS dd,
FORMAT(CreationTime,'ddd') AS ddd,
FORMAT(CreationTime,'dd-MM-yyyy') AS DD_MM_YYYY
FROM Sales.orders

-- Show Creation Date as the following Format
-- DAY WED JAN Q1 2025  12:34:56 PM
SELECT
OrderID,
CreationTime,
'Day ' + UPPER(Format(CreationTime,'ddd MMM'))
+ ' Q' + DATENAME(quarter,CreationTime)
+ FORMAT(CreationTime,' yyyy hh:mm:ss tt') AS Custom_Format
FROM sales.orders

SELECT
FORMAT(OrderDate,'MMM yy') AS order_date,
COUNT(*) AS num_of_orders
FROM sales.Orders
GROUP BY FORMAT(OrderDate,'MMM yy')

-- CONVERT(): Change the Date or Time value to a different type & formats the type
SELECT
CONVERT(INT,'123') AS [String to INT CONVERT], -- [] Helps in Naming the Column Freely
CONVERT(DATE,'11 July 1998') AS [String to DATE CONVERT],
CreationTime,
CONVERT(VARCHAR,CreationTime,34) [Datetime to VARCHAR] -- 34 is style dd-MM-yyyy
FROM sales.Orders

SELECT
CAST(CREATIONTIME AS VARCHAR) [DATE TO VARCHAR],
CAST(CreationTime AS DATE) [DATETIME2 to DATE]
FROM sales.orders

-- DATE CALCULATIONS
-- DATEADD(): Add/Subtract a time interval to/from a date
SELECT
CreationTime,
DATEADD(month,3,CreationTIME) [3 Months Added],
DATEADD(year,-5,CreationTime) [5 Years Subtracted]
FROM sales.Orders

-- DATEDIFF(): Find Difference between Two dates
SELECT
DATEDIFF(year,DATEADD(year,-5,CreationTime),GETDATE()) AS [years difference]
FROM sales.orders

-- Get the age of all employees
SELECT
BirthDate,
DATEDIFF(year,Birthdate,GETDATE()) [AGE]
FROM sales.Employees

-- Find the average shipping duration in days for each month
SELECT
DATENAME(month,OrderDate) AS [Month],
AVG(DATEDIFF(day,OrderDate,ShipDate)) AS [AVG SHIP]
FROM sales.orders
GROUP BY DATENAME(month,OrderDate)

-- TIME GAP Analysis
-- Find the number of days between each order and previous order
SELECT
OrderDate CurrentOrderDate,
LAG(OrderDate) OVER(Order by OrderDate) PreviousOrderDate, -- LAG(): Access a value from previous row
DATEDIFF(day,LAG(OrderDate) OVER(Order by OrderDate),OrderDate) AS [Days Difference]
FROM sales.Orders

-- Date Validation
-- ISDATE(): Check if a value is a date // Returns 1 if it is a Date
SELECT
ISDATE(123) AS [Check if int it is a DATE],
ISDATE('STRING') AS [Check if String is a Date],
ISDATE('11/05/2025') AS [Check if string is date] -- Given input has to follow format

-- USE CAST
-- Cast Values as DATES

SELECT 
OrderDate,
ISDATE(OrderDate) AS [Check if it is a Date],
CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE) ELSE '9999-12-11' -- Dummy Value
END NewDate
FROM
( SELECT '2021-09-01' AS OrderDate
	UNION
	SELECT '2022-10-23'
	UNION
	SELECT '2025-08'
)t -- T is alias for subquery
-- WHERE ISDATE(ORDERDATE) = 0 / Get values where condition is failed and not casted as date

-- NULL Functions
-- NULL To Value: ISNULL() // COALESCE()
-- VALUE To NULL: NULLIF()
-- CHECK NULL: IS NULL // IS NOT NULL

-- COALESCE: Return the first non Null value from a List // Slow as if takes in multiple values // ISNULL() takes in two values

-- USE CASE: Handle NULL values before Data Aggregation
-- Find the AVG Scores for the Customers
SELECT
CustomerID,
Score,
AVG(SCORE) OVER() as AVGSCORE,
AVG(COALESCE(Score,0)) OVER() AVGSCORE_NONULLs
FROM Sales.Customers

-- USE CASE: HANDLE NULLs Before mathematical operations
-- Display the Full customer Name in a single field and all 10 to their scores
SELECT
FirstNAME + ' ' + COALESCE(LASTNAME,'') AS [Customer Name],
Score,
COALESCE(Score,0) + 10 [New Score]
FROM sales.Customers

-- Sort the Scores with Nulls Appearing LAST
SELECT
Score,
CASE WHEN Score IS NULL THEN 1 ELSE 0 END [FLAG] -- THIS IS A FLAG
FROM sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score

-- NULLIF(): Compares Two Expressions
-- IF EQUAL, NULL is Returned
-- IF NOT, Then First Value is Returned

-- USE CASE: DIVISION BY 0
-- Find the sales price of each order by dividing sales by quantity
SELECT
ORDERID,
Quantity,
Sales,
Sales / NULLIF(Quantity,0) [Sales Price]
FROM sales.Orders

-- IS NULL // IS NOT NULL (USE CASE): Searching for missing information
-- Identify the customers who have no scores
SELECT
*
FROM SALES.Customers
WHERE Score IS NULL

-- Show a List of all customers who have a score
SELECT *
FROM sales.Customers
WHERE SCORE IS NOT NULL

-- Find unmatching rows between two tables (LEFT//RIGHT ANTI JOIN)
-- List all details of a customer who has not placed an order
SELECT
c.*,
o.OrderID
FROM sales.Customers AS c
LEFT JOIN sales.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.CreationTime IS NULL

-- NULL vs Empty String Vs BLank Spaces

WITH Orders AS (
SELECT 1 ID,'A' Category UNION
SELECT 2,NULL UNION
SELECT 3, '' UNION
SELECT 4,' '
) 
SELECT
*,
DATALENGTH(Category) [CategoryLEN]
FROM Orders

-- Values:
-- NULL = Unknown (Unknown Value)
-- Empty String = 0 (Known but Empty Value)
-- Blank Spaces = Number of Spaces (1 in this case) (Known Space Value)

-- DATA POLICIES
-- Set of rules on how the data will be handled.
-- 1. Use NULLs and empty strings but not Blank Spaces.
-- 2. ONLY USE NULLS and avoid empty string and blank spaces
-- 3. USE a default value and Avoid Using NULLS,Empty Spaces or Blank Spaces

WITH Orders AS (
SELECT 1 ID,'A' Category UNION
SELECT 2,NULL UNION
SELECT 3, '' UNION
SELECT 4,'  '
) 
SELECT
*,
DATALENGTH(Category) [CategoryLEN],
TRIM(Category) [Policy1],
DATALENGTH(TRIM(Category)) [Policy1LEN],
NULLIF(TRIM(Category),'') [Policy2], -- After removing spaces, if both are empty strings, Return NULL
COALESCE(NULLIF(TRIM(Category),''),'unknown') [Policy3]
FROM Orders

 -- USE Policy 2 When Storage is the task
 -- USE Policy 3 When Reporting is the task

 -- NULLs are special markers that represent missing value or unknown value


 -- CASE STATEMENTS
 -- Main Purpose: Data Transformation // Derive New Information // Create New Columns Based on Existing Data
 -- Categorize Data

 -- Generate a Report showing the total sales for each category:
 -- High: If sales>50
 -- Medium: If sales between 20 and 50
 -- Low: if sales<=20
 -- Sort the result from lowest to highest
 SELECT
 SUM(Sales) AS TotalSales,
 Category
 FROM
 (
	 SELECT
	 Sales,
	 CASE
	 WHEN Sales > 50 THEN 'High'
	 WHEN Sales > 20 THEN 'Medium'
	 ELSE 'Low'
	 END [Category]
	 From sales.Orders
)t
 GROUP BY Category
 ORDER BY TotalSales ASC
 
 -- Datatypes of the Rules Must MATCH // In this case, It is a string i.e. High/Medium/Low

 -- USE CASE: Mapping Values
 -- Retrieve Employee details as Full Text
 SELECT
 EmployeeID,
 FirstName,
 LastName,
 CASE
	WHEN Gender = 'M' THEN 'MALE'
	ELSE 'FEMALE'
 END [GenderFullText]
 FROM sales.Employees

 -- Retrieve the customers details with abbreviated country codes
 
SELECT DISTINCT Country FROM sales.Customers -- First find out all the countries present in the table
 
SELECT
 CustomerID,
 FirstName,
 CASE
	WHEN Country = 'Germany' THEN 'GR'
	WHEN Country = 'USA' THEN 'US'
	ELSE 'N/A'
 END [abCountry]
 FROM sales.Customers

 -- QUICK FORMAT/FORM: CASE <Column> WHEN 'VALUE' THEN 'Result'

 SELECT
 CustomerID,
 FirstName,
 CASE Country
	WHEN 'GERMANY' THEN 'DE'
	WHEN 'USA' THEN 'US'
END [CountryAbb]
FROM sales.Customers
 
 -- Handling Nulls
 -- Find the avg scores of customers and treat null as 0
 -- and additionally provide customer ID and last name
 SELECT
 CustomerID,
 SCORE,
 COALESCE(LASTNAME,'N/A') AS [LASTNAME],
 AVG(
	 CASE
		WHEN SCORE IS NULL THEN 0
		ELSE SCORE
	 END
 ) OVER() [AVG SCORE]
 FROM sales.Customers

 -- Conditional Aggregation
 -- Applying aggregation functions over a subset of data that fulfills certain conditions
 -- Count how many times a customer has made an order with sales greater than 30
SELECT 
	CustomerID,
	SUM(CASE 
		WHEN Sales > 30 THEN 1
		ELSE 0
	END) TotalOrdersHigh,
	COUNT(*) AS TotalOrders
FROM sales.Orders
GROUP BY CustomerID




-- IMP!! For Data Analysis

/* AGGREGATE FUNCTIONS
*/

-- Find the Total number of orders
-- Find Total Sales
-- Find Avg Sales of all orders
-- Find highest/lowest sale
-- Now, Break down these stats per customer ID
SELECT
customer_id,
COUNT(*) TotalOrders,
SUM(Sales) TotalSales,
AVG(Sales) AVGSales,
MAX(Sales) HighestSale,
Min(Sales) LowestSale
FROM orders
GROUP BY customer_id

-- Analyze the Scores in Table Customers
SELECT
country,
Count(*) as TotalScore,
SUM(Score) as ScoreSUM,
AVG(Score) as AVGScore,
MAX(Score) as MAX_Score,
MIN(Score) as MIN_Score
FROM customers
GROUP BY country

-- Window Functions
-- Retains number of rows for results
-- Aggregations + Details
-- Similar to GROUP BY, However, Window Functions are used for Advanced Data Analysis

-- Find total number of sales for each Product
-- additionally provide OrderID & OrderDate
USE SalesDB
-- GROUP BY does the aggregation but loses the details
SELECT 
ProductID,
OrderID,
OrderDate,
SUM(Sales) [TotalSales]
FROM Sales.Orders
GROUP BY 
	ProductID,
	OrderID,
	OrderDate

-- USE Window Functions for the Same Task
-- Result Granularity: Result is given for each row

SELECT
OrderID,
OrderDate,
Sales,
SUM(Sales) OVER() [TotalSales],
ProductID,
SUM(Sales) OVER(PARTITION BY ProductID) [TotalSalesByProduct],
OrderStatus,
SUM(Sales) OVER(PARTITION BY ProductID,OrderStatus) [SalesByProductAndStatus]
FROM Sales.Orders

-- Rank each order by its sales
-- Provide extra details

SELECT
OrderID,
OrderDate,
Sales,
RANK() OVER(ORDER BY Sales DESC) [RankedOrderBySales]
FROM Sales.Orders

-- Find the total sales for each product but for only product 101 and 102
SELECT
	OrderID,
	ProductID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus) [TotalSales]
FROM Sales.Orders
WHERE ProductID < 103 -- PRODUCTID IN (101,102)

-- FRAME INSIDE A WINDOW
SELECT
	ORDERID,
	ORDERDATE,
	ORDERSTATUS,
	SALES,
	SUM(Sales) OVER(PARTITION BY ORDERSTATUS ORDER BY ORDERDATE ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) [TotalSales]
FROM Sales.Orders
--

--
SELECT
	ORDERID,
	ORDERDATE,
	ORDERSTATUS,
	Sales,
	SUM(Sales) OVER (Partition BY ORDERSTATUS ORDER BY ORDERDATE ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) [TotalSales]
FROM Sales.Orders
--


-- Rank the customers based on their total sales
SELECT
	CustomerID,
	SUM(Sales) [TotalSales],
	RANK() OVER(ORDER BY SUM(Sales) DESC) [Rank Customer]
FROM Sales.Orders
GROUP BY CustomerID

SELECT DISTINCT
	CustomerID,
	COUNT(*) OVER (PARTITION BY CustomerID) [CountOfCustomer]
FROM Sales.Orders
ORDER BY CustomerID DESC

SELECT
	CustomerID
FROM Sales.Orders

-- Find number of total orders
-- Provide extra details
SELECT
	OrderID,
	CustomerID,
	OrderDate,
	COUNT(ORDERID) OVER() [TotalOrders],
	COUNT(ORDERID) OVER(PARTITION BY CustomerID) [TotalOrdersByEachCustomer]

FROM Sales.Orders

-- Find Total Number of Customers
-- Provide Extra Details
-- DATA QUALITY CHECK: DETECTING NUMBER OF NULLS BY COMPARING TO TOTAL NUMBER OF ROWS
SELECT
	*,
	COUNT(CustomerID) OVER() [TotalCustomers],
	COUNT(Score) OVER() [NumberOfScore]
FROM Sales.Customers

-- Find Any DUPLICATES

SELECT
	ORDERID,
	COUNT(ORDERID) OVER(PARTITION BY ORDERID) [CHECK] -- ORDERID is Primary Key PK, Must have no Duplicates i.e. 1 for all rows
FROM Sales.Orders
-- Check for duplicates in OrdersArchive Table and Then only Show Keys that are duplicate (Subqueries)
SELECT
*
FROM (
		SELECT
			ORDERID,
			COUNT(*) OVER(PARTITION BY ORDERID) [CHECKPK]
		FROM Sales.OrdersArchive )t
WHERE CHECKPK > 1

-- Find the total sales across all products
-- Find the total sales for each product
-- Additional information like OrderID, OrderDate

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	SUM(Sales) OVER() [TotalSales],
	SUM(Sales) OVER(PARTITION BY ProductID) [SalesByProduct]
FROM Sales.Orders

-- Part to Whole Analysis: Shows the contribution of a data point to overall dataset
-- Find the percentage contribution of sales of the product to total sales
-- FORMULA: Percentage Contribution = ( Product Sales / Total Sales ) * 100
SELECT
	ORDERID,
	ORDERDATE,
	PRODUCTID,
	Sales,
	SUM(Sales) OVER() [TotalSales],
	ROUND(CAST(Sales AS FLOAT) / SUM(Sales) OVER() * 100,2) [PercentageOfTotal] -- Due to Different Datatype, Error will be shown, Use CAST and ROUND
FROM Sales.Orders


-- Find Average Scores of the Customers
-- Additional Information Such as CustomerID and Last Name
USE SalesDB

SELECT
CustomerID,
LastName,
Score,
COALESCE(Score,0) [CustomerScore],
AVG(Score) OVER() [WrongAVG], -- NULLS not Handled
AVG(COALESCE(Score,0)) OVER() [AVGScore] -- Handle the NULL to get the Correct AVG
FROM Sales.Customers

-- Comparison Analysis: Helps to evaluate whether a value is above or below the average
-- Find all sales that are higher than the average sale across all orders

SELECT
*
FROM(
		SELECT
			OrderID,
			Sales,
			AVG(Sales) OVER() [AVGSales]
		FROM Sales.Orders )t
WHERE Sales > AVGSales

-- Conditional Aggregations
-- Aggregate functions on subsets of data

-- Count how many times each customer made an order with sales greater than 30

SELECT
	CustomerID,
	SUM(CASE
		WHEN Sales > 30 THEN 1
		ELSE 0
	END) [TotalSalesHigher],
	COUNT(*) AS TotalOrders
FROM Sales.Orders
GROUP BY CustomerID

-- USE CASE: Total Per Groups
-- Group Wise Analysis, to understand patterns within different categories

-- Find the average sales across all orders
-- Find average sales for each product
-- Additionally provide details such as orderID

SELECT
	ORDERID,
	ORDERDATE,
	PRODUCTID,
	Sales,
	AVG(Sales) OVER () [AVGSales],
	AVG(Sales) OVER (PARTITION BY PRODUCTID) [AVGSalesByProduct]
FROM Sales.Orders

-- Find the Highest and Lowest Sales of all orders
-- Find the Highest and Lowest Sales for each product
-- Additionally Provide details such as OrderID etc...

SELECT
	ORDERID,
	ORDERDATE,
	PRODUCTID,
	Sales,
	MIN(Sales) OVER () [LowestSales],
	MAX(Sales) OVER () [HighestSales],
	MIN(Sales) OVER (PARTITION BY PRODUCTID) [LowestSaleByProduct],
	MAX(Sales) OVER (PARTITION BY PRODUCTID) [HighestSaleByProduct]
FROM SALES.Orders

-- Show the Employees who have the highest salaries
SELECT
	*
FROM (SELECT
	*,
	MAX(Salary) OVER () [MaxSalary]
FROM Sales.Employees
)t WHERE Salary = MaxSalary

-- USE CASE: COMPARE TO EXTREMES
-- Help to Evaluate How well a value is performing relative to the extremes
-- Find the Deviation of each sale from minimum and maximum sales amounts
-- The Lower the deviation, the closer the data point is to the extreme

SELECT
	ORDERID,
	ORDERDATE,
	PRODUCTID,
	Sales,
	MIN(Sales) OVER () [LowestSales],
	MAX(Sales) OVER () [HighestSales],
	Sales - MIN(Sales) OVER () [DeviationFromMin],
	MAX(Sales) OVER () - Sales [DeviationFromMax]
FROM SALES.Orders


-- VERY IMP!!!
/* RUNNING & ROLLING TOTAL
Tracking (Use Case): Tracking Current Sales with Target Sales
Trend Analysis (Use Case): Providing Insights Into Historical Patterns
*** They Aggregate sequence of members and the aggregation is updated each time a new member is added ***
		*** ANALYSIS OVER TIME ***

RUNNING TOTAL: Aggregate All Values From The Beginning To The Current Value Without Dropping Off Older Data
ROLLING TOTAL: Aggregate All Values Within A Fixed Time Window (e.g. 30 Days) // As new data is added, oldest data point will be dropped.
(Rolling/Shifting Window)


RUNNING TOTAL = SUM(SALES) OVER(ORDER BY MONTH ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
ROLLING TOTAL = SUM(SALES) OVER(ORDER BY MONTH ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
*/

-- Calculate the MOVING average of sales for each product over time
SELECT
	ORDERID,
	ORDERDATE,
	PRODUCTID,
	Sales,
	AVG(Sales) OVER (PARTITION BY PRODUCTID ORDER BY ORDERDATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) [MovingAVG]
FROM Sales.Orders

-- Calculate the MOVING average of sales for each product over time, including only the next order
SELECT
	ORDERID,
	ORDERDATE,
	PRODUCTID,
	Sales,
	AVG(Sales) OVER (PARTITION BY PRODUCTID ORDER BY ORDERDATE ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) [RollingAVG]
FROM Sales.Orders

-- Window Ranking Functions
/*
-- Distribution Analysis: Percentage Based Ranking = 0,0.25,0.5.....1 (Continuous Values)
-- Functions: CUME_DIST(), PERCENT_RANK()
-- Use Case: Find Top 20% Products Based on Sales

-- Top/Bottom N Analysis: Integer Based Ranking: 1,2,3,4,5..... (Discrete Values)
-- Functions: ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE()
-- Use Case: Find Top 3 Products
*/

-- Rank The Orders Based On Their Sales From Highest To Lowest
SELECT
	ORDERID,
	PRODUCTID,
	SALES,
	RANK() OVER (ORDER BY SALES DESC) [RankBySales], -- Handles Ties, Has Gaps
	ROW_NUMBER() OVER (ORDER BY SALES DESC) [RankRowBySales], -- No Gaps and Doesnt Handle Ties
	DENSE_RANK() OVER (ORDER BY SALES DESC) [DenseRankRowBySales] -- Handles Ties, No Gaps
FROM SALES.ORDERS

-- USE CASE: TOP-N ANALYSIS: Analysis the top performers to do targeted marketing
-- Find the top highest sales for each product
SELECT * FROM	(SELECT
		ORDERID,
		PRODUCTID,
		SALES,
		ROW_NUMBER() OVER (PARTITION BY PRODUCTID ORDER BY SALES DESC) [Rank]
	FROM SALES.ORDERS)t WHERE Rank = 1

-- USE CASE: BOTTOM N Analysis: Help analysis the underperformance to manage risks to do optimizations
-- Find the lowest 2 customers based on their total sales
SELECT * FROM	(SELECT
		CUSTOMERID,
		SUM(Sales) [TotalSales],
		ROW_NUMBER() OVER(ORDER BY SUM(Sales)) [RowRank]
	FROM Sales.Orders
	GROUP BY CustomerID)t WHERE RowRank IN (1,2)

-- USE CASE: GENERATE UNIQUE IDs: Help to assign unique identifier for each row to help paginating
-- Assign Unique IDs to the Rows of The 'Orders Archive' Table
SELECT
*,
ROW_NUMBER() OVER(ORDER BY ORDERID,ORDERDATE) [UniqueID]
FROM Sales.OrdersArchive

-- Paginating: The Process of breaking down a large data into smaller, more manageable chunks

-- USE CASE: IDENTIFY DUPLICATES
-- Identify and remove duplicates rows to improve data quality
-- Identify duplicate rows and return a clean result without duplicates for Orders Archive
SELECT * FROM (SELECT
ROW_NUMBER() OVER(PARTITION BY ORDERID ORDER BY CREATIONTIME DESC) [rn],
*
FROM Sales.OrdersArchive)t WHERE rn = 1

-- NTILE(): Divides the rows into a specified number of approx equal groups(buckets)
-- Bucket Size = Number of Rows / Number of Buckets
-- SQL Rule: Larger Groups Come First
SELECT
	ORDERID,
	Sales,
	NTILE(3) OVER (ORDER BY Sales DESC) [3Bucket],
	NTILE(2) OVER (ORDER BY Sales DESC) [2Bucket],
	NTILE(1) OVER (ORDER BY Sales DESC) [1Bucket]
FROM Sales.Orders

-- USE CASE: DATA SEGMENTATION: Divides a dataset into distinct subsets based on certain criteria (Data Analysis)
-- Segment all orders into 3 categories: High, Medium and Low Sales
SELECT 
*,
CASE WHEN Buckets = 1 Then 'High'
	WHEN Buckets = 2 Then 'Medium'
	ELSE 'Low'
END [Category]
FROM (SELECT
	ORDERID,
	PRODUCTID,
	Sales,
	NTILE(3) OVER(ORDER BY SALES DESC) [Buckets]
FROM Sales.Orders)t

-- USE CASE: EQUALIZING LOAD: Load balancing in ETL (DATA ENGINEERING)
-- In order to export the data, divide the orders into 2 groups
SELECT
	ORDERID,
	NTILE(2) OVER(ORDER BY ORDERID) Buckets -- Use Primary key whenever you can **Good Practice** 
FROM SALES.ORDERS


-- Percentage Based Ranking
-- CUME_DIST(): Cumulative Distribution Calculates the distribution of data points within a window
-- Formula: CUME_DIST() = Position Number / Number of Rows
-- Tie Rule: The position of the LAST occurrence of the same value
-- Inclusive: The current row is included

SELECT
 ORDERID,
 Sales,
 CUME_DIST() OVER (ORDER BY SALES DESC) [PercentageRankingCumulative]
FROM Sales.Orders

-- PERCENT_RANK(): Calculates the relative position of each row
-- Formula: CUME_DIST() = Position Number - 1 / Number of Rows - 1
-- Tie Rule: The position of the FIRST occurrence of the same value
-- Exclusive: The current row is excluded
SELECT
 ORDERID,
 Sales,
 ROUND(PERCENT_RANK() OVER (ORDER BY SALES DESC),3) [PercentageRanking]
FROM Sales.Orders

-- Find the products that fall within the highest 40% of the prices
SELECT * FROM	(SELECT
			Product,
			Price,
			CUME_DIST() OVER (ORDER BY PRICE DESC) [%Ranking]
		FROM Sales.Products)t WHERE [%Ranking] <= 0.4



-- VALUE WINDOW FUNCTIONS: Access a value from other ROW
-- Compare Sales: Previous Month Vs Current Month Vs Next Month: LAG() // LEAD() Functions
-- FIRST_VALUE() // LAST_VALUE()

-- USE CASE: MoM (Month Over Month) Analysis // YoY (Year Over Year)
-- Time Series Analysis: The process of analyzing data to understand patters,trends, behaviors over time.
-- Analyze the MoM performance by finding the percentage change in sales between the current and previous month
SELECT
*,
[CurrentMonthSales] - [PreviousMonthSales] AS [MoM_Change],
CONCAT(ROUND(CAST(([CurrentMonthSales] - [PreviousMonthSales]) AS FLOAT)/ [PreviousMonthSales] * 100,2),'%')  AS [%MoM_Change]
FROM
		(SELECT
			MONTH(ORDERDATE) [OrderMonth],
			SUM(Sales) [CurrentMonthSales],
			LAG(SUM(Sales)) OVER(ORDER BY MONTH(ORDERDATE)) [PreviousMonthSales] 
		FROM Sales.Orders
		GROUP BY MONTH(ORDERDATE))t 


-- Customer Retention Analysis
-- Measure customer's behavior and loyalty to help businesses build strong relationships with customers
-- In order to analyze customer loyalty, rank customers based on average days between their orders
SELECT
CUSTOMERID,
AVG(DaysTilNextOrder) [AvgDays],
RANK() OVER(ORDER BY COALESCE(AVG(DaysTilNextOrder),99999)) [Rank] --COALESCE to negate the error from NULL value
FROM (SELECT
			ORDERID,
			CUSTOMERID,
			ORDERDATE [CurrentOrder],
			LEAD(ORDERDATE) OVER(PARTITION BY CUSTOMERID ORDER BY ORDERDATE) [NextOrder],
			DATEDIFF(day,ORDERDATE,LEAD(ORDERDATE) OVER(PARTITION BY CUSTOMERID ORDER BY ORDERDATE)) [DaysTilNextOrder]
		FROM SALES.ORDERS)t
GROUP BY CUSTOMERID

-- Find the lowest and the highest sales for each product
SELECT
	PRODUCTID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY PRODUCTID ORDER BY Sales) [LowestValue],
	LAST_VALUE(Sales) OVER(PARTITION BY PRODUCTID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) [HighestValue],
	-- For LAST_VALUE, YOU HAVE TO DEFINE A FRAME OTHERWISE THE VALUES WILL BE WRONG
	LAST_VALUE(Sales) OVER(PARTITION BY PRODUCTID ORDER BY Sales) [WRONGLASTVALUE],
	-- Sorting the data differently in FIRST_VALUE can also give the highest value
	FIRST_VALUE(Sales) OVER(PARTITION BY PRODUCTID ORDER BY Sales DESC) [HighestValue2],
	-- MIN() AND MAX() can also give the same results without sorting
	MIN(Sales) OVER(PARTITION BY PRODUCTID) [LowestValueMin],
	MAX(Sales) OVER(PARTITION BY PRODUCTID) [HighestValueMin]
FROM SALES.Orders
