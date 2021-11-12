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

-- 4. Fill missing values with coalesce()
SELECT
airport_code,
airport_name,
-- Replace the missing values
COALESCE(airport_city, airport_state, 'Unknown') AS location
FROM airports

-- B. Duplicate data
-- 1. Create row_number() by partition to understand if duplicates exist
SELECT *,
	   -- Apply ROW_NUMBER()
       ROW_NUMBER() OVER (
         	-- Write the partition
            PARTITION BY 
                airport_code, 
                carrier_code, 
                registration_date
			ORDER BY 
                airport_code, 
                carrier_code, 
                registration_date
        ) row_num
FROM flight_statistics

-- 2. Find duplicates
-- Use the WITH clause
WITH cte AS (
    SELECT *, 
        ROW_NUMBER() OVER (
            PARTITION BY 
                airport_code, 
                carrier_code, 
                registration_date
			ORDER BY 
                airport_code, 
                carrier_code, 
                registration_date
        ) row_num
    FROM flight_statistics
)
SELECT * FROM cte
-- Get only duplicates
WHERE row_num > 1;

-- 3. Exclude duplicates
WITH cte AS (
    SELECT *, 
        ROW_NUMBER() OVER (
            PARTITION BY 
                airport_code, 
                carrier_code, 
                registration_date
			ORDER BY 
                airport_code, 
                carrier_code, 
                registration_date
        ) row_num
    FROM flight_statistics
)
SELECT * FROM cte
-- Exclude duplicates
WHERE row_num = 1;

-- C. Date formats
-- 1. Using convert
SELECT 
    airport_code,
    carrier_code,
    canceled,
    -- Convert the registration_date to a DATE and print it in mm/dd/yyyy format
    CONVERT(VARCHAR(10), CAST(registration_date AS DATE), 101) AS registration_date
FROM flight_statistics 
-- Convert the registration_date to mm/dd/yyyy format
WHERE CONVERT(VARCHAR(10), CAST(registration_date AS DATE), 101) 
	-- Filter the first six months of 2014 in mm/dd/yyyy format 
	BETWEEN '01/01/2014' AND '06/30/2014'

-- 2. Using format
SELECT 
	pilot_code,
	pilot_name,
	pilot_surname,
	carrier_code,
    -- Convert the entry_date to a DATE and print it in dd/MM/yyyy format
	FORMAT(CAST(entry_date AS DATE), 'dd/MM/yyyy') AS entry_date
from pilots
