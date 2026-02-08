-- ============================
-- campaign_performance
-- ============================

USE DATABASE ANYCOMPANY_LAB;
USE SCHEMA SILVER;

-- 1) Link campaigns -> sales (sales during campaign)
SELECT
  c.campaign_id,
  c.campaign_name,
  c.campaign_type,
  c.region,
  c.budget,
  SUM(IFF(t.transaction_type ILIKE 'sale%', t.amount, 0)) AS sales_amount_during,
  SUM(IFF(t.transaction_type ILIKE 'sale%', t.amount, 0)) / NULLIF(c.budget, 0) AS roi_proxy
FROM campaigns c
LEFT JOIN transactions t
  ON t.region = c.region
 AND t.transaction_date BETWEEN c.start_date AND c.end_date
GROUP BY 1,2,3,4,5
ORDER BY roi_proxy DESC NULLS LAST;

-- 2) Identify most effective campaigns using uplift (before vs during)
WITH campaign_window AS (
  SELECT
    campaign_id,
    campaign_name,
    region,
    budget,
    start_date,
    end_date,
    DATEDIFF('day', start_date, end_date) + 1 AS dur_days
  FROM campaigns
),
sales_day AS (
  SELECT
    region,
    transaction_date,
    SUM(IFF(transaction_type ILIKE 'sale%', amount, 0)) AS sales_amount
  FROM transactions
  GROUP BY 1,2
)
SELECT
  c.campaign_id,
  c.campaign_name,
  c.region,
  c.budget,
  SUM(IFF(s.transaction_date BETWEEN c.start_date AND c.end_date, s.sales_amount, 0)) AS sales_during,
  SUM(IFF(s.transaction_date BETWEEN DATEADD(day, -c.dur_days, c.start_date) AND DATEADD(day, -1, c.start_date), s.sales_amount, 0)) AS sales_before,
  (sales_during - sales_before) AS uplift_amount,
  (sales_during - sales_before) / NULLIF(c.budget, 0) AS uplift_per_budget
FROM campaign_window c
LEFT JOIN sales_day s
  ON s.region = c.region
 AND s.transaction_date BETWEEN DATEADD(day, -c.dur_days, c.start_date) AND c.end_date
GROUP BY 1,2,3,4
ORDER BY uplift_per_budget DESC NULLS LAST;
