import streamlit as st
from utils import run_query

def run():
    st.header("🏷 Promotions Effectiveness")

    sql = """
    WITH promo_days AS (
      SELECT
        region,
        DATEADD(day, seq4(), start_date) AS dt
      FROM SILVER.promotions,
           TABLE(GENERATOR(ROWCOUNT => 10000)) g
      WHERE start_date IS NOT NULL
        AND end_date IS NOT NULL
        AND DATEADD(day, seq4(), start_date) <= end_date
    ),
    sales_by_day AS (
      SELECT
        region,
        transaction_date AS dt,
        SUM(IFF(transaction_type ILIKE 'sale%', amount, 0)) AS sales_amount
      FROM SILVER.transactions
      WHERE transaction_date IS NOT NULL
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
    ORDER BY region, promo_flag;
    """
    df = run_query(sql)

    regions = sorted(df["REGION"].dropna().unique())
    region = st.selectbox("Region", regions)

    dfr = df[df["REGION"] == region].copy()

    st.subheader("Avg daily sales: with vs without promo")
    st.bar_chart(dfr.set_index("PROMO_FLAG")["AVG_DAILY_SALES"])

    st.dataframe(dfr, use_container_width=True)
