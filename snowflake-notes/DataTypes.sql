-- Snowflake data types examples: fixed-point, floating-point, text, binary, and stage queries
-- Co-authored with CoCo
-- Data types for fixed-point numbers
CREATE OR REPLACE TABLE test_fixed(
  num1 NUMBER,
  num2 NUMBER(38, 0),
  num3 NUMBER(20, 0),
  num4 DECIMAL(20, 0),
  num5 NUMERIC(30, 0),
  dec1 NUMBER(10, 1),
  dec2 DECIMAL(20, 2),
  dec3 DEC(20, 2),
  dec4 NUMERIC(30, 3),
  int1 INT,
  int2 INTEGER,
  int3 BIGINT,
  int4 SMALLINT,
  int5 TINYINT,
  int6 BYTEINT
  );

DESC TABLE test_fixed;

-- Always use Number data-type for both Integer and Decimal with fixed-point.

insert overwrite into test_fixed (dec2)
values (35.3435);
select * from test_fixed;


-- Data types for floating-point numbers
CREATE OR REPLACE TABLE test_float(
  double1 DOUBLE,
  float1 FLOAT,
  float2 FLOAT4,
  float3 FLOAT8,
  dfloat DECFLOAT,
  dp1 DOUBLE PRECISION,
  real1 REAL);

DESC TABLE test_float;

insert overwrite into test_float (dfloat)
values (3.1414732);
select * from test_float;

SELECT 0.1::FLOAT + 0.2::FLOAT;

/*
Special values =>
Snowflake supports the following special values for FLOAT:
- 'NaN' (not a number)
- 'inf' (infinity)
- '-inf' (negative infinity)
The symbols 'NaN', 'inf', and '-inf' must be in single quotes, and are case-insensitive.


Number =>
- Exact value
- Scale fixed at x decimal places
- Cannot automatically shift decimal point with an exponent

Float => It's stored in binary floating-point format.
- Variable scale
- Uses exponent
- Approximate representation
- Possible rounding errors

DECFLOAT =>
Use the DECFLOAT data type when you need exact decimal results and a wide, variable scale in the same column.
- Exact value
- Variable scale
- Uses scientific notation internally
- Supports extremely large/small numbers

Summary =>
NUMBER   = Exact Value + Fixed Scale
DECFLOAT = Exact Value + Floating (Variable) Scale
FLOAT    = Approximate Value + Floating (Variable) Scale
*/


CREATE OR REPLACE TABLE test_text(
  vm VARCHAR(134217728),
  vd VARCHAR,
  v50 VARCHAR(50),
  cm CHAR(134217728),
  cd CHAR,
  c10 CHAR(10),
  sm STRING(134217728),
  sd STRING,
  s20 STRING(20),
  tm TEXT(134217728),
  td TEXT,
  t30 TEXT(30));

DESC TABLE test_text;

-- Snowflake treats all of them varchar internally.


------------ String Constants ------------------
-- String Literals [Always use single quote]
select 'dgdfgfg'

-- Escape Characaters [Method-1 Use backslash]
select 'string with a\' character'
-- Escape Characaters [Method-2 Use double dollar]
select $$string with a' character$$
-- To include a single quote character within a string constant, type two adjacent single quotes. [Only for escaping quote]
select 'string with a'' character'


--- Skip Binary Data Type [Not Important for interviews] ---------