-- Working with dates and timestamps

-- What time is it? In this chapter, you'll learn how to find out. You'll aggregate date/time data by hour, day, month, 
-- or year and practice both constructing time series and finding gaps in them.

-- A. Date/time types and formats
-- 1. Date comparisons
-- Count requests created on January 31, 2017
SELECT count(*) 
  FROM evanston311
 WHERE date_created::date = '2017-01-31';
 
-- Count requests created on February 29, 2016
SELECT count(*)
  FROM evanston311 
 WHERE date_created >= '2016-02-29' 
   AND date_created < '2016-03-01';

-- Count requests created on March 13, 2017
SELECT count(*)
  FROM evanston311
 WHERE date_created >= '2017-03-13'
   AND date_created < '2017-03-13'::date + 1;

-- 2. Date arithmetic
-- Subtract the min date_created from the max
SELECT max(date_created) - min(date_created)
  FROM evanston311;

-- How old is the most recent request?
SELECT now() - max(date_created)
  FROM evanston311;

-- Add 100 days to the current timestamp
SELECT now() + '100 days'::interval;

-- Select the current timestamp, 
-- and the current timestamp + 5 minutes
SELECT now(),
    now() + '5 minutes'::interval;

-- 3. Completion time by category
-- Select the category and the average completion time by category
SELECT category, 
       avg(date_completed - date_created) AS completion_time
  FROM evanston311
 GROUP BY category
-- Order the results
 ORDER BY completion_time DESC;

-- B. Date/time components and aggregation
-- 1. Date parts
-- Extract the month from date_created and count requests
SELECT date_part('month', date_created) AS month, 
       count(*)
  FROM evanston311
 -- Limit the date range
 WHERE date_created >= '2016-01-01'
   AND date_created < '2018-01-01'
 -- Group by what to get monthly counts?
 GROUP BY month;

-- Get the hour and count requests
SELECT date_part('hour', date_created) AS hour,
       count(*)
  FROM evanston311
 GROUP BY hour
 -- Order results to select most common
 ORDER BY count DESC
 LIMIT 1;

-- Count requests completed by hour
SELECT date_part('hour', date_completed) AS hour,
       count(*)
  FROM evanston311
 GROUP BY hour
 ORDER BY hour DESC;

-- 2. Variation by day of week
-- Select name of the day of the week the request was created 
SELECT to_char(date_created, 'day') AS day, 
       -- Select avg time between request creation and completion
       avg(date_completed - date_created) AS duration
  FROM evanston311 
 -- Group by the name of the day of the week and 
 -- integer value of day of week the request was created
 GROUP BY day, EXTRACT(DOW FROM date_created)
 -- Order by integer value of the day of the week 
 -- the request was created
 ORDER BY EXTRACT(DOW FROM date_created);

-- 3. Date truncation
-- Aggregate daily counts by month
SELECT date_trunc('month', day) AS month,
       avg(count)
  -- Subquery to compute daily counts
  FROM (SELECT date_trunc('day', date_created) AS day,
               count(*) AS count
          FROM evanston311
         GROUP BY day) AS daily_count
 GROUP BY month
 ORDER BY month;

-- C. Aggregating with date/time series
-- 1. Find missing dates
SELECT day
-- 1) Subquery to generate all dates
-- from min to max date_created
  FROM (SELECT generate_series(min(date_created),
                               max(date_created),
                               '1 day'::interval)::date AS day
          -- What table is date_created in?
          FROM evanston311) AS all_dates
-- 4) Select dates (day from above) that are NOT IN the subquery
 WHERE day NOT IN
       -- 2) Subquery to select all date_created values as dates
       (SELECT date_created::date
          FROM evanston311);
