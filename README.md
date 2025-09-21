# Retail Analytics Lakehouse Pipeline with Databricks Lakeflow Declarative Pipelines

---

## Table of Contents

1. [Overview](#overview)
2. [Technologies Used](#technologies-used)
3. [Architecture](#architecture)
4. [Data Sources](#data-sources)
5. [Pipeline Flow](#pipeline-flow)
    - [Bronze Layer: Ingestion](#bronze-layer-ingestion)
    - [Silver Layer: Data Cleaning & Transformation](#silver-layer-data-cleaning--transformation)
    - [Gold Layer: Aggregation & Business Insights](#gold-layer-aggregation--business-insights)
6. [Key Features](#key-features)
7. [Business Insights Delivered](#business-insights-delivered)
8. [How to Run](#how-to-run)
9. [Requirements](#requirements)
10. [Credits](#credits)

---

## Overview

This project implements a robust, end-to-end data pipeline for retail analytics using **Databricks Lakeflow Declarative Pipelines** (formerly Delta Live Tables) on AWS. The pipeline ingests raw sales and dimension data, applies data quality checks, transforms and aggregates the data, and delivers business-ready insights for dashboards and reporting.

---

## Technologies Used

- **Databricks Lakeflow Declarative Pipelines** – declarative, scalable, automated pipeline orchestration.
- **Databricks Unity Catalog** – unified data governance and fine-grained access control.
- **AWS S3/Volumes** – cloud storage layer for raw data ingestion.
- **Auto Loader** – efficient, incremental ingestion of new files from AWS storage.
- **Delta Lake** – ACID-compliant, scalable, performant data storage and management.
- **Databricks SQL** – analytics, dashboarding, and business intelligence.
- **PySpark** – advanced data transformations (if needed).
- **Git** – version control and collaboration.

---

## Architecture

The pipeline follows the Lakehouse multi-layered architecture:

### Bronze (Landing) Layer
- Ingests raw CSV files from AWS Volumes using Auto Loader into streaming tables.

### Silver Layer
- Cleans, casts, and joins data from bronze tables.
- Applies data quality constraints and prepares unified, analytics-ready tables.

### Gold Layer
- Aggregates and summarizes data into materialized views for business intelligence and dashboarding.

---

## Data Sources

- **Fact Sales**:  
  `/Volumes/retail_store/landing_zone/fact_and_dimentions_files/fact_sales/`
- **Products**:  
  `/Volumes/retail_store/landing_zone/fact_and_dimentions_files/dim_products/`
- **Customers**:  
  `/Volumes/retail_store/landing_zone/fact_and_dimentions_files/dim_customers/`
- **Region**:  
  `/Volumes/retail_store/landing_zone/fact_and_dimentions_files/dim_region/`

---

## Pipeline Flow

### Bronze Layer: Ingestion

- Uses `CREATE STREAMING LIVE TABLE` to ingest raw CSV data from AWS Volumes via Auto Loader.

```sql
CREATE STREAMING LIVE TABLE bronze.fact_sales
COMMENT "Raw fact sales from volume to bronze schema"
AS
SELECT * FROM cloud_files(
    '/Volumes/retail_store/landing_zone/fact_and_dimentions_files/fact_sales/',
    'csv',
    map('header','true')
);
```

### Silver Layer: Data Cleaning & Transformation

- Cleans and casts data types, trims strings, and applies data quality constraints.
- Joins fact and dimension tables to create a unified `cleaned_sales_data` table.

```sql
CREATE OR REFRESH STREAMING TABLE silver.cleaned_sales_data (
    CONSTRAINT email_not_null EXPECT (email IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT quantity_not_null EXPECT (quantity IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT channel_not_null EXPECT (channel IS NOT NULL) ON VIOLATION DROP ROW,
    CONSTRAINT promo_code_not_null EXPECT (promo_code IS NOT NULL) ON VIOLATION DROP ROW
)
AS
SELECT
    fs.sale_id, fs.order_date, fs.customer_id,
    c.first_name, c.last_name, c.email, c.join_date, c.vip,
    fs.product_id, p.product_name, p.category, p.price,
    fs.quantity, fs.discount, fs.region_id,
    r.region_name, r.country,
    fs.channel, fs.promo_code
FROM bronze.fact_sales fs
JOIN bronze.customers c ON fs.customer_id = c.customer_id
JOIN bronze.products p ON fs.product_id = p.product_id
JOIN bronze.region r ON fs.region_id = r.region_id;
```

### Gold Layer: Aggregation & Business Insights

- Creates materialized views for business reporting and dashboarding.

```sql
CREATE OR REFRESH MATERIALIZED VIEW gold.gold_top_10_customers AS
SELECT
    customer_id, first_name, last_name,
    SUM(quantity * price) AS total_spend
FROM silver.cleaned_sales_data
GROUP BY customer_id, first_name, last_name
ORDER BY total_spend DESC
LIMIT 10;
```

---

## Key Features

- **Streaming Ingestion**  
  Auto Loader enables scalable, incremental ingestion of new data files from AWS Volumes.
- **Data Quality Enforcement**  
  Expectations and constraints ensure only high-quality data flows downstream.
- **Schema Evolution**  
  The pipeline automatically adapts to schema changes in source data.
- **Version Control**  
  All pipeline SQL files and documentation are versioned in Git for collaboration and reproducibility.

---

## Business Insights Delivered

Gold layer materialized views provide:

- Top 10 customers by total spend
- Monthly and yearly revenue trends
- Product category performance
- Region-wise VIP customer revenue
- Discount utilization analysis

Views are designed for use in Databricks SQL dashboards with dynamic filters (e.g., by year).

---

## How to Run

1. **Configure your pipeline** in Databricks Lakeflow with the provided SQL files for each layer.
2. **Upload your data** to the specified AWS volume paths.
3. **Start the pipeline** and monitor progress in the Databricks UI.
4. **Connect Databricks SQL dashboards** to gold layer materialized views for real-time analytics.

---

## Requirements

- Databricks workspace with Unity Catalog enabled
- AWS S3/Volumes access for data storage
- Databricks Lakeflow Declarative Pipelines enabled
- Databricks SQL access for dashboarding

---

## Credits

Developed by the Retail Analytics Data Engineering Team.
