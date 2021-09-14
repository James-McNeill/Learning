-- Making use of the RideSummary table the following stored procedures will be used
-- to perform the CRUD process

-- 1. Perform an INSERT statement to the table
-- Create the stored procedure
CREATE PROCEDURE dbo.cusp_RideSummaryCreate 
    (@DateParm date,
     @RideHrsParm numeric)
AS
BEGIN
SET NOCOUNT ON
-- Insert into the Date and RideHours columns
INSERT INTO dbo.RideSummary(Date, RideHours)
-- Use values of @DateParm and @RideHrsParm
VALUES(@DateParm, @RideHrsParm) 

-- Select the record that was just inserted
SELECT
    -- Select Date column
	Date,
    -- Select RideHours column
    RideHours
FROM dbo.RideSummary
-- Check whether Date equals @DateParm
WHERE Date = @DateParm
END;

-- 2. Perform an UPDATE statement to the table being updated
-- Create the stored procedure
CREATE PROCEDURE dbo.cuspRideSummaryUpdate
	-- Specify @Date input parameter
	(@Date date,
     -- Specify @RideHrs input parameter
     @RideHrs numeric(18,0))
AS
BEGIN
SET NOCOUNT ON
-- Update RideSummary
UPDATE dbo.RideSummary
-- Set
SET
	Date = @Date,
    RideHours = @RideHrs
-- Include records where Date equals @Date
WHERE Date = @Date
END;

-- 3. Create a DELETE statement to the table
-- Create the stored procedure
CREATE PROCEDURE dbo.cuspRideSummaryDelete
	-- Specify @DateParm input parameter
	(@DateParm date,
     -- Specify @RowCountOut output parameter
     @RowCountOut int OUTPUT)
AS
BEGIN
-- Delete record(s) where Date equals @DateParm
DELETE FROM dbo.RideSummary
WHERE Date = @DateParm
-- Set @RowCountOut to @@ROWCOUNT
SET @RowCountOut = @@ROWCOUNT
END;
