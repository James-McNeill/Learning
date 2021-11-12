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

-- 3. Fill missing values with isnull()
SELECT
  airport_code,
  airport_name,
  -- Replace missing values for airport_city with 'Unknown'
  ISNULL(airport_city, 'Unknown') AS airport_city,
  -- Replace missing values for airport_state with 'Unknown'
  ISNULL(airport_state, 'Unknown') AS airport_state
FROM airports
