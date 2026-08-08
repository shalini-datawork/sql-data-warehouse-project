/*
===============================================================================
Stored Procedure: bronze.load_bronze

Purpose:
    Loads raw data from CSV files into the Bronze layer tables of the Data
    Warehouse using SQL Server BULK INSERT.

    The procedure follows a full-refresh approach:
        1. Truncates each Bronze table.
        2. Loads the latest data from the corresponding source file.
        3. Records and displays the load duration for each table.
        4. Displays the total execution time for the entire Bronze load process.

Source Systems:
    - CRM
    - ERP

WARNING:
    - This procedure performs a FULL REFRESH of all Bronze tables.
    - Existing data in the Bronze layer will be permanently removed before
      loading new data.
    - Ensure the CSV files exist at the specified file paths.
    - SQL Server service account must have read permissions on the source files.
    - BULK INSERT requires the SQL Server instance to access the file location,
      not just the client machine.

Prerequisites:
    - Bronze tables must already exist.
    - Source CSV files must be available.
    - Appropriate BULK INSERT permissions are required.

Usage Example:
    EXEC bronze.load_bronze;

===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN

    -- Variables used to measure load duration for individual tables
    -- and the overall Bronze load process.
    DECLARE
        @start_time DATETIME,
        @end_time DATETIME,
        @wb_start_time DATETIME,
        @wb_end_time DATETIME;

    BEGIN TRY

        SET @wb_start_time = GETDATE();

        PRINT '=========================================';
        PRINT 'Loading Bronze Layer';
        PRINT '=========================================';

        --=========================================================
        -- Load CRM Source Tables
        --=========================================================

        PRINT '-----------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '-----------------------------------------';

        ------------------------------------------------------------------------
        -- CRM Customer Information
        ------------------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Inserting Data Into: bronze.crm_cust_info';

        BULK INSERT bronze.crm_cust_info
        FROM 'E:\sql-ultimate-course-main\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH
        (
            FIRSTROW = 2,          -- Skip header row
            FIELDTERMINATOR = ',',
            TABLOCK               -- Improve bulk load performance
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -------------';

        ------------------------------------------------------------------------
        -- CRM Product Information
        ------------------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Data Into: bronze.crm_prd_info';

        BULK INSERT bronze.crm_prd_info
        FROM 'E:\sql-ultimate-course-main\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -------------';

        ------------------------------------------------------------------------
        -- CRM Sales Details
        ------------------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data Into: bronze.crm_sales_details';

        BULK INSERT bronze.crm_sales_details
        FROM 'E:\sql-ultimate-course-main\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -------------';

        --=========================================================
        -- Load ERP Source Tables
        --=========================================================

        PRINT '-----------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '-----------------------------------------';

        ------------------------------------------------------------------------
        -- ERP Customer Information
        ------------------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting Data Into: bronze.erp_cust_az12';

        BULK INSERT bronze.erp_cust_az12
        FROM 'E:\sql-ultimate-course-main\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -------------';

        ------------------------------------------------------------------------
        -- ERP Customer Location
        ------------------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting Data Into: bronze.erp_loc_a101';

        BULK INSERT bronze.erp_loc_a101
        FROM 'E:\sql-ultimate-course-main\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -------------';

        ------------------------------------------------------------------------
        -- ERP Product Categories
        ------------------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'E:\sql-ultimate-course-main\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '>> -------------';

        -- Record total workflow duration.
        SET @wb_end_time = GETDATE();

        PRINT '=========================================';
        PRINT 'Loading Bronze Layer Completed';
        PRINT 'Total Load Duration: '
            + CAST(DATEDIFF(SECOND, @wb_start_time, @wb_end_time) AS NVARCHAR)
            + ' seconds';
        PRINT '=========================================';

    END TRY

    BEGIN CATCH

        -- Display error information if the load process fails.
        PRINT '=========================================';
        PRINT 'ERROR OCCURRED DURING BRONZE LAYER LOAD';
        PRINT 'Error Message : ' + ERROR_MESSAGE();
        PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State   : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=========================================';

    END CATCH

END;
