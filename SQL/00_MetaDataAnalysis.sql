-- Understanding the MetaData within the database
-- The request made to the table "sqlite_master" is the master dataset within the database
select *
from sqlite_master;

-- Understand the number of records within a table
select count(*) as vol
from vehicles;

