-- Summarizing and aggregating numeric data
-- You'll build on functions like min and max to summarize numeric data in new ways. 
-- Add average, variance, correlation, and percentile functions to your toolkit, and learn how to truncate and round numeric values too. 
-- Build complex queries and save your results by creating temporary tables.

-- A. Numeric data types and summary functions
-- 1. Division
-- Select average revenue per employee by sector
SELECT sector, 
       avg(revenues/employees::numeric) AS avg_rev_employee
  FROM fortune500
 GROUP BY sector
 -- Use the column alias to order the results
 ORDER BY avg_rev_employee;
 
-- 2. Explore with division
-- Divide unanswered_count by question_count
SELECT unanswered_count/question_count::numeric AS computed_pct, 
       -- What are you comparing the above quantity to?
       unanswered_pct
  FROM stackoverflow
 -- Select rows where question_count is not 0
 WHERE question_count > 0
 LIMIT 10;
