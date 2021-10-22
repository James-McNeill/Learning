-- Triggers in t-sql
-- Used to automate tasks using custom designed triggers that are similar to stored procedures

-- Create a new trigger that fires when deleting data
CREATE TRIGGER PreventDiscountsDelete -- trigger name
ON Discounts  -- trigger relates to this table object
-- The trigger should fire instead of DELETE. INSTEAD OF: outlines that the trigger will be run after an event
INSTEAD OF DELETE
AS
	PRINT 'You are not allowed to delete data from the Discounts table.';
