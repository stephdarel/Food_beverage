import streamlit as st
from utils import run_query

def run():
    st.header("📈 Sales Performance")

    sql = """
    SELECT
      region,
      DATE_TRUNC('month', transaction_date) AS month,
      SUM(IFF(transaction_type ILIKE 'sale%', amount, 0)) AS sales_amount,
      COUNT_IF(transaction_type ILIKE 'sale%') AS sales_count
    FROM SILVER.transactions
    WHERE transaction_date IS NOT NULL
    GROUP BY 1,2
    ORDER BY month, region;
    """
    df = run_query(sql)

    regions = sorted(df["REGION"].dropna().unique())
    region = st.selectbox("Region", regions)

    dfr = df[df["REGION"] == region].copy()

    st.subheader(f"Monthly sales – {region}")
    st.line_chart(dfr.set_index("MONTH")["SALES_AMOUNT"])

    st.dataframe(dfr, use_container_width=True)
