-- What's in the database
-- Start exploring a database by identifying the tables and the foreign keys that link them. 
-- Look for missing values, count the number of observations, and join tables to understand how they're related. 
-- Learn about coalescing and casting data along the way.

-- Making use of PostgreSQL

-- A. What's in the database
-- 1. Count missing values
-- Select the count of ticker, 
-- subtract from the total number of rows, 
-- and alias as missing
SELECT count(*) - count(ticker) AS missing
  FROM fortune500;
  
-- 2. Join tables
SELECT company.name
-- Table(s) to select from
  FROM company
       INNER JOIN fortune500
       ON company.ticker=fortune500.ticker;
