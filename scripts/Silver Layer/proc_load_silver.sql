
/* 
======================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
=======================================================

Script Purpose:
This stored procedure performs the ETL (Extract, Transform, Load) process to populate the 'silver' schema tables from the 'bronze' schema.
Actions Performed:
Truncates Silver tables.
Inserts transformed and cleansed data from Bronze into Silver tables.
Parameters:
None.
This stored procedure does not accept any parameters or return any values.
Usage Example:
EXEC Silver.load_silver;
===========================================================
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATEtime;
    BEGIN TRY
    SET @batch_start_time = GETDATE();

    PRINT '====================================================';
    PRINT 'Loading Silver Layer';
    PRINT '====================================================';

    PRINT ' -----------------------';
    PRINT 'Loading CRM Tables';
    PRINT '------------------------- ';

    -- Loading silver.crm_cust_info
    SET @start_time = GETDATE();
        print'>> Truncating Table: silver.crm_cust_info';
        truncate table silver.crm_cust_info;
        print '>> inserting data into : silver.crm_cust_info';
        insert into silver.crm_cust_info(
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_marital_status,
            cst_gndr,
            cst_create_date)

        select 
        cst_id,
        cst_key,
        trim(cst_firstname) as cst_firstname,
        trim(cst_lastname) as cst_lastname,
        case when upper(trim(cst_marital_status)) = 'S' then 'single'
             when upper(trim(cst_marital_status)) = 'M' then 'married'
             else 'n/a'
        end cst_marital_status,
        case when upper(trim(cst_gndr)) = 'F' then 'female'
             when upper(trim(cst_gndr)) = 'M' then 'male'
             else 'n/a'
        end cst_gndr,

        cst_create_date
        from (
        select
        *,
        row_number() over (partition by cst_id order by cst_create_date desc) as flag_last
        from bronze.crm_cust_info;
        where cst_id is not null
        ) t  
        where flag_last = 1;
        set @end_time = getdate();
        PRINT '>> load Duration: ' + CAST(DATEDIFF (SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
    PRINT '>> ............';


        --- 2nd loading silver.crm_prd_info

        set @start_time = getdate();
        print'>> Truncating Table:silver.crm_prd_info';
        truncate table silver.crm_prd_info;
        print '>> inserting data into : silver.crm_prd_info';
        insert into silver.crm_prd_info(
	        prd_id,
	        cat_id,
	        prd_key,
	        prd_nm,
	        prd_cost,
	        prd_line,
	        prd_start_dt,
	        prd_end_dt
        )
        SELECT
        prd_id,

        replace(substring (prd_key, 1, 5),'-','_') as cat_id, 
        substring (prd_key ,7,len(prd_key))as prd_key,
        prd_nm,
        isnull (prd_cost,0) as prd_cost,
        case  upper(trim(prd_line))
             when 'M' then 'Mountain'
	         when 'R' then 'Road'
	         when 'S' then 'Other Sales'
	         when 'T' then 'Touring'
	         else 'n/a'
        end as prd_line,

        cast(prd_start_dt as date) as prd_start_dt,
        cast (lead (prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as date )as prd_end_dt
        FROM bronze.crm_prd_info;
        set@end_time = getdate();
        PRINT '>> load Duration: ' + CAST(DATEDIFF (SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
    PRINT '>> ...................';

        -----3rd loading crm_sale_details
            set @start_time = getdate();
        print'>> Truncating Table: silver.crm_sale_details';
        truncate table silver.crm_sale_details;
        print '>> inserting data into : silver.crm_sale_details';
        insert into silver.crm_sale_details(
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
        )
        SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        case when sls_order_dt = 0 or len(sls_order_dt) !=8 then null
	        else cast(cast(sls_order_dt as varchar) as date)
        end as sls_order_dt,
        case when sls_ship_dt = 0 or len(sls_ship_dt) !=8 then null
	        else cast(cast(sls_ship_dt as varchar) as date)
        end as sls_ship_dt,
        case when sls_due_dt = 0 or len(sls_due_dt) !=8 then null
	        else cast(cast(sls_due_dt as varchar) as date)
        end as sls_due_dt,

        CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
                THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END AS sls_sales,
        sls_quantity,
        CASE WHEN sls_price IS NULL or sls_price <= 0 
                THEN sls_sales /nullif (sls_quantity,0)
                ELSE sls_price
            end as sls_price
        FROM bronze.crm_sale_details;
        seet @end_time = getdate();
        PRINT '>>load Duration: ' + CAST(DATEDIFF (SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
    PRINT '>> ............';
        -----4th loading erp_cust_az12

        set @start_time = getdate();
        print'>> Truncating Table: silver.erp_cust_az12';
        truncate table silver.erp_cust_az12;
        print '>> inserting data into : silver.erp_cust_az12';
        insert into silver.erp_cust_az12(cid, bdate,gen)

        select
        case when cid like 'NAS%' then substring (cid, 4,len(cid))
	        else cid
        end as cid,
        case when bdate > getdate() then null
	        else bdate
        end as bdate,

        case when upper(trim(gen)) in ('F', 'Female') then 'Female'
             when upper(trim(gen)) in ('M', 'Male') then 'Male'
             else 'n/a'
        end as gen
        from bronze.erp_cust_az12;
        set @end_time = getdate();
        PRINT '>> load Duration: ' + CAST(DATEDIFF (SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
    PRINT '>> ............';

    print'-------------------------------------------';
    print 'Loading ERP Tables';
    print '------------------------------------------';

        --- 5th   loading erp_loc_a101
         set @start_time = getdate();
        print'>> Truncating Table: silver.erp_loc_a101 ';
        truncate table silver.erp_loc_a101 ;
        print '>> inserting data into : silver.erp_loc_a101 ';
        INSERT INTO silver.erp_loc_a101 (cid, cntry)
        SELECT
            REPLACE(cid, '-', '') AS cid,
            CASE 
                WHEN TRIM(cntry) = 'de' THEN 'germany'
                WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
                WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
                ELSE TRIM(cntry)
            END AS cntry
        FROM bronze.erp_loc_a101;
        ----6th
        set @start_time = getdate();
        print'>> Truncating Table: silver.erp_px_cat_g1v2';
        truncate table silver.erp_px_cat_g1v2;
        print '>> inserting data into : silver.erp_px_cat_g1v2';
        insert into silver.erp_px_cat_g1v2(id,cat,subcat,maintenance)

        select 
        id,
        cat,
        subcat,
        maintenance
        from bronze.erp_px_cat_g1v2  ;
        PRINT '>> LOAD Duration: ' + CAST(DATEDIFF (SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
    PRINT '>> ............';

    set @batch_end_time = getdate();
    print '============================================='
    print 'Loading Silver layer is completed';
    print '  -Total load Duration : ' + cast(datediff,(@batch_start_time,@batch_end_time) AS nvarchar) + 'seconds';
    print '---------------------------------------'
end try
BEGIN CATCH
    PRINT '----------------------------------------------------------------------------------------------------------------------'
    PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
    PRINT 'Error Message' + ERROR_MESSAGE();
    PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
    PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
    PRINT '----------------------------------------------------------------------------------------------------------------------'
END CATCH
End
