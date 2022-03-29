-- Data Driven Decision Making with advanced SQL queries

-- A. Nested query
-- 1. Often rented movies
SELECT *
FROM movies
WHERE movie_id IN  -- Select movie IDs from the inner query
	(SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(*) > 5)

-- 2. Frequent customers
SELECT *
FROM customers
WHERE customer_id IN            -- Select all customers with more than 10 movie rentals
	(SELECT customer_id
	FROM renting
	GROUP BY customer_id
	HAVING count(*) > 10);

-- 3. Movies with rating above average
SELECT title -- Report the movie titles of all movies with average rating higher than the total average
FROM movies
WHERE movie_id IN 
	(SELECT movie_id
	 FROM renting
     GROUP BY movie_id
     HAVING AVG(rating) > 
		(SELECT AVG(rating)
		 FROM renting));

-- B. Correlated Nested queries
-- 1. Analyzing customer behavior
-- Select customers with less than 5 movie rentals
SELECT *
FROM customers as c
WHERE 5 > 
	(SELECT count(*)
	FROM renting as r
	WHERE r.customer_id = c.customer_id); -- correlated connection between the inner and outer query datasets being used

-- 2. Customers who gave low ratings
SELECT *
FROM customers AS c
WHERE 4 > -- Select all customers with a minimum rating smaller than 4 
	(SELECT MIN(rating)
	FROM renting AS r
	WHERE r.customer_id = c.customer_id);

-- 3. Movies and ratings with correlated queries
SELECT *
FROM movies AS m
WHERE 5 < -- Select all movies with more than 5 ratings
	(SELECT count(rating)
	FROM renting AS r
	WHERE r.movie_id = m.movie_id);

SELECT *
FROM movies AS m
WHERE 8 < -- Select all movies with an average rating higher than 8
	(SELECT avg(rating)
	FROM renting AS r
	WHERE r.movie_id = m.movie_id);
-- Didn't have to use a group by clause to arrive at the final answer

-- C. Queries with exists
-- 1. Customers with at least one rating
SELECT *
FROM customers AS c -- Select all customers with at least one rating
WHERE EXISTS -- using this to return all the customers that have at least one rating
	(SELECT *
	FROM renting AS r
	WHERE rating IS NOT NULL 
	AND r.customer_id = c.customer_id);

-- 2. Actors in comedies
SELECT a.nationality, count(*) -- Report the nationality and the number of actors for each nationality
FROM actors AS a
WHERE EXISTS
	(SELECT ai.actor_id
	 FROM actsin AS ai
	 LEFT JOIN movies AS m
	 ON m.movie_id = ai.movie_id
	 WHERE m.genre = 'Comedy'
	 AND ai.actor_id = a.actor_id)
GROUP BY a.nationality;

-- D. Queries with UNION and INTERSECT
-- 1. Young actors not coming from the USA
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
UNION -- Select all actors who are not from the USA and all actors who are born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;

SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
INTERSECT -- Select all actors who are not from the USA and who are also born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;

-- 2. Dramas with high ratings
SELECT *
FROM movies
WHERE movie_id IN -- Select all movies of genre drama with average rating higher than 9
   (SELECT movie_id
    FROM movies
    WHERE genre = 'Drama'
    INTERSECT
    SELECT movie_id
    FROM renting
    GROUP BY movie_id
    HAVING AVG(rating)>9);
