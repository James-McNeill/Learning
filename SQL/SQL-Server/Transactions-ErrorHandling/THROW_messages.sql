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

-- Using the FORMATMESSAGE method to provide the message details. 
-- Objective of the code is to check for the difference in stock between sold bikes and current stock
DECLARE @product_name AS NVARCHAR(50) = 'Trek CrossRip+ - 2018';
-- Set the number of sold bikes
DECLARE @sold_bikes AS INT = 10;
DECLARE @current_stock INT;

SELECT @current_stock = stock FROM products WHERE product_name = @product_name;

DECLARE @my_message NVARCHAR(500) =
	-- Customize the error message
	FORMATMESSAGE('There are not enough %s bikes. You have %d in stock.', @product_name, @current_stock);

IF (@current_stock - @sold_bikes < 0)
	-- Throw the error
	THROW 50000, @my_message, 1;
