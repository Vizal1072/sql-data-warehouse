/*
=====================================================================================
DDL Script : Gold Views
=====================================================================================
Script Purpose: 
    This purpose creates views for gold layetr in the data warehouse.
    The Gold layer represents the final dimension and fact tables in star schema.

    Each view performs transformations and combines data from the Silver layer.
    to producr a clean, enriched, and business-ready dataset.

Usage:
    -   t  hese views can be queried directly for analytics and reporting.
=====================================================================================
*/

-- ===================================================================
-- Fact Table : gold.dim_customers
-- ===================================================================

IF OBJECT_ID('gold.dim_customers','U') IS NOT NULL
  DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	la.cntry as country,
	ci.cst_marital_status as marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		 ELSE COALESCE(ca.gen,'n/a')
	END AS gender,
	ca.bdate as birthdate,
	ci.cst_create_date as create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
  ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
  ON ci.cst_key=la.cid;

GO

-- ===================================================================
-- Fact Table : gold.dim_products
-- ===================================================================

IF OBJECT_ID('gold.dim_products','U') IS NOT NULL
  DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as  category_id,
	pc.cat as category,
	pc.subcat as sub_category,
	pc.maintenance as maintenance,
	pn.prd_cost as cost,
	pn.prd_line as  product_line,
	pn.prd_start_dt as start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
  ON pn.cat_id=pc.id
WHERE pn.prd_end_dt IS NULL;

GO

-- ===================================================================
-- Fact Table : gold.fact_sales
-- ===================================================================

IF OBJECT_ID('gold.fact_sales','U') IS NOT NULL
  DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT 
  sd.sls_ord_num AS order_number,
  pr.product_key,
  cu.customer_key,
  sd.sls_order_dt AS order_date,
  sd.sls_ship_dt AS shipping_date,
  sd.sls_due_dt AS due_date,
  sd.sls_sales AS sales_amount,
  sd.sls_quantity AS quantity,
  sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
  ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
  ON sd.sls_cust_id = cu.customer_id;

GO

 
