--read fact sales from volume to bronze schema
CREATE STREAMING LIVE TABLE bronze.fact_sales
COMMENT "Row fact sales from volume to bronze schema"
AS
SELECT * FROM cloud_files(
  '/Volumes/retail_store/landing_zone/fact_and_dimentions_files/fact_sales/','csv',map('header','true')
);

--read products from volume to bronze schema
CREATE STREAMING LIVE TABLE bronze.products
COMMENT "Row products from volume to bronze schema"
AS
SELECT * FROM cloud_files(
  '/Volumes/retail_store/landing_zone/fact_and_dimentions_files/dim_products/','csv',map('header','true')
);

--read customers from volume to bronze schema
CREATE STREAMING LIVE TABLE bronze.customers
COMMENT "Row customers from volume to bronze schema"
AS
SELECT * FROM cloud_files(
  '/Volumes/retail_store/landing_zone/fact_and_dimentions_files/dim_customers/','csv',map('header','true')
);

--read region from volume to bronze schema
CREATE STREAMING LIVE TABLE bronze.region
COMMENT "Row region from volume to bronze schema"
AS
SELECT * FROM cloud_files(
  '/Volumes/retail_store/landing_zone/fact_and_dimentions_files/dim_region/','csv',map('header','true')
);
