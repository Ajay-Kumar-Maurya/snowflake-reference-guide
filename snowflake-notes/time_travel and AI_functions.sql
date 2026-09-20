SHOW PARAMETERS LIKE 'CORTEX_CODE';

SELECT *
FROM TABLE(
  INFORMATION_SCHEMA.QUERY_ACCELERATION_HISTORY(
    DATE_RANGE_START => DATEADD('day', -7, CURRENT_TIMESTAMP()),
    DATE_RANGE_END => CURRENT_TIMESTAMP(),
    WAREHOUSE_NAME => 'COMPUTE_WH'
  )
);

SELECT AI_COMPLETE(
  model => 'snowflake-arctic',
  prompt => 'What is Snowflake?'
);

SELECT SNOWFLAKE.CORTEX.COMPLETE(
  'snowflake-arctic',
  'What is Snowflake?'
);



SELECT * FROM INFORMATION_SCHEMA.TABLES;
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;

CREATE OR REPLACE TABLE employees (
    employee_id NUMBER,
    employee_name STRING,
    department_id NUMBER,
    salary NUMBER
);

INSERT INTO employees VALUES
(1,'John',10,5000),
(2,'Mary',10,6000),
(3,'Sam',20,7000);

CREATE OR REPLACE FUNCTION get_employees_by_dept(dept_id NUMBER)
RETURNS TABLE (
    employee_id NUMBER,
    employee_name STRING,
    salary NUMBER
)
AS
$$
    SELECT employee_id,
           employee_name,
           salary
    FROM employees
    WHERE department_id = dept_id
$$;

SELECT * FROM TABLE(get_employees_by_dept(10));




SHOW USER FUNCTIONS;


SHOW CORTEX BASE MODELS;

SHOW DATABASES;

describe database OUR_FIRST_DB.PUBLIC.TEST_FIXED; --our_first_db

-- To describe a database:
DESCRIBE DATABASE OUR_FIRST_DB;

-- To describe a table:
DESCRIBE TABLE OUR_FIRST_DB.PUBLIC.TEST_FIXED;
show tables in schema like '%our_first_db.public%'

SHOW TABLES LIKE '%test%';

SHOW CLASSES IN DATABASE SNOWFLAKE;

SELECT SNOWFLAKE.CORTEX.COMPLETE(
'llama3',
'Explain Snowflake in 2 lines'
);

SHOW CLASSES IN SCHEMA SNOWFLAKE.ML;

SHOW FUNCTIONS IN CLASS SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE;

SHOW FUNCTIONS IN CLASS SNOWFLAKE.ML.ANOMALY_DETECTION;
SHOW PROCEDURES IN CLASS SNOWFLAKE.ML.ANOMALY_DETECTION;

SHOW ROLES IN CLASS SNOWFLAKE.DATA_PRIVACY.CLASSIFICATION_PROFILE;--SNOWFLAKE.ML.ANOMALY_DETECTION;




SHOW DATA METRIC FUNCTIONS


CREATE OR REPLACE PROCEDURE archive_old_orders(cutoff_date DATE)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
    LET row_count INT := 0;

    -- Insert old orders into archive table
    INSERT INTO orders_archive
    SELECT * FROM orders WHERE order_date < :cutoff_date;

    -- Get count of moved rows
    row_count := SQLROWCOUNT;

    -- Delete from source
    DELETE FROM orders WHERE order_date < :cutoff_date;

    RETURN 'Archived ' || :row_count || ' orders';
END;
$$;

CREATE OR REPLACE PROCEDURE get_employees()
RETURNS TABLE (
    emp_id NUMBER,
    emp_name STRING
)
LANGUAGE SQL
AS
$$
DECLARE
    res RESULTSET;
BEGIN
    res := (
        SELECT emp_id, emp_name
        FROM employees
    );

    RETURN TABLE(res);
END;
$$;

CREATE OR REPLACE PROCEDURE create_summary(source_table VARCHAR, target_table VARCHAR)
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'run'               -- points to the function below
AS
$$
def run(session, source_table: str, target_table: str) -> str:
    # 'session' is injected by Snowflake — not in SQL param list
    df = session.table(source_table)
    row_count = df.count()
    df.write.mode('overwrite').save_as_table(target_table)
    return f'Created {target_table} with {row_count} rows from {source_table}'
$$;





CREATE OR REPLACE SEQUENCE seq_5 START = 1 INCREMENT = 5;
SELECT seq_5.nextval a, seq_5.nextval b, seq_5.nextval c, seq_5.nextval d; -- 1, 6, 11, 16
SELECT seq_5.nextval a, seq_5.nextval b, seq_5.nextval c, seq_5.nextval d; -- 501, 506, 511, 516
SELECT seq_5.nextval a, seq_5.nextval b, seq_5.nextval c, seq_5.nextval d; -- 36, 41, 46, 51
SELECT seq_5.nextval a, seq_5.nextval b, seq_5.nextval c, seq_5.nextval d; -- 71, 76, 81, 86



create or replace SECURE view MY_TEST_RAJ_DB.MY_RAJ_SCHEMA.MY_STNDRD_VW
as select * from MY_TEST_RAJ_DB.MY_RAJ_SCHEMA.MY_TEST_RAJ_TABLE;

create or replace SECURE temp view my_mat_tmp_vw
as select * from MY_TEST_RAJ_DB.MY_RAJ_SCHEMA.MY_TEST_RAJ_TABLE;


SHOW PARAMETERS; -- 159
SHOW PARAMETERS IN SESSION; -- 159
SHOW PARAMETERS IN ACCOUNT; -- 295
SHOW PARAMETERS IN USER RAJMAURYA639366; -- 178
SHOW PARAMETERS IN WAREHOUSE COMPUTE_WH; -- 5

SHOW PARAMETERS IN DATABASE our_first_db;


ALTER USER IF EXISTS RAJMAURYA639366 ADD PROGRAMMATIC ACCESS TOKEN example_token
  DAYS_TO_EXPIRY = 1;

SHOW USER WORKLOAD IDENTITY AUTHENTICATION METHODS FOR USER RAJMAURYA639366;

 SHOW ACCOUNTS


-- When we create fresh account at Snowflake, we get these things automatically created.
SELECT CURRENT_ORGANIZATION_NAME(); -- OKKQGFX
SELECT CURRENT_ACCOUNT_NAME(); -- EE00442 [This is account identifier used to login to snowflake]
SELECT CURRENT_ACCOUNT(); -- IQ70747
SELECT CURRENT_USER(); -- RAJMAURYA639366
SELECT CURRENT_ROLE(); -- ACCOUNTADMIN
SHOW ROLES;
SHOW ORGANIZATION ACCOUNTS; -- Initially, you don't have any org account. You need to create one.
SHOW ACCOUNTS; -- Lists all accounts

-- Does not work in Snowflake
SELECT DISTINCT IS_TABLE_FUNCTION
FROM (SHOW FUNCTIONS)

-- Works in Snowflake
SHOW FUNCTIONS;
SELECT DISTINCT "is_table_function"
FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));

-- Initially, GLOBALORGADMIN role is not assigned.
-- You must have a role like ACCOUNTADMIN or another role with the MANAGE GRANTS privilege to assign roles.
GRANT ROLE GLOBALORGADMIN TO USER RAJMAURYA639366;

SHOW GRANTS OF ROLE GLOBALORGADMIN;

USE ROLE GLOBALORGADMIN;

USE ROLE ORGADMIN;


-- When i will create a organization account, then admin_user will be created and it gets access to GLOBALORGADMIN role.
CREATE ORGANIZATION ACCOUNT myorgaccount
  ADMIN_NAME = Raj_Admin
  ADMIN_PASSWORD = 'Raj123123Maurya'
  EMAIL = 'myemail@myorg.org'
  EDITION = enterprise;

-- creating second regular account
create account myaccount22
  admin_name = cas_admin
  admin_password = 'TestPassword123123'
  email = 'myemail@myorg.org'
  edition = enterprise;

  drop account myaccount22 GRACE_PERIOD_IN_DAYS = 3

  ALTER ACCOUNT myaccount22 SET IS_ORG_ADMIN = FALSE;

show regions;

SHOW FAILOVER GROUPS;       -- Account A is primary again
SHOW CONNECTIONS;            -- app_connection primary is in Account A
SHOW REPLICATION DATABASES;  -- Databases are primary in Account A


  -----------------------
  CREATE DATABASE ROLE our_first_db.drole1;
  SHOW DATABASE ROLES IN DATABASE our_first_db;

-- =====================================================
-- DEMO: Snowflake CHANGE_TRACKING + CHANGES Clause
-- Run this entire script sequentially
-- =====================================================
show users;
CREATE USER user1 PASSWORD='Akki123123123A' MUST_CHANGE_PASSWORD = TRUE;

select current_secondary_roles()

select is_database_role_in_session('our_first_db.READER')

show databases

CREATE DATABASE ROLE our_first_db.READER;

GRANT DATABASE ROLE READER TO USER RAJMAURYA639366;

SHOW GRANTS OF DATABASE ROLE our_first_db.READER;
-- Grant permissions to database role
GRANT SELECT ON TABLE SALES_DB.PUBLIC.ORDERS
TO DATABASE ROLE SALES_DB.READER;

-- Grant database role to account role
GRANT DATABASE ROLE SALES_DB.READER TO ROLE ANALYST;

-- Grant account role to user
GRANT ROLE ANALYST TO USER Raj;


create database my_test_raj_db
create schema my_test_raj_db.my_raj_schema
create table my_test_raj_table (age int, name text);
create database role my_test_raj_db.reader; -- creates database role with no previledges
GRANT DATABASE ROLE READER TO USER user1; -- only user can view database name in the list
GRANT USAGE ON DATABASE my_test_raj_db TO DATABASE ROLE reader; -- allows to use database
GRANT USAGE ON SCHEMA my_raj_schema TO DATABASE ROLE reader; -- Allows to use schema
GRANT SELECT ON TABLE my_test_raj_table TO DATABASE ROLE reader; -- Allows to run SELECT on table
GRANT CREATE TABLE ON SCHEMA my_raj_schema TO DATABASE ROLE reader;
SHOW GRANTS OF DATABASE ROLE my_test_raj_db.READER; -- list users assigned the role
SHOW GRANTS TO DATABASE ROLE my_test_raj_db.reader;

-- When database role is granted directly to a user, the database role's privileges are automatically available during the user's session.
create role ANALYST;


GRANT DATABASE ROLE  my_test_raj_db.READER TO ROLE ANALYST;

-- Grant account role to user
GRANT ROLE ANALYST TO USER user1;


-- Cleanup
DROP TABLE IF EXISTS t1;

-- Create table
CREATE OR REPLACE TABLE t1
(
    id NUMBER,
    c1 STRING
);

-- Enable change tracking
ALTER TABLE t1 SET CHANGE_TRACKING = TRUE;

-- =====================================================
-- STEP 1: Initial Load
-- =====================================================

INSERT INTO t1 VALUES
(1,'red'),
(2,'blue'),
(3,'green');

SELECT 'INITIAL DATA' AS STAGE;
SELECT * FROM t1 ORDER BY id;

-- Capture first timestamp
SET ts1 = CURRENT_TIMESTAMP();
select current_timestamp(); -- 2026-07-11 03:24:52.345 -0700
-- =====================================================
-- STEP 2: First Set of Changes
-- =====================================================

DELETE FROM t1 WHERE id = 1;
UPDATE t1 SET c1 = 'purple' WHERE id = 2;
INSERT INTO t1 VALUES (4,'yellow');

SELECT 'AFTER FIRST CHANGES' AS STAGE;
SELECT * FROM t1 ORDER BY id;

-- Show changes since ts1
SELECT 'CHANGES SINCE TS1' AS STAGE;

SELECT *
FROM t1
    CHANGES(INFORMATION => DEFAULT)
    AT(TIMESTAMP => $ts1);  -- It shows changes between latest and given timestamp.

-- Capture second timestamp
SET ts2 = CURRENT_TIMESTAMP();
select current_timestamp(); -- 2026-07-11 03:31:49.368 -0700
-- =====================================================
-- STEP 3: Second Set of Changes
-- =====================================================

UPDATE t1 SET c1 = 'black' WHERE id = 3;
DELETE FROM t1 WHERE id = 4;
INSERT INTO t1 VALUES (5,'white');

SELECT 'AFTER SECOND CHANGES' AS STAGE;
SELECT * FROM t1 ORDER BY id;

-- Changes between ts1 and ts2
SELECT 'CHANGES BETWEEN TS1 AND TS2' AS STAGE;

SELECT *
FROM t1
    CHANGES(INFORMATION => DEFAULT)
    AT(TIMESTAMP => $ts1)
    END(TIMESTAMP => $ts2);

-- Changes since ts2
SELECT 'CHANGES SINCE TS2' AS STAGE;

SELECT *
FROM t1
    CHANGES(INFORMATION => DEFAULT)
    AT(TIMESTAMP => $ts2);

-- Capture third timestamp
SET ts3 = CURRENT_TIMESTAMP();

-- =====================================================
-- STEP 4: Third Set of Changes
-- =====================================================

UPDATE t1 SET c1 = 'orange' WHERE id = 2;
INSERT INTO t1 VALUES (6,'pink');
DELETE FROM t1 WHERE id = 3;

SELECT 'AFTER THIRD CHANGES' AS STAGE;
SELECT * FROM t1 ORDER BY id;

-- Changes between ts2 and ts3
SELECT 'CHANGES BETWEEN TS2 AND TS3' AS STAGE;

SELECT *
FROM t1
    CHANGES(INFORMATION => DEFAULT)
    AT(TIMESTAMP => $ts2)
    END(TIMESTAMP => $ts3);

-- Changes since ts3
SELECT 'CHANGES SINCE TS3' AS STAGE;

SELECT *
FROM t1
    CHANGES(INFORMATION => DEFAULT)
    AT(TIMESTAMP => $ts3);

-- =====================================================
-- TIME TRAVEL COMPARISON
-- =====================================================

SELECT 'CURRENT TABLE' AS STAGE;
SELECT * FROM t1 ORDER BY id;

SELECT 'TABLE STATE AT TS1' AS STAGE;

SELECT *
FROM t1
AT(TIMESTAMP => $ts1)
ORDER BY id;

-- =====================================================
-- APPEND ONLY MODE
-- Returns only inserted rows
-- =====================================================

SELECT 'APPEND ONLY CHANGES SINCE TS1' AS STAGE;

SELECT *
FROM t1
    CHANGES(INFORMATION => APPEND_ONLY)
    AT(TIMESTAMP => $ts1);

-- =====================================================
-- View all timestamps used
-- =====================================================

SELECT
    $ts1 AS TS1,
    $ts2 AS TS2,
    $ts3 AS TS3;







-----------------------------------------------------------------
CREATE OR REPLACE TABLE t1 (
   id number(8) NOT NULL,
   c1 varchar(255) default NULL
 );

-- Enable change tracking on the table.
 ALTER TABLE t1 SET CHANGE_TRACKING = TRUE;

 -- Initialize a session variable for the current timestamp.
 SET ts1 = (SELECT CURRENT_TIMESTAMP());

 INSERT INTO t1 (id,c1)
 VALUES
 (1,'red'),
 (2,'blue'),
 (3,'green');

 select * from t1;

 DELETE FROM t1 WHERE id = 1;

 UPDATE t1 SET c1 = 'purple' WHERE id = 2;

 -- Query the change tracking metadata in the table during the interval from $ts1 to the current time.
 -- Return the full delta of the changes.
 SELECT *
 FROM t1
   CHANGES(INFORMATION => DEFAULT)
   AT(TIMESTAMP => $ts1);

 +----+--------+-----------------+-------------------+------------------------------------------+
 | ID | C1     | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
 |----+--------+-----------------+-------------------+------------------------------------------|
 |  2 | purple | INSERT          | False             | 1614e92e93f86af6348f15af01a85c4229b42907 |
 |  3 | green  | INSERT          | False             | 86df000054a4d1dc64d5d74a44c3131c4c046a1f |
 +----+--------+-----------------+-------------------+------------------------------------------+

 -- Query the change tracking metadata in the table during the interval from $ts1 to the current time.
 -- Return the append-only changes.
 SELECT *
 FROM t1
   CHANGES(INFORMATION => APPEND_ONLY)
   AT(TIMESTAMP => $ts1);

 +----+-------+-----------------+-------------------+------------------------------------------+
 | ID | C1    | METADATA$ACTION | METADATA$ISUPDATE | METADATA$ROW_ID                          |
 |----+-------+-----------------+-------------------+------------------------------------------|
 |  1 | red   | INSERT          | False             | 6a964a652fa82974f3f20b4f49685de54eeb4093 |
 |  2 | blue  | INSERT          | False             | 1614e92e93f86af6348f15af01a85c4229b42907 |
 |  3 | green | INSERT          | False             | 86df000054a4d1dc64d5d74a44c3131c4c046a1f |
 +----+-------+-----------------+-------------------+------------------------------------------+





-- Create new role [orphaned; not parented to any existing role]
CREATE ROLE IF NOT EXISTS DATA_ANALYST_ROLE;

-- Create new warehouse
CREATE WAREHOUSE IF NOT EXISTS ANALYST_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 300 -- in seconds
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- Create new user
CREATE USER IF NOT EXISTS ANALYST_USER
  PASSWORD = 'ChangeMe123!'
  DEFAULT_ROLE = DATA_ANALYST_ROLE
  DEFAULT_WAREHOUSE = ANALYST_WH
  MUST_CHANGE_PASSWORD = TRUE;

-- Assign role to user
GRANT ROLE DATA_ANALYST_ROLE TO USER ANALYST_USER;

-- Assign warehouse usage permission to role
GRANT USAGE ON WAREHOUSE ANALYST_WH TO ROLE DATA_ANALYST_ROLE;
select 2345;

select 'Aditya' as lead;

select 'Tarun' as Tester;

select 'Rahul' as onprem_dev;

SELECT LAST_QUERY_ID();

SELECT * FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));




SELECT PARSE_JSON('[1,2,3]')::variant;