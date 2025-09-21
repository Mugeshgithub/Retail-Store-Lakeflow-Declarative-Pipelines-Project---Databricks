CREATE OR REFRESH MATERIALIZED VIEW silver.cleaned_sales_data
(
  CONSTRAINT email_not_null EXPECT (c.email IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT quantity_not_null EXPECT (fs.quantity IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT channel_not_null EXPECT (fs.channel IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT promo_code_not_null EXPECT (fs.promo_code IS NOT NULL) ON VIOLATION DROP ROW
)
AS
SELECT
    fs.sale_id,
    fs.order_date,
    fs.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.join_date,
    c.vip,
    fs.product_id,
    p.product_name,
    p.category,
    p.price,
    fs.quantity,
    fs.discount,
    fs.region_id,
    r.region_name,
    r.country,
    fs.channel,
    fs.promo_code
FROM retail_store.silver.fact_sales fs
JOIN retail_store.silver.customers c
    ON fs.customer_id = c.customer_id
JOIN retail_store.silver.products p
    ON fs.product_id = p.product_id
JOIN retail_store.silver.region r
    ON fs.region_id = r.region_id;