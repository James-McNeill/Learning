SELECT count(*) as missing_price
from vehicles
where price is null;

SELECT 
	min(price) as min_price,
	avg(price) as avg_price,
	max(price) as max_price
from vehicles;