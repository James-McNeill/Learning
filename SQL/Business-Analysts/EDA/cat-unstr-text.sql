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

-- C. Splitting and concatenating text
-- 1. Concatenate strings
-- Concatenate house_num, a space, and street
-- and trim spaces from the start of the result
SELECT trim(concat(house_num, ' ', street),' ') AS address
  FROM evanston311;

-- 2. Split strings on a delimiter
-- split_part(string_to_split, delimiter, part_number)
-- Select the first word of the street value
SELECT split_part(street, ' ', 1) AS street_name, 
       count(*)
  FROM evanston311
 GROUP BY street_name
 ORDER BY count DESC
 LIMIT 20;
 
--  3. Shorten long strings
-- Select the first 50 chars when length is greater than 50
SELECT CASE WHEN length(description) > 50
            THEN left(description, 50) || '...'
       -- otherwise just select description
       ELSE description
       END
  FROM evanston311
 -- limit to descriptions that start with the word I
 WHERE description LIKE 'I %'
 ORDER BY description;
 
-- D. Strategies for multiple transformations
-- 1. Create an 'other' category
SELECT CASE WHEN zipcount < 100 THEN 'other'
       ELSE zip
       END AS zip_recoded,
       sum(zipcount) AS zipsum
  FROM (SELECT zip, count(*) AS zipcount
          FROM evanston311
         GROUP BY zip) AS fullcounts
 GROUP BY zip_recoded
 ORDER BY zipsum DESC;
 
--  2. Group and recode values
-- Code from previous step
DROP TABLE IF EXISTS recode;
CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
  FROM evanston311;
UPDATE recode SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';
UPDATE recode SET standardized='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';
UPDATE recode SET standardized='UNUSED' 
 WHERE standardized IN ('THIS REQUEST IS INACTIVE...Trash Cart', 
               '(DO NOT USE) Water Bill',
               'DO NOT USE Trash', 'NO LONGER IN USE');

-- Select the recoded categories and the count of each
SELECT standardized, count(*)
-- From the original table and table with recoded values
  FROM evanston311 
       LEFT JOIN recode
       -- What column do they have in common?
       ON evanston311.category = recode.category
 -- What do you need to group by to count?
 GROUP BY standardized
 -- Display the most common val values first
 ORDER BY count(*) DESC;
 
-- 3. Create a table with indicator variables
-- To clear table if it already exists
DROP TABLE IF EXISTS indicators;

-- Create the temp table
CREATE TEMP TABLE indicators AS
  SELECT id, 
         CAST (description LIKE '%@%' AS integer) AS email,
         CAST (description LIKE '%___-___-____%' AS integer) AS phone 
    FROM evanston311;
  
-- Select the column you'll group by
SELECT priority,
       -- Compute the proportion of rows with each indicator
       sum(email)/count(*)::numeric AS email_prop, 
       sum(phone)/count(*)::numeric AS phone_prop
  -- Tables to select from
  FROM evanston311
       LEFT JOIN indicators
       -- Joining condition
       ON evanston311.id=indicators.id
 -- What are you grouping by?
 GROUP BY priority;
