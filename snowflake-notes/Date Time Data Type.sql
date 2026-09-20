/*
Date & time data types
Snowflake supports data types for managing dates, times, and timestamps (combined date + time).
Snowflake supports the following date and time data types:
    DATE
    DATETIME
    Interval data types
    TIME
    TIMESTAMP_LTZ , TIMESTAMP_NTZ , TIMESTAMP_TZ


Interval Data Type =>
It is used to represent an interval. It can be represented in two ways.
- Interval Year : It hold interval of speicified years
- Interval Month : It hold interval of speicified months
- Interval Year to Month : It hold interval of speicified years + months

Instead of combining intervals togather, it is better to specify separate intervals. [Line: 28, 31]
Because, it is:
    More readable
    Easier for new developers
    Easier to modify
    Less prone to misunderstanding
*/

CREATE OR REPLACE TEMPORARY TABLE sample_table_with_interval (
  id VARCHAR,
  duration INTERVAL YEAR(2) TO MONTH
);
-- Duration stores interval of years and months. Year component can have up to 2 digits.


SELECT TO_DATE('2024-01-01') + INTERVAL '1-1' YEAR TO MONTH AS date_plus_one_year_one_month;
-- Here, '1-1' means, Interval is 1 year and 1 month. This interval will be added to date.

SELECT TO_DATE('2024-01-01') + INTERVAL '1' YEAR + INTERVAL '1' MONTH AS date_plus_one_year_one_month;
-- Here, 1 year interval and 1 month interval will be added to date.

-- Here, It will subtract 1 year and 1 month interval from date. [Writing separate interval is more readable.]
SELECT TO_DATE('2024-01-01') + INTERVAL '-1-1' YEAR TO MONTH AS date_plus_one_year_one_month;
SELECT TO_DATE('2024-01-01') - INTERVAL '1' YEAR - INTERVAL '1' MONTH AS date_plus_one_year_one_month;



------------- Timestamp ---------------------
select current_timestamp()::timestamptz, current_timestamp()::timestampntz, current_timestamp()::timestampltz, current_timestamp()::timestamp

-- Check current active timezone
SHOW PARAMETERS LIKE 'TIMEZONE';

ALTER SESSION SET TIMEZONE = 'America/Los_Angeles';
ALTER SESSION SET TIMEZONE = 'Asia/Kolkata';

select to_timestamp('2026-07-10 01:42:25.173 +0530', 'YYYY-MM-DD HH24:MI:SS.FF3 TZHTZM') -- to_timestamp returns timestamp_ntz
select to_timestamp_tz('2026-07-10 01:42:25.173 +0530', 'YYYY-MM-DD HH24:MI:SS.FF3 TZHTZM') -- to_timestamp_tz returns timestamp_tz
select to_timestamp('2026-07-10 01:42:25.173 +0530', 'YYYY-MM-DD HH24:MI:SS.FF3 TZHTZM')::timestamptz   -- timestamp_ntz -> timestamp_tz
select to_timestamp_tz('2026-07-10 01:42:25.173', 'YYYY-MM-DD HH24:MI:SS.FF3')::timestamptz -- timestamp_tz -> timestamp_tz

create or replace table my_tab_timestamp (my_tsp timestamp_ntz); -- timestamp_ltz, timestamp_tz [Change data-type and play with code]
insert into my_tab_timestamp values (current_timestamp());

select * from my_tab_timestamp;

/*
timestamp_tz => Stores timestamp value and its offset as well.
timestamp_ltz => Stores timestamp in UTC format. When you query the data, it will show timestamp in your current active timezone.
timestamp => Stores timestamp value and it does not store any offset. [You will lose timezone information.]
*/


----- DDL
create or replace table my_tab_timestamp(
    my_date DATE,
    my_date_time DATETIME,
    my_ltsp TIMESTAMP_LTZ,
    my_ntsp TIMESTAMP_NTZ,
    my_tztsp TIMESTAMPTZ
);

DESC TABLE my_tab_timestamp;

---
/*

Date and time formats =>
    https://docs.snowflake.com/en/sql-reference/data-types-datetime#date-and-time-formats

*/

-- List default format and parameter values
SHOW PARAMETERS;

-- Check to_timestamp will cast to which timestamp? ntz, ltz or tz??
SHOW PARAMETERS LIKE 'TIMESTAMP_TYPE_MAPPING';
-- Default Timestamp format
SHOW PARAMETERS LIKE 'TIMESTAMP_OUTPUT_FORMAT';

-- Set Timestamp Format
ALTER SESSION SET TIMESTAMP_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET TIMESTAMP_TZ_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET TIMESTAMP_NTZ_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';
ALTER SESSION SET TIMESTAMP_LTZ_OUTPUT_FORMAT = 'YYYY-MM-DD HH24:MI:SS.FF';