-- Introduction to business intelligence for a online movie rental database

-- A. Introduction to data driven decision making
-- 1. Exploring the table renting
SELECT *  -- Select all
FROM renting;        -- From table renting

SELECT movie_id,  -- Select all columns needed to compute the average rating per movie
       rating
FROM renting;

-- B. Filtering and ordering
-- 1. Working with dates
SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-04-01' AND '2018-08-31'
ORDER BY date_renting DESC; -- Order by recency in decreasing order

-- 2. Selecting movies
SELECT *
FROM movies
WHERE genre != 'Drama' ; -- All genres except drama

SELECT *
FROM movies
WHERE title IN ('Showtime', 'Love Actually', 'The Fighter'); -- Select all movies with the given titles

SELECT *
FROM movies
ORDER BY renting_price ; -- Order the movies by increasing renting price

-- 3. Select from renting
SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31' -- Renting in 2018
AND rating IS NOT NULL; -- Rating exists
