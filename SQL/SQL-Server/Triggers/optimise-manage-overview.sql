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

-- 3. Disable the trigger. If the trigger is not required for a certain period of time it can be paused instead of deleted
-- Pause the trigger execution
DISABLE TRIGGER PreventOrdersUpdate
ON Orders;

-- 4. Re-enable a disabled trigger
-- Resume the trigger execution
ENABLE TRIGGER PreventOrdersUpdate
ON Orders;

-- 5. Managing existing triggers
-- Get the disabled triggers
SELECT name,
	   object_id,
	   parent_class_desc
FROM sys.triggers
WHERE is_disabled = 1;

-- Check for unchanged server triggers
SELECT *
FROM sys.server_triggers
WHERE create_date = modify_date;

-- Get the database triggers
SELECT *
FROM sys.triggers
WHERE parent_class_desc = 'DATABASE';
