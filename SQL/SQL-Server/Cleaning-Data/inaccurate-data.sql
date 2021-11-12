-- Dealing with out of range values, different data types, and pattern matching

-- A. Out of range and inaccurate
-- 1. Out of range
SELECT * FROM series
-- Detect the out of range values
WHERE num_ratings NOT BETWEEN 0 AND 5000

SELECT * FROM series
-- Detect the out of range values
WHERE num_ratings < 0 OR num_ratings > 5000