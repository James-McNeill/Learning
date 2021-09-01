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

-- Final level is the SERIALIZABLE which locks data from being adjusted until the transaction has completed.
-- If the data contained within the TRANS is not being updated/inserted then the update/insert will take place.
-- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

-- Begin a transaction
BEGIN TRAN

SELECT * FROM customers;

-- After some mathematical operations, we selected information from the customers table.
SELECT * FROM customers;

-- Commit the transaction
COMMIT TRAN

-- Another example
-- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

-- Begin a transaction
BEGIN TRAN

-- Select customer_id between 1 and 10
SELECT * 
FROM customers
WHERE customer_id BETWEEN 1 AND 10;

-- After completing some mathematical operation, select customer_id between 1 and 10
SELECT * 
FROM customers
WHERE customer_id BETWEEN 1 AND 10;

-- Commit the transaction
COMMIT TRAN
