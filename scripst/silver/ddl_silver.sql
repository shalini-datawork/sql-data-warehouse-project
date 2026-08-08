/*
===============================================================================
Purpose:
    Creates the Silver layer tables for the Data Warehouse.

    The Silver layer stores cleaned, standardized, and transformed data
    originating from the Bronze layer. These tables are used as the trusted
    intermediate layer for downstream Gold-layer transformations.

Source Systems:
    - CRM (Customer Relationship Management)
    - ERP (Enterprise Resource Planning)

WARNING:
    - This script is DESTRUCTIVE.
    - If any of the listed Silver tables already exist, they will be dropped
      before being recreated.
    - All existing data in these tables will be permanently deleted.
    - Execute this script only when the Silver layer structure needs to be
      recreated.

Prerequisites:
    - The 'DataWarehouse' database must already exist.
    - The 'silver' schema must already exist.
    - Appropriate permissions are required to drop and create tables.

Design Notes:
    - The Silver tables use data types appropriate for the cleaned data.
    - 'dwh_create_date' records when each row is inserted into the Silver layer.
    - The DEFAULT constraint automatically populates 'dwh_create_date' when
      a row is inserted without explicitly providing a value.
===============================================================================
*/


--=============================================================================
-- CRM CUSTOMER INFORMATION
-- Stores cleaned and standardized customer master data from the CRM system.
--=============================================================================

IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info
(
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


--=============================================================================
-- CRM PRODUCT INFORMATION
-- Stores cleaned and standardized product master data from the CRM system.
--=============================================================================

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info
(
    prd_id INT,
    cat_id NVARCHAR(50),
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


--=============================================================================
-- CRM SALES DETAILS
-- Stores cleaned and standardized sales transaction data from the CRM system.
--=============================================================================

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details
(
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


--=============================================================================
-- ERP CUSTOMER INFORMATION
-- Stores cleaned customer demographic data from the ERP system.
--=============================================================================

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;

CREATE TABLE silver.erp_cust_az12
(
    cid NVARCHAR(50),
    bdate DATE,
    gen VARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


--=============================================================================
-- ERP CUSTOMER LOCATION
-- Stores standardized customer location data from the ERP system.
--=============================================================================

IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;

CREATE TABLE silver.erp_loc_a101
(
    cid NVARCHAR(50),
    cntry NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


--=============================================================================
-- ERP PRODUCT CATEGORY
-- Stores product category, subcategory, and maintenance information
-- from the ERP system.
--=============================================================================

IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;

CREATE TABLE silver.erp_px_cat_g1v2
(
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
