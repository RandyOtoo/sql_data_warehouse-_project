/*
======================================================================
DDL Script: Create Bronze Layer Tables
======================================================================

Overview:
    This script sets up the "bronze" layer of the data warehouse.
    The bronze layer stores raw data exactly as it comes from source systems.

What the script does:
    1. Checks if each table already exists in the 'bronze' schema.
    2. If a table exists:
        - It is dropped (deleted).
    3. Recreates the tables as empty structures.

Data Sources:
    The tables are designed to store raw data from two systems:
        - CRM (Customer Relationship Management)
        - ERP (Enterprise Resource Planning)

Tables Created:
    CRM Tables:
        - bronze.crm_cust_info      : Customer basic information
        - bronze.crm_prd_info       : Product details
        - bronze.crm_sales_details  : Sales transaction data

    ERP Tables:
        - bronze.erp_loc_a101       : Customer location data
        - bronze.erp_cust_az12      : Additional customer attributes
        - bronze.erp_px_cat_g1v2    : Product category information

Run this script to re-define the DDL structure of 'bronze' Tables

WARNING:
    - This script will delete existing tables before recreating them.
    - Any data currently stored in these tables will be permanently lost.
    - These tables are intended to hold raw, unprocessed data.

Recommended Use:
    - Initial setup of the bronze layer
    - Resetting raw data tables in development or testing environments
====================================================================================
*/ 


IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;

GO
  
CREATE TABLE bronze.crm_cust_info (
	cst_id			INT,
	cst_key			NVARCHAR(50),
	cst_firstname	NVARCHAR(50),
	cst_lastname	NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr		NVARCHAR(50),
	cst_create_date	DATE
);
GO

IF OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;

GO

CREATE TABLE bronze.crm_prd_info (
	prd_id			INT,
	prd_key			NVARCHAR(50),
	prd_nm			NVARCHAR(50),
	prd_cost		INT,
	prd_line		NVARCHAR(50),
	prd_start_dt	DATETIME,
	prd_end_dt		DATETIME
);
GO

IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;

GO

CREATE TABLE bronze.crm_sales_details (
	sls_ord_num		NVARCHAR(50),
	sls_prd_key		NVARCHAR(50),
	sls_cust_id		INT,
	sls_order_dt	INT,
	sls_ship_dt		INT,
	sls_due_dt		INT,
	sls_sales		INT,
	sls_quantity	INT,
	sls_price		INT
);
GO

IF OBJECT_ID ('bronze.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;

GO

CREATE TABLE bronze.erp_loc_a101 (
	cid		NVARCHAR(50),
	cntry	NVARCHAR(50)
);
GO

  
IF OBJECT_ID ('bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;

GO
  
CREATE TABLE bronze.erp_cust_az12 (
	cid		NVARCHAR(50),
	bdate	DATE,
	gen		NVARCHAR(50),
);
GO

  
IF OBJECT_ID ('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;

GO
  
CREATE TABLE bronze.erp_px_cat_g1v2 (
	id			NVARCHAR(50),
	cat			NVARCHAR(50),
	subcat		NVARCHAR(50),
	maintenance	NVARCHAR(50),
);
