import streamlit as st

st.set_page_config(page_title="Food & Beverage", layout="wide")
st.title("🍔 Food & Beverage – Data Product (Streamlit)")

page = st.sidebar.selectbox(
    "Dashboard",
    ["Sales Performance", "Promotions Effectiveness", "Marketing ROI"],
)

if page == "Sales Performance":
    from sales_dashboard import run
    run()
elif page == "Promotions Effectiveness":
    from promotions_dashboard import run
    run()
else:
    from marketing_dashboard import run
    run()
