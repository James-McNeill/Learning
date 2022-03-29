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

-- C. Aggregations - summarizing data
-- 1. Summarizing customer information
SELECT count(*) -- Count the total number of customers
FROM customers
WHERE date_of_birth BETWEEN '1980-01-01' AND '1989-12-31'; -- Select customers born between 1980-01-01 and 1989-12-31

SELECT count(*)   -- Count the total number of customers
FROM customers
WHERE country = 'Germany'; -- Select all customers from Germany

SELECT count(distinct(country))   -- Count the number of countries
FROM customers;

-- 2. Ratings of movie 25
SELECT min(rating) as min_rating, -- Calculate the minimum rating and use alias min_rating
	   max(rating) as max_rating, -- Calculate the maximum rating and use alias max_rating
	   avg(rating) as avg_rating, -- Calculate the average rating and use alias avg_rating
	   count(rating) as number_ratings -- Count the number of ratings and use alias number_ratings
FROM renting
WHERE movie_id = 25; -- Select all records of the movie with ID 25

-- 3. Examining annual rentals
SELECT 
	COUNT(*) AS number_renting,
	AVG(rating) AS average_rating, 
    count(rating) AS number_ratings -- Add the total number of ratings here.
FROM renting
WHERE date_renting >= '2019-01-01';
