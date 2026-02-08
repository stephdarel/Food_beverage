-- ============================
--  SILVER
-- ============================

USE DATABASE ANYCOMPANY_LAB;
USE SCHEMA SILVER;

-- Customers
CREATE OR REPLACE TABLE ANYCOMPANY_LAB.SILVER.customers AS
SELECT
  customer_id,
  name AS customer_name,
  TRY_TO_DATE(date_of_birth) AS date_of_birth,
  gender,
  region,
  country,
  city,
  marital_status,
  TRY_TO_NUMBER(REPLACE(annual_income,' ','')) AS annual_income
FROM ANYCOMPANY_LAB.BRONZE.customer_demographics
QUALIFY ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY customer_id) = 1;

-- Transactions
CREATE OR REPLACE TABLE ANYCOMPANY_LAB.SILVER.transactions AS
SELECT
  transaction_id,
  TRY_TO_DATE(transaction_date) AS transaction_date,
  transaction_type,
  TRY_TO_DECIMAL(REPLACE(amount,' ',''), 18, 2) AS amount,
  payment_method,
  entity,
  region,
  account_code
FROM ANYCOMPANY_LAB.BRONZE.financial_transactions
WHERE TRY_TO_DATE(transaction_date) IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_date) = 1;

-- Promotions
CREATE OR REPLACE TABLE ANYCOMPANY_LAB.SILVER.promotions AS
SELECT
  promotion_id,
  product_category,
  promotion_type,
  TRY_TO_DECIMAL(discount_percentage, 10, 4) AS discount_percentage,
  TRY_TO_DATE(start_date) AS start_date,
  TRY_TO_DATE(end_date) AS end_date,
  region
FROM ANYCOMPANY_LAB.BRONZE.promotions_data
WHERE TRY_TO_DATE(start_date) IS NOT NULL
  AND TRY_TO_DATE(end_date) IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY promotion_id ORDER BY start_date) = 1;

-- Campaigns
CREATE OR REPLACE TABLE ANYCOMPANY_LAB.SILVER.campaigns AS
SELECT
  campaign_id,
  campaign_name,
  campaign_type,
  product_category,
  target_audience,
  TRY_TO_DATE(start_date) AS start_date,
  TRY_TO_DATE(end_date) AS end_date,
  region,
  TRY_TO_DECIMAL(REPLACE(budget,' ',''), 18, 2) AS budget,
  TRY_TO_NUMBER(REPLACE(reach,' ','')) AS reach,
  TRY_TO_DECIMAL(conversion_rate, 10, 4) AS conversion_rate
FROM ANYCOMPANY_LAB.BRONZE.marketing_campaigns
WHERE TRY_TO_DATE(start_date) IS NOT NULL
  AND TRY_TO_DATE(end_date) IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY campaign_id ORDER BY start_date) = 1;

-- Shipping
CREATE OR REPLACE TABLE ANYCOMPANY_LAB.SILVER.shipping AS
SELECT
  shipment_id,
  order_id,
  TRY_TO_DATE(ship_date) AS ship_date,
  TRY_TO_DATE(estimated_delivery) AS estimated_delivery,
  shipping_method,
  status,
  TRY_TO_DECIMAL(REPLACE(shipping_cost,' ',''), 18, 2) AS shipping_cost,
  destination_region,
  destination_country,
  carrier
FROM ANYCOMPANY_LAB.BRONZE.logistics_and_shipping
WHERE TRY_TO_DATE(ship_date) IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY shipment_id ORDER BY ship_date) = 1;

-- Suppliers
CREATE OR REPLACE TABLE ANYCOMPANY_LAB.SILVER.suppliers AS
SELECT
  supplier_id,
  supplier_name,
  product_category,
  region,
  country,
  city,
  TRY_TO_NUMBER(lead_time) AS lead_time,
  TRY_TO_DECIMAL(reliability_score, 10, 4) AS reliability_score,
  TRY_TO_DECIMAL(quality_rating, 10, 4) AS quality_rating
FROM ANYCOMPANY_LAB.BRONZE.supplier_information
QUALIFY ROW_NUMBER() OVER (PARTITION BY supplier_id ORDER BY supplier_id) = 1;

-- Inventory (JSON)
CREATE OR REPLACE TABLE ANYCOMPANY_LAB.SILVER.inventory AS
SELECT
  data:product_id::STRING AS product_id,
  data:product_category::STRING AS product_category,
  data:region::STRING AS region,
  data:country::STRING AS country,
  data:warehouse::STRING AS warehouse,
  data:current_stock::INT AS current_stock,
  data:reorder_point::INT AS reorder_point,
  data:lead_time::INT AS lead_time,
  TRY_TO_DATE(data:last_restock_date::STRING) AS last_restock_date
FROM ANYCOMPANY_LAB.BRONZE.inventory;

-- Store locations (JSON)
CREATE OR REPLACE TABLE ANYCOMPANY_LAB.SILVER.store_locations AS
SELECT
  data:store_id::STRING AS store_id,
  data:store_name::STRING AS store_name,
  data:store_type::STRING AS store_type,
  data:region::STRING AS region,
  data:country::STRING AS country,
  data:city::STRING AS city,
  data:address::STRING AS address,
  data:postal_code::STRING AS postal_code,
  data:square_footage::FLOAT AS square_footage,
  data:employee_count::INT AS employee_count
FROM ANYCOMPANY_LAB.BRONZE.store_locations;

-- Quick sanity checks
SELECT COUNT(*) AS n_silver_transactions FROM ANYCOMPANY_LAB.SILVER.transactions;
SELECT COUNT(*) AS n_silver_customers FROM ANYCOMPANY_LAB.SILVER.customers;
SELECT * FROM ANYCOMPANY_LAB.SILVER.inventory LIMIT 10;