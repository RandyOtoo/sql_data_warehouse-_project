/*
======================================================================
Data Quality Checks: Silver Layer 
======================================================================
Overview:
    This script validates data quality in the silver layer tables.

What the script checks:
    - Primary key integrity (no duplicates or NULLs)
    - Removal of unwanted spaces in text fields.
    - Standardized values (e.g., gender, status, categories)
    - Valid numeric values (no NULLs, negatives, or inconsistencies). 
    - Invalid date ranges and orders.
    - Data Consistency between related fields.
    - Business rules (e.g., Sales = Quantity x Price).

Important Notes:
    - Queries should return no results if data is clean.
    - Any returned records indicate data quality issues that need review.

Recommended Use:
    - Run checks after data loading of silver layer
    - Ongoing data quality monitoring.
-- ------------------------------------------------------------------------------
*/

-- ===================================================
-- Checking CRM Silver Tables
-- ===================================================

-- ===================================================
-- Checking 'silver.crm_cust_info'
-- ===================================================

-- Check for NULLs or Duplicates in Primary key
-- Expectations: No Results

SELECT 
  cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


--------------------------------------------------

-- Check for Unwanted spaces
-- Expectations: No Result

SELECT
  cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT
  cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname!= TRIM(cst_lastname);
--------------------------------------------------------------

-- Data Standardization & Consistency
SELECT DISTINCT 
  cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

SELECT * FROM silver.crm_cust_info;

-- ===================================================
-- Checking 'silver.crm_prd_info'
-- ===================================================

-- Check for NULLs or Duplicates in Primary key
-- Expectations: No Result

SELECT 
  prd_id,
  COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;
------------------------------------------------------------------
-- Check for Unwanted spaces
-- Expectations: No Result

SELECT
  prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);
--------------------------------------------------------------
-- Check for NULLs or Negative Values in Cost
-- Expectations: No Result
SELECT
  prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;
-----------------------------------------------------------------
-- Data Standardization & Consistency
SELECT DISTINCT 
  prd_line
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders (Start Date > End Date)
-- Expectations: No Result
SELECT 
  *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

SELECT *
FROM silver.crm_prd_info;
-----------------------------------------------------------------------


-- ===================================================
-- Checking 'silver.crm_sales_details'
-- ===================================================

-- Check for Invalid Date
-- Expection: No Invalid Dates
SELECT 
  NULLIF(sls_due_dt,0) AS sls_due_dt
FROM silver.crm_sales_details
WHERE  sls_due_dt <= 0 
  OR LEN(sls_due_dt) != 8
  OR sls_due_dt > 20300101
  OR sls_due_dt < 19000101;
------------------------------------------------------------------
-- Check for Invalid Date Orders(Order Date > Shippping/Due Dates)
SELECT 
*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
  OR sls_order_dt > sls_due_dt;
----------------------------------------------------------------
-- Check Data Consistency : Between Sales , Quantity and Price

-- Business Rules
-- >> Sales = Quantity * Price
-- >> Values must not be NULL , zero, or negative
/* Rules
 If Sales is negative , zero or null, derive it using Quantity and Price.
 If Price is zero or null, calculate it using Sales and Quantity.
 If Price is negative, convert it to a positive value. */
  
SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
 OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
 OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
 ORDER BY sls_sales, sls_quantity, sls_price;
-----------------------------------------------------------------------------------------

SELECT 
*
FROM silver.crm_sales_details;

-- ===================================================
-- Checking ERP Silver Tables
-- ===================================================

-- ===================================================
-- Checking 'silver.erp_cust_az12'
-- ===================================================
-- Identify Out-of-Range Dates
-- Expectation: Birthdates b/n 1925-01-01 and Today

SELECT DISTINCT 
  bdate
FROM silver.erp_cust_az12
WHERE bdate < '1925-01-01' 
  OR bdate > GETDATE(); 
-------------------------------------------------------------------------------
-- Data Standardization & Consistency
SELECT DISTINCT 
  gen
FROM silver.erp_cust_az12;
-----------------------------------------------------------------------
SELECT 
*
FROM silver.erp_cust_az12;

-- ===================================================
-- Checking 'silver.erp_loc_a101'
-- ===================================================

-- Data Standardization & Consistency
SELECT DISTINCT 
  cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;

-- ===================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ===================================================
-- Check for umwanted spaces
-- Expectation: No Results
SELECT 
  * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
  OR subcat != TRIM(subcat) 
  OR maintenance != TRIM(maintenance);
-------------------------------------------------------------
-- Data Standardization & Consistency
SELECT DISTINCT 
  maintenance 
FROM silver.erp_px_cat_g1v2;
----------------------------------------------------------------
SELECT * FROM silver.erp_px_cat_g1v2;

