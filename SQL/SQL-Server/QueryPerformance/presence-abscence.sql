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
