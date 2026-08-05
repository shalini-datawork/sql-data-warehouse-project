/*
===============================================================================
Purpose:
    Creates a fresh DataWarehouse database by removing any existing database
    with the same name, then creates the Bronze, Silver, and Gold schemas
    used in a Medallion Architecture.

Warnings:
    - WARNING: This script permanently deletes the existing DataWarehouse
      database and all of its data.
    - WARNING: Any active connections to the database will be terminated
      using ROLLBACK IMMEDIATE.
    - Run this script only in development or test environments unless
      a complete database reset is intended.
===============================================================================
*/

USE master;
GO

-- Drop the existing DataWarehouse database (if present) to create a clean environment.
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-- Create a new Data Warehouse database.
CREATE DATABASE DataWarehouse;
GO

-- Switch context to the newly created database.
USE DataWarehouse;
GO

-- Create schemas representing the Medallion Architecture layers.
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
