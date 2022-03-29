-- Data Driven Decision Making with OLAP SQL queries
-- The OLAP extensions in SQL are introduced and applied to aggregated data on multiple levels. These extensions are the CUBE, ROLLUP and GROUPING SETS operators.

-- A. OLAP: CUBE operator
-- 1. Groups of customers
SELECT gender, -- Extract information of a pivot table of gender and country for the number of customers
	   country,
	   count(*)
FROM customers
GROUP BY CUBE (gender, country)
ORDER BY country;

-- 2. Categories of movies
SELECT genre,
       year_of_release,
       count(*)
FROM movies
GROUP BY CUBE (genre, year_of_release)
ORDER BY year_of_release;

-- 3. Analyzing average ratings
SELECT 
	c.country, 
	m.genre, 
	AVG(r.rating) AS avg_rating -- Calculate the average rating 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY CUBE (c.country, m.genre); -- For all aggregation levels of country and genre

-- B. ROLLUP operator
-- The order of the variables being used to group by is important. The level of segmentation reduces by rows
-- 1. Number of customers
-- Count the total number of customers, the number of customers for each country, and the number of female and male customers for each country
SELECT country,
       gender,
	   COUNT(*)
FROM customers
GROUP BY ROLLUP (country, gender)
ORDER BY country, gender; -- Order the result by country and gender

-- 2. Analyzing preferences of genres across countries
-- Group by each county and genre with OLAP extension
SELECT 
	c.country, 
	m.genre, 
	AVG(r.rating) AS avg_rating, 
	COUNT(*) AS num_rating
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY ROLLUP (c.country, m.genre)
ORDER BY c.country, m.genre;

-- C. GROUPING SETS
-- 1. 
