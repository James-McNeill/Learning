-- Data Interrogation

-- 1. Filtering
-- Add the new column to the select statement
SELECT PlayerName, 
       Team, 
       Position, 
       AvgRebounds -- Add the new column
FROM
     -- Sub-query starts here                             
	(SELECT 
      PlayerName, 
      Team, 
      Position,
      -- Calculate average total rebounds
     (DRebound+ORebound)/CAST(GamesPlayed AS numeric) AS AvgRebounds
	 FROM PlayerStats) tr
WHERE AvgRebounds >= 12; -- Filter rows

-- Using wildcards, simplfy where possible
SELECT PlayerName, 
      Country,
      College, 
      DraftYear, 
      DraftNumber 
FROM Players 
WHERE College LIKE 'Louisiana%';

-- 2. Having
SELECT Team, 
	SUM(TotalPoints) AS TotalPFPoints
FROM PlayerStats
-- Filter for only rows with power forwards
WHERE Position = 'PF'
GROUP BY Team
-- Filter for total points greater than 3000
HAVING SUM(TotalPoints) > 3000;

-- 3. Selecting sample of rows
-- TOP
SELECT TOP 10 -- Limit the number of rows to ten
      Latitude,
      Longitude,
	  Magnitude,
	  Depth,
	  NearestPop
FROM Earthquakes
WHERE Country = 'PG'
	OR Country = 'ID'
ORDER BY Depth; -- Order results from shallowest to deepest

-- Percentage of rows
SELECT TOP 25 PERCENT -- Limit rows to the upper quartile
       Latitude,
       Longitude,
	   Magnitude,
	   Depth,
	   NearestPop
FROM Earthquakes
WHERE Country = 'PG'
	OR Country = 'ID'
ORDER BY Magnitude DESC; -- Order the results

-- 4. Distinct to remove duplicates
SELECT DISTINCT(NearestPop),-- Remove duplicate city
		Country
FROM Earthquakes
WHERE Magnitude >= 8 -- Add filter condition 
	AND NearestPop IS NOT NULL
ORDER BY NearestPop;

SELECT NearestPop, 
       Country, 
       COUNT(NearestPop) NumEarthquakes -- Number of cities
FROM Earthquakes
WHERE Magnitude >= 8
	AND Country IS NOT NULL
GROUP BY NearestPop, Country -- Group columns
ORDER BY NumEarthquakes DESC;
