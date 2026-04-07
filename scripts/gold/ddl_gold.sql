/*
========================================================
DDL Script: Create Gold Layer (Dimensions & Fact Views)
========================================================

Overview:
    This script creates the gold layer views for analytics and reporting.
    It includes dimension tables and a fact table(Star Schema) built from the silver layer.

What the script does:
    - Drops existing views if they exist.
    - Creates dimension views:
        - dim_customers : customer details enriched with ERP data.
        - dim_products  : product and category information
    - Creates fact view:
        - fact_sales    : sales transactions linked to customers and products

Key Features:
    - Generates surrogate keys using ROW_NUMBER()
    - Joins multiple sources to enrich data
    - Applies business rules (e.g., latest products only)

Important Notes:
    - Views are built on cleaned data from the silver layer.
    - Designed for reporting, dashboards, and analytics use cases.

Recommended Use:
    - Final data layer for BI tools and business analysis
*/


-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,-- Surrogate key
	ci.cst_id							AS customer_id,
	ci.cst_key							AS customer_number,
	ci.cst_firstname					AS first_name,
	ci.cst_lastname						AS last_name,
	la.cntry							AS country,
	ci.cst_marital_status				AS marital_status,
	CASE WHEN ci.cst_gndr != 'Unknown' THEN ci.cst_gndr -- CRM is the Master for gender info
		 ELSE COALESCE(ca.gen, 'Unknown')				-- Fallback to ERP data
	END									AS gender,
	ca.bdate							AS birthdate,
	ci.cst_create_date					AS create_date 
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
	ON	ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
	ON	ci.cst_key = la.cid;

GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY pd.prd_start_dt, pd.prd_key) AS product_key, -- Surrogate key
	pd.prd_id		AS product_id,
	pd.prd_key		AS product_number,
	pd.cat_id		AS category_id,
	pd.prd_nm		AS product_name,
	pd.prd_line		AS product_line,
	pc.cat			AS category,
	pc.subcat		AS subcategory,
	pc.maintenance  AS maintenance,
	pd.prd_cost		AS cost,
	pd.prd_start_dt	AS start_date
FROM silver.crm_prd_info pd
LEFT JOIN silver.erp_px_cat_g1v2 pc
	ON	pd.cat_id = pc.id
WHERE prd_end_dt IS NULL ;-- Filter out all historical data
GO

-- ===============================================================
-- Create Fact Table: gold.fact_sales
-- ===============================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT 
	sd.sls_ord_num		AS order_number,
	pr.product_key		AS product_key,
	cs.customer_key		AS customer_key,
	sd.sls_order_dt		AS order_date,
	sd.sls_ship_dt		AS shipping_date,
	sd.sls_due_dt		AS due_date,
	sd.sls_sales		AS sales_amount,
	sd.sls_quantity		AS quantity,
	sd.sls_price		AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
	ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cs
	ON sd.sls_cust_id = cs.customer_id;
GO

