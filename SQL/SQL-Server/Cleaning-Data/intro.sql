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
