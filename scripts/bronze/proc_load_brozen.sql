/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
CREATE OR ALTER PROCEDURE brozen.load_brozen AS
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
BEGIN TRY
    SET @batch_start_time = GETDATE();
	PRINT '===================================================';
	PRINT 'Loading Brozen Layer';
	PRINT '===================================================';

	PRINT '----------------------------------------';
	PRINT 'Loading CRM Data';
	PRINT '----------------------------------------';

	SET @start_time = GETDATE();
	PRINT'>> Truncating Table: brozen.crm_cust_info';
	TRUNCATE TABLE brozen.crm_cust_info;
	PRINT'>> Inserting Data Into: brozen.crm_cust_info';
	BULK INSERT brozen.crm_cust_info
	FROM 'C:\Users\NETRA\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>>----------------------';

	SET @start_time = GETDATE();
	TRUNCATE TABLE brozen.crm_prd_info;

	BULK INSERT brozen.crm_prd_info
	FROM 'C:\Users\NETRA\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>>----------------------';

	SET @start_time = GETDATE();
	TRUNCATE TABLE brozen.crm_sales_details;

	BULK INSERT brozen.crm_sales_details
	FROM 'C:\Users\NETRA\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>>----------------------';


	PRINT '----------------------------------------';
	PRINT 'Loading ERP Data';
	PRINT '----------------------------------------';

	SET @start_time = GETDATE();
	TRUNCATE TABLE brozen.erp_loc_a101;

	BULK INSERT brozen.erp_loc_a101
	FROM 'C:\Users\NETRA\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>>----------------------';

	SET @start_time = GETDATE();
	TRUNCATE TABLE brozen.erp_cust_az12;

	BULK INSERT brozen.erp_cust_az12
	FROM 'C:\Users\NETRA\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>>----------------------';

	SET @start_time = GETDATE();

	TRUNCATE TABLE brozen.erp_px_cat_g1v2;

	BULK INSERT brozen.erp_px_cat_g1v2
	FROM 'C:\Users\NETRA\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	PRINT '>>----------------------';

	SET @batch_end_time = GETDATE();

	END TRY
	BEGIN CATCH
	    PRINT '=====================================================================';
		PRINT 'ERROR OCCURED DURING LOADING BROZEN LAYER'
		PRINT 'Error Occurred: ' + ERROR_MESSAGE();
		PRINT 'ERROR Message' +  + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR Message' +  + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=====================================================================';
	END CATCH
END
