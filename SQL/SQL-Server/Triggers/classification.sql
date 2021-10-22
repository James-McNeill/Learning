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
