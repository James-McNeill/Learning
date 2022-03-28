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

-- B. Cases and spaces
-- 1. Trimming
SELECT distinct street,
       -- Trim off unwanted characters from street. function(original, values to trim)
       trim(street, '0123456789 #/.') AS cleaned_street
  FROM evanston311
 ORDER BY street;
 
--  2. Exploring unstructured text
-- Count rows
SELECT count(*)
  FROM evanston311
 -- Where description includes trash or garbage. ILIKE: is case insensitive. This does take more memory so be careful
 WHERE description ILIKE '%trash%'
    OR description ILIKE '%garbage%';

-- Select categories containing Trash or Garbage
SELECT category
  FROM evanston311
 -- Use LIKE
 WHERE category LIKE '%Trash%'
    OR category LIKE '%Garbage%';

-- Count rows
SELECT count(*)
  FROM evanston311 
 -- description contains trash or garbage (any case)
 WHERE (description ILIKE '%trash%'
    OR description ILIKE '%garbage%') 
 -- category does not contain Trash or Garbage
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%';

-- Count rows with each category
SELECT category, count(*)
  FROM evanston311 
 WHERE (description ILIKE '%trash%'
    OR description ILIKE '%garbage%') 
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%'
 -- What are you counting?
 GROUP BY category
 --- order by most frequent values
 ORDER BY count(*) DESC
 LIMIT 10;

