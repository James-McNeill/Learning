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
