-- Working with SQL in a structured manner

-- 1. Formatting
-- Ensure all SQL syntax is in upper case
SELECT PlayerName, Country,
ROUND(Weight_kg/SQUARE(Height_cm/100),2) BMI
FROM Players 
WHERE Country = 'USA'
    OR Country = 'Canada'
ORDER BY BMI;

-- Adding comments
/*
Returns the Body Mass Index (BMI) for all North American players
from the 2017-2018 NBA season
*/

SELECT PlayerName, Country,
    ROUND(Weight_kg/SQUARE(Height_cm/100),2) BMI 
FROM Players 
WHERE Country = 'USA'
    OR Country = 'Canada';
-- ORDER BY BMI;

-- Debugging queries with comments. Maintains a record of the query history
-- Your friend's query
-- First attempt, contains errors and inconsistent formatting
/*
select PlayerName, p.Country,sum(ps.TotalPoints) 
AS TotalPoints  
FROM PlayerStats ps inner join Players On ps.PlayerName = p.PlayerName
WHERE p.Country = 'New Zeeland'
Group 
by PlayerName, Country
order by Country;
*/

-- Your query
-- Second attempt - errors corrected and formatting fixed

SELECT p.PlayerName, p.Country,
		SUM(ps.TotalPoints) AS TotalPoints  
FROM PlayerStats ps 
INNER JOIN Players p
	ON ps.PlayerName = p.PlayerName
WHERE p.Country = 'New Zealand'
GROUP BY p.PlayerName, p.Country;

-- 2. Using Aliasing. Helps to streamline the code
SELECT Team, 
   ROUND(AVG(BMI),2) AS AvgTeamBMI -- Alias the new column
FROM PlayerStats AS ps -- Alias PlayerStats table
INNER JOIN
		(SELECT PlayerName, Country,
			Weight_kg/SQUARE(Height_cm/100) BMI
		 FROM Players) AS p -- Alias the sub-query
             -- Alias the joining columns
	ON ps.PlayerName = p.PlayerName 
GROUP BY Team
HAVING AVG(BMI) >= 25;
