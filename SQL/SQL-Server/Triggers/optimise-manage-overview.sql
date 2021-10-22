-- Working with trigger optimisation and management

-- 1. Remove triggers if they are not needed any longer
-- Remove the trigger
DROP TRIGGER PreventNewDiscounts;

-- Remove the database trigger
DROP TRIGGER PreventTableDeletion
ON DATABASE;

-- Remove the server trigger
DROP TRIGGER DisallowLinkedServers
ON ALL SERVER;

-- 2. Modify trigger after creation
-- Fix the typo in the trigger message
ALTER TRIGGER PreventDiscountsDelete
ON Discounts
INSTEAD OF DELETE
AS
	PRINT 'You are not allowed to remove data from the Discounts table.';

-- 3. Disable the trigger
-- Pause the trigger execution
DISABLE TRIGGER PreventOrdersUpdate
ON Orders;
