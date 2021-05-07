SELECT year, count(*) as vol,
avg(price) as avg_price
from vehicles
GROUP by year;