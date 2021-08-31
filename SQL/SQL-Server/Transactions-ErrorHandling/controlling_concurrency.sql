-- Set the appropriate isolation level. Action will show TRANSACTIONS that are in progress but not committed
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- Select first_name, last_name, email and phone
	SELECT
    	first_name, 
        last_name, 
        email,
        phone
    FROM customers;

-- READ COMMITTED is the default setting. Therefore if a TRANSACTIONS has not been comitted or rolledback then the
-- data being processed will not be available for review.

-- Set the appropriate isolation level. Prevent dirty reads from taking place
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- Count the accounts
SELECT COUNT(*) AS number_of_accounts
FROM accounts
WHERE current_balance >= 50000;

-- Set the appropriate isolation level. Prevent dirty reads and non-repeatable reads from occuring
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

-- Begin a transaction
BEGIN TRAN

SELECT * FROM customers;

-- some mathematical operations, don't care about them...

SELECT * FROM customers;

-- Commit the transaction
COMMIT TRAN
