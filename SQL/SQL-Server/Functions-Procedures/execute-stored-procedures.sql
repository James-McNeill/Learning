-- 1. Execute stored procedure with output parameter
-- Create @RideHrs, which will be the output parameter to store the stored procedure results in
DECLARE @RideHrs AS numeric(18,0)
-- Execute the stored procedure
EXEC dbo.cuspSumRideHrsSingleDay
    -- Pass the input parameter
	@DateParm = '3/1/2018',
    -- Store the output in @RideHrs
	@RideHrsOut = @RideHrs OUTPUT
-- Select @RideHrs
SELECT @RideHrs AS RideHours

-- 2. Execute stored procedure with return value
-- Create @ReturnStatus
DECLARE @ReturnStatus AS int
-- Execute the SP, storing the result in @ReturnStatus
EXEC @ReturnStatus = dbo.cuspRideSummaryUpdate
    -- Specify @DateParm
	@DateParm = '3/1/2018',
    -- Specify @RideHrs
	@RideHrs = 300

-- Select the columns of interest
SELECT
	@ReturnStatus AS ReturnStatus,
    Date,
    RideHours
FROM dbo.RideSummary 
WHERE Date = '3/1/2018';

-- 3. Execute with OUTPUT and return value
-- Create @ReturnStatus
DECLARE @ReturnStatus AS int
-- Create @RowCount
DECLARE @RowCount AS int

-- Execute the SP, storing the result in @ReturnStatus
EXEC @ReturnStatus = dbo.cuspRideSummaryDelete 
    -- Specify @DateParm
	@DateParm = '3/1/2018',
    -- Specify RowCountOut
	@RowCountOut = @RowCount OUTPUT

-- Select the columns of interest
SELECT
	@ReturnStatus AS ReturnStatus,
    @RowCount AS 'RowCount';
