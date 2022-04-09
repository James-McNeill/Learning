-- Working with user centric KPIs

-- MAU monitor
WITH mau AS (
  SELECT
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    COUNT(DISTINCT user_id) AS mau
  FROM orders
  GROUP BY delivr_month)

SELECT
  -- Select the month and the MAU
  delivr_month,
  mau,
  COALESCE(
    LAG(mau) OVER(ORDER BY delivr_month),
  0) AS last_mau
FROM mau
-- Order by month in ascending order
ORDER BY delivr_month ASC;

-- DELTA
WITH mau AS (
  SELECT
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    COUNT(DISTINCT user_id) AS mau
  FROM orders
  GROUP BY delivr_month),

  mau_with_lag AS (
  SELECT
    delivr_month,
    mau,
    -- Fetch the previous month's MAU
    COALESCE(
      LAG(mau) OVER(ORDER BY delivr_month ASC),
    0) AS last_mau
  FROM mau)

SELECT
  -- Calculate each month's delta of MAUs
  delivr_month,
  mau - last_mau AS mau_delta
FROM mau_with_lag
-- Order by month in ascending order
ORDER BY delivr_month;

-- GROWTH RATE
WITH mau AS (
  SELECT
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    COUNT(DISTINCT user_id) AS mau
  FROM orders
  GROUP BY delivr_month),

  mau_with_lag AS (
  SELECT
    delivr_month,
    mau,
    GREATEST(
      LAG(mau) OVER (ORDER BY delivr_month ASC),
    1) AS last_mau
  FROM mau)

SELECT
  -- Calculate the MoM MAU growth rates
  delivr_month,
  ROUND(
    (mau - last_mau) ::NUMERIC / last_mau,
  2) AS growth
FROM mau_with_lag
-- Order by month in ascending order
ORDER BY delivr_month;

-- ORDER GROWTH RATE
WITH orders AS (
  SELECT
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    --  Count the unique order IDs
    COUNT(DISTINCT order_id) AS orders
  FROM orders
  GROUP BY delivr_month),

  orders_with_lag AS (
  SELECT
    delivr_month,
    -- Fetch each month's current and previous orders
    orders,
    COALESCE(
      LAG(orders) OVER(ORDER BY delivr_month),
    1) AS last_orders
  FROM orders)

SELECT
  delivr_month,
  -- Calculate the MoM order growth rate
  ROUND(
    (orders - last_orders) :: NUMERIC / last_orders,
  2) AS growth
FROM orders_with_lag
ORDER BY delivr_month ASC;
