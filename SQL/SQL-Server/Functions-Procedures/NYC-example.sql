-- Create stored procedure that will compute the borough stats
CREATE OR ALTER PROCEDURE dbo.cuspBoroughRideStats
AS
BEGIN
SELECT
    -- Calculate the pickup weekday
	DATENAME(weekday, PickupDate) AS 'Weekday',
    -- Select the Borough
	Zone.Borough AS 'PickupBorough',
    -- Display AvgFarePerKM as German currency
	FORMAT(AVG(dbo.ConvertDollar(TotalAmount, .88)/dbo.ConvertMiletoKm(TripDistance)), 'c', 'de-de') AS 'AvgFarePerKM',
    -- Display RideCount in the German format
	FORMAT(COUNT(ID), 'n', 'de-de') AS 'RideCount',
    -- Display TotalRideMin in the German format
	FORMAT(SUM(DATEDIFF(SECOND, PickupDate, DropOffDate))/60, 'n', 'de-de') AS 'TotalRideMin'
FROM YellowTripData
INNER JOIN TaxiZoneLookup AS Zone 
ON PULocationID = Zone.LocationID
-- Only include records where TripDistance is greater than 0
WHERE TripDistance > 0
-- Group by pickup weekday and Borough
GROUP BY DATENAME(WEEKDAY, PickupDate), Zone.Borough
ORDER BY CASE WHEN DATENAME(WEEKDAY, PickupDate) = 'Monday' THEN 1
	     	  WHEN DATENAME(WEEKDAY, PickupDate) = 'Tuesday' THEN 2
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Wednesday' THEN 3
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Thursday' THEN 4
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Friday' THEN 5
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Saturday' THEN 6
              WHEN DATENAME(WEEKDAY, PickupDate) = 'Sunday' THEN 7 END,  
		 SUM(DATEDIFF(SECOND, PickupDate, DropOffDate))/60
DESC
END;

-- Run the Stored Procedure and store the results in a TABLE
-- Create SPResults
DECLARE @SPResults TABLE(
  	-- Create Weekday
	Weekday nvarchar(30),
    -- Create Borough
	Borough nvarchar(30),
    -- Create AvgFarePerKM
	AvgFarePerKM nvarchar(30),
    -- Create RideCount
	RideCount nvarchar(30),
    -- Create TotalRideMin
	TotalRideMin nvarchar(30))

-- Insert the results into @SPResults
INSERT INTO @SPResults
-- Execute the SP
EXEC dbo.cuspBoroughRideStats

-- Select all the records from @SPresults 
SELECT * 
FROM @SPResults;
