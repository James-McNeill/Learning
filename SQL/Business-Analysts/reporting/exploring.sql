-- Exploring the case study

-- Build base report
-- Query the sport and distinct number of athletes
SELECT 
	sport, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY sport
-- Only include the 3 sports with the most athletes
ORDER BY athletes DESC
LIMIT 3;

-- Query sport, events, and athletes from summer_games
SELECT 
	sport, 
    COUNT(DISTINCT event) AS events, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY sport;

-- Using multiple tables to create report
-- Entity Relationship (E:R) graph showed how tables interact
-- Select the age of the oldest athlete for each region
SELECT 
	c.region, 
    MAX(age) AS age_of_oldest_athlete
FROM athletes AS a
-- First JOIN statement
JOIN summer_games AS s
ON a.id = s.athlete_id
-- Second JOIN statement
JOIN countries AS c
ON s.country_id = c.id
GROUP BY c.region;

-- Number of events in each sport
-- Select sport and events for summer sports
SELECT 
	sport, 
    COUNT(DISTINCT event) AS events
FROM summer_games
GROUP BY sport
UNION
-- Select sport and events for winter sports
SELECT 
	sport, 
    COUNT(DISTINCT event) AS events
FROM winter_games
GROUP BY sport
-- Show the most events at the top of the report
ORDER BY events DESC;

-- Validating the query
/* Pull total_bronze_medals below
SELECT SUM(bronze) AS total_bronze_medals
FROM summer_games; 
>> OUTPUT = 141 total_bronze_medals */

-- Select the total bronze_medals from your query
SELECT sum(bronze_medals)
FROM 
-- Previous query is shown below.  Alias this AS subquery
  (SELECT 
      country, 
      SUM(bronze) AS bronze_medals
  FROM summer_games AS s
  JOIN countries AS c
  ON s.country_id = c.id
  GROUP BY country) AS subquery
;

-- Report 1: Most decorated summer athlete
-- Pull athlete_name and gold_medals for summer games
SELECT 
	a.name AS athlete_name, 
    SUM(s.gold) AS gold_medals
FROM summer_games AS s
JOIN athletes AS a
ON s.athlete_id = a.id
GROUP BY a.name
-- Filter for only athletes with 3 gold medals or more
HAVING SUM(s.gold) >= 3
-- Sort to show the most gold medals at the top
ORDER BY SUM(s.gold) DESC;
