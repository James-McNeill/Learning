-- Example is reviewing the process of debiting one account and crediting another account.
-- The transactions are there then recorded within a transaction table. The transactions are part of
-- an all or nothing concept, by using BEGIN TRAN and COMMIT TRAN, the code will perform the full
-- transaction process if the code has no errors. If there are errors within the TRAN then the 
-- ROLLBACK statement will reverse any code within the TRAN statements.
BEGIN TRY  
	BEGIN TRAN;
		UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
		INSERT INTO transactions VALUES (1, -100, GETDATE());
        
		UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
		INSERT INTO transactions VALUES (5, 100, GETDATE());
	COMMIT TRAN;
END TRY
BEGIN CATCH  
	ROLLBACK TRAN;
END CATCH
