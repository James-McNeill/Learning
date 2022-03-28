-- Exploring categorical data and unstructured text

-- Text, or character, data can get messy, but you'll learn how to deal with inconsistencies in case, spacing, and delimiters. 
-- Learn how to use a temporary table to recode messy categorical data to standardized values you can count and aggregate.

-- A. Character data types and common issues
-- 1. Count the categories
-- Select the count of each level of priority
SELECT priority, count(*)
  FROM evanston311
GROUP BY priority;

-- Find values of source that appear in at least 100 rows
-- Also get the count of each value
SELECT source, count(*)
  FROM evanston311
 GROUP BY source
HAVING count(*) >= 100;

-- Find the 5 most common values of street and the count of each
SELECT street, count(*)
  FROM evanston311
 GROUP BY street
 ORDER BY count(*) DESC
 LIMIT 5;
