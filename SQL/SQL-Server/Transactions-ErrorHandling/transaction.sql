-- Example is reviewing the process of debiting one account and crediting another account.
-- The transactions are there then recorded within a transaction table. The transactions are part of
-- an all or nothing concept, by using BEGIN TRAN and COMMIT TRAN, the code will perform the full
-- transaction process if the code has no errors. If there are errors within the TRAN then the 
-- ROLLBACK statement will reverse any code within the TRAN statements.
BEGIN TRY  
	BEGIN TRAN; -- Everything within this section needs to work correctly to function
		UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
		INSERT INTO transactions VALUES (1, -100, GETDATE());
        
		UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
		INSERT INTO transactions VALUES (5, 100, GETDATE());
	COMMIT TRAN;
END TRY
BEGIN CATCH  
	ROLLBACK TRAN; -- If there are errors in the TRAN block then this statement will ROLLBACK
END CATCH

-- Example: Adding a value to the balance of the top 200 customers with balances less than 5000. If
-- the customer being reviewed is greater than 200 then the TRAN rolls back.
-- Begin the transaction
BEGIN TRAN; 
	UPDATE accounts set current_balance = current_balance + 100
		WHERE current_balance < 5000;
	-- Check number of affected rows
	IF @@ROWCOUNT > 200 
		BEGIN
        	-- Rollback the transaction
			ROLLBACK TRAN; 
			SELECT 'More accounts than expected. Rolling back'; 
		END
	ELSE
		BEGIN
        	-- Commit the transaction
			COMMIT TRAN; 
			SELECT 'Updates commited'; 
		END
