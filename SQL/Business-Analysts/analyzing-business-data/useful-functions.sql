-- Additional functions that can provide meaning to BI output

-- Formatting dates
SELECT DISTINCT
  -- Select the order date
  order_date,
  -- Format the order date. NOTE: there are many key formatting options available with TO_CHAR() to format dates
  TO_CHAR(order_date, 'FMDay DD, FMMonth YYYY') AS format_order_date
FROM orders
ORDER BY order_date ASC
LIMIT 3;

-- Ranking
-- Set up the user_count_orders CTE
WITH user_count_orders AS (
  SELECT
    user_id,
    COUNT(DISTINCT order_id) AS count_orders
  FROM orders
  -- Only keep orders in August 2018
  WHERE DATE_TRUNC('month', order_date) = '2018-08-01'
  GROUP BY user_id)

SELECT
  -- Select user ID, and rank user ID by count_orders
  user_id,
  RANK() OVER (ORDER BY count_orders DESC) AS count_orders_rank
FROM user_count_orders
ORDER BY count_orders_rank ASC
-- Limit the user IDs selected to 3
LIMIT 3;

-- Pivoting
-- Some functions do not exist within the default environment. Therefore the extensions have to be imported. Similar to libraries for Python
-- Import tablefunc
CREATE EXTENSION IF NOT EXISTS tablefunc;

-- The two $ signs are included at the beginning and end to ensure that the function processes the commands as string
SELECT * FROM CROSSTAB($$
  SELECT
    user_id,
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    SUM(meal_price * order_quantity) :: FLOAT AS revenue
  FROM meals
  JOIN orders ON meals.meal_id = orders.meal_id
 WHERE user_id IN (0, 1, 2, 3, 4)
   AND order_date < '2018-09-01'
 GROUP BY user_id, delivr_month
 ORDER BY user_id, delivr_month;
$$)
-- Select user ID and the months from June to August 2018
AS ct (user_id INT,
       "2018-06-01" FLOAT,
       "2018-07-01" FLOAT,
       "2018-08-01" FLOAT)
ORDER BY user_id ASC;
