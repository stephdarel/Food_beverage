-- ============================
-- sales_trends
-- ============================

USE DATABASE ANYCOMPANY_LAB;
USE SCHEMA SILVER;

-- 1) Évolution mensuelle des ventes
SELECT
  DATE_TRUNC('month', transaction_date) AS month,
  SUM(IFF(transaction_type ILIKE 'sale%', amount, 0)) AS sales_amount,
  COUNT_IF(transaction_type ILIKE 'sale%') AS sales_count
FROM transactions
GROUP BY 1
ORDER BY 1;

-- 2) Ventes par région
SELECT
  region,
  SUM(IFF(transaction_type ILIKE 'sale%', amount, 0)) AS sales_amount,
  COUNT_IF(transaction_type ILIKE 'sale%') AS sales_count
FROM transactions
GROUP BY 1
ORDER BY sales_amount DESC;

-- 3) Taux de remboursement par region
SELECT
  region,
  COUNT_IF(transaction_type ILIKE 'refund%') * 1.0 / COUNT(*) AS refund_rate
FROM transactions
GROUP BY 1
ORDER BY refund_rate DESC;

-- 4) Gestion du stock
SELECT
  region,
  product_category,
  COUNT_IF(current_stock = 0) AS stockouts,
  COUNT_IF(current_stock <= reorder_point) AS low_stock,
  COUNT(*) AS nb_products
FROM inventory
GROUP BY 1,2
ORDER BY stockouts DESC, low_stock DESC;
