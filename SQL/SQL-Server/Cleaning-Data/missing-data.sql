-- Working with missing data
-- A. Missing data
-- 1. Remove missing values
SELECT *
-- Select the appropriate table
FROM airports
-- Exclude the rows where airport_city is NULL
WHERE airport_city IS NOT NULL

SELECT *
-- Select the appropriate table
FROM airports
-- Return only the rows where airport_city is NULL
WHERE airport_city IS NULL

-- 2. Removing blank spaces
SELECT *
-- Select the appropriate table
FROM airports
-- Exclude the rows where airport_city is missing
WHERE airport_city <> ''

SELECT *
-- Select the appropriate table
FROM airports
-- Return only the rows where airport_city is missing
WHERE airport_city = ''
