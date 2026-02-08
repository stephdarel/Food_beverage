import streamlit as st
from utils import run_query

def run():
    st.header("🎯 Marketing Campaigns ROI")

    sql = """
    SELECT
      c.campaign_name,
      c.campaign_type,
      c.region,
      c.budget,
      SUM(IFF(t.transaction_type ILIKE 'sale%', t.amount, 0)) AS sales_amount_during,
      SUM(IFF(t.transaction_type ILIKE 'sale%', t.amount, 0)) / NULLIF(c.budget, 0) AS roi_proxy
    FROM SILVER.campaigns c
    LEFT JOIN SILVER.transactions t
      ON t.region = c.region
     AND t.transaction_date BETWEEN c.start_date AND c.end_date
    GROUP BY 1,2,3,4
    ORDER BY roi_proxy DESC NULLS LAST;
    """
    df = run_query(sql)

    st.subheader("Campaign ranking (ROI proxy)")
    st.dataframe(df, use_container_width=True)

    top_n = st.slider("Top N campaigns to plot", 5, 30, 10)
    df_top = df.head(top_n).copy()

    st.bar_chart(df_top.set_index("CAMPAIGN_NAME")["ROI_PROXY"])
