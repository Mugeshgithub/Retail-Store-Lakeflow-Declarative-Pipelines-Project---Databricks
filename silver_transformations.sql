--Fact sales

CREATE OR REFRESH STREAMING TABLE silver.fact_sales
COMMENT "Fact sales data cleaning"
AS
SELECT
    CAST(sale_id AS INT) AS sale_id,
    TO_DATE(order_date, 'dd/MM/yyyy') AS order_date,
    CAST(customer_id AS INT) AS customer_id,
    CAST(product_id AS INT) AS product_id,
    CAST(quantity AS INT) AS quantity,
    CAST(discount AS DOUBLE) AS discount,
    CAST(region_id AS INT) AS region_id,
    TRIM(channel) AS channel,
    TRIM(promo_code) AS promo_code
FROM STREAM(bronze.fact_sales);

--customers
CREATE OR REFRESH STREAMING TABLE silver.customers
COMMENT "Customers data cleaning"
AS
SELECT
    CAST(customer_id AS INT) AS customer_id,
    TRIM(first_name) AS first_name,
    TRIM(last_name) AS last_name,
    TRIM(email) AS email,
    TO_DATE(join_date, 'dd/MM/yyyy') AS join_date,
    CAST(vip AS BOOLEAN) AS vip
FROM STREAM(bronze.customers);


-- products
CREATE OR REFRESH STREAMING TABLE silver.products
COMMENT "Products data cleaning"
AS
SELECT
    CAST(product_id AS INT) AS product_id,
    TRIM(product_name) AS product_name,
    TRIM(category) AS category,
    CAST(price AS DOUBLE) AS price,
    CAST(in_stock AS INT) AS in_stock
FROM STREAM(bronze.products);

-- region
CREATE OR REFRESH STREAMING TABLE silver.region
COMMENT "Region data cleaning"
AS
SELECT
    CAST(region_id AS INT) AS region_id,
    TRIM(region_name) AS region_name,
    TRIM(country) AS country
FROM STREAM(bronze.region);