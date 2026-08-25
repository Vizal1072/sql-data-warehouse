
/*
========================================================================================
Quality Checks
========================================================================================
Script Purpose:
  This script performes various quality checks for data consistency , accuracy, 
  and standarization across the 'silver' schemas. It includes checks for:
  - Null or duplicate primary keys.
  - Unwanted spaces in string fields.
  - Data standardization and consistency
  - Invalid date ranges and orders
  - Data consistency between related fields.

Usage Notes:
  - Run those checks after data loading Silver Layer.
  - Investigate and resolve any discrepancies found during the checks.
========================================================================================
*/

-- ===================================================================================
-- Checking 'silver.crm_cust_info'
-- ===================================================================================
-- Checks for NULLs or Duplicates in Primary Key
-- Expectations: No Results

SELECT 
  cst_id, 
  COUNT(*) 
FROM silver.crm_cust_info 
GROUP BY cst_id 
HAVING COUNT(*) > 1 or cst_id IS NULL;

-- Check for Unwanted Spaces
-- Expectations: No Results

SELECT 
  cst_key,
  cst_firstname,
  cst_lastname,
  cst_gndr
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key) 
  OR cst_firstname != TRIM(cst_firstname)
  OR cst_lastname != TRIM(cst_lastname)
  OR cst_gndr != TRIM(cst_gndr);
  
-- Data Standardization & Consistency
-- Expectations: No Results

SELECT DISTINCT 
  cst_gndr 
FROM silver.crm_cust_info;

SELECT DISTINCT 
  cst_marital_status 
FROM silver.crm_cust_info;

-- ===================================================================================
-- Checking 'silver.crm_prd_info'
-- ===================================================================================
-- Checks for NULLs or Duplicates in Primary Key
-- Expectations: No Results
SELECT 
  prd_id, 
  COUNT(*) 
FROM silver.crm_prd_info 
GROUP BY prd_id 
HAVING COUNT(*) > 1 or prd_id IS NULL;

-- Check for Unwanted Spaces
-- Expectations: No Results

SELECT 
  prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm) ;

-- Check for NULLs or Negative Values 
-- Expectations: No Results

SELECT 
  prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data Transformation and Consistency
-- Expectations: No Results

SELECT DISTINCT 
    prd_line 
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders ( Start Date > End Date )
-- Expectations: No Results

SELECT 
  * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ===================================================================================
-- Checking 'silver.crm_sales_details'
-- ===================================================================================
-- Check for Invalid Dates
-- Expectations: No Invalid Dates

SELECT 
  NULLIF(sls_order_dt,0) AS sls_order_dt
FROM silver.crm_sales_details
WHERE sls_due_dt<=0
  OR LEN(sls_due_dt) !=8
  OR sls_due_dt > '2050-01-01'
  OR sls_due_dt < '1900-01-01';

-- Check for Invalid Date (Order date < Shipping/ Due date)
-- Expectations: No Results

SELECT
    *
FROM silver.crm_sales_details
WHERE sls_order_dt < sls_ship_dt
  OR sls_order_dt < sls_due_dt;

 
-- Data Standardization & Consistency
-- Expectations: No Results

SELECT DISTINCT 
  sls_sales,
  sls_quantity,
  sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
  OR sls_sales IS NULL
  OR sls_quantity IS NULL
  OR sls_price IS NULL
  OR sls_sales <= 0
  OR sls_quantity <= 0
  OR sls_price <= 0
ORDER BY sls_sales, sls_quantity,sls_price;

-- ===================================================================================
-- Checking 'silver.erp_cust_az12'
-- ===================================================================================
-- Identify Out-of-Range Dates
-- Expectations: BirthDates Between 1924-01-01 and Today

SELECT 
  bdate 
FROM silver.erp_cust_az12 
WHERE bdate < '1924-01-01' 
  OR bdate > GETDATE();

-- Data Standardization & Consistency
-- Expectations: No Results

SELECT DISTINCT 
  gen
FROM silver.erp_cust_az12 
ORDER BY gen;

-- ===================================================================================
-- Checking 'silver.erp_loc_a101'
-- ===================================================================================
-- Data Standardization & Consistency
-- Expectations: No Results

SELECT DISTINCT 
  cntry 
FROM silver.erp_loc_a101 ORDER BY cntry;

-- ===================================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ===================================================================================
-- Checks for Unwanted Spaces
-- Expectations: No Results

SELECT 
  *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
  OR subcat !=TRIM(subcat)
  OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency
-- Expectations: No Results

SELECT DISTINCT 
  maintenance
FROM silver.erp_px_cat_g1v2; 








