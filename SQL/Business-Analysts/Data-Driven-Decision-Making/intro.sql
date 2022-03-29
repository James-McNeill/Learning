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
