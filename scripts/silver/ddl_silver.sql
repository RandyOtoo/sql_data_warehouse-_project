
/*
===================================================
DDL Script : Create Silver Layer Tables
===================================================

Overview:
    This script creates the "silver" layer tables in the data warehouse.
    The silver layer stores cleaned and standardized data derived from the bronze layer.

What the script does:
    - Checks if each table exists in the 'silver' schema.
    - Drops existing tables if found.
    - Recreates the tables with the required structure.

Data Scope:
    - Includes both CRM and ERP datasets.
    - Table structures mirror the bronze layer but are intended for transformed data.

Important Notes:
    - Existing tables and their data will be permanently deleted.
    - This layer is used for data cleaning, validation, and transformation.

Recommended Use:
    - Initial setup of the silver layer
    - Resetting transformed data tables in development or testing
*/

IF OBJECT_ID ('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info; 
	
GO

CREATE TABLE silver.crm_cust_info (
	cst_id			INT,
	cst_key			NVARCHAR(50),
	cst_firstname	NVARCHAR(50),
	cst_lastname	NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr		NVARCHAR(50),
	cst_create_date	DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;

GO

CREATE TABLE silver.crm_prd_info (
	prd_id			INT,
	prd_key			NVARCHAR(50),
	prd_nm			NVARCHAR(50),
	prd_cost		INT,
	prd_line		NVARCHAR(50),
	prd_start_dt	DATETIME,
	prd_end_dt		DATETIME,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;

GO

CREATE TABLE silver.crm_sales_details (
	sls_ord_num		NVARCHAR(50),
	sls_prd_key		NVARCHAR(50),
	sls_cust_id		INT,
	sls_order_dt	INT,
	sls_ship_dt		INT,
	sls_due_dt		INT,
	sls_sales		INT,
	sls_quantity	INT,
	sls_price		INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101;

GO

CREATE TABLE silver.erp_loc_a101 (
	cid		NVARCHAR(50),
	cntry	NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12;

GO

CREATE TABLE silver.erp_cust_az12 (
	cid		NVARCHAR(50),
	bdate	DATE,
	gen		NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID ('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2;
GO

CREATE TABLE silver.erp_px_cat_g1v2 (
	id			NVARCHAR(50),
	cat			NVARCHAR(50),
	subcat		NVARCHAR(50),
	maintenance	NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO  
