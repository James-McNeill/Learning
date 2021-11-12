-- Working with SQL Server to clean datasets

-- A. Unifying formats
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
