-- CREATE SCHEMA [northwind]; -- run this line separately before everything else.

DROP TABLE [northwind].[DimCategory];
DROP TABLE [northwind].[DimSupplier];
DROP TABLE [northwind].[FactProduct];

CREATE TABLE [northwind].[FactProduct](
    [key] bigint, -- hash(product_id, "product")
    [product_id] bigint,
    [supplier_key] bigint, -- reference -> DimSupplier(key)
    [category_key] bigint, -- reference -> DimCategory(key)
    [times_ordered] int,
    [units_in_stock] int,
    [created_ts] datetime
)WITH(
     DISTRIBUTION = HASH (category_key),
    CLUSTERED COLUMNSTORE INDEX
    );


CREATE TABLE [northwind].[DimCategory](
    [key] bigint, -- hash of all columns of the source row
    [category_id] bigint,
    [category_name] nvarchar(100),
    created_ts datetime
    )WITH(
         DISTRIBUTION = HASH ([key]),
    CLUSTERED COLUMNSTORE INDEX ORDER ([key])
    )
;


CREATE TABLE [northwind].[DimSupplier](
    [key] bigint, -- hash of all columns of the source row
    [supplier_id] bigint,
    [company_name] nvarchar(100),
    [created_ts] datetime
    )WITH(
         DISTRIBUTION = REPLICATE,
         CLUSTERED COLUMNSTORE INDEX ORDER ([key])
    )
;


----------------------------------------------------


DROP TABLE [northwind].[DimEmployee];

DROP TABLE [northwind].[FactEmployeeMonthly];
DROP TABLE [northwind].[FactEmployee];
DROP TABLE [northwind].[FactSupervisor];


CREATE TABLE [northwind].[DimEmployee](
    [key] bigint UNIQUE NOT ENFORCED, -- hash(employee_id, "employee")
    [employee_id] int,
    [last_name] nvarchar (20) NOT NULL,
    [first_name] nvarchar (10) NOT NULL,
    [birth_date] datetime NULL,
    [hire_date] datetime NULL,
    [address] nvarchar (60) NULL ,
    [city] nvarchar (15) NULL ,
    [region] nvarchar (15) NULL ,
    [postal_code] nvarchar (10) NULL ,
    [country] nvarchar (15) NULL,
    [created_ts] datetime
    )WITH(
         DISTRIBUTION = HASH ([key]),
    CLUSTERED COLUMNSTORE INDEX ORDER ([key])
    )
;

CREATE INDEX name_index ON [northwind].[DimEmployee] ([last_name]);

CREATE TABLE [northwind].[FactEmployee](
    [key] bigint,
    [employee_key] bigint,
    [total_distinct_territories] int,
    [total_distinct_regions] int,
    [num_orders_affiliated] int,
    [num_products_affiliated] int,
    [created_ts] datetime
)WITH(
     DISTRIBUTION = HASH ([employee_key]),
    CLUSTERED COLUMNSTORE INDEX ORDER ([key])
    );

-- People who supervise at least one person.
CREATE TABLE [northwind].[FactSupervisor](
    [key] bigint,
    [employee_key] bigint, -- refers to the  records in the dim_employee table
    [num_employees_directly_supervised] int,
    [created_ts] datetime
)WITH(
     DISTRIBUTION = HASH ([employee_key]),
    CLUSTERED COLUMNSTORE INDEX ORDER ([key])
    )
;


CREATE TABLE [northwind].[FactEmployeeMonthly](
    [key] bigint, -- hash(employee_id, year, month)
    [employee_key] bigint, -- refers to the  records in the dim_employee table
    [year] int,
    [month] int,
    [total_products] int,
    [total_distinct_products] int,
    [total_orders] int,
    [created_ts] datetime
)WITH(
     DISTRIBUTION = HASH ([employee_key]),
    CLUSTERED COLUMNSTORE INDEX ORDER ([key])
    )
;


------------------------------------------


DROP TABLE [northwind].[FactCustomer];

CREATE TABLE [northwind].[FactCustomer](
    [key] bigint,
    [customer_id] nvarchar(100),
    [company_name] nvarchar(100),
    [contact_name] nvarchar(100),
    [contact_title] nvarchar(100),
    [address] nvarchar(100),
    [city] nvarchar(100),
    [region] nvarchar(100),
    [country] nvarchar(100),
    [phone] nvarchar(100),
    [fax] nvarchar(100),
    [total_orders] int,
    [total_raw_price] float,
    [total_discount] float,
    [average_discount] float,
    [created_ts] datetime
)WITH(
     DISTRIBUTION = ROUND_ROBIN,
    CLUSTERED COLUMNSTORE INDEX
    )
;

CREATE INDEX company_name_index     ON [northwind].[FactCustomer] ([company_name]);
CREATE INDEX contact_name_index     ON [northwind].[FactCustomer] ([contact_name]);
CREATE INDEX contact_title_index    ON [northwind].[FactCustomer] ([contact_title]);
