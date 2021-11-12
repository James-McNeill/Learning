-- Combining, splitting, and transforming data

-- A. Combining
-- 1. Using +
SELECT 
	client_name,
	client_surname,
    -- Concatenate city with state
    city + ', ' + state AS city_state
FROM clients

SELECT 
	client_name,
	client_surname,
    -- Consider the NULL values
	ISNULL(city, '') + ISNULL(', ' + state, '') AS city_state
FROM clients

-- 2. Concat(). Can be used since version 2012
SELECT 
		client_name,
		client_surname,
    -- Use the function to concatenate the city and the state
		CONCAT(
				city,
				CASE WHEN state IS NULL THEN '' 
				ELSE CONCAT(', ', state) END) AS city_state
FROM clients
