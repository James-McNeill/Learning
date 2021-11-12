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

-- 3. Working with datefromparts()
SELECT 
	product_name,
	units,
    -- Use the function to concatenate the different parts of the date
	DATEFROMPARTS(
      	year_of_sale, 
      	month_of_sale, 
      	day_of_sale) AS complete_date
FROM paper_shop_daily_sales

-- B. Splitting
-- 1. substring() and charindex()
SELECT 
	client_name,
	client_surname,
    -- Extract the name of the city
	SUBSTRING(city_state, 1, CHARINDEX(', ', city_state) - 1) AS city,
    -- Extract the name of the state
    SUBSTRING(city_state, CHARINDEX(', ', city_state) + 1, LEN(city_state)) AS state
FROM clients_split
