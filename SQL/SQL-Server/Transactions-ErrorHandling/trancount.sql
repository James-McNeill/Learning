-- @@TRANCOUNT variable is used to track the transactions that have been committed or rolled back

BEGIN TRY
	-- Begin the transaction
	BEGIN TRAN;
    	-- Correct the mistake
		UPDATE accounts SET current_balance = current_balance + 200
			WHERE account_id = 10;
    	-- Check if there is a transaction
		IF @@TRANCOUNT > 0     
    		-- Commit the transaction
			COMMIT TRAN;
     
	SELECT * FROM accounts
    	WHERE account_id = 10;      
END TRY
BEGIN CATCH  
    SELECT 'Rolling back the transaction'; 
    -- Check if there is a transaction
    IF @@TRANCOUNT > 0   	
    	-- Rollback the transaction
        ROLLBACK TRAN;
END CATCH
