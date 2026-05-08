-- cust_info table cleaned
create view cust_info_view as
select 
	cst_id,
	cst_key,
	trim(cst_firstname) as cst_firstname,
	trim(cst_lastname) as cst_lastname,
	case 
		when cst_marital_status = 'M' then 'Married'
		when cst_marital_status = 'S' then 'Single'
		else 'n/a'
	end as cst_marital_status,
	case 
		when upper(cst_gndr) = 'M' then 'Male'
		when upper(cst_gndr) = 'F' then 'Female'
		else 'n/a'
	end as cst_gndr,
	cst_create_date
from (
	select
		*,
		row_number() over (partition by cst_id order by cst_create_date desc) as row_no
	from crm.cust_info
	where cst_id is not null
) t
where row_no = 1;

-- prd_info table cleaning
select 
	prd_id,
	replace(substring(prd_key, 1, 5), '-', '_') as cat_id,
	substring(prd_key, 7, length(prd_key)) as prd_key,
	prd_nm,
	coalesce(prd_cost, 0) as prd_cost,
	case
		when upper(trim(prd_line)) = 'M' then 'Mountain'
		when upper(trim(prd_line)) = 'R' then 'Road'
		when upper(trim(prd_line)) = 'S' then 'Other Sales'
		when upper(trim(prd_line)) = 'T' then 'Touring'
		else 'n/a'
	end as prd_line,
	prd_start_dt,
	lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as prd_end_dt
from crm.prd_info;


-- sales detail table cleaning
select
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	case 
		when sls_order_dt= 0 or length(cast(sls_order_dt as varchar)) != 8 then null
		else cast(cast(sls_order_dt as varchar) as date)
	end as sls_order_dt,
	case 
		when sls_ship_dt= 0 or length(cast(sls_ship_dt as varchar)) != 8 then null
		else cast(cast(sls_ship_dt as varchar) as date)
	end as sls_ship_dt,
	case 
		when sls_due_dt= 0 or length(cast(sls_due_dt as varchar)) != 8 then null
		else cast(cast(sls_due_dt as varchar) as date)
	end as sls_due_dt,
	case
		when sls_sales is null or sls_sales <= 0 or sls_sales != (sls_quantity * ABS(sls_price))
			then sls_quantity * ABS(sls_price)
		else sls_sales
	end as sls_sales,
	sls_quantity,
	case 
		when sls_price is null or sls_price <= 0 
			then sls_sales / coalesce(sls_quantity, 0)
		else sls_price  -- Derive price if original value is invalid
	end as sls_price
from crm.sales_details;
	
create schema ccrm;

create table ccrm.sales_details as
select
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	case 
		when sls_order_dt= 0 or length(cast(sls_order_dt as varchar)) != 8 then null
		else cast(cast(sls_order_dt as varchar) as date)
	end as sls_order_dt,
	case 
		when sls_ship_dt= 0 or length(cast(sls_ship_dt as varchar)) != 8 then null
		else cast(cast(sls_ship_dt as varchar) as date)
	end as sls_ship_dt,
	case 
		when sls_due_dt= 0 or length(cast(sls_due_dt as varchar)) != 8 then null
		else cast(cast(sls_due_dt as varchar) as date)
	end as sls_due_dt,
	case
		when sls_sales is null or sls_sales <= 0 or sls_sales != (sls_quantity * ABS(sls_price))
			then sls_quantity * ABS(sls_price)
		else sls_sales
	end as sls_sales,
	sls_quantity,
	case 
		when sls_price is null or sls_price <= 0 
			then sls_sales / coalesce(sls_quantity, 0)
		else sls_price  -- Derive price if original value is invalid
	end as sls_price
from crm.sales_details;


create table ccrm.cust_info as 
select 
	cst_id,
	cst_key,
	trim(cst_firstname) as cst_firstname,
	trim(cst_lastname) as cst_lastname,
	case 
		when cst_marital_status = 'M' then 'Married'
		when cst_marital_status = 'S' then 'Single'
		else 'n/a'
	end as cst_marital_status,
	case 
		when upper(cst_gndr) = 'M' then 'Male'
		when upper(cst_gndr) = 'F' then 'Female'
		else 'n/a'
	end as cst_gndr,
	cst_create_date
from (
	select
		*,
		row_number() over (partition by cst_id order by cst_create_date desc) as row_no
	from crm.cust_info
	where cst_id is not null
) t
where row_no = 1;



create view crm.cust_info_view as 
select 
	cst_id,
	cst_key,
	trim(cst_firstname) as cst_firstname,
	trim(cst_lastname) as cst_lastname,
	case 
		when cst_marital_status = 'M' then 'Married'
		when cst_marital_status = 'S' then 'Single'
		else 'n/a'
	end as cst_marital_status,
	case 
		when upper(cst_gndr) = 'M' then 'Male'
		when upper(cst_gndr) = 'F' then 'Female'
		else 'n/a'
	end as cst_gndr,
	cst_create_date
from (
	select
		*,
		row_number() over (partition by cst_id order by cst_create_date desc) as row_no
	from crm.cust_info
	where cst_id is not null
) t
where row_no = 1;



















