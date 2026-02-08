

USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE WAREHOUSE ANALYTICS_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE;

CREATE OR REPLACE DATABASE ANYCOMPANY_LAB;
CREATE OR REPLACE SCHEMA ANYCOMPANY_LAB.BRONZE;
CREATE OR REPLACE SCHEMA ANYCOMPANY_LAB.SILVER;

USE WAREHOUSE ANALYTICS_WH;
USE DATABASE ANYCOMPANY_LAB;

-- Stage
CREATE OR REPLACE STAGE ANYCOMPANY_LAB.BRONZE.food_stage
  URL = 's3://logbrain-datalake/datasets/food-beverage/';

-- File formats
CREATE OR REPLACE FILE FORMAT ANYCOMPANY_LAB.BRONZE.csv
  TYPE = 'CSV'
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  TRIM_SPACE = TRUE
  NULL_IF = ('', 'NULL', 'null')
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;

CREATE OR REPLACE FILE FORMAT ANYCOMPANY_LAB.BRONZE.json
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE;

-- -------------------
-- BRONZE TABLES
-- -------------------
CREATE OR REPLACE TABLE ANYCOMPANY_LAB.BRONZE.customer_demographics (
  customer_id STRING,
  name STRING,
  date_of_birth STRING,
  gender STRING,
  region STRING,
  country STRING,
  city STRING,
  marital_status STRING,
  annual_income STRING
);

CREATE OR REPLACE TABLE ANYCOMPANY_LAB.BRONZE.customer_service_interactions (
  interaction_id STRING,
  interaction_date STRING,
  interaction_type STRING,
  issue_category STRING,
  description STRING,
  duration_minutes STRING,
  resolution_status STRING,
  follow_up_required STRING,
  customer_satisfaction STRING
);

CREATE OR REPLACE TABLE ANYCOMPANY_LAB.BRONZE.promotions_data (
  promotion_id STRING,
  product_category STRING,
  promotion_type STRING,
  discount_percentage STRING,
  start_date STRING,
  end_date STRING,
  region STRING
);

CREATE OR REPLACE TABLE ANYCOMPANY_LAB.BRONZE.marketing_campaigns (
  campaign_id STRING,
  campaign_name STRING,
  campaign_type STRING,
  product_category STRING,
  target_audience STRING,
  start_date STRING,
  end_date STRING,
  region STRING,
  budget STRING,
  reach STRING,
  conversion_rate STRING
);

CREATE OR REPLACE TABLE ANYCOMPANY_LAB.BRONZE.financial_transactions (
  transaction_id STRING,
  transaction_date STRING,
  transaction_type STRING,
  amount STRING,
  payment_method STRING,
  entity STRING,
  region STRING,
  account_code STRING
);

CREATE OR REPLACE TABLE ANYCOMPANY_LAB.BRONZE.logistics_and_shipping (
  shipment_id STRING,
  order_id STRING,
  ship_date STRING,
  estimated_delivery STRING,
  shipping_method STRING,
  status STRING,
  shipping_cost STRING,
  destination_region STRING,
  destination_country STRING,
  carrier STRING
);

CREATE OR REPLACE TABLE ANYCOMPANY_LAB.BRONZE.supplier_information (
  supplier_id STRING,
  supplier_name STRING,
  product_category STRING,
  region STRING,
  country STRING,
  city STRING,
  lead_time STRING,
  reliability_score STRING,
  quality_rating STRING
);

CREATE OR REPLACE TABLE ANYCOMPANY_LAB.BRONZE.employee_records (
  employee_id STRING,
  name STRING,
  date_of_birth STRING,
  hire_date STRING,
  department STRING,
  job_title STRING,
  salary STRING,
  region STRING,
  country STRING,
  email STRING
);

-- JSON 
CREATE OR REPLACE TABLE ANYCOMPANY_LAB.BRONZE.inventory (data VARIANT);
CREATE OR REPLACE TABLE ANYCOMPANY_LAB.BRONZE.store_locations (data VARIANT);

-- (Option) Reviews are problematic in your case 

-- ------------
-- COPY INTO
-- ------------
COPY INTO ANYCOMPANY_LAB.BRONZE.customer_demographics
FROM @ANYCOMPANY_LAB.BRONZE.food_stage/customer_demographics.csv
FILE_FORMAT = (FORMAT_NAME = ANYCOMPANY_LAB.BRONZE.csv)
FORCE = TRUE;

COPY INTO ANYCOMPANY_LAB.BRONZE.customer_service_interactions
FROM @ANYCOMPANY_LAB.BRONZE.food_stage/customer_service_interactions.csv
FILE_FORMAT = (FORMAT_NAME = ANYCOMPANY_LAB.BRONZE.csv)
FORCE = TRUE;

COPY INTO ANYCOMPANY_LAB.BRONZE.promotions_data
FROM @ANYCOMPANY_LAB.BRONZE.food_stage/promotions-data.csv
FILE_FORMAT = (FORMAT_NAME = ANYCOMPANY_LAB.BRONZE.csv)
FORCE = TRUE;

COPY INTO ANYCOMPANY_LAB.BRONZE.marketing_campaigns
FROM @ANYCOMPANY_LAB.BRONZE.food_stage/marketing_campaigns.csv
FILE_FORMAT = (FORMAT_NAME = ANYCOMPANY_LAB.BRONZE.csv)
FORCE = TRUE;

COPY INTO ANYCOMPANY_LAB.BRONZE.financial_transactions
FROM @ANYCOMPANY_LAB.BRONZE.food_stage/financial_transactions.csv
FILE_FORMAT = (FORMAT_NAME = ANYCOMPANY_LAB.BRONZE.csv)
FORCE = TRUE;

COPY INTO ANYCOMPANY_LAB.BRONZE.logistics_and_shipping
FROM @ANYCOMPANY_LAB.BRONZE.food_stage/logistics_and_shipping.csv
FILE_FORMAT = (FORMAT_NAME = ANYCOMPANY_LAB.BRONZE.csv)
FORCE = TRUE;

COPY INTO ANYCOMPANY_LAB.BRONZE.supplier_information
FROM @ANYCOMPANY_LAB.BRONZE.food_stage/supplier_information.csv
FILE_FORMAT = (FORMAT_NAME = ANYCOMPANY_LAB.BRONZE.csv)
FORCE = TRUE;

COPY INTO ANYCOMPANY_LAB.BRONZE.employee_records
FROM @ANYCOMPANY_LAB.BRONZE.food_stage/employee_records.csv
FILE_FORMAT = (FORMAT_NAME = ANYCOMPANY_LAB.BRONZE.csv)
FORCE = TRUE;

COPY INTO ANYCOMPANY_LAB.BRONZE.inventory
FROM @ANYCOMPANY_LAB.BRONZE.food_stage/inventory.json
FILE_FORMAT = (FORMAT_NAME = ANYCOMPANY_LAB.BRONZE.json)
FORCE = TRUE;

COPY INTO ANYCOMPANY_LAB.BRONZE.store_locations
FROM @ANYCOMPANY_LAB.BRONZE.food_stage/store_locations.json
FILE_FORMAT = (FORMAT_NAME = ANYCOMPANY_LAB.BRONZE.json)
FORCE = TRUE;

-- quick checks
SELECT COUNT(*) AS n_transactions FROM ANYCOMPANY_LAB.BRONZE.financial_transactions;
SELECT COUNT(*) AS n_customers FROM ANYCOMPANY_LAB.BRONZE.customer_demographics;
SELECT * FROM ANYCOMPANY_LAB.BRONZE.inventory LIMIT 10;