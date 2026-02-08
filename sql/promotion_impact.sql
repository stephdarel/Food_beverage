-- ============================
-- promotion_impact.
-- ============================

USE DATABASE ANYCOMPANY_LAB;
USE SCHEMA SILVER;

-- 1) Promotions overview by region
SELECT
  region,
  COUNT(DISTINCT promotion_id) AS nb_promotions,
  AVG(discount_percentage) AS avg_discount
FROM promotions
GROUP BY 1
ORDER BY nb_promotions DESC;

-- 2) Ventes pendant les périodes de promotion
SELECT
  p.region,
  SUM(IFF(t.transaction_type ILIKE 'sale%', t.amount, 0)) AS sales_amount_during_promo,
  COUNT_IF(t.transaction_type ILIKE 'sale%') AS sales_count_during_promo
FROM promotions p
JOIN transactions t
  ON t.region = p.region
 AND t.transaction_date BETWEEN p.start_date AND p.end_date
GROUP BY p.region
ORDER BY sales_amount_during_promo DESC;

-- 3) Comparison: avg daily sales WITH vs WITHOUT promo
WITH promo_days AS (
  SELECT
    region,
    DATEADD(day, seq4(), start_date) AS dt
  FROM promotions,
       TABLE(GENERATOR(ROWCOUNT => 10000)) g
  WHERE DATEADD(day, seq4(), start_date) <= end_date
),
sales_by_day AS (
  SELECT
    region,
    transaction_date AS dt,
    SUM(IFF(transaction_type ILIKE 'sale%', amount, 0)) AS sales_amount
  FROM transactions
  GROUP BY 1,2
)
SELECT
  s.region,
  IFF(p.dt IS NULL, 'NO_PROMO', 'PROMO') AS promo_flag,
  AVG(s.sales_amount) AS avg_daily_sales,
  COUNT(*) AS nb_days
FROM sales_by_day s
LEFT JOIN promo_days p
  ON p.region = s.region AND p.dt = s.dt
GROUP BY 1,2
ORDER BY 1,2;
