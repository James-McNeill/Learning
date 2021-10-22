-- Triggers classification DDL
-- The DDL triggers take place at the DATABASE / SERVER level for CREATE, ALTER and DELETE table statements

-- 1. Tracking table changes
-- Create the trigger to log table info
CREATE TRIGGER TrackTableChanges
ON Database
FOR CREATE_TABLE,
	ALTER_TABLE,
	DROP_TABLE
AS
	INSERT INTO TablesChangeLog (EventData, ChangedBy)
    VALUES (EVENTDATA(), USER);

-- 2. Rollback changes that shouldn't take place (DROP_TABLE)
-- Add a trigger to disable the removal of tables
CREATE TRIGGER PreventTableDeletion
ON DATABASE
FOR DROP_TABLE
AS
	RAISERROR ('You are not allowed to remove tables from this database.', 16, 1);
    -- Revert the statement that removes the table
    ROLLBACK;
