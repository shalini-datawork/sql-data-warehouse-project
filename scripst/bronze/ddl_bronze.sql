/*
===============================================================================
Purpose:
    Creates the Bronze layer tables for the Data Warehouse.

    These tables serve as the raw data ingestion layer and are designed to
    store data exactly as received from the source systems with no 
	transformation.

Source Systems:
    - CRM (Customer Relationship Management)
    - ERP (Enterprise Resource Planning)

WARNING:
    - This script is DESTRUCTIVE.
    - If any of the listed Bronze tables already exist, they will be dropped
      before being recreated.
    - All existing data in these tables will be permanently deleted.
    - Execute this script only when recreating the Bronze layer structure.

Prerequisites:
    - The 'DataWarehouse' database must already exist.
    - The 'bronze' schema must already be created.
===============================================================================
*/

--=============================================================================
-- CRM CUSTOMER INFORMATION
-- Stores raw customer master data from the CRM system.
--=============================================================================
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info
(
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE
);

--=============================================================================
-- CRM PRODUCT INFORMATION
-- Stores product master records from the CRM system.
--=============================================================================
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info
(
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
);

--=============================================================================
-- CRM SALES DETAILS
-- Stores transactional sales data from the CRM system.
--=============================================================================
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details
(
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

--=============================================================================
-- ERP CUSTOMER INFORMATION
-- Stores customer demographic data imported from the ERP system.
--=============================================================================
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12
(
    cid NVARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
);

--=============================================================================
-- ERP CUSTOMER LOCATION
-- Stores customer location information from the ERP system.
--=============================================================================
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101
(
    cid NVARCHAR(50),
    cntry NVARCHAR(50)
);

--=============================================================================
-- ERP PRODUCT CATEGORY
-- Stores product category and maintenance information from the ERP system.
--=============================================================================
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2
(
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50)
);
