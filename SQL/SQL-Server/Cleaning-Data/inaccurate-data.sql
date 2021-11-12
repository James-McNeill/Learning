-- Dealing with out of range values, different data types, and pattern matching

-- A. Out of range and inaccurate
-- 1. Out of range
SELECT * FROM series
-- Detect the out of range values
WHERE num_ratings NOT BETWEEN 0 AND 5000

SELECT * FROM series
-- Detect the out of range values
WHERE num_ratings < 0 OR num_ratings > 5000

-- 2. Excluding out of range values
SELECT * FROM series
-- Exclude the out of range values
WHERE num_ratings BETWEEN 0 AND 5000

SELECT * FROM series
-- Exclude the out of range values
WHERE num_ratings >= 0 AND num_ratings <= 5000

-- 3. Detecting and excluding inaccurate data
SELECT * FROM series
-- Detect series for adults
WHERE is_adult = 1
-- Detect series with the minimum age smaller than 18
AND min_age < 18

SELECT * FROM series
-- Filter series for adults
WHERE is_adult = 1
-- Exclude series with the minimum age greater or equals to 18
AND min_age >= 18

-- B. Converting data with different types
-- 1. Using cast() and convert()
-- Use CAST() to convert the num_ratings column
SELECT AVG(CAST(num_ratings AS INT))
FROM series
-- Use CAST() to convert the num_ratings column
WHERE CAST(num_ratings AS INT) BETWEEN 0 AND 5000

-- Use CONVERT() to convert the num_ratings column
SELECT AVG(CONVERT(INT, num_ratings))
FROM series
-- Use CONVERT() to convert the num_ratings column
WHERE CONVERT(INT, num_ratings) BETWEEN 0 AND 5000
