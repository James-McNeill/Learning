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
