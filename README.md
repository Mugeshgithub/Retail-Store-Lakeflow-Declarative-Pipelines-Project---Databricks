Retail Store Lakeflow Declarative Pipelines Project

Overview
This project demonstrates an end-to-end data pipeline for retail analytics using Databricks Lakeflow Declarative Pipelines (formerly Delta Live Tables). The pipeline ingests raw sales and dimension data from AWS cloud storage, applies data cleaning and quality constraints, and produces business-ready insights for dashboards and reporting.

Architecture
The pipeline follows a multi-layered Lakehouse architecture:

Bronze (Landing) Layer:
Ingests raw CSV files from AWS volumes into streaming tables using Auto Loader.

Silver Layer:
Cleans, casts, and joins data from bronze tables. Applies data quality constraints and prepares unified, analytics-ready tables.

Gold Layer:
Aggregates and summarizes data into materialized views for business intelligence and dashboarding.

Data Sources
Fact Sales: /Volumes/retail_store/landing_zone/fact_and_dimentions_files/fact_sales/
Products: /Volumes/retail_store/landing_zone/fact_and_dimentions_files/dim_products/
Customers: /Volumes/retail_store/landing_zone/fact_and_dimentions_files/dim_customers/
Region: /Volumes/retail_store/landing_zone/fact_and_dimentions_files/dim_region/
Key Features
Streaming Ingestion:
Uses Lakeflow streaming tables and Auto Loader for incremental, scalable data ingestion from AWS.

Data Quality Constraints:
Implements expectations to drop or warn on invalid records (e.g., nulls in key columns).

Schema Evolution:
Automatically adapts to schema changes in source data.

Business Insights:
Gold layer materialized views provide:

Top 10 customers by total spend
Monthly and yearly revenue trends
Product category performance
Region-wise VIP customer revenue
Discount utilization analysis
Dynamic Dashboards:
Gold views are designed for use in Databricks SQL dashboards with dynamic filters (e.g., by year).

Example: Bronze Layer Ingestion

sql CREATE STREAMING LIVE TABLE bronze.fact_sales COMMENT "Raw fact sales from volume to bronze schema" AS SELECT * FROM cloud_files( '/Volumes/retail_store/landing_zone/fact_and_dimentions_files/fact_sales/', 'csv', map('header','true') );

Example: Gold Layer Insight

## How to Run

1. **Configure your pipeline** in Databricks Lakeflow with the provided SQL files for each layer.
2. **Upload your data** to the specified AWS volume paths.
3. **Start the pipeline** and monitor progress in the Databricks UI.
4. **Connect Databricks SQL dashboards** to gold layer materialized views for real-time analytics.

## Version Control

- All pipeline SQL files and documentation are versioned in Git for collaboration and reproducibility.

## Requirements

- Databricks workspace with Unity Catalog enabled
- AWS S3/Volumes access for data storage
- Databricks Lakeflow Declarative Pipelines enabled

## Credits

Developed by the Retail Analytics Data Engineering Team.

