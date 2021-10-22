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
