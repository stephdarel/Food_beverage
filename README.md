# Food_beverage
Workshop – Data-Driven Marketing Analytics avec Snowflake et Streamlit

## Objectif
Mise en place d’un pipeline de données et d’un data product pour analyser
les performances commerciales et marketing d’une entreprise Food & Beverage.

Le projet couvre :
- ingestion de données dans Snowflake (CSV / JSON)
- nettoyage et structuration BRONZE → SILVER
- analyses business (ventes, promotions, campagnes)
- visualisation via une application Streamlit

---

## Architecture
- **Snowflake BRONZE** : données brutes chargées depuis un stage
- **Snowflake SILVER** : données nettoyées et typées
- **Streamlit** : dashboards lisant directement les tables SILVER

---
```
## Structure du projet
Food_beverage/
├── sql/
│ ├── Load_data.sql
│ ├── clean_data.sql
│ ├── sales_trends.sql
│ ├── promotion_impact.sql
│ └── campaign_performance.sql
├── streamlit/
│ ├── app.py
│ ├── utils.py
│ ├── sales_dashboard.py
│ ├── promotions_dashboard.py
│ └── marketing_dashboard.py
├── requirements.txt
└── README.md
```
---

## Installation

python -m venv venv
.\venv\Scripts\activate   
pip install -r requirements.txt

## Configuration Snowflake
Créer un fichier .env à la racine du projet :

SNOWFLAKE_USER=...

SNOWFLAKE_PASSWORD=...

SNOWFLAKE_ACCOUNT=...

SNOWFLAKE_WAREHOUSE=ANALYTICS_WH

SNOWFLAKE_DATABASE=ANYCOMPANY_LAB

SNOWFLAKE_SCHEMA=SILVER


## Exécution SQL

sql/Load_data.sql

sql/clean_data.sql

sql/sales_trends.sql

sql/promotion_impact.sql

sql/campaign_performance.sql

## Lancer Streamlit

streamlit run streamlit/app.py

Dashboards disponibles :
Sales Performance

Promotions Effectiveness

Marketing Campaigns ROI

Travail en équipe
Projet réalisé en groupe avec un workflow Git collaboratif :

branches par fonctionnalité

commits individuels

merges vers main

## Auteurs

Stephane NZATI

Christian SONTSA

Monica MBOULA

Brenda SAMA



