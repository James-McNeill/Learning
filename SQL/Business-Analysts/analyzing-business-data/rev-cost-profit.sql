-- Revenue Cost Profit
-- Profit is one of the first things people use to assess a company's success. 
-- In this chapter, you'll learn how to calculate revenue and cost, and then combine the two calculations using Common Table Expressions to calculate profit.

-- A. Revenue
-- 1. Revenue per customer
-- Calculate revenue
SELECT sum(meal_price * order_quantity) AS revenue
  FROM meals
  JOIN orders ON meals.meal_id = orders.meal_id
-- Keep only the records of customer ID 15
WHERE user_id = 15;

-- 2. Revenue per week
SELECT DATE_TRUNC('week', order_date) :: DATE AS delivr_week,
       -- Calculate revenue
       sum(meal_price * order_quantity) AS revenue
  FROM meals
  JOIN orders ON meals.meal_id = orders.meal_id
-- Keep only the records in June 2018
WHERE order_date BETWEEN '2018-06-01' AND '2018-06-30'
GROUP BY delivr_week
ORDER BY delivr_week ASC;

-- B. Using CTE's
-- The power of the temporary table allows the user to query the data better
-- Declare a CTE named monthly_cost
WITH monthly_cost AS (
  SELECT
    DATE_TRUNC('month', stocking_date)::DATE AS delivr_month,
    SUM(meal_cost * stocked_quantity) AS cost
  FROM meals
  JOIN stock ON meals.meal_id = stock.meal_id
  GROUP BY delivr_month)

-- C. Profit
-- 1. Overall review
WITH revenue AS (
  -- Calculate revenue per eatery
  SELECT eatery,
         SUM(meal_price * order_quantity) AS revenue
    FROM meals
    JOIN orders ON meals.meal_id = orders.meal_id
   GROUP BY eatery),

  cost AS (
  -- Calculate cost per eatery
  SELECT eatery,
         SUM(meal_cost * stocked_quantity) AS cost
    FROM meals
    JOIN stock ON meals.meal_id = stock.meal_id
   GROUP BY eatery)

   -- Calculate profit per eatery
   SELECT revenue.eatery,
          revenue - cost as profit
     FROM revenue
     JOIN cost ON revenue.eatery = cost.eatery
    ORDER BY profit DESC;
    

SELECT
  -- Calculate the average monthly cost before September
  AVG(cost)
FROM monthly_cost
WHERE delivr_month < '2018-09-01';

-- 2. Monthly review
-- Set up the revenue CTE
WITH revenue AS ( 
	SELECT
		DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
		SUM(meal_price * order_quantity) AS revenue
	FROM meals
	JOIN orders ON meals.meal_id = orders.meal_id
	GROUP BY delivr_month),
-- Set up the cost CTE
  cost AS (
 	SELECT
		DATE_TRUNC('month', stocking_date) :: DATE AS delivr_month,
		SUM(meal_cost * stocked_quantity) AS cost
	FROM meals
    JOIN stock ON meals.meal_id = stock.meal_id
	GROUP BY delivr_month)
-- Calculate profit by joining the CTEs
SELECT
	revenue.delivr_month,
	revenue - cost AS profit
FROM revenue
JOIN cost ON revenue.delivr_month = cost.delivr_month
ORDER BY revenue.delivr_month ASC;
