/*
System functions in Snowflake are specialized functions prefixed with SYSTEM$ that allow you to perform system-level actions, retrieve system information, or query metadata about your Snowflake environment.

System functions are prefixed with SYSTEM$ and must be called with parentheses, even if no parameters are required.
They are particularly useful for administrative tasks, monitoring, and optimizing Snowflake operations.

Reference :- https://docs.snowflake.com/en/sql-reference/functions-system

*/


------ Type Checking ----------------
-- Use SYSTEM$TYPEOF() method to check data-type of any data; You can use it in select clause to check data-type of column.
select SYSTEM$TYPEOF(43454.5455)