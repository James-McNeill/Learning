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