-- Presence and abscence review
-- Understanding if data is present or absent from a table

-- 1. Intersect. Data is present in two tables
SELECT Capital
FROM Nations -- Table with capital cities

INTERSECT -- Add the operator to compare the two queries

SELECT NearestPop -- Add the city name column
FROM Earthquakes;

-- 2. Except. Data is present in one table but abscent in the other
SELECT Code2 -- Add the country code column
FROM Nations

EXCEPT -- Add the operator to compare the two queries

SELECT Country 
FROM Earthquakes; -- Table with country codes

-- 3. IN and EXISTS
-- First attempt
SELECT CountryName,
       Pop2017, -- 2017 country population
        Capital, -- Capital city	   
       WorldBankRegion
FROM Nations
WHERE Capital IN -- Add the operator to compare queries
        (SELECT NearestPop 
	     FROM Earthquakes);
       
-- Second attempt
SELECT CountryName,   
	   Capital,
       Pop2016, -- 2016 country population
       WorldBankRegion
FROM Nations AS n
WHERE EXISTS -- Add the operator to compare queries
	  (SELECT 1
	   FROM Earthquakes AS e
	   WHERE n.Capital = e.NearestPop); -- Columns being compared

-- 4. NOT IN and NOT EXISTS
SELECT WorldBankRegion,
       CountryName
FROM Nations
WHERE Code2 NOT IN -- Add the operator to compare queries
	(SELECT CountryCode -- Country code column
	 FROM Cities);
	 
SELECT WorldBankRegion,
       CountryName,
	   Code2,
       Capital, -- Country capital column
	   Pop2017
FROM Nations AS n
WHERE NOT EXISTS -- Add the operator to compare queries
	(SELECT 1
	 FROM Cities AS c
	 WHERE n.Code2 = c.CountryCode); -- Columns being compared

-- 5. NOT IN with IS NOT NULL
SELECT WorldBankRegion,
       CountryName,
       Capital -- Capital city name column
FROM Nations
WHERE Capital NOT IN
	(SELECT NearestPop -- City name column
     FROM Earthquakes);
     
SELECT WorldBankRegion,
       CountryName,
       Capital
FROM Nations
WHERE Capital NOT IN
	(SELECT NearestPop
     FROM Earthquakes
     WHERE NearestPop IS NOT NULL); -- filter condition

-- 6. LEFT OUTER JOIN (inclusive)
-- First attempt
SELECT c.CustomerID,
       c.CompanyName,
	   c.ContactName,
	   c.ContactTitle,
	   c.Phone 
FROM Customers c
LEFT OUTER JOIN Orders o -- Joining operator
	ON c.CustomerID = o.CustomerID -- Joining columns
WHERE c.Country = 'France';

-- 7. LEFT OUTER JOIN (exclusive)
-- Second attempt
SELECT c.CustomerID,
       c.CompanyName,
	   c.ContactName,
	   c.ContactTitle,
	   c.Phone 
FROM Customers c
LEFT OUTER JOIN Orders o
	ON c.CustomerID = o.CustomerID
WHERE c.Country = 'France'
	AND o.CustomerID IS NULL; -- Filter condition
