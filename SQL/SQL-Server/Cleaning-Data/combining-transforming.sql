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

-- 2. left(), right() and reverse()
SELECT
	client_name,
	client_surname,
    -- Extract the name of the city
	LEFT(city_state, CHARINDEX(', ', city_state) - 1) AS city,
    -- Extract the name of the state
    RIGHT(city_state, CHARINDEX(' ,', REVERSE(city_state)) - 1) AS state
FROM clients_split

-- C. Pivot or unpivot
-- 1. Turning rows into columns
SELECT
	year_of_sale,
    -- Select the pivoted columns
	notebooks, 
	pencils, 
	crayons
FROM
   (SELECT 
		SUBSTRING(product_name_units, 1, charindex('-', product_name_units)-1) product_name, 
		CAST(SUBSTRING(product_name_units, charindex('-', product_name_units)+1, len(product_name_units)) AS INT) units,	
		year_of_sale
	FROM paper_shop_monthly_sales) sales
-- Sum the units for column that contains the values that will be column headers
PIVOT (SUM(units) FOR product_name IN (notebooks, pencils, crayons))
-- Give the alias name
AS paper_shop_pivot

-- 2. Turning columns into rows. Note that the unique data that created the original pivot table can not be reproduced by using unpivot
SELECT * FROM pivot_sales
-- Use the operator to convert columns into rows
UNPIVOT
	-- The resulting column that will contain the turned columns into rows
	(units FOR product_name IN (notebooks, pencils, crayons))
-- Give the alias name
AS unpivot_sales
