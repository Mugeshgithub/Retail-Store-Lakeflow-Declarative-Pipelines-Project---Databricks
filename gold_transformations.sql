-- 1. Top 10 Customers by Total Spend
CREATE OR REFRESH MATERIALIZED VIEW retail_store.gold.gold_top_10_customers AS
SELECT
  customer_id,
  first_name,
  last_name,
  SUM(quantity * price) AS total_spend
FROM retail_store.silver.cleaned_sales_data
GROUP BY customer_id, first_name, last_name
ORDER BY total_spend DESC
LIMIT 10;


-- 2. Monthly Revenue Trend
CREATE OR REFRESH MATERIALIZED VIEW retail_store.gold.gold_monthly_revenue_trend AS
SELECT
  DATE_TRUNC('month', order_date) AS sales_month,
  SUM(quantity * price) AS monthly_revenue
FROM retail_store.silver.cleaned_sales_data
GROUP BY sales_month
ORDER BY sales_month;


-- 3. Product Category Performance
CREATE OR REFRESH MATERIALIZED VIEW retail_store.gold.gold_category_performance AS
SELECT
  category,
  SUM(quantity) AS total_units_sold,
  SUM(quantity * price) AS total_revenue
FROM retail_store.silver.cleaned_sales_data
GROUP BY category
ORDER BY total_revenue DESC;



CREATE OR REFRESH MATERIALIZED VIEW retail_store.gold.gold_yearly_revenue AS
SELECT
  YEAR(order_date) AS sales_year,
  SUM(quantity * price) AS total_revenue
FROM retail_store.silver.cleaned_sales_data
GROUP BY sales_year
ORDER BY sales_year;