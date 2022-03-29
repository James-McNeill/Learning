-- Decision Making with simple SQL queries

-- A. Grouping movies
-- 1. First account for each country
SELECT country, -- For each country report the earliest date when an account was created
	min(date_account_start) AS first_account
FROM customers
GROUP BY country
ORDER BY first_account DESC;

-- 2. Average movie ratings
SELECT movie_id, 
       AVG(rating) AS avg_rating,
       COUNT(rating) AS number_ratings,
       COUNT(*) AS number_renting
FROM renting
GROUP BY movie_id
ORDER BY avg_rating DESC; -- Order by average rating in decreasing order

-- 3. Average rating per customer
SELECT customer_id, -- Report the customer_id
      avg(rating),  -- Report the average rating per customer
      count(rating),  -- Report the number of ratings per customer
      count(*)  -- Report the number of movie rentals per customer
FROM renting
GROUP BY customer_id
HAVING count(*) > 7 -- Select only customers with more than 7 movie rentals
ORDER BY avg(rating); -- Order by the average rating in ascending order

-- B. Joining movie ratings with customer data
-- 1. Join renting and customers
SELECT avg(r.rating) -- Average ratings of customers from Belgium
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
WHERE c.country='Belgium';

-- 2. Aggregating revenue, rentals and active customers
SELECT 
	SUM(m.renting_price), 
	COUNT(*), 
	COUNT(DISTINCT r.customer_id)
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
-- Only look at movie rentals in 2018
WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31';

-- 3. Movies and actors
SELECT distinct(a.name), -- Create a list of movie titles and actor names
       m.title
FROM actsin ai
LEFT JOIN movies AS m
ON m.movie_id = ai.movie_id
LEFT JOIN actors AS a
ON a.actor_id = ai.actor_id;

