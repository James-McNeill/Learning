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
