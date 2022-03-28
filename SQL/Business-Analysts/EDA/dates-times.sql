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

