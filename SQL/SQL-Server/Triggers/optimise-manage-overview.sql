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

-- 6. Keeping track of trigger execution
-- Modify the trigger to add new functionality
ALTER TRIGGER PreventOrdersUpdate
ON Orders
-- Prevent any row changes
INSTEAD OF UPDATE
AS
	-- Keep history of trigger executions
	INSERT INTO TriggerAudit (TriggerName, ExecutionDate)
	SELECT 'PreventOrdersUpdate', 
           GETDATE();

	RAISERROR ('Updates on "Orders" table are not permitted.
                Place a new order to add new products.', 16, 1);

-- 7. Identify problematic triggers
-- Get the table ID
SELECT object_id AS TableID
FROM sys.objects
WHERE name = 'Orders';

-- Get the trigger name
SELECT t.name AS TriggerName
FROM sys.objects AS o
-- Join with the triggers table
INNER JOIN sys.triggers AS t ON t.parent_id = o.object_id
WHERE o.name = 'Orders';

-- Identify UPDATE queries
SELECT t.name AS TriggerName
FROM sys.objects AS o
INNER JOIN sys.triggers AS t ON t.parent_id = o.object_id
-- Get the trigger events
INNER JOIN sys.trigger_events AS te ON te.object_id = t.object_id
WHERE o.name = 'Orders'
-- Filter for triggers reacting to new rows
AND te.type_desc = 'UPDATE';

-- Display the SQL code using OBJECT_DEFINITION() function
SELECT t.name AS TriggerName,
	   OBJECT_DEFINITION(t.object_id) AS TriggerDefinition
FROM sys.objects AS o
INNER JOIN sys.triggers AS t ON t.parent_id = o.object_id
INNER JOIN sys.trigger_events AS te ON te.object_id = t.object_id
WHERE o.name = 'Orders'
AND te.type_desc = 'UPDATE';
