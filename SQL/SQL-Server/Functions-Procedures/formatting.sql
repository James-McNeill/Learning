-- Creating an order by format to assign the weekdays in a particular order
SELECT
    -- Select the pickup day of week
	DATENAME(weekday, PickupDate) as DayofWeek,
    -- Calculate TotalAmount per TripDistance
	CAST(AVG(TotalAmount/
            -- Select TripDistance if it's more than 0
			CASE WHEN TripDistance > 0 THEN TripDistance
                 -- Use GetTripDistanceHotDeck()
     			 ELSE dbo.GetTripDistanceHotDeck() END) as decimal(10,2)) as 'AvgFare'
FROM YellowTripData
GROUP BY DATENAME(weekday, PickupDate)
-- Order by the PickupDate day of week
ORDER BY
     CASE WHEN DATENAME(weekday, PickupDate) = 'Monday' THEN 1
         WHEN DATENAME(weekday, PickupDate) = 'Tuesday' THEN 2
         WHEN DATENAME(weekday, PickupDate) = 'Wednesday' THEN 3
         WHEN DATENAME(weekday, PickupDate) = 'Thursday' THEN 4
         WHEN DATENAME(weekday, PickupDate) = 'Friday' THEN 5
         WHEN DATENAME(weekday, PickupDate) = 'Saturday' THEN 6
         WHEN DATENAME(weekday, PickupDate) = 'Sunday' THEN 7
END ASC;

-- Options for the FORMAT method
SELECT
    -- Cast PickupDate as a date and display as a German date
	FORMAT(CAST(PickupDate AS date), 'd', 'de-de') AS 'PickupDate',
	Zone.Borough,
    -- Display TotalDistance in the German format
	FORMAT(SUM(TripDistance), 'n', 'de-de') AS 'TotalDistance',
    -- Display TotalRideTime in the German format
	FORMAT(SUM(DATEDIFF(minute, PickupDate, DropoffDate)), 'n', 'de-de') AS 'TotalRideTime',
    -- Display TotalFare in German currency
	FORMAT(SUM(TotalAmount), 'c', 'de-de') AS 'TotalFare'
FROM YellowTripData
INNER JOIN TaxiZoneLookup AS Zone 
ON PULocationID = Zone.LocationID 
GROUP BY
	CAST(PickupDate as date),
    Zone.Borough 
ORDER BY
	CAST(PickupDate as date),
    Zone.Borough;
