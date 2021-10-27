-- Techniques to understand query performance tuning

-- 1. STATISTICS TIME in queries
-- Aim of this code is to review the time elapsed comparison between two queries that aim to perform the same operation
SET STATISTICS TIME ON -- Turn the time command on

-- Query 1
SELECT * 
FROM Teams
-- Sub-query 1
WHERE City IN -- Sub-query filter operator
      (SELECT CityName 
       FROM Cities) -- Table from Earthquakes database
-- Sub-query 2
   AND City IN -- Sub-query filter operator
	   (SELECT CityName 
	    FROM Cities
		WHERE CountryCode IN ('US','CA'))
-- Sub-query 3
    AND City IN -- Sub-query filter operator
        (SELECT CityName 
         FROM Cities
	     WHERE Pop2017 >2000000);

-- Query 2
SELECT * 
FROM Teams AS t
WHERE EXISTS -- Sub-query filter operator
	(SELECT 1 
     FROM Cities AS c
     WHERE t.City = c.CityName -- Columns being compared
        AND c.CountryCode IN ('US','CA')
          AND c.Pop2017 > 2000000);

SET STATISTICS TIME OFF -- Turn the time command off

-- 2. STATISTICS IO
-- Aims to review query performance by understanding the number of reads that are made of the tables used within the query.
-- A more efficient query will make less reads of a table
SET STATISTICS IO ON -- Turn the IO command on

-- Example 1. Results will show the number of reads made against each table used
SELECT CustomerID,
       CompanyName,
       (SELECT COUNT(*) 
	    FROM Orders AS o -- Add table
		WHERE c.CustomerID = o.CustomerID) CountOrders
FROM Customers AS c
WHERE CustomerID IN -- Add filter operator
       (SELECT CustomerID 
	    FROM Orders 
		WHERE ShipCity IN
            ('Berlin','Bern','Bruxelles','Helsinki',
			'Lisboa','Madrid','Paris','London'));

-- Example 2. Optimised the number of reads made against each table
SELECT c.CustomerID,
       c.CompanyName,
       COUNT(o.CustomerID)
FROM Customers AS c
INNER JOIN Orders AS o -- Join operator
    ON c.CustomerID = o.CustomerID
WHERE o.ShipCity IN -- Shipping destination column
     ('Berlin','Bern','Bruxelles','Helsinki',
	 'Lisboa','Madrid','Paris','London')
GROUP BY c.CustomerID,
         c.CompanyName;
	 
SET STATISTICS IO OFF -- Turn the IO command off

-- 3. Indexes
-- 1. Clustered index: stores each index value once, similar to a dictionary. Common structure is a B-TREE algorithm
-- 2. Unclustered index: similar to a contents at the back of a book. Maintains the index value similar to page numbers for each item

-- Clustered Index
-- Query 1
SELECT *
FROM Cities
WHERE CountryCode = 'RU' -- Country code
		OR CountryCode = 'CN' -- Country code

-- Query 2: this query runs quicker and performs less reads as the index is in place
SELECT *
FROM Cities
WHERE CountryCode IN ('JM','NZ') -- Country codes

-- 4. Execution plan
-- Can be used to highlight the different operations that take place when the SQL optimizer is working to develop the query operations.
-- Within SSMS it is displayed as a diagram of each individual step in the process
