-- Working with SQL Server to clean datasets

-- A. Unifying formats
-- 1. Using the replicate method
SELECT 
	-- Concat the strings
	CONCAT(
		carrier_code, 
		' - ', 
      	-- Replicate zeros
		REPLICATE('0', 9 - LEN(registration_code)), 
		registration_code, 
		', ', 
		airport_code)
	AS registration_code
FROM flight_statistics
-- Filter registers with more than 100 delays
WHERE delayed > 100

-- 2. Using the format method
SELECT 
    -- Concat the strings
	CONCAT(
		carrier_code, 
		' - ', 
        -- Format the code. Input value to method has to be numeric or date/time 
		FORMAT(CAST(registration_code AS INT), '0000000'),
		', ', 
		airport_code
	) AS registration_code
FROM flight_statistics
-- Filter registers with more than 100 delays
WHERE delayed > 100

-- B. Trimming and unifying strings
-- 1. Trimming strings 1
-- TRIM(): has only been available since SQL Server 2017. Prior to this date LTRIM() and RTRIM() would be required to create the same result
SELECT 
	airport_code,
	-- Use the appropriate function to remove the extra spaces
    TRIM(airport_name) AS airport_name,
	airport_city,
    airport_state
-- Select the source table
FROM airports

-- 2. Trimming strings 2
SELECT 
	airport_code,
	-- Use the appropriate function to remove the extra spaces
    LTRIM(RTRIM(airport_name)) AS airport_name,
	airport_city,
    airport_state
-- Select the source table
FROM airports

-- 3. Unifying strings
-- a. Applying replace method to all string values returns an error
SELECT 
	airport_code,
	airport_name,
    -- Use the appropriate function to unify the values
    REPLACE(airport_city, 'ch', 'Chicago') AS airport_city,
	airport_state
FROM airports  
WHERE airport_code IN ('ORD', 'MDW')

-- b. Using the case statement helps to select only the values required to be changed
SELECT airport_code, airport_name, 
	-- Use the CASE statement
	CASE
    	-- Unify the values
		WHEN airport_city <> 'Chicago' THEN REPLACE(airport_city, 'ch', 'Chicago')
		ELSE airport_city 
	END AS airport_city,
    airport_state
FROM airports
WHERE airport_code IN ('ORD', 'MDW')

-- c. Using the upper method ensures that the appropriate case sensitivity is being applied
SELECT 
	airport_code, airport_name,
    	-- Convert to uppercase
    	UPPER(
            -- Replace 'Chicago' with 'ch'.
          	REPLACE(airport_city, 'Chicago', 'ch')
        ) AS airport_city,
    airport_state
FROM airports
WHERE airport_code IN ('ORD', 'MDW')

-- C. String similarity
-- SOUNDEX(): performs phonetical comparison of strings to see how similar they are
-- DIFFERENCE(): returns a number between 0 - 4. With 0 representing no similarity and 4 representing very similar
-- 1. Soundex
SELECT 
    -- First name and surname of the statisticians
	DISTINCT S1.statistician_name, S1.statistician_surname
-- Join flight_statistics with itself
FROM flight_statistics S1 INNER JOIN flight_statistics S2 
	-- The SOUNDEX result of the first name and surname have to be the same
	ON SOUNDEX(S1.statistician_name) = SOUNDEX(S2.statistician_name) 
	AND SOUNDEX(S1.statistician_surname) = SOUNDEX(S2.statistician_surname) 
-- The texts of the first name or the texts of the surname have to be different
WHERE S1.statistician_name <> S2.statistician_name
	OR S1.statistician_surname <> S2.statistician_surname

-- 2. Difference
SELECT 
    -- First name and surnames of the statisticians
	DISTINCT S1.statistician_name, S1.statistician_surname
-- Join flight_statistics with itself
FROM flight_statistics S1 INNER JOIN flight_statistics S2 
	-- The DIFFERENCE of the first name and surname has to be equals to 4
	ON DIFFERENCE(S1.statistician_name, S2.statistician_name) = 4
	AND DIFFERENCE(S1.statistician_surname, S2.statistician_surname) = 4
-- The texts of the first name or the texts of the surname have to be different
WHERE S1.statistician_name <> S2.statistician_name
	OR S1.statistician_surname <> S2.statistician_surname
