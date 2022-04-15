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
