import os
import pandas as pd
import snowflake.connector
from dotenv import load_dotenv

load_dotenv()  # charge le .env

def get_connection():
    return snowflake.connector.connect(
        user=os.getenv("SNOWFLAKE_USER"),
        password=os.getenv("SNOWFLAKE_PASSWORD"),
        account=os.getenv("SNOWFLAKE_ACCOUNT"),
        warehouse=os.getenv("SNOWFLAKE_WAREHOUSE", "ANALYTICS_WH"),
        database=os.getenv("SNOWFLAKE_DATABASE", "ANYCOMPANY_LAB"),
        schema=os.getenv("SNOWFLAKE_SCHEMA", "SILVER"),
    )

def run_query(sql: str) -> pd.DataFrame:
    conn = get_connection()
    try:
        df = pd.read_sql(sql, conn)
    finally:
        conn.close()
    return df
