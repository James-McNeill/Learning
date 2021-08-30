-- Using a THROW statement with parameters
DECLARE @staff_id INT = 4;

IF NOT EXISTS (SELECT * FROM staff WHERE staff_id = @staff_id)
   	-- Invoke the THROW statement with parameters
	THROW 50001, 'No staff member with such id', 1;
ELSE
   	SELECT * FROM staff WHERE staff_id = @staff_id
    
-- Concatenating a message
DECLARE @first_name NVARCHAR(20) = 'Pedro';

-- Concat the message
DECLARE @my_message NVARCHAR(500) =
	CONCAT('There is no staff member with ', @first_name, ' as the first name.');

IF NOT EXISTS (SELECT * FROM staff WHERE first_name = @first_name)
	-- Throw the error
	THROW 50000, @my_message, 1;
