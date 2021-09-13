-- Declare @Shifts as a TABLE
DECLARE @Shifts TABLE(
    -- Create StartDateTime column
	StartDateTime datetime,
    -- Create EndDateTime column
	EndDateTime datetime)
-- Populate @Shifts
INSERT INTO @Shifts (StartDateTime, EndDateTime)
	SELECT '3/1/2018 8:00 AM', '3/1/2018 4:00 PM'
SELECT * 
FROM @Shifts

-- INSERT INTO the results of a query
-- Declare @RideDates
DECLARE @RideDates TABLE(
    -- Define RideStart column
	RideStart date, 
    -- Define RideEnd column
    RideEnd date)
-- Populate @RideDates
INSERT INTO @RideDates(RideStart, RideEnd)
-- Select the unique date values of StartDate and EndDate
SELECT DISTINCT
    -- Cast StartDate as date
	CAST(StartDate as date),
    -- Cast EndDate as date
	CAST(EndDate as date) 
FROM CapitalBikeShare 
SELECT * 
FROM @RideDates
