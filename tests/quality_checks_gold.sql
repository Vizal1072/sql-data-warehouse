/*
=================================================================================
Quality Checks
=================================================================================
Script Purpose:
    This script performs quality checksd to validate the integrity, consustency,
    and accuracy of the Gold Layer.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepnacies found during the checks.
=================================================================================
*/

-- ==============================================================
-- Checking 'gold.dim_customers'
-- ==============================================================
-- Checck the Uniqueness of customer key.
-- Expectations: No Results

SELECT 
  customer_key,
  COUNT(*) AS duplicate,
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT (*) > 1 ;

-- ==============================================================
-- Checking 'gold.dim_products'
-- ==============================================================
-- Checck the Uniqueness of product key.
-- Expectations: No Results

SELECT 
  product_key,
  COUNT(*) AS duplicate,
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT (*) > 1 ;

-- ==============================================================
-- Checking 'gold.fact_sales'
-- ==============================================================
-- Checck the data model connectivity between dact and dimensions.

SELECT *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;
