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
-- 1. Exploring nationality and gender of actors. Similar to the CUBE.
SELECT 
	nationality, -- Select nationality of the actors
    gender, -- Select gender of the actors
    count(*) -- Count the number of actors
FROM actors
GROUP BY GROUPING SETS ((nationality), (gender), ()); -- Use the correct GROUPING SETS operation. (): corresponds to overall total. Note this will be the first row

-- 2. Exploring rating by country and gender
SELECT 
	c.country, 
    c.gender,
	AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
-- Report all info from a Pivot table for country and gender
GROUP BY GROUPING SETS ((country, gender), (country), (gender), ());

-- D. All together
-- 1. Customer preference for genres
SELECT genre,
	   AVG(rating) AS avg_rating,
	   COUNT(rating) AS n_rating,
       COUNT(*) AS n_rentals,     
	   COUNT(DISTINCT m.movie_id) AS n_movies 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 3 )
AND r.date_renting >= '2018-01-01'
GROUP BY genre
ORDER BY avg(rating) DESC; -- Order the table by decreasing average rating

-- 2. Customer preference for actors
SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating,
	   COUNT(r.rating) AS n_rating,
	   COUNT(*) AS n_rentals,
	   COUNT(DISTINCT a.actor_id) AS n_actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-04-01'
GROUP BY CUBE (a.nationality, a.gender); -- Provide results for all aggregation levels represented in a pivot table
