-- Triggers in t-sql
-- Used to automate tasks using custom designed triggers that are similar to stored procedures

-- 1. Create a new trigger that fires when deleting data
CREATE TRIGGER PreventDiscountsDelete -- trigger name
ON Discounts  -- trigger relates to this table object
-- The trigger should fire instead of DELETE. INSTEAD OF: outlines that the trigger will be run after an event
INSTEAD OF DELETE
AS
	PRINT 'You are not allowed to delete data from the Discounts table.';

-- 2. Set up a new trigger. NOTE: triggers can be connected to a dataset to perform automated actions. The following example would allow
-- for appropriate auditing of the updates that take place. The trigger ensures that this process of storing the transaction movements can
-- be automated in the background
CREATE TRIGGER OrdersUpdatedRows
ON Orders
-- The trigger should fire after UPDATE statements. AFTER: means that the trigger action takes place after an UPDATE has occurred on the Orders table
AFTER UPDATE
-- Add the AS keyword before the trigger body
AS
	-- Insert details about the changes to a dedicated table
	INSERT INTO OrdersUpdate(OrderID, OrderDate, ModifyDate)
	SELECT OrderID, OrderDate, GETDATE()
	FROM inserted;
