-- Trigger classification

-- 1. AFTER triggers
-- Create the trigger. After a product has been retired store the details in the special deleted table
CREATE TRIGGER TrackRetiredProducts
ON Products
AFTER DELETE
AS
	INSERT INTO RetiredProducts (Product, Measure)
	SELECT Product, Measure
	FROM deleted;

-- Check that the trigger is working as expected
-- Remove the products that will be retired
DELETE FROM Products
WHERE Product IN ('Cloudberry', 'Guava', 'Nance', 'Yuzu');

-- Verify the output of the history table
SELECT * FROM RetiredProducts;
